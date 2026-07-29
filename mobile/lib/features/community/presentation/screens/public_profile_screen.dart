import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../../../core/utils/relative_time.dart';
import '../../../../shared/widgets/app_avatar.dart';
import '../../../../shared/widgets/loaders/skeleton.dart';
import '../../../../shared/widgets/states/empty_state.dart';
import '../../../home/data/models/observation_summary.dart';
import '../../data/models/public_profile.dart';
import '../providers/community_providers.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// PUBLIC PROFILE SCREEN (/users/:username)
/// Shows a community member's profile header and their public sightings.
/// ─────────────────────────────────────────────────────────────────────────────

class PublicProfileScreen extends ConsumerWidget {
  const PublicProfileScreen({super.key, required this.username});

  final String username;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(publicProfileProvider(username));

    return Scaffold(
      appBar: AppBar(title: Text('@$username')),
      body: profileAsync.when(
        loading: () => const _ProfileSkeleton(),
        error: (e, _) => AppEmptyState.error(
          message: e.toString(),
          onRetry: () => ref.invalidate(publicProfileProvider(username)),
        ),
        data: (profile) => _ProfileBody(profile: profile),
      ),
    );
  }
}

class _ProfileBody extends ConsumerWidget {
  const _ProfileBody({required this.profile});
  final PublicProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final obsAsync = ref.watch(userObservationsProvider(profile.id));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(userObservationsProvider(profile.id));
        await ref.read(userObservationsProvider(profile.id).future);
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _Header(profile: profile)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              SpaceTokens.base,
              SpaceTokens.sm,
              SpaceTokens.base,
              SpaceTokens.sm,
            ),
            sliver: SliverToBoxAdapter(
              child: Text('Sightings',
                  style: TypographyTokens.textTheme.titleLarge),
            ),
          ),
          obsAsync.when(
            loading: () => const SliverToBoxAdapter(child: _GridSkeleton()),
            error: (e, _) => SliverToBoxAdapter(
              child: AppEmptyState.error(
                message: e.toString(),
                onRetry: () =>
                    ref.invalidate(userObservationsProvider(profile.id)),
              ),
            ),
            data: (items) => _Grid(items: items),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: SpaceTokens.xxl + MediaQuery.viewPaddingOf(context).bottom,
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.profile});
  final PublicProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SpaceTokens.lg),
      child: Column(
        children: [
          AppAvatar(
            radius: 44,
            imageUrl: profile.profileImageUrl,
            name: profile.displayName,
          ),
          const SizedBox(height: SpaceTokens.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(profile.displayName,
                    style: TypographyTokens.textTheme.headlineSmall,
                    textAlign: TextAlign.center),
              ),
              if (profile.isVerified) ...[
                const SizedBox(width: SpaceTokens.xs),
                const Icon(Icons.verified,
                    size: 20, color: ColorTokens.brandPrimary),
              ],
            ],
          ),
          Text('@${profile.username}',
              style: TypographyTokens.textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              )),
          if (profile.bio != null && profile.bio!.isNotEmpty) ...[
            const SizedBox(height: SpaceTokens.md),
            Text(profile.bio!,
                textAlign: TextAlign.center,
                style: TypographyTokens.textTheme.bodyMedium),
          ],
          if (profile.createdAt != null) ...[
            const SizedBox(height: SpaceTokens.sm),
            Text('Joined ${RelativeTime.format(profile.createdAt)}',
                style: TypographyTokens.caption.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                )),
          ],
        ],
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({required this.items});
  final List<ObservationSummary> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SliverToBoxAdapter(
        child: AppEmptyState(
          icon: Icons.photo_library_outlined,
          title: 'No public sightings',
          message: 'This explorer has not shared any sightings yet.',
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.base),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: SpaceTokens.sm,
          crossAxisSpacing: SpaceTokens.sm,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, i) => _GridTile(observation: items[i]),
          childCount: items.length,
        ),
      ),
    );
  }
}

class _GridTile extends StatelessWidget {
  const _GridTile({required this.observation});
  final ObservationSummary observation;

  @override
  Widget build(BuildContext context) {
    final url = observation.primaryImageUrl;
    return GestureDetector(
      onTap: () =>
          context.push(AppRoutes.observationDetailPath(observation.id)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(RadiusTokens.md),
        child: (url == null || url.isEmpty)
            ? Container(
                color: ColorTokens.brandPrimary.withValues(alpha: 0.1),
                child: const Icon(Icons.image_outlined,
                    color: ColorTokens.brandPrimary),
              )
            : CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                memCacheWidth: (MediaQuery.sizeOf(context).width / 3 *
                        (MediaQuery.maybeOf(context)?.devicePixelRatio ?? 2.0))
                    .round(),
                placeholder: (_, __) => const Skeleton(borderRadius: 0),
                errorWidget: (_, __, ___) => Container(
                  color: ColorTokens.brandPrimary.withValues(alpha: 0.1),
                  child: const Icon(Icons.broken_image_outlined,
                      color: ColorTokens.brandPrimary),
                ),
              ),
      ),
    );
  }
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();
  @override
  Widget build(BuildContext context) => const SkeletonShimmer(
        child: Padding(
          padding: EdgeInsets.all(SpaceTokens.lg),
          child: Column(
            children: [
              Skeleton.circle(size: 88),
              SizedBox(height: SpaceTokens.md),
              Skeleton(width: 160, height: 22),
              SizedBox(height: SpaceTokens.sm),
              Skeleton(width: 100, height: 14),
              SizedBox(height: SpaceTokens.xl),
              _GridSkeleton(),
            ],
          ),
        ),
      );
}

class _GridSkeleton extends StatelessWidget {
  const _GridSkeleton();
  @override
  Widget build(BuildContext context) => GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: SpaceTokens.sm,
        crossAxisSpacing: SpaceTokens.sm,
        children: List.generate(
          6,
          (_) => const Skeleton(borderRadius: RadiusTokens.md),
        ),
      );
}
