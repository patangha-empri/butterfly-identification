// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommentImpl _$$CommentImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$CommentImpl',
      json,
      ($checkedConvert) {
        final val = _$CommentImpl(
          id: $checkedConvert('id', (v) => v as String),
          body: $checkedConvert('body', (v) => v as String),
          user: $checkedConvert(
              'user',
              (v) => v == null
                  ? null
                  : CommentAuthor.fromJson(v as Map<String, dynamic>)),
          createdAt: $checkedConvert('created_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {'createdAt': 'created_at'},
    );

Map<String, dynamic> _$$CommentImplToJson(_$CommentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'body': instance.body,
      if (instance.user?.toJson() case final value?) 'user': value,
      if (instance.createdAt?.toIso8601String() case final value?)
        'created_at': value,
    };

_$CommentAuthorImpl _$$CommentAuthorImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$CommentAuthorImpl',
      json,
      ($checkedConvert) {
        final val = _$CommentAuthorImpl(
          id: $checkedConvert('id', (v) => v as String),
          username: $checkedConvert('username', (v) => v as String?),
          fullName: $checkedConvert('full_name', (v) => v as String?),
          profileImageUrl:
              $checkedConvert('profile_image_url', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'fullName': 'full_name',
        'profileImageUrl': 'profile_image_url'
      },
    );

Map<String, dynamic> _$$CommentAuthorImplToJson(_$CommentAuthorImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      if (instance.username case final value?) 'username': value,
      if (instance.fullName case final value?) 'full_name': value,
      if (instance.profileImageUrl case final value?)
        'profile_image_url': value,
    };
