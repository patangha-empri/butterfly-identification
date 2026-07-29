// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'species_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SpeciesDetail _$SpeciesDetailFromJson(Map<String, dynamic> json) {
  return _SpeciesDetail.fromJson(json);
}

/// @nodoc
mixin _$SpeciesDetail {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'common_name')
  String get commonName => throw _privateConstructorUsedError;
  @JsonKey(name: 'scientific_name')
  String get scientificName => throw _privateConstructorUsedError;
  String? get family => throw _privateConstructorUsedError;
  String? get subfamily => throw _privateConstructorUsedError;
  String? get genus => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get habitat => throw _privateConstructorUsedError;
  @JsonKey(name: 'description_short')
  String? get descriptionShort => throw _privateConstructorUsedError;
  String? get rarity => throw _privateConstructorUsedError;
  @JsonKey(name: 'conservation_status')
  String? get conservationStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'wingspan_mm')
  String? get wingspanMm => throw _privateConstructorUsedError;
  @JsonKey(name: 'flight_months')
  List<int> get flightMonths => throw _privateConstructorUsedError;
  @JsonKey(name: 'host_plants')
  List<HostPlant> get hostPlants => throw _privateConstructorUsedError;
  List<String> get states => throw _privateConstructorUsedError;
  List<SpeciesImage> get images => throw _privateConstructorUsedError;
  @JsonKey(name: 'primary_image_url')
  String? get primaryImageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'observation_count')
  int get observationCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_bookmarked')
  bool get isBookmarked => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            @JsonKey(name: 'common_name') String commonName,
            @JsonKey(name: 'scientific_name') String scientificName,
            String? family,
            String? subfamily,
            String? genus,
            String? description,
            String? habitat,
            @JsonKey(name: 'description_short') String? descriptionShort,
            String? rarity,
            @JsonKey(name: 'conservation_status') String? conservationStatus,
            @JsonKey(name: 'wingspan_mm') String? wingspanMm,
            @JsonKey(name: 'flight_months') List<int> flightMonths,
            @JsonKey(name: 'host_plants') List<HostPlant> hostPlants,
            List<String> states,
            List<SpeciesImage> images,
            @JsonKey(name: 'primary_image_url') String? primaryImageUrl,
            @JsonKey(name: 'observation_count') int observationCount,
            @JsonKey(name: 'is_bookmarked') bool isBookmarked)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            @JsonKey(name: 'common_name') String commonName,
            @JsonKey(name: 'scientific_name') String scientificName,
            String? family,
            String? subfamily,
            String? genus,
            String? description,
            String? habitat,
            @JsonKey(name: 'description_short') String? descriptionShort,
            String? rarity,
            @JsonKey(name: 'conservation_status') String? conservationStatus,
            @JsonKey(name: 'wingspan_mm') String? wingspanMm,
            @JsonKey(name: 'flight_months') List<int> flightMonths,
            @JsonKey(name: 'host_plants') List<HostPlant> hostPlants,
            List<String> states,
            List<SpeciesImage> images,
            @JsonKey(name: 'primary_image_url') String? primaryImageUrl,
            @JsonKey(name: 'observation_count') int observationCount,
            @JsonKey(name: 'is_bookmarked') bool isBookmarked)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            @JsonKey(name: 'common_name') String commonName,
            @JsonKey(name: 'scientific_name') String scientificName,
            String? family,
            String? subfamily,
            String? genus,
            String? description,
            String? habitat,
            @JsonKey(name: 'description_short') String? descriptionShort,
            String? rarity,
            @JsonKey(name: 'conservation_status') String? conservationStatus,
            @JsonKey(name: 'wingspan_mm') String? wingspanMm,
            @JsonKey(name: 'flight_months') List<int> flightMonths,
            @JsonKey(name: 'host_plants') List<HostPlant> hostPlants,
            List<String> states,
            List<SpeciesImage> images,
            @JsonKey(name: 'primary_image_url') String? primaryImageUrl,
            @JsonKey(name: 'observation_count') int observationCount,
            @JsonKey(name: 'is_bookmarked') bool isBookmarked)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_SpeciesDetail value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_SpeciesDetail value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_SpeciesDetail value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this SpeciesDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpeciesDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpeciesDetailCopyWith<SpeciesDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpeciesDetailCopyWith<$Res> {
  factory $SpeciesDetailCopyWith(
          SpeciesDetail value, $Res Function(SpeciesDetail) then) =
      _$SpeciesDetailCopyWithImpl<$Res, SpeciesDetail>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'common_name') String commonName,
      @JsonKey(name: 'scientific_name') String scientificName,
      String? family,
      String? subfamily,
      String? genus,
      String? description,
      String? habitat,
      @JsonKey(name: 'description_short') String? descriptionShort,
      String? rarity,
      @JsonKey(name: 'conservation_status') String? conservationStatus,
      @JsonKey(name: 'wingspan_mm') String? wingspanMm,
      @JsonKey(name: 'flight_months') List<int> flightMonths,
      @JsonKey(name: 'host_plants') List<HostPlant> hostPlants,
      List<String> states,
      List<SpeciesImage> images,
      @JsonKey(name: 'primary_image_url') String? primaryImageUrl,
      @JsonKey(name: 'observation_count') int observationCount,
      @JsonKey(name: 'is_bookmarked') bool isBookmarked});
}

