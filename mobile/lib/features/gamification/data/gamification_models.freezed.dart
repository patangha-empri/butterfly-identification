// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gamification_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GamificationProfile _$GamificationProfileFromJson(Map<String, dynamic> json) {
  return _GamificationProfile.fromJson(json);
}

/// @nodoc
mixin _$GamificationProfile {
  GamificationStats get stats => throw _privateConstructorUsedError;
  StreakInfo get streak => throw _privateConstructorUsedError;
  @JsonKey(name: 'achievements_earned')
  int get achievementsEarned => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(GamificationStats stats, StreakInfo streak,
            @JsonKey(name: 'achievements_earned') int achievementsEarned)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(GamificationStats stats, StreakInfo streak,
            @JsonKey(name: 'achievements_earned') int achievementsEarned)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(GamificationStats stats, StreakInfo streak,
            @JsonKey(name: 'achievements_earned') int achievementsEarned)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_GamificationProfile value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_GamificationProfile value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_GamificationProfile value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this GamificationProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GamificationProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GamificationProfileCopyWith<GamificationProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GamificationProfileCopyWith<$Res> {
  factory $GamificationProfileCopyWith(
          GamificationProfile value, $Res Function(GamificationProfile) then) =
      _$GamificationProfileCopyWithImpl<$Res, GamificationProfile>;
  @useResult
  $Res call(
      {GamificationStats stats,
      StreakInfo streak,
      @JsonKey(name: 'achievements_earned') int achievementsEarned});

  $GamificationStatsCopyWith<$Res> get stats;
  $StreakInfoCopyWith<$Res> get streak;
}

/// @nodoc
class _$GamificationProfileCopyWithImpl<$Res, $Val extends GamificationProfile>
    implements $GamificationProfileCopyWith<$Res> {
  _$GamificationProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GamificationProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stats = null,
    Object? streak = null,
    Object? achievementsEarned = null,
  }) {
    return _then(_value.copyWith(
      stats: null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as GamificationStats,
      streak: null == streak
          ? _value.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as StreakInfo,
      achievementsEarned: null == achievementsEarned
          ? _value.achievementsEarned
          : achievementsEarned // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of GamificationProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GamificationStatsCopyWith<$Res> get stats {
    return $GamificationStatsCopyWith<$Res>(_value.stats, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }

  /// Create a copy of GamificationProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StreakInfoCopyWith<$Res> get streak {
    return $StreakInfoCopyWith<$Res>(_value.streak, (value) {
      return _then(_value.copyWith(streak: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GamificationProfileImplCopyWith<$Res>
    implements $GamificationProfileCopyWith<$Res> {
  factory _$$GamificationProfileImplCopyWith(_$GamificationProfileImpl value,
          $Res Function(_$GamificationProfileImpl) then) =
      __$$GamificationProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {GamificationStats stats,
      StreakInfo streak,
      @JsonKey(name: 'achievements_earned') int achievementsEarned});

  @override
  $GamificationStatsCopyWith<$Res> get stats;
  @override
  $StreakInfoCopyWith<$Res> get streak;
}

/// @nodoc
class __$$GamificationProfileImplCopyWithImpl<$Res>
    extends _$GamificationProfileCopyWithImpl<$Res, _$GamificationProfileImpl>
    implements _$$GamificationProfileImplCopyWith<$Res> {
  __$$GamificationProfileImplCopyWithImpl(_$GamificationProfileImpl _value,
      $Res Function(_$GamificationProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of GamificationProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stats = null,
    Object? streak = null,
    Object? achievementsEarned = null,
  }) {
    return _then(_$GamificationProfileImpl(
      stats: null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as GamificationStats,
      streak: null == streak
          ? _value.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as StreakInfo,
      achievementsEarned: null == achievementsEarned
          ? _value.achievementsEarned
          : achievementsEarned // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GamificationProfileImpl extends _GamificationProfile {
  const _$GamificationProfileImpl(
      {this.stats = const GamificationStats(),
      this.streak = const StreakInfo(),
      @JsonKey(name: 'achievements_earned') this.achievementsEarned = 0})
      : super._();

  factory _$GamificationProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$GamificationProfileImplFromJson(json);

  @override
  @JsonKey()
  final GamificationStats stats;
  @override
  @JsonKey()
  final StreakInfo streak;
  @override
  @JsonKey(name: 'achievements_earned')
  final int achievementsEarned;

  @override
  String toString() {
    return 'GamificationProfile(stats: $stats, streak: $streak, achievementsEarned: $achievementsEarned)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GamificationProfileImpl &&
            (identical(other.stats, stats) || other.stats == stats) &&
            (identical(other.streak, streak) || other.streak == streak) &&
            (identical(other.achievementsEarned, achievementsEarned) ||
                other.achievementsEarned == achievementsEarned));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, stats, streak, achievementsEarned);

  /// Create a copy of GamificationProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GamificationProfileImplCopyWith<_$GamificationProfileImpl> get copyWith =>
      __$$GamificationProfileImplCopyWithImpl<_$GamificationProfileImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(GamificationStats stats, StreakInfo streak,
            @JsonKey(name: 'achievements_earned') int achievementsEarned)
        $default,
  ) {
    return $default(stats, streak, achievementsEarned);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(GamificationStats stats, StreakInfo streak,
            @JsonKey(name: 'achievements_earned') int achievementsEarned)?
        $default,
  ) {
    return $default?.call(stats, streak, achievementsEarned);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(GamificationStats stats, StreakInfo streak,
            @JsonKey(name: 'achievements_earned') int achievementsEarned)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(stats, streak, achievementsEarned);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_GamificationProfile value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_GamificationProfile value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_GamificationProfile value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$GamificationProfileImplToJson(
      this,
    );
  }
}

abstract class _GamificationProfile extends GamificationProfile {
  const factory _GamificationProfile(
          {final GamificationStats stats,
          final StreakInfo streak,
          @JsonKey(name: 'achievements_earned') final int achievementsEarned}) =
      _$GamificationProfileImpl;
  const _GamificationProfile._() : super._();

  factory _GamificationProfile.fromJson(Map<String, dynamic> json) =
      _$GamificationProfileImpl.fromJson;

  @override
  GamificationStats get stats;
  @override
  StreakInfo get streak;
  @override
  @JsonKey(name: 'achievements_earned')
  int get achievementsEarned;

  /// Create a copy of GamificationProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GamificationProfileImplCopyWith<_$GamificationProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GamificationStats _$GamificationStatsFromJson(Map<String, dynamic> json) {
  return _GamificationStats.fromJson(json);
}

/// @nodoc
mixin _$GamificationStats {
  @JsonKey(name: 'total_observations')
  int get totalObservations => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_identifications')
  int get totalIdentifications => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_species_observed')
  int get totalSpeciesObserved => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_states_explored')
  int get totalStatesExplored => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_points')
  int get totalPoints => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'total_observations') int totalObservations,
            @JsonKey(name: 'total_identifications') int totalIdentifications,
            @JsonKey(name: 'total_species_observed') int totalSpeciesObserved,
            @JsonKey(name: 'total_states_explored') int totalStatesExplored,
            @JsonKey(name: 'total_points') int totalPoints)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            @JsonKey(name: 'total_observations') int totalObservations,
            @JsonKey(name: 'total_identifications') int totalIdentifications,
            @JsonKey(name: 'total_species_observed') int totalSpeciesObserved,
            @JsonKey(name: 'total_states_explored') int totalStatesExplored,
            @JsonKey(name: 'total_points') int totalPoints)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'total_observations') int totalObservations,
            @JsonKey(name: 'total_identifications') int totalIdentifications,
            @JsonKey(name: 'total_species_observed') int totalSpeciesObserved,
            @JsonKey(name: 'total_states_explored') int totalStatesExplored,
            @JsonKey(name: 'total_points') int totalPoints)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_GamificationStats value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_GamificationStats value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_GamificationStats value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this GamificationStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GamificationStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GamificationStatsCopyWith<GamificationStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GamificationStatsCopyWith<$Res> {
  factory $GamificationStatsCopyWith(
          GamificationStats value, $Res Function(GamificationStats) then) =
      _$GamificationStatsCopyWithImpl<$Res, GamificationStats>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_observations') int totalObservations,
      @JsonKey(name: 'total_identifications') int totalIdentifications,
      @JsonKey(name: 'total_species_observed') int totalSpeciesObserved,
      @JsonKey(name: 'total_states_explored') int totalStatesExplored,
      @JsonKey(name: 'total_points') int totalPoints});
}

/// @nodoc
class _$GamificationStatsCopyWithImpl<$Res, $Val extends GamificationStats>
    implements $GamificationStatsCopyWith<$Res> {
  _$GamificationStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GamificationStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalObservations = null,
    Object? totalIdentifications = null,
    Object? totalSpeciesObserved = null,
    Object? totalStatesExplored = null,
    Object? totalPoints = null,
  }) {
    return _then(_value.copyWith(
      totalObservations: null == totalObservations
          ? _value.totalObservations
          : totalObservations // ignore: cast_nullable_to_non_nullable
              as int,
      totalIdentifications: null == totalIdentifications
          ? _value.totalIdentifications
          : totalIdentifications // ignore: cast_nullable_to_non_nullable
              as int,
      totalSpeciesObserved: null == totalSpeciesObserved
          ? _value.totalSpeciesObserved
          : totalSpeciesObserved // ignore: cast_nullable_to_non_nullable
              as int,
      totalStatesExplored: null == totalStatesExplored
          ? _value.totalStatesExplored
          : totalStatesExplored // ignore: cast_nullable_to_non_nullable
              as int,
      totalPoints: null == totalPoints
          ? _value.totalPoints
          : totalPoints // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GamificationStatsImplCopyWith<$Res>
    implements $GamificationStatsCopyWith<$Res> {
  factory _$$GamificationStatsImplCopyWith(_$GamificationStatsImpl value,
          $Res Function(_$GamificationStatsImpl) then) =
      __$$GamificationStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_observations') int totalObservations,
      @JsonKey(name: 'total_identifications') int totalIdentifications,
      @JsonKey(name: 'total_species_observed') int totalSpeciesObserved,
      @JsonKey(name: 'total_states_explored') int totalStatesExplored,
      @JsonKey(name: 'total_points') int totalPoints});
}

/// @nodoc
class __$$GamificationStatsImplCopyWithImpl<$Res>
    extends _$GamificationStatsCopyWithImpl<$Res, _$GamificationStatsImpl>
    implements _$$GamificationStatsImplCopyWith<$Res> {
  __$$GamificationStatsImplCopyWithImpl(_$GamificationStatsImpl _value,
      $Res Function(_$GamificationStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of GamificationStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalObservations = null,
    Object? totalIdentifications = null,
    Object? totalSpeciesObserved = null,
    Object? totalStatesExplored = null,
    Object? totalPoints = null,
  }) {
    return _then(_$GamificationStatsImpl(
      totalObservations: null == totalObservations
          ? _value.totalObservations
          : totalObservations // ignore: cast_nullable_to_non_nullable
              as int,
      totalIdentifications: null == totalIdentifications
          ? _value.totalIdentifications
          : totalIdentifications // ignore: cast_nullable_to_non_nullable
              as int,
      totalSpeciesObserved: null == totalSpeciesObserved
          ? _value.totalSpeciesObserved
          : totalSpeciesObserved // ignore: cast_nullable_to_non_nullable
              as int,
      totalStatesExplored: null == totalStatesExplored
          ? _value.totalStatesExplored
          : totalStatesExplored // ignore: cast_nullable_to_non_nullable
              as int,
      totalPoints: null == totalPoints
          ? _value.totalPoints
          : totalPoints // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GamificationStatsImpl implements _GamificationStats {
  const _$GamificationStatsImpl(
      {@JsonKey(name: 'total_observations') this.totalObservations = 0,
      @JsonKey(name: 'total_identifications') this.totalIdentifications = 0,
      @JsonKey(name: 'total_species_observed') this.totalSpeciesObserved = 0,
      @JsonKey(name: 'total_states_explored') this.totalStatesExplored = 0,
      @JsonKey(name: 'total_points') this.totalPoints = 0});

  factory _$GamificationStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$GamificationStatsImplFromJson(json);

  @override
  @JsonKey(name: 'total_observations')
  final int totalObservations;
  @override
  @JsonKey(name: 'total_identifications')
  final int totalIdentifications;
  @override
  @JsonKey(name: 'total_species_observed')
  final int totalSpeciesObserved;
  @override
  @JsonKey(name: 'total_states_explored')
  final int totalStatesExplored;
  @override
  @JsonKey(name: 'total_points')
  final int totalPoints;

  @override
  String toString() {
    return 'GamificationStats(totalObservations: $totalObservations, totalIdentifications: $totalIdentifications, totalSpeciesObserved: $totalSpeciesObserved, totalStatesExplored: $totalStatesExplored, totalPoints: $totalPoints)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GamificationStatsImpl &&
            (identical(other.totalObservations, totalObservations) ||
                other.totalObservations == totalObservations) &&
            (identical(other.totalIdentifications, totalIdentifications) ||
                other.totalIdentifications == totalIdentifications) &&
            (identical(other.totalSpeciesObserved, totalSpeciesObserved) ||
                other.totalSpeciesObserved == totalSpeciesObserved) &&
            (identical(other.totalStatesExplored, totalStatesExplored) ||
                other.totalStatesExplored == totalStatesExplored) &&
            (identical(other.totalPoints, totalPoints) ||
                other.totalPoints == totalPoints));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalObservations,
      totalIdentifications,
      totalSpeciesObserved,
      totalStatesExplored,
      totalPoints);

  /// Create a copy of GamificationStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GamificationStatsImplCopyWith<_$GamificationStatsImpl> get copyWith =>
      __$$GamificationStatsImplCopyWithImpl<_$GamificationStatsImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'total_observations') int totalObservations,
            @JsonKey(name: 'total_identifications') int totalIdentifications,
            @JsonKey(name: 'total_species_observed') int totalSpeciesObserved,
            @JsonKey(name: 'total_states_explored') int totalStatesExplored,
            @JsonKey(name: 'total_points') int totalPoints)
        $default,
  ) {
    return $default(totalObservations, totalIdentifications,
        totalSpeciesObserved, totalStatesExplored, totalPoints);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            @JsonKey(name: 'total_observations') int totalObservations,
            @JsonKey(name: 'total_identifications') int totalIdentifications,
            @JsonKey(name: 'total_species_observed') int totalSpeciesObserved,
            @JsonKey(name: 'total_states_explored') int totalStatesExplored,
            @JsonKey(name: 'total_points') int totalPoints)?
        $default,
  ) {
    return $default?.call(totalObservations, totalIdentifications,
        totalSpeciesObserved, totalStatesExplored, totalPoints);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'total_observations') int totalObservations,
            @JsonKey(name: 'total_identifications') int totalIdentifications,
            @JsonKey(name: 'total_species_observed') int totalSpeciesObserved,
            @JsonKey(name: 'total_states_explored') int totalStatesExplored,
            @JsonKey(name: 'total_points') int totalPoints)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(totalObservations, totalIdentifications,
          totalSpeciesObserved, totalStatesExplored, totalPoints);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_GamificationStats value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_GamificationStats value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_GamificationStats value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$GamificationStatsImplToJson(
      this,
    );
  }
}

