import 'package:dio/dio.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// APP EXCEPTION HIERARCHY
/// Sealed class that covers all failure modes in the app.
/// ─────────────────────────────────────────────────────────────────────────────

sealed class AppException implements Exception {
  const AppException({required this.message, this.code, this.details});

  final String message;
  final String? code;
  final Object? details;

  @override
  String toString() => 'AppException(${runtimeType}): $message';
}

// ── Network exceptions ───────────────────────────────────────────────────────

final class NetworkException extends AppException {
  const NetworkException({super.message = 'No internet connection.', super.code, super.details});
}

final class TimeoutException extends AppException {
  const TimeoutException({super.message = 'Request timed out. Please try again.', super.code, super.details});
}

// ── API / HTTP exceptions ────────────────────────────────────────────────────

final class ApiException extends AppException {
  const ApiException({
    required super.message,
    required this.statusCode,
    super.code,
    super.details,
  });
  final int statusCode;
}

final class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Session expired. Please sign in again.',
    super.code,
    super.details,
  });
}

final class ForbiddenException extends AppException {
  const ForbiddenException({
    super.message = "You don't have permission to perform this action.",
    super.code,
    super.details,
  });
}

final class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'The requested resource was not found.',
    super.code,
    super.details,
  });
}

final class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    required this.fieldErrors,
    super.code,
  });
  final Map<String, List<String>> fieldErrors;
}

final class ServerException extends AppException {
  const ServerException({
    super.message = 'Server error. Please try again later.',
    super.code,
    super.details,
  });
}

final class RateLimitException extends AppException {
  const RateLimitException({
    super.message = 'Too many requests. Please wait a moment.',
    this.retryAfterSeconds,
    super.code,
  });
  final int? retryAfterSeconds;
}

// ── Auth exceptions ──────────────────────────────────────────────────────────

final class TokenExpiredException extends AppException {
  const TokenExpiredException({
    super.message = 'Your session has expired. Please sign in again.',
    super.code,
  });
}

final class TokenRefreshException extends AppException {
  const TokenRefreshException({
    super.message = 'Failed to refresh session. Please sign in again.',
    super.code,
  });
}

// ── Storage / DB exceptions ──────────────────────────────────────────────────

final class CacheException extends AppException {
  const CacheException({super.message = 'Failed to access local cache.', super.code, super.details});
}

final class StorageException extends AppException {
  const StorageException({super.message = 'Failed to read/write secure storage.', super.code, super.details});
}

// ── Feature-specific exceptions ──────────────────────────────────────────────

final class CameraException extends AppException {
  const CameraException({super.message = 'Camera error.', super.code, super.details});
}

final class ImageProcessingException extends AppException {
  const ImageProcessingException({super.message = 'Failed to process image.', super.code, super.details});
}

final class AiIdentificationException extends AppException {
  const AiIdentificationException({super.message = 'AI identification failed.', super.code, super.details});
}

final class LocationException extends AppException {
  const LocationException({super.message = 'Could not get location.', super.code, super.details});
}

// ── Unknown / Generic ────────────────────────────────────────────────────────

final class UnknownException extends AppException {
  const UnknownException({super.message = 'An unexpected error occurred.', super.code, super.details});
}

/// ─────────────────────────────────────────────────────────────────────────────
/// EXCEPTION MAPPER
/// Converts raw Dio/platform exceptions → typed AppException
/// ─────────────────────────────────────────────────────────────────────────────

abstract class ExceptionMapper {
  static AppException fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();

      case DioExceptionType.connectionError:
        return const NetworkException();

      case DioExceptionType.badResponse:
        return _fromResponse(e);

      case DioExceptionType.cancel:
        return const ApiException(message: 'Request was cancelled.', statusCode: 0);

      default:
        return UnknownException(message: e.message ?? 'Unknown error', details: e);
    }
  }

  static AppException _fromResponse(DioException e) {
    final response = e.response;
    final statusCode = response?.statusCode ?? 0;
    final data = response?.data;

    // Extract API error message from backend response shape:
    // { "success": false, "message": "...", "errors": {...} }
    // `msg` is null when the backend sent no message, so we can fall back to a
    // sensible default per status code.
    final msg = _extractMessage(data);
    final errors = _extractErrors(data);

    return switch (statusCode) {
      400 => errors.isNotEmpty
          ? ValidationException(
              message: msg ?? 'Please check the highlighted fields.',
              fieldErrors: errors,
            )
          : ApiException(
              message: msg ?? 'Bad request.', statusCode: statusCode),
      401 => UnauthorizedException(
          message: msg ?? 'Session expired. Please sign in again.'),
      403 => ForbiddenException(
          message: msg ?? "You don't have permission to perform this action."),
      404 => NotFoundException(message: msg ?? 'The resource was not found.'),
      409 => ApiException(
          message: msg ?? 'This already exists.', statusCode: statusCode),
      422 => ValidationException(
          message: msg ?? 'Please check the highlighted fields.',
          fieldErrors: errors,
        ),
      429 => RateLimitException(
          message: msg ?? 'Too many requests. Please wait a moment.',
          retryAfterSeconds: _parseRetryAfter(e.response?.headers),
        ),
      >= 500 => ServerException(
          message: msg ?? 'Server error. Please try again later.'),
      _ => ApiException(
          message: msg ?? 'An error occurred.', statusCode: statusCode),
    };
  }

  /// Returns the backend's human message, or null if none was provided.
  static String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final m = data['message'] ?? data['error'];
      if (m is String && m.trim().isNotEmpty) return m;
    }
    return null;
  }

  static Map<String, List<String>> _extractErrors(dynamic data) {
    if (data is! Map<String, dynamic>) return {};
    final rawErrors = data['errors'];
    if (rawErrors is! Map<String, dynamic>) return {};
    return rawErrors.map((k, v) {
      if (v is List) return MapEntry(k, v.map((e) => e.toString()).toList());
      return MapEntry(k, [v.toString()]);
    });
  }

  static int? _parseRetryAfter(Headers? headers) {
    final value = headers?.value('retry-after');
    return value != null ? int.tryParse(value) : null;
  }

  static AppException fromObject(Object? error) {
    if (error is AppException) return error;
    if (error is DioException) return fromDioException(error);
    return UnknownException(message: error?.toString() ?? 'Unknown error', details: error);
  }
}
