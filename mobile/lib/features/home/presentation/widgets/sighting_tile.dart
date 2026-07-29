import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../../../core/utils/a11y.dart';
import '../../../../shared/widgets/confidence_meter.dart';
import '../../../../shared/widgets/loaders/skeleton.dart';
import '../../data/models/observation_summary.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// SIGHTING TILE
/// Horizontal observation row used in the "Recent sightings" feed.
/// ─────────────────────────────────────────────────────────────────────────────

class SightingTile extends StatelessWidget {
  const SightingTile({
    super.key,
    required this.observation,
    this.onTap,
    this.onPrivacyChanged,
    this.isPrivacyLoading = false,
  });

  final ObservationSummary observation;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onPrivacyChanged;
  final bool isPrivacyLoading;

  @override
  Widget build(BuildContext context) {
    final title = observation.identifiedSpeciesName ??
        observation.title ??
        'Unidentified sighting';
    final subtitle = observation.locationName ??
        observation.stateName ??
        'Location unknown';

    return Semantics(
      button: onTap != null,
      label: '$title at $subtitle',
      child: InkWell(
        onTap: onTap == null
            ? null
            : () {
                Haptics.light();
                onTap!();
              },
        borderRadius: RadiusTokens.cardBR,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: SpaceTokens.sm,
            horizontal: SpaceTokens.xs,
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(RadiusTokens.md),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: _image(),
                ),
              ),
              const SizedBox(width: SpaceTokens.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TypographyTokens.textTheme.titleSmall,
                          ),
                        ),
                        if (observation.verificationStatus == 'rejected') ...[
                          const SizedBox(width: SpaceTokens.xs),
                          const _RejectedChip(),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.place_outlined,
                            size: 12,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TypographyTokens.caption.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (observation.identificationConfidence != null) ...[
                      const SizedBox(height: SpaceTokens.xs),
                      ConfidenceBar(
                        value: observation.identificationConfidence!,
                        height: 4,
                        animate: false,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: SpaceTokens.sm),
              _LikeChip(count: observation.likeCount),
              if (onPrivacyChanged != null) ...[
                const SizedBox(width: SpaceTokens.sm),
                isPrivacyLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Switch(
                        value: observation.privacy == 'public',
                        activeColor: ColorTokens.brandPrimary,
                        onChanged: onPrivacyChanged,
                      ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _image() {
    if (observation.primaryImageUrl == null ||
        observation.primaryImageUrl!.isEmpty) {
      return Container(
        color: ColorTokens.brandPrimary.withValues(alpha: 0.12),
        child: const Icon(Icons.image_outlined,
            color: ColorTokens.brandPrimary, size: 24),
      );
    }
    return CachedNetworkImage(
      imageUrl: observation.primaryImageUrl!,
      fit: BoxFit.cover,
      memCacheWidth: 256,
      placeholder: (_, __) => const Skeleton(height: 64, borderRadius: 0),
      errorWidget: (_, __, ___) => Container(
        color: ColorTokens.brandPrimary.withValues(alpha: 0.12),
        child: const Icon(Icons.broken_image_outlined,
            color: ColorTokens.brandPrimary, size: 20),
      ),
    );
  }
}

class _RejectedChip extends StatelessWidget {
  const _RejectedChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: ColorTokens.error.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        'Rejected',
        style: TypographyTokens.caption.copyWith(
          color: ColorTokens.error,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _LikeChip extends StatelessWidget {
  const _LikeChip({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.favorite,
            size: 16, color: ColorTokens.error.withValues(alpha: 0.8)),
        const SizedBox(height: 2),
        Text('$count', style: TypographyTokens.caption),
      ],
    );
  }
}
