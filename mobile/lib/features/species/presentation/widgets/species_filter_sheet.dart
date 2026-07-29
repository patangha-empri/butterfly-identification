import 'package:flutter/material.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../../../shared/widgets/buttons/app_button.dart';
import '../../../../shared/widgets/cards/rarity_badge.dart';
import '../../data/models/species_filter.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// SPECIES FILTER SHEET
/// Editable copy of the active filter; returns the new filter on Apply.
/// Present via AppBottomSheet.show(...).
/// ─────────────────────────────────────────────────────────────────────────────

class SpeciesFilterSheet extends StatefulWidget {
  const SpeciesFilterSheet({
    super.key,
    required this.initial,
    required this.onApply,
  });

  final SpeciesFilter initial;
  final ValueChanged<SpeciesFilter> onApply;

  @override
  State<SpeciesFilterSheet> createState() => _SpeciesFilterSheetState();
}

class _SpeciesFilterSheetState extends State<SpeciesFilterSheet> {
  late SpeciesFilter _draft = widget.initial;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    // The filter options scroll; the Clear/Apply row stays pinned at the
    // bottom. Presented with AppBottomSheet(scrollable: false) so this widget
    // owns its own scroll view.
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: SingleChildScrollView(
            child: _buildFilters(),
          ),
        ),
        const SizedBox(height: SpaceTokens.md),
        _buildActions(context),
      ],
    );
  }

  Widget _buildFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Rarity'),
        Wrap(
          spacing: SpaceTokens.sm,
          runSpacing: SpaceTokens.sm,
          children: kRarityOptions.map((r) {
            final tier = RarityTier.fromString(r);
            final selected = _draft.rarity == r;
            return FilterChip(
              label: Text(tier.label),
              selected: selected,
              avatar: Icon(tier.icon, size: 14, color: tier.color),
              onSelected: (_) => setState(() => _draft = selected
                  ? _draft.copyWith(clearRarity: true)
                  : _draft.copyWith(rarity: r)),
            );
          }).toList(),
        ),
        const SizedBox(height: SpaceTokens.lg),

        _label('Family'),
        Wrap(
          spacing: SpaceTokens.sm,
          runSpacing: SpaceTokens.sm,
          children: kButterflyFamilies.map((f) {
            final selected = _draft.family == f;
            return FilterChip(
              label: Text(f),
              selected: selected,
              onSelected: (_) => setState(() => _draft = selected
                  ? _draft.copyWith(clearFamily: true)
                  : _draft.copyWith(family: f)),
            );
          }).toList(),
        ),
        const SizedBox(height: SpaceTokens.lg),

        _label('Active in month'),
        Wrap(
          spacing: SpaceTokens.sm,
          runSpacing: SpaceTokens.sm,
          children: List.generate(12, (i) {
            final month = i + 1;
            final selected = _draft.month == month;
            return ChoiceChip(
              label: Text(_months[i]),
              selected: selected,
              onSelected: (_) => setState(() => _draft = selected
                  ? _draft.copyWith(clearMonth: true)
                  : _draft.copyWith(month: month)),
            );
          }),
        ),
        const SizedBox(height: SpaceTokens.lg),

        _label('Sort by'),
        Wrap(
          spacing: SpaceTokens.sm,
          runSpacing: SpaceTokens.sm,
          children: SpeciesSort.values.map((s) {
            final selected = _draft.sort == s;
            return ChoiceChip(
              label: Text(s.label),
              selected: selected,
              onSelected: (_) => setState(() => _draft = _draft.copyWith(sort: s)),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            label: 'Clear',
            variant: AppButtonVariant.outline,
            onPressed: () => setState(() => _draft = _draft.clearedFacets()),
          ),
        ),
        const SizedBox(width: SpaceTokens.md),
        Expanded(
          flex: 2,
          child: AppButton(
            label: _draft.activeCount > 0
                ? 'Apply (${_draft.activeCount})'
                : 'Apply',
            onPressed: () {
              widget.onApply(_draft);
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: SpaceTokens.sm),
        child: Text(
          text,
          style: TypographyTokens.textTheme.titleSmall?.copyWith(
            color: ColorTokens.brandPrimary,
          ),
        ),
      );
}
