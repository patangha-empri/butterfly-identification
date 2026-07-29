import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/user_entity.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// AUTH REPOSITORY CONTRACT (domain layer)
/// Returns Either<Failure, T> — failures bubble up cleanly.
/// ─────────────────────────────────────────────────────────────────────────────

abstract class IAuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    required String fullName,
    required String username,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, UserEntity>> getCurrentUser();

  Future<Either<Failure, void>> forgotPassword(String email);

  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  });

  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<Either<Failure, UserEntity>> updateProfile({
    String? fullName,
    String? bio,
  });

  /// Returns true if a valid access token exists in secure storage.
  Future<bool> isAuthenticated();

  /// Attempt to restore session from stored tokens.
  Future<Either<Failure, UserEntity>> restoreSession();
}