/// @nodoc
class _$SpeciesDetailCopyWithImpl<$Res, $Val extends SpeciesDetail>
    implements $SpeciesDetailCopyWith<$Res> {
  _$SpeciesDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpeciesDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? commonName = null,
    Object? scientificName = null,
    Object? family = freezed,
    Object? subfamily = freezed,
    Object? genus = freezed,
    Object? description = freezed,
    Object? habitat = freezed,
    Object? descriptionShort = freezed,
    Object? rarity = freezed,
    Object? conservationStatus = freezed,
    Object? wingspanMm = freezed,
    Object? flightMonths = null,
    Object? hostPlants = null,
    Object? states = null,
    Object? images = null,
    Object? primaryImageUrl = freezed,
    Object? observationCount = null,
    Object? isBookmarked = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      commonName: null == commonName
          ? _value.commonName
          : commonName // ignore: cast_nullable_to_non_nullable
              as String,
      scientificName: null == scientificName
          ? _value.scientificName
          : scientificName // ignore: cast_nullable_to_non_nullable
              as String,
      family: freezed == family
          ? _value.family
          : family // ignore: cast_nullable_to_non_nullable
              as String?,
      subfamily: freezed == subfamily
          ? _value.subfamily
          : subfamily // ignore: cast_nullable_to_non_nullable
              as String?,
      genus: freezed == genus
          ? _value.genus
          : genus // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      habitat: freezed == habitat
          ? _value.habitat
          : habitat // ignore: cast_nullable_to_non_nullable
              as String?,
      descriptionShort: freezed == descriptionShort
          ? _value.descriptionShort
          : descriptionShort // ignore: cast_nullable_to_non_nullable
              as String?,
      rarity: freezed == rarity
          ? _value.rarity
          : rarity // ignore: cast_nullable_to_non_nullable
              as String?,
      conservationStatus: freezed == conservationStatus
          ? _value.conservationStatus
          : conservationStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      wingspanMm: freezed == wingspanMm
          ? _value.wingspanMm
          : wingspanMm // ignore: cast_nullable_to_non_nullable
              as String?,
      flightMonths: null == flightMonths
          ? _value.flightMonths
          : flightMonths // ignore: cast_nullable_to_non_nullable
              as List<int>,
      hostPlants: null == hostPlants
          ? _value.hostPlants
          : hostPlants // ignore: cast_nullable_to_non_nullable
              as List<HostPlant>,
      states: null == states
          ? _value.states
          : states // ignore: cast_nullable_to_non_nullable
              as List<String>,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpeciesImage>,
      primaryImageUrl: freezed == primaryImageUrl
          ? _value.primaryImageUrl
          : primaryImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      observationCount: null == observationCount
          ? _value.observationCount
          : observationCount // ignore: cast_nullable_to_non_nullable
              as int,
      isBookmarked: null == isBookmarked
          ? _value.isBookmarked
          : isBookmarked // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpeciesDetailImplCopyWith<$Res>
    implements $SpeciesDetailCopyWith<$Res> {
  factory _$$SpeciesDetailImplCopyWith(
          _$SpeciesDetailImpl value, $Res Function(_$SpeciesDetailImpl) then) =
      __$$SpeciesDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'common_name') String commonName,
      @JsonKey(name: 'scientific_name') String scientificName,
      String? family,
      String? subfamily,
      String? genus,
      String? description,
      String? habitat,
      @JsonKey(name: 'description_short') String? descriptionShort,
      String? rarity,
      @JsonKey(name: 'conservation_status') String? conservationStatus,
      @JsonKey(name: 'wingspan_mm') String? wingspanMm,
      @JsonKey(name: 'flight_months') List<int> flightMonths,
      @JsonKey(name: 'host_plants') List<HostPlant> hostPlants,
      List<String> states,
      List<SpeciesImage> images,
      @JsonKey(name: 'primary_image_url') String? primaryImageUrl,
      @JsonKey(name: 'observation_count') int observationCount,
      @JsonKey(name: 'is_bookmarked') bool isBookmarked});
}