abstract class _GamificationStats implements GamificationStats {
  const factory _GamificationStats(
      {@JsonKey(name: 'total_observations') final int totalObservations,
      @JsonKey(name: 'total_identifications') final int totalIdentifications,
      @JsonKey(name: 'total_species_observed') final int totalSpeciesObserved,
      @JsonKey(name: 'total_states_explored') final int totalStatesExplored,
      @JsonKey(name: 'total_points')
      final int totalPoints}) = _$GamificationStatsImpl;

  factory _GamificationStats.fromJson(Map<String, dynamic> json) =
      _$GamificationStatsImpl.fromJson;

  @override
  @JsonKey(name: 'total_observations')
  int get totalObservations;
  @override
  @JsonKey(name: 'total_identifications')
  int get totalIdentifications;
  @override
  @JsonKey(name: 'total_species_observed')
  int get totalSpeciesObserved;
  @override
  @JsonKey(name: 'total_states_explored')
  int get totalStatesExplored;
  @override
  @JsonKey(name: 'total_points')
  int get totalPoints;

  /// Create a copy of GamificationStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GamificationStatsImplCopyWith<_$GamificationStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StreakInfo _$StreakInfoFromJson(Map<String, dynamic> json) {
  return _StreakInfo.fromJson(json);
}

