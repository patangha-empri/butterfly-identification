import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/theme/theme_mode_provider.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_providers.dart';
import '../widgets/change_password_sheet.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// SETTINGS SCREEN (/settings)
/// Account, notifications, appearance, about.
/// ─────────────────────────────────────────────────────────────────────────────

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionLabel('Account'),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Change password'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showChangePasswordSheet(context),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log out'),
            onTap: () => _confirmLogout(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever_outlined,
                color: ColorTokens.error),
            title: const Text('Delete account',
                style: TextStyle(color: ColorTokens.error)),
            onTap: () => _confirmDeleteAccount(context, ref),
          ),

          const Divider(height: 1),
          const _SectionLabel('Notifications'),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notification preferences'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.notificationPreferences),
          ),

          const Divider(height: 1),
          const _SectionLabel('Appearance'),
          _ThemeTile(
            current: themeMode,
            onChanged: (m) => ref.read(themeModeProvider.notifier).set(m),
          ),

          const Divider(height: 1),
          const _SectionLabel('Legal'),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.privacyPolicy),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Terms & conditions'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.terms),
          ),
          ListTile(
            leading: const Icon(Icons.groups_outlined),
            title: const Text('Community guidelines'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.communityGuidelines),
          ),

          const Divider(height: 1),
          const _SectionLabel('About'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Version'),
            trailing: Text('1.0.0'),
          ),
          const SizedBox(height: SpaceTokens.xl),
        ],
      ),
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

  Future<void> _confirmDeleteAccount(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete account?'),
        content: const Text(
          'Your account will be deactivated and your sightings removed from '
          'public view. You will be signed out and won\'t be able to log back '
          'in. This cannot be undone from the app.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: ColorTokens.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final result = await ref.read(profileRepositoryProvider).deleteAccount();
    if (!context.mounted) return;
    await result.fold(
      (f) async {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not delete account: ${f.message}')),
        );
      },
      (_) async {
        await ref.read(authNotifierProvider.notifier).logout();
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(
            SpaceTokens.lg, SpaceTokens.lg, SpaceTokens.lg, SpaceTokens.xs),
        child: Text(
          label.toUpperCase(),
          style: TypographyTokens.rarityLabel.copyWith(
            color: ColorTokens.brandPrimary,
            letterSpacing: 1.2,
          ),
        ),
      );
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile({required this.current, required this.onChanged});
  final ThemeMode current;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: SpaceTokens.lg, vertical: SpaceTokens.sm),
      child: Row(
        children: [
          const Icon(Icons.brightness_6_outlined),
          const SizedBox(width: SpaceTokens.base),
          const Expanded(child: Text('Theme')),
          SegmentedButton<ThemeMode>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(
                  value: ThemeMode.light, icon: Icon(Icons.light_mode)),
              ButtonSegment(
                  value: ThemeMode.dark, icon: Icon(Icons.dark_mode)),
              ButtonSegment(
                  value: ThemeMode.system, icon: Icon(Icons.brightness_auto)),
            ],
            selected: {current},
            onSelectionChanged: (s) => onChanged(s.first),
          ),
        ],
      ),
    );
  }
}
