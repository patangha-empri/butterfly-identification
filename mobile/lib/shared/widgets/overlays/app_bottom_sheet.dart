import 'package:flutter/material.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/theme/typography_tokens.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// APP BOTTOM SHEET
/// Standardized modal sheet with drag handle, title, and optional scroll.
/// Use AppBottomSheet.show(...) to present.
/// ─────────────────────────────────────────────────────────────────────────────

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.trailing,
    this.scrollable = true,
    this.maxHeightFactor = 0.9,
    this.padding = const EdgeInsets.fromLTRB(
      SpaceTokens.base,
      0,
      SpaceTokens.base,
      SpaceTokens.xl,
    ),
  });

  final Widget child;
  final String? title;
  final Widget? trailing;
  final bool scrollable;
  final double maxHeightFactor;
  final EdgeInsetsGeometry padding;

  /// Presents the sheet as a modal bottom sheet.
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    String? title,
    Widget? trailing,
    bool scrollable = true,
    bool isDismissible = true,
    bool useSafeArea = true,
    double maxHeightFactor = 0.9,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      useSafeArea: useSafeArea,
      // Present above the shell's bottom navigation bar, not behind it.
      useRootNavigator: true,
      showDragHandle: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (_) => AppBottomSheet(
        title: title,
        trailing: trailing,
        scrollable: scrollable,
        maxHeightFactor: maxHeightFactor,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final maxHeight = MediaQuery.sizeOf(context).height * maxHeightFactor;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    // showModalBottomSheet's useSafeArea only avoids the status bar; with
    // edge-to-edge enabled the sheet still extends under the Android system
    // navigation bar, so pad for it here. Skipped while the keyboard is open,
    // since the viewInsets margin already lifts the sheet clear of it.
    final bottomSafe =
        bottomInset > 0 ? 0.0 : MediaQuery.viewPaddingOf(context).bottom;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight + bottomInset),
      margin: EdgeInsets.only(bottom: bottomInset),
      decoration: BoxDecoration(
        color: isDark ? ColorTokens.surfaceDark : ColorTokens.surfaceLight,
        borderRadius: RadiusTokens.bottomSheetBR,
        boxShadow: ShadowTokens.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(vertical: SpaceTokens.md),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: RadiusTokens.pillBR,
              ),
            ),
          ),

          // ── Title row ────────────────────────────────────────────────────
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SpaceTokens.base,
                0,
                SpaceTokens.base,
                SpaceTokens.md,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title!,
                      style: TypographyTokens.textTheme.titleLarge,
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
            ),

          // ── Content ──────────────────────────────────────────────────────
          Flexible(
            child: scrollable
                ? SingleChildScrollView(
                    padding: padding.add(EdgeInsets.only(bottom: bottomSafe)),
                    child: child,
                  )
                : Padding(
                    padding: padding.add(EdgeInsets.only(bottom: bottomSafe)),
                    child: child,
                  ),
          ),
        ],
      ),
    );
  }
}
