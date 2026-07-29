import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../../../core/utils/relative_time.dart';
import '../../../../shared/widgets/app_avatar.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../gamification/presentation/gamification_providers.dart';
import '../providers/profile_providers.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// MY PROFILE SCREEN (Profile tab)
/// Header + stats strip + quick links. Replaces the Phase 3 placeholder.
/// ─────────────────────────────────────────────────────────────────────────────

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Trigger a refresh of the cached user from the server.
    ref.watch(myProfileProvider);
    final user = ref.watch(currentUserProvider);
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom + 80;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(myProfileProvider);
                ref.invalidate(gamificationProfileProvider);
                await ref.read(myProfileProvider.future);
              },
              child: ListView(
                padding: EdgeInsets.only(bottom: bottomInset),
                children: [
                  if (user.activeWarnings > 0)
                    _WarningBanner(count: user.activeWarnings),
                  _Header(
                    name: user.fullName,
                    username: user.username,
                    bio: user.bio,
                    avatarUrl: user.profileImageUrl,
                    isVerified: user.isVerified,
                    joined: user.createdAt,
                  ),
                  const _StatsStrip(),
                  const SizedBox(height: SpaceTokens.sm),
                  const Divider(height: 1),
                  _Links(),
                ],
              ),
            ),
    );
  }
}

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
          SpaceTokens.base, SpaceTokens.sm, SpaceTokens.base, 0),
      padding: const EdgeInsets.all(SpaceTokens.md),
      decoration: BoxDecoration(
        color: ColorTokens.warning.withValues(alpha: 0.12),
        borderRadius: RadiusTokens.cardBR,
        border: Border.all(color: ColorTokens.warning.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: ColorTokens.warning, size: 20),
          const SizedBox(width: SpaceTokens.sm),
          Expanded(
            child: Text(
              count == 1
                  ? 'Your account has an active warning from the moderation '
                      'team. Check your notifications for details.'
                  : 'Your account has $count active warnings from the '
                      'moderation team. Check your notifications for details.',
              style: TypographyTokens.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.name,
    required this.username,
    required this.bio,
    required this.avatarUrl,
    required this.isVerified,
    required this.joined,
  });

  final String name;
  final String username;
  final String? bio;
  final String? avatarUrl;
  final bool isVerified;
  final DateTime? joined;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        SpaceTokens.lg,
        SpaceTokens.xl,
        SpaceTokens.lg,
        SpaceTokens.lg,
      ),
      decoration: const BoxDecoration(gradient: ColorTokens.primaryGradient),
      child: Column(
        children: [
          AppAvatar(
            radius: 44,
            imageUrl: avatarUrl,
            name: name,
            backgroundColor: Colors.white.withValues(alpha: 0.25),
            foregroundColor: Colors.white,
          ),
          const SizedBox(height: SpaceTokens.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(name,
                    textAlign: TextAlign.center,
                    style: TypographyTokens.textTheme.headlineSmall
                        ?.copyWith(color: Colors.white)),
              ),
              if (isVerified) ...[
                const SizedBox(width: SpaceTokens.xs),
                const Icon(Icons.verified, size: 20, color: Colors.white),
              ],
            ],
          ),
          Text('@$username',
              style: TypographyTokens.textTheme.bodyMedium
                  ?.copyWith(color: Colors.white.withValues(alpha: 0.85))),
          if (bio != null && bio!.isNotEmpty) ...[
            const SizedBox(height: SpaceTokens.md),
            Text(bio!,
                textAlign: TextAlign.center,
                style: TypographyTokens.textTheme.bodyMedium
                    ?.copyWith(color: Colors.white.withValues(alpha: 0.95))),
          ],
          if (joined != null) ...[
            const SizedBox(height: SpaceTokens.sm),
            Text('Joined ${RelativeTime.format(joined)}',
                style: TypographyTokens.caption
                    .copyWith(color: Colors.white.withValues(alpha: 0.8))),
          ],
        ],
      ),
    );
  }
}

class _StatsStrip extends ConsumerWidget {
  const _StatsStrip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(gamificationProfileProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: SpaceTokens.lg, vertical: SpaceTokens.lg),
      child: async.when(
        loading: () => const SizedBox(
            height: 48, child: Center(child: CircularProgressIndicator())),
        error: (_, __) => const SizedBox.shrink(),
        data: (p) => Row(
          children: [
            _Stat(label: 'Sightings', value: '${p.stats.totalObservations}'),
            _Stat(label: 'Species', value: '${p.stats.totalSpeciesObserved}'),
            _Stat(label: 'States', value: '${p.stats.totalStatesExplored}'),
            _Stat(label: 'Streak', value: '${p.streak.currentStreak}'),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: TypographyTokens.textTheme.titleLarge),
          Text(label,
              style: TypographyTokens.caption.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              )),
        ],
      ),
    );
  }
}

class _Links extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _LinkTile(
          icon: Icons.edit_outlined,
          label: 'Edit profile',
          onTap: () => context.push(AppRoutes.editProfile),
        ),
        _LinkTile(
          icon: Icons.photo_camera_outlined,
          label: 'My sightings',
          onTap: () => context.push(AppRoutes.myObservations),
        ),
        _LinkTile(
          icon: Icons.emoji_events_outlined,
          label: 'Achievements',
          onTap: () => context.push(AppRoutes.achievements),
        ),
        _LinkTile(
          icon: Icons.bookmark_outline,
          label: 'Saved species',
          onTap: () => context.push(AppRoutes.savedSpecies),
        ),
        _LinkTile(
          icon: Icons.settings_outlined,
          label: 'Settings',
          onTap: () => context.push(AppRoutes.settings),
        ),
        const Divider(height: 1),
        _LinkTile(
          icon: Icons.logout,
          label: 'Log out',
          destructive: true,
          onTap: () => _confirmLogout(context, ref),
        ),
      ],
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You can sign back in any time.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Log out')),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(authNotifierProvider.notifier).logout();
    }
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive
        ? ColorTokens.error
        : Theme.of(context).colorScheme.onSurface;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label,
          style: TypographyTokens.textTheme.bodyLarge?.copyWith(color: color)),
      trailing: destructive
          ? null
          : Icon(Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurfaceVariant),
      onTap: onTap,
    );
  }
}
