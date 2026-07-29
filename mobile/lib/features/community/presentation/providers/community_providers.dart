import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../home/data/models/observation_summary.dart';
import '../../data/datasources/community_remote_datasource.dart';
import '../../data/models/comment.dart';
import '../../data/models/public_profile.dart';
import '../../data/repositories/community_repository.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// COMMUNITY PROVIDERS
/// ─────────────────────────────────────────────────────────────────────────────

final communityRemoteDataSourceProvider =
    Provider<ICommunityRemoteDataSource>(
  (ref) => CommunityRemoteDataSource(dio: ref.read(dioProvider)),
  name: 'communityRemoteDataSource',
);

final communityRepositoryProvider = Provider<ICommunityRepository>(
  (ref) => CommunityRepository(
    remote: ref.read(communityRemoteDataSourceProvider),
  ),
  name: 'communityRepository',
);

class CommunityException implements Exception {
  CommunityException(this.message);
  final String message;
  @override
  String toString() => message;
}

// ── Public feed (infinite scroll) ──────────────────────────────────────────────

class FeedState {
  const FeedState({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.error,
    this.page = 1,
  });

  final List<ObservationSummary> items;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? error;
  final int page;

  FeedState copyWith({
    List<ObservationSummary>? items,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? error,
    int? page,
  }) =>
      FeedState(
        items: items ?? this.items,
        isLoading: isLoading ?? this.isLoading,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        hasMore: hasMore ?? this.hasMore,
        error: error,
        page: page ?? this.page,
      );
}

class CommunityFeedNotifier extends StateNotifier<FeedState> {
  CommunityFeedNotifier(this._repo) : super(const FeedState(isLoading: true)) {
    refresh();
  }

  final ICommunityRepository _repo;
  static const _perPage = 20;

  Future<void> refresh() async {
    state = const FeedState(isLoading: true);
    final result = await _repo.feed(page: 1);
    state = result.fold(
      (f) => FeedState(isLoading: false, error: f.message, hasMore: false),
      (paged) => FeedState(
        items: paged.items,
        isLoading: false,
        hasMore: paged.items.length >= _perPage &&
            paged.items.length < paged.total,
        page: 1,
      ),
    );
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    final next = state.page + 1;
    final result = await _repo.feed(page: next);
    state = result.fold(
      (f) => state.copyWith(isLoadingMore: false, error: f.message),
      (paged) {
        final merged = [...state.items, ...paged.items];
        return state.copyWith(
          items: merged,
          isLoadingMore: false,
          page: next,
          hasMore: paged.items.isNotEmpty && merged.length < paged.total,
        );
      },
    );
  }

  /// Optimistically reflect a like toggle coming from a card.
  void applyLike(String observationId, bool liked, int likeCount) {
    state = state.copyWith(
      items: [
        for (final o in state.items)
          if (o.id == observationId)
            o.copyWith(isLiked: liked, likeCount: likeCount)
          else
            o,
      ],
    );
  }
}

final communityFeedProvider =
    StateNotifierProvider.autoDispose<CommunityFeedNotifier, FeedState>(
  (ref) => CommunityFeedNotifier(ref.read(communityRepositoryProvider)),
  name: 'communityFeed',
);

// ── Like toggle (returns the server truth) ──────────────────────────────────────

final likeToggleProvider =
    Provider.autoDispose<Future<LikeResult> Function(String)>((ref) {
  final repo = ref.read(communityRepositoryProvider);
  return (String observationId) async {
    final result = await repo.toggleLike(observationId);
    return result.fold(
      (f) => throw CommunityException(f.message),
      (r) => r,
    );
  };
});

// ── Comments ────────────────────────────────────────────────────────────────────

final commentsProvider = StateNotifierProvider.autoDispose
    .family<CommentsNotifier, AsyncValue<List<Comment>>, String>(
  (ref, obsId) =>
      CommentsNotifier(ref.read(communityRepositoryProvider), obsId),
  name: 'comments',
);

class CommentsNotifier extends StateNotifier<AsyncValue<List<Comment>>> {
  CommentsNotifier(this._repo, this._obsId)
      : super(const AsyncValue.loading()) {
    load();
  }

  final ICommunityRepository _repo;
  final String _obsId;

  Future<void> load() async {
    state = const AsyncValue.loading();
    final result = await _repo.comments(_obsId);
    state = result.fold(
      (f) => AsyncValue.error(f.message, StackTrace.current),
      (paged) => AsyncValue.data(paged.items),
    );
  }

  Future<bool> add(String body) async {
    final result = await _repo.addComment(_obsId, body);
    return result.fold(
      (f) => false,
      (comment) {
        state = AsyncValue.data([comment, ...state.value ?? const []]);
        return true;
      },
    );
  }

  Future<bool> remove(String commentId) async {
    final result = await _repo.deleteComment(_obsId, commentId);
    return result.fold(
      (f) => false,
      (_) {
        state = AsyncValue.data(
          (state.value ?? const []).where((c) => c.id != commentId).toList(),
        );
        return true;
      },
    );
  }
}

// ── Public profile ───────────────────────────────────────────────────────────────

final publicProfileProvider =
    FutureProvider.autoDispose.family<PublicProfile, String>(
  (ref, username) async {
    final result =
        await ref.read(communityRepositoryProvider).profile(username);
    return result.fold((f) => throw CommunityException(f.message), (p) => p);
  },
  name: 'publicProfile',
);

final userObservationsProvider = FutureProvider.autoDispose
    .family<List<ObservationSummary>, String>(
  (ref, userId) async {
    final result =
        await ref.read(communityRepositoryProvider).userObservations(userId);
    return result.fold(
      (f) => throw CommunityException(f.message),
      (paged) => paged.items,
    );
  },
  name: 'userObservations',
);
