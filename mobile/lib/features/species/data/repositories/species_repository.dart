import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart' show Value;
import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/species_dao.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../home/data/models/species_summary.dart';
import '../datasources/species_remote_datasource.dart';
import '../models/species_detail.dart';
import '../models/species_filter.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// SPECIES REPOSITORY (offline-first)
/// ─────────────────────────────────────────────────────────────────────────────

abstract class ISpeciesRepository {
  Future<Either<Failure, List<SpeciesSummary>>> getSpecies({
    required int page,
    int perPage,
    SpeciesFilter filter,
  });
  Future<Either<Failure, List<SpeciesSummary>>> search(String query);
  Future<Either<Failure, SpeciesDetail>> getDetail(String id);
  Future<Either<Failure, List<SpeciesSummary>>> getSimilar(String id);
  Future<Either<Failure, bool>> toggleBookmark(String id);
  Stream<Set<String>> watchBookmarkedIds();
  Stream<List<SpeciesSummary>> watchBookmarkedSpecies();
}

class SpeciesRepository implements ISpeciesRepository {
  SpeciesRepository({
    required ISpeciesRemoteDataSource remote,
    required SpeciesDao dao,
    required IConnectivityService connectivity,
  })  : _remote = remote,
        _dao = dao,
        _connectivity = connectivity;

  final ISpeciesRemoteDataSource _remote;
  final SpeciesDao _dao;
  final IConnectivityService _connectivity;

  @override
  Future<Either<Failure, List<SpeciesSummary>>> getSpecies({
    required int page,
    int perPage = 20,
    SpeciesFilter filter = const SpeciesFilter(),
  }) async {
    if (!_connectivity.isOnline) {
      return _cachedList(page: page, perPage: perPage);
    }
    try {
      final items = await _remote.fetchSpecies(
        page: page,
        perPage: perPage,
        filter: filter,
      );
      // Cache only the unfiltered first pages for offline browsing.
      if (filter.isEmpty) {
        await _dao.upsertAll(items.map(_toCompanion).toList());
      }
      return Right(items);
    } on AppException catch (e) {
      if (page == 1) return _cachedList(page: page, perPage: perPage, fallbackError: e);
      return Left(e.toFailure());
    } catch (_) {
      return _cachedList(page: page, perPage: perPage);
    }
  }

  @override
  Future<Either<Failure, List<SpeciesSummary>>> search(String query) async {
    if (query.trim().isEmpty) return const Right([]);
    if (!_connectivity.isOnline) {
      try {
        final rows = await _dao.search(query.trim());
        return Right(rows.map(_fromRow).toList());
      } catch (_) {
        return const Left(CacheFailure());
      }
    }
    try {
      return Right(await _remote.searchSpecies(query.trim()));
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(ExceptionMapper.fromObject(e).toFailure());
    }
  }

  @override
  Future<Either<Failure, SpeciesDetail>> getDetail(String id) async {
    if (!_connectivity.isOnline) return _cachedDetail(id);
    try {
      final detail = await _remote.fetchDetail(id);
      // Keep the summary cache fresh + reflect bookmark state.
      final bookmarked = await _dao.isBookmarked('species', id);
      await _dao.upsert(_detailToCompanion(detail, bookmarked: bookmarked));
      return Right(detail.copyWith(isBookmarked: bookmarked));
    } on AppException catch (e) {
      final cached = await _cachedDetail(id);
      return cached.fold((_) => Left(e.toFailure()), Right.new);
    } catch (e) {
      return _cachedDetail(id);
    }
  }

  @override
  Future<Either<Failure, List<SpeciesSummary>>> getSimilar(String id) async {
    if (!_connectivity.isOnline) return const Right([]);
    try {
      return Right(await _remote.fetchSimilar(id));
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (_) {
      return const Right([]);
    }
  }

  @override
  Future<Either<Failure, bool>> toggleBookmark(String id) async {
    try {
      final isBookmarked = await _dao.isBookmarked('species', id);
      if (isBookmarked) {
        await _dao.removeBookmark('species', id);
      } else {
        await _dao.addBookmark(
          BookmarksTableCompanion(
            type: const Value('species'),
            refId: Value(id),
            savedAt: Value(DateTime.now()),
          ),
        );
      }
      // Mirror flag on the cached species row if present.
      await _dao.toggleBookmark(id, bookmarked: !isBookmarked);
      return Right(!isBookmarked);
    } catch (_) {
      return const Left(CacheFailure(message: 'Could not update bookmark.'));
    }
  }

  @override
  Stream<Set<String>> watchBookmarkedIds() => _dao
      .watchBookmarked()
      .map((rows) => rows.map((r) => r.id).toSet());

  @override
  Stream<List<SpeciesSummary>> watchBookmarkedSpecies() =>
      _dao.watchBookmarked().map((rows) => rows.map(_fromRow).toList());

  // ── Cache helpers ──────────────────────────────────────────────────────────

  Future<Either<Failure, List<SpeciesSummary>>> _cachedList({
    required int page,
    required int perPage,
    AppException? fallbackError,
  }) async {
    try {
      final rows = await _dao.getAll(limit: perPage, offset: (page - 1) * perPage);
      if (rows.isEmpty) {
        return Left(fallbackError?.toFailure() ??
            const CacheFailure(message: 'No cached species available.'));
      }
      return Right(rows.map(_fromRow).toList());
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  Future<Either<Failure, SpeciesDetail>> _cachedDetail(String id) async {
    try {
      final row = await _dao.getById(id);
      if (row == null) {
        return const Left(
          NetworkFailure(message: 'Species unavailable offline.'),
        );
      }
      return Right(SpeciesDetail(
        id: row.id,
        commonName: row.commonName,
        scientificName: row.scientificName,
        family: row.family,
        rarity: row.rarity,
        conservationStatus: row.conservationStatus,
        descriptionShort: row.descriptionShort,
        primaryImageUrl: row.primaryImageUrl,
        observationCount: row.observationCount,
        isBookmarked: row.isBookmarked,
      ));
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  // ── Mappers ─────────────────────────────────────────────────────────────────

  SpeciesSummary _fromRow(CachedSpeciesRow r) => SpeciesSummary(
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

  CachedSpeciesTableCompanion _toCompanion(SpeciesSummary s) =>
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

  CachedSpeciesTableCompanion _detailToCompanion(
    SpeciesDetail d, {
    required bool bookmarked,
  }) =>
      CachedSpeciesTableCompanion(
        id: Value(d.id),
        commonName: Value(d.commonName),
        scientificName: Value(d.scientificName),
        family: Value(d.family),
        primaryImageUrl: Value(d.primaryImageUrl),
        rarity: Value(d.rarity),
        conservationStatus: Value(d.conservationStatus),
        descriptionShort: Value(d.descriptionShort ?? d.description),
        observationCount: Value(d.observationCount),
        isBookmarked: Value(bookmarked),
        cachedAt: Value(DateTime.now()),
      );
}
