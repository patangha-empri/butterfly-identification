// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geography_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

IndiaState _$IndiaStateFromJson(Map<String, dynamic> json) {
  return _IndiaState.fromJson(json);
}

/// @nodoc
mixin _$IndiaState {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get code => throw _privateConstructorUsedError;
  String? get region => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_union_territory')
  bool get isUnionTerritory => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(int id, String name, String? code, String? region,
            @JsonKey(name: 'is_union_territory') bool isUnionTerritory)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(int id, String name, String? code, String? region,
            @JsonKey(name: 'is_union_territory') bool isUnionTerritory)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int id, String name, String? code, String? region,
            @JsonKey(name: 'is_union_territory') bool isUnionTerritory)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_IndiaState value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_IndiaState value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_IndiaState value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this IndiaState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IndiaState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IndiaStateCopyWith<IndiaState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IndiaStateCopyWith<$Res> {
  factory $IndiaStateCopyWith(
          IndiaState value, $Res Function(IndiaState) then) =
      _$IndiaStateCopyWithImpl<$Res, IndiaState>;
  @useResult
  $Res call(
      {int id,
      String name,
      String? code,
      String? region,
      @JsonKey(name: 'is_union_territory') bool isUnionTerritory});
}

/// @nodoc
class _$IndiaStateCopyWithImpl<$Res, $Val extends IndiaState>
    implements $IndiaStateCopyWith<$Res> {
  _$IndiaStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IndiaState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = freezed,
    Object? region = freezed,
    Object? isUnionTerritory = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
      isUnionTerritory: null == isUnionTerritory
          ? _value.isUnionTerritory
          : isUnionTerritory // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IndiaStateImplCopyWith<$Res>
    implements $IndiaStateCopyWith<$Res> {
  factory _$$IndiaStateImplCopyWith(
          _$IndiaStateImpl value, $Res Function(_$IndiaStateImpl) then) =
      __$$IndiaStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String? code,
      String? region,
      @JsonKey(name: 'is_union_territory') bool isUnionTerritory});
}

/// @nodoc
class __$$IndiaStateImplCopyWithImpl<$Res>
    extends _$IndiaStateCopyWithImpl<$Res, _$IndiaStateImpl>
    implements _$$IndiaStateImplCopyWith<$Res> {
  __$$IndiaStateImplCopyWithImpl(
      _$IndiaStateImpl _value, $Res Function(_$IndiaStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of IndiaState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = freezed,
    Object? region = freezed,
    Object? isUnionTerritory = null,
  }) {
    return _then(_$IndiaStateImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
      isUnionTerritory: null == isUnionTerritory
          ? _value.isUnionTerritory
          : isUnionTerritory // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IndiaStateImpl implements _IndiaState {
  const _$IndiaStateImpl(
      {required this.id,
      required this.name,
      this.code,
      this.region,
      @JsonKey(name: 'is_union_territory') this.isUnionTerritory = false});

  factory _$IndiaStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$IndiaStateImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? code;
  @override
  final String? region;
  @override
  @JsonKey(name: 'is_union_territory')
  final bool isUnionTerritory;

  @override
  String toString() {
    return 'IndiaState(id: $id, name: $name, code: $code, region: $region, isUnionTerritory: $isUnionTerritory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IndiaStateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.isUnionTerritory, isUnionTerritory) ||
                other.isUnionTerritory == isUnionTerritory));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, code, region, isUnionTerritory);

  /// Create a copy of IndiaState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IndiaStateImplCopyWith<_$IndiaStateImpl> get copyWith =>
      __$$IndiaStateImplCopyWithImpl<_$IndiaStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(int id, String name, String? code, String? region,
            @JsonKey(name: 'is_union_territory') bool isUnionTerritory)
        $default,
  ) {
    return $default(id, name, code, region, isUnionTerritory);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(int id, String name, String? code, String? region,
            @JsonKey(name: 'is_union_territory') bool isUnionTerritory)?
        $default,
  ) {
    return $default?.call(id, name, code, region, isUnionTerritory);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int id, String name, String? code, String? region,
            @JsonKey(name: 'is_union_territory') bool isUnionTerritory)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(id, name, code, region, isUnionTerritory);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_IndiaState value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_IndiaState value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_IndiaState value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$IndiaStateImplToJson(
      this,
    );
  }
}

abstract class _IndiaState implements IndiaState {
  const factory _IndiaState(
          {required final int id,
          required final String name,
          final String? code,
          final String? region,
          @JsonKey(name: 'is_union_territory') final bool isUnionTerritory}) =
      _$IndiaStateImpl;

  factory _IndiaState.fromJson(Map<String, dynamic> json) =
      _$IndiaStateImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get code;
  @override
  String? get region;
  @override
  @JsonKey(name: 'is_union_territory')
  bool get isUnionTerritory;

  /// Create a copy of IndiaState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IndiaStateImplCopyWith<_$IndiaStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IndiaDistrict _$IndiaDistrictFromJson(Map<String, dynamic> json) {
  return _IndiaDistrict.fromJson(json);
}

