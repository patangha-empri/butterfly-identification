import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// PROFILE PROVIDERS
/// ─────────────────────────────────────────────────────────────────────────────

final profileRemoteDataSourceProvider = Provider<IProfileRemoteDataSource>(
  (ref) => ProfileRemoteDataSource(dio: ref.read(dioProvider)),
  name: 'profileRemoteDataSource',
);

final profileRepositoryProvider = Provider<IProfileRepository>(
  (ref) => ProfileRepository(remote: ref.read(profileRemoteDataSourceProvider)),
  name: 'profileRepository',
);

final myProfileProvider = FutureProvider.autoDispose<UserEntity>((ref) async {
  final result = await ref.read(profileRepositoryProvider).getMyProfile();
  return result.fold(
    (f) {
      if (f is AuthFailure || f.message.toLowerCase().contains('not found')) {
        Future.microtask(() {
          ref.read(authStateNotifierProvider.notifier).onSessionExpired();
        });
      }
      final cached = ref.read(currentUserProvider);
      if (cached != null) return cached;
      throw ProfileException(f.message);
    },
    (user) {
      // Keep the global current-user in sync with the server truth.
      ref.read(currentUserProvider.notifier).state = user;
      return user;
    },
  );
}, name: 'myProfile');

// ── Edit profile ────────────────────────────────────────────────────────────────

enum EditStatus { idle, saving, success, error }

class EditProfileState {
  const EditProfileState({
    this.status = EditStatus.idle,
    this.error,
    this.fieldErrors = const {},
  });

  final EditStatus status;
  final String? error;
  final Map<String, String> fieldErrors;

  bool get isSaving => status == EditStatus.saving;

  EditProfileState copyWith({
    EditStatus? status,
    String? error,
    Map<String, String>? fieldErrors,
  }) =>
      EditProfileState(
        status: status ?? this.status,
        error: error,
        fieldErrors: fieldErrors ?? this.fieldErrors,
      );
}

class EditProfileNotifier extends StateNotifier<EditProfileState> {
  EditProfileNotifier(this._repo, this._ref)
      : super(const EditProfileState());

  final IProfileRepository _repo;
  final Ref _ref;

  Future<bool> save({
    String? fullName,
    String? username,
    String? bio,
    int? preferredStateId,
  }) async {
    state = const EditProfileState(status: EditStatus.saving);
    final result = await _repo.updateProfile(
      fullName: fullName,
      username: username,
      bio: bio,
      preferredStateId: preferredStateId,
    );
    return result.fold(
      (f) {
        state = EditProfileState(
          status: EditStatus.error,
          error: f.message,
          fieldErrors: _fieldErrors(f),
        );
        return false;
      },
      (user) {
        _ref.read(currentUserProvider.notifier).state = user;
        state = const EditProfileState(status: EditStatus.success);
        return true;
      },
    );
  }

  Future<bool> uploadAvatar(File image) async {
    state = const EditProfileState(status: EditStatus.saving);
    final result = await _repo.uploadAvatar(image);
    return result.fold(
      (f) {
        state = EditProfileState(status: EditStatus.error, error: f.message);
        return false;
      },
      (user) {
        _ref.read(currentUserProvider.notifier).state = user;
        state = const EditProfileState(status: EditStatus.success);
        return true;
      },
    );
  }

  Map<String, String> _fieldErrors(Failure f) {
    final out = <String, String>{};
    if (f is ValidationFailure) {
      f.fieldErrors.forEach((k, v) {
        if (v.isNotEmpty) {
          out[k == 'full_name' ? 'fullName' : k] = v.first;
        }
      });
    } else if (f.message.toLowerCase().contains('username')) {
      out['username'] = f.message;
    }
    return out;
  }
}

final editProfileNotifierProvider =
    StateNotifierProvider.autoDispose<EditProfileNotifier, EditProfileState>(
  (ref) => EditProfileNotifier(ref.read(profileRepositoryProvider), ref),
  name: 'editProfileNotifier',
);

// ── Change password ───────────────────────────────────────────────────────────

enum PasswordStatus { idle, saving, success, error }

class ChangePasswordState {
  const ChangePasswordState({this.status = PasswordStatus.idle, this.error});
  final PasswordStatus status;
  final String? error;

  bool get isSaving => status == PasswordStatus.saving;
}

class ChangePasswordNotifier extends StateNotifier<ChangePasswordState> {
  ChangePasswordNotifier(this._repo) : super(const ChangePasswordState());

  final IProfileRepository _repo;

  Future<bool> submit({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = const ChangePasswordState(status: PasswordStatus.saving);
    final result = await _repo.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    return result.fold(
      (f) {
        state = ChangePasswordState(
            status: PasswordStatus.error, error: f.message);
        return false;
      },
      (_) {
        state = const ChangePasswordState(status: PasswordStatus.success);
        return true;
      },
    );
  }
}

final changePasswordNotifierProvider = StateNotifierProvider.autoDispose<
    ChangePasswordNotifier, ChangePasswordState>(
  (ref) => ChangePasswordNotifier(ref.read(profileRepositoryProvider)),
  name: 'changePasswordNotifier',
);

class ProfileException implements Exception {
  ProfileException(this.message);
  final String message;
  @override
  String toString() => message;
}
