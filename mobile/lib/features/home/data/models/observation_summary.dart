import 'package:freezed_annotation/freezed_annotation.dart';

part 'observation_summary.freezed.dart';
part 'observation_summary.g.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// OBSERVATION SUMMARY
/// Lightweight sighting projection for feeds (nearby / recent / community).
/// ─────────────────────────────────────────────────────────────────────────────

@freezed
class ObservationSummary with _$ObservationSummary {
  const factory ObservationSummary({
    required String id,
    String? title,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'user_name') String? userName,
    @JsonKey(name: 'user_username') String? userUsername,
    @JsonKey(name: 'user_avatar_url') String? userAvatarUrl,
    @JsonKey(name: 'state_name') String? stateName,
    @JsonKey(name: 'location_name') String? locationName,
    double? latitude,
    double? longitude,
    @Default('public') String privacy,
    @Default('pending') String status,
    @JsonKey(name: 'verification_status') String? verificationStatus,
    @JsonKey(name: 'identified_species_id') String? identifiedSpeciesId,
    @JsonKey(name: 'identified_species_name') String? identifiedSpeciesName,
    @JsonKey(name: 'identification_confidence') double? identificationConfidence,
    @JsonKey(name: 'primary_image_url') String? primaryImageUrl,
    @JsonKey(name: 'like_count') @Default(0) int likeCount,
    @JsonKey(name: 'comment_count') @Default(0) int commentCount,
    @JsonKey(name: 'is_liked') @Default(false) bool isLiked,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _ObservationSummary;

  factory ObservationSummary.fromJson(Map<String, dynamic> json) =>
      _$ObservationSummaryFromJson(json);
}