/// @nodoc
mixin _$StreakInfo {
  @JsonKey(name: 'current_streak')
  int get currentStreak => throw _privateConstructorUsedError;
  @JsonKey(name: 'longest_streak')
  int get longestStreak => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_observation_date')
  String? get lastObservationDate => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'current_streak') int currentStreak,
            @JsonKey(name: 'longest_streak') int longestStreak,
            @JsonKey(name: 'last_observation_date') String? lastObservationDate)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            @JsonKey(name: 'current_streak') int currentStreak,
            @JsonKey(name: 'longest_streak') int longestStreak,
            @JsonKey(name: 'last_observation_date')
            String? lastObservationDate)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'current_streak') int currentStreak,
            @JsonKey(name: 'longest_streak') int longestStreak,
            @JsonKey(name: 'last_observation_date')
            String? lastObservationDate)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StreakInfo value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StreakInfo value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StreakInfo value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this StreakInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StreakInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StreakInfoCopyWith<StreakInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StreakInfoCopyWith<$Res> {
  factory $StreakInfoCopyWith(
          StreakInfo value, $Res Function(StreakInfo) then) =
      _$StreakInfoCopyWithImpl<$Res, StreakInfo>;
  @useResult
  $Res call(
      {@JsonKey(name: 'current_streak') int currentStreak,
      @JsonKey(name: 'longest_streak') int longestStreak,
      @JsonKey(name: 'last_observation_date') String? lastObservationDate});
}

