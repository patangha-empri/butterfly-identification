import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../ai_identification/data/models/ai_result.dart';
import '../../../home/data/models/observation_summary.dart';
import '../../data/datasources/observation_remote_datasource.dart';
import '../../data/models/observation.dart';
import '../../data/models/observation_draft.dart';
import '../../data/repositories/observation_repository.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// OBSERVATION PROVIDERS
/// ─────────────────────────────────────────────────────────────────────────────

final observationRemoteDataSourceProvider =
    Provider<IObservationRemoteDataSource>(
  (ref) => ObservationRemoteDataSource(dio: ref.read(dioProvider)),
  name: 'observationRemoteDataSource',
);

final observationRepositoryProvider = Provider<IObservationRepository>(
  (ref) => ObservationRepository(
    remote: ref.read(observationRemoteDataSourceProvider),
    dao: ref.read(appDatabaseProvider).observationsDao,
    connectivity: ref.read(connectivityServiceProvider),
  ),
  name: 'observationRepository',
);

/// Full detail for a single observation.
final observationDetailProvider =
    FutureProvider.autoDispose.family<Observation, String>(
  (ref, id) async {
    final result = await ref.read(observationRepositoryProvider).getDetail(id);
    return result.fold((f) => throw ObservationException(f.message), (o) => o);
  },
  name: 'observationDetail',
);

/// The current user's sightings (first page).
final myObservationsProvider =
    FutureProvider.autoDispose<List<ObservationSummary>>(
  (ref) async {
    final result = await ref.read(observationRepositoryProvider).listMine();
    return result.fold(
      (f) => throw ObservationException(f.message),
      (list) => list,
    );
  },
  name: 'myObservations',
);

/// Count of sightings waiting in the offline queue.
final pendingQueueCountProvider = FutureProvider.autoDispose<int>(
  (ref) => ref.read(observationRepositoryProvider).pendingQueueCount(),
  name: 'pendingQueueCount',
);

// ── Submit notifier ──────────────────────────────────────────────────────────

enum SubmitStatus { idle, submitting, success, queued, rejected, error }

class SubmitState {
  const SubmitState({
    this.status = SubmitStatus.idle,
    this.stage,
    this.progress = 0,
    this.observation,
    this.aiResult,
    this.error,
    this.fieldErrors = const {},
  });

  final SubmitStatus status;
  final SubmitStage? stage;
  final double progress;
  final Observation? observation;

  /// Completed AI identification for the submitted photos (when available).
  final AiResult? aiResult;
  final String? error;
  final Map<String, String> fieldErrors;

  bool get isSubmitting => status == SubmitStatus.submitting;

  SubmitState copyWith({
    SubmitStatus? status,
    SubmitStage? stage,
    double? progress,
    Observation? observation,
    AiResult? aiResult,
    String? error,
    Map<String, String>? fieldErrors,
  }) =>
      SubmitState(
        status: status ?? this.status,
        stage: stage ?? this.stage,
        progress: progress ?? this.progress,
        observation: observation ?? this.observation,
        aiResult: aiResult ?? this.aiResult,
        error: error,
        fieldErrors: fieldErrors ?? this.fieldErrors,
      );
}

class SubmitNotifier extends StateNotifier<SubmitState> {
  SubmitNotifier(this._repository) : super(const SubmitState());

  final IObservationRepository _repository;

  Future<void> submit(ObservationDraft draft) async {
    state = const SubmitState(status: SubmitStatus.submitting, progress: 0);

    final result = await _repository.submit(
      draft,
      onProgress: (stage, fraction) {
        state = state.copyWith(
          status: SubmitStatus.submitting,
          stage: stage,
          progress: fraction,
        );
      },
    );

    state = result.fold(
      (failure) {
        final fieldErrors = <String, String>{};
        if (failure is ValidationFailure) {
          failure.fieldErrors.forEach((k, v) {
            if (v.isNotEmpty) fieldErrors[k] = v.first;
          });
        }
        return SubmitState(
          status: SubmitStatus.error,
          error: failure.message,
          fieldErrors: fieldErrors,
        );
      },
      (outcome) => switch (outcome) {
        SubmitSuccess(:final observation, :final aiResult) => SubmitState(
            status: SubmitStatus.success,
            observation: observation,
            aiResult: aiResult,
          ),
        SubmitQueued() => const SubmitState(status: SubmitStatus.queued),
        SubmitRejected(:final reason) => SubmitState(
            status: SubmitStatus.rejected,
            error: reason,
          ),
      },
    );
  }

  void reset() => state = const SubmitState();
}

final submitNotifierProvider =
    StateNotifierProvider.autoDispose<SubmitNotifier, SubmitState>(
  (ref) => SubmitNotifier(ref.read(observationRepositoryProvider)),
  name: 'submitNotifier',
);

class ObservationException implements Exception {
  ObservationException(this.message);
  final String message;
  @override
  String toString() => message;
}
