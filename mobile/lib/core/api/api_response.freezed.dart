// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ApiResponse<T> _$ApiResponseFromJson<T>(
    Map<String, dynamic> json, T Function(Object?) fromJsonT) {
  return _ApiResponse<T>.fromJson(json, fromJsonT);
}

/// @nodoc
mixin _$ApiResponse<T> {
  bool get success => throw _privateConstructorUsedError;
  T? get data => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  ApiMeta? get meta => throw _privateConstructorUsedError;
  Map<String, dynamic>? get errors => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(bool success, T? data, String? message, ApiMeta? meta,
            Map<String, dynamic>? errors)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(bool success, T? data, String? message, ApiMeta? meta,
            Map<String, dynamic>? errors)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(bool success, T? data, String? message, ApiMeta? meta,
            Map<String, dynamic>? errors)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ApiResponse<T> value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ApiResponse<T> value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ApiResponse<T> value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this ApiResponse to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) =>
      throw _privateConstructorUsedError;

  /// Create a copy of ApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiResponseCopyWith<T, ApiResponse<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiResponseCopyWith<T, $Res> {
  factory $ApiResponseCopyWith(
          ApiResponse<T> value, $Res Function(ApiResponse<T>) then) =
      _$ApiResponseCopyWithImpl<T, $Res, ApiResponse<T>>;
  @useResult
  $Res call(
      {bool success,
      T? data,
      String? message,
      ApiMeta? meta,
      Map<String, dynamic>? errors});

  $ApiMetaCopyWith<$Res>? get meta;
}

