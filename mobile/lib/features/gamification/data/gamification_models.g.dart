// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gamification_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GamificationProfileImpl _$$GamificationProfileImplFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$GamificationProfileImpl',
      json,
      ($checkedConvert) {
        final val = _$GamificationProfileImpl(
          stats: $checkedConvert(
              'stats',
              (v) => v == null
                  ? const GamificationStats()
                  : GamificationStats.fromJson(v as Map<String, dynamic>)),
          streak: $checkedConvert(
              'streak',
              (v) => v == null
                  ? const StreakInfo()
                  : StreakInfo.fromJson(v as Map<String, dynamic>)),
          achievementsEarned: $checkedConvert(
              'achievements_earned', (v) => (v as num?)?.toInt() ?? 0),
        );
        return val;
      },
      fieldKeyMap: const {'achievementsEarned': 'achievements_earned'},
    );

Map<String, dynamic> _$$GamificationProfileImplToJson(
        _$GamificationProfileImpl instance) =>
    <String, dynamic>{
      'stats': instance.stats.toJson(),
      'streak': instance.streak.toJson(),
      'achievements_earned': instance.achievementsEarned,
    };

_$GamificationStatsImpl _$$GamificationStatsImplFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$GamificationStatsImpl',
      json,
      ($checkedConvert) {
        final val = _$GamificationStatsImpl(
          totalObservations: $checkedConvert(
              'total_observations', (v) => (v as num?)?.toInt() ?? 0),
          totalIdentifications: $checkedConvert(
              'total_identifications', (v) => (v as num?)?.toInt() ?? 0),
          totalSpeciesObserved: $checkedConvert(
              'total_species_observed', (v) => (v as num?)?.toInt() ?? 0),
          totalStatesExplored: $checkedConvert(
              'total_states_explored', (v) => (v as num?)?.toInt() ?? 0),
          totalPoints:
              $checkedConvert('total_points', (v) => (v as num?)?.toInt() ?? 0),
        );
        return val;
      },
      fieldKeyMap: const {
        'totalObservations': 'total_observations',
        'totalIdentifications': 'total_identifications',
        'totalSpeciesObserved': 'total_species_observed',
        'totalStatesExplored': 'total_states_explored',
        'totalPoints': 'total_points'
      },
    );

Map<String, dynamic> _$$GamificationStatsImplToJson(
        _$GamificationStatsImpl instance) =>
    <String, dynamic>{
      'total_observations': instance.totalObservations,
      'total_identifications': instance.totalIdentifications,
      'total_species_observed': instance.totalSpeciesObserved,
      'total_states_explored': instance.totalStatesExplored,
      'total_points': instance.totalPoints,
    };

_$StreakInfoImpl _$$StreakInfoImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$StreakInfoImpl',
      json,
      ($checkedConvert) {
        final val = _$StreakInfoImpl(
          currentStreak: $checkedConvert(
              'current_streak', (v) => (v as num?)?.toInt() ?? 0),
          longestStreak: $checkedConvert(
              'longest_streak', (v) => (v as num?)?.toInt() ?? 0),
          lastObservationDate:
              $checkedConvert('last_observation_date', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'currentStreak': 'current_streak',
        'longestStreak': 'longest_streak',
        'lastObservationDate': 'last_observation_date'
      },
    );

Map<String, dynamic> _$$StreakInfoImplToJson(_$StreakInfoImpl instance) =>
    <String, dynamic>{
      'current_streak': instance.currentStreak,
      'longest_streak': instance.longestStreak,
      if (instance.lastObservationDate case final value?)
        'last_observation_date': value,
    };

_$AchievementItemImpl _$$AchievementItemImplFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$AchievementItemImpl',
      json,
      ($checkedConvert) {
        final val = _$AchievementItemImpl(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          name: $checkedConvert('name', (v) => v as String? ?? ''),
          description:
              $checkedConvert('description', (v) => v as String? ?? ''),
          badgeImageUrl:
              $checkedConvert('badge_image_url', (v) => v as String?),
          achievementType:
              $checkedConvert('achievement_type', (v) => v as String? ?? ''),
          thresholdValue: $checkedConvert(
              'threshold_value', (v) => (v as num?)?.toInt() ?? 1),
          points: $checkedConvert('points', (v) => (v as num?)?.toInt() ?? 10),
          isEarned: $checkedConvert('is_earned', (v) => v as bool? ?? false),
          earnedAt: $checkedConvert('earned_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {
        'badgeImageUrl': 'badge_image_url',
        'achievementType': 'achievement_type',
        'thresholdValue': 'threshold_value',
        'isEarned': 'is_earned',
        'earnedAt': 'earned_at'
      },
    );

Map<String, dynamic> _$$AchievementItemImplToJson(
        _$AchievementItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      if (instance.badgeImageUrl case final value?) 'badge_image_url': value,
      'achievement_type': instance.achievementType,
      'threshold_value': instance.thresholdValue,
      'points': instance.points,
      'is_earned': instance.isEarned,
      if (instance.earnedAt?.toIso8601String() case final value?)
        'earned_at': value,
    };
