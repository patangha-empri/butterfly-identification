import 'package:flutter/material.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../../../features/species/data/models/species_detail.dart';

class SpeciesInsightsCard extends StatelessWidget {
  const SpeciesInsightsCard({super.key, required this.profile});
  
  final Map<String, dynamic> profile;

  factory SpeciesInsightsCard.fromDetail(SpeciesDetail detail) {
    // Extract species epithet (second word of scientific name)
    final parts = detail.scientificName.trim().split(' ');
    final speciesEpithet = parts.length > 1 ? parts[1] : '';

    final states = detail.states;
    final hostPlants = detail.hostPlants.map((hp) => hp.name).toList();
    
    // Format flight months to names
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final activeMonths = detail.flightMonths
        .where((m) => m >= 1 && m <= 12)
        .map((m) => months[m - 1])
        .toList();

    final mappedProfile = {
      'description': detail.description ?? detail.descriptionShort,
      'taxonomy': {
        'class': 'Insecta',
        'order': 'Lepidoptera',
        'family': detail.family,
        'genus': detail.genus,
        'species': speciesEpithet,
      },
      'physical_characteristics': {
        'average_wingspan_cm': detail.wingspanMm,
      },
      'habitat': detail.habitat != null && detail.habitat!.isNotEmpty ? [detail.habitat] : [],
      'distribution': {
        'regions': states,
        'native': true,
      },
      'seasonality': {
        'active_months': activeMonths,
      },
      'host_plants': hostPlants,
      'conservation': {
        'status': detail.conservationStatus,
        'rarity': detail.rarity,
      },
    };

    return SpeciesInsightsCard(profile: mappedProfile);
  }

