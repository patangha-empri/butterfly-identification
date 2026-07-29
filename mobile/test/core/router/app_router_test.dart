import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/core/router/app_routes.dart';
import 'package:butterfly_india/core/router/app_router.dart';
import 'package:butterfly_india/core/theme/app_theme.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('AppRoutes — path constants', () {
    test('home is root path', () {
      expect(AppRoutes.home, '/');
    });

    test('speciesDetailPath generates correct path', () {
      expect(AppRoutes.speciesDetailPath('sp-001'), '/species/sp-001');
    });

    test('observationDetailPath generates correct path', () {
      expect(AppRoutes.observationDetailPath('obs-123'), '/observations/obs-123');
    });

    test('articleDetailPath generates correct path', () {
      expect(AppRoutes.articleDetailPath('intro-to-butterflies'), '/articles/intro-to-butterflies');
    });
  });

  group('GoRouter — navigation', () {
    late ProviderContainer container;

    setUp(() {
      container = createTestContainer();
    });

    tearDown(() => container.dispose());

    testWidgets('initial location is splash', (tester) async {
      final router = container.read(appRouterProvider);
      expect(router.routeInformationProvider.value.uri.path, AppRoutes.splash);
    });

    testWidgets('splash shows then navigates to login when unauthenticated',
        (tester) async {
      tester.view.physicalSize = const Size(400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final router = container.read(appRouterProvider);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            theme: AppTheme.light,
            routerConfig: router,
          ),
        ),
      );

      // Splash renders first.
      await tester.pump();
      expect(find.text('Butterfly India'), findsOneWidget);

      // Advance past the splash min-display + init → navigates, then settle
      // the login screen's finite entrance animations.
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Onboarding already completed (fake prefs) + not logged in → login.
      expect(find.text('Welcome back'), findsOneWidget);
    });
  });
}
