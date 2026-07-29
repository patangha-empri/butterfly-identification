// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AiResultImpl _$$AiResultImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$AiResultImpl',
      json,
      ($checkedConvert) {
        final val = _$AiResultImpl(
          id: $checkedConvert('id', (v) => v as String),
          observationId: $checkedConvert('observation_id', (v) => v as String?),
          status: $checkedConvert('status', (v) => v as String? ?? 'pending'),
          errorMessage: $checkedConvert('error_message', (v) => v as String?),
          processingTimeMs: $checkedConvert(
              'processing_time_ms', (v) => (v as num?)?.toInt()),
          modelVersion:
              $checkedConvert('gemini_model_version', (v) => v as String?),
          matches: $checkedConvert(
              'matches',
              (v) =>
                  (v as List<dynamic>?)
                      ?.map((e) => AiMatch.fromJson(e as Map<String, dynamic>))
                      .toList() ??
                  const []),
          createdAt: $checkedConvert('created_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
          completedAt: $checkedConvert('completed_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
          rawResponse: $checkedConvert(
              'raw_gemini_response', (v) => v as Map<String, dynamic>?),
        );
        return val;
      },
      fieldKeyMap: const {
        'observationId': 'observation_id',
        'errorMessage': 'error_message',
        'processingTimeMs': 'processing_time_ms',
        'modelVersion': 'gemini_model_version',
        'createdAt': 'created_at',
        'completedAt': 'completed_at',
        'rawResponse': 'raw_gemini_response'
      },
    );

Map<String, dynamic> _$$AiResultImplToJson(_$AiResultImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      if (instance.observationId case final value?) 'observation_id': value,
      'status': instance.status,
      if (instance.errorMessage case final value?) 'error_message': value,
      if (instance.processingTimeMs case final value?)
        'processing_time_ms': value,
      if (instance.modelVersion case final value?)
        'gemini_model_version': value,
      'matches': instance.matches.map((e) => e.toJson()).toList(),
      if (instance.createdAt?.toIso8601String() case final value?)
        'created_at': value,
      if (instance.completedAt?.toIso8601String() case final value?)
        'completed_at': value,
      if (instance.rawResponse case final value?) 'raw_gemini_response': value,
    };

_$AiMatchImpl _$$AiMatchImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$AiMatchImpl',
      json,
      ($checkedConvert) {
        final val = _$AiMatchImpl(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          rank: $checkedConvert('rank', (v) => (v as num?)?.toInt() ?? 1),
          confidenceScore: $checkedConvert(
              'confidence_score', (v) => (v as num?)?.toDouble() ?? 0),
          commonName:
              $checkedConvert('matched_common_name', (v) => v as String?),
          scientificName:
              $checkedConvert('matched_scientific_name', (v) => v as String?),
          speciesId: $checkedConvert('species_id', (v) => v as String?),
          isAccepted:
              $checkedConvert('is_accepted', (v) => v as bool? ?? false),
          species:
              $checkedConvert('species', (v) => v as Map<String, dynamic>?),
        );
        return val;
      },
      fieldKeyMap: const {
        'confidenceScore': 'confidence_score',
        'commonName': 'matched_common_name',
        'scientificName': 'matched_scientific_name',
        'speciesId': 'species_id',
        'isAccepted': 'is_accepted'
      },
    );

Map<String, dynamic> _$$AiMatchImplToJson(_$AiMatchImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rank': instance.rank,
      'confidence_score': instance.confidenceScore,
      if (instance.commonName case final value?) 'matched_common_name': value,
      if (instance.scientificName case final value?)
        'matched_scientific_name': value,
      if (instance.speciesId case final value?) 'species_id': value,
      'is_accepted': instance.isAccepted,
      if (instance.species case final value?) 'species': value,
    };
