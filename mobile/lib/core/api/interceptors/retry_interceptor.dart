import 'dart:math';
import 'package:dio/dio.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// RETRY INTERCEPTOR
/// Exponential back-off retry for network/timeout failures.
/// Does NOT retry 4xx responses (client errors), only retries:
///   - connection errors
///   - timeout errors
///   - 5xx server errors
/// ─────────────────────────────────────────────────────────────────────────────

class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required Dio dio,
    this.maxRetries = 3,
    this.retryDelayMs = 500,
    this.useExponentialBackoff = true,
  }) : _dio = dio;

  final Dio _dio;
  final int maxRetries;
  final int retryDelayMs;
  final bool useExponentialBackoff;

  static const _retryCountKey = '_retry_count';

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }

  int _delay(int attempt) {
    if (!useExponentialBackoff) return retryDelayMs;
    return (retryDelayMs * pow(2, attempt)).toInt();
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_shouldRetry(err)) return handler.next(err);

    final retryCount =
        (err.requestOptions.extra[_retryCountKey] as int?) ?? 0;

    if (retryCount >= maxRetries) return handler.next(err);

    await Future.delayed(Duration(milliseconds: _delay(retryCount)));

    final options = err.requestOptions;
    options.extra[_retryCountKey] = retryCount + 1;

    try {
      final response = await _dio.fetch<dynamic>(options);
      return handler.resolve(response);
    } catch (e) {
      return handler.next(err);
    }
  }
}
