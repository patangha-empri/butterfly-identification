import 'dart:ui';
import 'package:flutter/material.dart';
import 'color_tokens.dart';
import 'design_tokens.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// GLASSMORPHISM TOKEN SYSTEM
/// Reusable BackdropFilter + BoxDecoration combos for glass surfaces.
/// ─────────────────────────────────────────────────────────────────────────────

abstract class GlassTokens {
  // ── Blur levels ───────────────────────────────────────────────────────────
  static const double blurLight = 8.0;
  static const double blurMedium = 16.0;
  static const double blurHeavy = 28.0;
  static const double blurMax = 40.0;

  // ── Light glass ───────────────────────────────────────────────────────────
  static BoxDecoration glassDecoration({
    bool isDark = false,
    double blurRadius = blurMedium,
    double opacity = 0.75,
    double borderOpacity = 0.2,
    double borderRadius = RadiusTokens.card,
    List<BoxShadow>? shadows,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      color: isDark
          ? Colors.black.withValues(alpha:opacity * 0.6)
          : Colors.white.withValues(alpha:opacity),
      border: Border.all(
        color: isDark
            ? Colors.white.withValues(alpha:borderOpacity * 0.5)
            : Colors.white.withValues(alpha:borderOpacity),
        width: 1.0,
      ),
      boxShadow: shadows ?? ShadowTokens.md,
    );
  }

  // ── Presets ───────────────────────────────────────────────────────────────
  static const BoxDecoration lightCard = BoxDecoration(
    color: ColorTokens.glassLight,
    borderRadius: BorderRadius.all(Radius.circular(RadiusTokens.card)),
    border: Border.fromBorderSide(
      BorderSide(color: ColorTokens.glassBorderLight, width: 1.0),
    ),
    boxShadow: ShadowTokens.md,
  );

  static const BoxDecoration darkCard = BoxDecoration(
    color: ColorTokens.glassDark,
    borderRadius: BorderRadius.all(Radius.circular(RadiusTokens.card)),
    border: Border.fromBorderSide(
      BorderSide(color: ColorTokens.glassBorderDark, width: 1.0),
    ),
    boxShadow: ShadowTokens.md,
  );

  static BoxDecoration navBar({required bool isDark}) => BoxDecoration(
    color: isDark
        ? const Color(0xBB1A2535)
        : const Color(0xCCF8F6F1),
    border: Border(
      top: BorderSide(
        color: isDark
            ? Colors.white.withValues(alpha:0.06)
            : Colors.black.withValues(alpha:0.06),
        width: 0.5,
      ),
    ),
  );
}

/// A widget wrapper that applies a BackdropFilter gaussian blur
/// then renders [child] on top of a semi-transparent glass surface.
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.blur = GlassTokens.blurMedium,
    this.opacity = 0.75,
    this.borderRadius = RadiusTokens.card,
    this.borderOpacity = 0.2,
    this.padding,
    this.isDark = false,
    this.shadows,
    this.constraints,
  });

  final Widget child;
  final double blur;
  final double opacity;
  final double borderRadius;
  final double borderOpacity;
  final EdgeInsetsGeometry? padding;
  final bool isDark;
  final List<BoxShadow>? shadows;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          constraints: constraints,
          decoration: GlassTokens.glassDecoration(
            isDark: isDark,
            blurRadius: blur,
            opacity: opacity,
            borderOpacity: borderOpacity,
            borderRadius: borderRadius,
            shadows: shadows,
          ),
          child: child,
        ),
      ),
    );
  }
}
