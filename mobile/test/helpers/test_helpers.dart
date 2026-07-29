import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:butterfly_india/core/providers/core_providers.dart';
import 'package:butterfly_india/core/database/app_database.dart';
import 'package:butterfly_india/core/services/app_preferences.dart';
import 'package:butterfly_india/core/services/location_service.dart';
import '../mocks/mock_services.dart';

/// In-memory fake of IAppPreferences for tests.
class FakeAppPreferences implements IAppPreferences {
  FakeAppPreferences({bool onboardingCompleted = true})
      : _onboarding = onboardingCompleted;

  bool _onboarding;
  String? _theme;
  bool _notifAsked = false;

  @override
  bool get onboardingCompleted => _onboarding;
  @override
  Future<void> setOnboardingCompleted(bool value) async => _onboarding = value;

  @override
  String? get themePreference => _theme;
  @override
  Future<void> setThemePreference(String value) async => _theme = value;

  @override
  bool get notifPermissionAsked => _notifAsked;
  @override
  Future<void> setNotifPermissionAsked(bool value) async => _notifAsked = value;
}

/// ─────────────────────────────────────────────────────────────────────────────
/// TEST HELPERS
/// Shared utilities for widget, provider, and integration tests.
/// ─────────────────────────────────────────────────────────────────────────────

/// Creates a ProviderContainer with standard test overrides.
ProviderContainer createTestContainer({
  List<Override> overrides = const [],
  List<ProviderObserver> observers = const [],
  AppDatabase? database,
  MockConnectivityService? connectivity,
}) {
  final db = database ?? AppDatabase.inMemory();
  return ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      secureStorageProvider.overrideWithValue(MockSecureStorageService()),
      tokenManagerProvider.overrideWithValue(MockTokenManager()),
      dioProvider.overrideWithValue(createMockDio()),
      connectivityServiceProvider
          .overrideWithValue(connectivity ?? MockConnectivityService()),
      appPreferencesProvider.overrideWithValue(FakeAppPreferences()),
      // Tests must not touch the real GPS plugin (it hangs without a device).
      locationServiceProvider.overrideWithValue(const StubLocationService()),
      ...overrides,
    ],
    observers: observers,
  );
}

/// Wraps a widget in the full app scaffold for widget tests.
Widget buildTestableWidget(
  Widget child, {
  List<Override> overrides = const [],
  ThemeData? theme,
}) {
  final container = createTestContainer(overrides: overrides);
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: theme ?? ThemeData.light(useMaterial3: true),
      home: child,
    ),
  );
}

/// Pump + settle with a timeout.
Future<void> pumpAndSettle(
  WidgetTester tester, {
  Duration timeout = const Duration(seconds: 5),
}) async {
  await tester.pumpAndSettle(
    const Duration(milliseconds: 100),
    EnginePhase.sendSemanticsUpdate,
    timeout,
  );
}

/// Test data factories
abstract class TestData {
  static const String testUserId = 'test-user-123';
  static const String testEmail = 'test@butterflyindia.app';
  static const String testPassword = 'TestPassword123!';
  static const String testUsername = 'testuser';
  static const String testFullName = 'Test User';
  static const String testAccessToken = 'test-access-token-abc123';
  static const String testRefreshToken = 'test-refresh-token-xyz789';

  static Map<String, dynamic> userJson() => {
    'id': testUserId,
    'username': testUsername,
    'email': testEmail,
    'full_name': testFullName,
    'bio': 'A butterfly enthusiast',
    'profile_image_url': null,
    'role': 'user',
    'observation_count': 5,
    'species_count': 3,
    'is_verified': false,
    'created_at': '2024-01-15T10:30:00Z',
  };

  static Map<String, dynamic> authTokensJson() => {
    'access_token': testAccessToken,
    'refresh_token': testRefreshToken,
    'user': userJson(),
  };

  static Map<String, dynamic> observationJson() => {
    'id': 'obs-001',
    'title': 'Spotted a Crimson Rose',
    'notes': 'Near a Jatropha bush',
    'state_id': 11,
    'state_name': 'Karnataka',
    'latitude': 12.9716,
    'longitude': 77.5946,
    'privacy': 'public',
    'status': 'identified',
    'identified_species_name': 'Pachliopta hector',
    'identification_confidence': 0.95,
    'primary_image_url': 'https://cdn.example.com/obs-001.jpg',
    'created_at': '2024-06-01T08:00:00Z',
  };

  static Map<String, dynamic> speciesJson() => {
    'id': 'sp-001',
    'common_name': 'Crimson Rose',
    'scientific_name': 'Pachliopta hector',
    'family': 'Papilionidae',
    'rarity': 'uncommon',
    'conservation_status': 'LC',
    'primary_image_url': 'https://cdn.example.com/species-001.jpg',
  };
}
