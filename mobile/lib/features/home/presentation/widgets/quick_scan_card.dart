import 'package:flutter/material.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../../../core/utils/a11y.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// QUICK SCAN CARD
/// Hero CTA that launches the AI camera flow (wired in Phase 6).
/// ─────────────────────────────────────────────────────────────────────────────

class QuickScanCard extends StatelessWidget {
  const QuickScanCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Scan a butterfly with AI',
      child: GestureDetector(
        onTap: () {
          Haptics.medium();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.all(SpaceTokens.lg),
          decoration: BoxDecoration(
            gradient: ColorTokens.aiGradient,
            borderRadius: RadiusTokens.cardBR,
            boxShadow: ShadowTokens.brand,
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: RadiusTokens.buttonBR,
                ),
                child: const Icon(Icons.center_focus_strong,
                    color: Colors.white, size: 30),
              ),
              const SizedBox(width: SpaceTokens.base),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Identify a butterfly',
                      style: TypographyTokens.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Snap a photo — our AI names the species',
                      style: TypographyTokens.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  color: Colors.white, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
