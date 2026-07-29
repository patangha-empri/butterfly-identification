import 'package:dartz/dartz.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../home/data/models/observation_summary.dart';
import '../datasources/community_remote_datasource.dart';
import '../models/comment.dart';
import '../models/public_profile.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// COMMUNITY REPOSITORY — wraps the datasource in Either<Failure, T>.
/// ─────────────────────────────────────────────────────────────────────────────

abstract class ICommunityRepository {
  Future<Either<Failure, Paged<ObservationSummary>>> feed({
    int page,
    Map<String, dynamic>? filters,
  });
  Future<Either<Failure, LikeResult>> toggleLike(String observationId);
  Future<Either<Failure, Paged<Comment>>> comments(String observationId, {int page});
  Future<Either<Failure, Comment>> addComment(String observationId, String body);
  Future<Either<Failure, Unit>> deleteComment(String observationId, String commentId);
  Future<Either<Failure, PublicProfile>> profile(String username);
  Future<Either<Failure, Paged<ObservationSummary>>> userObservations(
    String userId, {
    int page,
  });
}

class CommunityRepository implements ICommunityRepository {
  CommunityRepository({required ICommunityRemoteDataSource remote})
      : _remote = remote;

  final ICommunityRemoteDataSource _remote;

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() run) async {
    try {
      return Right(await run());
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(ExceptionMapper.fromObject(e).toFailure());
    }
  }

  @override
  Future<Either<Failure, Paged<ObservationSummary>>> feed({
    int page = 1,
    Map<String, dynamic>? filters,
  }) =>
      _guard(() => _remote.fetchFeed(page: page, filters: filters));

  @override
  Future<Either<Failure, LikeResult>> toggleLike(String observationId) =>
      _guard(() => _remote.toggleLike(observationId));

  @override
  Future<Either<Failure, Paged<Comment>>> comments(
    String observationId, {
    int page = 1,
  }) =>
      _guard(() => _remote.fetchComments(observationId, page: page));

  @override
  Future<Either<Failure, Comment>> addComment(
    String observationId,
    String body,
  ) =>
      _guard(() => _remote.addComment(observationId, body));

  @override
  Future<Either<Failure, Unit>> deleteComment(
    String observationId,
    String commentId,
  ) =>
      _guard(() async {
        await _remote.deleteComment(observationId, commentId);
        return unit;
      });

  @override
  Future<Either<Failure, PublicProfile>> profile(String username) =>
      _guard(() => _remote.fetchProfile(username));

  @override
  Future<Either<Failure, Paged<ObservationSummary>>> userObservations(
    String userId, {
    int page = 1,
  }) =>
      _guard(() => _remote.fetchUserObservations(userId, page: page));
}
