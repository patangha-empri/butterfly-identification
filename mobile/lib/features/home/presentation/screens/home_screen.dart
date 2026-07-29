import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/responsive/app_breakpoints.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/theme/motion_tokens.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../notifications/presentation/notification_providers.dart';
import '../../../gamification/presentation/gamification_providers.dart';
import '../../../../shared/widgets/cards/rarity_badge.dart';
import '../../../../shared/widgets/cards/species_card.dart';
import '../../../../shared/widgets/inputs/floating_search_bar.dart';
import '../../../../shared/widgets/loaders/skeleton.dart';
import '../../../../shared/widgets/sliver_section.dart';
import '../../../../shared/widgets/states/empty_state.dart';
import '../../data/models/home_feed.dart';
import '../../data/models/species_summary.dart';
import '../providers/home_providers.dart';
import '../widgets/quick_scan_card.dart';
import '../widgets/sighting_tile.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// HOME SCREEN
/// Immersive sliver-based discovery dashboard.
/// ─────────────────────────────────────────────────────────────────────────────

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(homeFeedProvider);
    await ref.read(homeFeedProvider.future);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(homeFeedProvider);
    final user = ref.watch(currentUserProvider);
    final firstName = (user?.fullName.split(' ').first) ?? 'Explorer';

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _refresh(ref),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            _HomeAppBar(firstName: firstName),

            // Search trigger
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  SpaceTokens.base,
                  SpaceTokens.sm,
                  SpaceTokens.base,
                  SpaceTokens.sm,
                ),
                child: FloatingSearchBar(
                  readOnly: true,
                  onTap: () => context.push(AppRoutes.search),
                ),
              ),
            ),

            // Quick scan CTA
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  SpaceTokens.base,
                  SpaceTokens.sm,
                  SpaceTokens.base,
                  SpaceTokens.sm,
                ),
                child: QuickScanCard(onTap: () => context.push(AppRoutes.aiScan)),
              ),
            ),

            // Explorer progress (gamification)
            const SliverToBoxAdapter(child: _ExplorerStrip()),

            ...feedAsync.when(
              loading: () => [const _LoadingSlivers()],
              error: (err, _) => [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppEmptyState.error(
                    message: err.toString(),
                    onRetry: () => ref.invalidate(homeFeedProvider),
                  ),
                ),
              ],
              data: (feed) => _buildFeedSlivers(context, ref, feed),
            ),

            // Clear the shell's bottom nav bar (extendBody) + gesture inset.
            SliverGap(MediaQuery.viewPaddingOf(context).bottom + 96),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFeedSlivers(
    BuildContext context,
    WidgetRef ref,
    HomeFeed feed,
  ) {
    if (feed.isEmpty) {
      return [
        const SliverFillRemaining(
          hasScrollBody: false,
          child: AppEmptyState(
            icon: Icons.travel_explore,
            title: 'Nothing to discover yet',
            message: 'Check back soon for trending butterflies and sightings.',
          ),
        ),
      ];
    }

    final cardHeight = AppBreakpoints.isTablet(context) ? 230.0 : 200.0;
    final cardWidth = AppBreakpoints.isTablet(context) ? 170.0 : 150.0;

    return [
      if (feed.fromCache) const _OfflineBanner(),

      if (feed.trending.isNotEmpty) ...[
        SliverSectionHeader(
          title: 'Trending now',
          subtitle: 'Most-spotted butterflies this week',
          actionLabel: 'See all',
          onAction: () => context.go(AppRoutes.speciesList),
        ),
        _SpeciesCarousel(
          species: feed.trending,
          height: cardHeight,
          width: cardWidth,
        ),
      ],

      if (feed.seasonal.isNotEmpty) ...[
        const SliverSectionHeader(
          title: 'In season',
          subtitle: 'Active in India right now',
        ),
        _SpeciesCarousel(
          species: feed.seasonal,
          height: cardHeight,
          width: cardWidth,
        ),
      ],

      if (feed.nearby.isNotEmpty) ...[
        const SliverSectionHeader(
          title: 'Nearby sightings',
          subtitle: 'Recently spotted around you',
        ),
        SliverHorizontalCarousel(
          itemCount: feed.nearby.length,
          height: 96,
          itemWidth: 300,
          itemBuilder: (ctx, i) {
            final o = feed.nearby[i];
            return SightingTile(
              observation: o,
              onTap: () => context.push(AppRoutes.observationDetailPath(o.id)),
            );
          },
        ),
      ],

      if (feed.recent.isNotEmpty) ...[
        const SliverSectionHeader(title: 'Recent community sightings'),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.base),
          sliver: SliverList.separated(
            itemCount: feed.recent.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (ctx, i) {
              final o = feed.recent[i];
              return SightingTile(
                observation: o,
                onTap: () =>
                    context.push(AppRoutes.observationDetailPath(o.id)),
              );
            },
          ),
        ),
      ],
    ];
  }
}

