import 'package:drift/drift.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// DRIFT TABLE — Cached Observations
/// ─────────────────────────────────────────────────────────────────────────────

@DataClassName('CachedObservationRow')
class CachedObservationsTable extends Table {
  @override
  String get tableName => 'cached_observations';

  TextColumn get id => text()();
  TextColumn get userId => text().nullable()();
  TextColumn get title => text().nullable()();
  TextColumn get notes => text().nullable()();
  IntColumn get stateId => integer().nullable()();
  TextColumn get stateName => text().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  TextColumn get locationName => text().nullable()();
  TextColumn get privacy => text().withDefault(const Constant('public'))();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get identificationStatus => text().nullable()();
  TextColumn get identifiedSpeciesId => text().nullable()();
  TextColumn get identifiedSpeciesName => text().nullable()();
  RealColumn get identificationConfidence => real().nullable()();
  TextColumn get primaryImageUrl => text().nullable()();
  TextColumn get imageUrlsJson => text().nullable()(); // JSON array
  DateTimeColumn get observedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(true))();
  IntColumn get likeCount => integer().withDefault(const Constant(0))();
  IntColumn get commentCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

// ── Offline Queue ─────────────────────────────────────────────────────────────

@DataClassName('OfflineQueueRow')
class OfflineQueueTable extends Table {
  @override
  String get tableName => 'offline_queue';

  IntColumn get localId => integer().autoIncrement()();
  TextColumn get type => text()(); // 'observation', 'identification', etc.
  TextColumn get payload => text()(); // JSON-serialized body
  TextColumn get endpoint => text()();
  TextColumn get httpMethod => text().withDefault(const Constant('POST'))();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  IntColumn get maxRetries => integer().withDefault(const Constant(5))();
  BoolColumn get hasImages => boolean().withDefault(const Constant(false))();
  TextColumn get localImagePaths => text().nullable()(); // JSON array of local paths
  TextColumn get status => text().withDefault(const Constant('pending'))();
  // pending / processing / failed / succeeded
  TextColumn get errorMessage => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();
}
