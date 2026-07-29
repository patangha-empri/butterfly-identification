import 'package:flutter/material.dart';
import '../../../core/theme/color_tokens.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// SCAN OVERLAY
/// Animated AI scan layer for the camera viewfinder. Renders corner brackets,
/// a sweeping scan line and a breathing reticle driven by [ScanState].
/// Full AI-flow choreography lands in Phase 6 — this is the reusable primitive.
/// ─────────────────────────────────────────────────────────────────────────────

enum ScanState { idle, detecting, scanning, locked, processing }

class ScanOverlay extends StatefulWidget {
  const ScanOverlay({
    super.key,
    this.state = ScanState.idle,
    this.color = ColorTokens.brandPrimaryLight,
    this.reticleSize = 260,
  });

  final ScanState state;
  final Color color;
  final double reticleSize;

  @override
  State<ScanOverlay> createState() => _ScanOverlayState();
}

class _ScanOverlayState extends State<ScanOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _sweep;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _sweep = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _sweep.dispose();
    _pulse.dispose();
    super.dispose();
  }

  Color get _stateColor => switch (widget.state) {
        ScanState.locked => ColorTokens.confidenceCertain,
        ScanState.scanning => widget.color,
        ScanState.detecting => ColorTokens.brandSecondary,
        ScanState.processing => ColorTokens.brandAccent,
        ScanState.idle => widget.color.withValues(alpha: 0.6),
      };

  @override
  Widget build(BuildContext context) {
    final showSweep = widget.state == ScanState.scanning ||
        widget.state == ScanState.detecting;

    return IgnorePointer(
      child: Semantics(
        label: 'Scanning for butterfly, status: ${widget.state.name}',
        child: AnimatedBuilder(
          animation: Listenable.merge([_sweep, _pulse]),
          builder: (context, _) {
            return CustomPaint(
              size: Size.infinite,
              painter: _ScanPainter(
                color: _stateColor,
                reticleSize: widget.reticleSize,
                sweepProgress: showSweep ? _sweep.value : -1,
                pulse: 0.96 + (_pulse.value * 0.08),
                locked: widget.state == ScanState.locked,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ScanPainter extends CustomPainter {
  _ScanPainter({
    required this.color,
    required this.reticleSize,
    required this.sweepProgress,
    required this.pulse,
    required this.locked,
  });

  final Color color;
  final double reticleSize;
  final double sweepProgress; // -1 = hidden, 0..1 = position
  final double pulse;
  final bool locked;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final boxSize = reticleSize * pulse;
    final rect = Rect.fromCenter(
      center: center,
      width: boxSize,
      height: boxSize,
    );

    // ── Dim the area outside the reticle ──────────────────────────────────
    final scrimPaint = Paint()..color = Colors.black.withValues(alpha: 0.45);
    final outerPath = Path()..addRect(Offset.zero & size);
    final innerPath = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(24)));
    canvas.drawPath(
      Path.combine(PathOperation.difference, outerPath, innerPath),
      scrimPaint,
    );

    // ── Corner brackets ───────────────────────────────────────────────────
    final bracketPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    const cornerLen = 28.0;
    void corner(Offset o, Offset hDir, Offset vDir) {
      canvas.drawLine(o, o + hDir * cornerLen, bracketPaint);
      canvas.drawLine(o, o + vDir * cornerLen, bracketPaint);
    }

    corner(rect.topLeft, const Offset(1, 0), const Offset(0, 1));
    corner(rect.topRight, const Offset(-1, 0), const Offset(0, 1));
    corner(rect.bottomLeft, const Offset(1, 0), const Offset(0, -1));
    corner(rect.bottomRight, const Offset(-1, 0), const Offset(0, -1));

    // ── Sweep line ────────────────────────────────────────────────────────
    if (sweepProgress >= 0) {
      final y = rect.top + rect.height * sweepProgress;
      final sweepPaint = Paint()
        ..shader = LinearGradient(
          colors: [
            color.withValues(alpha: 0),
            color.withValues(alpha: 0.8),
            color.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromLTRB(rect.left, y - 20, rect.right, y + 20))
        ..strokeWidth = 3;
      canvas.drawLine(
        Offset(rect.left, y),
        Offset(rect.right, y),
        sweepPaint,
      );
    }

    // ── Locked confirmation ring ──────────────────────────────────────────
    if (locked) {
      final ringPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(24)),
        ringPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_ScanPainter old) =>
      old.sweepProgress != sweepProgress ||
      old.pulse != pulse ||
      old.color != color ||
      old.locked != locked;
}
