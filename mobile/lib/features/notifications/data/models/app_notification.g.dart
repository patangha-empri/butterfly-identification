// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppNotificationImpl _$$AppNotificationImplFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$AppNotificationImpl',
      json,
      ($checkedConvert) {
        final val = _$AppNotificationImpl(
          id: $checkedConvert('id', (v) => v as String),
          type: $checkedConvert('type', (v) => v as String? ?? 'system'),
          title: $checkedConvert('title', (v) => v as String? ?? ''),
          body: $checkedConvert('body', (v) => v as String? ?? ''),
          data: $checkedConvert('data', (v) => v as Map<String, dynamic>?),
          isRead: $checkedConvert('is_read', (v) => v as bool? ?? false),
          createdAt: $checkedConvert('created_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {'isRead': 'is_read', 'createdAt': 'created_at'},
    );

Map<String, dynamic> _$$AppNotificationImplToJson(
        _$AppNotificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'body': instance.body,
      if (instance.data case final value?) 'data': value,
      'is_read': instance.isRead,
      if (instance.createdAt?.toIso8601String() case final value?)
        'created_at': value,
    };
