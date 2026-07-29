import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/design_tokens.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// CIRCLE BACK BUTTON
/// White circular back button with a black arrow, for use over hero imagery
/// where the default (unfilled) back arrow lacks contrast.
/// ─────────────────────────────────────────────────────────────────────────────

class CircleBackButton extends StatelessWidget {
  const CircleBackButton({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(SpaceTokens.sm),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            tooltip: 'Back',
            onPressed: () => context.pop(),
          ),
        ),
      );
}
