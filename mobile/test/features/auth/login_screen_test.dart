import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:butterfly_india/core/theme/app_theme.dart';
import 'package:butterfly_india/features/auth/presentation/providers/auth_provider.dart';
import 'package:butterfly_india/features/auth/presentation/screens/login_screen.dart';
import 'package:butterfly_india/shared/widgets/buttons/app_button.dart';
import '../../helpers/test_helpers.dart';
import 'fake_auth_repository.dart';

void main() {
  Widget buildLoginWidget(FakeAuthRepository repo) {
    final container = createTestContainer(
      overrides: [authRepositoryProvider.overrideWithValue(repo)],
    );

    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
        GoRoute(
            path: '/',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('HOME_SCREEN')))),
        GoRoute(
            path: '/register',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('REGISTER_SCREEN')))),
        GoRoute(
            path: '/forgot-password',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('FORGOT_SCREEN')))),
      ],
    );

    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        theme: AppTheme.light,
        routerConfig: router,
      ),
    );
  }

  /// Pumps the LoginScreen at a phone size so the mobile (single-column)
  /// layout renders instead of the tablet two-panel.
  Future<void> pumpLogin(WidgetTester tester, FakeAuthRepository repo) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(buildLoginWidget(repo));
    await tester.pumpAndSettle();
  }

  group('LoginScreen', () {
    testWidgets('renders email + password fields and sign in button',
        (tester) async {
      await pumpLogin(tester, FakeAuthRepository());

      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.widgetWithText(AppButton, 'Sign In'), findsOneWidget);
    });

    testWidgets('shows validation errors on empty submit', (tester) async {
      final repo = FakeAuthRepository();
      await pumpLogin(tester, repo);

      await tester.tap(find.widgetWithText(AppButton, 'Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
      expect(repo.loginCalls, 0);
    });

    testWidgets('calls repository with valid input', (tester) async {
      final repo = FakeAuthRepository();
      await pumpLogin(tester, repo);

      await tester.enterText(
          find.byType(TextFormField).at(0), 'user@test.app');
      await tester.enterText(find.byType(TextFormField).at(1), 'secret123');

      await tester.tap(find.widgetWithText(AppButton, 'Sign In'));
      await tester.pumpAndSettle();

      expect(repo.loginCalls, 1);
      expect(repo.lastEmail, 'user@test.app');
    });

    testWidgets('navigates to home on successful login', (tester) async {
      final repo = FakeAuthRepository();
      await pumpLogin(tester, repo);

      await tester.enterText(
          find.byType(TextFormField).at(0), 'user@test.app');
      await tester.enterText(find.byType(TextFormField).at(1), 'secret123');
      await tester.tap(find.widgetWithText(AppButton, 'Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('HOME_SCREEN'), findsOneWidget);
    });

    testWidgets('shows error snackbar on failed login', (tester) async {
      final repo = FakeAuthRepository(
        shouldFail: true,
        failureMessage: 'Invalid credentials',
      );
      await pumpLogin(tester, repo);

      await tester.enterText(
          find.byType(TextFormField).at(0), 'user@test.app');
      await tester.enterText(find.byType(TextFormField).at(1), 'wrongpass');
      await tester.tap(find.widgetWithText(AppButton, 'Sign In'));
      await tester.pump(); // start
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Invalid credentials'), findsOneWidget);
    });

    testWidgets('navigates to register screen', (tester) async {
      await pumpLogin(tester, FakeAuthRepository());

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      expect(find.text('REGISTER_SCREEN'), findsOneWidget);
    });

    testWidgets('navigates to forgot password', (tester) async {
      await pumpLogin(tester, FakeAuthRepository());

      await tester.tap(find.text('Forgot password?'));
      await tester.pumpAndSettle();

      expect(find.text('FORGOT_SCREEN'), findsOneWidget);
    });
  });
}
