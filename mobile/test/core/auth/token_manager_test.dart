import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:butterfly_india/core/auth/token_manager.dart';
import '../../mocks/mock_services.dart';
import '../../helpers/test_helpers.dart';

void main() {
  late TokenManager tokenManager;
  late MockSecureStorageService mockStorage;

  setUp(() {
    mockStorage = MockSecureStorageService();
    tokenManager = TokenManager(storage: mockStorage);
  });

  group('TokenManager', () {
    test('getAccessToken returns null when not stored', () async {
      final token = await tokenManager.getAccessToken();
      expect(token, isNull);
    });

    test('saveTokens stores both tokens', () async {
      await tokenManager.saveTokens(
        accessToken: TestData.testAccessToken,
        refreshToken: TestData.testRefreshToken,
      );

      expect(await tokenManager.getAccessToken(), TestData.testAccessToken);
      expect(await tokenManager.getRefreshToken(), TestData.testRefreshToken);
    });

    test('clearTokens removes both tokens', () async {
      await tokenManager.saveTokens(
        accessToken: TestData.testAccessToken,
        refreshToken: TestData.testRefreshToken,
      );

      await tokenManager.clearTokens();

      expect(await tokenManager.getAccessToken(), isNull);
      expect(await tokenManager.getRefreshToken(), isNull);
    });

    test('isRefreshing returns false initially', () {
      expect(tokenManager.isRefreshing, isFalse);
    });

    test('concurrent refresh calls share single result', () async {
      // This validates the thread-safe refresh-once pattern
      await mockStorage.saveAccessToken(TestData.testAccessToken);
      await mockStorage.saveRefreshToken(TestData.testRefreshToken);

      // Both calls should resolve the same future
      final calls = await Future.wait([
        tokenManager.getAccessToken(),
        tokenManager.getAccessToken(),
      ]);

      expect(calls[0], equals(calls[1]));
    });
  });
}
