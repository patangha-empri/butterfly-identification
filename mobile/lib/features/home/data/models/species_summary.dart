import 'package:freezed_annotation/freezed_annotation.dart';

part 'species_summary.freezed.dart';
part 'species_summary.g.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// SPECIES SUMMARY
/// Lightweight species projection used by feeds, carousels and grids.
/// Matches the backend species list shape (snake_case).
/// ─────────────────────────────────────────────────────────────────────────────

@freezed
class SpeciesSummary with _$SpeciesSummary {
  const factory SpeciesSummary({
    required String id,
    @JsonKey(name: 'common_name') required String commonName,
    @JsonKey(name: 'scientific_name') required String scientificName,
    String? family,
    String? rarity,
    @JsonKey(name: 'conservation_status') String? conservationStatus,
    @JsonKey(name: 'primary_image_url') String? primaryImageUrl,
    @JsonKey(name: 'observation_count') @Default(0) int observationCount,
    @JsonKey(name: 'description_short') String? descriptionShort,
  }) = _SpeciesSummary;

  factory SpeciesSummary.fromJson(Map<String, dynamic> json) =>
      _$SpeciesSummaryFromJson(json);
}
