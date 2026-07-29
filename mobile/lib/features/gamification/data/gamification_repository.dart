import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/errors/failure.dart';
import 'gamification_models.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// GAMIFICATION DATASOURCE + REPOSITORY
/// ─────────────────────────────────────────────────────────────────────────────

abstract class IGamificationRepository {
  Future<Either<Failure, GamificationProfile>> getProfile();
  Future<Either<Failure, List<AchievementItem>>> getAchievements();
}

class GamificationRepository implements IGamificationRepository {
  GamificationRepository({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() fn) async {
    try {
      return Right(await fn());
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(ExceptionMapper.fromObject(e).toFailure());
    }
  }

  @override
  Future<Either<Failure, GamificationProfile>> getProfile() => _guard(() async {
        final res = await _dio.get<dynamic>(ApiEndpoints.gamificationProfile);
        final data = res.data;
        final obj = data is Map<String, dynamic>
            ? (data['data'] as Map<String, dynamic>? ?? data)
            : <String, dynamic>{};
        return GamificationProfile.fromJson(obj);
      });

  @override
  Future<Either<Failure, List<AchievementItem>>> getAchievements() =>
      _guard(() async {
        final res = await _dio.get<dynamic>(ApiEndpoints.achievements);
        final data = res.data;
        final raw = data is Map<String, dynamic> ? data['data'] : data;
        if (raw is! List) return <AchievementItem>[];
        return raw
            .whereType<Map<String, dynamic>>()
            .map(AchievementItem.fromJson)
            .toList();
      });
}