/// @nodoc
mixin _$IndiaDistrict {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'state_id')
  int? get stateId => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            int id,
            String name,
            @JsonKey(name: 'state_id') int? stateId,
            double? latitude,
            double? longitude)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            int id,
            String name,
            @JsonKey(name: 'state_id') int? stateId,
            double? latitude,
            double? longitude)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            int id,
            String name,
            @JsonKey(name: 'state_id') int? stateId,
            double? latitude,
            double? longitude)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_IndiaDistrict value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_IndiaDistrict value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_IndiaDistrict value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this IndiaDistrict to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IndiaDistrict
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IndiaDistrictCopyWith<IndiaDistrict> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IndiaDistrictCopyWith<$Res> {
  factory $IndiaDistrictCopyWith(
          IndiaDistrict value, $Res Function(IndiaDistrict) then) =
      _$IndiaDistrictCopyWithImpl<$Res, IndiaDistrict>;
  @useResult
  $Res call(
      {int id,
      String name,
      @JsonKey(name: 'state_id') int? stateId,
      double? latitude,
      double? longitude});
}

/// @nodoc
class _$IndiaDistrictCopyWithImpl<$Res, $Val extends IndiaDistrict>
    implements $IndiaDistrictCopyWith<$Res> {
  _$IndiaDistrictCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IndiaDistrict
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? stateId = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      stateId: freezed == stateId
          ? _value.stateId
          : stateId // ignore: cast_nullable_to_non_nullable
              as int?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IndiaDistrictImplCopyWith<$Res>
    implements $IndiaDistrictCopyWith<$Res> {
  factory _$$IndiaDistrictImplCopyWith(
          _$IndiaDistrictImpl value, $Res Function(_$IndiaDistrictImpl) then) =
      __$$IndiaDistrictImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      @JsonKey(name: 'state_id') int? stateId,
      double? latitude,
      double? longitude});
}

/// @nodoc
class __$$IndiaDistrictImplCopyWithImpl<$Res>
    extends _$IndiaDistrictCopyWithImpl<$Res, _$IndiaDistrictImpl>
    implements _$$IndiaDistrictImplCopyWith<$Res> {
  __$$IndiaDistrictImplCopyWithImpl(
      _$IndiaDistrictImpl _value, $Res Function(_$IndiaDistrictImpl) _then)
      : super(_value, _then);

  /// Create a copy of IndiaDistrict
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? stateId = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
  }) {
    return _then(_$IndiaDistrictImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      stateId: freezed == stateId
          ? _value.stateId
          : stateId // ignore: cast_nullable_to_non_nullable
              as int?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IndiaDistrictImpl implements _IndiaDistrict {
  const _$IndiaDistrictImpl(
      {required this.id,
      required this.name,
      @JsonKey(name: 'state_id') this.stateId,
      this.latitude,
      this.longitude});

  factory _$IndiaDistrictImpl.fromJson(Map<String, dynamic> json) =>
      _$$IndiaDistrictImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  @JsonKey(name: 'state_id')
  final int? stateId;
  @override
  final double? latitude;
  @override
  final double? longitude;

  @override
  String toString() {
    return 'IndiaDistrict(id: $id, name: $name, stateId: $stateId, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IndiaDistrictImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.stateId, stateId) || other.stateId == stateId) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, stateId, latitude, longitude);

  /// Create a copy of IndiaDistrict
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IndiaDistrictImplCopyWith<_$IndiaDistrictImpl> get copyWith =>
      __$$IndiaDistrictImplCopyWithImpl<_$IndiaDistrictImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            int id,
            String name,
            @JsonKey(name: 'state_id') int? stateId,
            double? latitude,
            double? longitude)
        $default,
  ) {
    return $default(id, name, stateId, latitude, longitude);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            int id,
            String name,
            @JsonKey(name: 'state_id') int? stateId,
            double? latitude,
            double? longitude)?
        $default,
  ) {
    return $default?.call(id, name, stateId, latitude, longitude);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            int id,
            String name,
            @JsonKey(name: 'state_id') int? stateId,
            double? latitude,
            double? longitude)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(id, name, stateId, latitude, longitude);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_IndiaDistrict value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_IndiaDistrict value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_IndiaDistrict value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$IndiaDistrictImplToJson(
      this,
    );
  }
}

abstract class _IndiaDistrict implements IndiaDistrict {
  const factory _IndiaDistrict(
      {required final int id,
      required final String name,
      @JsonKey(name: 'state_id') final int? stateId,
      final double? latitude,
      final double? longitude}) = _$IndiaDistrictImpl;

  factory _IndiaDistrict.fromJson(Map<String, dynamic> json) =
      _$IndiaDistrictImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'state_id')
  int? get stateId;
  @override
  double? get latitude;
  @override
  double? get longitude;

  /// Create a copy of IndiaDistrict
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IndiaDistrictImplCopyWith<_$IndiaDistrictImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
