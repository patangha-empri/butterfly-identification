import 'package:dartz/dartz.dart';
import 'package:butterfly_india/core/errors/failure.dart';
import 'package:butterfly_india/features/auth/domain/entities/user_entity.dart';
import 'package:butterfly_india/features/auth/domain/repositories/i_auth_repository.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// FAKE AUTH REPOSITORY
/// In-memory controllable repository for auth screen + notifier tests.
/// Set [shouldFail] / [failureMessage] to simulate errors; set [delay] to
/// exercise loading states.
/// ─────────────────────────────────────────────────────────────────────────────

class FakeAuthRepository implements IAuthRepository {
  FakeAuthRepository({
    this.shouldFail = false,
    this.failureMessage = 'Invalid credentials',
    this.delay = Duration.zero,
  });

  bool shouldFail;
  String failureMessage;
  Duration delay;

  // Call recorders
  int loginCalls = 0;
  int registerCalls = 0;
  int forgotPasswordCalls = 0;
  String? lastEmail;
  String? lastUsername;

  static const fakeUser = UserEntity(
    id: 'fake-1',
    username: 'fakeuser',
    email: 'fake@test.app',
    fullName: 'Fake User',
  );

  Future<Either<Failure, T>> _result<T>(T value) async {
    if (delay != Duration.zero) await Future.delayed(delay);
    if (shouldFail) return Left(AuthFailure(message: failureMessage));
    return Right(value);
  }

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    loginCalls++;
    lastEmail = email;
    return _result(fakeUser);
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    required String fullName,
    required String username,
  }) async {
    registerCalls++;
    lastEmail = email;
    lastUsername = username;
    return _result(fakeUser);
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    forgotPasswordCalls++;
    lastEmail = email;
    return _result(null);
  }

  @override
  Future<Either<Failure, void>> logout() async => _result(null);

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async =>
      _result(fakeUser);

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  }) async =>
      _result(null);

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async =>
      _result(null);

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    String? fullName,
    String? bio,
  }) async =>
      _result(fakeUser);

  @override
  Future<bool> isAuthenticated() async => !shouldFail;

  @override
  Future<Either<Failure, UserEntity>> restoreSession() async =>
      _result(fakeUser);
}
