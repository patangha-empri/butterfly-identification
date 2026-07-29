import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:butterfly_india/core/providers/core_providers.dart';
import 'package:butterfly_india/core/theme/app_theme.dart';
import 'package:butterfly_india/features/auth/presentation/screens/onboarding_screen.dart';
import '../../helpers/test_helpers.dart';

void main() {
  Widget buildOnboardingWidget(FakeAppPreferences prefs) {
    final container = createTestContainer(
      overrides: [appPreferencesProvider.overrideWithValue(prefs)],
    );
    final router = GoRouter(
      initialLocation: '/onboarding',
      routes: [
        GoRoute(
            path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
        GoRoute(
            path: '/login',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('LOGIN_SCREEN')))),
      ],
    );
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    );
  }

  Future<void> pumpOnboarding(
      WidgetTester tester, FakeAppPreferences prefs) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(buildOnboardingWidget(prefs));
    await tester.pumpAndSettle();
  }

  group('OnboardingScreen', () {
    testWidgets('shows first page and Next button', (tester) async {
      await pumpOnboarding(tester, FakeAppPreferences(onboardingCompleted: false));

      expect(find.textContaining('Discover'), findsWidgets);
      expect(find.text('Next'), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);
    });

    testWidgets('Skip completes onboarding + navigates to login',
        (tester) async {
      final prefs = FakeAppPreferences(onboardingCompleted: false);
      await pumpOnboarding(tester, prefs);

      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      expect(prefs.onboardingCompleted, isTrue);
      expect(find.text('LOGIN_SCREEN'), findsOneWidget);
    });

    testWidgets('advances through pages to Get Started', (tester) async {
      final prefs = FakeAppPreferences(onboardingCompleted: false);
      await pumpOnboarding(tester, prefs);

      // Page 1 → 2
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      // Page 2 → 3
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Last page shows Get Started
      expect(find.text('Get Started'), findsOneWidget);

      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      expect(prefs.onboardingCompleted, isTrue);
      expect(find.text('LOGIN_SCREEN'), findsOneWidget);
    });
  });
}
