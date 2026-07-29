import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/species_table.dart';

part 'species_dao.g.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// SPECIES DAO
/// ─────────────────────────────────────────────────────────────────────────────

@DriftAccessor(tables: [CachedSpeciesTable, UserPreferencesTable, BookmarksTable])
class SpeciesDao extends DatabaseAccessor<AppDatabase>
    with _$SpeciesDaoMixin {
  SpeciesDao(super.db);

  // ── Species Cache ─────────────────────────────────────────────────────────

  Future<List<CachedSpeciesRow>> getAll({int limit = 100, int offset = 0}) =>
      (select(cachedSpeciesTable)
            ..orderBy([(t) => OrderingTerm.asc(t.commonName)])
            ..limit(limit, offset: offset))
          .get();

  Future<CachedSpeciesRow?> getById(String id) =>
      (select(cachedSpeciesTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<List<CachedSpeciesRow>> search(String query) =>
      (select(cachedSpeciesTable)
            ..where(
              (t) => t.commonName.like('%$query%') |
                  t.scientificName.like('%$query%'),
            )
            ..limit(20))
          .get();

  Future<List<CachedSpeciesRow>> getBookmarked() =>
      (select(cachedSpeciesTable)
            ..where((t) => t.isBookmarked.equals(true))
            ..orderBy([(t) => OrderingTerm.asc(t.commonName)]))
          .get();

  Stream<List<CachedSpeciesRow>> watchBookmarked() =>
      (select(cachedSpeciesTable)
            ..where((t) => t.isBookmarked.equals(true)))
          .watch();

  Future<void> upsert(CachedSpeciesTableCompanion entry) =>
      into(cachedSpeciesTable).insertOnConflictUpdate(entry);

  Future<void> upsertAll(List<CachedSpeciesTableCompanion> entries) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(cachedSpeciesTable, entries);
    });
  }

  Future<void> toggleBookmark(String id, {required bool bookmarked}) =>
      (update(cachedSpeciesTable)..where((t) => t.id.equals(id))).write(
        CachedSpeciesTableCompanion(isBookmarked: Value(bookmarked)),
      );

  Future<int> deleteOlderThan(DateTime cutoff) =>
      (delete(cachedSpeciesTable)
            ..where(
              (t) => t.cachedAt.isSmallerThanValue(cutoff) &
                  t.isBookmarked.equals(false),
            ))
          .go();

  // ── User Preferences ──────────────────────────────────────────────────────

  Future<String?> getPref(String key) async {
    final row = await (select(userPreferencesTable)
          ..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> setPref(String key, String value) =>
      into(userPreferencesTable).insertOnConflictUpdate(
        UserPreferencesTableCompanion(
          key: Value(key),
          value: Value(value),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<void> deletePref(String key) =>
      (delete(userPreferencesTable)..where((t) => t.key.equals(key))).go();

  // ── Bookmarks ─────────────────────────────────────────────────────────────

  Future<List<BookmarkRow>> getAllBookmarks({String? type}) {
    final query = select(bookmarksTable)
      ..orderBy([(t) => OrderingTerm.desc(t.savedAt)]);
    if (type != null) {
      query.where((t) => t.type.equals(type));
    }
    return query.get();
  }

  Future<bool> isBookmarked(String type, String refId) async {
    final row = await (select(bookmarksTable)
          ..where((t) => t.type.equals(type) & t.refId.equals(refId)))
        .getSingleOrNull();
    return row != null;
  }

  Future<void> addBookmark(BookmarksTableCompanion entry) =>
      into(bookmarksTable).insertOnConflictUpdate(entry);

  Future<int> removeBookmark(String type, String refId) =>
      (delete(bookmarksTable)
            ..where((t) => t.type.equals(type) & t.refId.equals(refId)))
          .go();
}
