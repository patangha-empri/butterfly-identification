import 'package:flutter/material.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// TYPOGRAPHY TOKEN SYSTEM
/// Dual-font hierarchy: PlayfairDisplay (display/hero) + Inter (body/UI)
/// Responsive scale via ScreenUtil is applied at widget level, not here.
/// ─────────────────────────────────────────────────────────────────────────────

abstract class TypographyTokens {
  // ── Font Families ─────────────────────────────────────────────────────────
  static const String displayFamily = 'PlayfairDisplay';
  static const String bodyFamily = 'Inter';

  // ── Base TextTheme (light) ────────────────────────────────────────────────
  static TextTheme get textTheme => const TextTheme(
    // ── Display — Cinematic hero titles ─────────────────────────────────────
    displayLarge: TextStyle(
      fontFamily: displayFamily,
      fontSize: 57,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.25,
      height: 1.12,
    ),
    displayMedium: TextStyle(
      fontFamily: displayFamily,
      fontSize: 45,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.16,
    ),
    displaySmall: TextStyle(
      fontFamily: displayFamily,
      fontSize: 36,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.22,
    ),

    // ── Headline — Section titles ────────────────────────────────────────────
    headlineLarge: TextStyle(
      fontFamily: displayFamily,
      fontSize: 32,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.25,
    ),
    headlineMedium: TextStyle(
      fontFamily: displayFamily,
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.29,
    ),
    headlineSmall: TextStyle(
      fontFamily: displayFamily,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.33,
    ),

    // ── Title — Card/sheet titles ────────────────────────────────────────────
    titleLarge: TextStyle(
      fontFamily: bodyFamily,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.27,
    ),
    titleMedium: TextStyle(
      fontFamily: bodyFamily,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      height: 1.5,
    ),
    titleSmall: TextStyle(
      fontFamily: bodyFamily,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.43,
    ),

    // ── Body — Reading text ───────────────────────────────────────────────────
    bodyLarge: TextStyle(
      fontFamily: bodyFamily,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontFamily: bodyFamily,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.43,
    ),
    bodySmall: TextStyle(
      fontFamily: bodyFamily,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.33,
    ),

    // ── Label — Chips/badges/buttons ─────────────────────────────────────────
    labelLarge: TextStyle(
      fontFamily: bodyFamily,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.43,
    ),
    labelMedium: TextStyle(
      fontFamily: bodyFamily,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.33,
    ),
    labelSmall: TextStyle(
      fontFamily: bodyFamily,
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.45,
    ),
  );

  // ── Specialty Styles ──────────────────────────────────────────────────────
  /// Species scientific name — italic serif
  static const TextStyle scientificName = TextStyle(
    fontFamily: displayFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    letterSpacing: 0.3,
  );

  /// Rarity badge label
  static const TextStyle rarityLabel = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
  );

  /// Confidence percentage — large mono-weight display
  static const TextStyle confidenceDisplay = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.5,
    height: 1.0,
  );

  /// Tab/nav label
  static const TextStyle navLabel = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
  );

  /// Metadata / caption
  static const TextStyle caption = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    height: 1.4,
  );

  /// Hero/cinematic species name
  static const TextStyle heroTitle = TextStyle(
    fontFamily: displayFamily,
    fontSize: 38,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.1,
    shadows: [
      Shadow(
        offset: Offset(0, 2),
        blurRadius: 12,
        color: Color(0x80000000),
      ),
    ],
  );

  /// XP / stat number display
  static const TextStyle statNumber = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );
}
