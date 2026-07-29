// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'observation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ObservationImpl _$$ObservationImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$ObservationImpl',
      json,
      ($checkedConvert) {
        final val = _$ObservationImpl(
          id: $checkedConvert('id', (v) => v as String),
          userId: $checkedConvert('user_id', (v) => v as String?),
          userName: $checkedConvert('user_name', (v) => v as String?),
          userAvatarUrl:
              $checkedConvert('user_avatar_url', (v) => v as String?),
          title: $checkedConvert('title', (v) => v as String?),
          notes: $checkedConvert('notes', (v) => v as String?),
          weather: $checkedConvert('weather', (v) => v as String?),
          butterflyActivity:
              $checkedConvert('butterfly_activity', (v) => v as String?),
          countObserved: $checkedConvert(
              'count_observed', (v) => (v as num?)?.toInt() ?? 1),
          stateId: $checkedConvert('state_id', (v) => (v as num?)?.toInt()),
          stateName: $checkedConvert('state_name', (v) => v as String?),
          districtId:
              $checkedConvert('district_id', (v) => (v as num?)?.toInt()),
          districtName: $checkedConvert('district_name', (v) => v as String?),
          latitude: $checkedConvert('latitude', (v) => (v as num?)?.toDouble()),
          longitude:
              $checkedConvert('longitude', (v) => (v as num?)?.toDouble()),
          locationName: $checkedConvert('location_name', (v) => v as String?),
          privacy: $checkedConvert('privacy', (v) => v as String? ?? 'public'),
          status: $checkedConvert('status', (v) => v as String? ?? 'pending'),
          verificationStatus:
              $checkedConvert('verification_status', (v) => v as String?),
          adminNotes: $checkedConvert('admin_notes', (v) => v as String?),
          identificationStatus:
              $checkedConvert('identification_status', (v) => v as String?),
          identifiedSpeciesId:
              $checkedConvert('identified_species_id', (v) => v as String?),
          identifiedSpeciesName:
              $checkedConvert('identified_species_name', (v) => v as String?),
          identificationConfidence: $checkedConvert(
              'identification_confidence', (v) => (v as num?)?.toDouble()),
          identificationReasoning:
              $checkedConvert('identification_reasoning', (v) => v as String?),
          rawGeminiResponse: $checkedConvert(
              'raw_gemini_response', (v) => v as Map<String, dynamic>?),
          primaryImageUrl:
              $checkedConvert('primary_image_url', (v) => v as String?),
          images: $checkedConvert(
              'images',
              (v) =>
                  (v as List<dynamic>?)
                      ?.map((e) =>
                          ObservationImage.fromJson(e as Map<String, dynamic>))
                      .toList() ??
                  const []),
          likeCount:
              $checkedConvert('like_count', (v) => (v as num?)?.toInt() ?? 0),
          commentCount: $checkedConvert(
              'comment_count', (v) => (v as num?)?.toInt() ?? 0),
          isLiked: $checkedConvert('is_liked', (v) => v as bool? ?? false),
          observedAt: $checkedConvert('observed_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
          createdAt: $checkedConvert('created_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {
        'userId': 'user_id',
        'userName': 'user_name',
        'userAvatarUrl': 'user_avatar_url',
        'butterflyActivity': 'butterfly_activity',
        'countObserved': 'count_observed',
        'stateId': 'state_id',
        'stateName': 'state_name',
        'districtId': 'district_id',
        'districtName': 'district_name',
        'locationName': 'location_name',
        'verificationStatus': 'verification_status',
        'adminNotes': 'admin_notes',
        'identificationStatus': 'identification_status',
        'identifiedSpeciesId': 'identified_species_id',
        'identifiedSpeciesName': 'identified_species_name',
        'identificationConfidence': 'identification_confidence',
        'identificationReasoning': 'identification_reasoning',
        'rawGeminiResponse': 'raw_gemini_response',
        'primaryImageUrl': 'primary_image_url',
        'likeCount': 'like_count',
        'commentCount': 'comment_count',
        'isLiked': 'is_liked',
        'observedAt': 'observed_at',
        'createdAt': 'created_at'
      },
    );

Map<String, dynamic> _$$ObservationImplToJson(_$ObservationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      if (instance.userId case final value?) 'user_id': value,
      if (instance.userName case final value?) 'user_name': value,
      if (instance.userAvatarUrl case final value?) 'user_avatar_url': value,
      if (instance.title case final value?) 'title': value,
      if (instance.notes case final value?) 'notes': value,
      if (instance.weather case final value?) 'weather': value,
      if (instance.butterflyActivity case final value?)
        'butterfly_activity': value,
      'count_observed': instance.countObserved,
      if (instance.stateId case final value?) 'state_id': value,
      if (instance.stateName case final value?) 'state_name': value,
      if (instance.districtId case final value?) 'district_id': value,
      if (instance.districtName case final value?) 'district_name': value,
      if (instance.latitude case final value?) 'latitude': value,
      if (instance.longitude case final value?) 'longitude': value,
      if (instance.locationName case final value?) 'location_name': value,
      'privacy': instance.privacy,
      'status': instance.status,
      if (instance.verificationStatus case final value?)
        'verification_status': value,
      if (instance.adminNotes case final value?) 'admin_notes': value,
      if (instance.identificationStatus case final value?)
        'identification_status': value,
      if (instance.identifiedSpeciesId case final value?)
        'identified_species_id': value,
      if (instance.identifiedSpeciesName case final value?)
        'identified_species_name': value,
      if (instance.identificationConfidence case final value?)
        'identification_confidence': value,
      if (instance.identificationReasoning case final value?)
        'identification_reasoning': value,
      if (instance.rawGeminiResponse case final value?)
        'raw_gemini_response': value,
      if (instance.primaryImageUrl case final value?)
        'primary_image_url': value,
      'images': instance.images.map((e) => e.toJson()).toList(),
      'like_count': instance.likeCount,
      'comment_count': instance.commentCount,
      'is_liked': instance.isLiked,
      if (instance.observedAt?.toIso8601String() case final value?)
        'observed_at': value,
      if (instance.createdAt?.toIso8601String() case final value?)
        'created_at': value,
    };

_$ObservationImageImpl _$$ObservationImageImplFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$ObservationImageImpl',
      json,
      ($checkedConvert) {
        final val = _$ObservationImageImpl(
          id: $checkedConvert('id', (v) => v as String?),
          optimizedUrl: $checkedConvert('optimized_url', (v) => v as String?),
          originalUrl: $checkedConvert('original_url', (v) => v as String?),
          thumbnailUrl: $checkedConvert('thumbnail_url', (v) => v as String?),
          isPrimary: $checkedConvert('is_primary', (v) => v as bool? ?? false),
        );
        return val;
      },
      fieldKeyMap: const {
        'optimizedUrl': 'optimized_url',
        'originalUrl': 'original_url',
        'thumbnailUrl': 'thumbnail_url',
        'isPrimary': 'is_primary'
      },
    );

Map<String, dynamic> _$$ObservationImageImplToJson(
        _$ObservationImageImpl instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.optimizedUrl case final value?) 'optimized_url': value,
      if (instance.originalUrl case final value?) 'original_url': value,
      if (instance.thumbnailUrl case final value?) 'thumbnail_url': value,
      'is_primary': instance.isPrimary,
    };