/// @nodoc
class _$ApiResponseCopyWithImpl<T, $Res, $Val extends ApiResponse<T>>
    implements $ApiResponseCopyWith<T, $Res> {
  _$ApiResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = freezed,
    Object? message = freezed,
    Object? meta = freezed,
    Object? errors = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      meta: freezed == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as ApiMeta?,
      errors: freezed == errors
          ? _value.errors
          : errors // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }

  /// Create a copy of ApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ApiMetaCopyWith<$Res>? get meta {
    if (_value.meta == null) {
      return null;
    }

    return $ApiMetaCopyWith<$Res>(_value.meta!, (value) {
      return _then(_value.copyWith(meta: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ApiResponseImplCopyWith<T, $Res>
    implements $ApiResponseCopyWith<T, $Res> {
  factory _$$ApiResponseImplCopyWith(_$ApiResponseImpl<T> value,
          $Res Function(_$ApiResponseImpl<T>) then) =
      __$$ApiResponseImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      T? data,
      String? message,
      ApiMeta? meta,
      Map<String, dynamic>? errors});

  @override
  $ApiMetaCopyWith<$Res>? get meta;
}

/// @nodoc
class __$$ApiResponseImplCopyWithImpl<T, $Res>
    extends _$ApiResponseCopyWithImpl<T, $Res, _$ApiResponseImpl<T>>
    implements _$$ApiResponseImplCopyWith<T, $Res> {
  __$$ApiResponseImplCopyWithImpl(
      _$ApiResponseImpl<T> _value, $Res Function(_$ApiResponseImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of ApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = freezed,
    Object? message = freezed,
    Object? meta = freezed,
    Object? errors = freezed,
  }) {
    return _then(_$ApiResponseImpl<T>(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      meta: freezed == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as ApiMeta?,
      errors: freezed == errors
          ? _value._errors
          : errors // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)
class _$ApiResponseImpl<T> implements _ApiResponse<T> {
  const _$ApiResponseImpl(
      {required this.success,
      this.data,
      this.message,
      this.meta,
      final Map<String, dynamic>? errors})
      : _errors = errors;

  factory _$ApiResponseImpl.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$$ApiResponseImplFromJson(json, fromJsonT);

  @override
  final bool success;
  @override
  final T? data;
  @override
  final String? message;
  @override
  final ApiMeta? meta;
  final Map<String, dynamic>? _errors;
  @override
  Map<String, dynamic>? get errors {
    final value = _errors;
    if (value == null) return null;
    if (_errors is EqualUnmodifiableMapView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ApiResponse<$T>(success: $success, data: $data, message: $message, meta: $meta, errors: $errors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiResponseImpl<T> &&
            (identical(other.success, success) || other.success == success) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.meta, meta) || other.meta == meta) &&
            const DeepCollectionEquality().equals(other._errors, _errors));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      success,
      const DeepCollectionEquality().hash(data),
      message,
      meta,
      const DeepCollectionEquality().hash(_errors));

  /// Create a copy of ApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiResponseImplCopyWith<T, _$ApiResponseImpl<T>> get copyWith =>
      __$$ApiResponseImplCopyWithImpl<T, _$ApiResponseImpl<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(bool success, T? data, String? message, ApiMeta? meta,
            Map<String, dynamic>? errors)
        $default,
  ) {
    return $default(success, data, message, meta, errors);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(bool success, T? data, String? message, ApiMeta? meta,
            Map<String, dynamic>? errors)?
        $default,
  ) {
    return $default?.call(success, data, message, meta, errors);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(bool success, T? data, String? message, ApiMeta? meta,
            Map<String, dynamic>? errors)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(success, data, message, meta, errors);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ApiResponse<T> value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ApiResponse<T> value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ApiResponse<T> value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return _$$ApiResponseImplToJson<T>(this, toJsonT);
  }
}

abstract class _ApiResponse<T> implements ApiResponse<T> {
  const factory _ApiResponse(
      {required final bool success,
      final T? data,
      final String? message,
      final ApiMeta? meta,
      final Map<String, dynamic>? errors}) = _$ApiResponseImpl<T>;

  factory _ApiResponse.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =
      _$ApiResponseImpl<T>.fromJson;

  @override
  bool get success;
  @override
  T? get data;
  @override
  String? get message;
  @override
  ApiMeta? get meta;
  @override
  Map<String, dynamic>? get errors;

  /// Create a copy of ApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiResponseImplCopyWith<T, _$ApiResponseImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

ApiMeta _$ApiMetaFromJson(Map<String, dynamic> json) {
  return _ApiMeta.fromJson(json);
}

/// @nodoc
mixin _$ApiMeta {
  int? get total => throw _privateConstructorUsedError;
  int? get page => throw _privateConstructorUsedError;
  int? get perPage => throw _privateConstructorUsedError;
  int? get totalPages => throw _privateConstructorUsedError;
  bool? get hasMore => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            int? total, int? page, int? perPage, int? totalPages, bool? hasMore)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(int? total, int? page, int? perPage, int? totalPages,
            bool? hasMore)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int? total, int? page, int? perPage, int? totalPages,
            bool? hasMore)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ApiMeta value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ApiMeta value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ApiMeta value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this ApiMeta to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiMetaCopyWith<ApiMeta> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiMetaCopyWith<$Res> {
  factory $ApiMetaCopyWith(ApiMeta value, $Res Function(ApiMeta) then) =
      _$ApiMetaCopyWithImpl<$Res, ApiMeta>;
  @useResult
  $Res call(
      {int? total, int? page, int? perPage, int? totalPages, bool? hasMore});
}

/// @nodoc
class _$ApiMetaCopyWithImpl<$Res, $Val extends ApiMeta>
    implements $ApiMetaCopyWith<$Res> {
  _$ApiMetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = freezed,
    Object? page = freezed,
    Object? perPage = freezed,
    Object? totalPages = freezed,
    Object? hasMore = freezed,
  }) {
    return _then(_value.copyWith(
      total: freezed == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int?,
      page: freezed == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int?,
      perPage: freezed == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int?,
      totalPages: freezed == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int?,
      hasMore: freezed == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiMetaImplCopyWith<$Res> implements $ApiMetaCopyWith<$Res> {
  factory _$$ApiMetaImplCopyWith(
          _$ApiMetaImpl value, $Res Function(_$ApiMetaImpl) then) =
      __$$ApiMetaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? total, int? page, int? perPage, int? totalPages, bool? hasMore});
}

/// @nodoc
class __$$ApiMetaImplCopyWithImpl<$Res>
    extends _$ApiMetaCopyWithImpl<$Res, _$ApiMetaImpl>
    implements _$$ApiMetaImplCopyWith<$Res> {
  __$$ApiMetaImplCopyWithImpl(
      _$ApiMetaImpl _value, $Res Function(_$ApiMetaImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApiMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = freezed,
    Object? page = freezed,
    Object? perPage = freezed,
    Object? totalPages = freezed,
    Object? hasMore = freezed,
  }) {
    return _then(_$ApiMetaImpl(
      total: freezed == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int?,
      page: freezed == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int?,
      perPage: freezed == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int?,
      totalPages: freezed == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int?,
      hasMore: freezed == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiMetaImpl implements _ApiMeta {
  const _$ApiMetaImpl(
      {this.total, this.page, this.perPage, this.totalPages, this.hasMore});

  factory _$ApiMetaImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiMetaImplFromJson(json);

  @override
  final int? total;
  @override
  final int? page;
  @override
  final int? perPage;
  @override
  final int? totalPages;
  @override
  final bool? hasMore;

  @override
  String toString() {
    return 'ApiMeta(total: $total, page: $page, perPage: $perPage, totalPages: $totalPages, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiMetaImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.perPage, perPage) || other.perPage == perPage) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, total, page, perPage, totalPages, hasMore);

  /// Create a copy of ApiMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiMetaImplCopyWith<_$ApiMetaImpl> get copyWith =>
      __$$ApiMetaImplCopyWithImpl<_$ApiMetaImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            int? total, int? page, int? perPage, int? totalPages, bool? hasMore)
        $default,
  ) {
    return $default(total, page, perPage, totalPages, hasMore);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(int? total, int? page, int? perPage, int? totalPages,
            bool? hasMore)?
        $default,
  ) {
    return $default?.call(total, page, perPage, totalPages, hasMore);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int? total, int? page, int? perPage, int? totalPages,
            bool? hasMore)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(total, page, perPage, totalPages, hasMore);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ApiMeta value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ApiMeta value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ApiMeta value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiMetaImplToJson(
      this,
    );
  }
}

abstract class _ApiMeta implements ApiMeta {
  const factory _ApiMeta(
      {final int? total,
      final int? page,
      final int? perPage,
      final int? totalPages,
      final bool? hasMore}) = _$ApiMetaImpl;

  factory _ApiMeta.fromJson(Map<String, dynamic> json) = _$ApiMetaImpl.fromJson;

  @override
  int? get total;
  @override
  int? get page;
  @override
  int? get perPage;
  @override
  int? get totalPages;
  @override
  bool? get hasMore;

  /// Create a copy of ApiMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiMetaImplCopyWith<_$ApiMetaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PaginatedResponse<T> {
  List<T> get items => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get perPage => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(List<T> items, int total, int page, int perPage,
            int totalPages, bool hasMore)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(List<T> items, int total, int page, int perPage,
            int totalPages, bool hasMore)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(List<T> items, int total, int page, int perPage,
            int totalPages, bool hasMore)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PaginatedResponse<T> value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PaginatedResponse<T> value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PaginatedResponse<T> value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of PaginatedResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginatedResponseCopyWith<T, PaginatedResponse<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginatedResponseCopyWith<T, $Res> {
  factory $PaginatedResponseCopyWith(PaginatedResponse<T> value,
          $Res Function(PaginatedResponse<T>) then) =
      _$PaginatedResponseCopyWithImpl<T, $Res, PaginatedResponse<T>>;
  @useResult
  $Res call(
      {List<T> items,
      int total,
      int page,
      int perPage,
      int totalPages,
      bool hasMore});
}

/// @nodoc
class _$PaginatedResponseCopyWithImpl<T, $Res,
        $Val extends PaginatedResponse<T>>
    implements $PaginatedResponseCopyWith<T, $Res> {
  _$PaginatedResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginatedResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? total = null,
    Object? page = null,
    Object? perPage = null,
    Object? totalPages = null,
    Object? hasMore = null,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginatedResponseImplCopyWith<T, $Res>
    implements $PaginatedResponseCopyWith<T, $Res> {
  factory _$$PaginatedResponseImplCopyWith(_$PaginatedResponseImpl<T> value,
          $Res Function(_$PaginatedResponseImpl<T>) then) =
      __$$PaginatedResponseImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call(
      {List<T> items,
      int total,
      int page,
      int perPage,
      int totalPages,
      bool hasMore});
}

/// @nodoc
class __$$PaginatedResponseImplCopyWithImpl<T, $Res>
    extends _$PaginatedResponseCopyWithImpl<T, $Res, _$PaginatedResponseImpl<T>>
    implements _$$PaginatedResponseImplCopyWith<T, $Res> {
  __$$PaginatedResponseImplCopyWithImpl(_$PaginatedResponseImpl<T> _value,
      $Res Function(_$PaginatedResponseImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of PaginatedResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? total = null,
    Object? page = null,
    Object? perPage = null,
    Object? totalPages = null,
    Object? hasMore = null,
  }) {
    return _then(_$PaginatedResponseImpl<T>(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$PaginatedResponseImpl<T> implements _PaginatedResponse<T> {
  const _$PaginatedResponseImpl(
      {required final List<T> items,
      required this.total,
      required this.page,
      required this.perPage,
      required this.totalPages,
      required this.hasMore})
      : _items = items;

  final List<T> _items;
  @override
  List<T> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final int total;
  @override
  final int page;
  @override
  final int perPage;
  @override
  final int totalPages;
  @override
  final bool hasMore;

  @override
  String toString() {
    return 'PaginatedResponse<$T>(items: $items, total: $total, page: $page, perPage: $perPage, totalPages: $totalPages, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginatedResponseImpl<T> &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.perPage, perPage) || other.perPage == perPage) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      total,
      page,
      perPage,
      totalPages,
      hasMore);

  /// Create a copy of PaginatedResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginatedResponseImplCopyWith<T, _$PaginatedResponseImpl<T>>
      get copyWith =>
          __$$PaginatedResponseImplCopyWithImpl<T, _$PaginatedResponseImpl<T>>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(List<T> items, int total, int page, int perPage,
            int totalPages, bool hasMore)
        $default,
  ) {
    return $default(items, total, page, perPage, totalPages, hasMore);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(List<T> items, int total, int page, int perPage,
            int totalPages, bool hasMore)?
        $default,
  ) {
    return $default?.call(items, total, page, perPage, totalPages, hasMore);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(List<T> items, int total, int page, int perPage,
            int totalPages, bool hasMore)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(items, total, page, perPage, totalPages, hasMore);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PaginatedResponse<T> value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PaginatedResponse<T> value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PaginatedResponse<T> value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _PaginatedResponse<T> implements PaginatedResponse<T> {
  const factory _PaginatedResponse(
      {required final List<T> items,
      required final int total,
      required final int page,
      required final int perPage,
      required final int totalPages,
      required final bool hasMore}) = _$PaginatedResponseImpl<T>;

  @override
  List<T> get items;
  @override
  int get total;
  @override
  int get page;
  @override
  int get perPage;
  @override
  int get totalPages;
  @override
  bool get hasMore;

  /// Create a copy of PaginatedResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginatedResponseImplCopyWith<T, _$PaginatedResponseImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}
