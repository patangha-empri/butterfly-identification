import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_result.freezed.dart';
part 'ai_result.g.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// AI IDENTIFICATION RESULT + MATCHES
/// Matches IdentificationResult / IdentificationMatch.to_dict() from the backend.
/// The trigger endpoint runs synchronously and returns this completed result.
/// ─────────────────────────────────────────────────────────────────────────────

@freezed
class AiResult with _$AiResult {
  const factory AiResult({
    required String id,
    @JsonKey(name: 'observation_id') String? observationId,
    @Default('pending') String status,
    @JsonKey(name: 'error_message') String? errorMessage,
    @JsonKey(name: 'processing_time_ms') int? processingTimeMs,
    @JsonKey(name: 'gemini_model_version') String? modelVersion,
    @Default([]) List<AiMatch> matches,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'raw_gemini_response') Map<String, dynamic>? rawResponse,
  }) = _AiResult;

  const AiResult._();

  factory AiResult.fromJson(Map<String, dynamic> json) =>
      _$AiResultFromJson(json);

  bool get isCompleted => status == 'completed';
  bool get isFailed => status == 'failed';
  bool get isPending => status == 'pending' || status == 'processing';

  /// Sorted by rank ascending (rank 1 = best).
  List<AiMatch> get rankedMatches {
    final list = [...matches]..sort((a, b) => a.rank.compareTo(b.rank));
    return list;
  }

  AiMatch? get topMatch =>
      rankedMatches.isEmpty ? null : rankedMatches.first;

  List<AiMatch> get alternatives =>
      rankedMatches.length <= 1 ? const [] : rankedMatches.sublist(1);

  /// True when the AI ran but produced no usable match (e.g. no butterfly).
  bool get hasNoMatch => isCompleted && matches.isEmpty;

  /// True when Gemini positively saw a butterfly in the photo — even if it
  /// couldn't narrow it down to a species. Drives the manual species pick.
  bool get butterflyDetected => detection?['contains_butterfly'] == true;

  // Helpers for the new rich JSON schema
  Map<String, dynamic>? get detection => rawResponse?['detection'] as Map<String, dynamic>?;
  Map<String, dynamic>? get imageQuality => rawResponse?['image_quality'] as Map<String, dynamic>?;
  Map<String, dynamic>? get identificationReason => rawResponse?['identification_reason'] as Map<String, dynamic>?;
  Map<String, dynamic>? get speciesProfile => rawResponse?['species_profile'] as Map<String, dynamic>?;
  Map<String, dynamic>? get userGuidance => rawResponse?['user_guidance'] as Map<String, dynamic>?;
}

@freezed
class AiMatch with _$AiMatch {
  const factory AiMatch({
    required int id,
    @Default(1) int rank,
    @JsonKey(name: 'confidence_score') @Default(0) double confidenceScore,
    @JsonKey(name: 'matched_common_name') String? commonName,
    @JsonKey(name: 'matched_scientific_name') String? scientificName,
    @JsonKey(name: 'species_id') String? speciesId,
    @JsonKey(name: 'is_accepted') @Default(false) bool isAccepted,
    Map<String, dynamic>? species,
  }) = _AiMatch;

  const AiMatch._();

  factory AiMatch.fromJson(Map<String, dynamic> json) =>
      _$AiMatchFromJson(json);

  String get displayCommonName => commonName ?? 'Unknown species';
  String get displayScientificName => scientificName ?? '';

  /// Primary image from the embedded species payload, if available.
  String? get imageUrl => species?['primary_image_url'] as String?;
  String? get rarity => species?['rarity'] as String?;
}
