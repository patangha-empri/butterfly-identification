import 'dart:async';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:butterfly_india/core/auth/secure_storage_service.dart';
import 'package:butterfly_india/core/auth/token_manager.dart';
import 'package:butterfly_india/core/network/connectivity_service.dart';
import 'package:butterfly_india/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:butterfly_india/features/auth/domain/repositories/i_auth_repository.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// MOCK SERVICES (Mocktail)
/// ─────────────────────────────────────────────────────────────────────────────

// ── Core infrastructure mocks ─────────────────────────────────────────────────

class MockSecureStorageService extends Mock implements ISecureStorageService {
  final _store = <String, String>{};

  @override
  Future<void> saveAccessToken(String token) async => _store['access'] = token;

  @override
  Future<void> saveRefreshToken(String token) async => _store['refresh'] = token;

  @override
  Future<String?> getAccessToken() async => _store['access'];

  @override
  Future<String?> getRefreshToken() async => _store['refresh'];

  @override
  Future<void> clearTokens() async {
    _store.remove('access');
    _store.remove('refresh');
  }

  @override
  Future<void> saveString(String key, String value) async => _store[key] = value;

  @override
  Future<String?> getString(String key) async => _store[key];

  @override
  Future<void> deleteKey(String key) async => _store.remove(key);

  @override
  Future<void> clearAll() async => _store.clear();
}

class MockTokenManager extends Mock implements ITokenManager {
  String? _accessToken;
  String? _refreshToken;
  bool _refreshing = false;

  @override
  Future<String?> getAccessToken() async => _accessToken;

  @override
  Future<String?> getRefreshToken() async => _refreshToken;

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  @override
  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
  }

  @override
  Future<String?> refreshAccessToken(Dio dio) async => _accessToken;

  @override
  bool get isRefreshing => _refreshing;

  void setTokens(String access, String refresh) {
    _accessToken = access;
    _refreshToken = refresh;
  }
}

class MockConnectivityService extends Mock implements IConnectivityService {
  ConnectivityStatus _status = ConnectivityStatus.online;
  final _controller = StreamController<ConnectivityStatus>.broadcast();

  @override
  Stream<ConnectivityStatus> get statusStream => _controller.stream;

  @override
  Future<ConnectivityStatus> get currentStatus async => _status;

  @override
  bool get isOnline => _status == ConnectivityStatus.online;

  void setStatus(ConnectivityStatus status) {
    _status = status;
    _controller.add(status);
  }

  void dispose() => _controller.close();
}

// ── Auth mocks ────────────────────────────────────────────────────────────────

class MockAuthRemoteDataSource extends Mock implements IAuthRemoteDataSource {}

class MockAuthRepository extends Mock implements IAuthRepository {}

// ── Dio mock helper ───────────────────────────────────────────────────────────

Dio createMockDio({String baseUrl = 'http://localhost:5000'}) {
  return Dio(BaseOptions(baseUrl: baseUrl))
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Default: pass through
          handler.next(options);
        },
      ),
    );
}

class MockDio extends Mock implements Dio {}
