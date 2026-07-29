import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';
import 'auth_state.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// AUTH PROVIDERS (feature layer)
/// ─────────────────────────────────────────────────────────────────────────────

// ── DI: Datasource + Repository ───────────────────────────────────────────────

final authRemoteDataSourceProvider = Provider<IAuthRemoteDataSource>(
  (ref) => AuthRemoteDataSource(dio: ref.read(dioProvider)),
  name: 'authRemoteDataSource',
);

final authRepositoryProvider = Provider<IAuthRepository>(
  (ref) => AuthRepositoryImpl(
    remoteDataSource: ref.read(authRemoteDataSourceProvider),
    tokenManager: ref.read(tokenManagerProvider),
  ),
  name: 'authRepository',
);

// ── Auth Notifier ─────────────────────────────────────────────────────────────

class AuthNotifier extends StateNotifier<AuthUiState> {
  AuthNotifier(this._repository, this._ref)
      : super(const AuthUiState.initial());

  final IAuthRepository _repository;
  final Ref _ref;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthUiState.loading();
    final result = await _repository.login(email: email, password: password);
    result.fold(
      (failure) => state = _errorFrom(failure),
      (user) {
        _ref.read(currentUserProvider.notifier).state = user;
        _ref.read(authStateNotifierProvider.notifier).onLoggedIn();
        state = AuthUiState.success(user);
      },
    );
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String username,
  }) async {
    state = const AuthUiState.loading();
    final result = await _repository.register(
      email: email,
      password: password,
      fullName: fullName,
      username: username,
    );
    result.fold(
      (failure) => state = _errorFrom(failure),
      (user) {
        _ref.read(currentUserProvider.notifier).state = user;
        _ref.read(authStateNotifierProvider.notifier).onLoggedIn();
        state = AuthUiState.success(user);
      },
    );
  }

  /// Translates a [Failure] into a UI error state, deriving inline field-level
  /// errors from (a) 422 validation field errors and (b) conflict/credential
  /// messages so the right input can be highlighted.
  AuthUiState _errorFrom(Failure failure) {
    final fieldErrors = <String, String>{};

    if (failure is ValidationFailure) {
      failure.fieldErrors.forEach((key, messages) {
        if (messages.isNotEmpty) {
          fieldErrors[_normalizeField(key)] = messages.first;
        }
      });
    } else {
      final lower = failure.message.toLowerCase();
      final isGenericCredential =
          lower.contains('email or password') || lower.contains('invalid');
      if (isGenericCredential) {
        // Wrong-credentials error → banner only, no single-field highlight.
      } else if (lower.contains('email')) {
        fieldErrors['email'] = failure.message;
      } else if (lower.contains('username')) {
        fieldErrors['username'] = failure.message;
      } else if (lower.contains('password')) {
        fieldErrors['password'] = failure.message;
      }
    }

    return AuthUiState.error(failure.message, fieldErrors: fieldErrors);
  }

  String _normalizeField(String backendKey) => switch (backendKey) {
        'full_name' => 'fullName',
        _ => backendKey,
      };

  Future<void> logout() async {
    await _repository.logout();
    _ref.read(currentUserProvider.notifier).state = null;
    _ref.read(authStateNotifierProvider.notifier).onLoggedOut();
    state = const AuthUiState.initial();
  }

  Future<void> restoreSession() async {
    state = const AuthUiState.loading();
    final result = await _repository.restoreSession();
    result.fold(
      (failure) {
        _ref.read(authStateNotifierProvider.notifier).onSessionExpired();
        state = const AuthUiState.initial();
      },
      (user) {
        _ref.read(currentUserProvider.notifier).state = user;
        _ref.read(authStateNotifierProvider.notifier).onLoggedIn();
        state = AuthUiState.success(user);
      },
    );
  }

  void clearError() {
    if (state.hasError) {
      state = const AuthUiState.initial();
    }
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthUiState>(
  (ref) => AuthNotifier(ref.read(authRepositoryProvider), ref),
  name: 'authNotifier',
);

// ── Current user ──────────────────────────────────────────────────────────────

final currentUserProvider = StateProvider<UserEntity?>(
  (ref) => null,
  name: 'currentUser',
);

final isAuthenticatedProvider = Provider<bool>(
  (ref) => ref.watch(currentUserProvider) != null,
  name: 'isAuthenticated',
);
