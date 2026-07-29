import 'package:flutter/material.dart';
import '../../responsive/app_breakpoints.dart';
import '../../theme/color_tokens.dart';
import '../../theme/design_tokens.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// BUILDCONTEXT EXTENSIONS
/// Clean access to theme, responsive helpers, and navigation.
/// ─────────────────────────────────────────────────────────────────────────────

extension ThemeX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  // ── Semantic colors ─────────────────────────────────────────────────────
  Color get primaryColor => colorScheme.primary;
  Color get surfaceColor => colorScheme.surface;
  Color get errorColor => colorScheme.error;
  Color get onPrimary => colorScheme.onPrimary;

  Color get textPrimary => isDark
      ? ColorTokens.textPrimaryDark
      : ColorTokens.textPrimaryLight;
  Color get textSecondary => isDark
      ? ColorTokens.textSecondaryDark
      : ColorTokens.textSecondaryLight;
  Color get textTertiary => isDark
      ? ColorTokens.textTertiaryDark
      : ColorTokens.textTertiaryLight;
}

extension ResponsiveX on BuildContext {
  bool get isMobile => AppBreakpoints.isMobile(this);
  bool get isTablet => AppBreakpoints.isTablet(this);
  bool get isTabletLarge => AppBreakpoints.isTabletLarge(this);
  bool get isFoldable => AppBreakpoints.isFoldable(this);
  bool get isLandscape => AppBreakpoints.isLandscape(this);
  int get gridColumns => AppBreakpoints.gridColumns(this);
  double get hPad => AppBreakpoints.horizontalPadding(this);
  double get maxWidth => AppBreakpoints.maxContentWidth(this);
  AppNavigationType get navType => AppBreakpoints.navType(this);
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);
  double get topPadding => MediaQuery.viewPaddingOf(this).top;
  double get bottomPadding => MediaQuery.viewPaddingOf(this).bottom;
}

extension NavigationX on BuildContext {
  void popIfCan() {
    if (Navigator.canPop(this)) Navigator.pop(this);
  }
}

extension SpacingX on BuildContext {
  SizedBox get spaceXS => const SizedBox(height: SpaceTokens.xs, width: SpaceTokens.xs);
  SizedBox get spaceSM => const SizedBox(height: SpaceTokens.sm, width: SpaceTokens.sm);
  SizedBox get spaceMD => const SizedBox(height: SpaceTokens.md, width: SpaceTokens.md);
  SizedBox get spaceBase => const SizedBox(height: SpaceTokens.base, width: SpaceTokens.base);
  SizedBox get spaceLG => const SizedBox(height: SpaceTokens.lg, width: SpaceTokens.lg);
  SizedBox get spaceXL => const SizedBox(height: SpaceTokens.xl, width: SpaceTokens.xl);
  SizedBox get spaceXXL => const SizedBox(height: SpaceTokens.xxl, width: SpaceTokens.xxl);
}
