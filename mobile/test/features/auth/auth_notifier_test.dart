import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/features/auth/presentation/providers/auth_provider.dart';
import 'package:butterfly_india/features/auth/presentation/providers/auth_state.dart';
import '../../helpers/test_helpers.dart';
import 'fake_auth_repository.dart';

void main() {
  group('AuthNotifier', () {
    late FakeAuthRepository repo;
    late ProviderContainer container;

    ProviderContainer build(FakeAuthRepository r) => createTestContainer(
          overrides: [authRepositoryProvider.overrideWithValue(r)],
        );

    setUp(() {
      repo = FakeAuthRepository();
      container = build(repo);
      addTearDown(container.dispose);
    });

    test('initial state is AuthUiState.initial', () {
      expect(container.read(authNotifierProvider), const AuthUiState.initial());
    });

    test('login success → success state + currentUser set', () async {
      await container.read(authNotifierProvider.notifier).login(
            email: 'fake@test.app',
            password: 'pass123',
          );

      final state = container.read(authNotifierProvider);
      expect(state.isSuccess, isTrue);
      expect(state.user, FakeAuthRepository.fakeUser);
      expect(container.read(currentUserProvider), FakeAuthRepository.fakeUser);
      expect(repo.loginCalls, 1);
      expect(repo.lastEmail, 'fake@test.app');
    });

    test('login failure → error state with message', () async {
      repo.shouldFail = true;
      repo.failureMessage = 'Wrong password';

      await container.read(authNotifierProvider.notifier).login(
            email: 'fake@test.app',
            password: 'bad',
          );

      final state = container.read(authNotifierProvider);
      expect(state.hasError, isTrue);
      expect(state.errorMessage, 'Wrong password');
      expect(container.read(currentUserProvider), isNull);
    });

    test('register success sets user', () async {
      await container.read(authNotifierProvider.notifier).register(
            email: 'new@test.app',
            password: 'Abcdef12',
            fullName: 'New User',
            username: 'newuser',
          );

      expect(container.read(authNotifierProvider).isSuccess, isTrue);
      expect(repo.registerCalls, 1);
      expect(repo.lastUsername, 'newuser');
    });

    test('logout clears user and resets to initial', () async {
      await container.read(authNotifierProvider.notifier).login(
            email: 'fake@test.app',
            password: 'pass',
          );
      expect(container.read(currentUserProvider), isNotNull);

      await container.read(authNotifierProvider.notifier).logout();

      expect(container.read(currentUserProvider), isNull);
      expect(container.read(authNotifierProvider), const AuthUiState.initial());
    });

    test('emits loading before success', () async {
      repo.delay = const Duration(milliseconds: 50);
      final states = <AuthUiState>[];
      container.listen(authNotifierProvider, (_, next) => states.add(next));

      await container.read(authNotifierProvider.notifier).login(
            email: 'fake@test.app',
            password: 'pass',
          );

      expect(states.first.isLoading, isTrue);
      expect(states.last.isSuccess, isTrue);
    });

    test('clearError resets error state', () async {
      repo.shouldFail = true;
      await container.read(authNotifierProvider.notifier).login(
            email: 'x@y.com',
            password: 'bad',
          );
      expect(container.read(authNotifierProvider).hasError, isTrue);

      container.read(authNotifierProvider.notifier).clearError();
      expect(container.read(authNotifierProvider), const AuthUiState.initial());
    });
  });
}
