import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/color_tokens.dart';
import '../../core/theme/design_tokens.dart';
import '../../core/theme/typography_tokens.dart';
import '../../core/utils/a11y.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// ANIMATED BOTTOM NAV
/// Floating glassmorphic bottom navigation with animated indicator pill,
/// icon morph (outlined ↔ filled) and a central elevated scan FAB slot.
/// ─────────────────────────────────────────────────────────────────────────────

class AnimatedNavItem {
  const AnimatedNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
  final IconData icon;
  final IconData activeIcon;
  final String label;
}

class AnimatedBottomNav extends StatelessWidget {
  const AnimatedBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.centerButton,
  });

  final List<AnimatedNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Widget? centerButton;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPad = MediaQuery.viewPaddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        SpaceTokens.base,
        0,
        SpaceTokens.base,
        bottomPad > 0 ? bottomPad : SpaceTokens.md,
      ),
      child: ClipRRect(
        borderRadius: RadiusTokens.pillBR,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.sm),
            decoration: BoxDecoration(
              color: isDark
                  ? ColorTokens.surfaceDark.withValues(alpha: 0.75)
                  : Colors.white.withValues(alpha: 0.8),
              borderRadius: RadiusTokens.pillBR,
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.white.withValues(alpha: 0.5),
              ),
              boxShadow: ShadowTokens.lg,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (int i = 0; i < items.length; i++)
                  _NavButton(
                    item: items[i],
                    isActive: i == currentIndex,
                    onTap: () {
                      Haptics.selection();
                      onTap(i);
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final AnimatedNavItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? ColorTokens.brandPrimary
        : Theme.of(context).colorScheme.onSurfaceVariant;

    return Semantics(
      label: item.label,
      selected: isActive,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: RadiusTokens.pillBR,
        child: AnimatedContainer(
          duration: DurationTokens.normal,
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: isActive ? SpaceTokens.base : SpaceTokens.md,
            vertical: SpaceTokens.sm,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? ColorTokens.brandPrimary.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: RadiusTokens.pillBR,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: DurationTokens.fast,
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: Icon(
                  isActive ? item.activeIcon : item.icon,
                  key: ValueKey(isActive),
                  size: 22,
                  color: color,
                ),
              ),
              // Animated label reveal only when active
              ClipRect(
                child: AnimatedAlign(
                  duration: DurationTokens.normal,
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.centerLeft,
                  widthFactor: isActive ? 1.0 : 0.0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: SpaceTokens.sm),
                    child: Text(
                      item.label,
                      style: TypographyTokens.textTheme.labelMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
