// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'species_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SpeciesSummary _$SpeciesSummaryFromJson(Map<String, dynamic> json) {
  return _SpeciesSummary.fromJson(json);
}

/// @nodoc
mixin _$SpeciesSummary {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'common_name')
  String get commonName => throw _privateConstructorUsedError;
  @JsonKey(name: 'scientific_name')
  String get scientificName => throw _privateConstructorUsedError;
  String? get family => throw _privateConstructorUsedError;
  String? get rarity => throw _privateConstructorUsedError;
  @JsonKey(name: 'conservation_status')
  String? get conservationStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'primary_image_url')
  String? get primaryImageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'observation_count')
  int get observationCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'description_short')
  String? get descriptionShort => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            @JsonKey(name: 'common_name') String commonName,
            @JsonKey(name: 'scientific_name') String scientificName,
            String? family,
            String? rarity,
            @JsonKey(name: 'conservation_status') String? conservationStatus,
            @JsonKey(name: 'primary_image_url') String? primaryImageUrl,
            @JsonKey(name: 'observation_count') int observationCount,
            @JsonKey(name: 'description_short') String? descriptionShort)
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
            String? rarity,
            @JsonKey(name: 'conservation_status') String? conservationStatus,
            @JsonKey(name: 'primary_image_url') String? primaryImageUrl,
            @JsonKey(name: 'observation_count') int observationCount,
            @JsonKey(name: 'description_short') String? descriptionShort)?
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
            String? rarity,
            @JsonKey(name: 'conservation_status') String? conservationStatus,
            @JsonKey(name: 'primary_image_url') String? primaryImageUrl,
            @JsonKey(name: 'observation_count') int observationCount,
            @JsonKey(name: 'description_short') String? descriptionShort)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_SpeciesSummary value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_SpeciesSummary value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_SpeciesSummary value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this SpeciesSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpeciesSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpeciesSummaryCopyWith<SpeciesSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpeciesSummaryCopyWith<$Res> {
  factory $SpeciesSummaryCopyWith(
          SpeciesSummary value, $Res Function(SpeciesSummary) then) =
      _$SpeciesSummaryCopyWithImpl<$Res, SpeciesSummary>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'common_name') String commonName,
      @JsonKey(name: 'scientific_name') String scientificName,
      String? family,
      String? rarity,
      @JsonKey(name: 'conservation_status') String? conservationStatus,
      @JsonKey(name: 'primary_image_url') String? primaryImageUrl,
      @JsonKey(name: 'observation_count') int observationCount,
      @JsonKey(name: 'description_short') String? descriptionShort});
}

/// @nodoc
class _$SpeciesSummaryCopyWithImpl<$Res, $Val extends SpeciesSummary>
    implements $SpeciesSummaryCopyWith<$Res> {
  _$SpeciesSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpeciesSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? commonName = null,
    Object? scientificName = null,
    Object? family = freezed,
    Object? rarity = freezed,
    Object? conservationStatus = freezed,
    Object? primaryImageUrl = freezed,
    Object? observationCount = null,
    Object? descriptionShort = freezed,
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
      rarity: freezed == rarity
          ? _value.rarity
          : rarity // ignore: cast_nullable_to_non_nullable
              as String?,
      conservationStatus: freezed == conservationStatus
          ? _value.conservationStatus
          : conservationStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryImageUrl: freezed == primaryImageUrl
          ? _value.primaryImageUrl
          : primaryImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      observationCount: null == observationCount
          ? _value.observationCount
          : observationCount // ignore: cast_nullable_to_non_nullable
              as int,
      descriptionShort: freezed == descriptionShort
          ? _value.descriptionShort
          : descriptionShort // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpeciesSummaryImplCopyWith<$Res>
    implements $SpeciesSummaryCopyWith<$Res> {
  factory _$$SpeciesSummaryImplCopyWith(_$SpeciesSummaryImpl value,
          $Res Function(_$SpeciesSummaryImpl) then) =
      __$$SpeciesSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'common_name') String commonName,
      @JsonKey(name: 'scientific_name') String scientificName,
      String? family,
      String? rarity,
      @JsonKey(name: 'conservation_status') String? conservationStatus,
      @JsonKey(name: 'primary_image_url') String? primaryImageUrl,
      @JsonKey(name: 'observation_count') int observationCount,
      @JsonKey(name: 'description_short') String? descriptionShort});
}

