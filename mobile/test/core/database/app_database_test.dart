import 'package:drift/drift.dart' hide isNull, isNotNull, isEmpty, isNotEmpty;
import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/core/database/app_database.dart';
import 'package:butterfly_india/core/database/tables/observations_table.dart';
import 'package:butterfly_india/core/database/tables/species_table.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.inMemory();
  });

  tearDown(() => db.close());

  group('AppDatabase — Observations DAO', () {
    test('inserts and retrieves a cached observation', () async {
      final entry = CachedObservationsTableCompanion(
        id: const Value('obs-001'),
        title: const Value('Test observation'),
        stateId: const Value(11),
        privacy: const Value('public'),
        status: const Value('pending'),
        isSynced: const Value(false),
      );

      await db.observationsDao.upsert(entry);
      final result = await db.observationsDao.getById('obs-001');

      expect(result, isNotNull);
      expect(result!.title, 'Test observation');
      expect(result.stateId, 11);
    });

    test('returns null for non-existent observation', () async {
      final result = await db.observationsDao.getById('non-existent');
      expect(result, isNull);
    });

    test('upsert updates existing row', () async {
      final initial = CachedObservationsTableCompanion(
        id: const Value('obs-002'),
        title: const Value('Original title'),
        privacy: const Value('public'),
        status: const Value('pending'),
      );

      await db.observationsDao.upsert(initial);

      final updated = CachedObservationsTableCompanion(
        id: const Value('obs-002'),
        title: const Value('Updated title'),
        privacy: const Value('private'),
        status: const Value('identified'),
      );

      await db.observationsDao.upsert(updated);
      final result = await db.observationsDao.getById('obs-002');

      expect(result!.title, 'Updated title');
      expect(result.privacy, 'private');
    });

    test('getAll returns in descending createdAt order', () async {
      await db.observationsDao.upsertAll([
        CachedObservationsTableCompanion(
          id: const Value('obs-a'),
          privacy: const Value('public'),
          status: const Value('pending'),
          createdAt: Value(DateTime(2024, 1, 1)),
        ),
        CachedObservationsTableCompanion(
          id: const Value('obs-b'),
          privacy: const Value('public'),
          status: const Value('pending'),
          createdAt: Value(DateTime(2024, 6, 1)),
        ),
      ]);

      final results = await db.observationsDao.getAll();
      expect(results.first.id, 'obs-b'); // Newest first
    });
  });

  group('AppDatabase — Offline Queue', () {
    test('addToQueue inserts pending item', () async {
      await db.observationsDao.addToQueue(
        const OfflineQueueTableCompanion(
          type: Value('observation'),
          payload: Value('{"title": "test"}'),
          endpoint: Value('/api/v1/observations'),
          httpMethod: Value('POST'),
        ),
      );

      final pending = await db.observationsDao.getPendingQueue();
      expect(pending.length, 1);
      expect(pending.first.type, 'observation');
    });

    test('markSucceeded updates status', () async {
      final id = await db.observationsDao.addToQueue(
        const OfflineQueueTableCompanion(
          type: Value('observation'),
          payload: Value('{}'),
          endpoint: Value('/api/v1/observations'),
        ),
      );

      await db.observationsDao.markSucceeded(id);
      final pending = await db.observationsDao.getPendingQueue();
      expect(pending, isEmpty);
    });

    test('incrementRetry updates retry count', () async {
      final id = await db.observationsDao.addToQueue(
        const OfflineQueueTableCompanion(
          type: Value('observation'),
          payload: Value('{}'),
          endpoint: Value('/api/v1/observations'),
          maxRetries: Value(3),
        ),
      );

      await db.observationsDao.incrementRetry(id);
      await db.observationsDao.incrementRetry(id);

      // After 2 retries, should still be pending (max is 3)
      final pending = await db.observationsDao.getPendingQueue();
      expect(pending.first.retryCount, 2);
    });

    test('getPendingCount returns correct count', () async {
      await db.observationsDao.addToQueue(
        const OfflineQueueTableCompanion(
          type: Value('observation'),
          payload: Value('{}'),
          endpoint: Value('/api/v1/observations'),
        ),
      );
      await db.observationsDao.addToQueue(
        const OfflineQueueTableCompanion(
          type: Value('identification'),
          payload: Value('{}'),
          endpoint: Value('/api/v1/identification'),
        ),
      );

      final count = await db.observationsDao.getPendingCount();
      expect(count, 2);
    });
  });

  group('AppDatabase — Species DAO', () {
    test('search returns matching species', () async {
      await db.speciesDao.upsertAll([
        const CachedSpeciesTableCompanion(
          id: Value('sp-001'),
          commonName: Value('Crimson Rose'),
          scientificName: Value('Pachliopta hector'),
        ),
        const CachedSpeciesTableCompanion(
          id: Value('sp-002'),
          commonName: Value('Common Jezebel'),
          scientificName: Value('Delias eucharis'),
        ),
      ]);

      final results = await db.speciesDao.search('crimson');
      expect(results.length, 1);
      expect(results.first.commonName, 'Crimson Rose');
    });

    test('toggleBookmark updates isBookmarked', () async {
      await db.speciesDao.upsert(
        const CachedSpeciesTableCompanion(
          id: Value('sp-001'),
          commonName: Value('Crimson Rose'),
          scientificName: Value('Pachliopta hector'),
        ),
      );

      await db.speciesDao.toggleBookmark('sp-001', bookmarked: true);
      final bookmarked = await db.speciesDao.getBookmarked();
      expect(bookmarked.length, 1);

      await db.speciesDao.toggleBookmark('sp-001', bookmarked: false);
      final unbookmarked = await db.speciesDao.getBookmarked();
      expect(unbookmarked, isEmpty);
    });

    test('preferences: set and get', () async {
      await db.speciesDao.setPref('theme', 'dark');
      final value = await db.speciesDao.getPref('theme');
      expect(value, 'dark');
    });

    test('preferences: delete removes key', () async {
      await db.speciesDao.setPref('key', 'value');
      await db.speciesDao.deletePref('key');
      final value = await db.speciesDao.getPref('key');
      expect(value, isNull);
    });
  });

  group('AppDatabase — Maintenance', () {
    test('pruneExpiredCache deletes old non-bookmarked species', () async {
      // Insert old species
      await db.speciesDao.upsert(
        CachedSpeciesTableCompanion(
          id: const Value('sp-old'),
          commonName: const Value('Old Species'),
          scientificName: const Value('Old scientificus'),
          cachedAt: Value(DateTime.now().subtract(const Duration(days: 10))),
        ),
      );

      // Insert recent species
      await db.speciesDao.upsert(
        const CachedSpeciesTableCompanion(
          id: Value('sp-new'),
          commonName: Value('New Species'),
          scientificName: Value('New scientificus'),
        ),
      );

      await db.pruneExpiredCache();

      final allSpecies = await db.speciesDao.getAll();
      expect(allSpecies.length, 1);
      expect(allSpecies.first.id, 'sp-new');
    });
  });
}
