import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_preferences.freezed.dart';
part 'notification_preferences.g.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// NOTIFICATION PREFERENCES
/// Matches NotificationPreference.to_dict() (all booleans).
/// ─────────────────────────────────────────────────────────────────────────────

@freezed
class NotificationPreferences with _$NotificationPreferences {
  const factory NotificationPreferences({
    @JsonKey(name: 'identification_complete')
    @Default(true)
    bool identificationComplete,
    @JsonKey(name: 'new_species_nearby') @Default(true) bool newSpeciesNearby,
    @JsonKey(name: 'admin_verification') @Default(true) bool adminVerification,
    @JsonKey(name: 'educational_alerts') @Default(true) bool educationalAlerts,
    @Default(true) bool events,
  }) = _NotificationPreferences;

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesFromJson(json);
}