/// @nodoc
class _$StreakInfoCopyWithImpl<$Res, $Val extends StreakInfo>
    implements $StreakInfoCopyWith<$Res> {
  _$StreakInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StreakInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastObservationDate = freezed,
  }) {
    return _then(_value.copyWith(
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      lastObservationDate: freezed == lastObservationDate
          ? _value.lastObservationDate
          : lastObservationDate // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StreakInfoImplCopyWith<$Res>
    implements $StreakInfoCopyWith<$Res> {
  factory _$$StreakInfoImplCopyWith(
          _$StreakInfoImpl value, $Res Function(_$StreakInfoImpl) then) =
      __$$StreakInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'current_streak') int currentStreak,
      @JsonKey(name: 'longest_streak') int longestStreak,
      @JsonKey(name: 'last_observation_date') String? lastObservationDate});
}

/// @nodoc
class __$$StreakInfoImplCopyWithImpl<$Res>
    extends _$StreakInfoCopyWithImpl<$Res, _$StreakInfoImpl>
    implements _$$StreakInfoImplCopyWith<$Res> {
  __$$StreakInfoImplCopyWithImpl(
      _$StreakInfoImpl _value, $Res Function(_$StreakInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of StreakInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastObservationDate = freezed,
  }) {
    return _then(_$StreakInfoImpl(
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      lastObservationDate: freezed == lastObservationDate
          ? _value.lastObservationDate
          : lastObservationDate // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreakInfoImpl implements _StreakInfo {
  const _$StreakInfoImpl(
      {@JsonKey(name: 'current_streak') this.currentStreak = 0,
      @JsonKey(name: 'longest_streak') this.longestStreak = 0,
      @JsonKey(name: 'last_observation_date') this.lastObservationDate});

  factory _$StreakInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$StreakInfoImplFromJson(json);

  @override
  @JsonKey(name: 'current_streak')
  final int currentStreak;
  @override
  @JsonKey(name: 'longest_streak')
  final int longestStreak;
  @override
  @JsonKey(name: 'last_observation_date')
  final String? lastObservationDate;

  @override
  String toString() {
    return 'StreakInfo(currentStreak: $currentStreak, longestStreak: $longestStreak, lastObservationDate: $lastObservationDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreakInfoImpl &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.lastObservationDate, lastObservationDate) ||
                other.lastObservationDate == lastObservationDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, currentStreak, longestStreak, lastObservationDate);

  /// Create a copy of StreakInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StreakInfoImplCopyWith<_$StreakInfoImpl> get copyWith =>
      __$$StreakInfoImplCopyWithImpl<_$StreakInfoImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'current_streak') int currentStreak,
            @JsonKey(name: 'longest_streak') int longestStreak,
            @JsonKey(name: 'last_observation_date') String? lastObservationDate)
        $default,
  ) {
    return $default(currentStreak, longestStreak, lastObservationDate);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            @JsonKey(name: 'current_streak') int currentStreak,
            @JsonKey(name: 'longest_streak') int longestStreak,
            @JsonKey(name: 'last_observation_date')
            String? lastObservationDate)?
        $default,
  ) {
    return $default?.call(currentStreak, longestStreak, lastObservationDate);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'current_streak') int currentStreak,
            @JsonKey(name: 'longest_streak') int longestStreak,
            @JsonKey(name: 'last_observation_date')
            String? lastObservationDate)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(currentStreak, longestStreak, lastObservationDate);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StreakInfo value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StreakInfo value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StreakInfo value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreakInfoImplToJson(
      this,
    );
  }
}

