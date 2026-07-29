import 'package:equatable/equatable.dart';
import 'app_exception.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// FAILURE (value-type wrapping AppException for Either<Failure, T> returns)
/// Used in repository / usecase layer.
/// ─────────────────────────────────────────────────────────────────────────────

abstract class Failure extends Equatable {
  const Failure({required this.message, this.code});

  final String message;
  final String? code;

  @override
  List<Object?> get props => [message, code];
}

final class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection.', super.code});
}

final class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code, this.statusCode});
  final int? statusCode;
}

final class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});
}

final class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    required this.fieldErrors,
    super.code,
  });
  final Map<String, List<String>> fieldErrors;

  @override
  List<Object?> get props => [...super.props, fieldErrors];
}

final class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Local cache error.', super.code});
}

final class RateLimitFailure extends Failure {
  const RateLimitFailure({required super.message, super.code});
}

final class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'An unexpected error occurred.', super.code});
}

// ── Mapper ────────────────────────────────────────────────────────────────────

extension AppExceptionToFailure on AppException {
  Failure toFailure() => switch (this) {
    final NetworkException e => NetworkFailure(message: e.message),
    final TimeoutException e => NetworkFailure(message: e.message),
    final UnauthorizedException e => AuthFailure(message: e.message),
    final ForbiddenException e => AuthFailure(message: e.message),
    final TokenExpiredException e => AuthFailure(message: e.message),
    final TokenRefreshException e => AuthFailure(message: e.message),
    final ValidationException e => ValidationFailure(
        message: e.message,
        fieldErrors: e.fieldErrors,
      ),
    final RateLimitException e => RateLimitFailure(message: e.message),
    final ApiException e => ServerFailure(message: e.message, statusCode: e.statusCode),
    final ServerException e => ServerFailure(message: e.message),
    final CacheException e => CacheFailure(message: e.message),
    _ => UnknownFailure(message: message),
  };
}
