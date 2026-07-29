import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import '../../../../core/api/api_endpoints.dart';
import '../../../auth/data/models/user_model.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// PROFILE REMOTE DATASOURCE
/// Wraps the /users/me + /auth/change-password endpoints. Reuses the auth
/// feature's UserModel since /users/me returns the same user shape.
/// ─────────────────────────────────────────────────────────────────────────────

abstract class IProfileRemoteDataSource {
  Future<UserModel> getMyProfile();
  Future<UserModel> updateProfile(Map<String, dynamic> body);
  Future<UserModel> uploadAvatar(File image);
  Future<void> changePassword(String currentPassword, String newPassword);
  Future<void> deleteAccount();
}

class ProfileRemoteDataSource implements IProfileRemoteDataSource {
  ProfileRemoteDataSource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Map<String, dynamic> _obj(Response<dynamic> res) {
    final data = res.data;
    if (data is Map<String, dynamic>) {
      final inner = data['data'];
      if (inner is Map<String, dynamic>) return inner;
      return data;
    }
    return <String, dynamic>{};
  }

  @override
  Future<UserModel> getMyProfile() async {
    final res = await _dio.get<dynamic>(ApiEndpoints.profile);
    return UserModel.fromJson(_obj(res));
  }

  @override
  Future<UserModel> updateProfile(Map<String, dynamic> body) async {
    final res = await _dio.put<dynamic>(ApiEndpoints.updateProfile, data: body);
    return UserModel.fromJson(_obj(res));
  }

  @override
  Future<UserModel> uploadAvatar(File image) async {
    final form = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        image.path,
        filename: p.basename(image.path),
      ),
    });
    final res = await _dio.post<dynamic>(
      ApiEndpoints.uploadAvatar,
      data: form,
      options: Options(contentType: 'multipart/form-data'),
    );
    return UserModel.fromJson(_obj(res));
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    await _dio.post<dynamic>(
      ApiEndpoints.changePassword,
      data: {
        'current_password': currentPassword,
        'new_password': newPassword,
      },
    );
  }

  @override
  Future<void> deleteAccount() async {
    await _dio.delete<dynamic>(ApiEndpoints.deleteAccount);
  }
}
