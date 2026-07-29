import 'package:freezed_annotation/freezed_annotation.dart';

part 'observation.freezed.dart';
part 'observation.g.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// OBSERVATION (full detail) + enums
/// Matches the Flask observation payload.
/// ─────────────────────────────────────────────────────────────────────────────

@freezed
class Observation with _$Observation {
  const factory Observation({
    required String id,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'user_name') String? userName,
    @JsonKey(name: 'user_avatar_url') String? userAvatarUrl,
    String? title,
    String? notes,
    String? weather,
    @JsonKey(name: 'butterfly_activity') String? butterflyActivity,
    @JsonKey(name: 'count_observed') @Default(1) int countObserved,
    @JsonKey(name: 'state_id') int? stateId,
    @JsonKey(name: 'state_name') String? stateName,
    @JsonKey(name: 'district_id') int? districtId,
    @JsonKey(name: 'district_name') String? districtName,
    double? latitude,
    double? longitude,
    @JsonKey(name: 'location_name') String? locationName,
    @Default('public') String privacy,
    @Default('pending') String status,
    @JsonKey(name: 'verification_status') String? verificationStatus,
    // Moderation note (e.g. rejection reason) — only present for owner/staff.
    @JsonKey(name: 'admin_notes') String? adminNotes,
    @JsonKey(name: 'identification_status') String? identificationStatus,
    @JsonKey(name: 'identified_species_id') String? identifiedSpeciesId,
    @JsonKey(name: 'identified_species_name') String? identifiedSpeciesName,
    @JsonKey(name: 'identification_confidence') double? identificationConfidence,
    @JsonKey(name: 'identification_reasoning') String? identificationReasoning,
    @JsonKey(name: 'raw_gemini_response') Map<String, dynamic>? rawGeminiResponse,
    @JsonKey(name: 'primary_image_url') String? primaryImageUrl,
    @Default([]) List<ObservationImage> images,
    @JsonKey(name: 'like_count') @Default(0) int likeCount,
    @JsonKey(name: 'comment_count') @Default(0) int commentCount,
    @JsonKey(name: 'is_liked') @Default(false) bool isLiked,
    @JsonKey(name: 'observed_at') DateTime? observedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Observation;

  const Observation._();

  factory Observation.fromJson(Map<String, dynamic> json) =>
      _$ObservationFromJson(json);

  List<String> get imageUrls {
    final urls =
        images.map((i) => i.url).where((u) => u.isNotEmpty).toList();
    if (primaryImageUrl != null &&
        primaryImageUrl!.isNotEmpty &&
        !urls.contains(primaryImageUrl)) {
      urls.insert(0, primaryImageUrl!);
    }
    return urls;
  }

  bool get isIdentified =>
      identifiedSpeciesName != null && identifiedSpeciesName!.isNotEmpty;

  bool get isAnalysing =>
      identificationStatus == 'processing' || identificationStatus == 'pending';

  /// Rejected by a moderator — hidden from the community, visible to the owner.
  bool get isRejected => verificationStatus == 'rejected';
}

@freezed
class ObservationImage with _$ObservationImage {
  const factory ObservationImage({
    String? id,
    // Backend returns original_url / optimized_url / thumbnail_url (no image_url).
    @JsonKey(name: 'optimized_url') String? optimizedUrl,
    @JsonKey(name: 'original_url') String? originalUrl,
    @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
    @JsonKey(name: 'is_primary') @Default(false) bool isPrimary,
  }) = _ObservationImage;

  const ObservationImage._();

  factory ObservationImage.fromJson(Map<String, dynamic> json) =>
      _$ObservationImageFromJson(json);

  /// Best display URL, preferring the optimized variant.
  String get url => optimizedUrl ?? originalUrl ?? thumbnailUrl ?? '';
}

// ── Enums (backend-aligned values) ───────────────────────────────────────────

enum ObservationPrivacy {
  public('public', 'Public', 'Visible to everyone'),
  anonymousPublic('anonymous_public', 'Anonymous', 'Public without your name'),
  private('private', 'Private', 'Only you and admins');

  const ObservationPrivacy(this.value, this.label, this.description);
  final String value;
  final String label;
  final String description;

  static ObservationPrivacy fromValue(String? v) => values.firstWhere(
        (e) => e.value == v,
        orElse: () => ObservationPrivacy.public,
      );
}

enum Weather {
  sunny('sunny', 'Sunny', '☀️'),
  partlyCloudy('partly_cloudy', 'Partly cloudy', '⛅'),
  cloudy('cloudy', 'Cloudy', '☁️'),
  overcast('overcast', 'Overcast', '🌥️'),
  rainy('rainy', 'Rainy', '🌧️'),
  windy('windy', 'Windy', '💨');

  const Weather(this.value, this.label, this.emoji);
  final String value;
  final String label;
  final String emoji;
}

enum ButterflyActivity {
  feeding('feeding', 'Feeding'),
  resting('resting', 'Resting'),
  mating('mating', 'Mating'),
  flying('flying', 'Flying'),
  ovipositing('ovipositing', 'Laying eggs'),
  puddling('puddling', 'Puddling'),
  basking('basking', 'Basking');

  const ButterflyActivity(this.value, this.label);
  final String value;
  final String label;
}
