import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart' show Value;
import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/species_dao.dart';
import '../../../../core/database/daos/observations_dao.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/services/location_service.dart';
import '../datasources/home_remote_datasource.dart';
import '../models/home_feed.dart';
import '../models/observation_summary.dart';
import '../models/species_summary.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// HOME REPOSITORY (offline-first)
/// Strategy:
///   • Online  → fetch all sections in parallel, persist to cache, return fresh.
///   • Offline → assemble feed from the local Drift cache (fromCache: true).
///   • Partial network failure → still returns whatever sections succeeded.
/// ─────────────────────────────────────────────────────────────────────────────

abstract class IHomeRepository {
  Future<Either<Failure, HomeFeed>> getHomeFeed({bool forceRefresh = false});
}

class HomeRepository implements IHomeRepository {
  HomeRepository({
    required IHomeRemoteDataSource remote,
    required SpeciesDao speciesDao,
    required ObservationsDao observationsDao,
    required IConnectivityService connectivity,
    required ILocationService location,
  })  : _remote = remote,
        _speciesDao = speciesDao,
        _observationsDao = observationsDao,
        _connectivity = connectivity,
        _location = location;

  final IHomeRemoteDataSource _remote;
  final SpeciesDao _speciesDao;
  final ObservationsDao _observationsDao;
  final IConnectivityService _connectivity;
  final ILocationService _location;

  @override
  Future<Either<Failure, HomeFeed>> getHomeFeed({
    bool forceRefresh = false,
  }) async {
    if (!_connectivity.isOnline) {
      return _loadFromCache();
    }

    try {
      final coords = await _location.currentCoords();

      // Tracks whether any section threw, so we can tell a genuinely empty
      // feed (200s with no data) from a network outage.
      var anyFailed = false;
      Future<Object?> safe(Future<Object?> Function() fn) async {
        try {
          return await fn();
        } catch (_) {
          anyFailed = true;
          return null;
        }
      }

      // Fetch all sections in parallel; tolerate individual failures.
      final results = await Future.wait([
        safe(() => _remote.fetchTrendingSpecies()),
        safe(() => _remote.fetchSeasonalSpecies()),
        safe(() => _remote.fetchFeaturedSpecies()),
        safe(() => _remote.fetchNearby(lat: coords?.lat, lng: coords?.lng)),
        safe(() => _remote.fetchRecentObservations()),
      ]);

      final trending = (results[0] as List<SpeciesSummary>?) ?? const [];
      final seasonal = (results[1] as List<SpeciesSummary>?) ?? const [];
      final featured = (results[2] as List<SpeciesSummary>?) ?? const [];
      var nearby = (results[3] as List<ObservationSummary>?) ?? const [];
      final recent = (results[4] as List<ObservationSummary>?) ?? const [];

      // Graceful nearby fallback: no GPS / empty → reuse recent sightings.
      if (nearby.isEmpty && recent.isNotEmpty) {
        nearby = recent.take(6).toList();
      }

      final feed = HomeFeed(
        trending: trending,
        seasonal: seasonal,
        featured: featured,
        nearby: nearby,
        recent: recent,
      );

      // Empty + a section failed ⇒ likely an outage → serve cache.
      // Empty with no failures ⇒ genuinely empty → show the empty state.
      if (feed.isEmpty && anyFailed) return _loadFromCache();
      if (!feed.isEmpty) await _persist(feed);
      return Right(feed);
    } on AppException catch (e) {
      final cached = await _loadFromCache();
      return cached.fold((_) => Left(e.toFailure()), Right.new);
    } catch (_) {
      return _loadFromCache();
    }
  }

  // ── Cache read ──────────────────────────────────────────────────────────────

