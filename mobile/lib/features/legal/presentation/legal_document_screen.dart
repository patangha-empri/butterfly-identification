import 'package:flutter/material.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/theme/typography_tokens.dart';
import 'legal_content.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// LEGAL DOCUMENT SCREEN
/// Renders a [LegalDoc] (privacy policy / terms / community guidelines).
/// ─────────────────────────────────────────────────────────────────────────────

class LegalDocumentScreen extends StatelessWidget {
  const LegalDocumentScreen({super.key, required this.doc});

  final LegalDoc doc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(doc.title)),
      body: ListView(
        padding: const EdgeInsets.all(SpaceTokens.lg),
        children: [
          Text(doc.updated,
              style: TypographyTokens.caption.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              )),
          const SizedBox(height: SpaceTokens.lg),
          for (final s in doc.sections) ...[
            Text(s.heading, style: TypographyTokens.textTheme.titleMedium),
            const SizedBox(height: SpaceTokens.xs),
            Text(s.body,
                style: TypographyTokens.textTheme.bodyMedium?.copyWith(height: 1.5)),
            const SizedBox(height: SpaceTokens.lg),
          ],
          const SizedBox(height: SpaceTokens.xl),
        ],
      ),
    );
  }
}
