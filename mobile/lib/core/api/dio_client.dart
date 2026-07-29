import 'package:dio/dio.dart';
import '../auth/token_manager.dart';
import '../errors/app_exception.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/retry_interceptor.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// DIO CLIENT FACTORY
/// Creates and configures the single Dio instance used throughout the app.
///
/// Interceptor order (applied top → bottom):
///   1. LoggingInterceptor   — logs before any modification
///   2. RetryInterceptor     — catches network/5xx before auth
///   3. AuthInterceptor      — attaches token, handles 401 + refresh
/// ─────────────────────────────────────────────────────────────────────────────

abstract class DioConfig {
  // ── Timeouts ──────────────────────────────────────────────────────────────
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // ── Base URLs per environment ─────────────────────────────────────────────
  // Dev: PC's LAN IP so a physical device reaches the backend over Wi-Fi
  // (no `adb reverse` needed). Requirements:
  //   • phone + PC on the same Wi-Fi network
  //   • backend running with --host=0.0.0.0
  //   • Windows Firewall allows inbound TCP 5000 (Private profile)
  // If the PC's IP changes (DHCP), update it here.
  // Alternatives: emulator → http://10.0.2.2:5000 ; USB-only → http://localhost:5000 + adb reverse.
  // Loads from mobile/.env via --dart-define-from-file=.env
  static const String devBaseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://staging.thirdeyegfx.in/butterfly_backend',
  );
  static const String stagingBaseUrl = 'https://api.staging.butterflyindia.app';
  static const String prodBaseUrl = 'https://api.butterflyindia.app';
}

class DioClient {
  DioClient._();

  static Dio create({
    required String baseUrl,
    required ITokenManager tokenManager,
    void Function()? onUnauthorized,
    List<Interceptor>? additionalInterceptors,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: DioConfig.connectTimeout,
        receiveTimeout: DioConfig.receiveTimeout,
        sendTimeout: DioConfig.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-App-Platform': 'flutter',
          'X-App-Version': '1.0.0',
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        },
      ),
    );

    // Order matters — add lowest-priority first
    dio.interceptors.addAll([
      LoggingInterceptor(),
      RetryInterceptor(dio: dio),
      AuthInterceptor(
        tokenManager: tokenManager,
        dio: dio,
        onUnauthorized: onUnauthorized,
      ),
      ...?additionalInterceptors,
    ]);

    return dio;
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
/// API RESULT WRAPPER
/// Functional wrapper used in datasources: ApiResult<T> = Either<AppException, T>
/// ─────────────────────────────────────────────────────────────────────────────

typedef ApiResult<T> = ({T? data, AppException? error, bool isSuccess});

extension ApiResultX<T> on ApiResult<T> {
  bool get isFailure => !isSuccess;
  T get requireData => data!;

  R fold<R>({
    required R Function(AppException) onError,
    required R Function(T) onSuccess,
  }) {
    if (isSuccess && data != null) return onSuccess(data as T);
    return onError(error ?? const UnknownException());
  }
}

ApiResult<T> apiSuccess<T>(T data) =>
    (data: data, error: null, isSuccess: true);
ApiResult<T> apiError<T>(AppException e) =>
    (data: null, error: e, isSuccess: false);

/// Safe Dio call wrapper used inside datasources
Future<ApiResult<T>> safeApiCall<T>(
  Future<T> Function() call,
) async {
  try {
    final result = await call();
    return apiSuccess(result);
  } on DioException catch (e) {
    return apiError(ExceptionMapper.fromDioException(e));
  } catch (e) {
    return apiError(ExceptionMapper.fromObject(e));
  }
}
