import 'package:dio/dio.dart';
import '../../../core/api/api_endpoints.dart';
import 'models/app_notification.dart';
import 'models/notification_preferences.dart';

/// Page of notifications + the server-reported unread count.
class NotificationPage {
  const NotificationPage({
    required this.items,
    required this.unreadCount,
    required this.hasMore,
    required this.page,
  });
  final List<AppNotification> items;
  final int unreadCount;
  final bool hasMore;
  final int page;
}

/// ─────────────────────────────────────────────────────────────────────────────
/// NOTIFICATION REMOTE DATASOURCE
/// ─────────────────────────────────────────────────────────────────────────────

abstract class INotificationRemoteDataSource {
  Future<NotificationPage> fetch({int page, int perPage});
  Future<void> markRead(String id);
  Future<void> markAllRead();
  Future<NotificationPreferences> getPreferences();
  Future<NotificationPreferences> updatePreferences(
      NotificationPreferences prefs);
}

class NotificationRemoteDataSource implements INotificationRemoteDataSource {
  NotificationRemoteDataSource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<NotificationPage> fetch({int page = 1, int perPage = 30}) async {
    final res = await _dio.get<dynamic>(
      ApiEndpoints.notifications,
      queryParameters: {'page': page, 'per_page': perPage},
    );
    final data = res.data as Map<String, dynamic>;
    final raw = data['data'];
    final meta = (data['meta'] as Map<String, dynamic>?) ?? const {};
    final items = raw is List
        ? raw
            .whereType<Map<String, dynamic>>()
            .map(AppNotification.fromJson)
            .toList()
        : <AppNotification>[];
    return NotificationPage(
      items: items,
      unreadCount: (meta['unread_count'] as num?)?.toInt() ?? 0,
      hasMore: (meta['has_next'] as bool?) ?? false,
      page: (meta['page'] as num?)?.toInt() ?? page,
    );
  }

  @override
  Future<void> markRead(String id) async {
    await _dio.patch<dynamic>(ApiEndpoints.notificationRead(id));
  }

  @override
  Future<void> markAllRead() async {
    await _dio.post<dynamic>(ApiEndpoints.notificationsReadAll);
  }

  @override
  Future<NotificationPreferences> getPreferences() async {
    final res = await _dio.get<dynamic>(ApiEndpoints.notificationPreferences);
    return NotificationPreferences.fromJson(_obj(res));
  }

  @override
  Future<NotificationPreferences> updatePreferences(
      NotificationPreferences prefs) async {
    final res = await _dio.put<dynamic>(
      ApiEndpoints.notificationPreferences,
      data: prefs.toJson(),
    );
    return NotificationPreferences.fromJson(_obj(res));
  }

  Map<String, dynamic> _obj(Response<dynamic> res) {
    final data = res.data;
    if (data is Map<String, dynamic>) {
      final inner = data['data'];
      if (inner is Map<String, dynamic>) return inner;
      return data;
    }
    return <String, dynamic>{};
  }
}
