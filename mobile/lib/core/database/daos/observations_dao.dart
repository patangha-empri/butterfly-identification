import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/observations_table.dart';

part 'observations_dao.g.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// OBSERVATIONS DAO
/// All database operations for cached observations and offline queue.
/// ─────────────────────────────────────────────────────────────────────────────

@DriftAccessor(tables: [CachedObservationsTable, OfflineQueueTable])
class ObservationsDao extends DatabaseAccessor<AppDatabase>
    with _$ObservationsDaoMixin {
  ObservationsDao(super.db);

  // ── Cached Observations ───────────────────────────────────────────────────

  Future<List<CachedObservationRow>> getAll({int limit = 50, int offset = 0}) =>
      (select(cachedObservationsTable)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(limit, offset: offset))
          .get();

  Future<CachedObservationRow?> getById(String id) =>
      (select(cachedObservationsTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Stream<List<CachedObservationRow>> watchAll({int limit = 50}) =>
      (select(cachedObservationsTable)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(limit))
          .watch();

  Future<void> upsert(CachedObservationsTableCompanion entry) =>
      into(cachedObservationsTable).insertOnConflictUpdate(entry);

  Future<void> upsertAll(List<CachedObservationsTableCompanion> entries) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(cachedObservationsTable, entries);
    });
  }

  Future<int> deleteById(String id) =>
      (delete(cachedObservationsTable)..where((t) => t.id.equals(id)))
          .go();

  Future<int> deleteAllObservations() =>
      delete(cachedObservationsTable).go();

  Future<int> deleteOlderThan(DateTime cutoff) =>
      (delete(cachedObservationsTable)
            ..where((t) => t.cachedAt.isSmallerThanValue(cutoff)))
          .go();

  // ── Offline Queue ─────────────────────────────────────────────────────────

  Future<List<OfflineQueueRow>> getPendingQueue() =>
      (select(offlineQueueTable)
            ..where((t) => t.status.equals('pending'))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

  Stream<List<OfflineQueueRow>> watchPendingQueue() =>
      (select(offlineQueueTable)
            ..where((t) => t.status.equals('pending')))
          .watch();

  Future<int> addToQueue(OfflineQueueTableCompanion entry) =>
      into(offlineQueueTable).insert(entry);

  Future<void> markProcessing(int localId) =>
      (update(offlineQueueTable)..where((t) => t.localId.equals(localId)))
          .write(const OfflineQueueTableCompanion(status: Value('processing')));

  Future<void> markSucceeded(int localId) =>
      (update(offlineQueueTable)..where((t) => t.localId.equals(localId)))
          .write(const OfflineQueueTableCompanion(status: Value('succeeded')));

  Future<void> markFailed(int localId, String errorMessage) =>
      (update(offlineQueueTable)..where((t) => t.localId.equals(localId))).write(
        OfflineQueueTableCompanion(
          status: const Value('failed'),
          errorMessage: Value(errorMessage),
          lastAttemptAt: Value(DateTime.now()),
        ),
      );

  Future<void> incrementRetry(int localId) async {
    final row = await (select(offlineQueueTable)
          ..where((t) => t.localId.equals(localId)))
        .getSingleOrNull();
    if (row == null) return;

    final newCount = row.retryCount + 1;
    final newStatus = newCount >= row.maxRetries ? 'failed' : 'pending';

    await (update(offlineQueueTable)..where((t) => t.localId.equals(localId)))
        .write(OfflineQueueTableCompanion(
      retryCount: Value(newCount),
      status: Value(newStatus),
      lastAttemptAt: Value(DateTime.now()),
    ));
  }

  Future<int> clearSucceeded() =>
      (delete(offlineQueueTable)..where((t) => t.status.equals('succeeded')))
          .go();

  /// Recovers rows left in 'processing' by a sync that was interrupted
  /// (app killed / crashed mid-upload) so they get picked up on the next drain.
  Future<int> resetProcessingToPending() =>
      (update(offlineQueueTable)..where((t) => t.status.equals('processing')))
          .write(const OfflineQueueTableCompanion(status: Value('pending')));

  Future<int> getPendingCount() async {
    final countExpr = offlineQueueTable.localId.count();
    final query = selectOnly(offlineQueueTable)
      ..where(offlineQueueTable.status.equals('pending'))
      ..addColumns([countExpr]);
    final result = await query.getSingle();
    return result.read(countExpr) ?? 0;
  }
}
