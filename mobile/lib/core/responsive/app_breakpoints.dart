import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// ADAPTIVE BREAKPOINT SYSTEM
/// Named breakpoints covering phones → foldables → tablets → large tablets
/// ─────────────────────────────────────────────────────────────────────────────

abstract class AppBreakpoints {
  // ── Width thresholds (dp) ─────────────────────────────────────────────────
  static const double mobileSmall = 320;
  static const double mobileMedium = 375;
  static const double mobileLarge = 430;
  static const double foldableClosed = 480;
  static const double tabletSmall = 600;
  static const double tabletMedium = 768;
  static const double tabletLarge = 900;
  static const double tabletXL = 1080;
  static const double desktop = 1280;

  // ── Named tag constants ───────────────────────────────────────────────────
  static const String mobileTag = 'MOBILE';
  static const String foldableTag = 'FOLDABLE';
  static const String tabletTag = 'TABLET';
  static const String tabletLargeTag = 'TABLET_LARGE';
  static const String desktopTag = 'DESKTOP';

  // ── ResponsiveFramework breakpoints ──────────────────────────────────────
  static List<Breakpoint> get breakpoints => [
    const Breakpoint(start: 0, end: 479, name: mobileTag),
    const Breakpoint(start: 480, end: 599, name: foldableTag),
    const Breakpoint(start: 600, end: 899, name: tabletTag),
    const Breakpoint(start: 900, end: 1079, name: tabletLargeTag),
    const Breakpoint(start: 1080, end: double.infinity, name: desktopTag),
  ];

  // ── Convenience helpers ───────────────────────────────────────────────────
  // Width-based + null-safe: work with OR without a ResponsiveBreakpoints
  // ancestor, so individual screens are testable in isolation and never crash
  // if shown outside the responsive scope.

  static double _width(BuildContext context) => MediaQuery.sizeOf(context).width;

  /// Phone-class width (< 600dp). Includes folded foldables.
  static bool isMobile(BuildContext context) => _width(context) < tabletSmall;

  /// Tablet OR larger (>= 600dp) — used by adaptive two-panel layouts.
  static bool isTablet(BuildContext context) => _width(context) >= tabletSmall;

  /// Large tablet / desktop (>= 900dp).
  static bool isTabletLarge(BuildContext context) =>
      _width(context) >= tabletLarge;

  /// Foldable closed band (480–599dp).
  static bool isFoldable(BuildContext context) {
    final w = _width(context);
    return w >= foldableClosed && w < tabletSmall;
  }

  static bool isLandscape(BuildContext context) =>
      MediaQuery.orientationOf(context) == Orientation.landscape;

  static bool isSplitScreen(BuildContext context) {
    final mq = MediaQuery.of(context);
    // Split screen typically has width < 60% of screen and aspect ratio changed
    return mq.size.width < 500 && mq.size.height > mq.size.width;
  }

  // ── Layout column count ───────────────────────────────────────────────────
  static int gridColumns(BuildContext context) {
    if (isTabletLarge(context)) return 4;
    if (isTablet(context)) return 3;
    if (isFoldable(context)) return 2;
    if (isLandscape(context)) return 2;
    return 2;
  }

  static int listColumns(BuildContext context) {
    if (isTabletLarge(context)) return 3;
    if (isTablet(context)) return 2;
    return 1;
  }

  // ── Navigation type ───────────────────────────────────────────────────────
  static AppNavigationType navType(BuildContext context) {
    if (isTabletLarge(context)) return AppNavigationType.rail;
    if (isTablet(context)) return AppNavigationType.rail;
    return AppNavigationType.bottomBar;
  }

  // ── Adaptive padding ──────────────────────────────────────────────────────
  static double horizontalPadding(BuildContext context) {
    if (isTabletLarge(context)) return 32.0;
    if (isTablet(context)) return 24.0;
    return 16.0;
  }

  static double maxContentWidth(BuildContext context) {
    if (isTabletLarge(context)) return 900.0;
    if (isTablet(context)) return 720.0;
    return double.infinity;
  }
}

enum AppNavigationType { bottomBar, rail, drawer }
