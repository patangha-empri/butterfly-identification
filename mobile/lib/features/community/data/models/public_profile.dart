import 'package:freezed_annotation/freezed_annotation.dart';

part 'public_profile.freezed.dart';
part 'public_profile.g.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// PUBLIC PROFILE — matches User.to_dict(include_private=False).
/// ─────────────────────────────────────────────────────────────────────────────

@freezed
class PublicProfile with _$PublicProfile {
  const factory PublicProfile({
    required String id,
    required String username,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'profile_image_url') String? profileImageUrl,
    String? bio,
    @JsonKey(name: 'is_verified') @Default(false) bool isVerified,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _PublicProfile;

  const PublicProfile._();

  factory PublicProfile.fromJson(Map<String, dynamic> json) =>
      _$PublicProfileFromJson(json);

  String get displayName =>
      (fullName != null && fullName!.isNotEmpty) ? fullName! : username;
}