  Future<Either<Failure, HomeFeed>> _loadFromCache() async {
    try {
      final speciesRows = await _speciesDao.getAll(limit: 30);
      final obsRows = await _observationsDao.getAll(limit: 20);

      final species = speciesRows.map(_speciesFromRow).toList();
      final observations = obsRows.map(_obsFromRow).toList();

      if (species.isEmpty && observations.isEmpty) {
        return const Left(CacheFailure(message: 'No cached data available.'));
      }

      return Right(HomeFeed(
        trending: species.take(10).toList(),
        seasonal: species.skip(10).take(10).toList(),
        featured: species.take(6).toList(),
        nearby: observations.take(6).toList(),
        recent: observations,
        fromCache: true,
      ));
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  // ── Cache write ───────────────────────────────────────────────────────────

  Future<void> _persist(HomeFeed feed) async {
    final allSpecies = <String, SpeciesSummary>{
      for (final s in [...feed.trending, ...feed.seasonal, ...feed.featured])
        s.id: s,
    };
    if (allSpecies.isNotEmpty) {
      await _speciesDao.upsertAll(
        allSpecies.values.map(_speciesToCompanion).toList(),
      );
    }

    final allObs = <String, ObservationSummary>{
      for (final o in [...feed.recent, ...feed.nearby]) o.id: o,
    };
    if (allObs.isNotEmpty) {
      await _observationsDao.upsertAll(
        allObs.values.map(_obsToCompanion).toList(),
      );
    }
  }

  // ── Mappers ─────────────────────────────────────────────────────────────────

  CachedSpeciesTableCompanion _speciesToCompanion(SpeciesSummary s) =>
      CachedSpeciesTableCompanion(
        id: Value(s.id),
        commonName: Value(s.commonName),
        scientificName: Value(s.scientificName),
        family: Value(s.family),
        primaryImageUrl: Value(s.primaryImageUrl),
        rarity: Value(s.rarity),
        conservationStatus: Value(s.conservationStatus),
        descriptionShort: Value(s.descriptionShort),
        observationCount: Value(s.observationCount),
        cachedAt: Value(DateTime.now()),
      );

  SpeciesSummary _speciesFromRow(CachedSpeciesRow r) => SpeciesSummary(
        id: r.id,
        commonName: r.commonName,
        scientificName: r.scientificName,
        family: r.family,
        rarity: r.rarity,
        conservationStatus: r.conservationStatus,
        primaryImageUrl: r.primaryImageUrl,
        observationCount: r.observationCount,
        descriptionShort: r.descriptionShort,
      );

  CachedObservationsTableCompanion _obsToCompanion(ObservationSummary o) =>
      CachedObservationsTableCompanion(
        id: Value(o.id),
        userId: Value(o.userId),
        title: Value(o.title),
        stateName: Value(o.stateName),
        latitude: Value(o.latitude),
        longitude: Value(o.longitude),
        locationName: Value(o.locationName),
        privacy: Value(o.privacy),
        status: Value(o.status),
        identifiedSpeciesId: Value(o.identifiedSpeciesId),
        identifiedSpeciesName: Value(o.identifiedSpeciesName),
        identificationConfidence: Value(o.identificationConfidence),
        primaryImageUrl: Value(o.primaryImageUrl),
        likeCount: Value(o.likeCount),
        commentCount: Value(o.commentCount),
        createdAt: Value(o.createdAt ?? DateTime.now()),
        cachedAt: Value(DateTime.now()),
        isSynced: const Value(true),
      );

  ObservationSummary _obsFromRow(CachedObservationRow r) => ObservationSummary(
        id: r.id,
        title: r.title,
        userId: r.userId,
        stateName: r.stateName,
        locationName: r.locationName,
        latitude: r.latitude,
        longitude: r.longitude,
        privacy: r.privacy,
        status: r.status,
        identifiedSpeciesId: r.identifiedSpeciesId,
        identifiedSpeciesName: r.identifiedSpeciesName,
        identificationConfidence: r.identificationConfidence,
        primaryImageUrl: r.primaryImageUrl,
        likeCount: r.likeCount,
        commentCount: r.commentCount,
        createdAt: r.createdAt,
      );
}
