import 'package:flutter/material.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// DESIGN TOKEN SYSTEM
/// Spacing, radii, elevations, durations, shadows — all named constants.
/// ─────────────────────────────────────────────────────────────────────────────

abstract class SpaceTokens {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double base = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 40.0;
  static const double huge = 48.0;
  static const double massive = 64.0;

  // ── Page padding ─────────────────────────────────────────────────────────
  static const EdgeInsets pagePaddingH = EdgeInsets.symmetric(horizontal: base);
  static const EdgeInsets pagePaddingAll = EdgeInsets.all(base);
  static const EdgeInsets cardPadding = EdgeInsets.all(base);
  static const EdgeInsets chipPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: xs,
  );
}

abstract class RadiusTokens {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double base = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 28.0;
  static const double card = 20.0;
  static const double pill = 999.0;
  static const double button = 14.0;
  static const double bottomSheet = 24.0;
  static const double dialog = 20.0;

  static BorderRadius get cardBR => BorderRadius.circular(card);
  static BorderRadius get buttonBR => BorderRadius.circular(button);
  static BorderRadius get pillBR => BorderRadius.circular(pill);
  static BorderRadius get bottomSheetBR => const BorderRadius.only(
    topLeft: Radius.circular(bottomSheet),
    topRight: Radius.circular(bottomSheet),
  );
}

abstract class ShadowTokens {
  // ── Soft surface shadow ───────────────────────────────────────────────────
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 32,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> xl = [
    BoxShadow(
      color: Color(0x22000000),
      blurRadius: 48,
      offset: Offset(0, 16),
    ),
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  // ── Colored brand shadow ──────────────────────────────────────────────────
  static const List<BoxShadow> brand = [
    BoxShadow(
      color: Color(0x3D1F6E5A),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> accent = [
    BoxShadow(
      color: Color(0x3DFF8A3D),
      blurRadius: 20,
      offset: Offset(0, 6),
    ),
  ];
}

abstract class DurationTokens {
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 450);
  static const Duration slower = Duration(milliseconds: 600);
  static const Duration cinematic = Duration(milliseconds: 900);
  static const Duration pageTransition = Duration(milliseconds: 350);
  static const Duration shimmer = Duration(milliseconds: 1200);
  static const Duration splash = Duration(milliseconds: 2200);
}

abstract class CurveTokens {
  static const Curve standard = Curves.easeInOut;
  static const Curve decelerate = Curves.easeOutCubic;
  static const Curve accelerate = Curves.easeInCubic;
  static const Curve spring = Curves.elasticOut;
  static const Curve smooth = Curves.easeOutQuart;
  static const Curve bounce = Curves.bounceOut;
  static const Curve overshoot = Curves.elasticOut;
}

abstract class ElevationTokens {
  static const double none = 0.0;
  static const double xs = 1.0;
  static const double sm = 2.0;
  static const double md = 4.0;
  static const double lg = 8.0;
  static const double xl = 12.0;
  static const double floatingButton = 6.0;
  static const double bottomSheet = 16.0;
  static const double dialog = 24.0;
}
