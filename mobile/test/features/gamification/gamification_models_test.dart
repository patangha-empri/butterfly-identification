import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/features/gamification/data/gamification_models.dart';
import 'package:butterfly_india/shared/widgets/explorer_badge.dart';

void main() {
  group('GamificationProfile.fromJson', () {
    test('parses stats + streak from backend shape', () {
      final p = GamificationProfile.fromJson({
        'achievements_earned': 2,
        'stats': {
          'total_observations': 11,
          'total_identifications': 4,
          'total_species_observed': 3,
          'total_states_explored': 2,
          'total_points': 250,
        },
        'streak': {
          'current_streak': 5,
          'longest_streak': 9,
          'last_observation_date': '2026-05-29',
        },
      });
      expect(p.stats.totalObservations, 11);
      expect(p.streak.currentStreak, 5);
      expect(p.achievementsEarned, 2);
    });

    test('derives level + xp from points (100/level)', () {
      const p = GamificationProfile(stats: GamificationStats(totalPoints: 250));
      expect(p.points, 250);
      expect(p.level, 3); // 250 ~/ 100 + 1
      expect(p.xpInLevel, 50); // 250 % 100
      expect(p.xpForLevel, 100);
    });

    test('defaults are zero / level 1', () {
      const p = GamificationProfile();
      expect(p.level, 1);
      expect(p.points, 0);
    });
  });

  group('AchievementItem', () {
    test('icon derived from type', () {
      expect(
        const AchievementItem(id: 1, achievementType: 'streak_7').icon,
        Icons.local_fire_department,
      );
      expect(
        const AchievementItem(id: 2, achievementType: 'species_50').icon,
        Icons.flutter_dash,
      );
      expect(
        const AchievementItem(id: 3, achievementType: 'state_explorer').icon,
        Icons.public,
      );
    });

    test('tier escalates with points', () {
      expect(const AchievementItem(id: 1, points: 10).tier, BadgeTier.bronze);
      expect(const AchievementItem(id: 2, points: 25).tier, BadgeTier.silver);
      expect(const AchievementItem(id: 3, points: 50).tier, BadgeTier.gold);
      expect(const AchievementItem(id: 4, points: 100).tier,
          BadgeTier.legendary);
    });

    test('fromJson maps earned status', () {
      final a = AchievementItem.fromJson({
        'id': 1,
        'name': 'First Flutter',
        'description': 'Log your first sighting',
        'achievement_type': 'first_observation',
        'threshold_value': 1,
        'points': 10,
        'is_earned': true,
        'earned_at': '2026-05-29T10:00:00Z',
      });
      expect(a.isEarned, isTrue);
      expect(a.earnedAt, isNotNull);
      expect(a.icon, Icons.photo_camera);
    });
  });
}
