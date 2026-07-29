import 'dart:async';
import 'package:dio/dio.dart';
import 'secure_storage_service.dart';
import '../api/api_endpoints.dart';
import '../errors/app_exception.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// TOKEN MANAGER
/// Handles JWT access/refresh lifecycle:
///   - stores tokens in secure storage
///   - exposes read methods for interceptors
///   - implements thread-safe refresh-once pattern
///     (multiple concurrent 401s share one refresh request)
/// ─────────────────────────────────────────────────────────────────────────────

abstract class ITokenManager {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> saveTokens({required String accessToken, required String refreshToken});
  Future<void> clearTokens();
  Future<String?> refreshAccessToken(Dio dio);
  bool get isRefreshing;
}

class TokenManager implements ITokenManager {
  TokenManager({required ISecureStorageService storage}) : _storage = storage;

  final ISecureStorageService _storage;

  // ── Refresh-once lock ─────────────────────────────────────────────────────
  // Multiple 401s arrive simultaneously → only one refresh call is made,
  // all waiters share the same future result.
  Completer<String?>? _refreshCompleter;

  @override
  bool get isRefreshing => _refreshCompleter != null && !_refreshCompleter!.isCompleted;

  @override
  Future<String?> getAccessToken() => _storage.getAccessToken();

  @override
  Future<String?> getRefreshToken() => _storage.getRefreshToken();

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.saveAccessToken(accessToken),
      _storage.saveRefreshToken(refreshToken),
    ]);
  }

  @override
  Future<void> clearTokens() => _storage.clearTokens();

  /// Refreshes the access token.
  /// Thread-safe: concurrent calls share one in-flight request.
  @override
  Future<String?> refreshAccessToken(Dio dio) async {
    // If already refreshing, wait for that result
    if (isRefreshing) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<String?>();
    // Waiters may or may not await this future; without ignore() a refresh
    // failure with no concurrent waiters becomes an unhandled async error.
    _refreshCompleter!.future.ignore();

    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        throw const TokenRefreshException(
          message: 'No refresh token stored. Please sign in again.',
        );
      }

      // Use a fresh Dio instance (no interceptors) to avoid recursion
      final refreshDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));

      // flask_jwt_extended's @jwt_required(refresh=True) reads the refresh
      // token from the Authorization header (JWT_TOKEN_LOCATION = headers),
      // not from the request body.
      final response = await refreshDio.post(
        ApiEndpoints.refresh,
        options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
      );

      final data = response.data as Map<String, dynamic>;
      final newAccessToken = data['data']?['access_token'] as String?;
      final newRefreshToken = data['data']?['refresh_token'] as String? ?? refreshToken;

      if (newAccessToken == null || newAccessToken.isEmpty) {
        throw const TokenRefreshException();
      }

      await saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );

      _refreshCompleter!.complete(newAccessToken);
      return newAccessToken;
    } on DioException catch (e) {
      // The server answered but rejected the refresh token (expired/revoked)
      // → the session is over. Surface it as TokenRefreshException so the
      // auth interceptor signs the user out. Pure network failures (no
      // response) are rethrown as-is so an offline blip doesn't log out.
      if (e.response != null) {
        const refreshError = TokenRefreshException(
          message: 'Session expired. Please sign in again.',
        );
        _refreshCompleter!.completeError(refreshError);
        throw refreshError;
      }
      _refreshCompleter!.completeError(e);
      rethrow;
    } catch (e) {
      _refreshCompleter!.completeError(e);
      rethrow;
    } finally {
      _refreshCompleter = null;
    }
  }
}
