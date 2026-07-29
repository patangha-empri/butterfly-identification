import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../shared/widgets/explorer_badge.dart';

part 'gamification_models.freezed.dart';
part 'gamification_models.g.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// GAMIFICATION MODELS — explorer profile + achievements
/// Matches /gamification/me and /gamification/achievements.
/// ─────────────────────────────────────────────────────────────────────────────

@freezed
class GamificationProfile with _$GamificationProfile {
  const factory GamificationProfile({
    @Default(GamificationStats()) GamificationStats stats,
    @Default(StreakInfo()) StreakInfo streak,
    @JsonKey(name: 'achievements_earned') @Default(0) int achievementsEarned,
  }) = _GamificationProfile;

  const GamificationProfile._();

  factory GamificationProfile.fromJson(Map<String, dynamic> json) =>
      _$GamificationProfileFromJson(json);

  int get points => stats.totalPoints;

  /// Linear progression: every 100 points = one explorer level.
  int get level => (points ~/ 100) + 1;
  int get xpInLevel => points % 100;
  int get xpForLevel => 100;
}

@freezed
class GamificationStats with _$GamificationStats {
  const factory GamificationStats({
    @JsonKey(name: 'total_observations') @Default(0) int totalObservations,
    @JsonKey(name: 'total_identifications') @Default(0) int totalIdentifications,
    @JsonKey(name: 'total_species_observed') @Default(0) int totalSpeciesObserved,
    @JsonKey(name: 'total_states_explored') @Default(0) int totalStatesExplored,
    @JsonKey(name: 'total_points') @Default(0) int totalPoints,
  }) = _GamificationStats;

  factory GamificationStats.fromJson(Map<String, dynamic> json) =>
      _$GamificationStatsFromJson(json);
}

@freezed
class StreakInfo with _$StreakInfo {
  const factory StreakInfo({
    @JsonKey(name: 'current_streak') @Default(0) int currentStreak,
    @JsonKey(name: 'longest_streak') @Default(0) int longestStreak,
    @JsonKey(name: 'last_observation_date') String? lastObservationDate,
  }) = _StreakInfo;

  factory StreakInfo.fromJson(Map<String, dynamic> json) =>
      _$StreakInfoFromJson(json);
}

@freezed
class AchievementItem with _$AchievementItem {
  const factory AchievementItem({
    required int id,
    @Default('') String name,
    @Default('') String description,
    @JsonKey(name: 'badge_image_url') String? badgeImageUrl,
    @JsonKey(name: 'achievement_type') @Default('') String achievementType,
    @JsonKey(name: 'threshold_value') @Default(1) int thresholdValue,
    @Default(10) int points,
    @JsonKey(name: 'is_earned') @Default(false) bool isEarned,
    @JsonKey(name: 'earned_at') DateTime? earnedAt,
  }) = _AchievementItem;

  const AchievementItem._();

  factory AchievementItem.fromJson(Map<String, dynamic> json) =>
      _$AchievementItemFromJson(json);

  /// Icon derived from the achievement type.
  IconData get icon {
    final t = achievementType;
    if (t.startsWith('streak')) return Icons.local_fire_department;
    if (t.startsWith('species')) return Icons.flutter_dash;
    if (t.startsWith('state')) return Icons.public;
    if (t.startsWith('verified')) return Icons.verified;
    if (t.contains('contributor')) return Icons.workspace_premium;
    if (t.contains('first')) return Icons.photo_camera;
    return Icons.emoji_events;
  }

  /// Tier escalates with the achievement's point value.
  BadgeTier get tier {
    if (points >= 100) return BadgeTier.legendary;
    if (points >= 50) return BadgeTier.gold;
    if (points >= 25) return BadgeTier.silver;
    return BadgeTier.bronze;
  }
}
