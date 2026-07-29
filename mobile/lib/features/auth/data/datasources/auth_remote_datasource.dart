import 'package:dio/dio.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/api/dio_client.dart';
import '../models/user_model.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// AUTH REMOTE DATASOURCE
/// Raw HTTP calls that return typed models — no domain logic here.
/// ─────────────────────────────────────────────────────────────────────────────

abstract class IAuthRemoteDataSource {
  Future<AuthTokensModel> login({
    required String email,
    required String password,
  });

  Future<AuthTokensModel> register({
    required String email,
    required String password,
    required String fullName,
    required String username,
  });

  Future<void> logout();

  Future<UserModel> getCurrentUser();

  Future<void> forgotPassword(String email);

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<UserModel> updateProfile({
    String? fullName,
    String? bio,
  });
}

class AuthRemoteDataSource implements IAuthRemoteDataSource {
  AuthRemoteDataSource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<AuthTokensModel> login({
    required String email,
    required String password,
  }) async {
    final result = await safeApiCall(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      return AuthTokensModel.fromJson(response.data!['data'] as Map<String, dynamic>);
    });

    return result.fold(
      onError: (e) => throw e,
      onSuccess: (data) => data,
    );
  }

  @override
  Future<AuthTokensModel> register({
    required String email,
    required String password,
    required String fullName,
    required String username,
  }) async {
    final registerResult = await safeApiCall(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.register,
        data: {
          'email': email,
          'password': password,
          'full_name': fullName,
          'username': username,
        },
      );
      return AuthTokensModel.fromJson(response.data!['data'] as Map<String, dynamic>);
    });

    return registerResult.fold(
      onError: (e) => throw e,
      onSuccess: (data) => data,
    );
  }

  @override
  Future<void> logout() async {
    await safeApiCall(() => _dio.post<void>(ApiEndpoints.logout));
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final result = await safeApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.me);
      return UserModel.fromJson(response.data!['data'] as Map<String, dynamic>);
    });

    return result.fold(
      onError: (e) => throw e,
      onSuccess: (data) => data,
    );
  }

  @override
  Future<void> forgotPassword(String email) async {
    await safeApiCall(
      () => _dio.post<void>(ApiEndpoints.forgotPassword, data: {'email': email}),
    );
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await safeApiCall(
      () => _dio.post<void>(
        ApiEndpoints.resetPassword,
        data: {'token': token, 'password': newPassword},
      ),
    );
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await safeApiCall(
      () => _dio.post<void>(
        ApiEndpoints.changePassword,
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      ),
    );
  }

  @override
  Future<UserModel> updateProfile({
    String? fullName,
    String? bio,
  }) async {
    final result = await safeApiCall(() async {
      final response = await _dio.patch<Map<String, dynamic>>(
        ApiEndpoints.updateProfile,
        data: {
          if (fullName != null) 'full_name': fullName,
          if (bio != null) 'bio': bio,
        },
      );
      return UserModel.fromJson(response.data!['data'] as Map<String, dynamic>);
    });

    return result.fold(
      onError: (e) => throw e,
      onSuccess: (data) => data,
    );
  }
}
