import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart' show Value;
import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/observations_dao.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/utils/image_helper.dart';
import '../../../ai_identification/data/models/ai_result.dart';
import '../../../home/data/models/observation_summary.dart';
import '../datasources/observation_remote_datasource.dart';
import '../models/observation.dart';
import '../models/observation_draft.dart';

/// Outcome of a submit attempt.
sealed class SubmitOutcome {
  const SubmitOutcome();
}

class SubmitSuccess extends SubmitOutcome {
  const SubmitSuccess(this.observation, {this.aiResult});
  final Observation observation;

  /// Completed Gemini identification (null when no photos were attached or
  /// the AI call failed — identification is best-effort in that case).
  final AiResult? aiResult;
}

/// Saved to the offline queue; will sync when back online.
class SubmitQueued extends SubmitOutcome {
  const SubmitQueued();
}

/// The AI positively found no butterfly in the photos — the sighting was
/// removed server-side and must not appear anywhere.
class SubmitRejected extends SubmitOutcome {
  const SubmitRejected(this.reason);
  final String reason;
}

/// Reports progress through the multi-step submit pipeline.
typedef SubmitProgress = void Function(SubmitStage stage, double fraction);

enum SubmitStage { compressing, creating, uploading, identifying, done }

/// ─────────────────────────────────────────────────────────────────────────────
/// OBSERVATION REPOSITORY
/// ─────────────────────────────────────────────────────────────────────────────

abstract class IObservationRepository {
  Future<Either<Failure, SubmitOutcome>> submit(
    ObservationDraft draft, {
    SubmitProgress? onProgress,
  });
  Future<Either<Failure, Observation>> getDetail(String id);
  Future<Either<Failure, List<ObservationSummary>>> listMine({int page});
  Future<int> pendingQueueCount();
  Future<void> syncPending();
  Future<Either<Failure, Observation>> updatePrivacy(String id, String privacy);

  /// Owner manually names the species (e.g. after AI found a butterfly but
  /// no confident match). Verification stays pending on the backend.
  Future<Either<Failure, Observation>> setSpecies(String id, String speciesId);

  /// Best-effort removal of a sighting the user chose not to keep.
  Future<void> discard(String id);
}

class ObservationRepository implements IObservationRepository {
  ObservationRepository({
    required IObservationRemoteDataSource remote,
    required ObservationsDao dao,
    required IConnectivityService connectivity,
  })  : _remote = remote,
        _dao = dao,
        _connectivity = connectivity;

  final IObservationRemoteDataSource _remote;
  final ObservationsDao _dao;
  final IConnectivityService _connectivity;

  @override
  Future<Either<Failure, SubmitOutcome>> submit(
    ObservationDraft draft, {
    SubmitProgress? onProgress,
  }) async {
    if (!draft.isValid) {
      return const Left(ValidationFailure(
        message: 'Please select a state for your sighting.',
        fieldErrors: {'state_id': ['Required']},
      ));
    }

    // 1. Compress images up front (works offline too).
    onProgress?.call(SubmitStage.compressing, 0);
    final compressed = await ImageHelper.compressAll(draft.images);

    // 2. Offline → enqueue and bail early.
    if (!_connectivity.isOnline) {
      await _enqueue(draft, compressed);
      onProgress?.call(SubmitStage.done, 1);
      return const Right(SubmitQueued());
    }

    try {
      // 3. Create the observation.
      onProgress?.call(SubmitStage.creating, 0.1);
      final obs = await _remote.create(draft.toCreateJson());

      // 4. Upload images sequentially (one per request).
      for (var i = 0; i < compressed.length; i++) {
        onProgress?.call(
          SubmitStage.uploading,
          0.2 + (0.6 * (i / (compressed.length == 0 ? 1 : compressed.length))),
        );
        await _remote.uploadImage(obs.id, compressed[i]);
      }

      // 5. AI identification. Blocking gate: when Gemini positively finds no
      // butterfly in the photos, the sighting is deleted and rejected so
      // non-butterfly images never end up in the feed. If the AI itself is
      // unreachable/fails, submission still goes through (best-effort).
      AiResult? aiResult;
      if (compressed.isNotEmpty) {
        onProgress?.call(SubmitStage.identifying, 0.9);
        try {
          aiResult = await _remote.triggerIdentify(obs.id);
        } catch (_) {/* AI unavailable — don't block the submission */}

        if (aiResult != null && _isConfirmedNonButterfly(aiResult)) {
          try {
            await _remote.delete(obs.id);
          } catch (_) {/* best-effort cleanup */}
          onProgress?.call(SubmitStage.done, 1);
          return const Right(SubmitRejected(
            'No butterfly was found in your photo. Only butterfly sightings '
            'can be submitted — please retake the photo with the butterfly '
            'clearly visible.',
          ));
        }
      }

      onProgress?.call(SubmitStage.done, 1);
      return Right(SubmitSuccess(obs, aiResult: aiResult));
    } on AppException catch (e) {
      // Network dropped mid-flight → queue for later.
      if (e is NetworkException || e is TimeoutException) {
        await _enqueue(draft, compressed);
        return const Right(SubmitQueued());
      }
      return Left(e.toFailure());
    } catch (e) {
      return Left(ExceptionMapper.fromObject(e).toFailure());
    }
  }

