import 'package:dio/dio.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../home/data/models/observation_summary.dart';
import '../models/comment.dart';
import '../models/public_profile.dart';

/// Result of a like toggle.
class LikeResult {
  const LikeResult({required this.liked, required this.likeCount});
  final bool liked;
  final int likeCount;
}

/// A page of items plus the total count (for infinite scroll).
class Paged<T> {
  const Paged({required this.items, required this.total});
  final List<T> items;
  final int total;
}

/// ─────────────────────────────────────────────────────────────────────────────
/// COMMUNITY REMOTE DATASOURCE — public feed, likes, comments, profiles.
/// ─────────────────────────────────────────────────────────────────────────────

abstract class ICommunityRemoteDataSource {
  Future<Paged<ObservationSummary>> fetchFeed({
    int page,
    int perPage,
    Map<String, dynamic>? filters,
  });
  Future<LikeResult> toggleLike(String observationId);
  Future<Paged<Comment>> fetchComments(String observationId, {int page, int perPage});
  Future<Comment> addComment(String observationId, String body);
  Future<void> deleteComment(String observationId, String commentId);
  Future<PublicProfile> fetchProfile(String username);
  Future<Paged<ObservationSummary>> fetchUserObservations(
    String userId, {
    int page,
    int perPage,
  });
}

class CommunityRemoteDataSource implements ICommunityRemoteDataSource {
  CommunityRemoteDataSource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  int _total(Response<dynamic> res, int fallback) {
    final data = res.data;
    if (data is Map<String, dynamic>) {
      final meta = data['meta'];
      if (meta is Map<String, dynamic> && meta['total'] is int) {
        return meta['total'] as int;
      }
    }
    return fallback;
  }

  List<Map<String, dynamic>> _list(Response<dynamic> res) {
    final data = res.data;
    final raw = data is Map<String, dynamic> ? data['data'] : data;
    if (raw is! List) return const [];
    return raw.whereType<Map<String, dynamic>>().toList();
  }

  Map<String, dynamic> _obj(Response<dynamic> res) {
    final data = res.data;
    if (data is Map<String, dynamic>) {
      final inner = data['data'];
      if (inner is Map<String, dynamic>) return inner;
      return data;
    }
    return const {};
  }

  @override
  Future<Paged<ObservationSummary>> fetchFeed({
    int page = 1,
    int perPage = 20,
    Map<String, dynamic>? filters,
  }) async {
    final res = await _dio.get<dynamic>(
      ApiEndpoints.observationsFeed,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        ...?filters,
      },
    );
    final items = _list(res).map(ObservationSummary.fromJson).toList();
    return Paged(items: items, total: _total(res, items.length));
  }

  @override
  Future<LikeResult> toggleLike(String observationId) async {
    final res = await _dio.post<dynamic>(
      ApiEndpoints.observationLike(observationId),
    );
    final d = _obj(res);
    return LikeResult(
      liked: d['liked'] == true,
      likeCount: (d['like_count'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  Future<Paged<Comment>> fetchComments(
    String observationId, {
    int page = 1,
    int perPage = 30,
  }) async {
    final res = await _dio.get<dynamic>(
      ApiEndpoints.observationComments(observationId),
      queryParameters: {'page': page, 'per_page': perPage},
    );
    final items = _list(res).map(Comment.fromJson).toList();
    return Paged(items: items, total: _total(res, items.length));
  }

  @override
  Future<Comment> addComment(String observationId, String body) async {
    final res = await _dio.post<dynamic>(
      ApiEndpoints.observationComments(observationId),
      data: {'body': body},
    );
    return Comment.fromJson(_obj(res));
  }

  @override
  Future<void> deleteComment(String observationId, String commentId) async {
    await _dio.delete<dynamic>(
      ApiEndpoints.observationComment(observationId, commentId),
    );
  }

  @override
  Future<PublicProfile> fetchProfile(String username) async {
    final res = await _dio.get<dynamic>(
      ApiEndpoints.userPublicProfile(username),
    );
    return PublicProfile.fromJson(_obj(res));
  }

  @override
  Future<Paged<ObservationSummary>> fetchUserObservations(
    String userId, {
    int page = 1,
    int perPage = 20,
  }) async {
    final res = await _dio.get<dynamic>(
      ApiEndpoints.userObservations(userId),
      queryParameters: {'page': page, 'per_page': perPage},
    );
    final items = _list(res).map(ObservationSummary.fromJson).toList();
    return Paged(items: items, total: _total(res, items.length));
  }
}
