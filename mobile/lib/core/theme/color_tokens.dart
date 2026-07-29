import 'package:flutter/material.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// COLOR TOKEN SYSTEM
/// Brand-specific semantic color palette for Butterfly India
/// All UI layers consume tokens — never raw hex values.
/// ─────────────────────────────────────────────────────────────────────────────

abstract class ColorTokens {
  // ── Brand ─────────────────────────────────────────────────────────────────
  static const Color brandPrimary = Color(0xFF1F6E5A);
  static const Color brandPrimaryLight = Color(0xFF2D9E82);
  static const Color brandPrimaryDark = Color(0xFF134A3C);
  static const Color brandSecondary = Color(0xFF4A90E2);
  static const Color brandSecondaryLight = Color(0xFF6BAAE8);
  static const Color brandAccent = Color(0xFFFF8A3D);
  static const Color brandAccentLight = Color(0xFFFFAA70);

  // ── Background ────────────────────────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFF8F6F1);
  static const Color backgroundDark = Color(0xFF0F1720);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1A2535);
  static const Color surfaceVariantLight = Color(0xFFF0EDE6);
  static const Color surfaceVariantDark = Color(0xFF243040);

  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimaryLight = Color(0xFF1A1A1A);
  static const Color textSecondaryLight = Color(0xFF666666);
  static const Color textTertiaryLight = Color(0xFF999999);
  static const Color textPrimaryDark = Color(0xFFF5F5F5);
  static const Color textSecondaryDark = Color(0xFFB0B8C4);
  static const Color textTertiaryDark = Color(0xFF7A8896);

  // ── Semantic ──────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF2ECC71);
  static const Color successLight = Color(0xFFD5F5E3);
  static const Color warning = Color(0xFFF39C12);
  static const Color warningLight = Color(0xFFFEF9E7);
  static const Color error = Color(0xFFE74C3C);
  static const Color errorLight = Color(0xFFFDECEB);
  static const Color info = Color(0xFF3498DB);
  static const Color infoLight = Color(0xFFEBF5FB);

  // ── Rarity Tiers ─────────────────────────────────────────────────────────
  static const Color rarityCommon = Color(0xFF78909C);
  static const Color rarityUncommon = Color(0xFF43A047);
  static const Color rarityRare = Color(0xFF1E88E5);
  static const Color rarityVeryRare = Color(0xFF8E24AA);
  static const Color rarityEndangered = Color(0xFFE53935);

  // ── AI Confidence ─────────────────────────────────────────────────────────
  static const Color confidenceCertain = Color(0xFF2ECC71);   // >90%
  static const Color confidenceLikely = Color(0xFF1F6E5A);    // 70-90%
  static const Color confidencePossible = Color(0xFFF39C12);  // 50-70%
  static const Color confidenceUncertain = Color(0xFFE74C3C); // <50%

  // ── Glass / Overlay ───────────────────────────────────────────────────────
  static const Color glassLight = Color(0xCCFFFFFF);
  static const Color glassDark = Color(0xCC1A2535);
  static const Color glassBorderLight = Color(0x33FFFFFF);
  static const Color glassBorderDark = Color(0x22FFFFFF);
  static const Color overlayLight = Color(0x80000000);
  static const Color overlayDark = Color(0xA0000000);

  // ── Gamification ─────────────────────────────────────────────────────────
  static const Color goldBadge = Color(0xFFFFD700);
  static const Color silverBadge = Color(0xFFC0C0C0);
  static const Color bronzeBadge = Color(0xFFCD7F32);
  static const Color xpColor = Color(0xFF9B59B6);

  // ── Map / Geography ───────────────────────────────────────────────────────
  static const Color mapMarkerDefault = Color(0xFF1F6E5A);
  static const Color mapMarkerHighlight = Color(0xFFFF8A3D);
  static const Color mapHeatmapLow = Color(0xFFAED6F1);
  static const Color mapHeatmapHigh = Color(0xFF1F6E5A);

  // ── Gradients ─────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brandPrimaryLight, brandPrimaryDark],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xCC0F1720)],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A2535), backgroundDark],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brandAccent, Color(0xFFFF6B35)],
  );

  static const LinearGradient aiGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4A90E2), Color(0xFF1F6E5A)],
  );

  // ── ColorScheme factories ─────────────────────────────────────────────────
  static ColorScheme get lightScheme => const ColorScheme(
    brightness: Brightness.light,
    primary: brandPrimary,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFCCE8E1),
    onPrimaryContainer: brandPrimaryDark,
    secondary: brandSecondary,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFD6E8FA),
    onSecondaryContainer: Color(0xFF0A3D6B),
    tertiary: brandAccent,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFFFE0C8),
    onTertiaryContainer: Color(0xFF7A3800),
    error: error,
    onError: Colors.white,
    errorContainer: errorLight,
    onErrorContainer: Color(0xFF6B1A14),
    surface: surfaceLight,
    onSurface: textPrimaryLight,
    surfaceContainerHighest: surfaceVariantLight,
    onSurfaceVariant: textSecondaryLight,
    outline: Color(0xFFCCCCCC),
    outlineVariant: Color(0xFFE5E5E5),
    shadow: Color(0x1A000000),
    scrim: Color(0x80000000),
    inverseSurface: surfaceDark,
    onInverseSurface: textPrimaryDark,
    inversePrimary: brandPrimaryLight,
  );

  static ColorScheme get darkScheme => const ColorScheme(
    brightness: Brightness.dark,
    primary: brandPrimaryLight,
    onPrimary: Colors.white,
    primaryContainer: brandPrimaryDark,
    onPrimaryContainer: Color(0xFFCCE8E1),
    secondary: brandSecondaryLight,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFF0A3D6B),
    onSecondaryContainer: Color(0xFFD6E8FA),
    tertiary: brandAccentLight,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFF7A3800),
    onTertiaryContainer: Color(0xFFFFE0C8),
    error: Color(0xFFFF6B6B),
    onError: Colors.white,
    errorContainer: Color(0xFF6B1A14),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: surfaceDark,
    onSurface: textPrimaryDark,
    surfaceContainerHighest: surfaceVariantDark,
    onSurfaceVariant: textSecondaryDark,
    outline: Color(0xFF3D4F5C),
    outlineVariant: Color(0xFF2A3A48),
    shadow: Color(0x40000000),
    scrim: Color(0xA0000000),
    inverseSurface: surfaceLight,
    onInverseSurface: textPrimaryLight,
    inversePrimary: brandPrimary,
  );
}
