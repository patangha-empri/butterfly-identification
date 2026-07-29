import 'package:dartz/dartz.dart';
import '../../../../core/auth/token_manager.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// AUTH REPOSITORY IMPLEMENTATION
/// Bridges datasource ↔ domain: handles token persistence + maps failures.
/// ─────────────────────────────────────────────────────────────────────────────

class AuthRepositoryImpl implements IAuthRepository {
  AuthRepositoryImpl({
    required IAuthRemoteDataSource remoteDataSource,
    required ITokenManager tokenManager,
  })  : _remote = remoteDataSource,
        _tokens = tokenManager;

  final IAuthRemoteDataSource _remote;
  final ITokenManager _tokens;

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) =>
      _safeCall(() async {
        final tokens = await _remote.login(email: email, password: password);
        await _tokens.saveTokens(
          accessToken: tokens.accessToken,
          refreshToken: tokens.refreshToken,
        );
        return tokens.user.toEntity();
      });

  @override
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    required String fullName,
    required String username,
  }) =>
      _safeCall(() async {
        final tokens = await _remote.register(
          email: email,
          password: password,
          fullName: fullName,
          username: username,
        );
        await _tokens.saveTokens(
          accessToken: tokens.accessToken,
          refreshToken: tokens.refreshToken,
        );
        return tokens.user.toEntity();
      });

  @override
  Future<Either<Failure, void>> logout() => _safeCall(() async {
        try {
          await _remote.logout();
        } catch (_) {
          // Ignore remote error — always clear local tokens
        }
        await _tokens.clearTokens();
      });

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() =>
      _safeCall(() async => (await _remote.getCurrentUser()).toEntity());

  @override
  Future<Either<Failure, void>> forgotPassword(String email) =>
      _safeCall(() => _remote.forgotPassword(email));

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  }) =>
      _safeCall(
        () => _remote.resetPassword(token: token, newPassword: newPassword),
      );

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) =>
      _safeCall(
        () => _remote.changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      );

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    String? fullName,
    String? bio,
  }) =>
      _safeCall(() async =>
          (await _remote.updateProfile(fullName: fullName, bio: bio)).toEntity());

  @override
  Future<bool> isAuthenticated() async {
    final token = await _tokens.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<Either<Failure, UserEntity>> restoreSession() => _safeCall(() async {
        final token = await _tokens.getAccessToken();
        if (token == null || token.isEmpty) {
          throw const UnauthorizedException(
            message: 'No session found.',
          );
        }
        return (await _remote.getCurrentUser()).toEntity();
      });

  // ── Helper ────────────────────────────────────────────────────────────────

  Future<Either<Failure, T>> _safeCall<T>(Future<T> Function() fn) async {
    try {
      final result = await fn();
      return Right(result);
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(ExceptionMapper.fromObject(e).toFailure());
    }
  }
}
