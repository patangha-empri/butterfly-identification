import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../errors/app_exception.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// SECURE STORAGE SERVICE
/// Wraps flutter_secure_storage with typed methods for auth tokens.
/// ─────────────────────────────────────────────────────────────────────────────

abstract class ISecureStorageService {
  Future<void> saveAccessToken(String token);
  Future<void> saveRefreshToken(String token);
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> clearTokens();
  Future<void> saveString(String key, String value);
  Future<String?> getString(String key);
  Future<void> deleteKey(String key);
  Future<void> clearAll();
}

class SecureStorageService implements ISecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  final FlutterSecureStorage _storage;

  // ── Key constants ─────────────────────────────────────────────────────────
  static const String _accessTokenKey = 'auth_access_token';
  static const String _refreshTokenKey = 'auth_refresh_token';

  @override
  Future<void> saveAccessToken(String token) =>
      _wrap(() => _storage.write(key: _accessTokenKey, value: token));

  @override
  Future<void> saveRefreshToken(String token) =>
      _wrap(() => _storage.write(key: _refreshTokenKey, value: token));

  @override
  Future<String?> getAccessToken() =>
      _wrap(() => _storage.read(key: _accessTokenKey));

  @override
  Future<String?> getRefreshToken() =>
      _wrap(() => _storage.read(key: _refreshTokenKey));

  @override
  Future<void> clearTokens() async {
    await _wrap(() => _storage.delete(key: _accessTokenKey));
    await _wrap(() => _storage.delete(key: _refreshTokenKey));
  }

  @override
  Future<void> saveString(String key, String value) =>
      _wrap(() => _storage.write(key: key, value: value));

  @override
  Future<String?> getString(String key) =>
      _wrap(() => _storage.read(key: key));

  @override
  Future<void> deleteKey(String key) =>
      _wrap(() => _storage.delete(key: key));

  @override
  Future<void> clearAll() => _wrap(() => _storage.deleteAll());

  // ── Helpers ───────────────────────────────────────────────────────────────
  Future<T> _wrap<T>(Future<T> Function() fn) async {
    try {
      return await fn();
    } catch (e) {
      throw StorageException(
        message: 'Secure storage operation failed: $e',
        details: e,
      );
    }
  }
}