abstract class _StreakInfo implements StreakInfo {
  const factory _StreakInfo(
      {@JsonKey(name: 'current_streak') final int currentStreak,
      @JsonKey(name: 'longest_streak') final int longestStreak,
      @JsonKey(name: 'last_observation_date')
      final String? lastObservationDate}) = _$StreakInfoImpl;

  factory _StreakInfo.fromJson(Map<String, dynamic> json) =
      _$StreakInfoImpl.fromJson;

  @override
  @JsonKey(name: 'current_streak')
  int get currentStreak;
  @override
  @JsonKey(name: 'longest_streak')
  int get longestStreak;
  @override
  @JsonKey(name: 'last_observation_date')
  String? get lastObservationDate;

  /// Create a copy of StreakInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StreakInfoImplCopyWith<_$StreakInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AchievementItem _$AchievementItemFromJson(Map<String, dynamic> json) {
  return _AchievementItem.fromJson(json);
}

/// @nodoc
mixin _$AchievementItem {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'badge_image_url')
  String? get badgeImageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'achievement_type')
  String get achievementType => throw _privateConstructorUsedError;
  @JsonKey(name: 'threshold_value')
  int get thresholdValue => throw _privateConstructorUsedError;
  int get points => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_earned')
  bool get isEarned => throw _privateConstructorUsedError;
  @JsonKey(name: 'earned_at')
  DateTime? get earnedAt => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            int id,
            String name,
            String description,
            @JsonKey(name: 'badge_image_url') String? badgeImageUrl,
            @JsonKey(name: 'achievement_type') String achievementType,
            @JsonKey(name: 'threshold_value') int thresholdValue,
            int points,
            @JsonKey(name: 'is_earned') bool isEarned,
            @JsonKey(name: 'earned_at') DateTime? earnedAt)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            int id,
            String name,
            String description,
            @JsonKey(name: 'badge_image_url') String? badgeImageUrl,
            @JsonKey(name: 'achievement_type') String achievementType,
            @JsonKey(name: 'threshold_value') int thresholdValue,
            int points,
            @JsonKey(name: 'is_earned') bool isEarned,
            @JsonKey(name: 'earned_at') DateTime? earnedAt)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            int id,
            String name,
            String description,
            @JsonKey(name: 'badge_image_url') String? badgeImageUrl,
            @JsonKey(name: 'achievement_type') String achievementType,
            @JsonKey(name: 'threshold_value') int thresholdValue,
            int points,
            @JsonKey(name: 'is_earned') bool isEarned,
            @JsonKey(name: 'earned_at') DateTime? earnedAt)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AchievementItem value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AchievementItem value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AchievementItem value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this AchievementItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AchievementItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AchievementItemCopyWith<AchievementItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AchievementItemCopyWith<$Res> {
  factory $AchievementItemCopyWith(
          AchievementItem value, $Res Function(AchievementItem) then) =
      _$AchievementItemCopyWithImpl<$Res, AchievementItem>;
  @useResult
  $Res call(
      {int id,
      String name,
      String description,
      @JsonKey(name: 'badge_image_url') String? badgeImageUrl,
      @JsonKey(name: 'achievement_type') String achievementType,
      @JsonKey(name: 'threshold_value') int thresholdValue,
      int points,
      @JsonKey(name: 'is_earned') bool isEarned,
      @JsonKey(name: 'earned_at') DateTime? earnedAt});
}

