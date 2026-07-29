import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../shared/widgets/loaders/skeleton.dart';
import '../../../../shared/widgets/states/empty_state.dart';
import '../providers/community_providers.dart';
import '../widgets/community_post_card.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// COMMUNITY FEED SCREEN (Community tab)
/// Public feed of sightings with infinite scroll, pull-to-refresh, likes &
/// comments.
/// ─────────────────────────────────────────────────────────────────────────────

class CommunityFeedScreen extends ConsumerStatefulWidget {
  const CommunityFeedScreen({super.key});

  @override
  ConsumerState<CommunityFeedScreen> createState() =>
      _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends ConsumerState<CommunityFeedScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 400) {
      ref.read(communityFeedProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(communityFeedProvider);
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom + 80;

    return Scaffold(
      appBar: AppBar(title: const Text('Community')),
      body: RefreshIndicator(
        onRefresh: () => ref.read(communityFeedProvider.notifier).refresh(),
        child: _body(state, bottomInset),
      ),
    );
  }

  Widget _body(FeedState state, double bottomInset) {
    if (state.isLoading) {
      return ListView(
        padding: const EdgeInsets.all(SpaceTokens.base),
        children: const [_PostSkeleton(), _PostSkeleton(), _PostSkeleton()],
      );
    }

    if (state.error != null && state.items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.25),
          AppEmptyState.error(
            message: state.error,
            onRetry: () => ref.read(communityFeedProvider.notifier).refresh(),
          ),
        ],
      );
    }

    if (state.items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.2),
          const AppEmptyState(
            icon: Icons.groups_outlined,
            title: 'No sightings yet',
            message: 'Public sightings from the community will appear here.',
          ),
        ],
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.fromLTRB(
        SpaceTokens.base,
        SpaceTokens.base,
        SpaceTokens.base,
        bottomInset,
      ),
      itemCount: state.items.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, i) {
        if (i >= state.items.length) {
          return const Padding(
            padding: EdgeInsets.all(SpaceTokens.lg),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final obs = state.items[i];
        return CommunityPostCard(
          observation: obs,
          onLikeChanged: (liked, count) => ref
              .read(communityFeedProvider.notifier)
              .applyLike(obs.id, liked, count),
        );
      },
    );
  }
}

class _PostSkeleton extends StatelessWidget {
  const _PostSkeleton();
  @override
  Widget build(BuildContext context) => const SkeletonShimmer(
        child: Padding(
          padding: EdgeInsets.only(bottom: SpaceTokens.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Skeleton.circle(size: 36),
                  SizedBox(width: SpaceTokens.sm),
                  Skeleton(width: 120, height: 12),
                ],
              ),
              SizedBox(height: SpaceTokens.sm),
              Skeleton(height: 200, borderRadius: RadiusTokens.card),
              SizedBox(height: SpaceTokens.sm),
              Skeleton(width: 160, height: 14),
            ],
          ),
        ),
      );
}
