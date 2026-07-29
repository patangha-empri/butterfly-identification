import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/core/database/app_database.dart';
import 'package:butterfly_india/core/network/connectivity_service.dart';
import 'package:butterfly_india/core/services/location_service.dart';
import 'package:butterfly_india/features/home/data/repositories/home_repository.dart';
import '../../mocks/mock_services.dart';
import 'fake_home_datasource.dart';

class _FakeLocation implements ILocationService {
  _FakeLocation([this._coords]);
  final GeoCoords? _coords;
  @override
  Future<GeoCoords?> currentCoords() async => _coords;
  @override
  Future<bool> get hasPermission async => _coords != null;
}

void main() {
  late AppDatabase db;
  late FakeHomeRemoteDataSource remote;
  late MockConnectivityService connectivity;

  HomeRepository build({ILocationService? location}) => HomeRepository(
        remote: remote,
        speciesDao: db.speciesDao,
        observationsDao: db.observationsDao,
        connectivity: connectivity,
        location: location ?? _FakeLocation(),
      );

  setUp(() {
    db = AppDatabase.inMemory();
    remote = FakeHomeRemoteDataSource();
    connectivity = MockConnectivityService();
  });

  tearDown(() => db.close());

  group('HomeRepository — online', () {
    test('fetches fresh feed and returns Right', () async {
      final result = await build().getHomeFeed();

      expect(result.isRight(), isTrue);
      final feed = result.getOrElse(() => throw 'unexpected');
      expect(feed.trending, isNotEmpty);
      expect(feed.recent, isNotEmpty);
      expect(feed.fromCache, isFalse);
    });

    test('persists fetched species + observations to cache', () async {
      await build().getHomeFeed();

      final cachedSpecies = await db.speciesDao.getAll();
      final cachedObs = await db.observationsDao.getAll();
      expect(cachedSpecies, isNotEmpty);
      expect(cachedObs, isNotEmpty);
    });

    test('passes GPS coords to nearby when available', () async {
      await build(location: _FakeLocation((lat: 12.9, lng: 77.5)))
          .getHomeFeed();

      expect(remote.lastLat, 12.9);
      expect(remote.lastLng, 77.5);
    });

    test('nearby falls back to recent when nearby empty', () async {
      remote.failNearby = true; // nearby throws → empty
      final result = await build().getHomeFeed();

      final feed = result.getOrElse(() => throw 'unexpected');
      // Falls back to recent sightings instead of empty nearby.
      expect(feed.nearby, isNotEmpty);
    });
  });

  group('HomeRepository — offline', () {
    test('returns cache failure when offline with empty cache', () async {
      connectivity.setStatus(ConnectivityStatus.offline);

      final result = await build().getHomeFeed();
      expect(result.isLeft(), isTrue);
    });

    test('serves cached feed when offline after a prior online fetch',
        () async {
      // 1. Online fetch populates cache.
      await build().getHomeFeed();

      // 2. Go offline → should serve from cache.
      connectivity.setStatus(ConnectivityStatus.offline);
      final result = await build().getHomeFeed();

      expect(result.isRight(), isTrue);
      final feed = result.getOrElse(() => throw 'unexpected');
      expect(feed.fromCache, isTrue);
      expect(feed.trending, isNotEmpty);
    });
  });

  group('HomeRepository — total network failure', () {
    test('falls back to cache when all sections fail', () async {
      // Seed cache first.
      await build().getHomeFeed();

      // Now everything fails → should serve cache, not error.
      remote.failAll = true;
      final result = await build().getHomeFeed();

      expect(result.isRight(), isTrue);
      expect(
        result.getOrElse(() => throw 'unexpected').fromCache,
        isTrue,
      );
    });
  });
}
