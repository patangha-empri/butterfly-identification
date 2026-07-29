import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/utils/a11y.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// GLASS CARD
/// Frosted glassmorphic surface — the signature container of the app.
/// Falls back to a solid surface when reduce-motion / low-end devices need it.
/// ─────────────────────────────────────────────────────────────────────────────

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.blur = 18,
    this.opacity = 0.7,
    this.borderRadius = RadiusTokens.card,
    this.padding = SpaceTokens.cardPadding,
    this.margin,
    this.onTap,
    this.border = true,
    this.shadows,
    this.width,
    this.height,
    this.gradient,
    this.semanticLabel,
  });

  final Widget child;
  final double blur;
  final double opacity;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool border;
  final List<BoxShadow>? shadows;
  final double? width;
  final double? height;
  final Gradient? gradient;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = BorderRadius.circular(borderRadius);

    final surface = ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: gradient,
            color: gradient != null
                ? null
                : (isDark
                    ? Colors.white.withValues(alpha: opacity * 0.12)
                    : Colors.white.withValues(alpha: opacity)),
            border: border
                ? Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.12)
                        : Colors.white.withValues(alpha: 0.4),
                    width: 1.0,
                  )
                : null,
          ),
          child: child,
        ),
      ),
    );

    final withShadow = Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: shadows ?? ShadowTokens.md,
      ),
      child: surface,
    );

    final result = onTap != null
        ? Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Haptics.light();
                onTap!();
              },
              borderRadius: radius,
              child: withShadow,
            ),
          )
        : withShadow;

    if (semanticLabel != null) {
      return Semantics(
        label: semanticLabel,
        button: onTap != null,
        container: true,
        child: result,
      );
    }
    return result;
  }
}
