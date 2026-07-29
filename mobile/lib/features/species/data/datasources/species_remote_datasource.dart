import 'package:dio/dio.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../home/data/models/species_summary.dart';
import '../models/species_detail.dart';
import '../models/species_filter.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// SPECIES REMOTE DATASOURCE
/// ─────────────────────────────────────────────────────────────────────────────

abstract class ISpeciesRemoteDataSource {
  Future<List<SpeciesSummary>> fetchSpecies({
    required int page,
    int perPage,
    SpeciesFilter filter,
  });
  Future<List<SpeciesSummary>> searchSpecies(String query, {int page});
  Future<SpeciesDetail> fetchDetail(String id);
  Future<List<SpeciesSummary>> fetchSimilar(String id);
}

class SpeciesRemoteDataSource implements ISpeciesRemoteDataSource {
  SpeciesRemoteDataSource({required Dio dio}) : _dio = dio;

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

  Map<String, dynamic> _obj(Response<dynamic> res) {
    final data = res.data;
    if (data is Map<String, dynamic>) {
      final inner = data['data'];
      if (inner is Map<String, dynamic>) return inner;
      return data;
    }
    return <String, dynamic>{};
  }

  @override
  Future<List<SpeciesSummary>> fetchSpecies({
    required int page,
    int perPage = 20,
    SpeciesFilter filter = const SpeciesFilter(),
  }) async {
    final res = await _dio.get<dynamic>(
      ApiEndpoints.species,
      queryParameters: filter.toQueryParameters(page: page, perPage: perPage),
    );
    return _list(res, SpeciesSummary.fromJson);
  }

  @override
  Future<List<SpeciesSummary>> searchSpecies(String query, {int page = 1}) async {
    // No dedicated /species/search route (it collides with /species/<id>).
    // Use the list endpoint's `search` filter instead.
    final res = await _dio.get<dynamic>(
      ApiEndpoints.species,
      queryParameters: {'search': query, 'page': page, 'per_page': 20},
    );
    return _list(res, SpeciesSummary.fromJson);
  }

  @override
  Future<SpeciesDetail> fetchDetail(String id) async {
    final res = await _dio.get<dynamic>(ApiEndpoints.speciesDetail(id));
    return SpeciesDetail.fromJson(_obj(res));
  }

  @override
  Future<List<SpeciesSummary>> fetchSimilar(String id) async {
    final res = await _dio.get<dynamic>(ApiEndpoints.speciesSimilar(id));
    return _list(res, SpeciesSummary.fromJson);
  }
}
