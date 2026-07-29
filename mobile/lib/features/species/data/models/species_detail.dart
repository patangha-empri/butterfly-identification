import 'package:freezed_annotation/freezed_annotation.dart';

part 'species_detail.freezed.dart';
part 'species_detail.g.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// SPECIES DETAIL
/// Full species record powering the detail page. All rich fields are nullable /
/// defaulted so the UI degrades gracefully against partial backend payloads.
/// ─────────────────────────────────────────────────────────────────────────────

@freezed
class SpeciesDetail with _$SpeciesDetail {
  const factory SpeciesDetail({
    required String id,
    @JsonKey(name: 'common_name') required String commonName,
    @JsonKey(name: 'scientific_name') required String scientificName,
    String? family,
    String? subfamily,
    String? genus,
    String? description,
    String? habitat,
    @JsonKey(name: 'description_short') String? descriptionShort,
    String? rarity,
    @JsonKey(name: 'conservation_status') String? conservationStatus,
    @JsonKey(name: 'wingspan_mm') String? wingspanMm,
    @JsonKey(name: 'flight_months') @Default([]) List<int> flightMonths,
    @JsonKey(name: 'host_plants') @Default([]) List<HostPlant> hostPlants,
    @Default([]) List<String> states,
    @Default([]) List<SpeciesImage> images,
    @JsonKey(name: 'primary_image_url') String? primaryImageUrl,
    @JsonKey(name: 'observation_count') @Default(0) int observationCount,
    @JsonKey(name: 'is_bookmarked') @Default(false) bool isBookmarked,
  }) = _SpeciesDetail;

  const SpeciesDetail._();

  factory SpeciesDetail.fromJson(Map<String, dynamic> json) =>
      _$SpeciesDetailFromJson(json);

  /// All gallery image URLs, ensuring the primary image is first.
  List<String> get galleryUrls {
    final urls = images.map((i) => i.url).toList();
    if (primaryImageUrl != null && !urls.contains(primaryImageUrl)) {
      urls.insert(0, primaryImageUrl!);
    }
    return urls;
  }

  bool get hasDistribution => states.isNotEmpty;
  bool get hasHostPlants => hostPlants.isNotEmpty;
  bool get hasFlightData => flightMonths.isNotEmpty;
}

@freezed
class SpeciesImage with _$SpeciesImage {
  const factory SpeciesImage({
    @JsonKey(name: 'image_url') required String url,
    String? caption,
    String? credit,
    @JsonKey(name: 'is_primary') @Default(false) bool isPrimary,
  }) = _SpeciesImage;

  factory SpeciesImage.fromJson(Map<String, dynamic> json) =>
      _$SpeciesImageFromJson(json);
}

@freezed
class HostPlant with _$HostPlant {
  const factory HostPlant({
    required String name,
    @JsonKey(name: 'scientific_name') String? scientificName,
  }) = _HostPlant;

  factory HostPlant.fromJson(Map<String, dynamic> json) =>
      _$HostPlantFromJson(json);
}
