import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/core/database/app_database.dart';
import 'package:butterfly_india/core/network/connectivity_service.dart';
import 'package:butterfly_india/features/home/data/models/species_summary.dart';
import 'package:butterfly_india/features/species/data/models/species_filter.dart';
import 'package:butterfly_india/features/species/data/repositories/species_repository.dart';
import '../../mocks/mock_services.dart';
import 'fake_species_datasource.dart';

void main() {
  late AppDatabase db;
  late FakeSpeciesRemoteDataSource remote;
  late MockConnectivityService connectivity;

  SpeciesRepository build() => SpeciesRepository(
        remote: remote,
        dao: db.speciesDao,
        connectivity: connectivity,
      );

  setUp(() {
    db = AppDatabase.inMemory();
    remote = FakeSpeciesRemoteDataSource();
    connectivity = MockConnectivityService();
  });

  tearDown(() => db.close());

  group('getSpecies', () {
    test('returns page 1 and caches when filter empty', () async {
      final result = await build().getSpecies(page: 1, perPage: 20);
      expect(result.isRight(), isTrue);
      expect(result.getOrElse(() => []), hasLength(20));

      final cached = await db.speciesDao.getAll(limit: 50);
      expect(cached, isNotEmpty);
    });

    test('passes filter to datasource', () async {
      const filter = SpeciesFilter(rarity: 'rare');
      await build().getSpecies(page: 1, filter: filter);
      expect(remote.lastFilter, filter);
    });

    test('does not cache when filter is active', () async {
      await build()
          .getSpecies(page: 1, filter: const SpeciesFilter(rarity: 'rare'));
      final cached = await db.speciesDao.getAll(limit: 50);
      expect(cached, isEmpty);
    });

    test('offline page 1 serves cache', () async {
      // Prime cache online.
      await build().getSpecies(page: 1);
      // Offline.
      connectivity.setStatus(ConnectivityStatus.offline);
      final result = await build().getSpecies(page: 1);
      expect(result.isRight(), isTrue);
      expect(result.getOrElse(() => []), isNotEmpty);
    });

    test('offline with empty cache returns failure', () async {
      connectivity.setStatus(ConnectivityStatus.offline);
      final result = await build().getSpecies(page: 1);
      expect(result.isLeft(), isTrue);
    });
  });

  group('getDetail', () {
    test('returns detail and reflects bookmark state', () async {
      final result = await build().getDetail('sp-1');
      expect(result.isRight(), isTrue);
      final d = result.getOrElse(() => throw 'unexpected');
      expect(d.commonName, 'Crimson Rose');
      expect(d.isBookmarked, isFalse);
    });
  });

  group('search', () {
    test('empty query returns empty list without calling remote', () async {
      final result = await build().search('');
      expect(result.getOrElse(() => <SpeciesSummary>[]), isEmpty);
      expect(remote.lastSearchQuery, isNull);
    });

    test('online search hits datasource', () async {
      final result = await build().search('rose');
      expect(result.isRight(), isTrue);
      expect(remote.lastSearchQuery, 'rose');
    });
  });

  group('bookmarks', () {
    test('toggleBookmark adds then removes', () async {
      final repo = build();
      final added = await repo.toggleBookmark('sp-1');
      expect(added.getOrElse(() => false), isTrue);
      expect(await db.speciesDao.isBookmarked('species', 'sp-1'), isTrue);

      final removed = await repo.toggleBookmark('sp-1');
      expect(removed.getOrElse(() => true), isFalse);
      expect(await db.speciesDao.isBookmarked('species', 'sp-1'), isFalse);
    });

    test('watchBookmarkedIds emits bookmarked set', () async {
      final repo = build();
      // Seed a cached species so the watch (on cached_species.isBookmarked) sees it.
      await build().getSpecies(page: 1);
      await repo.toggleBookmark('sp-1');

      final ids = await repo.watchBookmarkedIds().first;
      expect(ids, contains('sp-1'));
    });
  });

  group('getSimilar', () {
    test('returns recommendations online', () async {
      final result = await build().getSimilar('sp-1');
      expect(result.getOrElse(() => []), hasLength(2));
    });

    test('returns empty offline', () async {
      connectivity.setStatus(ConnectivityStatus.offline);
      final result = await build().getSimilar('sp-1');
      expect(result.getOrElse(() => <SpeciesSummary>[]), isEmpty);
    });
  });
}
