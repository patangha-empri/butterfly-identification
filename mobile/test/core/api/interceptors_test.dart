import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/core/api/interceptors/auth_interceptor.dart';
import 'package:butterfly_india/core/api/interceptors/retry_interceptor.dart';
import '../../mocks/mock_services.dart';
import '../../helpers/test_helpers.dart';

/// A fake HttpClientAdapter that captures the outgoing request and returns a
/// configurable canned response. Lets us verify interceptor behavior end-to-end
/// without real network access.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter({this.statusCode = 200, this.body = '{"success":true}'});

  int statusCode;
  String body;
  final List<RequestOptions> requests = [];
  int callCount = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    callCount++;
    return ResponseBody.fromString(
      body,
      statusCode,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  group('AuthInterceptor', () {
    late MockTokenManager tokenManager;
    late Dio dio;
    late _FakeAdapter adapter;

    setUp(() {
      tokenManager = MockTokenManager();
      dio = Dio(BaseOptions(baseUrl: 'http://test.local'));
      adapter = _FakeAdapter();
      dio.httpClientAdapter = adapter;
      dio.interceptors.add(
        AuthInterceptor(tokenManager: tokenManager, dio: dio),
      );
    });

    test('adds Authorization header when token present', () async {
      tokenManager.setTokens(TestData.testAccessToken, TestData.testRefreshToken);

      await dio.get<dynamic>('/protected');

      expect(adapter.requests.single.headers['Authorization'],
          'Bearer ${TestData.testAccessToken}');
    });

    test('omits Authorization header when no token', () async {
      await dio.get<dynamic>('/public');

      expect(
        adapter.requests.single.headers.containsKey('Authorization'),
        isFalse,
      );
    });

    test('calls onUnauthorized when refresh has no token', () async {
      var unauthorizedCalled = false;
      final freshDio = Dio(BaseOptions(baseUrl: 'http://test.local'));
      final failAdapter = _FakeAdapter(statusCode: 401, body: '{"message":"expired"}');
      freshDio.httpClientAdapter = failAdapter;
      freshDio.interceptors.add(
        AuthInterceptor(
          tokenManager: tokenManager, // empty tokens → refresh fails
          dio: freshDio,
          onUnauthorized: () => unauthorizedCalled = true,
        ),
      );

      try {
        await freshDio.get<dynamic>('/protected');
      } catch (_) {/* expected */}

      expect(unauthorizedCalled, isTrue);
    });
  });

  group('RetryInterceptor', () {
    test('retries on 5xx then succeeds', () async {
      final dio = Dio(BaseOptions(baseUrl: 'http://test.local'));
      final adapter = _FlakyAdapter(failTimes: 2, failStatus: 503);
      dio.httpClientAdapter = adapter;
      dio.interceptors.add(
        RetryInterceptor(
          dio: dio,
          maxRetries: 3,
          retryDelayMs: 1,
          useExponentialBackoff: false,
        ),
      );

      final response = await dio.get<dynamic>('/flaky');

      expect(response.statusCode, 200);
      expect(adapter.callCount, 3); // 2 failures + 1 success
    });

    test('does not retry 400 client errors', () async {
      final dio = Dio(BaseOptions(
        baseUrl: 'http://test.local',
        validateStatus: (_) => true, // don't throw on 400
      ));
      final adapter = _FakeAdapter(statusCode: 400, body: '{"message":"bad"}');
      dio.httpClientAdapter = adapter;
      dio.interceptors.add(
        RetryInterceptor(dio: dio, maxRetries: 3, retryDelayMs: 1),
      );

      await dio.get<dynamic>('/bad');

      expect(adapter.callCount, 1); // no retries
    });

    test('gives up after maxRetries', () async {
      final dio = Dio(BaseOptions(baseUrl: 'http://test.local'));
      final adapter = _FlakyAdapter(failTimes: 99, failStatus: 500);
      dio.httpClientAdapter = adapter;
      dio.interceptors.add(
        RetryInterceptor(
          dio: dio,
          maxRetries: 2,
          retryDelayMs: 1,
          useExponentialBackoff: false,
        ),
      );

      try {
        await dio.get<dynamic>('/always-fails');
      } catch (_) {/* expected */}

      // 1 initial + 2 retries = 3 attempts
      expect(adapter.callCount, 3);
    });
  });
}

/// Adapter that fails [failTimes] then returns 200.
class _FlakyAdapter implements HttpClientAdapter {
  _FlakyAdapter({required this.failTimes, this.failStatus = 500});

  final int failTimes;
  final int failStatus;
  int callCount = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    callCount++;
    final status = callCount <= failTimes ? failStatus : 200;
    return ResponseBody.fromString(
      '{"success": ${status == 200}}',
      status,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
