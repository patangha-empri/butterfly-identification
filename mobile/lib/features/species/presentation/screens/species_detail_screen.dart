import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/responsive/app_breakpoints.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../../../core/utils/a11y.dart';
import '../../../../shared/widgets/buttons/circle_back_button.dart';
import '../../../../shared/widgets/cards/rarity_badge.dart';
import '../../../../shared/widgets/cards/species_card.dart';
import '../../../../shared/widgets/cards/species_insights_card.dart';
import '../../../../shared/widgets/loaders/skeleton.dart';
import '../../../../shared/widgets/sliver_section.dart';
import '../../../../shared/widgets/states/empty_state.dart';
import '../../data/models/species_detail.dart';
import '../providers/species_providers.dart';
import '../widgets/flight_calendar.dart';
import '../widgets/species_gallery.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// SPECIES DETAIL SCREEN (replaces the Phase 3 stub)
/// Cinematic hero gallery + rich sections; adaptive two-panel on tablets.
/// ─────────────────────────────────────────────────────────────────────────────

class SpeciesDetailScreen extends ConsumerWidget {
  const SpeciesDetailScreen({super.key, required this.speciesId});

  final String speciesId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(speciesDetailProvider(speciesId));

    return Scaffold(
      body: detailAsync.when(
        loading: () => const _DetailSkeleton(),
        error: (err, _) => SafeArea(
          child: AppEmptyState.error(
            message: err.toString(),
            onRetry: () => ref.invalidate(speciesDetailProvider(speciesId)),
          ),
        ),
        data: (detail) => AppBreakpoints.isTablet(context)
            ? _TabletLayout(detail: detail)
            : _PhoneLayout(detail: detail),
      ),
    );
  }
}

// ── Phone layout (collapsing hero + scroll) ──────────────────────────────────

class _PhoneLayout extends ConsumerWidget {
  const _PhoneLayout({required this.detail});
  final SpeciesDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 320,
          pinned: true,
          leading: const CircleBackButton(),
          actions: [_BookmarkAction(detail: detail)],
          flexibleSpace: FlexibleSpaceBar(
            background: SpeciesGallery(
              imageUrls: detail.galleryUrls,
              heroTag: 'species-list-${detail.id}',
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(SpaceTokens.lg),
          sliver: SliverList.list(children: _content(context, ref, detail)),
        ),
        ..._similarSlivers(context, ref, detail.id),
        SliverGap(32 + MediaQuery.viewPaddingOf(context).bottom),
      ],
    );
  }
}

// ── Tablet layout (gallery left / info right) ────────────────────────────────

