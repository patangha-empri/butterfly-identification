import 'package:dio/dio.dart';
import '../../../core/api/api_endpoints.dart';
import 'geography_models.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// GEOGRAPHY REMOTE DATASOURCE
/// ─────────────────────────────────────────────────────────────────────────────

abstract class IGeographyRemoteDataSource {
  Future<List<IndiaState>> fetchStates();
  Future<List<IndiaDistrict>> fetchDistricts(int stateId);
}

class GeographyRemoteDataSource implements IGeographyRemoteDataSource {
  GeographyRemoteDataSource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  List<T> _list<T>(
    Response<dynamic> res,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final data = res.data;
    final raw = data is Map<String, dynamic> ? data['data'] : data;
    if (raw is! List) return [];
    return raw.whereType<Map<String, dynamic>>().map(fromJson).toList();
  }

  @override
  Future<List<IndiaState>> fetchStates() async {
    final res = await _dio.get<dynamic>(ApiEndpoints.states);
    return _list(res, IndiaState.fromJson);
  }

  @override
  Future<List<IndiaDistrict>> fetchDistricts(int stateId) async {
    final res = await _dio.get<dynamic>(ApiEndpoints.stateDistricts(stateId));
    return _list(res, IndiaDistrict.fromJson);
  }
}
