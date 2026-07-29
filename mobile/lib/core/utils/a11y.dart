import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// ACCESSIBILITY SYSTEM
/// Helpers for semantics, reduced-motion, haptics and minimum tap targets.
/// ─────────────────────────────────────────────────────────────────────────────

abstract class A11y {
  /// Minimum WCAG-compliant interactive tap target.
  static const double minTapTarget = 48.0;

  /// True when the OS has "reduce motion" enabled — animations should be
  /// shortened or skipped to respect the user's preference.
  static bool reduceMotion(BuildContext context) =>
      MediaQuery.maybeOf(context)?.disableAnimations ?? false;

  /// True when bold-text accessibility setting is on.
  static bool boldText(BuildContext context) =>
      MediaQuery.maybeOf(context)?.boldText ?? false;

  /// Clamped text scale — prevents layout breakage from extreme OS text scaling.
  static double clampedTextScale(
    BuildContext context, {
    double min = 0.85,
    double max = 1.4,
  }) {
    final scale = MediaQuery.maybeOf(context)?.textScaler.scale(1.0) ?? 1.0;
    return scale.clamp(min, max);
  }

  /// Wraps a widget to guarantee a minimum tap target size.
  static Widget ensureTapTarget(Widget child) => ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: minTapTarget,
          minHeight: minTapTarget,
        ),
        child: Center(child: child),
      );
}

/// ─────────────────────────────────────────────────────────────────────────────
/// HAPTIC SERVICE
/// Centralized tactile feedback library used across the app.
/// ─────────────────────────────────────────────────────────────────────────────

abstract class Haptics {
  static Future<void> light() => HapticFeedback.lightImpact();
  static Future<void> medium() => HapticFeedback.mediumImpact();
  static Future<void> heavy() => HapticFeedback.heavyImpact();
  static Future<void> selection() => HapticFeedback.selectionClick();
  static Future<void> vibrate() => HapticFeedback.vibrate();

  /// Success pattern — single sharp tap.
  static Future<void> success() => HapticFeedback.mediumImpact();

  /// Error pattern — two short taps.
  static Future<void> error() async {
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 120));
    await HapticFeedback.heavyImpact();
  }
}

/// Semantic wrapper for screen-reader-only labels.
class A11yLabel extends StatelessWidget {
  const A11yLabel({
    super.key,
    required this.label,
    required this.child,
    this.hint,
    this.button = false,
    this.excludeChildSemantics = true,
  });

  final String label;
  final String? hint;
  final Widget child;
  final bool button;
  final bool excludeChildSemantics;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      button: button,
      container: true,
      child: excludeChildSemantics
          ? ExcludeSemantics(child: child)
          : child,
    );
  }
}
