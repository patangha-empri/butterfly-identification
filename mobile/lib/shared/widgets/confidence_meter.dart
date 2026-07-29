import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/color_tokens.dart';
import '../../core/theme/design_tokens.dart';
import '../../core/theme/typography_tokens.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// CONFIDENCE TIER
/// Maps a 0..1 AI confidence value → labelled, color-coded tier.
/// ─────────────────────────────────────────────────────────────────────────────

enum ConfidenceTier {
  certain('Certain', ColorTokens.confidenceCertain),
  likely('Likely', ColorTokens.confidenceLikely),
  possible('Possible', ColorTokens.confidencePossible),
  uncertain('Uncertain', ColorTokens.confidenceUncertain);

  const ConfidenceTier(this.label, this.color);
  final String label;
  final Color color;

  static ConfidenceTier fromValue(double v) {
    if (v >= AppConstants.certainConfidence) return ConfidenceTier.certain;
    if (v >= AppConstants.likelyConfidence) return ConfidenceTier.likely;
    if (v >= AppConstants.possibleConfidence) return ConfidenceTier.possible;
    return ConfidenceTier.uncertain;
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
/// CONFIDENCE METER (radial)
/// Animated arc gauge that fills with spring physics to [value] (0..1).
/// ─────────────────────────────────────────────────────────────────────────────

class ConfidenceMeter extends StatelessWidget {
  const ConfidenceMeter({
    super.key,
    required this.value,
    this.size = 140,
    this.strokeWidth = 12,
    this.showLabel = true,
    this.animate = true,
  }) : assert(value >= 0 && value <= 1);

  final double value;
  final double size;
  final double strokeWidth;
  final bool showLabel;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final tier = ConfidenceTier.fromValue(value);
    final pct = (value * 100).round();

    return Semantics(
      label: 'AI confidence ${tier.label}, $pct percent',
      child: SizedBox(
        width: size,
        height: size,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: value),
          duration: animate ? DurationTokens.cinematic : Duration.zero,
          curve: Curves.easeOutCubic,
          builder: (context, animValue, _) {
            return CustomPaint(
              painter: _ConfidenceArcPainter(
                value: animValue,
                color: tier.color,
                strokeWidth: strokeWidth,
                trackColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              child: showLabel
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${(animValue * 100).round()}%',
                            style: TypographyTokens.confidenceDisplay.copyWith(
                              fontSize: size * 0.26,
                              color: tier.color,
                            ),
                          ),
                          Text(
                            tier.label,
                            style: TypographyTokens.rarityLabel.copyWith(
                              color: tier.color,
                            ),
                          ),
                        ],
                      ),
                    )
                  : null,
            );
          },
        ),
      ),
    );
  }
}

class _ConfidenceArcPainter extends CustomPainter {
  _ConfidenceArcPainter({
    required this.value,
    required this.color,
    required this.strokeWidth,
    required this.trackColor,
  });

  final double value;
  final Color color;
  final double strokeWidth;
  final Color trackColor;

  static const double _startAngle = math.pi * 0.75;
  static const double _sweepRange = math.pi * 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, _startAngle, _sweepRange, false, trackPaint);

    // Progress with gradient
    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: _startAngle,
        endAngle: _startAngle + _sweepRange,
        colors: [color.withValues(alpha: 0.6), color],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, _startAngle, _sweepRange * value, false, progressPaint);

    // Glow dot at the tip
    if (value > 0.01) {
      final tipAngle = _startAngle + _sweepRange * value;
      final tip = Offset(
        center.dx + radius * math.cos(tipAngle),
        center.dy + radius * math.sin(tipAngle),
      );
      canvas.drawCircle(
        tip,
        strokeWidth * 0.5,
        Paint()
          ..color = color
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
    }
  }

  @override
  bool shouldRepaint(_ConfidenceArcPainter old) =>
      old.value != value || old.color != color;
}

/// ─────────────────────────────────────────────────────────────────────────────
/// CONFIDENCE BAR (linear)
/// Compact horizontal variant for ranked alternative match lists.
/// ─────────────────────────────────────────────────────────────────────────────

class ConfidenceBar extends StatelessWidget {
  const ConfidenceBar({
    super.key,
    required this.value,
    this.height = 6,
    this.showPercent = true,
    this.animate = true,
  });

  final double value;
  final double height;
  final bool showPercent;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final tier = ConfidenceTier.fromValue(value);
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(height),
            child: Stack(
              children: [
                Container(
                  height: height,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: value),
                  duration: animate ? DurationTokens.slower : Duration.zero,
                  curve: Curves.easeOutCubic,
                  builder: (context, v, _) => FractionallySizedBox(
                    widthFactor: v.clamp(0, 1),
                    child: Container(
                      height: height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [tier.color.withValues(alpha: 0.7), tier.color],
                        ),
                        borderRadius: BorderRadius.circular(height),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showPercent) ...[
          const SizedBox(width: SpaceTokens.sm),
          Text(
            '${(value * 100).round()}%',
            style: TypographyTokens.textTheme.labelSmall?.copyWith(
              color: tier.color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }
}
