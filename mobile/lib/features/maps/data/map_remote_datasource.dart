import 'package:dio/dio.dart';
import '../../../core/api/api_endpoints.dart';
import '../../home/data/models/observation_summary.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// MAP REMOTE DATASOURCE
/// Pulls public sightings (from the observations feed) to plot on the map.
/// ─────────────────────────────────────────────────────────────────────────────

abstract class IMapRemoteDataSource {
  Future<List<ObservationSummary>> fetchSightings({
    int? stateId,
    String? privacy,
    int perPage,
  });
}

class MapRemoteDataSource implements IMapRemoteDataSource {
  MapRemoteDataSource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<ObservationSummary>> fetchSightings({
    int? stateId,
    String? privacy,
    int perPage = 100,
  }) async {
    final res = await _dio.get<dynamic>(
      ApiEndpoints.observationsFeed,
      queryParameters: {
        'page': 1,
        'per_page': perPage,
        if (stateId != null) 'state_id': stateId,
        if (privacy != null) 'privacy': privacy,
      },
    );
    final data = res.data;
    final raw = data is Map<String, dynamic> ? data['data'] : data;
    if (raw is! List) return [];
    return raw
        .whereType<Map<String, dynamic>>()
        .map(ObservationSummary.fromJson)
        .toList();
  }
}
