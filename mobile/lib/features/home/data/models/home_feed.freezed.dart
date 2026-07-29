// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_feed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomeFeed {
  List<SpeciesSummary> get trending => throw _privateConstructorUsedError;
  List<SpeciesSummary> get seasonal => throw _privateConstructorUsedError;
  List<SpeciesSummary> get featured => throw _privateConstructorUsedError;
  List<ObservationSummary> get nearby => throw _privateConstructorUsedError;
  List<ObservationSummary> get recent => throw _privateConstructorUsedError;
  bool get fromCache => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            List<SpeciesSummary> trending,
            List<SpeciesSummary> seasonal,
            List<SpeciesSummary> featured,
            List<ObservationSummary> nearby,
            List<ObservationSummary> recent,
            bool fromCache)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            List<SpeciesSummary> trending,
            List<SpeciesSummary> seasonal,
            List<SpeciesSummary> featured,
            List<ObservationSummary> nearby,
            List<ObservationSummary> recent,
            bool fromCache)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            List<SpeciesSummary> trending,
            List<SpeciesSummary> seasonal,
            List<SpeciesSummary> featured,
            List<ObservationSummary> nearby,
            List<ObservationSummary> recent,
            bool fromCache)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_HomeFeed value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_HomeFeed value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_HomeFeed value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of HomeFeed
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeFeedCopyWith<HomeFeed> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeFeedCopyWith<$Res> {
  factory $HomeFeedCopyWith(HomeFeed value, $Res Function(HomeFeed) then) =
      _$HomeFeedCopyWithImpl<$Res, HomeFeed>;
  @useResult
  $Res call(
      {List<SpeciesSummary> trending,
      List<SpeciesSummary> seasonal,
      List<SpeciesSummary> featured,
      List<ObservationSummary> nearby,
      List<ObservationSummary> recent,
      bool fromCache});
}