/// @nodoc
class __$$SpeciesDetailImplCopyWithImpl<$Res>
    extends _$SpeciesDetailCopyWithImpl<$Res, _$SpeciesDetailImpl>
    implements _$$SpeciesDetailImplCopyWith<$Res> {
  __$$SpeciesDetailImplCopyWithImpl(
      _$SpeciesDetailImpl _value, $Res Function(_$SpeciesDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpeciesDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? commonName = null,
    Object? scientificName = null,
    Object? family = freezed,
    Object? subfamily = freezed,
    Object? genus = freezed,
    Object? description = freezed,
    Object? habitat = freezed,
    Object? descriptionShort = freezed,
    Object? rarity = freezed,
    Object? conservationStatus = freezed,
    Object? wingspanMm = freezed,
    Object? flightMonths = null,
    Object? hostPlants = null,
    Object? states = null,
    Object? images = null,
    Object? primaryImageUrl = freezed,
    Object? observationCount = null,
    Object? isBookmarked = null,
  }) {
    return _then(_$SpeciesDetailImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      commonName: null == commonName
          ? _value.commonName
          : commonName // ignore: cast_nullable_to_non_nullable
              as String,
      scientificName: null == scientificName
          ? _value.scientificName
          : scientificName // ignore: cast_nullable_to_non_nullable
              as String,
      family: freezed == family
          ? _value.family
          : family // ignore: cast_nullable_to_non_nullable
              as String?,
      subfamily: freezed == subfamily
          ? _value.subfamily
          : subfamily // ignore: cast_nullable_to_non_nullable
              as String?,
      genus: freezed == genus
          ? _value.genus
          : genus // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      habitat: freezed == habitat
          ? _value.habitat
          : habitat // ignore: cast_nullable_to_non_nullable
              as String?,
      descriptionShort: freezed == descriptionShort
          ? _value.descriptionShort
          : descriptionShort // ignore: cast_nullable_to_non_nullable
              as String?,
      rarity: freezed == rarity
          ? _value.rarity
          : rarity // ignore: cast_nullable_to_non_nullable
              as String?,
      conservationStatus: freezed == conservationStatus
          ? _value.conservationStatus
          : conservationStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      wingspanMm: freezed == wingspanMm
          ? _value.wingspanMm
          : wingspanMm // ignore: cast_nullable_to_non_nullable
              as String?,
      flightMonths: null == flightMonths
          ? _value._flightMonths
          : flightMonths // ignore: cast_nullable_to_non_nullable
              as List<int>,
      hostPlants: null == hostPlants
          ? _value._hostPlants
          : hostPlants // ignore: cast_nullable_to_non_nullable
              as List<HostPlant>,
      states: null == states
          ? _value._states
          : states // ignore: cast_nullable_to_non_nullable
              as List<String>,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpeciesImage>,
      primaryImageUrl: freezed == primaryImageUrl
          ? _value.primaryImageUrl
          : primaryImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      observationCount: null == observationCount
          ? _value.observationCount
          : observationCount // ignore: cast_nullable_to_non_nullable
              as int,
      isBookmarked: null == isBookmarked
          ? _value.isBookmarked
          : isBookmarked // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpeciesDetailImpl extends _SpeciesDetail {
  const _$SpeciesDetailImpl(
      {required this.id,
      @JsonKey(name: 'common_name') required this.commonName,
      @JsonKey(name: 'scientific_name') required this.scientificName,
      this.family,
      this.subfamily,
      this.genus,
      this.description,
      this.habitat,
      @JsonKey(name: 'description_short') this.descriptionShort,
      this.rarity,
      @JsonKey(name: 'conservation_status') this.conservationStatus,
      @JsonKey(name: 'wingspan_mm') this.wingspanMm,
      @JsonKey(name: 'flight_months') final List<int> flightMonths = const [],
      @JsonKey(name: 'host_plants') final List<HostPlant> hostPlants = const [],
      final List<String> states = const [],
      final List<SpeciesImage> images = const [],
      @JsonKey(name: 'primary_image_url') this.primaryImageUrl,
      @JsonKey(name: 'observation_count') this.observationCount = 0,
      @JsonKey(name: 'is_bookmarked') this.isBookmarked = false})
      : _flightMonths = flightMonths,
        _hostPlants = hostPlants,
        _states = states,
        _images = images,
        super._();

  factory _$SpeciesDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpeciesDetailImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'common_name')
  final String commonName;
  @override
  @JsonKey(name: 'scientific_name')
  final String scientificName;
  @override
  final String? family;
  @override
  final String? subfamily;
  @override
  final String? genus;
  @override
  final String? description;
  @override
  final String? habitat;
  @override
  @JsonKey(name: 'description_short')
  final String? descriptionShort;
  @override
  final String? rarity;
  @override
  @JsonKey(name: 'conservation_status')
  final String? conservationStatus;
  @override
  @JsonKey(name: 'wingspan_mm')
  final String? wingspanMm;
  final List<int> _flightMonths;
  @override
  @JsonKey(name: 'flight_months')
  List<int> get flightMonths {
    if (_flightMonths is EqualUnmodifiableListView) return _flightMonths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_flightMonths);
  }

  final List<HostPlant> _hostPlants;
  @override
  @JsonKey(name: 'host_plants')
  List<HostPlant> get hostPlants {
    if (_hostPlants is EqualUnmodifiableListView) return _hostPlants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hostPlants);
  }

  final List<String> _states;
  @override
  @JsonKey()
  List<String> get states {
    if (_states is EqualUnmodifiableListView) return _states;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_states);
  }

  final List<SpeciesImage> _images;
  @override
  @JsonKey()
  List<SpeciesImage> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  @JsonKey(name: 'primary_image_url')
  final String? primaryImageUrl;
  @override
  @JsonKey(name: 'observation_count')
  final int observationCount;
  @override
  @JsonKey(name: 'is_bookmarked')
  final bool isBookmarked;

  @override
  String toString() {
    return 'SpeciesDetail(id: $id, commonName: $commonName, scientificName: $scientificName, family: $family, subfamily: $subfamily, genus: $genus, description: $description, habitat: $habitat, descriptionShort: $descriptionShort, rarity: $rarity, conservationStatus: $conservationStatus, wingspanMm: $wingspanMm, flightMonths: $flightMonths, hostPlants: $hostPlants, states: $states, images: $images, primaryImageUrl: $primaryImageUrl, observationCount: $observationCount, isBookmarked: $isBookmarked)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpeciesDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.commonName, commonName) ||
                other.commonName == commonName) &&
            (identical(other.scientificName, scientificName) ||
                other.scientificName == scientificName) &&
            (identical(other.family, family) || other.family == family) &&
            (identical(other.subfamily, subfamily) ||
                other.subfamily == subfamily) &&
            (identical(other.genus, genus) || other.genus == genus) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.habitat, habitat) || other.habitat == habitat) &&
            (identical(other.descriptionShort, descriptionShort) ||
                other.descriptionShort == descriptionShort) &&
            (identical(other.rarity, rarity) || other.rarity == rarity) &&
            (identical(other.conservationStatus, conservationStatus) ||
                other.conservationStatus == conservationStatus) &&
            (identical(other.wingspanMm, wingspanMm) ||
                other.wingspanMm == wingspanMm) &&
            const DeepCollectionEquality()
                .equals(other._flightMonths, _flightMonths) &&
            const DeepCollectionEquality()
                .equals(other._hostPlants, _hostPlants) &&
            const DeepCollectionEquality().equals(other._states, _states) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.primaryImageUrl, primaryImageUrl) ||
                other.primaryImageUrl == primaryImageUrl) &&
            (identical(other.observationCount, observationCount) ||
                other.observationCount == observationCount) &&
            (identical(other.isBookmarked, isBookmarked) ||
                other.isBookmarked == isBookmarked));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        commonName,
        scientificName,
        family,
        subfamily,
        genus,
        description,
        habitat,
        descriptionShort,
        rarity,
        conservationStatus,
        wingspanMm,
        const DeepCollectionEquality().hash(_flightMonths),
        const DeepCollectionEquality().hash(_hostPlants),
        const DeepCollectionEquality().hash(_states),
        const DeepCollectionEquality().hash(_images),
        primaryImageUrl,
        observationCount,
        isBookmarked
      ]);

  /// Create a copy of SpeciesDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpeciesDetailImplCopyWith<_$SpeciesDetailImpl> get copyWith =>
      __$$SpeciesDetailImplCopyWithImpl<_$SpeciesDetailImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            @JsonKey(name: 'common_name') String commonName,
            @JsonKey(name: 'scientific_name') String scientificName,
            String? family,
            String? subfamily,
            String? genus,
            String? description,
            String? habitat,
            @JsonKey(name: 'description_short') String? descriptionShort,
            String? rarity,
            @JsonKey(name: 'conservation_status') String? conservationStatus,
            @JsonKey(name: 'wingspan_mm') String? wingspanMm,
            @JsonKey(name: 'flight_months') List<int> flightMonths,
            @JsonKey(name: 'host_plants') List<HostPlant> hostPlants,
            List<String> states,
            List<SpeciesImage> images,
            @JsonKey(name: 'primary_image_url') String? primaryImageUrl,
            @JsonKey(name: 'observation_count') int observationCount,
            @JsonKey(name: 'is_bookmarked') bool isBookmarked)
        $default,
  ) {
    return $default(
        id,
        commonName,
        scientificName,
        family,
        subfamily,
        genus,
        description,
        habitat,
        descriptionShort,
        rarity,
        conservationStatus,
        wingspanMm,
        flightMonths,
        hostPlants,
        states,
        images,
        primaryImageUrl,
        observationCount,
        isBookmarked);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            @JsonKey(name: 'common_name') String commonName,
            @JsonKey(name: 'scientific_name') String scientificName,
            String? family,
            String? subfamily,
            String? genus,
            String? description,
            String? habitat,
            @JsonKey(name: 'description_short') String? descriptionShort,
            String? rarity,
            @JsonKey(name: 'conservation_status') String? conservationStatus,
            @JsonKey(name: 'wingspan_mm') String? wingspanMm,
            @JsonKey(name: 'flight_months') List<int> flightMonths,
            @JsonKey(name: 'host_plants') List<HostPlant> hostPlants,
            List<String> states,
            List<SpeciesImage> images,
            @JsonKey(name: 'primary_image_url') String? primaryImageUrl,
            @JsonKey(name: 'observation_count') int observationCount,
            @JsonKey(name: 'is_bookmarked') bool isBookmarked)?
        $default,
  ) {
    return $default?.call(
        id,
        commonName,
        scientificName,
        family,
        subfamily,
        genus,
        description,
        habitat,
        descriptionShort,
        rarity,
        conservationStatus,
        wingspanMm,
        flightMonths,
        hostPlants,
        states,
        images,
        primaryImageUrl,
        observationCount,
        isBookmarked);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            @JsonKey(name: 'common_name') String commonName,
            @JsonKey(name: 'scientific_name') String scientificName,
            String? family,
            String? subfamily,
            String? genus,
            String? description,
            String? habitat,
            @JsonKey(name: 'description_short') String? descriptionShort,
            String? rarity,
            @JsonKey(name: 'conservation_status') String? conservationStatus,
            @JsonKey(name: 'wingspan_mm') String? wingspanMm,
            @JsonKey(name: 'flight_months') List<int> flightMonths,
            @JsonKey(name: 'host_plants') List<HostPlant> hostPlants,
            List<String> states,
            List<SpeciesImage> images,
            @JsonKey(name: 'primary_image_url') String? primaryImageUrl,
            @JsonKey(name: 'observation_count') int observationCount,
            @JsonKey(name: 'is_bookmarked') bool isBookmarked)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(
          id,
          commonName,
          scientificName,
          family,
          subfamily,
          genus,
          description,
          habitat,
          descriptionShort,
          rarity,
          conservationStatus,
          wingspanMm,
          flightMonths,
          hostPlants,
          states,
          images,
          primaryImageUrl,
          observationCount,
          isBookmarked);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_SpeciesDetail value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_SpeciesDetail value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_SpeciesDetail value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SpeciesDetailImplToJson(
      this,
    );
  }
}

