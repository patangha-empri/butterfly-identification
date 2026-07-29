import 'package:dartz/dartz.dart';
import 'package:butterfly_india/core/errors/failure.dart';
import 'package:butterfly_india/features/gamification/data/gamification_models.dart';
import 'package:butterfly_india/features/gamification/data/gamification_repository.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// FAKE GAMIFICATION REPOSITORY
/// ─────────────────────────────────────────────────────────────────────────────

class FakeGamificationRepository implements IGamificationRepository {
  FakeGamificationRepository({this.fail = false});
  bool fail;

  @override
  Future<Either<Failure, GamificationProfile>> getProfile() async {
    if (fail) return const Left(ServerFailure(message: 'boom'));
    return const Right(GamificationProfile(
      stats: GamificationStats(
        totalObservations: 11,
        totalSpeciesObserved: 3,
        totalStatesExplored: 2,
        totalPoints: 250,
      ),
      streak: StreakInfo(currentStreak: 4, longestStreak: 9),
      achievementsEarned: 3,
    ));
  }

  @override
  Future<Either<Failure, List<AchievementItem>>> getAchievements() async {
    if (fail) return const Left(ServerFailure(message: 'boom'));
    return const Right([
      AchievementItem(
        id: 1,
        name: 'First Flutter',
        description: 'Log your first sighting',
        achievementType: 'first_observation',
        points: 10,
        isEarned: true,
      ),
      AchievementItem(
        id: 2,
        name: 'Streak 7',
        description: '7-day streak',
        achievementType: 'streak_7',
        points: 50,
        isEarned: false,
      ),
    ]);
  }
}
