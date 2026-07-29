import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../../../core/utils/a11y.dart';
import '../../../../shared/widgets/states/empty_state.dart';
import '../../data/models/notification_preferences.dart';
import '../notification_providers.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// NOTIFICATION PREFERENCES SCREEN
/// ─────────────────────────────────────────────────────────────────────────────

class NotificationPreferencesScreen extends ConsumerWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(notificationPreferencesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notification settings')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppEmptyState.error(
          message: e.toString(),
          onRetry: () => ref.invalidate(notificationPreferencesProvider),
        ),
        data: (prefs) => _PreferencesForm(initial: prefs),
      ),
    );
  }
}

class _PreferencesForm extends ConsumerStatefulWidget {
  const _PreferencesForm({required this.initial});
  final NotificationPreferences initial;

  @override
  ConsumerState<_PreferencesForm> createState() => _PreferencesFormState();
}

class _PreferencesFormState extends ConsumerState<_PreferencesForm> {
  late NotificationPreferences _prefs = widget.initial;
  bool _saving = false;

  Future<void> _update(NotificationPreferences next) async {
    unawaited(Haptics.selection());
    setState(() {
      _prefs = next;
      _saving = true;
    });
    final result =
        await ref.read(notificationRepositoryProvider).updatePreferences(next);
    if (!mounted) return;
    setState(() => _saving = false);
    result.fold(
      (f) {
        // Revert on failure.
        setState(() => _prefs = widget.initial);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(f.message),
          backgroundColor: ColorTokens.error,
        ));
      },
      (_) => ref.invalidate(unreadCountProvider),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(
        top: SpaceTokens.sm,
        bottom: SpaceTokens.sm + MediaQuery.viewPaddingOf(context).bottom,
      ),
      children: [
        if (_saving)
          const LinearProgressIndicator(minHeight: 2),
        _tile(
          'AI identification results',
          'When your sighting has been identified',
          _prefs.identificationComplete,
          (v) => _update(_prefs.copyWith(identificationComplete: v)),
        ),
        _tile(
          'New species nearby',
          'Rare or seasonal butterflies in your area',
          _prefs.newSpeciesNearby,
          (v) => _update(_prefs.copyWith(newSpeciesNearby: v)),
        ),
        _tile(
          'Verification updates',
          'When admins review your sightings',
          _prefs.adminVerification,
          (v) => _update(_prefs.copyWith(adminVerification: v)),
        ),
        _tile(
          'Educational alerts',
          'Tips, articles and butterfly facts',
          _prefs.educationalAlerts,
          (v) => _update(_prefs.copyWith(educationalAlerts: v)),
        ),
        _tile(
          'Events & challenges',
          'Community events and seasonal challenges',
          _prefs.events,
          (v) => _update(_prefs.copyWith(events: v)),
        ),
        Padding(
          padding: const EdgeInsets.all(SpaceTokens.base),
          child: Text(
            'Push delivery requires notification permission. In-app '
            'notifications always appear in the notification center.',
            style: TypographyTokens.caption.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _tile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      value: value,
      onChanged: _saving ? null : onChanged,
      title: Text(title, style: TypographyTokens.textTheme.titleSmall),
      subtitle: Text(subtitle,
          style: TypographyTokens.caption.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          )),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: SpaceTokens.base),
    );
  }
}
