// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'species_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpeciesDetailImpl _$$SpeciesDetailImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$SpeciesDetailImpl',
      json,
      ($checkedConvert) {
        final val = _$SpeciesDetailImpl(
          id: $checkedConvert('id', (v) => v as String),
          commonName: $checkedConvert('common_name', (v) => v as String),
          scientificName:
              $checkedConvert('scientific_name', (v) => v as String),
          family: $checkedConvert('family', (v) => v as String?),
          subfamily: $checkedConvert('subfamily', (v) => v as String?),
          genus: $checkedConvert('genus', (v) => v as String?),
          description: $checkedConvert('description', (v) => v as String?),
          habitat: $checkedConvert('habitat', (v) => v as String?),
          descriptionShort:
              $checkedConvert('description_short', (v) => v as String?),
          rarity: $checkedConvert('rarity', (v) => v as String?),
          conservationStatus:
              $checkedConvert('conservation_status', (v) => v as String?),
          wingspanMm: $checkedConvert('wingspan_mm', (v) => v as String?),
          flightMonths: $checkedConvert(
              'flight_months',
              (v) =>
                  (v as List<dynamic>?)
                      ?.map((e) => (e as num).toInt())
                      .toList() ??
                  const []),
          hostPlants: $checkedConvert(
              'host_plants',
              (v) =>
                  (v as List<dynamic>?)
                      ?.map(
                          (e) => HostPlant.fromJson(e as Map<String, dynamic>))
                      .toList() ??
                  const []),
          states: $checkedConvert(
              'states',
              (v) =>
                  (v as List<dynamic>?)?.map((e) => e as String).toList() ??
                  const []),
          images: $checkedConvert(
              'images',
              (v) =>
                  (v as List<dynamic>?)
                      ?.map((e) =>
                          SpeciesImage.fromJson(e as Map<String, dynamic>))
                      .toList() ??
                  const []),
          primaryImageUrl:
              $checkedConvert('primary_image_url', (v) => v as String?),
          observationCount: $checkedConvert(
              'observation_count', (v) => (v as num?)?.toInt() ?? 0),
          isBookmarked:
              $checkedConvert('is_bookmarked', (v) => v as bool? ?? false),
        );
        return val;
      },
      fieldKeyMap: const {
        'commonName': 'common_name',
        'scientificName': 'scientific_name',
        'descriptionShort': 'description_short',
        'conservationStatus': 'conservation_status',
        'wingspanMm': 'wingspan_mm',
        'flightMonths': 'flight_months',
        'hostPlants': 'host_plants',
        'primaryImageUrl': 'primary_image_url',
        'observationCount': 'observation_count',
        'isBookmarked': 'is_bookmarked'
      },
    );

Map<String, dynamic> _$$SpeciesDetailImplToJson(_$SpeciesDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'common_name': instance.commonName,
      'scientific_name': instance.scientificName,
      if (instance.family case final value?) 'family': value,
      if (instance.subfamily case final value?) 'subfamily': value,
      if (instance.genus case final value?) 'genus': value,
      if (instance.description case final value?) 'description': value,
      if (instance.habitat case final value?) 'habitat': value,
      if (instance.descriptionShort case final value?)
        'description_short': value,
      if (instance.rarity case final value?) 'rarity': value,
      if (instance.conservationStatus case final value?)
        'conservation_status': value,
      if (instance.wingspanMm case final value?) 'wingspan_mm': value,
      'flight_months': instance.flightMonths,
      'host_plants': instance.hostPlants.map((e) => e.toJson()).toList(),
      'states': instance.states,
      'images': instance.images.map((e) => e.toJson()).toList(),
      if (instance.primaryImageUrl case final value?)
        'primary_image_url': value,
      'observation_count': instance.observationCount,
      'is_bookmarked': instance.isBookmarked,
    };

_$SpeciesImageImpl _$$SpeciesImageImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$SpeciesImageImpl',
      json,
      ($checkedConvert) {
        final val = _$SpeciesImageImpl(
          url: $checkedConvert('image_url', (v) => v as String),
          caption: $checkedConvert('caption', (v) => v as String?),
          credit: $checkedConvert('credit', (v) => v as String?),
          isPrimary: $checkedConvert('is_primary', (v) => v as bool? ?? false),
        );
        return val;
      },
      fieldKeyMap: const {'url': 'image_url', 'isPrimary': 'is_primary'},
    );

Map<String, dynamic> _$$SpeciesImageImplToJson(_$SpeciesImageImpl instance) =>
    <String, dynamic>{
      'image_url': instance.url,
      if (instance.caption case final value?) 'caption': value,
      if (instance.credit case final value?) 'credit': value,
      'is_primary': instance.isPrimary,
    };

_$HostPlantImpl _$$HostPlantImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$HostPlantImpl',
      json,
      ($checkedConvert) {
        final val = _$HostPlantImpl(
          name: $checkedConvert('name', (v) => v as String),
          scientificName:
              $checkedConvert('scientific_name', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'scientificName': 'scientific_name'},
    );

Map<String, dynamic> _$$HostPlantImplToJson(_$HostPlantImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      if (instance.scientificName case final value?) 'scientific_name': value,
    };
