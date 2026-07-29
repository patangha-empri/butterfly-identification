// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationPreferencesImpl _$$NotificationPreferencesImplFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$NotificationPreferencesImpl',
      json,
      ($checkedConvert) {
        final val = _$NotificationPreferencesImpl(
          identificationComplete: $checkedConvert(
              'identification_complete', (v) => v as bool? ?? true),
          newSpeciesNearby:
              $checkedConvert('new_species_nearby', (v) => v as bool? ?? true),
          adminVerification:
              $checkedConvert('admin_verification', (v) => v as bool? ?? true),
          educationalAlerts:
              $checkedConvert('educational_alerts', (v) => v as bool? ?? true),
          events: $checkedConvert('events', (v) => v as bool? ?? true),
        );
        return val;
      },
      fieldKeyMap: const {
        'identificationComplete': 'identification_complete',
        'newSpeciesNearby': 'new_species_nearby',
        'adminVerification': 'admin_verification',
        'educationalAlerts': 'educational_alerts'
      },
    );

Map<String, dynamic> _$$NotificationPreferencesImplToJson(
        _$NotificationPreferencesImpl instance) =>
    <String, dynamic>{
      'identification_complete': instance.identificationComplete,
      'new_species_nearby': instance.newSpeciesNearby,
      'admin_verification': instance.adminVerification,
      'educational_alerts': instance.educationalAlerts,
      'events': instance.events,
    };
