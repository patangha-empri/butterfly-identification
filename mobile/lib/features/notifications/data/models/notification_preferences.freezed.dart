// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_preferences.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationPreferences _$NotificationPreferencesFromJson(
    Map<String, dynamic> json) {
  return _NotificationPreferences.fromJson(json);
}

/// @nodoc
mixin _$NotificationPreferences {
  @JsonKey(name: 'identification_complete')
  bool get identificationComplete => throw _privateConstructorUsedError;
  @JsonKey(name: 'new_species_nearby')
  bool get newSpeciesNearby => throw _privateConstructorUsedError;
  @JsonKey(name: 'admin_verification')
  bool get adminVerification => throw _privateConstructorUsedError;
  @JsonKey(name: 'educational_alerts')
  bool get educationalAlerts => throw _privateConstructorUsedError;
  bool get events => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'identification_complete')
            bool identificationComplete,
            @JsonKey(name: 'new_species_nearby') bool newSpeciesNearby,
            @JsonKey(name: 'admin_verification') bool adminVerification,
            @JsonKey(name: 'educational_alerts') bool educationalAlerts,
            bool events)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            @JsonKey(name: 'identification_complete')
            bool identificationComplete,
            @JsonKey(name: 'new_species_nearby') bool newSpeciesNearby,
            @JsonKey(name: 'admin_verification') bool adminVerification,
            @JsonKey(name: 'educational_alerts') bool educationalAlerts,
            bool events)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'identification_complete')
            bool identificationComplete,
            @JsonKey(name: 'new_species_nearby') bool newSpeciesNearby,
            @JsonKey(name: 'admin_verification') bool adminVerification,
            @JsonKey(name: 'educational_alerts') bool educationalAlerts,
            bool events)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NotificationPreferences value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NotificationPreferences value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NotificationPreferences value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this NotificationPreferences to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationPreferencesCopyWith<NotificationPreferences> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationPreferencesCopyWith<$Res> {
  factory $NotificationPreferencesCopyWith(NotificationPreferences value,
          $Res Function(NotificationPreferences) then) =
      _$NotificationPreferencesCopyWithImpl<$Res, NotificationPreferences>;
  @useResult
  $Res call(
      {@JsonKey(name: 'identification_complete') bool identificationComplete,
      @JsonKey(name: 'new_species_nearby') bool newSpeciesNearby,
      @JsonKey(name: 'admin_verification') bool adminVerification,
      @JsonKey(name: 'educational_alerts') bool educationalAlerts,
      bool events});
}

/// @nodoc
class _$NotificationPreferencesCopyWithImpl<$Res,
        $Val extends NotificationPreferences>
    implements $NotificationPreferencesCopyWith<$Res> {
  _$NotificationPreferencesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identificationComplete = null,
    Object? newSpeciesNearby = null,
    Object? adminVerification = null,
    Object? educationalAlerts = null,
    Object? events = null,
  }) {
    return _then(_value.copyWith(
      identificationComplete: null == identificationComplete
          ? _value.identificationComplete
          : identificationComplete // ignore: cast_nullable_to_non_nullable
              as bool,
      newSpeciesNearby: null == newSpeciesNearby
          ? _value.newSpeciesNearby
          : newSpeciesNearby // ignore: cast_nullable_to_non_nullable
              as bool,
      adminVerification: null == adminVerification
          ? _value.adminVerification
          : adminVerification // ignore: cast_nullable_to_non_nullable
              as bool,
      educationalAlerts: null == educationalAlerts
          ? _value.educationalAlerts
          : educationalAlerts // ignore: cast_nullable_to_non_nullable
              as bool,
      events: null == events
          ? _value.events
          : events // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationPreferencesImplCopyWith<$Res>
    implements $NotificationPreferencesCopyWith<$Res> {
  factory _$$NotificationPreferencesImplCopyWith(
          _$NotificationPreferencesImpl value,
          $Res Function(_$NotificationPreferencesImpl) then) =
      __$$NotificationPreferencesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'identification_complete') bool identificationComplete,
      @JsonKey(name: 'new_species_nearby') bool newSpeciesNearby,
      @JsonKey(name: 'admin_verification') bool adminVerification,
      @JsonKey(name: 'educational_alerts') bool educationalAlerts,
      bool events});
}

