import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/theme/typography_tokens.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// FLOATING SEARCH BAR
/// Glassmorphic pill-shaped search field that floats above content.
/// Works as a real input or as a tappable "search trigger" (readOnly + onTap).
/// ─────────────────────────────────────────────────────────────────────────────

class FloatingSearchBar extends StatelessWidget {
  const FloatingSearchBar({
    super.key,
    this.hint = 'Search butterflies…',
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.readOnly = false,
    this.autofocus = false,
    this.leading,
    this.trailing,
    this.elevation = true,
  });

  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool autofocus;
  final Widget? leading;
  final Widget? trailing;
  final bool elevation;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = BorderRadius.circular(RadiusTokens.pill);

    return Semantics(
      textField: !readOnly,
      button: readOnly,
      label: hint,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: elevation ? ShadowTokens.md : null,
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.base),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.white.withValues(alpha: 0.8),
                borderRadius: radius,
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.12)
                      : Colors.white.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  leading ??
                      Icon(
                        Icons.search,
                        size: 20,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  const SizedBox(width: SpaceTokens.md),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: onChanged,
                      onSubmitted: onSubmitted,
                      onTap: onTap,
                      readOnly: readOnly,
                      autofocus: autofocus,
                      textInputAction: TextInputAction.search,
                      style: TypographyTokens.textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: hint,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        filled: false,
                        hintStyle:
                            TypographyTokens.textTheme.bodyMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: SpaceTokens.sm),
                    trailing!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
