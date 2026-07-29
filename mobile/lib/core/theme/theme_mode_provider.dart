import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/core_providers.dart';
import '../services/app_preferences.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// THEME MODE — user-selectable, persisted via AppPreferences.
/// ─────────────────────────────────────────────────────────────────────────────

ThemeMode themeModeFromString(String? value) => switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

String themeModeToString(ThemeMode mode) => switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._prefs)
      : super(themeModeFromString(_prefs.themePreference));

  final IAppPreferences _prefs;

  Future<void> set(ThemeMode mode) async {
    state = mode;
    await _prefs.setThemePreference(themeModeToString(mode));
  }
}

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(ref.read(appPreferencesProvider)),
  name: 'themeMode',
);
