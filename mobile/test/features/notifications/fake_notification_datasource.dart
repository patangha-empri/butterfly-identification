import 'package:butterfly_india/features/notifications/data/models/app_notification.dart';
import 'package:butterfly_india/features/notifications/data/models/notification_preferences.dart';
import 'package:butterfly_india/features/notifications/data/notification_remote_datasource.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// FAKE NOTIFICATION REMOTE DATASOURCE
/// ─────────────────────────────────────────────────────────────────────────────

class FakeNotificationRemoteDataSource
    implements INotificationRemoteDataSource {
  FakeNotificationRemoteDataSource({this.fail = false, this.totalPages = 1});

  bool fail;
  int totalPages;
  int markReadCalls = 0;
  int markAllCalls = 0;
  NotificationPreferences? lastSavedPrefs;

  static AppNotification notif(String id, {bool read = false, String type = 'identification_complete'}) =>
      AppNotification(
        id: id,
        type: type,
        title: 'Notification $id',
        body: 'Body $id',
        isRead: read,
        createdAt: DateTime.now(),
        data: const {'observation_id': 'obs-1'},
      );

  @override
  Future<NotificationPage> fetch({int page = 1, int perPage = 30}) async {
    if (fail) throw Exception('network');
    return NotificationPage(
      items: [
        notif('${page}a', read: false),
        notif('${page}b', read: true),
      ],
      unreadCount: 3,
      hasMore: page < totalPages,
      page: page,
    );
  }

  @override
  Future<void> markRead(String id) async {
    markReadCalls++;
    if (fail) throw Exception('network');
  }

  @override
  Future<void> markAllRead() async {
    markAllCalls++;
    if (fail) throw Exception('network');
  }

  @override
  Future<NotificationPreferences> getPreferences() async {
    if (fail) throw Exception('network');
    return const NotificationPreferences();
  }

  @override
  Future<NotificationPreferences> updatePreferences(
      NotificationPreferences prefs) async {
    lastSavedPrefs = prefs;
    if (fail) throw Exception('network');
    return prefs;
  }
}
