import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../api/dio_client.dart';
import '../auth/secure_storage_service.dart';
import '../auth/token_manager.dart';
import '../database/app_database.dart';
import '../network/connectivity_service.dart';
import '../services/app_preferences.dart';
import '../services/location_service.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// CORE PROVIDERS
/// Infrastructure-layer singleton providers — consumed by all feature layers.
/// ─────────────────────────────────────────────────────────────────────────────

// ── Database ──────────────────────────────────────────────────────────────────

final appDatabaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('Override in bootstrap'),
  name: 'appDatabase',
);

// ── App Preferences ───────────────────────────────────────────────────────────

final appPreferencesProvider = Provider<IAppPreferences>(
  (ref) => throw UnimplementedError('Override in bootstrap'),
  name: 'appPreferences',
);

// ── Location Service (real GPS via geolocator) ────────────────────────────────

final locationServiceProvider = Provider<ILocationService>(
  (ref) => const GeolocatorLocationService(),
  name: 'locationService',
);

// ── Secure Storage ────────────────────────────────────────────────────────────

final secureStorageProvider = Provider<ISecureStorageService>(
  (ref) => SecureStorageService(),
  name: 'secureStorage',
);

// ── Token Manager ─────────────────────────────────────────────────────────────

final tokenManagerProvider = Provider<ITokenManager>(
  (ref) => TokenManager(storage: ref.read(secureStorageProvider)),
  name: 'tokenManager',
);

// ── Dio HTTP Client ───────────────────────────────────────────────────────────

final dioProvider = Provider<Dio>((ref) {
  final baseUrl = _resolveBaseUrl();
  final tokenManager = ref.read(tokenManagerProvider);

  return DioClient.create(
    baseUrl: baseUrl,
    tokenManager: tokenManager,
    onUnauthorized: () {
      // Invalidate auth state — handled in authStateProvider
      ref.read(authStateNotifierProvider.notifier).onSessionExpired();
    },
  );
}, name: 'dio');

// ── Connectivity ──────────────────────────────────────────────────────────────

final connectivityServiceProvider = Provider<IConnectivityService>(
  (ref) {
    final service = ConnectivityService();
    ref.onDispose(service.dispose);
    return service;
  },
  name: 'connectivity',
);

final connectivityStatusProvider = StreamProvider<ConnectivityStatus>(
  (ref) => ref.watch(connectivityServiceProvider).statusStream,
  name: 'connectivityStatus',
);

final isOnlineProvider = Provider<bool>(
  (ref) => ref.watch(connectivityStatusProvider).valueOrNull ==
      ConnectivityStatus.online,
  name: 'isOnline',
);

// ── App initialization ────────────────────────────────────────────────────────

final appInitProvider = FutureProvider<void>((ref) async {
  // 1. Restore auth session from secure storage
  await ref.read(authStateNotifierProvider.notifier).restoreSession();

  // 2. Warm up DB (already lazily opened — just ensure it's ready)
  await ref.read(appDatabaseProvider).customSelect('SELECT 1').get();
}, name: 'appInit');

// ── Environment helper ────────────────────────────────────────────────────────

String _resolveBaseUrl() {
  const env = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  return switch (env) {
    'prod' => DioConfig.prodBaseUrl,
    'staging' => DioConfig.stagingBaseUrl,
    _ => DioConfig.devBaseUrl,
  };
}

// ── Auth state listenable (for GoRouter refresh) ──────────────────────────────

/// A ChangeNotifier that GoRouter listens to for redirect re-evaluation.
class AuthStateListenable extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  void setLoggedIn(bool value) {
    if (_isLoggedIn == value) return;
    _isLoggedIn = value;
    notifyListeners();
  }
}

final authStateListenableProvider = Provider<AuthStateListenable>(
  (ref) => AuthStateListenable(),
  name: 'authStateListenable',
);

// ── Auth state notifier (stub — expanded in Phase 2) ─────────────────────────

class _AuthStateNotifier extends Notifier<_AuthState> {
  @override
  _AuthState build() => const _AuthState(isLoading: true);

  Future<void> restoreSession() async {
    final tokenManager = ref.read(tokenManagerProvider);
    final token = await tokenManager.getAccessToken();
    final isLoggedIn = token != null && token.isNotEmpty;

    ref.read(authStateListenableProvider).setLoggedIn(isLoggedIn);
    state = _AuthState(isLoading: false, isAuthenticated: isLoggedIn);
  }

  void onSessionExpired() {
    ref.read(tokenManagerProvider).clearTokens();
    ref.read(authStateListenableProvider).setLoggedIn(false);
    state = const _AuthState(isLoading: false, isAuthenticated: false);
  }

  void onLoggedIn() {
    ref.read(authStateListenableProvider).setLoggedIn(true);
    state = const _AuthState(isLoading: false, isAuthenticated: true);
  }

  void onLoggedOut() {
    ref.read(tokenManagerProvider).clearTokens();
    ref.read(authStateListenableProvider).setLoggedIn(false);
    state = const _AuthState(isLoading: false, isAuthenticated: false);
  }
}

class _AuthState {
  const _AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
  });
  final bool isLoading;
  final bool isAuthenticated;
}

final authStateNotifierProvider =
    NotifierProvider<_AuthStateNotifier, _AuthState>(
  _AuthStateNotifier.new,
  name: 'authState',
);
