// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$UserModelImpl',
      json,
      ($checkedConvert) {
        final val = _$UserModelImpl(
          id: $checkedConvert('id', (v) => v as String),
          username: $checkedConvert('username', (v) => v as String),
          email: $checkedConvert('email', (v) => v as String),
          fullName: $checkedConvert('full_name', (v) => v as String),
          bio: $checkedConvert('bio', (v) => v as String?),
          profileImageUrl:
              $checkedConvert('profile_image_url', (v) => v as String?),
          role: $checkedConvert('role', (v) => v as String? ?? 'user'),
          observationCount: $checkedConvert(
              'observation_count', (v) => (v as num?)?.toInt() ?? 0),
          speciesCount: $checkedConvert(
              'species_count', (v) => (v as num?)?.toInt() ?? 0),
          isVerified:
              $checkedConvert('is_verified', (v) => v as bool? ?? false),
          activeWarnings: $checkedConvert(
              'active_warnings', (v) => (v as num?)?.toInt() ?? 0),
          createdAt: $checkedConvert('created_at', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'fullName': 'full_name',
        'profileImageUrl': 'profile_image_url',
        'observationCount': 'observation_count',
        'speciesCount': 'species_count',
        'isVerified': 'is_verified',
        'activeWarnings': 'active_warnings',
        'createdAt': 'created_at'
      },
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'full_name': instance.fullName,
      if (instance.bio case final value?) 'bio': value,
      if (instance.profileImageUrl case final value?)
        'profile_image_url': value,
      if (instance.role case final value?) 'role': value,
      if (instance.observationCount case final value?)
        'observation_count': value,
      if (instance.speciesCount case final value?) 'species_count': value,
      if (instance.isVerified case final value?) 'is_verified': value,
      if (instance.activeWarnings case final value?) 'active_warnings': value,
      if (instance.createdAt case final value?) 'created_at': value,
    };

_$AuthTokensModelImpl _$$AuthTokensModelImplFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$AuthTokensModelImpl',
      json,
      ($checkedConvert) {
        final val = _$AuthTokensModelImpl(
          accessToken: $checkedConvert('access_token', (v) => v as String),
          refreshToken: $checkedConvert('refresh_token', (v) => v as String),
          user: $checkedConvert(
              'user', (v) => UserModel.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {
        'accessToken': 'access_token',
        'refreshToken': 'refresh_token'
      },
    );

Map<String, dynamic> _$$AuthTokensModelImplToJson(
        _$AuthTokensModelImpl instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'user': instance.user.toJson(),
    };
