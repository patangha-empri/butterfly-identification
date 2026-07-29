import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/theme/design_tokens.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// SKELETON LOADERS
/// Shimmer placeholder primitives + composed skeletons for common layouts.
/// ─────────────────────────────────────────────────────────────────────────────

class Skeleton extends StatelessWidget {
  const Skeleton({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = RadiusTokens.sm,
    this.shape = BoxShape.rectangle,
  });

  /// Circle convenience constructor.
  const Skeleton.circle({super.key, required double size})
      : width = size,
        height = size,
        borderRadius = 0,
        shape = BoxShape.circle;

  final double? width;
  final double height;
  final double borderRadius;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? ColorTokens.surfaceVariantDark : ColorTokens.surfaceVariantLight,
        shape: shape,
        borderRadius: shape == BoxShape.circle
            ? null
            : BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// Wraps any subtree (composed of [Skeleton]s) in a shimmer sweep.
class SkeletonShimmer extends StatelessWidget {
  const SkeletonShimmer({super.key, required this.child, this.enabled = true});

  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark
          ? ColorTokens.surfaceVariantDark
          : ColorTokens.surfaceVariantLight,
      highlightColor: isDark
          ? ColorTokens.surfaceDark.withValues(alpha: 0.6)
          : Colors.white,
      period: DurationTokens.shimmer,
      child: child,
    );
  }
}

/// Pre-composed species card skeleton.
class SpeciesCardSkeleton extends StatelessWidget {
  const SpeciesCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SkeletonShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Skeleton(height: 140, borderRadius: RadiusTokens.card),
          SizedBox(height: SpaceTokens.sm),
          Skeleton(width: 120, height: 14),
          SizedBox(height: SpaceTokens.xs),
          Skeleton(width: 80, height: 11, borderRadius: RadiusTokens.xs),
        ],
      ),
    );
  }
}

/// Pre-composed list-tile skeleton (avatar + two lines).
class ListTileSkeleton extends StatelessWidget {
  const ListTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SkeletonShimmer(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: SpaceTokens.sm),
        child: Row(
          children: [
            Skeleton.circle(size: 48),
            SizedBox(width: SpaceTokens.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Skeleton(width: double.infinity, height: 14),
                  SizedBox(height: SpaceTokens.xs),
                  Skeleton(width: 140, height: 11),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Grid of skeleton cards for loading the species/discovery feed.
class SkeletonGrid extends StatelessWidget {
  const SkeletonGrid({super.key, this.itemCount = 6, this.crossAxisCount = 2});

  final int itemCount;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: SpaceTokens.pagePaddingAll,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: SpaceTokens.md,
        mainAxisSpacing: SpaceTokens.md,
        childAspectRatio: 0.72,
      ),
      itemCount: itemCount,
      itemBuilder: (_, __) => const SpeciesCardSkeleton(),
    );
  }
}
