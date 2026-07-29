import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../../../shared/widgets/explorer_badge.dart';
import '../../../../shared/widgets/loaders/skeleton.dart';
import '../../../../shared/widgets/overlays/app_bottom_sheet.dart';
import '../../../../shared/widgets/states/empty_state.dart';
import '../../data/gamification_models.dart';
import '../gamification_providers.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// ACHIEVEMENTS / EXPLORER HUB SCREEN
/// ─────────────────────────────────────────────────────────────────────────────

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(gamificationProfileProvider);
    final achievementsAsync = ref.watch(achievementsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Explorer')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(gamificationProfileProvider);
          ref.invalidate(achievementsProvider);
          await ref.read(gamificationProfileProvider.future);
        },
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            SpaceTokens.base,
            SpaceTokens.base,
            SpaceTokens.base,
            SpaceTokens.base + MediaQuery.viewPaddingOf(context).bottom,
          ),
          children: [
            // ── Explorer header ──────────────────────────────────────────────
            profileAsync.when(
              loading: () => const Skeleton(
                  height: 180, borderRadius: RadiusTokens.card),
              error: (e, _) => AppEmptyState.error(
                message: e.toString(),
                onRetry: () => ref.invalidate(gamificationProfileProvider),
              ),
              data: (p) => _ExplorerHeader(profile: p),
            ),
            const SizedBox(height: SpaceTokens.xl),

            // ── Badges ───────────────────────────────────────────────────────
            Text('Badges', style: TypographyTokens.textTheme.titleLarge),
            const SizedBox(height: SpaceTokens.md),
            achievementsAsync.when(
              loading: () => const _BadgeGridSkeleton(),
              error: (e, _) => AppEmptyState.error(
                message: e.toString(),
                onRetry: () => ref.invalidate(achievementsProvider),
              ),
              data: (items) => _BadgeGrid(items: items),
            ),
            const SizedBox(height: SpaceTokens.xxl),
          ],
        ),
      ),
    );
  }
}

class _ExplorerHeader extends StatelessWidget {
  const _ExplorerHeader({required this.profile});
  final GamificationProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SpaceTokens.lg),
      decoration: BoxDecoration(
        gradient: ColorTokens.primaryGradient,
        borderRadius: RadiusTokens.cardBR,
        boxShadow: ShadowTokens.brand,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                alignment: Alignment.center,
                child: Text('${profile.level}',
                    style: TypographyTokens.statNumber
                        .copyWith(color: Colors.white)),
              ),
              const SizedBox(width: SpaceTokens.base),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Level ${profile.level} Explorer',
                        style: TypographyTokens.textTheme.titleMedium
                            ?.copyWith(color: Colors.white)),
                    Text('${profile.points} XP · ${profile.achievementsEarned} badges',
                        style: TypographyTokens.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.85))),
                  ],
                ),
              ),
              _StreakChip(streak: profile.streak.currentStreak),
            ],
          ),
          const SizedBox(height: SpaceTokens.lg),
          // XP progress within the level
          _WhiteXpBar(
            current: profile.xpInLevel,
            total: profile.xpForLevel,
            level: profile.level,
          ),
          const SizedBox(height: SpaceTokens.lg),
          Row(
            children: [
              _Stat('Sightings', '${profile.stats.totalObservations}'),
              _Stat('Species', '${profile.stats.totalSpeciesObserved}'),
              _Stat('States', '${profile.stats.totalStatesExplored}'),
              _Stat('Best streak', '${profile.streak.longestStreak}'),
            ],
          ),
        ],
      ),
    );
  }
}

class _WhiteXpBar extends StatelessWidget {
  const _WhiteXpBar(
      {required this.current, required this.total, required this.level});
  final int current;
  final int total;
  final int level;

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? (current / total).clamp(0.0, 1.0) : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.white.withValues(alpha: 0.25),
            valueColor: const AlwaysStoppedAnimation(Colors.white),
          ),
        ),
        const SizedBox(height: SpaceTokens.xs),
        Text('$current / $total XP to level ${level + 1}',
            style: TypographyTokens.caption
                .copyWith(color: Colors.white.withValues(alpha: 0.85))),
      ],
    );
  }
}

class _StreakChip extends StatelessWidget {
  const _StreakChip({required this.streak});
  final int streak;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: SpaceTokens.md, vertical: SpaceTokens.xs),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: RadiusTokens.pillBR,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department,
              color: ColorTokens.brandAccent, size: 18),
          const SizedBox(width: 4),
          Text('$streak',
              style: TypographyTokens.textTheme.titleSmall
                  ?.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: TypographyTokens.textTheme.titleLarge
                  ?.copyWith(color: Colors.white)),
          Text(label,
              textAlign: TextAlign.center,
              style: TypographyTokens.caption
                  .copyWith(color: Colors.white.withValues(alpha: 0.8))),
        ],
      ),
    );
  }
}

class _BadgeGridSkeleton extends StatelessWidget {
  const _BadgeGridSkeleton();

  @override
  Widget build(BuildContext context) {
    return SkeletonShimmer(
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: SpaceTokens.base,
        crossAxisSpacing: SpaceTokens.sm,
        childAspectRatio: 0.8,
        children: List.generate(
          6,
          (_) => const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Skeleton.circle(size: 64),
              SizedBox(height: SpaceTokens.sm),
              Skeleton(width: 60, height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _BadgeGrid extends StatelessWidget {
  const _BadgeGrid({required this.items});
  final List<AchievementItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const AppEmptyState(
        icon: Icons.emoji_events_outlined,
        title: 'No badges yet',
        message: 'Log sightings to start earning badges!',
      );
    }
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: SpaceTokens.base,
      crossAxisSpacing: SpaceTokens.sm,
      childAspectRatio: 0.8,
      children: items
          .map((a) => ExplorerBadge(
                icon: a.icon,
                label: a.name,
                tier: a.tier,
                isLocked: !a.isEarned,
                animateOnAppear: false,
                onTap: () => _showDetail(context, a),
              ))
          .toList(),
    );
  }

  void _showDetail(BuildContext context, AchievementItem a) {
    AppBottomSheet.show(
      context,
      title: a.name,
      scrollable: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ExplorerBadge(
            icon: a.icon,
            label: '',
            tier: a.tier,
            isLocked: !a.isEarned,
            animateOnAppear: false,
            size: 72,
          ),
          const SizedBox(height: SpaceTokens.md),
          Text(a.description, style: TypographyTokens.textTheme.bodyLarge),
          const SizedBox(height: SpaceTokens.sm),
          Row(
            children: [
              Icon(a.isEarned ? Icons.check_circle : Icons.lock_outline,
                  size: 16,
                  color: a.isEarned ? ColorTokens.success : ColorTokens.rarityCommon),
              const SizedBox(width: SpaceTokens.xs),
              Text(
                a.isEarned ? 'Earned · +${a.points} XP' : '+${a.points} XP when earned',
                style: TypographyTokens.textTheme.labelMedium?.copyWith(
                  color: a.isEarned
                      ? ColorTokens.success
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
