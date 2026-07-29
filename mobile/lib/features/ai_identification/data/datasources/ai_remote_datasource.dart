import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import '../../../../core/api/api_endpoints.dart';
import '../models/ai_result.dart';

/// One species suggestion from a stateless quick scan.
class QuickScanMatch {
  const QuickScanMatch({
    required this.commonName,
    required this.scientificName,
    required this.confidence,
  });

  final String commonName;
  final String scientificName;

  /// 0.0–1.0.
  final double confidence;
}

/// Result of a stateless Gemini photo scan (no observation created).
class QuickScanResult {
  const QuickScanResult({
    required this.isButterfly,
    required this.identified,
    this.matches = const [],
  });

  final bool isButterfly;
  final bool identified;
  final List<QuickScanMatch> matches;

  QuickScanMatch? get topMatch => matches.isEmpty ? null : matches.first;

  factory QuickScanResult.fromJson(Map<String, dynamic> json) {
    final rawMatches = json['matches'];
    return QuickScanResult(
      isButterfly: json['is_butterfly'] == true,
      identified: json['identified'] == true,
      matches: rawMatches is! List
          ? const []
          : rawMatches
              .whereType<Map<String, dynamic>>()
              .map((m) => QuickScanMatch(
                    commonName: (m['common_name'] as String?) ?? 'Unknown',
                    scientificName: (m['scientific_name'] as String?) ?? '',
                    confidence:
                        (m['confidence'] as num?)?.toDouble() ?? 0.0,
                  ))
              .toList(),
    );
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
/// AI REMOTE DATASOURCE
/// `trigger` runs Gemini synchronously server-side (5–15s) and returns the
/// completed result, so no client-side polling is required.
/// ─────────────────────────────────────────────────────────────────────────────

abstract class IAiRemoteDataSource {
  Future<AiResult> triggerIdentify(String observationId);
  Future<AiResult> getResult(String observationId);

  /// Stateless Gemini scan of a single photo — no observation is created.
  Future<QuickScanResult> quickScan(File image);
}

class AiRemoteDataSource implements IAiRemoteDataSource {
  AiRemoteDataSource({required Dio dio}) : _dio = dio;

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
  Future<AiResult> triggerIdentify(String observationId) async {
    final res = await _dio.post<dynamic>(
      ApiEndpoints.observationIdentify(observationId),
      // Gemini call is inline — allow generous time beyond the default.
      options: Options(receiveTimeout: const Duration(seconds: 40)),
    );
    return AiResult.fromJson(_obj(res));
  }

  @override
  Future<AiResult> getResult(String observationId) async {
    final res = await _dio.get<dynamic>(
      ApiEndpoints.observationIdentifyResult(observationId),
    );
    return AiResult.fromJson(_obj(res));
  }

  @override
  Future<QuickScanResult> quickScan(File image) async {
    final form = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        image.path,
        filename: p.basename(image.path),
      ),
    });
    final res = await _dio.post<dynamic>(
      ApiEndpoints.aiQuickScan,
      data: form,
      options: Options(
        contentType: 'multipart/form-data',
        // Gemini runs inline server-side.
        receiveTimeout: const Duration(seconds: 40),
      ),
    );
    return QuickScanResult.fromJson(_obj(res));
  }
}
