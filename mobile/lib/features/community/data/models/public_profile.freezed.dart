// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'public_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PublicProfile _$PublicProfileFromJson(Map<String, dynamic> json) {
  return _PublicProfile.fromJson(json);
}

/// @nodoc
mixin _$PublicProfile {
  String get id => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String? get fullName => throw _privateConstructorUsedError;
  @JsonKey(name: 'profile_image_url')
  String? get profileImageUrl => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_verified')
  bool get isVerified => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String username,
            @JsonKey(name: 'full_name') String? fullName,
            @JsonKey(name: 'profile_image_url') String? profileImageUrl,
            String? bio,
            @JsonKey(name: 'is_verified') bool isVerified,
            @JsonKey(name: 'created_at') DateTime? createdAt)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String username,
            @JsonKey(name: 'full_name') String? fullName,
            @JsonKey(name: 'profile_image_url') String? profileImageUrl,
            String? bio,
            @JsonKey(name: 'is_verified') bool isVerified,
            @JsonKey(name: 'created_at') DateTime? createdAt)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String username,
            @JsonKey(name: 'full_name') String? fullName,
            @JsonKey(name: 'profile_image_url') String? profileImageUrl,
            String? bio,
            @JsonKey(name: 'is_verified') bool isVerified,
            @JsonKey(name: 'created_at') DateTime? createdAt)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PublicProfile value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PublicProfile value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PublicProfile value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this PublicProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PublicProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PublicProfileCopyWith<PublicProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PublicProfileCopyWith<$Res> {
  factory $PublicProfileCopyWith(
          PublicProfile value, $Res Function(PublicProfile) then) =
      _$PublicProfileCopyWithImpl<$Res, PublicProfile>;
  @useResult
  $Res call(
      {String id,
      String username,
      @JsonKey(name: 'full_name') String? fullName,
      @JsonKey(name: 'profile_image_url') String? profileImageUrl,
      String? bio,
      @JsonKey(name: 'is_verified') bool isVerified,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$PublicProfileCopyWithImpl<$Res, $Val extends PublicProfile>
    implements $PublicProfileCopyWith<$Res> {
  _$PublicProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PublicProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? fullName = freezed,
    Object? profileImageUrl = freezed,
    Object? bio = freezed,
    Object? isVerified = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PublicProfileImplCopyWith<$Res>
    implements $PublicProfileCopyWith<$Res> {
  factory _$$PublicProfileImplCopyWith(
          _$PublicProfileImpl value, $Res Function(_$PublicProfileImpl) then) =
      __$$PublicProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String username,
      @JsonKey(name: 'full_name') String? fullName,
      @JsonKey(name: 'profile_image_url') String? profileImageUrl,
      String? bio,
      @JsonKey(name: 'is_verified') bool isVerified,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$$PublicProfileImplCopyWithImpl<$Res>
    extends _$PublicProfileCopyWithImpl<$Res, _$PublicProfileImpl>
    implements _$$PublicProfileImplCopyWith<$Res> {
  __$$PublicProfileImplCopyWithImpl(
      _$PublicProfileImpl _value, $Res Function(_$PublicProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of PublicProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? fullName = freezed,
    Object? profileImageUrl = freezed,
    Object? bio = freezed,
    Object? isVerified = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$PublicProfileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PublicProfileImpl extends _PublicProfile {
  const _$PublicProfileImpl(
      {required this.id,
      required this.username,
      @JsonKey(name: 'full_name') this.fullName,
      @JsonKey(name: 'profile_image_url') this.profileImageUrl,
      this.bio,
      @JsonKey(name: 'is_verified') this.isVerified = false,
      @JsonKey(name: 'created_at') this.createdAt})
      : super._();

  factory _$PublicProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$PublicProfileImplFromJson(json);

  @override
  final String id;
  @override
  final String username;
  @override
  @JsonKey(name: 'full_name')
  final String? fullName;
  @override
  @JsonKey(name: 'profile_image_url')
  final String? profileImageUrl;
  @override
  final String? bio;
  @override
  @JsonKey(name: 'is_verified')
  final bool isVerified;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'PublicProfile(id: $id, username: $username, fullName: $fullName, profileImageUrl: $profileImageUrl, bio: $bio, isVerified: $isVerified, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PublicProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, username, fullName,
      profileImageUrl, bio, isVerified, createdAt);

  /// Create a copy of PublicProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PublicProfileImplCopyWith<_$PublicProfileImpl> get copyWith =>
      __$$PublicProfileImplCopyWithImpl<_$PublicProfileImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String username,
            @JsonKey(name: 'full_name') String? fullName,
            @JsonKey(name: 'profile_image_url') String? profileImageUrl,
            String? bio,
            @JsonKey(name: 'is_verified') bool isVerified,
            @JsonKey(name: 'created_at') DateTime? createdAt)
        $default,
  ) {
    return $default(
        id, username, fullName, profileImageUrl, bio, isVerified, createdAt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String username,
            @JsonKey(name: 'full_name') String? fullName,
            @JsonKey(name: 'profile_image_url') String? profileImageUrl,
            String? bio,
            @JsonKey(name: 'is_verified') bool isVerified,
            @JsonKey(name: 'created_at') DateTime? createdAt)?
        $default,
  ) {
    return $default?.call(
        id, username, fullName, profileImageUrl, bio, isVerified, createdAt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String username,
            @JsonKey(name: 'full_name') String? fullName,
            @JsonKey(name: 'profile_image_url') String? profileImageUrl,
            String? bio,
            @JsonKey(name: 'is_verified') bool isVerified,
            @JsonKey(name: 'created_at') DateTime? createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(
          id, username, fullName, profileImageUrl, bio, isVerified, createdAt);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PublicProfile value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PublicProfile value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PublicProfile value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PublicProfileImplToJson(
      this,
    );
  }
}

abstract class _PublicProfile extends PublicProfile {
  const factory _PublicProfile(
          {required final String id,
          required final String username,
          @JsonKey(name: 'full_name') final String? fullName,
          @JsonKey(name: 'profile_image_url') final String? profileImageUrl,
          final String? bio,
          @JsonKey(name: 'is_verified') final bool isVerified,
          @JsonKey(name: 'created_at') final DateTime? createdAt}) =
      _$PublicProfileImpl;
  const _PublicProfile._() : super._();

  factory _PublicProfile.fromJson(Map<String, dynamic> json) =
      _$PublicProfileImpl.fromJson;

  @override
  String get id;
  @override
  String get username;
  @override
  @JsonKey(name: 'full_name')
  String? get fullName;
  @override
  @JsonKey(name: 'profile_image_url')
  String? get profileImageUrl;
  @override
  String? get bio;
  @override
  @JsonKey(name: 'is_verified')
  bool get isVerified;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of PublicProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PublicProfileImplCopyWith<_$PublicProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
