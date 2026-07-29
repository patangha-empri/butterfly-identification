import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import '../../../../core/api/api_endpoints.dart';
import '../../../ai_identification/data/models/ai_result.dart';
import '../../../home/data/models/observation_summary.dart';
import '../models/observation.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// OBSERVATION REMOTE DATASOURCE
/// Note: the backend accepts ONE image per request (multipart field `image`),
/// so images are uploaded sequentially by the repository.
/// ─────────────────────────────────────────────────────────────────────────────

abstract class IObservationRemoteDataSource {
  Future<Observation> create(Map<String, dynamic> body);
  Future<ObservationImage> uploadImage(
    String observationId,
    File image, {
    void Function(int sent, int total)? onProgress,
  });
  Future<Observation> getDetail(String id);
  Future<List<ObservationSummary>> listMine({int page, int perPage});
  Future<AiResult> triggerIdentify(String observationId);
  Future<Observation> updatePrivacy(String id, String privacy);
  Future<Observation> update(String id, Map<String, dynamic> body);
  Future<void> delete(String id);
}

class ObservationRemoteDataSource implements IObservationRemoteDataSource {
  ObservationRemoteDataSource({required Dio dio}) : _dio = dio;

  final Dio _dio;

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
  Future<Observation> create(Map<String, dynamic> body) async {
    final res = await _dio.post<dynamic>(ApiEndpoints.observations, data: body);
    return Observation.fromJson(_obj(res));
  }

  @override
  Future<ObservationImage> uploadImage(
    String observationId,
    File image, {
    void Function(int sent, int total)? onProgress,
  }) async {
    final form = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        image.path,
        filename: p.basename(image.path),
      ),
    });
    final res = await _dio.post<dynamic>(
      ApiEndpoints.observationImages(observationId),
      data: form,
      onSendProgress: onProgress,
      options: Options(contentType: 'multipart/form-data'),
    );
    return ObservationImage.fromJson(_obj(res));
  }

  @override
  Future<Observation> getDetail(String id) async {
    final res = await _dio.get<dynamic>(ApiEndpoints.observation(id));
    return Observation.fromJson(_obj(res));
  }

  @override
  Future<List<ObservationSummary>> listMine({
    int page = 1,
    int perPage = 20,
  }) async {
    final res = await _dio.get<dynamic>(
      ApiEndpoints.myObservations,
      queryParameters: {'page': page, 'per_page': perPage},
    );
    final data = res.data;
    final raw = data is Map<String, dynamic> ? data['data'] : data;
    if (raw is! List) return [];
    return raw
        .whereType<Map<String, dynamic>>()
        .map(ObservationSummary.fromJson)
        .toList();
  }

  @override
  Future<AiResult> triggerIdentify(String observationId) async {
    final res = await _dio.post<dynamic>(
      ApiEndpoints.observationIdentify(observationId),
      // Gemini runs inline server-side — allow beyond the default timeout.
      options: Options(receiveTimeout: const Duration(seconds: 40)),
    );
    return AiResult.fromJson(_obj(res));
  }

  @override
  Future<Observation> updatePrivacy(String id, String privacy) async {
    final res = await _dio.patch<dynamic>(
      ApiEndpoints.observationPrivacy(id),
      data: {'privacy': privacy},
    );
    return Observation.fromJson(_obj(res));
  }

  @override
  Future<Observation> update(String id, Map<String, dynamic> body) async {
    final res = await _dio.put<dynamic>(ApiEndpoints.observation(id), data: body);
    return Observation.fromJson(_obj(res));
  }

  @override
  Future<void> delete(String id) async {
    await _dio.delete<dynamic>(ApiEndpoints.observation(id));
  }
}
