import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/theme/color_tokens.dart';

part 'app_notification.freezed.dart';
part 'app_notification.g.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// APP NOTIFICATION
/// Matches Notification.to_dict() from the backend.
/// ─────────────────────────────────────────────────────────────────────────────

@freezed
class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    @Default('system') String type,
    @Default('') String title,
    @Default('') String body,
    Map<String, dynamic>? data,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _AppNotification;

  const AppNotification._();

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);

  NotificationKind get kind => NotificationKind.fromNotification(this);

  /// Deep-link target id pulled from the payload, if present.
  String? get speciesId => data?['species_id'] as String?;
  String? get observationId => data?['observation_id'] as String?;
}

/// Visual + routing classification derived from the backend `type` string & payload.
enum NotificationKind {
  identification(Icons.auto_awesome, ColorTokens.brandSecondary),
  social(Icons.favorite, ColorTokens.error),
  achievement(Icons.emoji_events, ColorTokens.goldBadge),
  nearby(Icons.place, ColorTokens.brandPrimary),
  moderation(Icons.shield_outlined, ColorTokens.warning),
  warning(Icons.warning_amber_rounded, ColorTokens.error),
  update(Icons.system_update_alt_rounded, ColorTokens.info),
  information(Icons.info_outline_rounded, ColorTokens.brandSecondary),
  account(Icons.manage_accounts_rounded, ColorTokens.goldBadge),
  system(Icons.notifications, ColorTokens.rarityCommon);

  const NotificationKind(this.icon, this.color);
  final IconData icon;
  final Color color;

  static NotificationKind fromType(String type) {
    final t = type.toLowerCase();
    if (t.contains('warning')) return NotificationKind.warning;
    if (t.contains('update')) return NotificationKind.update;
    if (t.contains('info') || t == 'educational_alert') return NotificationKind.information;
    if (t.contains('account') || t == 'admin_action') return NotificationKind.account;
    if (t.startsWith('admin')) return NotificationKind.moderation;
    if (t.contains('identif')) return NotificationKind.identification;
    if (t.contains('like') || t.contains('comment') || t.contains('follow')) {
      return NotificationKind.social;
    }
    if (t.contains('achiev') ||
        t.contains('badge') ||
        t.contains('streak') ||
        t.contains('level')) {
      return NotificationKind.achievement;
    }
    if (t.contains('nearby') || t.contains('species') || t.contains('event')) {
      return NotificationKind.nearby;
    }
    return NotificationKind.system;
  }

  static NotificationKind fromNotification(AppNotification n) {
    final type = n.type.toLowerCase();
    final title = n.title.toLowerCase();
    final body = n.body.toLowerCase();
    final action = (n.data?['action'] as String?)?.toLowerCase() ?? '';

    // Check warning first
    if (type == 'warning' ||
        title.contains('warning') ||
        body.contains('warning') ||
        action == 'warning') {
      return NotificationKind.warning;
    }
    // Check update
    if (type == 'update' ||
        title.contains('update') ||
        body.contains('update')) {
      return NotificationKind.update;
    }
    // Check info
    if (type == 'info' ||
        title.contains('info') ||
        body.contains('info') ||
        type == 'educational_alert') {
      return NotificationKind.information;
    }
    // Check account-related
    if (type == 'account' ||
        title.contains('account') ||
        body.contains('account') ||
        action == 'flag') {
      return NotificationKind.account;
    }
    return fromType(n.type);
  }
}
