import 'package:flutter/material.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/theme/typography_tokens.dart';
import '../buttons/app_button.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// EMPTY / ERROR STATE
/// Reusable placeholder for empty lists, errors and offline situations.
/// ─────────────────────────────────────────────────────────────────────────────

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.iconColor,
  });

  /// Convenience: network/offline error state.
  factory AppEmptyState.offline({VoidCallback? onRetry}) => AppEmptyState(
        icon: Icons.wifi_off_rounded,
        title: "You're offline",
        message: 'Check your connection and try again.',
        actionLabel: onRetry != null ? 'Retry' : null,
        onAction: onRetry,
      );

  /// Convenience: generic error state.
  factory AppEmptyState.error({String? message, VoidCallback? onRetry}) =>
      AppEmptyState(
        icon: Icons.error_outline_rounded,
        title: 'Something went wrong',
        message: message ?? 'An unexpected error occurred.',
        actionLabel: onRetry != null ? 'Try Again' : null,
        onAction: onRetry,
      );

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SpaceTokens.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (iconColor ?? Theme.of(context).colorScheme.primary)
                    .withValues(alpha: 0.1),
              ),
              child: Icon(
                icon,
                size: 40,
                color: iconColor ?? Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: SpaceTokens.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TypographyTokens.textTheme.titleLarge,
            ),
            if (message != null) ...[
              const SizedBox(height: SpaceTokens.sm),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: TypographyTokens.textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: SpaceTokens.xl),
              AppButton(
                label: actionLabel!,
                onPressed: onAction,
                isFullWidth: false,
                size: AppButtonSize.medium,
                icon: Icons.refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
