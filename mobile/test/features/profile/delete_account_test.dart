import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/core/errors/app_exception.dart';
import 'package:butterfly_india/features/auth/data/models/user_model.dart';
import 'package:butterfly_india/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:butterfly_india/features/profile/data/repositories/profile_repository.dart';

class _FakeProfileDataSource implements IProfileRemoteDataSource {
  _FakeProfileDataSource({this.throwOnDelete});
  final AppException? throwOnDelete;
  int deleteCalls = 0;

  @override
  Future<void> deleteAccount() async {
    deleteCalls++;
    if (throwOnDelete != null) throw throwOnDelete!;
  }

  @override
  Future<UserModel> getMyProfile() => throw UnimplementedError();
  @override
  Future<UserModel> updateProfile(Map<String, dynamic> body) =>
      throw UnimplementedError();
  @override
  Future<UserModel> uploadAvatar(File image) => throw UnimplementedError();
  @override
  Future<void> changePassword(String c, String n) => throw UnimplementedError();
}

void main() {
  test('deleteAccount returns Right on success and calls the datasource',
      () async {
    final ds = _FakeProfileDataSource();
    final repo = ProfileRepository(remote: ds);

    final result = await repo.deleteAccount();

    expect(ds.deleteCalls, 1);
    expect(result.isRight(), isTrue);
  });

  test('deleteAccount maps an exception to a Left failure', () async {
    final ds = _FakeProfileDataSource(
      throwOnDelete: const ServerException(message: 'boom'),
    );
    final repo = ProfileRepository(remote: ds);

    final result = await repo.deleteAccount();

    expect(result.isLeft(), isTrue);
  });
}
