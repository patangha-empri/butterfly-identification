import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment.freezed.dart';
part 'comment.g.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// COMMENT + author projection — matches ObservationComment.to_dict().
/// ─────────────────────────────────────────────────────────────────────────────

@freezed
class Comment with _$Comment {
  const factory Comment({
    required String id,
    required String body,
    CommentAuthor? user,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
}

@freezed
class CommentAuthor with _$CommentAuthor {
  const factory CommentAuthor({
    required String id,
    String? username,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'profile_image_url') String? profileImageUrl,
  }) = _CommentAuthor;

  const CommentAuthor._();

  factory CommentAuthor.fromJson(Map<String, dynamic> json) =>
      _$CommentAuthorFromJson(json);

  String get displayName =>
      (fullName != null && fullName!.isNotEmpty) ? fullName! : (username ?? 'User');
}
