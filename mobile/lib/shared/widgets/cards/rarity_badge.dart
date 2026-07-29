import 'package:flutter/material.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/theme/typography_tokens.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// RARITY TIER + BADGE
/// ─────────────────────────────────────────────────────────────────────────────

enum RarityTier {
  common('Common', ColorTokens.rarityCommon, Icons.circle),
  uncommon('Uncommon', ColorTokens.rarityUncommon, Icons.circle),
  rare('Rare', ColorTokens.rarityRare, Icons.star),
  veryRare('Very Rare', ColorTokens.rarityVeryRare, Icons.auto_awesome),
  endangered('Endangered', ColorTokens.rarityEndangered, Icons.warning_amber);

  const RarityTier(this.label, this.color, this.icon);
  final String label;
  final Color color;
  final IconData icon;

  static RarityTier fromString(String? s) => switch (s?.toLowerCase()) {
        'uncommon' => RarityTier.uncommon,
        'rare' => RarityTier.rare,
        'very_rare' || 'veryrare' => RarityTier.veryRare,
        'endangered' => RarityTier.endangered,
        _ => RarityTier.common,
      };
}

class RarityBadge extends StatelessWidget {
  const RarityBadge({super.key, required this.tier, this.compact = false});

  final RarityTier tier;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Rarity: ${tier.label}',
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? SpaceTokens.sm : SpaceTokens.md,
          vertical: compact ? 2 : SpaceTokens.xs,
        ),
        decoration: BoxDecoration(
          color: tier.color.withValues(alpha: 0.15),
          borderRadius: RadiusTokens.pillBR,
          border: Border.all(color: tier.color.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(tier.icon, size: compact ? 10 : 12, color: tier.color),
            if (!compact) ...[
              const SizedBox(width: SpaceTokens.xs),
              Text(
                tier.label.toUpperCase(),
                style: TypographyTokens.rarityLabel.copyWith(color: tier.color),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
