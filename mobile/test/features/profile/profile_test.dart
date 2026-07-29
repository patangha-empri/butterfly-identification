import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/core/providers/core_providers.dart';
import 'package:butterfly_india/core/services/app_preferences.dart';
import 'package:butterfly_india/core/theme/theme_mode_provider.dart';
import 'package:butterfly_india/features/auth/domain/entities/user_entity.dart';
import 'package:butterfly_india/features/auth/presentation/providers/auth_provider.dart';
import 'package:butterfly_india/features/gamification/presentation/gamification_providers.dart';
import 'package:butterfly_india/features/profile/presentation/providers/profile_providers.dart';
import 'package:butterfly_india/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:butterfly_india/features/profile/presentation/screens/profile_screen.dart';
import 'package:butterfly_india/features/profile/presentation/screens/settings_screen.dart';
import '../../helpers/test_helpers.dart';
import '../gamification/fake_gamification_repository.dart';
import 'fake_profile_repository.dart';

void main() {
  ProviderContainer container(List<Override> extra) => createTestContainer(
        overrides: [
          gamificationRepositoryProvider
              .overrideWithValue(FakeGamificationRepository()),
          ...extra,
        ],
      );

  Future<ProviderContainer> pump(
    WidgetTester tester,
    Widget child, {
    List<Override> overrides = const [],
  }) async {
    tester.view.physicalSize = const Size(420, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final c = container(overrides);
    addTearDown(c.dispose);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: c,
      child: MaterialApp(home: child),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    return c;
  }

  group('ProfileScreen', () {
    testWidgets('renders header, stats and quick links', (tester) async {
      await pump(
        tester,
        const ProfileScreen(),
        overrides: [
          profileRepositoryProvider
              .overrideWithValue(FakeProfileRepository()),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.text('Asha Nair'), findsOneWidget);
      expect(find.text('@asha'), findsOneWidget);
      // stats from FakeGamificationRepository
      expect(find.text('Sightings'), findsOneWidget);
      expect(find.text('11'), findsOneWidget);
      // quick links
      expect(find.text('Edit profile'), findsOneWidget);
      expect(find.text('Log out'), findsOneWidget);
    });
  });

  group('EditProfileScreen', () {
    testWidgets('prefills fields from current user', (tester) async {
      await pump(
        tester,
        const EditProfileScreen(),
        overrides: [
          profileRepositoryProvider
              .overrideWithValue(FakeProfileRepository()),
          currentUserProvider.overrideWith((ref) => const UserEntity(
                id: 'u-1',
                username: 'asha',
                email: 'asha@example.com',
                fullName: 'Asha Nair',
                bio: 'Lepidoptera lover',
              )),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.text('Asha Nair'), findsOneWidget);
      expect(find.text('asha'), findsOneWidget);
      expect(find.text('Save changes'), findsOneWidget);
    });
  });

  group('SettingsScreen', () {
    testWidgets('renders sections and theme control', (tester) async {
      await pump(tester, const SettingsScreen());
      await tester.pumpAndSettle();

      expect(find.text('Change password'), findsOneWidget);
      expect(find.text('Notification preferences'), findsOneWidget);
      expect(find.text('Theme'), findsOneWidget);
      expect(find.text('Version'), findsOneWidget);
    });

    testWidgets('selecting dark theme persists the preference',
        (tester) async {
      final prefs = FakeAppPreferences();
      final c = await pump(
        tester,
        const SettingsScreen(),
        overrides: [appPreferencesProvider.overrideWithValue(prefs)],
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.dark_mode));
      await tester.pumpAndSettle();

      expect(prefs.themePreference, 'dark');
      expect(c.read(themeModeProvider), ThemeMode.dark);
    });
  });

  group('EditProfileNotifier', () {
    test('save success updates current user', () async {
      final c = container([
        profileRepositoryProvider.overrideWithValue(FakeProfileRepository()),
      ]);
      addTearDown(c.dispose);

      final ok = await c
          .read(editProfileNotifierProvider.notifier)
          .save(fullName: 'New Name', username: 'asha', bio: 'hi');

      expect(ok, isTrue);
      expect(c.read(currentUserProvider)?.fullName, 'New Name');
    });

    test('save surfaces username-taken as a field error', () async {
      final c = container([
        profileRepositoryProvider
            .overrideWithValue(FakeProfileRepository(usernameTaken: true)),
      ]);
      addTearDown(c.dispose);

      final ok = await c
          .read(editProfileNotifierProvider.notifier)
          .save(username: 'taken');

      expect(ok, isFalse);
      expect(c.read(editProfileNotifierProvider).fieldErrors['username'],
          isNotNull);
    });
  });

  group('ChangePasswordNotifier', () {
    test('submit success', () async {
      final repo = FakeProfileRepository();
      final c = container([
        profileRepositoryProvider.overrideWithValue(repo),
      ]);
      addTearDown(c.dispose);

      final ok = await c
          .read(changePasswordNotifierProvider.notifier)
          .submit(currentPassword: 'old', newPassword: 'newpass12');

      expect(ok, isTrue);
      expect(repo.passwordCalls, 1);
    });

    test('submit failure sets error', () async {
      final c = container([
        profileRepositoryProvider
            .overrideWithValue(FakeProfileRepository(failPassword: true)),
      ]);
      addTearDown(c.dispose);

      final ok = await c
          .read(changePasswordNotifierProvider.notifier)
          .submit(currentPassword: 'old', newPassword: 'newpass12');

      expect(ok, isFalse);
      expect(c.read(changePasswordNotifierProvider).status,
          PasswordStatus.error);
    });
  });
}