class _TabletLayout extends ConsumerWidget {
  const _TabletLayout({required this.detail});
  final SpeciesDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                Positioned.fill(
                  child: SpeciesGallery(
                    imageUrls: detail.galleryUrls,
                    heroTag: 'species-list-${detail.id}',
                  ),
                ),
                const Positioned(top: 8, left: 8, child: CircleBackButton()),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(SpaceTokens.xl),
                  sliver: SliverList.list(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: _BookmarkAction(detail: detail),
                      ),
                      ..._content(context, ref, detail),
                    ],
                  ),
                ),
                ..._similarSlivers(context, ref, detail.id),
                const SliverGap(32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared content blocks ─────────────────────────────────────────────────────

List<Widget> _content(BuildContext context, WidgetRef ref, SpeciesDetail d) {
  return [
    Row(
      children: [
        if (d.rarity != null) ...[
          RarityBadge(tier: RarityTier.fromString(d.rarity)),
          const SizedBox(width: SpaceTokens.sm),
        ],
        if (d.conservationStatus != null)
          _Chip(label: d.conservationStatus!, icon: Icons.shield_outlined),
      ],
    ),
    const SizedBox(height: SpaceTokens.md),
    Text(d.commonName, style: TypographyTokens.textTheme.headlineMedium),
    const SizedBox(height: 2),
    Text(
      d.scientificName,
      style: TypographyTokens.scientificName.copyWith(
        fontSize: 16,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    ),
    if (d.family != null) ...[
      const SizedBox(height: SpaceTokens.xs),
      Text(
        [d.family, d.subfamily].whereType<String>().join(' · '),
        style: TypographyTokens.textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    ],

    // Stats row
    const SizedBox(height: SpaceTokens.lg),
    Wrap(
      spacing: SpaceTokens.xxl,
      runSpacing: SpaceTokens.md,
      children: [
        if (d.wingspanMm != null)
          _Stat(label: 'Wingspan', value: d.wingspanMm!),
        _Stat(label: 'Sightings', value: '${d.observationCount}'),
      ],
    ),

    if ((d.description ?? d.descriptionShort) != null) ...[
      const _SectionTitle('About'),
      Text(
        d.description ?? d.descriptionShort!,
        style: TypographyTokens.textTheme.bodyLarge?.copyWith(height: 1.6),
      ),
    ],

    if (d.hasFlightData) ...[
      const _SectionTitle('Flight season'),
      FlightCalendar(activeMonths: d.flightMonths),
    ],

    if (d.hasHostPlants) ...[
      const _SectionTitle('Host plants'),
      Wrap(
        spacing: SpaceTokens.sm,
        runSpacing: SpaceTokens.sm,
        children: d.hostPlants
            .map((h) => _HostPlantChip(plant: h))
            .toList(),
      ),
    ],

    SpeciesInsightsCard.fromDetail(d),
  ];
}

List<Widget> _similarSlivers(BuildContext context, WidgetRef ref, String id) {
  final similarAsync = ref.watch(similarSpeciesProvider(id));
  final similar = similarAsync.valueOrNull ?? [];
  if (similar.isEmpty) return [];
  return [
    const SliverSectionHeader(title: 'Similar species'),
    SliverHorizontalCarousel(
      itemCount: similar.length,
      height: 200,
      itemWidth: 150,
      itemBuilder: (context, i) {
        final s = similar[i];
        return SpeciesCard(
          id: s.id,
          commonName: s.commonName,
          scientificName: s.scientificName,
          imageUrl: s.primaryImageUrl,
          rarity: s.rarity != null ? RarityTier.fromString(s.rarity) : null,
          onTap: () => context.push(AppRoutes.speciesDetailPath(s.id)),
        );
      },
    ),
  ];
}

// ── Small components ──────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(
          top: SpaceTokens.xl,
          bottom: SpaceTokens.sm,
        ),
        child: Text(text, style: TypographyTokens.textTheme.titleLarge),
      );
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: SpaceTokens.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: TypographyTokens.statNumber),
            Text(
              label,
              style: TypographyTokens.caption.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.icon});
  final String label;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: SpaceTokens.md,
          vertical: SpaceTokens.xs,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: RadiusTokens.pillBR,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: SpaceTokens.xs),
            Text(label, style: TypographyTokens.textTheme.labelSmall),
          ],
        ),
      );
}

class _HostPlantChip extends StatelessWidget {
  const _HostPlantChip({required this.plant});
  final HostPlant plant;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: SpaceTokens.md,
          vertical: SpaceTokens.sm,
        ),
        decoration: BoxDecoration(
          color: ColorTokens.brandPrimary.withValues(alpha: 0.1),
          borderRadius: RadiusTokens.buttonBR,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_florist_outlined,
                size: 14, color: ColorTokens.brandPrimary),
            const SizedBox(width: SpaceTokens.xs),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(plant.name,
                    style: TypographyTokens.textTheme.labelMedium),
                if (plant.scientificName != null)
                  Text(plant.scientificName!,
                      style: TypographyTokens.scientificName
                          .copyWith(fontSize: 10)),
              ],
            ),
          ],
        ),
      );
}

class _BookmarkAction extends ConsumerWidget {
  const _BookmarkAction({required this.detail});
  final SpeciesDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(bookmarkedSpeciesProvider).valueOrNull ?? {};
    final isBookmarked = bookmarks.contains(detail.id) || detail.isBookmarked;
    return Padding(
      padding: const EdgeInsets.all(SpaceTokens.sm),
      child: CircleAvatar(
        backgroundColor: Colors.black.withValues(alpha: 0.35),
        child: IconButton(
          tooltip: isBookmarked ? 'Remove bookmark' : 'Save species',
          icon: Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: isBookmarked ? ColorTokens.brandAccent : Colors.white,
          ),
          onPressed: () {
            Haptics.selection();
            ref.read(speciesRepositoryProvider).toggleBookmark(detail.id);
          },
        ),
      ),
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();
  @override
  Widget build(BuildContext context) {
    return SkeletonShimmer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          Skeleton(height: 320, borderRadius: 0),
          Padding(
            padding: EdgeInsets.all(SpaceTokens.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton(width: 200, height: 28),
                SizedBox(height: SpaceTokens.sm),
                Skeleton(width: 140, height: 16),
                SizedBox(height: SpaceTokens.xl),
                Skeleton(width: double.infinity, height: 14),
                SizedBox(height: SpaceTokens.sm),
                Skeleton(width: double.infinity, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