// ── Explorer strip (gamification entry point) ────────────────────────────────

class _ExplorerStrip extends ConsumerWidget {
  const _ExplorerStrip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(gamificationProfileProvider);
    final profile = async.valueOrNull;
    if (profile == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          SpaceTokens.base, SpaceTokens.sm, SpaceTokens.base, SpaceTokens.sm),
      child: Material(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: RadiusTokens.cardBR,
        child: InkWell(
          borderRadius: RadiusTokens.cardBR,
          onTap: () => context.push(AppRoutes.achievements),
          child: Padding(
            padding: const EdgeInsets.all(SpaceTokens.md),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: ColorTokens.brandPrimary,
                  child: Text('${profile.level}',
                      style: TypographyTokens.textTheme.titleSmall
                          ?.copyWith(color: Colors.white)),
                ),
                const SizedBox(width: SpaceTokens.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Level ${profile.level} Explorer',
                          style: TypographyTokens.textTheme.titleSmall),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: profile.xpForLevel > 0
                              ? profile.xpInLevel / profile.xpForLevel
                              : 0,
                          minHeight: 6,
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: SpaceTokens.md),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department,
                        size: 18, color: ColorTokens.brandAccent),
                    Text('${profile.streak.currentStreak}',
                        style: TypographyTokens.textTheme.labelLarge),
                  ],
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── App bar ─────────────────────────────────────────────────────────────────

class _HomeAppBar extends ConsumerWidget {
  const _HomeAppBar({required this.firstName});
  final String firstName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(unreadCountProvider).valueOrNull ?? 0;
    return SliverAppBar(
      pinned: true,
      floating: true,
      expandedHeight: 96,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.fromLTRB(
          SpaceTokens.base,
          0,
          SpaceTokens.base,
          SpaceTokens.md,
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🦋', style: TextStyle(fontSize: 20)),
            const SizedBox(width: SpaceTokens.sm),
            Flexible(
              child: Text(
                'Hi, $firstName',
                overflow: TextOverflow.ellipsis,
                style: TypographyTokens.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Badge(
            isLabelVisible: unread > 0,
            label: Text(unread > 99 ? '99+' : '$unread'),
            child: const Icon(Icons.notifications_outlined),
          ),
          onPressed: () => context.push(AppRoutes.notifications),
          tooltip: 'Notifications',
        ),
        const SizedBox(width: SpaceTokens.xs),
      ],
    );
  }
}

// ── Species carousel sliver ───────────────────────────────────────────────────

class _SpeciesCarousel extends StatelessWidget {
  const _SpeciesCarousel({
    required this.species,
    required this.height,
    required this.width,
  });

  final List<SpeciesSummary> species;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SliverHorizontalCarousel(
      itemCount: species.length,
      height: height,
      itemWidth: width,
      itemBuilder: (context, i) {
        final s = species[i];
        return SpeciesCard(
          id: s.id,
          commonName: s.commonName,
          scientificName: s.scientificName,
          imageUrl: s.primaryImageUrl,
          rarity: s.rarity != null ? RarityTier.fromString(s.rarity) : null,
          heroTag: 'species-${s.id}',
          onTap: () => context.push(AppRoutes.speciesDetailPath(s.id)),
        ).animateCard(index: i);
      },
    );
  }
}

// ── Loading skeletons ─────────────────────────────────────────────────────────

class _LoadingSlivers extends StatelessWidget {
  const _LoadingSlivers();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(
                SpaceTokens.base, SpaceTokens.lg, SpaceTokens.base, SpaceTokens.md),
            child: Skeleton(width: 160, height: 24),
          ),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.base),
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(width: SpaceTokens.md),
              itemBuilder: (_, __) =>
                  const SizedBox(width: 150, child: SpeciesCardSkeleton()),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(
                SpaceTokens.base, SpaceTokens.xl, SpaceTokens.base, SpaceTokens.sm),
            child: Skeleton(width: 200, height: 24),
          ),
          ...List.generate(
            4,
            (_) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: SpaceTokens.base),
              child: ListTileSkeleton(),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Offline banner ────────────────────────────────────────────────────────────

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(
            SpaceTokens.base, SpaceTokens.sm, SpaceTokens.base, 0),
        padding: const EdgeInsets.symmetric(
            horizontal: SpaceTokens.md, vertical: SpaceTokens.sm),
        decoration: BoxDecoration(
          color: ColorTokens.warning.withValues(alpha: 0.12),
          borderRadius: RadiusTokens.buttonBR,
        ),
        child: Row(
          children: [
            const Icon(Icons.cloud_off, size: 16, color: ColorTokens.warning),
            const SizedBox(width: SpaceTokens.sm),
            Expanded(
              child: Text(
                'Showing saved content — you appear to be offline.',
                style: TypographyTokens.caption
                    .copyWith(color: ColorTokens.warning),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