abstract class _SpeciesDetail extends SpeciesDetail {
  const factory _SpeciesDetail(
      {required final String id,
      @JsonKey(name: 'common_name') required final String commonName,
      @JsonKey(name: 'scientific_name') required final String scientificName,
      final String? family,
      final String? subfamily,
      final String? genus,
      final String? description,
      final String? habitat,
      @JsonKey(name: 'description_short') final String? descriptionShort,
      final String? rarity,
      @JsonKey(name: 'conservation_status') final String? conservationStatus,
      @JsonKey(name: 'wingspan_mm') final String? wingspanMm,
      @JsonKey(name: 'flight_months') final List<int> flightMonths,
      @JsonKey(name: 'host_plants') final List<HostPlant> hostPlants,
      final List<String> states,
      final List<SpeciesImage> images,
      @JsonKey(name: 'primary_image_url') final String? primaryImageUrl,
      @JsonKey(name: 'observation_count') final int observationCount,
      @JsonKey(name: 'is_bookmarked')
      final bool isBookmarked}) = _$SpeciesDetailImpl;
  const _SpeciesDetail._() : super._();

  factory _SpeciesDetail.fromJson(Map<String, dynamic> json) =
      _$SpeciesDetailImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'common_name')
  String get commonName;
  @override
  @JsonKey(name: 'scientific_name')
  String get scientificName;
  @override
  String? get family;
  @override
  String? get subfamily;
  @override
  String? get genus;
  @override
  String? get description;
  @override
  String? get habitat;
  @override
  @JsonKey(name: 'description_short')
  String? get descriptionShort;
  @override
  String? get rarity;
  @override
  @JsonKey(name: 'conservation_status')
  String? get conservationStatus;
  @override
  @JsonKey(name: 'wingspan_mm')
  String? get wingspanMm;
  @override
  @JsonKey(name: 'flight_months')
  List<int> get flightMonths;
  @override
  @JsonKey(name: 'host_plants')
  List<HostPlant> get hostPlants;
  @override
  List<String> get states;
  @override
  List<SpeciesImage> get images;
  @override
  @JsonKey(name: 'primary_image_url')
  String? get primaryImageUrl;
  @override
  @JsonKey(name: 'observation_count')
  int get observationCount;
  @override
  @JsonKey(name: 'is_bookmarked')
  bool get isBookmarked;

  /// Create a copy of SpeciesDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpeciesDetailImplCopyWith<_$SpeciesDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SpeciesImage _$SpeciesImageFromJson(Map<String, dynamic> json) {
  return _SpeciesImage.fromJson(json);
}

