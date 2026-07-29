import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/theme/typography_tokens.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// AUTH ERROR BANNER
/// Persistent inline banner that surfaces the backend's error message clearly
/// (e.g. "Invalid email or password.", "An account with this email already
/// exists."). Animates in; renders nothing when [message] is null.
/// ─────────────────────────────────────────────────────────────────────────────

class AuthErrorBanner extends StatelessWidget {
  const AuthErrorBanner({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    if (message == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: SpaceTokens.base),
      padding: const EdgeInsets.symmetric(
        horizontal: SpaceTokens.base,
        vertical: SpaceTokens.md,
      ),
      decoration: BoxDecoration(
        color: ColorTokens.error.withValues(alpha: 0.1),
        borderRadius: RadiusTokens.buttonBR,
        border: Border.all(color: ColorTokens.error.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, size: 18, color: ColorTokens.error),
          const SizedBox(width: SpaceTokens.sm),
          Expanded(
            child: Text(
              message!,
              style: TypographyTokens.textTheme.bodySmall?.copyWith(
                color: ColorTokens.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: DurationTokens.fast)
        .moveY(begin: -6, end: 0, duration: DurationTokens.fast);
  }
}
