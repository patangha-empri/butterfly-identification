import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables/observations_table.dart';
import 'tables/species_table.dart';
import 'daos/observations_dao.dart';
import 'daos/species_dao.dart';

part 'app_database.g.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// APP DATABASE (Drift / SQLite)
/// Offline-first local store for observations, species, queue and prefs.
///
/// Migration strategy:
///   schemaVersion bumped on every table change.
///   MigrationStrategy handles ALTER TABLE / data transformations.
/// ─────────────────────────────────────────────────────────────────────────────

@DriftDatabase(
  tables: [
    CachedObservationsTable,
    OfflineQueueTable,
    CachedSpeciesTable,
    UserPreferencesTable,
    BookmarksTable,
  ],
  daos: [ObservationsDao, SpeciesDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? _openConnection());

  /// In-memory database for testing
  AppDatabase.inMemory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      // Future migrations:
      // if (from < 2) { await m.addColumn(...); }
    },
    beforeOpen: (details) async {
      if (details.wasCreated) {
        // Seed initial data if needed
      }
      // Enable WAL mode for better concurrent read/write performance
      await customStatement('PRAGMA journal_mode=WAL');
      await customStatement('PRAGMA foreign_keys=ON');
    },
  );

  // ── Maintenance ───────────────────────────────────────────────────────────

  Future<void> compact() async {
    await customStatement('VACUUM');
  }

  Future<void> pruneExpiredCache({Duration maxAge = const Duration(days: 7)}) async {
    final cutoff = DateTime.now().subtract(maxAge);
    await observationsDao.deleteOlderThan(cutoff);
    await speciesDao.deleteOlderThan(cutoff);
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'butterfly_india.db'));
    return NativeDatabase.createInBackground(file);
  });
}