  @override
  Widget build(BuildContext context) {
    final description = profile['description'] as String?;
    final taxonomy = profile['taxonomy'] as Map<String, dynamic>?;
    final physical = profile['physical_characteristics'] as Map<String, dynamic>?;
    final habitats = profile['habitat'] as List?;
    final distribution = profile['distribution'] as Map<String, dynamic>?;
    final seasonality = profile['seasonality'] as Map<String, dynamic>?;
    final hostPlants = profile['host_plants'] as List?;
    final nectarPlants = profile['nectar_plants'] as List?;
    final behavior = profile['behavior'] as Map<String, dynamic>?;
    final lifeCycle = profile['life_cycle'] as Map<String, dynamic>?;
    final lifespan = profile['lifespan'] as String?;
    final conservation = profile['conservation'] as Map<String, dynamic>?;
    final facts = (profile['interesting_facts'] as List?)?.cast<String>() ?? [];
    
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(top: SpaceTokens.md),
      color: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: RadiusTokens.cardBR),
      child: ExpansionTile(
        title: Text('Species Insights', style: TypographyTokens.textTheme.titleMedium),
        leading: const Icon(Icons.menu_book, color: ColorTokens.brandPrimary),
        shape: const Border(),
        childrenPadding: const EdgeInsets.fromLTRB(SpaceTokens.lg, 0, SpaceTokens.lg, SpaceTokens.lg),
        children: [
          // ── Description ───────────────────────────────────────────────────
          if (description != null && description.isNotEmpty) ...[
            Text(
              description,
              style: TypographyTokens.textTheme.bodyMedium?.copyWith(height: 1.4),
            ),
            const SizedBox(height: SpaceTokens.md),
          ],

          // ── Taxonomy ──────────────────────────────────────────────────────
          if (taxonomy != null) ...[
            _SectionSubtitle('Taxonomy', Icons.category_outlined),
            _InsightRow('Class', taxonomy['class']),
            _InsightRow('Order', taxonomy['order']),
            _InsightRow('Family', taxonomy['family']),
            _InsightRow('Genus', taxonomy['genus']),
            _InsightRow('Species', taxonomy['species']),
            const Divider(height: SpaceTokens.lg),
          ],

          // ── Physical Characteristics ──────────────────────────────────────
          if (physical != null) ...[
            _SectionSubtitle('Physical Characteristics', Icons.straighten),
            _InsightRow('Wingspan', physical['average_wingspan_cm']),
            _InsightRow('Dimorphism', physical['sexual_dimorphism']),
            if (physical['male_description'] != null)
              _InsightRow('Male Details', physical['male_description']),
            if (physical['female_description'] != null)
              _InsightRow('Female Details', physical['female_description']),
            const Divider(height: SpaceTokens.lg),
          ],

          // ── Habitat & Range ───────────────────────────────────────────────
          if (habitats != null || distribution != null) ...[
            _SectionSubtitle('Habitat & Distribution', Icons.public),
            if (habitats != null && habitats.isNotEmpty)
              _InsightRow('Habitats', habitats.join(', ')),
            if (distribution != null) ...[
              if (distribution['countries'] != null)
                _InsightRow('Countries', (distribution['countries'] as List).join(', ')),
              if (distribution['regions'] != null)
                _InsightRow('Regions', (distribution['regions'] as List).join(', ')),
              _InsightRow('Native status', distribution['native'] == null
                  ? null
                  : (distribution['native'] == true ? 'Native' : 'Introduced/Migrant')),
            ],
            const Divider(height: SpaceTokens.lg),
          ],

          // ── Food Plants ───────────────────────────────────────────────────
          if ((hostPlants != null && hostPlants.isNotEmpty) || (nectarPlants != null && nectarPlants.isNotEmpty)) ...[
            _SectionSubtitle('Diet & Host Plants', Icons.local_florist_outlined),
            if (hostPlants != null && hostPlants.isNotEmpty)
              _InsightRow('Host Plants', hostPlants.join(', ')),
            if (nectarPlants != null && nectarPlants.isNotEmpty)
              _InsightRow('Nectar Plants', nectarPlants.join(', ')),
            const Divider(height: SpaceTokens.lg),
          ],

          // ── Behavior ──────────────────────────────────────────────────────
          if (behavior != null) ...[
            _SectionSubtitle('Behavior', Icons.directions_run),
            _InsightRow('Flight pattern', behavior['flight_pattern']),
            _InsightRow('Feeding', behavior['feeding']),
            _InsightRow('Migration', behavior['migration']),
            _InsightRow('Activity', behavior['activity']),
            const Divider(height: SpaceTokens.lg),
          ],

          // ── Life Cycle & Seasonality ─────────────────────────────────────
          if (lifeCycle != null || seasonality != null || lifespan != null) ...[
            _SectionSubtitle('Life Cycle & Seasonality', Icons.loop),
            if (seasonality != null) ...[
              _InsightRow('Peak season', seasonality['peak_season']),
              if (seasonality['active_months'] != null)
                _InsightRow('Active months', (seasonality['active_months'] as List).join(', ')),
            ],
            if (lifespan != null)
              _InsightRow('Lifespan', lifespan),
            if (lifeCycle != null) ...[
              if (lifeCycle['egg'] != null) _InsightRow('Egg stage', lifeCycle['egg']),
              if (lifeCycle['larva'] != null) _InsightRow('Larva/Caterpillar', lifeCycle['larva']),
              if (lifeCycle['pupa'] != null) _InsightRow('Pupa/Chrysalis', lifeCycle['pupa']),
              if (lifeCycle['adult'] != null) _InsightRow('Adult stage', lifeCycle['adult']),
            ],
            const Divider(height: SpaceTokens.lg),
          ],

          // ── Conservation ──────────────────────────────────────────────────
          if (conservation != null) ...[
            _SectionSubtitle('Conservation & Rarity', Icons.shield_outlined),
            _InsightRow('Status', conservation['status']),
            _InsightRow('Population trend', conservation['population_trend']),
            _InsightRow('Rare status', conservation['rare'] == null
                ? null
                : (conservation['rare'] == true ? 'Yes' : 'No')),
            _InsightRow('Protected status', conservation['protected'] == null
                ? null
                : (conservation['protected'] == true ? 'Yes' : 'No')),
            const Divider(height: SpaceTokens.lg),
          ],

          // ── Interesting Facts ─────────────────────────────────────────────
          if (facts.isNotEmpty) ...[
            _SectionSubtitle('Interesting Facts', Icons.lightbulb_outline),
            ...facts.map((f) => Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.star, size: 14, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      Expanded(child: Text(f, style: TypographyTokens.textTheme.bodyMedium)),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }
}

class _SectionSubtitle extends StatelessWidget {
  const _SectionSubtitle(this.title, this.icon);
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SpaceTokens.sm),
      child: Row(
        children: [
          Icon(icon, size: 16, color: colorScheme.primary),
          const SizedBox(width: SpaceTokens.xs),
          Text(
            title,
            style: TypographyTokens.textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow(this.label, this.value);
  final String label;
  final dynamic value;

  @override
  Widget build(BuildContext context) {
    if (value == null || value.toString().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TypographyTokens.textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: SpaceTokens.md),
          Expanded(
            child: Text(
              value.toString(),
              textAlign: TextAlign.right,
              style: TypographyTokens.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
