import 'package:dio/dio.dart';
import '../../../../core/api/api_endpoints.dart';
import '../models/observation_summary.dart';
import '../models/species_summary.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// HOME REMOTE DATASOURCE
/// Thin wrapper over the backend discovery endpoints. Returns typed models or
/// throws DioException (mapped to AppException by the repository layer).
/// ─────────────────────────────────────────────────────────────────────────────

abstract class IHomeRemoteDataSource {
  Future<List<SpeciesSummary>> fetchTrendingSpecies({int limit});
  Future<List<SpeciesSummary>> fetchSeasonalSpecies({int limit});
  Future<List<SpeciesSummary>> fetchFeaturedSpecies({int limit});
  Future<List<ObservationSummary>> fetchNearby({
    double? lat,
    double? lng,
    int limit,
  });
  Future<List<ObservationSummary>> fetchRecentObservations({
    int page,
    int perPage,
  });
}

class HomeRemoteDataSource implements IHomeRemoteDataSource {
  HomeRemoteDataSource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  List<T> _list<T>(
    Response<dynamic> res,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final data = res.data;
    final raw = data is Map<String, dynamic> ? data['data'] : data;
    if (raw is! List) return [];
    return raw
        .whereType<Map<String, dynamic>>()
        .map(fromJson)
        .toList(growable: false);
  }

  @override
  Future<List<SpeciesSummary>> fetchTrendingSpecies({int limit = 10}) async {
    // No dedicated "trending" endpoint on the backend — use the species list.
    final res = await _dio.get<dynamic>(
      ApiEndpoints.species,
      queryParameters: {'page': 1, 'per_page': limit},
    );
    return _list(res, SpeciesSummary.fromJson);
  }

  @override
  Future<List<SpeciesSummary>> fetchSeasonalSpecies({int limit = 10}) async {
    // No seasonal endpoint yet — return empty without a network call.
    return const [];
  }

  @override
  Future<List<SpeciesSummary>> fetchFeaturedSpecies({int limit = 10}) async {
    // No featured endpoint yet — return empty without a network call.
    return const [];
  }

  @override
  Future<List<ObservationSummary>> fetchNearby({
    double? lat,
    double? lng,
    int limit = 10,
  }) async {
    // Backend has no geo "nearby" endpoint yet — use the public feed.
    final res = await _dio.get<dynamic>(
      ApiEndpoints.observationsFeed,
      queryParameters: {
        'page': 1,
        'per_page': limit,
        if (lat != null) 'lat': lat,
        if (lng != null) 'lng': lng,
      },
    );
    return _list(res, ObservationSummary.fromJson);
  }

  @override
  Future<List<ObservationSummary>> fetchRecentObservations({
    int page = 1,
    int perPage = 20,
  }) async {
    final res = await _dio.get<dynamic>(
      ApiEndpoints.observationsFeed,
      queryParameters: {'page': page, 'per_page': perPage},
    );
    return _list(res, ObservationSummary.fromJson);
  }
}
