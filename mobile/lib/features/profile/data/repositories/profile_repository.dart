import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../datasources/profile_remote_datasource.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// PROFILE REPOSITORY — Either<Failure, T> over the profile datasource.
/// Returns domain UserEntity so the rest of the app stays decoupled from JSON.
/// ─────────────────────────────────────────────────────────────────────────────

abstract class IProfileRepository {
  Future<Either<Failure, UserEntity>> getMyProfile();
  Future<Either<Failure, UserEntity>> updateProfile({
    String? fullName,
    String? username,
    String? bio,
    int? preferredStateId,
  });
  Future<Either<Failure, UserEntity>> uploadAvatar(File image);
  Future<Either<Failure, Unit>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
  Future<Either<Failure, Unit>> deleteAccount();
}

class ProfileRepository implements IProfileRepository {
  ProfileRepository({required IProfileRemoteDataSource remote})
      : _remote = remote;

  final IProfileRemoteDataSource _remote;

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() run) async {
    try {
      return Right(await run());
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(ExceptionMapper.fromObject(e).toFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getMyProfile() =>
      _guard(() async => (await _remote.getMyProfile()).toEntity());

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    String? fullName,
    String? username,
    String? bio,
    int? preferredStateId,
  }) {
    final body = <String, dynamic>{
      if (fullName != null) 'full_name': fullName,
      if (username != null) 'username': username,
      if (bio != null) 'bio': bio,
      if (preferredStateId != null) 'preferred_state_id': preferredStateId,
    };
    return _guard(() async => (await _remote.updateProfile(body)).toEntity());
  }

  @override
  Future<Either<Failure, UserEntity>> uploadAvatar(File image) =>
      _guard(() async => (await _remote.uploadAvatar(image)).toEntity());

  @override
  Future<Either<Failure, Unit>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) =>
      _guard(() async {
        await _remote.changePassword(currentPassword, newPassword);
        return unit;
      });

  @override
  Future<Either<Failure, Unit>> deleteAccount() => _guard(() async {
        await _remote.deleteAccount();
        return unit;
      });
}
