import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../data/gamification_models.dart';
import '../data/gamification_repository.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// GAMIFICATION PROVIDERS
/// ─────────────────────────────────────────────────────────────────────────────

final gamificationRepositoryProvider = Provider<IGamificationRepository>(
  (ref) => GamificationRepository(dio: ref.read(dioProvider)),
  name: 'gamificationRepository',
);

final gamificationProfileProvider =
    FutureProvider.autoDispose<GamificationProfile>((ref) async {
  final result = await ref.read(gamificationRepositoryProvider).getProfile();
  return result.fold(
    (f) => throw GamificationException(f.message),
    (p) => p,
  );
}, name: 'gamificationProfile');

final achievementsProvider =
    FutureProvider.autoDispose<List<AchievementItem>>((ref) async {
  final result =
      await ref.read(gamificationRepositoryProvider).getAchievements();
  return result.fold(
    (f) => throw GamificationException(f.message),
    (list) => list,
  );
}, name: 'achievements');

class GamificationException implements Exception {
  GamificationException(this.message);
  final String message;
  @override
  String toString() => message;
}
