// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get id => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String get fullName => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  @JsonKey(name: 'profile_image_url')
  String? get profileImageUrl => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: 'user')
  String? get role => throw _privateConstructorUsedError;
  @JsonKey(name: 'observation_count', defaultValue: 0)
  int? get observationCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'species_count', defaultValue: 0)
  int? get speciesCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_verified', defaultValue: false)
  bool? get isVerified => throw _privateConstructorUsedError;
  @JsonKey(name: 'active_warnings', defaultValue: 0)
  int? get activeWarnings => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String username,
            String email,
            @JsonKey(name: 'full_name') String fullName,
            String? bio,
            @JsonKey(name: 'profile_image_url') String? profileImageUrl,
            @JsonKey(defaultValue: 'user') String? role,
            @JsonKey(name: 'observation_count', defaultValue: 0)
            int? observationCount,
            @JsonKey(name: 'species_count', defaultValue: 0) int? speciesCount,
            @JsonKey(name: 'is_verified', defaultValue: false) bool? isVerified,
            @JsonKey(name: 'active_warnings', defaultValue: 0)
            int? activeWarnings,
            @JsonKey(name: 'created_at') String? createdAt)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String username,
            String email,
            @JsonKey(name: 'full_name') String fullName,
            String? bio,
            @JsonKey(name: 'profile_image_url') String? profileImageUrl,
            @JsonKey(defaultValue: 'user') String? role,
            @JsonKey(name: 'observation_count', defaultValue: 0)
            int? observationCount,
            @JsonKey(name: 'species_count', defaultValue: 0) int? speciesCount,
            @JsonKey(name: 'is_verified', defaultValue: false) bool? isVerified,
            @JsonKey(name: 'active_warnings', defaultValue: 0)
            int? activeWarnings,
            @JsonKey(name: 'created_at') String? createdAt)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String username,
            String email,
            @JsonKey(name: 'full_name') String fullName,
            String? bio,
            @JsonKey(name: 'profile_image_url') String? profileImageUrl,
            @JsonKey(defaultValue: 'user') String? role,
            @JsonKey(name: 'observation_count', defaultValue: 0)
            int? observationCount,
            @JsonKey(name: 'species_count', defaultValue: 0) int? speciesCount,
            @JsonKey(name: 'is_verified', defaultValue: false) bool? isVerified,
            @JsonKey(name: 'active_warnings', defaultValue: 0)
            int? activeWarnings,
            @JsonKey(name: 'created_at') String? createdAt)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UserModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UserModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UserModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {String id,
      String username,
      String email,
      @JsonKey(name: 'full_name') String fullName,
      String? bio,
      @JsonKey(name: 'profile_image_url') String? profileImageUrl,
      @JsonKey(defaultValue: 'user') String? role,
      @JsonKey(name: 'observation_count', defaultValue: 0)
      int? observationCount,
      @JsonKey(name: 'species_count', defaultValue: 0) int? speciesCount,
      @JsonKey(name: 'is_verified', defaultValue: false) bool? isVerified,
      @JsonKey(name: 'active_warnings', defaultValue: 0) int? activeWarnings,
      @JsonKey(name: 'created_at') String? createdAt});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? email = null,
    Object? fullName = null,
    Object? bio = freezed,
    Object? profileImageUrl = freezed,
    Object? role = freezed,
    Object? observationCount = freezed,
    Object? speciesCount = freezed,
    Object? isVerified = freezed,
    Object? activeWarnings = freezed,
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
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      observationCount: freezed == observationCount
          ? _value.observationCount
          : observationCount // ignore: cast_nullable_to_non_nullable
              as int?,
      speciesCount: freezed == speciesCount
          ? _value.speciesCount
          : speciesCount // ignore: cast_nullable_to_non_nullable
              as int?,
      isVerified: freezed == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      activeWarnings: freezed == activeWarnings
          ? _value.activeWarnings
          : activeWarnings // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String username,
      String email,
      @JsonKey(name: 'full_name') String fullName,
      String? bio,
      @JsonKey(name: 'profile_image_url') String? profileImageUrl,
      @JsonKey(defaultValue: 'user') String? role,
      @JsonKey(name: 'observation_count', defaultValue: 0)
      int? observationCount,
      @JsonKey(name: 'species_count', defaultValue: 0) int? speciesCount,
      @JsonKey(name: 'is_verified', defaultValue: false) bool? isVerified,
      @JsonKey(name: 'active_warnings', defaultValue: 0) int? activeWarnings,
      @JsonKey(name: 'created_at') String? createdAt});
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? email = null,
    Object? fullName = null,
    Object? bio = freezed,
    Object? profileImageUrl = freezed,
    Object? role = freezed,
    Object? observationCount = freezed,
    Object? speciesCount = freezed,
    Object? isVerified = freezed,
    Object? activeWarnings = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$UserModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      observationCount: freezed == observationCount
          ? _value.observationCount
          : observationCount // ignore: cast_nullable_to_non_nullable
              as int?,
      speciesCount: freezed == speciesCount
          ? _value.speciesCount
          : speciesCount // ignore: cast_nullable_to_non_nullable
              as int?,
      isVerified: freezed == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      activeWarnings: freezed == activeWarnings
          ? _value.activeWarnings
          : activeWarnings // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl extends _UserModel {
  const _$UserModelImpl(
      {required this.id,
      required this.username,
      required this.email,
      @JsonKey(name: 'full_name') required this.fullName,
      this.bio,
      @JsonKey(name: 'profile_image_url') this.profileImageUrl,
      @JsonKey(defaultValue: 'user') this.role,
      @JsonKey(name: 'observation_count', defaultValue: 0)
      this.observationCount,
      @JsonKey(name: 'species_count', defaultValue: 0) this.speciesCount,
      @JsonKey(name: 'is_verified', defaultValue: false) this.isVerified,
      @JsonKey(name: 'active_warnings', defaultValue: 0) this.activeWarnings,
      @JsonKey(name: 'created_at') this.createdAt})
      : super._();

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String id;
  @override
  final String username;
  @override
  final String email;
  @override
  @JsonKey(name: 'full_name')
  final String fullName;
  @override
  final String? bio;
  @override
  @JsonKey(name: 'profile_image_url')
  final String? profileImageUrl;
  @override
  @JsonKey(defaultValue: 'user')
  final String? role;
  @override
  @JsonKey(name: 'observation_count', defaultValue: 0)
  final int? observationCount;
  @override
  @JsonKey(name: 'species_count', defaultValue: 0)
  final int? speciesCount;
  @override
  @JsonKey(name: 'is_verified', defaultValue: false)
  final bool? isVerified;
  @override
  @JsonKey(name: 'active_warnings', defaultValue: 0)
  final int? activeWarnings;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, email: $email, fullName: $fullName, bio: $bio, profileImageUrl: $profileImageUrl, role: $role, observationCount: $observationCount, speciesCount: $speciesCount, isVerified: $isVerified, activeWarnings: $activeWarnings, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.observationCount, observationCount) ||
                other.observationCount == observationCount) &&
            (identical(other.speciesCount, speciesCount) ||
                other.speciesCount == speciesCount) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.activeWarnings, activeWarnings) ||
                other.activeWarnings == activeWarnings) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      username,
      email,
      fullName,
      bio,
      profileImageUrl,
      role,
      observationCount,
      speciesCount,
      isVerified,
      activeWarnings,
      createdAt);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String username,
            String email,
            @JsonKey(name: 'full_name') String fullName,
            String? bio,
            @JsonKey(name: 'profile_image_url') String? profileImageUrl,
            @JsonKey(defaultValue: 'user') String? role,
            @JsonKey(name: 'observation_count', defaultValue: 0)
            int? observationCount,
            @JsonKey(name: 'species_count', defaultValue: 0) int? speciesCount,
            @JsonKey(name: 'is_verified', defaultValue: false) bool? isVerified,
            @JsonKey(name: 'active_warnings', defaultValue: 0)
            int? activeWarnings,
            @JsonKey(name: 'created_at') String? createdAt)
        $default,
  ) {
    return $default(id, username, email, fullName, bio, profileImageUrl, role,
        observationCount, speciesCount, isVerified, activeWarnings, createdAt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String username,
            String email,
            @JsonKey(name: 'full_name') String fullName,
            String? bio,
            @JsonKey(name: 'profile_image_url') String? profileImageUrl,
            @JsonKey(defaultValue: 'user') String? role,
            @JsonKey(name: 'observation_count', defaultValue: 0)
            int? observationCount,
            @JsonKey(name: 'species_count', defaultValue: 0) int? speciesCount,
            @JsonKey(name: 'is_verified', defaultValue: false) bool? isVerified,
            @JsonKey(name: 'active_warnings', defaultValue: 0)
            int? activeWarnings,
            @JsonKey(name: 'created_at') String? createdAt)?
        $default,
  ) {
    return $default?.call(
        id,
        username,
        email,
        fullName,
        bio,
        profileImageUrl,
        role,
        observationCount,
        speciesCount,
        isVerified,
        activeWarnings,
        createdAt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String username,
            String email,
            @JsonKey(name: 'full_name') String fullName,
            String? bio,
            @JsonKey(name: 'profile_image_url') String? profileImageUrl,
            @JsonKey(defaultValue: 'user') String? role,
            @JsonKey(name: 'observation_count', defaultValue: 0)
            int? observationCount,
            @JsonKey(name: 'species_count', defaultValue: 0) int? speciesCount,
            @JsonKey(name: 'is_verified', defaultValue: false) bool? isVerified,
            @JsonKey(name: 'active_warnings', defaultValue: 0)
            int? activeWarnings,
            @JsonKey(name: 'created_at') String? createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(
          id,
          username,
          email,
          fullName,
          bio,
          profileImageUrl,
          role,
          observationCount,
          speciesCount,
          isVerified,
          activeWarnings,
          createdAt);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UserModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UserModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UserModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel extends UserModel {
  const factory _UserModel(
      {required final String id,
      required final String username,
      required final String email,
      @JsonKey(name: 'full_name') required final String fullName,
      final String? bio,
      @JsonKey(name: 'profile_image_url') final String? profileImageUrl,
      @JsonKey(defaultValue: 'user') final String? role,
      @JsonKey(name: 'observation_count', defaultValue: 0)
      final int? observationCount,
      @JsonKey(name: 'species_count', defaultValue: 0) final int? speciesCount,
      @JsonKey(name: 'is_verified', defaultValue: false) final bool? isVerified,
      @JsonKey(name: 'active_warnings', defaultValue: 0)
      final int? activeWarnings,
      @JsonKey(name: 'created_at') final String? createdAt}) = _$UserModelImpl;
  const _UserModel._() : super._();

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get id;
  @override
  String get username;
  @override
  String get email;
  @override
  @JsonKey(name: 'full_name')
  String get fullName;
  @override
  String? get bio;
  @override
  @JsonKey(name: 'profile_image_url')
  String? get profileImageUrl;
  @override
  @JsonKey(defaultValue: 'user')
  String? get role;
  @override
  @JsonKey(name: 'observation_count', defaultValue: 0)
  int? get observationCount;
  @override
  @JsonKey(name: 'species_count', defaultValue: 0)
  int? get speciesCount;
  @override
  @JsonKey(name: 'is_verified', defaultValue: false)
  bool? get isVerified;
  @override
  @JsonKey(name: 'active_warnings', defaultValue: 0)
  int? get activeWarnings;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AuthTokensModel _$AuthTokensModelFromJson(Map<String, dynamic> json) {
  return _AuthTokensModel.fromJson(json);
}

/// @nodoc
mixin _$AuthTokensModel {
  @JsonKey(name: 'access_token')
  String get accessToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'refresh_token')
  String get refreshToken => throw _privateConstructorUsedError;
  UserModel get user => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(@JsonKey(name: 'access_token') String accessToken,
            @JsonKey(name: 'refresh_token') String refreshToken, UserModel user)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            @JsonKey(name: 'access_token') String accessToken,
            @JsonKey(name: 'refresh_token') String refreshToken,
            UserModel user)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'access_token') String accessToken,
            @JsonKey(name: 'refresh_token') String refreshToken,
            UserModel user)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AuthTokensModel value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AuthTokensModel value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AuthTokensModel value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this AuthTokensModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthTokensModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthTokensModelCopyWith<AuthTokensModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthTokensModelCopyWith<$Res> {
  factory $AuthTokensModelCopyWith(
          AuthTokensModel value, $Res Function(AuthTokensModel) then) =
      _$AuthTokensModelCopyWithImpl<$Res, AuthTokensModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'access_token') String accessToken,
      @JsonKey(name: 'refresh_token') String refreshToken,
      UserModel user});

  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class _$AuthTokensModelCopyWithImpl<$Res, $Val extends AuthTokensModel>
    implements $AuthTokensModelCopyWith<$Res> {
  _$AuthTokensModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthTokensModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? user = null,
  }) {
    return _then(_value.copyWith(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel,
    ) as $Val);
  }

  /// Create a copy of AuthTokensModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get user {
    return $UserModelCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthTokensModelImplCopyWith<$Res>
    implements $AuthTokensModelCopyWith<$Res> {
  factory _$$AuthTokensModelImplCopyWith(_$AuthTokensModelImpl value,
          $Res Function(_$AuthTokensModelImpl) then) =
      __$$AuthTokensModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'access_token') String accessToken,
      @JsonKey(name: 'refresh_token') String refreshToken,
      UserModel user});

  @override
  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class __$$AuthTokensModelImplCopyWithImpl<$Res>
    extends _$AuthTokensModelCopyWithImpl<$Res, _$AuthTokensModelImpl>
    implements _$$AuthTokensModelImplCopyWith<$Res> {
  __$$AuthTokensModelImplCopyWithImpl(
      _$AuthTokensModelImpl _value, $Res Function(_$AuthTokensModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthTokensModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? user = null,
  }) {
    return _then(_$AuthTokensModelImpl(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthTokensModelImpl implements _AuthTokensModel {
  const _$AuthTokensModelImpl(
      {@JsonKey(name: 'access_token') required this.accessToken,
      @JsonKey(name: 'refresh_token') required this.refreshToken,
      required this.user});

  factory _$AuthTokensModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthTokensModelImplFromJson(json);

  @override
  @JsonKey(name: 'access_token')
  final String accessToken;
  @override
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @override
  final UserModel user;

  @override
  String toString() {
    return 'AuthTokensModel(accessToken: $accessToken, refreshToken: $refreshToken, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthTokensModelImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, accessToken, refreshToken, user);

  /// Create a copy of AuthTokensModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthTokensModelImplCopyWith<_$AuthTokensModelImpl> get copyWith =>
      __$$AuthTokensModelImplCopyWithImpl<_$AuthTokensModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(@JsonKey(name: 'access_token') String accessToken,
            @JsonKey(name: 'refresh_token') String refreshToken, UserModel user)
        $default,
  ) {
    return $default(accessToken, refreshToken, user);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            @JsonKey(name: 'access_token') String accessToken,
            @JsonKey(name: 'refresh_token') String refreshToken,
            UserModel user)?
        $default,
  ) {
    return $default?.call(accessToken, refreshToken, user);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'access_token') String accessToken,
            @JsonKey(name: 'refresh_token') String refreshToken,
            UserModel user)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(accessToken, refreshToken, user);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AuthTokensModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AuthTokensModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AuthTokensModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthTokensModelImplToJson(
      this,
    );
  }
}

abstract class _AuthTokensModel implements AuthTokensModel {
  const factory _AuthTokensModel(
      {@JsonKey(name: 'access_token') required final String accessToken,
      @JsonKey(name: 'refresh_token') required final String refreshToken,
      required final UserModel user}) = _$AuthTokensModelImpl;

  factory _AuthTokensModel.fromJson(Map<String, dynamic> json) =
      _$AuthTokensModelImpl.fromJson;

  @override
  @JsonKey(name: 'access_token')
  String get accessToken;
  @override
  @JsonKey(name: 'refresh_token')
  String get refreshToken;
  @override
  UserModel get user;

  /// Create a copy of AuthTokensModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthTokensModelImplCopyWith<_$AuthTokensModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