  /// True only when the AI ran to completion and positively determined the
  /// image contains no butterfly. A butterfly that merely couldn't be
  /// identified to species level (poor photo quality) is NOT rejected, and
  /// neither is a failed/unreachable AI run.
  static bool _isConfirmedNonButterfly(AiResult result) {
    if (!result.isCompleted || result.matches.isNotEmpty) return false;
    return result.detection?['contains_butterfly'] != true;
  }

  @override
  Future<Either<Failure, Observation>> getDetail(String id) async {
    try {
      return Right(await _remote.getDetail(id));
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(ExceptionMapper.fromObject(e).toFailure());
    }
  }

  @override
  Future<Either<Failure, List<ObservationSummary>>> listMine({
    int page = 1,
  }) async {
    try {
      return Right(await _remote.listMine(page: page));
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(ExceptionMapper.fromObject(e).toFailure());
    }
  }

  @override
  Future<int> pendingQueueCount() => _dao.getPendingCount();

  /// Drains the offline queue when connectivity is available.
  ///
  /// Robustness:
  ///  - recovers rows stuck in 'processing' from an interrupted run,
  ///  - treats failures as retryable (via [ObservationsDao.incrementRetry]) so a
  ///    transient network drop doesn't permanently discard a queued sighting;
  ///    only after `maxRetries` does a row become 'failed'.
  @override
  Future<void> syncPending() async {
    if (!_connectivity.isOnline) return;

    // Re-queue anything a previous (crashed) drain left mid-flight.
    await _dao.resetProcessingToPending();

    final pending = await _dao.getPendingQueue();
    for (final row in pending) {
      try {
        await _dao.markProcessing(row.localId);
        final payload = jsonDecode(row.payload) as Map<String, dynamic>;
        final paths =
            (jsonDecode(row.localImagePaths ?? '[]') as List).cast<String>();

        final obs = await _remote.create(payload);
        for (final path in paths) {
          final file = File(path);
          if (file.existsSync()) await _remote.uploadImage(obs.id, file);
        }
        try {
          final aiResult = await _remote.triggerIdentify(obs.id);
          // Same butterfly-only gate as online submits: silently drop
          // queued sightings the AI confirms contain no butterfly.
          if (paths.isNotEmpty && _isConfirmedNonButterfly(aiResult)) {
            try {
              await _remote.delete(obs.id);
            } catch (_) {}
          }
        } catch (_) {}
        await _dao.markSucceeded(row.localId);
      } catch (_) {
        // Retryable: incrementRetry resets to 'pending' until maxRetries,
        // after which the row is marked 'failed'.
        await _dao.incrementRetry(row.localId);
      }
    }
    await _dao.clearSucceeded();
  }

  // ── Offline queue ────────────────────────────────────────────────────────

  Future<void> _enqueue(ObservationDraft draft, List<File> images) async {
    await _dao.addToQueue(
      OfflineQueueTableCompanion(
        type: const Value('observation'),
        endpoint: const Value('/api/v1/observations/'),
        httpMethod: const Value('POST'),
        payload: Value(jsonEncode(draft.toCreateJson())),
        hasImages: Value(images.isNotEmpty),
        localImagePaths:
            Value(jsonEncode(images.map((f) => f.path).toList())),
        status: const Value('pending'),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<Either<Failure, Observation>> updatePrivacy(
    String id,
    String privacy,
  ) async {
    try {
      final obs = await _remote.updatePrivacy(id, privacy);
      return Right(obs);
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(ExceptionMapper.fromObject(e).toFailure());
    }
  }

  @override
  Future<Either<Failure, Observation>> setSpecies(
    String id,
    String speciesId,
  ) async {
    try {
      final obs = await _remote.update(id, {'species_id': speciesId});
      return Right(obs);
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(ExceptionMapper.fromObject(e).toFailure());
    }
  }

  @override
  Future<void> discard(String id) async {
    try {
      await _remote.delete(id);
    } catch (_) {
      // Best-effort — an orphaned private sighting is harmless.
    }
  }
}
