import 'package:equatable/equatable.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// SPECIES FILTER
/// Immutable filter/query state for the species listing. Used as a provider
/// family key, so it implements value equality.
/// ─────────────────────────────────────────────────────────────────────────────

class SpeciesFilter extends Equatable {
  const SpeciesFilter({
    this.query,
    this.rarity,
    this.family,
    this.stateId,
    this.month,
    this.sort = SpeciesSort.nameAsc,
  });

  final String? query;
  final String? rarity;
  final String? family;
  final int? stateId;
  final int? month; // 1–12 (seasonal activity)
  final SpeciesSort sort;

  /// Number of active facet filters (excludes free-text query + default sort).
  int get activeCount => [
        rarity,
        family,
        stateId,
        month,
      ].where((e) => e != null).length;

  bool get hasQuery => query != null && query!.trim().isNotEmpty;
  bool get isEmpty => activeCount == 0 && !hasQuery && sort == SpeciesSort.nameAsc;

  /// copyWith with explicit clearing via [clear*] flags.
  SpeciesFilter copyWith({
    String? query,
    String? rarity,
    String? family,
    int? stateId,
    int? month,
    SpeciesSort? sort,
    bool clearQuery = false,
    bool clearRarity = false,
    bool clearFamily = false,
    bool clearState = false,
    bool clearMonth = false,
  }) {
    return SpeciesFilter(
      query: clearQuery ? null : (query ?? this.query),
      rarity: clearRarity ? null : (rarity ?? this.rarity),
      family: clearFamily ? null : (family ?? this.family),
      stateId: clearState ? null : (stateId ?? this.stateId),
      month: clearMonth ? null : (month ?? this.month),
      sort: sort ?? this.sort,
    );
  }

  /// Clears all facet filters but keeps the free-text query + sort.
  SpeciesFilter clearedFacets() => SpeciesFilter(query: query, sort: sort);

  Map<String, dynamic> toQueryParameters({required int page, int perPage = 20}) {
    // Backend (GET /species/) supports: search, family, conservation_status,
    // state_id, color, is_migratory. `sort`/`month`/`rarity` have no server
    // equivalent yet, so they're omitted (ignored facets) rather than sent.
    return {
      'page': page,
      'per_page': perPage,
      if (hasQuery) 'search': query!.trim(),
      if (family != null) 'family': family,
      if (stateId != null) 'state_id': stateId,
    };
  }

  @override
  List<Object?> get props => [query, rarity, family, stateId, month, sort];
}

enum SpeciesSort {
  nameAsc('name_asc', 'Name (A–Z)'),
  nameDesc('name_desc', 'Name (Z–A)'),
  rarity('rarity', 'Rarity'),
  mostObserved('most_observed', 'Most observed');

  const SpeciesSort(this.apiValue, this.label);
  final String apiValue;
  final String label;
}

/// Common butterfly families in India (filter options).
const kButterflyFamilies = <String>[
  'Papilionidae',
  'Pieridae',
  'Nymphalidae',
  'Lycaenidae',
  'Hesperiidae',
  'Riodinidae',
];

const kRarityOptions = <String>[
  'common',
  'uncommon',
  'rare',
  'very_rare',
  'endangered',
];
