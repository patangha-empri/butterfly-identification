// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'species_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpeciesSummaryImpl _$$SpeciesSummaryImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$SpeciesSummaryImpl',
      json,
      ($checkedConvert) {
        final val = _$SpeciesSummaryImpl(
          id: $checkedConvert('id', (v) => v as String),
          commonName: $checkedConvert('common_name', (v) => v as String),
          scientificName:
              $checkedConvert('scientific_name', (v) => v as String),
          family: $checkedConvert('family', (v) => v as String?),
          rarity: $checkedConvert('rarity', (v) => v as String?),
          conservationStatus:
              $checkedConvert('conservation_status', (v) => v as String?),
          primaryImageUrl:
              $checkedConvert('primary_image_url', (v) => v as String?),
          observationCount: $checkedConvert(
              'observation_count', (v) => (v as num?)?.toInt() ?? 0),
          descriptionShort:
              $checkedConvert('description_short', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'commonName': 'common_name',
        'scientificName': 'scientific_name',
        'conservationStatus': 'conservation_status',
        'primaryImageUrl': 'primary_image_url',
        'observationCount': 'observation_count',
        'descriptionShort': 'description_short'
      },
    );

Map<String, dynamic> _$$SpeciesSummaryImplToJson(
        _$SpeciesSummaryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'common_name': instance.commonName,
      'scientific_name': instance.scientificName,
      if (instance.family case final value?) 'family': value,
      if (instance.rarity case final value?) 'rarity': value,
      if (instance.conservationStatus case final value?)
        'conservation_status': value,
      if (instance.primaryImageUrl case final value?)
        'primary_image_url': value,
      'observation_count': instance.observationCount,
      if (instance.descriptionShort case final value?)
        'description_short': value,
    };