/// @nodoc
class __$$SpeciesSummaryImplCopyWithImpl<$Res>
    extends _$SpeciesSummaryCopyWithImpl<$Res, _$SpeciesSummaryImpl>
    implements _$$SpeciesSummaryImplCopyWith<$Res> {
  __$$SpeciesSummaryImplCopyWithImpl(
      _$SpeciesSummaryImpl _value, $Res Function(_$SpeciesSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpeciesSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? commonName = null,
    Object? scientificName = null,
    Object? family = freezed,
    Object? rarity = freezed,
    Object? conservationStatus = freezed,
    Object? primaryImageUrl = freezed,
    Object? observationCount = null,
    Object? descriptionShort = freezed,
  }) {
    return _then(_$SpeciesSummaryImpl(
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
      rarity: freezed == rarity
          ? _value.rarity
          : rarity // ignore: cast_nullable_to_non_nullable
              as String?,
      conservationStatus: freezed == conservationStatus
          ? _value.conservationStatus
          : conservationStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryImageUrl: freezed == primaryImageUrl
          ? _value.primaryImageUrl
          : primaryImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      observationCount: null == observationCount
          ? _value.observationCount
          : observationCount // ignore: cast_nullable_to_non_nullable
              as int,
      descriptionShort: freezed == descriptionShort
          ? _value.descriptionShort
          : descriptionShort // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpeciesSummaryImpl implements _SpeciesSummary {
  const _$SpeciesSummaryImpl(
      {required this.id,
      @JsonKey(name: 'common_name') required this.commonName,
      @JsonKey(name: 'scientific_name') required this.scientificName,
      this.family,
      this.rarity,
      @JsonKey(name: 'conservation_status') this.conservationStatus,
      @JsonKey(name: 'primary_image_url') this.primaryImageUrl,
      @JsonKey(name: 'observation_count') this.observationCount = 0,
      @JsonKey(name: 'description_short') this.descriptionShort});

  factory _$SpeciesSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpeciesSummaryImplFromJson(json);

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
  final String? rarity;
  @override
  @JsonKey(name: 'conservation_status')
  final String? conservationStatus;
  @override
  @JsonKey(name: 'primary_image_url')
  final String? primaryImageUrl;
  @override
  @JsonKey(name: 'observation_count')
  final int observationCount;
  @override
  @JsonKey(name: 'description_short')
  final String? descriptionShort;

  @override
  String toString() {
    return 'SpeciesSummary(id: $id, commonName: $commonName, scientificName: $scientificName, family: $family, rarity: $rarity, conservationStatus: $conservationStatus, primaryImageUrl: $primaryImageUrl, observationCount: $observationCount, descriptionShort: $descriptionShort)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpeciesSummaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.commonName, commonName) ||
                other.commonName == commonName) &&
            (identical(other.scientificName, scientificName) ||
                other.scientificName == scientificName) &&
            (identical(other.family, family) || other.family == family) &&
            (identical(other.rarity, rarity) || other.rarity == rarity) &&
            (identical(other.conservationStatus, conservationStatus) ||
                other.conservationStatus == conservationStatus) &&
            (identical(other.primaryImageUrl, primaryImageUrl) ||
                other.primaryImageUrl == primaryImageUrl) &&
            (identical(other.observationCount, observationCount) ||
                other.observationCount == observationCount) &&
            (identical(other.descriptionShort, descriptionShort) ||
                other.descriptionShort == descriptionShort));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      commonName,
      scientificName,
      family,
      rarity,
      conservationStatus,
      primaryImageUrl,
      observationCount,
      descriptionShort);

  /// Create a copy of SpeciesSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpeciesSummaryImplCopyWith<_$SpeciesSummaryImpl> get copyWith =>
      __$$SpeciesSummaryImplCopyWithImpl<_$SpeciesSummaryImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            @JsonKey(name: 'common_name') String commonName,
            @JsonKey(name: 'scientific_name') String scientificName,
            String? family,
            String? rarity,
            @JsonKey(name: 'conservation_status') String? conservationStatus,
            @JsonKey(name: 'primary_image_url') String? primaryImageUrl,
            @JsonKey(name: 'observation_count') int observationCount,
            @JsonKey(name: 'description_short') String? descriptionShort)
        $default,
  ) {
    return $default(
        id,
        commonName,
        scientificName,
        family,
        rarity,
        conservationStatus,
        primaryImageUrl,
        observationCount,
        descriptionShort);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            @JsonKey(name: 'common_name') String commonName,
            @JsonKey(name: 'scientific_name') String scientificName,
            String? family,
            String? rarity,
            @JsonKey(name: 'conservation_status') String? conservationStatus,
            @JsonKey(name: 'primary_image_url') String? primaryImageUrl,
            @JsonKey(name: 'observation_count') int observationCount,
            @JsonKey(name: 'description_short') String? descriptionShort)?
        $default,
  ) {
    return $default?.call(
        id,
        commonName,
        scientificName,
        family,
        rarity,
        conservationStatus,
        primaryImageUrl,
        observationCount,
        descriptionShort);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            @JsonKey(name: 'common_name') String commonName,
            @JsonKey(name: 'scientific_name') String scientificName,
            String? family,
            String? rarity,
            @JsonKey(name: 'conservation_status') String? conservationStatus,
            @JsonKey(name: 'primary_image_url') String? primaryImageUrl,
            @JsonKey(name: 'observation_count') int observationCount,
            @JsonKey(name: 'description_short') String? descriptionShort)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(
          id,
          commonName,
          scientificName,
          family,
          rarity,
          conservationStatus,
          primaryImageUrl,
          observationCount,
          descriptionShort);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_SpeciesSummary value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_SpeciesSummary value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_SpeciesSummary value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SpeciesSummaryImplToJson(
      this,
    );
  }
}

abstract class _SpeciesSummary implements SpeciesSummary {
  const factory _SpeciesSummary(
      {required final String id,
      @JsonKey(name: 'common_name') required final String commonName,
      @JsonKey(name: 'scientific_name') required final String scientificName,
      final String? family,
      final String? rarity,
      @JsonKey(name: 'conservation_status') final String? conservationStatus,
      @JsonKey(name: 'primary_image_url') final String? primaryImageUrl,
      @JsonKey(name: 'observation_count') final int observationCount,
      @JsonKey(name: 'description_short')
      final String? descriptionShort}) = _$SpeciesSummaryImpl;

  factory _SpeciesSummary.fromJson(Map<String, dynamic> json) =
      _$SpeciesSummaryImpl.fromJson;

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
  String? get rarity;
  @override
  @JsonKey(name: 'conservation_status')
  String? get conservationStatus;
  @override
  @JsonKey(name: 'primary_image_url')
  String? get primaryImageUrl;
  @override
  @JsonKey(name: 'observation_count')
  int get observationCount;
  @override
  @JsonKey(name: 'description_short')
  String? get descriptionShort;

  /// Create a copy of SpeciesSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpeciesSummaryImplCopyWith<_$SpeciesSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
