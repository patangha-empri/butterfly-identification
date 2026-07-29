import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'color_tokens.dart';
import 'design_tokens.dart';
import 'typography_tokens.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// APP THEME
/// Full Material 3 ThemeData instances built from token system.
/// ─────────────────────────────────────────────────────────────────────────────

abstract class AppTheme {
  // ── Light Theme ───────────────────────────────────────────────────────────
  static ThemeData get light => _build(
    colorScheme: ColorTokens.lightScheme,
    brightness: Brightness.light,
    scaffoldBg: ColorTokens.backgroundLight,
    statusIconBrightness: Brightness.dark,
  );

  // ── Dark Theme ────────────────────────────────────────────────────────────
  static ThemeData get dark => _build(
    colorScheme: ColorTokens.darkScheme,
    brightness: Brightness.dark,
    scaffoldBg: ColorTokens.backgroundDark,
    statusIconBrightness: Brightness.light,
  );

  static ThemeData _build({
    required ColorScheme colorScheme,
    required Brightness brightness,
    required Color scaffoldBg,
    required Brightness statusIconBrightness,
  }) {
    final isLight = brightness == Brightness.light;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
      scaffoldBackgroundColor: scaffoldBg,
      textTheme: TypographyTokens.textTheme.apply(
        bodyColor: isLight ? ColorTokens.textPrimaryLight : ColorTokens.textPrimaryDark,
        displayColor: isLight ? ColorTokens.textPrimaryLight : ColorTokens.textPrimaryDark,
      ),

      // ── AppBar ──────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TypographyTokens.textTheme.titleLarge?.copyWith(
          color: isLight ? ColorTokens.textPrimaryLight : ColorTokens.textPrimaryDark,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: isLight ? ColorTokens.textPrimaryLight : ColorTokens.textPrimaryDark,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: statusIconBrightness,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: statusIconBrightness,
        ),
        surfaceTintColor: Colors.transparent,
      ),

      // ── Card ─────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: RadiusTokens.cardBR,
        ),
        color: isLight ? ColorTokens.surfaceLight : ColorTokens.surfaceDark,
        shadowColor: Colors.transparent,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),

      // ── Elevated Button ──────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: RadiusTokens.buttonBR,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: SpaceTokens.xl,
            vertical: SpaceTokens.base,
          ),
          minimumSize: const Size(0, 52),
          textStyle: TypographyTokens.textTheme.labelLarge,
        ),
      ),

      // ── Text Button ──────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: RadiusTokens.buttonBR,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: SpaceTokens.base,
            vertical: SpaceTokens.sm,
          ),
          textStyle: TypographyTokens.textTheme.labelLarge,
        ),
      ),

      // ── Outlined Button ──────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: RadiusTokens.buttonBR,
          ),
          side: BorderSide(color: colorScheme.outline),
          padding: const EdgeInsets.symmetric(
            horizontal: SpaceTokens.xl,
            vertical: SpaceTokens.base,
          ),
          minimumSize: const Size(0, 52),
          textStyle: TypographyTokens.textTheme.labelLarge,
        ),
      ),

      // ── Input Decoration ─────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight
            ? ColorTokens.surfaceVariantLight
            : ColorTokens.surfaceVariantDark,
        border: OutlineInputBorder(
          borderRadius: RadiusTokens.cardBR,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: RadiusTokens.cardBR,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: RadiusTokens.cardBR,
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: RadiusTokens.cardBR,
          borderSide: BorderSide(color: colorScheme.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: SpaceTokens.base,
          vertical: SpaceTokens.md,
        ),
        hintStyle: TypographyTokens.textTheme.bodyMedium?.copyWith(
          color: isLight ? ColorTokens.textTertiaryLight : ColorTokens.textTertiaryDark,
        ),
        labelStyle: TypographyTokens.textTheme.bodyMedium?.copyWith(
          color: isLight ? ColorTokens.textSecondaryLight : ColorTokens.textSecondaryDark,
        ),
      ),

      // ── Bottom Navigation Bar ─────────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: isLight
            ? ColorTokens.textTertiaryLight
            : ColorTokens.textTertiaryDark,
        selectedLabelStyle: TypographyTokens.navLabel,
        unselectedLabelStyle: TypographyTokens.navLabel,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      // ── Navigation Bar (M3) ───────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Selected pill: solid dark brand fill with a white icon for strong
        // contrast; the label matches the fill colour and turns bold.
        indicatorColor: colorScheme.primary,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? TypographyTokens.navLabel.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                )
              : TypographyTokens.navLabel,
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 24,
            color: states.contains(WidgetState.selected)
                ? Colors.white
                : isLight
                    ? ColorTokens.textTertiaryLight
                    : ColorTokens.textTertiaryDark,
          ),
        ),
      ),

      // ── Bottom Sheet ─────────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isLight ? ColorTokens.surfaceLight : ColorTokens.surfaceDark,
        modalBackgroundColor: isLight ? ColorTokens.surfaceLight : ColorTokens.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: RadiusTokens.bottomSheetBR,
        ),
        elevation: ElevationTokens.bottomSheet,
        showDragHandle: true,
        dragHandleColor: isLight ? ColorTokens.textTertiaryLight : ColorTokens.textTertiaryDark,
      ),

      // ── Chip ─────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: isLight ? ColorTokens.surfaceVariantLight : ColorTokens.surfaceVariantDark,
        selectedColor: colorScheme.primaryContainer,
        checkmarkColor: isLight
            ? ColorTokens.brandPrimaryDark
            : ColorTokens.textPrimaryDark,
        labelStyle: TypographyTokens.textTheme.labelMedium?.copyWith(
          color: isLight
              ? ColorTokens.textPrimaryLight
              : ColorTokens.textPrimaryDark,
          fontWeight: FontWeight.w600,
        ),
        secondaryLabelStyle: TypographyTokens.textTheme.labelMedium?.copyWith(
          color: isLight
              ? ColorTokens.brandPrimaryDark
              : ColorTokens.textPrimaryDark,
          fontWeight: FontWeight.w600,
        ),
        side: BorderSide(color: colorScheme.outlineVariant),
        shape: const StadiumBorder(),
        padding: SpaceTokens.chipPadding,
        elevation: 0,
        pressElevation: 0,
      ),

      // ── Dialog ───────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: isLight ? ColorTokens.surfaceLight : ColorTokens.surfaceDark,
        elevation: ElevationTokens.dialog,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.dialog),
        ),
        titleTextStyle: TypographyTokens.textTheme.titleLarge?.copyWith(
          color: isLight ? ColorTokens.textPrimaryLight : ColorTokens.textPrimaryDark,
        ),
      ),

      // ── Divider ──────────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: isLight
            ? colorScheme.outlineVariant
            : colorScheme.outlineVariant,
        thickness: 0.5,
        space: 0,
      ),

      // ── Icon ─────────────────────────────────────────────────────────────
      iconTheme: IconThemeData(
        color: isLight ? ColorTokens.textSecondaryLight : ColorTokens.textSecondaryDark,
        size: 24,
      ),

      // ── Floating Action Button ────────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: ElevationTokens.floatingButton,
        shape: RoundedRectangleBorder(
          borderRadius: RadiusTokens.cardBR,
        ),
      ),

      // ── Switch ───────────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStatePropertyAll(colorScheme.primary),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest,
        ),
      ),

      // ── Tooltip ──────────────────────────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isLight ? ColorTokens.surfaceDark : ColorTokens.surfaceLight,
          borderRadius: BorderRadius.circular(RadiusTokens.sm),
        ),
        textStyle: TypographyTokens.textTheme.bodySmall?.copyWith(
          color: isLight ? ColorTokens.textPrimaryDark : ColorTokens.textPrimaryLight,
        ),
      ),

      // ── Page transitions ─────────────────────────────────────────────────
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),

      splashFactory: InkSparkle.splashFactory,
    );
  }
}
