import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:butterfly_india/core/errors/failure.dart';
import 'package:butterfly_india/features/auth/domain/entities/user_entity.dart';
import 'package:butterfly_india/features/profile/data/repositories/profile_repository.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// FAKE PROFILE REPOSITORY — deterministic, in-memory.
/// ─────────────────────────────────────────────────────────────────────────────

class FakeProfileRepository implements IProfileRepository {
  FakeProfileRepository({
    this.failUpdate = false,
    this.usernameTaken = false,
    this.failPassword = false,
    this.failDelete = false,
  });

  bool failUpdate;
  bool usernameTaken;
  bool failPassword;
  bool failDelete;

  int updateCalls = 0;
  int passwordCalls = 0;
  int avatarCalls = 0;
  int deleteCalls = 0;

  static const _base = UserEntity(
    id: 'u-1',
    username: 'asha',
    email: 'asha@example.com',
    fullName: 'Asha Nair',
    bio: 'Lepidoptera lover',
    isVerified: true,
  );

  @override
  Future<Either<Failure, UserEntity>> getMyProfile() async =>
      const Right(_base);

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    String? fullName,
    String? username,
    String? bio,
    int? preferredStateId,
  }) async {
    updateCalls++;
    if (usernameTaken) {
      return const Left(ValidationFailure(
        message: 'Username is already taken.',
        fieldErrors: {'username': ['Username is already taken.']},
      ));
    }
    if (failUpdate) return const Left(ServerFailure(message: 'update boom'));
    return Right(UserEntity(
      id: _base.id,
      username: username ?? _base.username,
      email: _base.email,
      fullName: fullName ?? _base.fullName,
      bio: bio ?? _base.bio,
      isVerified: _base.isVerified,
    ));
  }

  @override
  Future<Either<Failure, UserEntity>> uploadAvatar(File image) async {
    avatarCalls++;
    if (failUpdate) return const Left(ServerFailure(message: 'avatar boom'));
    return const Right(UserEntity(
      id: 'u-1',
      username: 'asha',
      email: 'asha@example.com',
      fullName: 'Asha Nair',
      profileImageUrl: 'https://cdn.example.com/avatar.jpg',
    ));
  }

  @override
  Future<Either<Failure, Unit>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    passwordCalls++;
    if (failPassword) {
      return const Left(AuthFailure(message: 'Current password is incorrect.'));
    }
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> deleteAccount() async {
    deleteCalls++;
    if (failDelete) return const Left(ServerFailure(message: 'delete boom'));
    return const Right(unit);
  }
}