/// @nodoc
mixin _$SpeciesImage {
  @JsonKey(name: 'image_url')
  String get url => throw _privateConstructorUsedError;
  String? get caption => throw _privateConstructorUsedError;
  String? get credit => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_primary')
  bool get isPrimary => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(@JsonKey(name: 'image_url') String url, String? caption,
            String? credit, @JsonKey(name: 'is_primary') bool isPrimary)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(@JsonKey(name: 'image_url') String url, String? caption,
            String? credit, @JsonKey(name: 'is_primary') bool isPrimary)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(@JsonKey(name: 'image_url') String url, String? caption,
            String? credit, @JsonKey(name: 'is_primary') bool isPrimary)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_SpeciesImage value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_SpeciesImage value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_SpeciesImage value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this SpeciesImage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpeciesImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpeciesImageCopyWith<SpeciesImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpeciesImageCopyWith<$Res> {
  factory $SpeciesImageCopyWith(
          SpeciesImage value, $Res Function(SpeciesImage) then) =
      _$SpeciesImageCopyWithImpl<$Res, SpeciesImage>;
  @useResult
  $Res call(
      {@JsonKey(name: 'image_url') String url,
      String? caption,
      String? credit,
      @JsonKey(name: 'is_primary') bool isPrimary});
}

/// @nodoc
class _$SpeciesImageCopyWithImpl<$Res, $Val extends SpeciesImage>
    implements $SpeciesImageCopyWith<$Res> {
  _$SpeciesImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpeciesImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? caption = freezed,
    Object? credit = freezed,
    Object? isPrimary = null,
  }) {
    return _then(_value.copyWith(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      caption: freezed == caption
          ? _value.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String?,
      credit: freezed == credit
          ? _value.credit
          : credit // ignore: cast_nullable_to_non_nullable
              as String?,
      isPrimary: null == isPrimary
          ? _value.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpeciesImageImplCopyWith<$Res>
    implements $SpeciesImageCopyWith<$Res> {
  factory _$$SpeciesImageImplCopyWith(
          _$SpeciesImageImpl value, $Res Function(_$SpeciesImageImpl) then) =
      __$$SpeciesImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'image_url') String url,
      String? caption,
      String? credit,
      @JsonKey(name: 'is_primary') bool isPrimary});
}

