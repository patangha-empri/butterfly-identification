import 'package:dartz/dartz.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/errors/failure.dart';
import 'models/notification_preferences.dart';
import 'notification_remote_datasource.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// NOTIFICATION REPOSITORY
/// ─────────────────────────────────────────────────────────────────────────────

abstract class INotificationRepository {
  Future<Either<Failure, NotificationPage>> getNotifications({int page});
  Future<Either<Failure, void>> markRead(String id);
  Future<Either<Failure, void>> markAllRead();
  Future<Either<Failure, NotificationPreferences>> getPreferences();
  Future<Either<Failure, NotificationPreferences>> updatePreferences(
      NotificationPreferences prefs);
}

class NotificationRepository implements INotificationRepository {
  NotificationRepository({required INotificationRemoteDataSource remote})
      : _remote = remote;

  final INotificationRemoteDataSource _remote;

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() fn) async {
    try {
      return Right(await fn());
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(ExceptionMapper.fromObject(e).toFailure());
    }
  }

  @override
  Future<Either<Failure, NotificationPage>> getNotifications({int page = 1}) =>
      _guard(() => _remote.fetch(page: page));

  @override
  Future<Either<Failure, void>> markRead(String id) =>
      _guard(() => _remote.markRead(id));

  @override
  Future<Either<Failure, void>> markAllRead() =>
      _guard(() => _remote.markAllRead());

  @override
  Future<Either<Failure, NotificationPreferences>> getPreferences() =>
      _guard(() => _remote.getPreferences());

  @override
  Future<Either<Failure, NotificationPreferences>> updatePreferences(
          NotificationPreferences prefs) =>
      _guard(() => _remote.updatePreferences(prefs));
}
