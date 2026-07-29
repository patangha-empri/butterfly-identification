import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:butterfly_india/core/errors/failure.dart';
import 'package:butterfly_india/core/errors/app_exception.dart';
import 'package:butterfly_india/features/auth/data/models/user_model.dart';
import 'package:butterfly_india/features/auth/data/repositories/auth_repository_impl.dart';
import '../../mocks/mock_services.dart';
import '../../helpers/test_helpers.dart';

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockDataSource;
  late MockTokenManager mockTokenManager;

  setUp(() {
    mockDataSource = MockAuthRemoteDataSource();
    mockTokenManager = MockTokenManager();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockDataSource,
      tokenManager: mockTokenManager,
    );
  });

  final testAuthTokens = AuthTokensModel.fromJson(TestData.authTokensJson());
  final testUser = UserModel.fromJson(TestData.userJson());

  group('AuthRepository.login', () {
    test('returns UserEntity on successful login', () async {
      when(() => mockDataSource.login(
            email: TestData.testEmail,
            password: TestData.testPassword,
          )).thenAnswer((_) async => testAuthTokens);

      final result = await repository.login(
        email: TestData.testEmail,
        password: TestData.testPassword,
      );

      expect(result, isA<Right>());
      result.fold(
        (f) => fail('Expected success but got failure: $f'),
        (user) {
          expect(user.email, TestData.testEmail);
          expect(user.fullName, TestData.testFullName);
        },
      );
    });

    test('saves tokens on successful login', () async {
      when(() => mockDataSource.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => testAuthTokens);

      await repository.login(
        email: TestData.testEmail,
        password: TestData.testPassword,
      );

      // MockTokenManager stores tokens in memory — verify by reading
      expect(
        await mockTokenManager.getAccessToken(),
        TestData.testAccessToken,
      );
      expect(
        await mockTokenManager.getRefreshToken(),
        TestData.testRefreshToken,
      );
    });

    test('returns AuthFailure on UnauthorizedException', () async {
      when(() => mockDataSource.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(const UnauthorizedException());

      final result = await repository.login(
        email: TestData.testEmail,
        password: 'wrong-password',
      );

      expect(result, isA<Left>());
      result.fold(
        (f) => expect(f, isA<AuthFailure>()),
        (_) => fail('Expected failure'),
      );
    });

    test('returns ValidationFailure on ValidationException', () async {
      when(() => mockDataSource.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(const ValidationException(
        message: 'Invalid email',
        fieldErrors: {'email': ['Invalid format']},
      ));

      final result = await repository.login(
        email: 'bad-email',
        password: TestData.testPassword,
      );

      expect(result, isA<Left>());
      result.fold(
        (f) => expect(f, isA<ValidationFailure>()),
        (_) => fail('Expected failure'),
      );
    });
  });

  group('AuthRepository.restoreSession', () {
    test('returns UserEntity when valid token exists', () async {
      mockTokenManager.setTokens(
        TestData.testAccessToken,
        TestData.testRefreshToken,
      );

      when(() => mockDataSource.getCurrentUser())
          .thenAnswer((_) async => testUser);

      final result = await repository.restoreSession();

      expect(result, isA<Right>());
    });

    test('returns AuthFailure when no token stored', () async {
      // No tokens set — empty storage
      final result = await repository.restoreSession();

      expect(result, isA<Left>());
      result.fold(
        (f) => expect(f, isA<AuthFailure>()),
        (_) => fail('Expected failure'),
      );
    });
  });

  group('AuthRepository.logout', () {
    test('clears tokens even if remote logout fails', () async {
      when(() => mockDataSource.logout())
          .thenThrow(const NetworkException());

      // Pre-populate tokens
      await mockTokenManager.saveTokens(
        accessToken: TestData.testAccessToken,
        refreshToken: TestData.testRefreshToken,
      );

      final result = await repository.logout();

      // Should still succeed (Right<void>)
      expect(result, isA<Right>());

      // Tokens should be cleared
      expect(await mockTokenManager.getAccessToken(), isNull);
    });
  });

  group('AuthRepository.isAuthenticated', () {
    test('returns true when access token exists', () async {
      mockTokenManager.setTokens(
        TestData.testAccessToken,
        TestData.testRefreshToken,
      );

      final result = await repository.isAuthenticated();
      expect(result, isTrue);
    });

    test('returns false when no access token', () async {
      final result = await repository.isAuthenticated();
      expect(result, isFalse);
    });
  });
}