/// @nodoc
class _$HomeFeedCopyWithImpl<$Res, $Val extends HomeFeed>
    implements $HomeFeedCopyWith<$Res> {
  _$HomeFeedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeFeed
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trending = null,
    Object? seasonal = null,
    Object? featured = null,
    Object? nearby = null,
    Object? recent = null,
    Object? fromCache = null,
  }) {
    return _then(_value.copyWith(
      trending: null == trending
          ? _value.trending
          : trending // ignore: cast_nullable_to_non_nullable
              as List<SpeciesSummary>,
      seasonal: null == seasonal
          ? _value.seasonal
          : seasonal // ignore: cast_nullable_to_non_nullable
              as List<SpeciesSummary>,
      featured: null == featured
          ? _value.featured
          : featured // ignore: cast_nullable_to_non_nullable
              as List<SpeciesSummary>,
      nearby: null == nearby
          ? _value.nearby
          : nearby // ignore: cast_nullable_to_non_nullable
              as List<ObservationSummary>,
      recent: null == recent
          ? _value.recent
          : recent // ignore: cast_nullable_to_non_nullable
              as List<ObservationSummary>,
      fromCache: null == fromCache
          ? _value.fromCache
          : fromCache // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomeFeedImplCopyWith<$Res>
    implements $HomeFeedCopyWith<$Res> {
  factory _$$HomeFeedImplCopyWith(
          _$HomeFeedImpl value, $Res Function(_$HomeFeedImpl) then) =
      __$$HomeFeedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<SpeciesSummary> trending,
      List<SpeciesSummary> seasonal,
      List<SpeciesSummary> featured,
      List<ObservationSummary> nearby,
      List<ObservationSummary> recent,
      bool fromCache});
}

/// @nodoc
class __$$HomeFeedImplCopyWithImpl<$Res>
    extends _$HomeFeedCopyWithImpl<$Res, _$HomeFeedImpl>
    implements _$$HomeFeedImplCopyWith<$Res> {
  __$$HomeFeedImplCopyWithImpl(
      _$HomeFeedImpl _value, $Res Function(_$HomeFeedImpl) _then)
      : super(_value, _then);

  /// Create a copy of HomeFeed
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trending = null,
    Object? seasonal = null,
    Object? featured = null,
    Object? nearby = null,
    Object? recent = null,
    Object? fromCache = null,
  }) {
    return _then(_$HomeFeedImpl(
      trending: null == trending
          ? _value._trending
          : trending // ignore: cast_nullable_to_non_nullable
              as List<SpeciesSummary>,
      seasonal: null == seasonal
          ? _value._seasonal
          : seasonal // ignore: cast_nullable_to_non_nullable
              as List<SpeciesSummary>,
      featured: null == featured
          ? _value._featured
          : featured // ignore: cast_nullable_to_non_nullable
              as List<SpeciesSummary>,
      nearby: null == nearby
          ? _value._nearby
          : nearby // ignore: cast_nullable_to_non_nullable
              as List<ObservationSummary>,
      recent: null == recent
          ? _value._recent
          : recent // ignore: cast_nullable_to_non_nullable
              as List<ObservationSummary>,
      fromCache: null == fromCache
          ? _value.fromCache
          : fromCache // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$HomeFeedImpl extends _HomeFeed {
  const _$HomeFeedImpl(
      {final List<SpeciesSummary> trending = const [],
      final List<SpeciesSummary> seasonal = const [],
      final List<SpeciesSummary> featured = const [],
      final List<ObservationSummary> nearby = const [],
      final List<ObservationSummary> recent = const [],
      this.fromCache = false})
      : _trending = trending,
        _seasonal = seasonal,
        _featured = featured,
        _nearby = nearby,
        _recent = recent,
        super._();

  final List<SpeciesSummary> _trending;
  @override
  @JsonKey()
  List<SpeciesSummary> get trending {
    if (_trending is EqualUnmodifiableListView) return _trending;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_trending);
  }

  final List<SpeciesSummary> _seasonal;
  @override
  @JsonKey()
  List<SpeciesSummary> get seasonal {
    if (_seasonal is EqualUnmodifiableListView) return _seasonal;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_seasonal);
  }

  final List<SpeciesSummary> _featured;
  @override
  @JsonKey()
  List<SpeciesSummary> get featured {
    if (_featured is EqualUnmodifiableListView) return _featured;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_featured);
  }

  final List<ObservationSummary> _nearby;
  @override
  @JsonKey()
  List<ObservationSummary> get nearby {
    if (_nearby is EqualUnmodifiableListView) return _nearby;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nearby);
  }

  final List<ObservationSummary> _recent;
  @override
  @JsonKey()
  List<ObservationSummary> get recent {
    if (_recent is EqualUnmodifiableListView) return _recent;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recent);
  }

  @override
  @JsonKey()
  final bool fromCache;

  @override
  String toString() {
    return 'HomeFeed(trending: $trending, seasonal: $seasonal, featured: $featured, nearby: $nearby, recent: $recent, fromCache: $fromCache)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeFeedImpl &&
            const DeepCollectionEquality().equals(other._trending, _trending) &&
            const DeepCollectionEquality().equals(other._seasonal, _seasonal) &&
            const DeepCollectionEquality().equals(other._featured, _featured) &&
            const DeepCollectionEquality().equals(other._nearby, _nearby) &&
            const DeepCollectionEquality().equals(other._recent, _recent) &&
            (identical(other.fromCache, fromCache) ||
                other.fromCache == fromCache));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_trending),
      const DeepCollectionEquality().hash(_seasonal),
      const DeepCollectionEquality().hash(_featured),
      const DeepCollectionEquality().hash(_nearby),
      const DeepCollectionEquality().hash(_recent),
      fromCache);

  /// Create a copy of HomeFeed
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeFeedImplCopyWith<_$HomeFeedImpl> get copyWith =>
      __$$HomeFeedImplCopyWithImpl<_$HomeFeedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            List<SpeciesSummary> trending,
            List<SpeciesSummary> seasonal,
            List<SpeciesSummary> featured,
            List<ObservationSummary> nearby,
            List<ObservationSummary> recent,
            bool fromCache)
        $default,
  ) {
    return $default(trending, seasonal, featured, nearby, recent, fromCache);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            List<SpeciesSummary> trending,
            List<SpeciesSummary> seasonal,
            List<SpeciesSummary> featured,
            List<ObservationSummary> nearby,
            List<ObservationSummary> recent,
            bool fromCache)?
        $default,
  ) {
    return $default?.call(
        trending, seasonal, featured, nearby, recent, fromCache);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            List<SpeciesSummary> trending,
            List<SpeciesSummary> seasonal,
            List<SpeciesSummary> featured,
            List<ObservationSummary> nearby,
            List<ObservationSummary> recent,
            bool fromCache)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(trending, seasonal, featured, nearby, recent, fromCache);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_HomeFeed value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_HomeFeed value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_HomeFeed value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _HomeFeed extends HomeFeed {
  const factory _HomeFeed(
      {final List<SpeciesSummary> trending,
      final List<SpeciesSummary> seasonal,
      final List<SpeciesSummary> featured,
      final List<ObservationSummary> nearby,
      final List<ObservationSummary> recent,
      final bool fromCache}) = _$HomeFeedImpl;
  const _HomeFeed._() : super._();

  @override
  List<SpeciesSummary> get trending;
  @override
  List<SpeciesSummary> get seasonal;
  @override
  List<SpeciesSummary> get featured;
  @override
  List<ObservationSummary> get nearby;
  @override
  List<ObservationSummary> get recent;
  @override
  bool get fromCache;

  /// Create a copy of HomeFeed
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeFeedImplCopyWith<_$HomeFeedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