/// @nodoc
class __$$SpeciesImageImplCopyWithImpl<$Res>
    extends _$SpeciesImageCopyWithImpl<$Res, _$SpeciesImageImpl>
    implements _$$SpeciesImageImplCopyWith<$Res> {
  __$$SpeciesImageImplCopyWithImpl(
      _$SpeciesImageImpl _value, $Res Function(_$SpeciesImageImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpeciesImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? caption = freezed,
    Object? credit = freezed,
    Object? isPrimary = null,
  }) {
    return _then(_$SpeciesImageImpl(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      caption: freezed == caption
          ? _value.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String?,
      credit: freezed == credit
          ? _value.credit
          : credit // ignore: cast_nullable_to_non_nullable
              as String?,
      isPrimary: null == isPrimary
          ? _value.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpeciesImageImpl implements _SpeciesImage {
  const _$SpeciesImageImpl(
      {@JsonKey(name: 'image_url') required this.url,
      this.caption,
      this.credit,
      @JsonKey(name: 'is_primary') this.isPrimary = false});

  factory _$SpeciesImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpeciesImageImplFromJson(json);

  @override
  @JsonKey(name: 'image_url')
  final String url;
  @override
  final String? caption;
  @override
  final String? credit;
  @override
  @JsonKey(name: 'is_primary')
  final bool isPrimary;

  @override
  String toString() {
    return 'SpeciesImage(url: $url, caption: $caption, credit: $credit, isPrimary: $isPrimary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpeciesImageImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            (identical(other.credit, credit) || other.credit == credit) &&
            (identical(other.isPrimary, isPrimary) ||
                other.isPrimary == isPrimary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url, caption, credit, isPrimary);

  /// Create a copy of SpeciesImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpeciesImageImplCopyWith<_$SpeciesImageImpl> get copyWith =>
      __$$SpeciesImageImplCopyWithImpl<_$SpeciesImageImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(@JsonKey(name: 'image_url') String url, String? caption,
            String? credit, @JsonKey(name: 'is_primary') bool isPrimary)
        $default,
  ) {
    return $default(url, caption, credit, isPrimary);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(@JsonKey(name: 'image_url') String url, String? caption,
            String? credit, @JsonKey(name: 'is_primary') bool isPrimary)?
        $default,
  ) {
    return $default?.call(url, caption, credit, isPrimary);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(@JsonKey(name: 'image_url') String url, String? caption,
            String? credit, @JsonKey(name: 'is_primary') bool isPrimary)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(url, caption, credit, isPrimary);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_SpeciesImage value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_SpeciesImage value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_SpeciesImage value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SpeciesImageImplToJson(
      this,
    );
  }
}

abstract class _SpeciesImage implements SpeciesImage {
  const factory _SpeciesImage(
      {@JsonKey(name: 'image_url') required final String url,
      final String? caption,
      final String? credit,
      @JsonKey(name: 'is_primary') final bool isPrimary}) = _$SpeciesImageImpl;

  factory _SpeciesImage.fromJson(Map<String, dynamic> json) =
      _$SpeciesImageImpl.fromJson;

  @override
  @JsonKey(name: 'image_url')
  String get url;
  @override
  String? get caption;
  @override
  String? get credit;
  @override
  @JsonKey(name: 'is_primary')
  bool get isPrimary;

  /// Create a copy of SpeciesImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpeciesImageImplCopyWith<_$SpeciesImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HostPlant _$HostPlantFromJson(Map<String, dynamic> json) {
  return _HostPlant.fromJson(json);
}

/// @nodoc
mixin _$HostPlant {
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'scientific_name')
  String? get scientificName => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String name,
            @JsonKey(name: 'scientific_name') String? scientificName)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String name,
            @JsonKey(name: 'scientific_name') String? scientificName)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String name,
            @JsonKey(name: 'scientific_name') String? scientificName)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_HostPlant value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_HostPlant value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_HostPlant value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this HostPlant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HostPlant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HostPlantCopyWith<HostPlant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HostPlantCopyWith<$Res> {
  factory $HostPlantCopyWith(HostPlant value, $Res Function(HostPlant) then) =
      _$HostPlantCopyWithImpl<$Res, HostPlant>;
  @useResult
  $Res call(
      {String name, @JsonKey(name: 'scientific_name') String? scientificName});
}

/// @nodoc
class _$HostPlantCopyWithImpl<$Res, $Val extends HostPlant>
    implements $HostPlantCopyWith<$Res> {
  _$HostPlantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HostPlant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? scientificName = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      scientificName: freezed == scientificName
          ? _value.scientificName
          : scientificName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HostPlantImplCopyWith<$Res>
    implements $HostPlantCopyWith<$Res> {
  factory _$$HostPlantImplCopyWith(
          _$HostPlantImpl value, $Res Function(_$HostPlantImpl) then) =
      __$$HostPlantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name, @JsonKey(name: 'scientific_name') String? scientificName});
}

