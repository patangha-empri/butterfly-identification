import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// APP PREFERENCES
/// Lightweight key/value store for non-sensitive app flags (onboarding, theme).
/// Sensitive data (tokens) lives in SecureStorageService, not here.
/// ─────────────────────────────────────────────────────────────────────────────

abstract class IAppPreferences {
  bool get onboardingCompleted;
  Future<void> setOnboardingCompleted(bool value);

  String? get themePreference;
  Future<void> setThemePreference(String value);

  bool get notifPermissionAsked;
  Future<void> setNotifPermissionAsked(bool value);
}

class AppPreferences implements IAppPreferences {
  AppPreferences(this._prefs);

  final SharedPreferences _prefs;

  /// Async factory — call once during bootstrap.
  static Future<AppPreferences> create() async {
    final prefs = await SharedPreferences.getInstance();
    return AppPreferences(prefs);
  }

  @override
  bool get onboardingCompleted =>
      _prefs.getBool(AppConstants.onboardingCompletedKey) ?? false;

  @override
  Future<void> setOnboardingCompleted(bool value) =>
      _prefs.setBool(AppConstants.onboardingCompletedKey, value);

  @override
  String? get themePreference =>
      _prefs.getString(AppConstants.themePreferenceKey);

  @override
  Future<void> setThemePreference(String value) =>
      _prefs.setString(AppConstants.themePreferenceKey, value);

  @override
  bool get notifPermissionAsked =>
      _prefs.getBool(AppConstants.notifPermissionAskedKey) ?? false;

  @override
  Future<void> setNotifPermissionAsked(bool value) =>
      _prefs.setBool(AppConstants.notifPermissionAskedKey, value);
}
