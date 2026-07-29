import 'package:dartz/dartz.dart';
import 'package:butterfly_india/core/errors/failure.dart';
import 'package:butterfly_india/features/home/data/models/observation_summary.dart';
import 'package:butterfly_india/features/observations/data/models/observation.dart';
import 'package:butterfly_india/features/observations/data/models/observation_draft.dart';
import 'package:butterfly_india/features/observations/data/repositories/observation_repository.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// FAKE OBSERVATION REPOSITORY — for sync-controller tests.
/// Tracks the pending count and how many times the queue was drained.
/// ─────────────────────────────────────────────────────────────────────────────

class FakeObservationRepository implements IObservationRepository {
  FakeObservationRepository({this.pending = 0, this.failSync = false});

  int pending;
  bool failSync;
  int syncCalls = 0;

  @override
  Future<int> pendingQueueCount() async => pending;

  @override
  Future<void> syncPending() async {
    syncCalls++;
    if (failSync) throw Exception('sync failed');
    pending = 0; // drains everything
  }

  @override
  Future<Either<Failure, Observation>> getDetail(String id) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, List<ObservationSummary>>> listMine({int page = 1}) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, SubmitOutcome>> submit(
    ObservationDraft draft, {
    SubmitProgress? onProgress,
  }) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, Observation>> updatePrivacy(String id, String privacy) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, Observation>> setSpecies(String id, String speciesId) =>
      throw UnimplementedError();

  @override
  Future<void> discard(String id) async {}
}
