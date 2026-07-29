// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geography_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IndiaStateImpl _$$IndiaStateImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$IndiaStateImpl',
      json,
      ($checkedConvert) {
        final val = _$IndiaStateImpl(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          name: $checkedConvert('name', (v) => v as String),
          code: $checkedConvert('code', (v) => v as String?),
          region: $checkedConvert('region', (v) => v as String?),
          isUnionTerritory:
              $checkedConvert('is_union_territory', (v) => v as bool? ?? false),
        );
        return val;
      },
      fieldKeyMap: const {'isUnionTerritory': 'is_union_territory'},
    );

Map<String, dynamic> _$$IndiaStateImplToJson(_$IndiaStateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      if (instance.code case final value?) 'code': value,
      if (instance.region case final value?) 'region': value,
      'is_union_territory': instance.isUnionTerritory,
    };

_$IndiaDistrictImpl _$$IndiaDistrictImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$IndiaDistrictImpl',
      json,
      ($checkedConvert) {
        final val = _$IndiaDistrictImpl(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          name: $checkedConvert('name', (v) => v as String),
          stateId: $checkedConvert('state_id', (v) => (v as num?)?.toInt()),
          latitude: $checkedConvert('latitude', (v) => (v as num?)?.toDouble()),
          longitude:
              $checkedConvert('longitude', (v) => (v as num?)?.toDouble()),
        );
        return val;
      },
      fieldKeyMap: const {'stateId': 'state_id'},
    );

Map<String, dynamic> _$$IndiaDistrictImplToJson(_$IndiaDistrictImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      if (instance.stateId case final value?) 'state_id': value,
      if (instance.latitude case final value?) 'latitude': value,
      if (instance.longitude case final value?) 'longitude': value,
    };
