import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/theme/typography_tokens.dart';
import '../../../core/utils/a11y.dart';
import '../loaders/skeleton.dart';
import 'rarity_badge.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// SPECIES CARD
/// Image-first card with cinematic gradient overlay, name, scientific name,
/// rarity badge and bookmark control. Hero-transition ready.
/// ─────────────────────────────────────────────────────────────────────────────

class SpeciesCard extends StatelessWidget {
  const SpeciesCard({
    super.key,
    required this.id,
    required this.commonName,
    required this.scientificName,
    this.imageUrl,
    this.rarity,
    this.onTap,
    this.isBookmarked = false,
    this.onBookmarkToggle,
    this.aspectRatio = 0.72,
    this.heroTag,
  });

  final String id;
  final String commonName;
  final String scientificName;
  final String? imageUrl;
  final RarityTier? rarity;
  final VoidCallback? onTap;
  final bool isBookmarked;
  final VoidCallback? onBookmarkToggle;
  final double aspectRatio;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$commonName, $scientificName'
          '${rarity != null ? ', ${rarity!.label}' : ''}',
      button: onTap != null,
      child: GestureDetector(
        onTap: () {
          if (onTap != null) {
            Haptics.light();
            onTap!();
          }
        },
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: ClipRRect(
            borderRadius: RadiusTokens.cardBR,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ── Image ────────────────────────────────────────────────
                _buildImage(),

                // ── Gradient scrim ───────────────────────────────────────
                const DecoratedBox(
                  decoration: BoxDecoration(gradient: ColorTokens.heroGradient),
                ),

                // ── Rarity badge (top-left) ──────────────────────────────
                if (rarity != null)
                  Positioned(
                    top: SpaceTokens.sm,
                    left: SpaceTokens.sm,
                    child: RarityBadge(tier: rarity!, compact: true),
                  ),

                // ── Bookmark (top-right) ─────────────────────────────────
                if (onBookmarkToggle != null)
                  Positioned(
                    top: SpaceTokens.xs,
                    right: SpaceTokens.xs,
                    child: _BookmarkButton(
                      isBookmarked: isBookmarked,
                      onToggle: onBookmarkToggle!,
                    ),
                  ),

                // ── Text content (bottom) ────────────────────────────────
                Positioned(
                  left: SpaceTokens.md,
                  right: SpaceTokens.md,
                  bottom: SpaceTokens.md,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        commonName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TypographyTokens.textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        scientificName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TypographyTokens.scientificName.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    final image = imageUrl == null || imageUrl!.isEmpty
        ? Container(
            color: ColorTokens.brandPrimary.withValues(alpha: 0.15),
            child: const Icon(Icons.flutter_dash,
                size: 48, color: ColorTokens.brandPrimary),
          )
        : CachedNetworkImage(
            imageUrl: imageUrl!,
            fit: BoxFit.cover,
            memCacheWidth: 600,
            placeholder: (_, __) =>
                const Skeleton(height: double.infinity, borderRadius: 0),
            errorWidget: (_, __, ___) => Container(
              color: ColorTokens.brandPrimary.withValues(alpha: 0.15),
              child: const Icon(Icons.broken_image_outlined,
                  color: ColorTokens.brandPrimary),
            ),
          );

    return heroTag != null ? Hero(tag: heroTag!, child: image) : image;
  }
}

class _BookmarkButton extends StatelessWidget {
  const _BookmarkButton({required this.isBookmarked, required this.onToggle});

  final bool isBookmarked;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: isBookmarked ? 'Remove bookmark' : 'Add bookmark',
      button: true,
      child: Material(
        color: Colors.black.withValues(alpha: 0.25),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            Haptics.selection();
            onToggle();
          },
          child: Padding(
            padding: const EdgeInsets.all(SpaceTokens.sm),
            child: AnimatedSwitcher(
              duration: DurationTokens.fast,
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                key: ValueKey(isBookmarked),
                size: 18,
                color: isBookmarked ? ColorTokens.brandAccent : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