/// @nodoc
class __$$NotificationPreferencesImplCopyWithImpl<$Res>
    extends _$NotificationPreferencesCopyWithImpl<$Res,
        _$NotificationPreferencesImpl>
    implements _$$NotificationPreferencesImplCopyWith<$Res> {
  __$$NotificationPreferencesImplCopyWithImpl(
      _$NotificationPreferencesImpl _value,
      $Res Function(_$NotificationPreferencesImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identificationComplete = null,
    Object? newSpeciesNearby = null,
    Object? adminVerification = null,
    Object? educationalAlerts = null,
    Object? events = null,
  }) {
    return _then(_$NotificationPreferencesImpl(
      identificationComplete: null == identificationComplete
          ? _value.identificationComplete
          : identificationComplete // ignore: cast_nullable_to_non_nullable
              as bool,
      newSpeciesNearby: null == newSpeciesNearby
          ? _value.newSpeciesNearby
          : newSpeciesNearby // ignore: cast_nullable_to_non_nullable
              as bool,
      adminVerification: null == adminVerification
          ? _value.adminVerification
          : adminVerification // ignore: cast_nullable_to_non_nullable
              as bool,
      educationalAlerts: null == educationalAlerts
          ? _value.educationalAlerts
          : educationalAlerts // ignore: cast_nullable_to_non_nullable
              as bool,
      events: null == events
          ? _value.events
          : events // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationPreferencesImpl implements _NotificationPreferences {
  const _$NotificationPreferencesImpl(
      {@JsonKey(name: 'identification_complete')
      this.identificationComplete = true,
      @JsonKey(name: 'new_species_nearby') this.newSpeciesNearby = true,
      @JsonKey(name: 'admin_verification') this.adminVerification = true,
      @JsonKey(name: 'educational_alerts') this.educationalAlerts = true,
      this.events = true});

  factory _$NotificationPreferencesImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationPreferencesImplFromJson(json);

  @override
  @JsonKey(name: 'identification_complete')
  final bool identificationComplete;
  @override
  @JsonKey(name: 'new_species_nearby')
  final bool newSpeciesNearby;
  @override
  @JsonKey(name: 'admin_verification')
  final bool adminVerification;
  @override
  @JsonKey(name: 'educational_alerts')
  final bool educationalAlerts;
  @override
  @JsonKey()
  final bool events;

  @override
  String toString() {
    return 'NotificationPreferences(identificationComplete: $identificationComplete, newSpeciesNearby: $newSpeciesNearby, adminVerification: $adminVerification, educationalAlerts: $educationalAlerts, events: $events)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationPreferencesImpl &&
            (identical(other.identificationComplete, identificationComplete) ||
                other.identificationComplete == identificationComplete) &&
            (identical(other.newSpeciesNearby, newSpeciesNearby) ||
                other.newSpeciesNearby == newSpeciesNearby) &&
            (identical(other.adminVerification, adminVerification) ||
                other.adminVerification == adminVerification) &&
            (identical(other.educationalAlerts, educationalAlerts) ||
                other.educationalAlerts == educationalAlerts) &&
            (identical(other.events, events) || other.events == events));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, identificationComplete,
      newSpeciesNearby, adminVerification, educationalAlerts, events);

  /// Create a copy of NotificationPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationPreferencesImplCopyWith<_$NotificationPreferencesImpl>
      get copyWith => __$$NotificationPreferencesImplCopyWithImpl<
          _$NotificationPreferencesImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'identification_complete')
            bool identificationComplete,
            @JsonKey(name: 'new_species_nearby') bool newSpeciesNearby,
            @JsonKey(name: 'admin_verification') bool adminVerification,
            @JsonKey(name: 'educational_alerts') bool educationalAlerts,
            bool events)
        $default,
  ) {
    return $default(identificationComplete, newSpeciesNearby, adminVerification,
        educationalAlerts, events);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            @JsonKey(name: 'identification_complete')
            bool identificationComplete,
            @JsonKey(name: 'new_species_nearby') bool newSpeciesNearby,
            @JsonKey(name: 'admin_verification') bool adminVerification,
            @JsonKey(name: 'educational_alerts') bool educationalAlerts,
            bool events)?
        $default,
  ) {
    return $default?.call(identificationComplete, newSpeciesNearby,
        adminVerification, educationalAlerts, events);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'identification_complete')
            bool identificationComplete,
            @JsonKey(name: 'new_species_nearby') bool newSpeciesNearby,
            @JsonKey(name: 'admin_verification') bool adminVerification,
            @JsonKey(name: 'educational_alerts') bool educationalAlerts,
            bool events)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(identificationComplete, newSpeciesNearby,
          adminVerification, educationalAlerts, events);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NotificationPreferences value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NotificationPreferences value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NotificationPreferences value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationPreferencesImplToJson(
      this,
    );
  }
}

abstract class _NotificationPreferences implements NotificationPreferences {
  const factory _NotificationPreferences(
      {@JsonKey(name: 'identification_complete')
      final bool identificationComplete,
      @JsonKey(name: 'new_species_nearby') final bool newSpeciesNearby,
      @JsonKey(name: 'admin_verification') final bool adminVerification,
      @JsonKey(name: 'educational_alerts') final bool educationalAlerts,
      final bool events}) = _$NotificationPreferencesImpl;

  factory _NotificationPreferences.fromJson(Map<String, dynamic> json) =
      _$NotificationPreferencesImpl.fromJson;

  @override
  @JsonKey(name: 'identification_complete')
  bool get identificationComplete;
  @override
  @JsonKey(name: 'new_species_nearby')
  bool get newSpeciesNearby;
  @override
  @JsonKey(name: 'admin_verification')
  bool get adminVerification;
  @override
  @JsonKey(name: 'educational_alerts')
  bool get educationalAlerts;
  @override
  bool get events;

  /// Create a copy of NotificationPreferences
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationPreferencesImplCopyWith<_$NotificationPreferencesImpl>
      get copyWith => throw _privateConstructorUsedError;
}