/// @nodoc
class _$AchievementItemCopyWithImpl<$Res, $Val extends AchievementItem>
    implements $AchievementItemCopyWith<$Res> {
  _$AchievementItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AchievementItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? badgeImageUrl = freezed,
    Object? achievementType = null,
    Object? thresholdValue = null,
    Object? points = null,
    Object? isEarned = null,
    Object? earnedAt = freezed,
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
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      badgeImageUrl: freezed == badgeImageUrl
          ? _value.badgeImageUrl
          : badgeImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      achievementType: null == achievementType
          ? _value.achievementType
          : achievementType // ignore: cast_nullable_to_non_nullable
              as String,
      thresholdValue: null == thresholdValue
          ? _value.thresholdValue
          : thresholdValue // ignore: cast_nullable_to_non_nullable
              as int,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      isEarned: null == isEarned
          ? _value.isEarned
          : isEarned // ignore: cast_nullable_to_non_nullable
              as bool,
      earnedAt: freezed == earnedAt
          ? _value.earnedAt
          : earnedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AchievementItemImplCopyWith<$Res>
    implements $AchievementItemCopyWith<$Res> {
  factory _$$AchievementItemImplCopyWith(_$AchievementItemImpl value,
          $Res Function(_$AchievementItemImpl) then) =
      __$$AchievementItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String description,
      @JsonKey(name: 'badge_image_url') String? badgeImageUrl,
      @JsonKey(name: 'achievement_type') String achievementType,
      @JsonKey(name: 'threshold_value') int thresholdValue,
      int points,
      @JsonKey(name: 'is_earned') bool isEarned,
      @JsonKey(name: 'earned_at') DateTime? earnedAt});
}

