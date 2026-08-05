import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../data/models/species_detail.dart';
import '../providers/species_providers.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// CUSTOM FIELDS SECTION
/// Renders the admin-defined fields a species carries.
///
/// The species payload holds only `{field_key: value}`; the titles, order and
/// grouping come from the definitions endpoint, and the backend already omits
/// any field not marked visible in the app. Everything here is therefore driven
/// by data — a field added in the admin panel appears without an app release.
///
/// Renders nothing at all when the species has no values, the definitions have
/// not loaded, or the request failed. It is an optional block on an otherwise
/// complete page and must never show a spinner or an error in its place.
/// ─────────────────────────────────────────────────────────────────────────────

class CustomFieldsSection extends ConsumerWidget {
  const CustomFieldsSection({super.key, required this.detail});

  final SpeciesDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (detail.customFields.isEmpty) return const SizedBox.shrink();

    final definitions =
        ref.watch(speciesFieldDefinitionsProvider).valueOrNull ??
            const <SpeciesFieldDefinition>[];
    if (definitions.isEmpty) return const SizedBox.shrink();

    // Definitions arrive already sorted by sort_order then label; keep that
    // order so admins control how the section reads.
    final groups = <String, List<(SpeciesFieldDefinition, String)>>{};
    for (final def in definitions) {
      final text = def.display(detail.customFields[def.fieldKey]);
      if (text == null) continue;
      groups.putIfAbsent(def.groupName, () => []).add((def, text));
    }
    if (groups.isEmpty) return const SizedBox.shrink();

    final onSurfaceVariant = Theme.of(context).colorScheme.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in groups.entries) ...[
          Padding(
            padding: const EdgeInsets.only(
              top: SpaceTokens.xl,
              bottom: SpaceTokens.sm,
            ),
            child: Text(
              entry.key,
              style: TypographyTokens.textTheme.titleLarge,
            ),
          ),
          for (final (def, text) in entry.value)
            Padding(
              padding: const EdgeInsets.only(bottom: SpaceTokens.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    def.label,
                    style: TypographyTokens.textTheme.labelMedium?.copyWith(
                      color: onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    text,
                    style: TypographyTokens.textTheme.bodyLarge
                        ?.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
        ],
      ],
    );
  }
}
