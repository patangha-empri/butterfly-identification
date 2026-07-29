import 'package:dio/dio.dart';
import '../../auth/token_manager.dart';
import '../../errors/app_exception.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// AUTH INTERCEPTOR
/// 1. Attaches Bearer token to every authenticated request
/// 2. On 401: attempts silent token refresh → retries original request once
/// 3. On second 401: throws UnauthorizedException → triggers sign-out
/// ─────────────────────────────────────────────────────────────────────────────

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required ITokenManager tokenManager,
    required Dio dio,
    this.onUnauthorized,
  })  : _tokenManager = tokenManager,
        _dio = dio;

  final ITokenManager _tokenManager;
  final Dio _dio;
  final void Function()? onUnauthorized;

  static const _retryKey = '_retry';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenManager.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final path = err.requestOptions.path;
    if (path.contains('/auth/login') ||
        path.contains('/auth/register') ||
        path.contains('/auth/refresh')) {
      return handler.next(err);
    }

    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Prevent infinite retry loop
    if (err.requestOptions.extra[_retryKey] == true) {
      onUnauthorized?.call();
      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: const UnauthorizedException(),
          type: DioExceptionType.badResponse,
        ),
      );
    }

    try {
      final newToken = await _tokenManager.refreshAccessToken(_dio);
      if (newToken == null) {
        onUnauthorized?.call();
        return handler.reject(err);
      }

      // Mutate the original request options with new token + retry flag
      err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
      err.requestOptions.extra[_retryKey] = true;

      final response = await _dio.fetch<dynamic>(err.requestOptions);
      return handler.resolve(response);
    } on TokenRefreshException {
      onUnauthorized?.call();
      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: const UnauthorizedException(),
          type: DioExceptionType.badResponse,
        ),
      );
    } catch (_) {
      return handler.next(err);
    }
  }
}