/// @nodoc
class __$$HostPlantImplCopyWithImpl<$Res>
    extends _$HostPlantCopyWithImpl<$Res, _$HostPlantImpl>
    implements _$$HostPlantImplCopyWith<$Res> {
  __$$HostPlantImplCopyWithImpl(
      _$HostPlantImpl _value, $Res Function(_$HostPlantImpl) _then)
      : super(_value, _then);

  /// Create a copy of HostPlant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? scientificName = freezed,
  }) {
    return _then(_$HostPlantImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      scientificName: freezed == scientificName
          ? _value.scientificName
          : scientificName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HostPlantImpl implements _HostPlant {
  const _$HostPlantImpl(
      {required this.name,
      @JsonKey(name: 'scientific_name') this.scientificName});

  factory _$HostPlantImpl.fromJson(Map<String, dynamic> json) =>
      _$$HostPlantImplFromJson(json);

  @override
  final String name;
  @override
  @JsonKey(name: 'scientific_name')
  final String? scientificName;

  @override
  String toString() {
    return 'HostPlant(name: $name, scientificName: $scientificName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HostPlantImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.scientificName, scientificName) ||
                other.scientificName == scientificName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, scientificName);

  /// Create a copy of HostPlant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HostPlantImplCopyWith<_$HostPlantImpl> get copyWith =>
      __$$HostPlantImplCopyWithImpl<_$HostPlantImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String name,
            @JsonKey(name: 'scientific_name') String? scientificName)
        $default,
  ) {
    return $default(name, scientificName);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String name,
            @JsonKey(name: 'scientific_name') String? scientificName)?
        $default,
  ) {
    return $default?.call(name, scientificName);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String name,
            @JsonKey(name: 'scientific_name') String? scientificName)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(name, scientificName);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_HostPlant value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_HostPlant value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_HostPlant value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$HostPlantImplToJson(
      this,
    );
  }
}

abstract class _HostPlant implements HostPlant {
  const factory _HostPlant(
          {required final String name,
          @JsonKey(name: 'scientific_name') final String? scientificName}) =
      _$HostPlantImpl;

  factory _HostPlant.fromJson(Map<String, dynamic> json) =
      _$HostPlantImpl.fromJson;

  @override
  String get name;
  @override
  @JsonKey(name: 'scientific_name')
  String? get scientificName;

  /// Create a copy of HostPlant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HostPlantImplCopyWith<_$HostPlantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
