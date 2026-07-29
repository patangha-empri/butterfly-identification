import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// USER MODEL (data layer — Freezed + json_serializable)
/// Matches the Flask API /auth/me response shape.
/// ─────────────────────────────────────────────────────────────────────────────

@freezed
class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String id,
    required String username,
    required String email,
    @JsonKey(name: 'full_name') required String fullName,
    String? bio,
    @JsonKey(name: 'profile_image_url') String? profileImageUrl,
    @JsonKey(defaultValue: 'user') String? role,
    @JsonKey(name: 'observation_count', defaultValue: 0) int? observationCount,
    @JsonKey(name: 'species_count', defaultValue: 0) int? speciesCount,
    @JsonKey(name: 'is_verified', defaultValue: false) bool? isVerified,
    @JsonKey(name: 'active_warnings', defaultValue: 0) int? activeWarnings,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  UserEntity toEntity() => UserEntity(
    id: id,
    username: username,
    email: email,
    fullName: fullName,
    bio: bio,
    profileImageUrl: profileImageUrl,
    role: UserRole.fromString(role ?? 'user'),
    observationCount: observationCount ?? 0,
    speciesCount: speciesCount ?? 0,
    isVerified: isVerified ?? false,
    activeWarnings: activeWarnings ?? 0,
    createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
  );
}

@freezed
class AuthTokensModel with _$AuthTokensModel {
  const factory AuthTokensModel({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    required UserModel user,
  }) = _AuthTokensModel;

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensModelFromJson(json);
}
