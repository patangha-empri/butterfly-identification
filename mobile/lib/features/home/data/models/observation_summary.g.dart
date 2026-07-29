// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'observation_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ObservationSummaryImpl _$$ObservationSummaryImplFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$ObservationSummaryImpl',
      json,
      ($checkedConvert) {
        final val = _$ObservationSummaryImpl(
          id: $checkedConvert('id', (v) => v as String),
          title: $checkedConvert('title', (v) => v as String?),
          userId: $checkedConvert('user_id', (v) => v as String?),
          userName: $checkedConvert('user_name', (v) => v as String?),
          userUsername: $checkedConvert('user_username', (v) => v as String?),
          userAvatarUrl:
              $checkedConvert('user_avatar_url', (v) => v as String?),
          stateName: $checkedConvert('state_name', (v) => v as String?),
          locationName: $checkedConvert('location_name', (v) => v as String?),
          latitude: $checkedConvert('latitude', (v) => (v as num?)?.toDouble()),
          longitude:
              $checkedConvert('longitude', (v) => (v as num?)?.toDouble()),
          privacy: $checkedConvert('privacy', (v) => v as String? ?? 'public'),
          status: $checkedConvert('status', (v) => v as String? ?? 'pending'),
          verificationStatus:
              $checkedConvert('verification_status', (v) => v as String?),
          identifiedSpeciesId:
              $checkedConvert('identified_species_id', (v) => v as String?),
          identifiedSpeciesName:
              $checkedConvert('identified_species_name', (v) => v as String?),
          identificationConfidence: $checkedConvert(
              'identification_confidence', (v) => (v as num?)?.toDouble()),
          primaryImageUrl:
              $checkedConvert('primary_image_url', (v) => v as String?),
          likeCount:
              $checkedConvert('like_count', (v) => (v as num?)?.toInt() ?? 0),
          commentCount: $checkedConvert(
              'comment_count', (v) => (v as num?)?.toInt() ?? 0),
          isLiked: $checkedConvert('is_liked', (v) => v as bool? ?? false),
          createdAt: $checkedConvert('created_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {
        'userId': 'user_id',
        'userName': 'user_name',
        'userUsername': 'user_username',
        'userAvatarUrl': 'user_avatar_url',
        'stateName': 'state_name',
        'locationName': 'location_name',
        'verificationStatus': 'verification_status',
        'identifiedSpeciesId': 'identified_species_id',
        'identifiedSpeciesName': 'identified_species_name',
        'identificationConfidence': 'identification_confidence',
        'primaryImageUrl': 'primary_image_url',
        'likeCount': 'like_count',
        'commentCount': 'comment_count',
        'isLiked': 'is_liked',
        'createdAt': 'created_at'
      },
    );

Map<String, dynamic> _$$ObservationSummaryImplToJson(
        _$ObservationSummaryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      if (instance.title case final value?) 'title': value,
      if (instance.userId case final value?) 'user_id': value,
      if (instance.userName case final value?) 'user_name': value,
      if (instance.userUsername case final value?) 'user_username': value,
      if (instance.userAvatarUrl case final value?) 'user_avatar_url': value,
      if (instance.stateName case final value?) 'state_name': value,
      if (instance.locationName case final value?) 'location_name': value,
      if (instance.latitude case final value?) 'latitude': value,
      if (instance.longitude case final value?) 'longitude': value,
      'privacy': instance.privacy,
      'status': instance.status,
      if (instance.verificationStatus case final value?)
        'verification_status': value,
      if (instance.identifiedSpeciesId case final value?)
        'identified_species_id': value,
      if (instance.identifiedSpeciesName case final value?)
        'identified_species_name': value,
      if (instance.identificationConfidence case final value?)
        'identification_confidence': value,
      if (instance.primaryImageUrl case final value?)
        'primary_image_url': value,
      'like_count': instance.likeCount,
      'comment_count': instance.commentCount,
      'is_liked': instance.isLiked,
      if (instance.createdAt?.toIso8601String() case final value?)
        'created_at': value,
    };