/// @nodoc
class __$$AchievementItemImplCopyWithImpl<$Res>
    extends _$AchievementItemCopyWithImpl<$Res, _$AchievementItemImpl>
    implements _$$AchievementItemImplCopyWith<$Res> {
  __$$AchievementItemImplCopyWithImpl(
      _$AchievementItemImpl _value, $Res Function(_$AchievementItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of AchievementItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? badgeImageUrl = freezed,
    Object? achievementType = null,
    Object? thresholdValue = null,
    Object? points = null,
    Object? isEarned = null,
    Object? earnedAt = freezed,
  }) {
    return _then(_$AchievementItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      badgeImageUrl: freezed == badgeImageUrl
          ? _value.badgeImageUrl
          : badgeImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      achievementType: null == achievementType
          ? _value.achievementType
          : achievementType // ignore: cast_nullable_to_non_nullable
              as String,
      thresholdValue: null == thresholdValue
          ? _value.thresholdValue
          : thresholdValue // ignore: cast_nullable_to_non_nullable
              as int,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      isEarned: null == isEarned
          ? _value.isEarned
          : isEarned // ignore: cast_nullable_to_non_nullable
              as bool,
      earnedAt: freezed == earnedAt
          ? _value.earnedAt
          : earnedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AchievementItemImpl extends _AchievementItem {
  const _$AchievementItemImpl(
      {required this.id,
      this.name = '',
      this.description = '',
      @JsonKey(name: 'badge_image_url') this.badgeImageUrl,
      @JsonKey(name: 'achievement_type') this.achievementType = '',
      @JsonKey(name: 'threshold_value') this.thresholdValue = 1,
      this.points = 10,
      @JsonKey(name: 'is_earned') this.isEarned = false,
      @JsonKey(name: 'earned_at') this.earnedAt})
      : super._();

  factory _$AchievementItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$AchievementItemImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey(name: 'badge_image_url')
  final String? badgeImageUrl;
  @override
  @JsonKey(name: 'achievement_type')
  final String achievementType;
  @override
  @JsonKey(name: 'threshold_value')
  final int thresholdValue;
  @override
  @JsonKey()
  final int points;
  @override
  @JsonKey(name: 'is_earned')
  final bool isEarned;
  @override
  @JsonKey(name: 'earned_at')
  final DateTime? earnedAt;

  @override
  String toString() {
    return 'AchievementItem(id: $id, name: $name, description: $description, badgeImageUrl: $badgeImageUrl, achievementType: $achievementType, thresholdValue: $thresholdValue, points: $points, isEarned: $isEarned, earnedAt: $earnedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AchievementItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.badgeImageUrl, badgeImageUrl) ||
                other.badgeImageUrl == badgeImageUrl) &&
            (identical(other.achievementType, achievementType) ||
                other.achievementType == achievementType) &&
            (identical(other.thresholdValue, thresholdValue) ||
                other.thresholdValue == thresholdValue) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.isEarned, isEarned) ||
                other.isEarned == isEarned) &&
            (identical(other.earnedAt, earnedAt) ||
                other.earnedAt == earnedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      badgeImageUrl,
      achievementType,
      thresholdValue,
      points,
      isEarned,
      earnedAt);

  /// Create a copy of AchievementItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AchievementItemImplCopyWith<_$AchievementItemImpl> get copyWith =>
      __$$AchievementItemImplCopyWithImpl<_$AchievementItemImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            int id,
            String name,
            String description,
            @JsonKey(name: 'badge_image_url') String? badgeImageUrl,
            @JsonKey(name: 'achievement_type') String achievementType,
            @JsonKey(name: 'threshold_value') int thresholdValue,
            int points,
            @JsonKey(name: 'is_earned') bool isEarned,
            @JsonKey(name: 'earned_at') DateTime? earnedAt)
        $default,
  ) {
    return $default(id, name, description, badgeImageUrl, achievementType,
        thresholdValue, points, isEarned, earnedAt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            int id,
            String name,
            String description,
            @JsonKey(name: 'badge_image_url') String? badgeImageUrl,
            @JsonKey(name: 'achievement_type') String achievementType,
            @JsonKey(name: 'threshold_value') int thresholdValue,
            int points,
            @JsonKey(name: 'is_earned') bool isEarned,
            @JsonKey(name: 'earned_at') DateTime? earnedAt)?
        $default,
  ) {
    return $default?.call(id, name, description, badgeImageUrl, achievementType,
        thresholdValue, points, isEarned, earnedAt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            int id,
            String name,
            String description,
            @JsonKey(name: 'badge_image_url') String? badgeImageUrl,
            @JsonKey(name: 'achievement_type') String achievementType,
            @JsonKey(name: 'threshold_value') int thresholdValue,
            int points,
            @JsonKey(name: 'is_earned') bool isEarned,
            @JsonKey(name: 'earned_at') DateTime? earnedAt)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(id, name, description, badgeImageUrl, achievementType,
          thresholdValue, points, isEarned, earnedAt);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AchievementItem value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AchievementItem value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AchievementItem value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AchievementItemImplToJson(
      this,
    );
  }
}

abstract class _AchievementItem extends AchievementItem {
  const factory _AchievementItem(
          {required final int id,
          final String name,
          final String description,
          @JsonKey(name: 'badge_image_url') final String? badgeImageUrl,
          @JsonKey(name: 'achievement_type') final String achievementType,
          @JsonKey(name: 'threshold_value') final int thresholdValue,
          final int points,
          @JsonKey(name: 'is_earned') final bool isEarned,
          @JsonKey(name: 'earned_at') final DateTime? earnedAt}) =
      _$AchievementItemImpl;
  const _AchievementItem._() : super._();

  factory _AchievementItem.fromJson(Map<String, dynamic> json) =
      _$AchievementItemImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get description;
  @override
  @JsonKey(name: 'badge_image_url')
  String? get badgeImageUrl;
  @override
  @JsonKey(name: 'achievement_type')
  String get achievementType;
  @override
  @JsonKey(name: 'threshold_value')
  int get thresholdValue;
  @override
  int get points;
  @override
  @JsonKey(name: 'is_earned')
  bool get isEarned;
  @override
  @JsonKey(name: 'earned_at')
  DateTime? get earnedAt;

  /// Create a copy of AchievementItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AchievementItemImplCopyWith<_$AchievementItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
