import 'package:dartz/dartz.dart';
import 'package:butterfly_india/core/errors/failure.dart';
import 'package:butterfly_india/features/community/data/datasources/community_remote_datasource.dart';
import 'package:butterfly_india/features/community/data/models/comment.dart';
import 'package:butterfly_india/features/community/data/models/public_profile.dart';
import 'package:butterfly_india/features/community/data/repositories/community_repository.dart';
import 'package:butterfly_india/features/home/data/models/observation_summary.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// FAKE COMMUNITY REPOSITORY — in-memory, deterministic for widget tests.
/// ─────────────────────────────────────────────────────────────────────────────

class FakeCommunityRepository implements ICommunityRepository {
  FakeCommunityRepository({this.fail = false, this.empty = false});

  bool fail;
  bool empty;
  int likeCalls = 0;
  final List<Comment> addedComments = [];

  static final feedItems = <ObservationSummary>[
    ObservationSummary(
      id: 'obs-1',
      title: 'Blue Tiger',
      userId: 'u-1',
      userName: 'Asha',
      identifiedSpeciesName: 'Tirumala limniace',
      stateName: 'Kerala',
      locationName: 'Munnar',
      likeCount: 5,
      commentCount: 2,
      createdAt: DateTime(2026, 5, 20),
    ),
    ObservationSummary(
      id: 'obs-2',
      title: 'Common Crow',
      userId: 'u-2',
      userName: 'Ravi',
      stateName: 'Goa',
      likeCount: 1,
      isLiked: true,
      createdAt: DateTime(2026, 5, 22),
    ),
  ];

  @override
  Future<Either<Failure, Paged<ObservationSummary>>> feed({
    int page = 1,
    Map<String, dynamic>? filters,
  }) async {
    if (fail) return const Left(ServerFailure(message: 'feed boom'));
    if (empty || page > 1) {
      return const Right(Paged(items: [], total: 0));
    }
    return Right(Paged(items: feedItems, total: feedItems.length));
  }

  @override
  Future<Either<Failure, LikeResult>> toggleLike(String observationId) async {
    likeCalls++;
    if (fail) return const Left(ServerFailure(message: 'like boom'));
    return const Right(LikeResult(liked: true, likeCount: 6));
  }

  @override
  Future<Either<Failure, Paged<Comment>>> comments(
    String observationId, {
    int page = 1,
  }) async {
    if (fail) return const Left(ServerFailure(message: 'comments boom'));
    return Right(Paged(
      items: [
        Comment(
          id: 'c-1',
          body: 'Beautiful shot!',
          user: const CommentAuthor(id: 'u-9', username: 'maya', fullName: 'Maya'),
          createdAt: DateTime(2026, 5, 23),
        ),
      ],
      total: 1,
    ));
  }

  @override
  Future<Either<Failure, Comment>> addComment(
    String observationId,
    String body,
  ) async {
    if (fail) return const Left(ServerFailure(message: 'add boom'));
    final c = Comment(
      id: 'c-new',
      body: body,
      user: const CommentAuthor(id: 'me', username: 'me', fullName: 'Me'),
      createdAt: DateTime(2026, 5, 29),
    );
    addedComments.add(c);
    return Right(c);
  }

  @override
  Future<Either<Failure, Unit>> deleteComment(
    String observationId,
    String commentId,
  ) async {
    if (fail) return const Left(ServerFailure(message: 'del boom'));
    return const Right(unit);
  }

  @override
  Future<Either<Failure, PublicProfile>> profile(String username) async {
    if (fail) return const Left(ServerFailure(message: 'no user'));
    return Right(PublicProfile(
      id: 'u-1',
      username: username,
      fullName: 'Asha Nair',
      bio: 'Lepidoptera lover',
      isVerified: true,
      createdAt: DateTime(2025, 1, 1),
    ));
  }

  @override
  Future<Either<Failure, Paged<ObservationSummary>>> userObservations(
    String userId, {
    int page = 1,
  }) async {
    if (fail) return const Left(ServerFailure(message: 'user obs boom'));
    if (page > 1) return const Right(Paged(items: [], total: 0));
    return Right(Paged(items: feedItems, total: feedItems.length));
  }
}
