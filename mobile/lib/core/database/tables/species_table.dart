import 'package:drift/drift.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// DRIFT TABLE — Cached Species
/// ─────────────────────────────────────────────────────────────────────────────

@DataClassName('CachedSpeciesRow')
class CachedSpeciesTable extends Table {
  @override
  String get tableName => 'cached_species';

  TextColumn get id => text()();
  TextColumn get commonName => text()();
  TextColumn get scientificName => text()();
  TextColumn get family => text().nullable()();
  TextColumn get subfamily => text().nullable()();
  TextColumn get primaryImageUrl => text().nullable()();
  TextColumn get rarity => text().nullable()();
  TextColumn get conservationStatus => text().nullable()();
  TextColumn get descriptionShort => text().nullable()();
  TextColumn get statesJson => text().nullable()(); // JSON array of state names
  BoolColumn get isBookmarked => boolean().withDefault(const Constant(false))();
  IntColumn get observationCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// ── User Preferences / Settings ───────────────────────────────────────────────

@DataClassName('UserPreferenceRow')
class UserPreferencesTable extends Table {
  @override
  String get tableName => 'user_preferences';

  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {key};
}

// ── Bookmarks ─────────────────────────────────────────────────────────────────

@DataClassName('BookmarkRow')
class BookmarksTable extends Table {
  @override
  String get tableName => 'bookmarks';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()(); // 'species' | 'observation'
  TextColumn get refId => text()();
  TextColumn get dataJson => text().nullable()(); // Serialized preview data
  DateTimeColumn get savedAt => dateTime().withDefault(currentDateAndTime)();
}
