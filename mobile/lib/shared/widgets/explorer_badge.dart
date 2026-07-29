import 'package:flutter/material.dart';
import '../../core/theme/color_tokens.dart';
import '../../core/theme/design_tokens.dart';
import '../../core/theme/typography_tokens.dart';
import '../../core/theme/motion_tokens.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// EXPLORER BADGE
/// Gamification achievement badge with tier ring, icon and optional lock state.
/// ─────────────────────────────────────────────────────────────────────────────

enum BadgeTier {
  bronze(ColorTokens.bronzeBadge),
  silver(ColorTokens.silverBadge),
  gold(ColorTokens.goldBadge),
  legendary(ColorTokens.xpColor);

  const BadgeTier(this.color);
  final Color color;
}

class ExplorerBadge extends StatelessWidget {
  const ExplorerBadge({
    super.key,
    required this.icon,
    required this.label,
    this.tier = BadgeTier.bronze,
    this.size = 88,
    this.isLocked = false,
    this.isNew = false,
    this.onTap,
    this.animateOnAppear = true,
  });

  final IconData icon;
  final String label;
  final BadgeTier tier;
  final double size;
  final bool isLocked;
  final bool isNew;
  final VoidCallback? onTap;
  final bool animateOnAppear;

  @override
  Widget build(BuildContext context) {
    final color = isLocked ? ColorTokens.rarityCommon : tier.color;

    final badge = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isLocked
                    ? null
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          color.withValues(alpha: 0.9),
                          color.withValues(alpha: 0.5),
                        ],
                      ),
                color: isLocked
                    ? Theme.of(context).colorScheme.surfaceContainerHighest
                    : null,
                boxShadow: isLocked
                    ? null
                    : [
                        BoxShadow(
                          color: color.withValues(alpha: 0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                border: Border.all(
                  color: color.withValues(alpha: isLocked ? 0.3 : 0.8),
                  width: 2,
                ),
              ),
              child: Icon(
                isLocked ? Icons.lock_outline : icon,
                size: size * 0.4,
                color: isLocked
                    ? ColorTokens.textTertiaryLight
                    : Colors.white,
              ),
            ),
            if (isNew && !isLocked)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SpaceTokens.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: ColorTokens.error,
                    borderRadius: RadiusTokens.pillBR,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Text(
                    'NEW',
                    style: TypographyTokens.rarityLabel.copyWith(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: SpaceTokens.sm),
        SizedBox(
          width: size + 16,
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TypographyTokens.textTheme.labelSmall?.copyWith(
              color: isLocked
                  ? ColorTokens.textTertiaryLight
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );

    final wrapped = Semantics(
      label: '$label badge, ${tier.name}${isLocked ? ', locked' : ', unlocked'}',
      button: onTap != null,
      child: onTap != null
          ? GestureDetector(onTap: onTap, child: badge)
          : badge,
    );

    return animateOnAppear && !isLocked ? wrapped.animatePop() : wrapped;
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
/// XP PROGRESS BAR — explorer level progression
/// ─────────────────────────────────────────────────────────────────────────────

class XpProgressBar extends StatelessWidget {
  const XpProgressBar({
    super.key,
    required this.currentXp,
    required this.levelXp,
    required this.level,
    this.height = 10,
  });

  final int currentXp;
  final int levelXp;
  final int level;
  final double height;

  @override
  Widget build(BuildContext context) {
    final progress = levelXp > 0 ? (currentXp / levelXp).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Level $level',
              style: TypographyTokens.textTheme.labelMedium?.copyWith(
                color: ColorTokens.xpColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '$currentXp / $levelXp XP',
              style: TypographyTokens.textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: SpaceTokens.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(height),
          child: Stack(
            children: [
              Container(
                height: height,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: progress),
                duration: DurationTokens.cinematic,
                curve: Curves.easeOutCubic,
                builder: (context, v, _) => FractionallySizedBox(
                  widthFactor: v,
                  child: Container(
                    height: height,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ColorTokens.xpColor.withValues(alpha: 0.7),
                          ColorTokens.xpColor,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(height),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
