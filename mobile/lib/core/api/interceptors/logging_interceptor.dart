import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// LOGGING INTERCEPTOR
/// Pretty-prints requests/responses in debug mode only.
/// Redacts Authorization headers in logs for security.
/// ─────────────────────────────────────────────────────────────────────────────

class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({Logger? logger})
      : _logger = logger ??
            Logger(
              printer: PrettyPrinter(
                methodCount: 0,
                errorMethodCount: 5,
                lineLength: 80,
                colors: true,
                printEmojis: true,
              ),
            );

  final Logger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      final redactedHeaders = Map<String, dynamic>.from(options.headers);
      if (redactedHeaders.containsKey('Authorization')) {
        redactedHeaders['Authorization'] = 'Bearer [REDACTED]';
      }

      _logger.d(
        '→ ${options.method} ${options.uri}\n'
        'Headers: $redactedHeaders\n'
        '${options.data != null ? 'Body: ${options.data}' : ''}',
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.i(
        '← ${response.statusCode} ${response.requestOptions.uri}\n'
        'Body: ${_truncate(response.data?.toString() ?? '')}',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.e(
        '✕ ${err.requestOptions.method} ${err.requestOptions.uri}\n'
        'Type: ${err.type}\n'
        'Status: ${err.response?.statusCode}\n'
        'Body: ${_truncate(err.response?.data?.toString() ?? err.message ?? '')}',
        error: err.error,
      );
    }
    handler.next(err);
  }

  String _truncate(String s, {int maxLen = 500}) =>
      s.length > maxLen ? '${s.substring(0, maxLen)}…' : s;
}
