// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PublicProfileImpl _$$PublicProfileImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$PublicProfileImpl',
      json,
      ($checkedConvert) {
        final val = _$PublicProfileImpl(
          id: $checkedConvert('id', (v) => v as String),
          username: $checkedConvert('username', (v) => v as String),
          fullName: $checkedConvert('full_name', (v) => v as String?),
          profileImageUrl:
              $checkedConvert('profile_image_url', (v) => v as String?),
          bio: $checkedConvert('bio', (v) => v as String?),
          isVerified:
              $checkedConvert('is_verified', (v) => v as bool? ?? false),
          createdAt: $checkedConvert('created_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {
        'fullName': 'full_name',
        'profileImageUrl': 'profile_image_url',
        'isVerified': 'is_verified',
        'createdAt': 'created_at'
      },
    );

Map<String, dynamic> _$$PublicProfileImplToJson(_$PublicProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      if (instance.fullName case final value?) 'full_name': value,
      if (instance.profileImageUrl case final value?)
        'profile_image_url': value,
      if (instance.bio case final value?) 'bio': value,
      'is_verified': instance.isVerified,
      if (instance.createdAt?.toIso8601String() case final value?)
        'created_at': value,
    };
