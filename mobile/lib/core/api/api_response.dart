import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// API RESPONSE WRAPPERS
/// Matches the Flask backend response shape:
///   { "success": true, "data": {...}, "message": "...", "meta": {...} }
/// ─────────────────────────────────────────────────────────────────────────────

@Freezed(genericArgumentFactories: true)
class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse({
    required bool success,
    T? data,
    String? message,
    ApiMeta? meta,
    Map<String, dynamic>? errors,
  }) = _ApiResponse;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);
}

@freezed
class ApiMeta with _$ApiMeta {
  const factory ApiMeta({
    int? total,
    int? page,
    int? perPage,
    int? totalPages,
    bool? hasMore,
  }) = _ApiMeta;

  factory ApiMeta.fromJson(Map<String, dynamic> json) =>
      _$ApiMetaFromJson(json);
}

// ── Paginated response helper ─────────────────────────────────────────────────

@freezed
class PaginatedResponse<T> with _$PaginatedResponse<T> {
  const factory PaginatedResponse({
    required List<T> items,
    required int total,
    required int page,
    required int perPage,
    required int totalPages,
    required bool hasMore,
  }) = _PaginatedResponse;

  factory PaginatedResponse.fromApiResponse(
    ApiResponse<List<T>> response, {
    int defaultPage = 1,
    int defaultPerPage = 20,
  }) {
    final meta = response.meta;
    return PaginatedResponse(
      items: response.data ?? [],
      total: meta?.total ?? (response.data?.length ?? 0),
      page: meta?.page ?? defaultPage,
      perPage: meta?.perPage ?? defaultPerPage,
      totalPages: meta?.totalPages ?? 1,
      hasMore: meta?.hasMore ?? false,
    );
  }
}
