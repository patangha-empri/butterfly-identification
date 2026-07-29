import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'design_tokens.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// MOTION SYSTEM
/// Centralized animation rules — every widget pulls from these presets so motion
/// feels consistent and cinematic across the entire app.
/// ─────────────────────────────────────────────────────────────────────────────

abstract class MotionTokens {
  // ── Entrance: fade + slide up ───────────────────────────────────────────────
  static List<Effect> fadeSlideUp({
    Duration? duration,
    Duration? delay,
    double offset = 24,
  }) =>
      [
        FadeEffect(
          duration: duration ?? DurationTokens.slow,
          delay: delay,
          curve: CurveTokens.decelerate,
        ),
        MoveEffect(
          begin: Offset(0, offset),
          end: Offset.zero,
          duration: duration ?? DurationTokens.slow,
          delay: delay,
          curve: CurveTokens.decelerate,
        ),
      ];

  // ── Entrance: fade + scale (cards/badges) ──────────────────────────────────
  static List<Effect> fadeScale({
    Duration? duration,
    Duration? delay,
    double beginScale = 0.92,
  }) =>
      [
        FadeEffect(
          duration: duration ?? DurationTokens.normal,
          delay: delay,
          curve: CurveTokens.decelerate,
        ),
        ScaleEffect(
          begin: Offset(beginScale, beginScale),
          end: const Offset(1, 1),
          duration: duration ?? DurationTokens.normal,
          delay: delay,
          curve: CurveTokens.decelerate,
        ),
      ];

  // ── Pop entrance (achievement / badge reveal) ───────────────────────────────
  static List<Effect> popIn({Duration? delay}) => [
        ScaleEffect(
          begin: const Offset(0, 0),
          end: const Offset(1, 1),
          duration: DurationTokens.slower,
          delay: delay,
          curve: Curves.elasticOut,
        ),
        FadeEffect(
          duration: DurationTokens.fast,
          delay: delay,
        ),
      ];

  // ── Shimmer (loading) ───────────────────────────────────────────────────────
  static List<Effect> shimmer({Duration? duration}) => [
        ShimmerEffect(
          duration: duration ?? DurationTokens.shimmer,
          color: Colors.white.withValues(alpha: 0.35),
          angle: 0.5,
        ),
      ];

  // ── Pulse (scan reticle, live indicators) ───────────────────────────────────
  static List<Effect> pulse({double minScale = 0.96, double maxScale = 1.04}) =>
      [
        ScaleEffect(
          begin: Offset(minScale, minScale),
          end: Offset(maxScale, maxScale),
          duration: DurationTokens.slower,
          curve: Curves.easeInOut,
        ),
      ];

  // ── Staggered list helper ───────────────────────────────────────────────────
  static Duration staggerDelay(int index, {int stepMs = 60, int maxMs = 600}) {
    final ms = (index * stepMs).clamp(0, maxMs);
    return Duration(milliseconds: ms);
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
/// ANIMATION EXTENSIONS
/// Sugar to apply standard motion to any widget:
///   MyWidget().animateEntrance(index: 2)
/// ─────────────────────────────────────────────────────────────────────────────

extension WidgetMotionX on Widget {
  /// Standard entrance — fade + slide up, optionally staggered by [index].
  Widget animateEntrance({int index = 0, Duration? duration}) => animate(
        delay: MotionTokens.staggerDelay(index),
      ).addEffects(MotionTokens.fadeSlideUp(duration: duration));

  /// Card entrance — fade + scale.
  Widget animateCard({int index = 0}) => animate(
        delay: MotionTokens.staggerDelay(index),
      ).addEffects(MotionTokens.fadeScale());

  /// Pop-in for badges / rewards.
  Widget animatePop({Duration? delay}) =>
      animate(delay: delay).addEffects(MotionTokens.popIn());

  /// Infinite gentle pulse.
  Widget animatePulse() =>
      animate(onPlay: (c) => c.repeat(reverse: true)).addEffects(MotionTokens.pulse());
}
