import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../data/models/app_notification.dart';
import '../data/models/notification_preferences.dart';
import '../data/notification_remote_datasource.dart';
import '../data/notification_repository.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// NOTIFICATION PROVIDERS
/// ─────────────────────────────────────────────────────────────────────────────

final notificationDataSourceProvider =
    Provider<INotificationRemoteDataSource>(
  (ref) => NotificationRemoteDataSource(dio: ref.read(dioProvider)),
  name: 'notificationDataSource',
);

final notificationRepositoryProvider = Provider<INotificationRepository>(
  (ref) => NotificationRepository(
      remote: ref.read(notificationDataSourceProvider)),
  name: 'notificationRepository',
);

/// Unread count for the home bell badge (independent of the list screen).
final unreadCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final result =
      await ref.read(notificationRepositoryProvider).getNotifications();
  return result.fold((_) => 0, (page) => page.unreadCount);
}, name: 'unreadCount');

/// Notification preferences.
final notificationPreferencesProvider =
    FutureProvider.autoDispose<NotificationPreferences>((ref) async {
  final result =
      await ref.read(notificationRepositoryProvider).getPreferences();
  return result.fold(
    (f) => throw NotificationException(f.message),
    (prefs) => prefs,
  );
}, name: 'notificationPreferences');

// ── List notifier ───────────────────────────────────────────────────────────

enum NotificationsStatus { initial, loading, loadingMore, success, error }

class NotificationsState {
  const NotificationsState({
    this.items = const [],
    this.unreadCount = 0,
    this.status = NotificationsStatus.initial,
    this.hasMore = true,
    this.page = 1,
    this.error,
  });

  final List<AppNotification> items;
  final int unreadCount;
  final NotificationsStatus status;
  final bool hasMore;
  final int page;
  final String? error;

  bool get isInitialLoading =>
      status == NotificationsStatus.loading && items.isEmpty;
  bool get isEmpty =>
      status == NotificationsStatus.success && items.isEmpty;
  bool get hasError => status == NotificationsStatus.error;

  NotificationsState copyWith({
    List<AppNotification>? items,
    int? unreadCount,
    NotificationsStatus? status,
    bool? hasMore,
    int? page,
    String? error,
  }) =>
      NotificationsState(
        items: items ?? this.items,
        unreadCount: unreadCount ?? this.unreadCount,
        status: status ?? this.status,
        hasMore: hasMore ?? this.hasMore,
        page: page ?? this.page,
        error: error,
      );
}

class NotificationsNotifier extends StateNotifier<NotificationsState> {
  NotificationsNotifier(this._repository, this._ref)
      : super(const NotificationsState());

  final INotificationRepository _repository;
  final Ref _ref;

  Future<void> load() async {
    state = const NotificationsState(status: NotificationsStatus.loading);
    final result = await _repository.getNotifications(page: 1);
    state = result.fold(
      (f) => state.copyWith(
          status: NotificationsStatus.error, error: f.message),
      (p) => NotificationsState(
        items: p.items,
        unreadCount: p.unreadCount,
        status: NotificationsStatus.success,
        hasMore: p.hasMore,
        page: 1,
      ),
    );
  }

  Future<void> loadMore() async {
    if (!state.hasMore ||
        state.status == NotificationsStatus.loadingMore ||
        state.status == NotificationsStatus.loading) {
      return;
    }
    state = state.copyWith(status: NotificationsStatus.loadingMore);
    final result = await _repository.getNotifications(page: state.page + 1);
    state = result.fold(
      (_) => state.copyWith(
          status: NotificationsStatus.success, hasMore: false),
      (p) => state.copyWith(
        items: [...state.items, ...p.items],
        status: NotificationsStatus.success,
        hasMore: p.hasMore,
        page: state.page + 1,
        unreadCount: p.unreadCount,
      ),
    );
  }

  Future<void> markRead(String id) async {
    // Optimistic update.
    final updated = state.items
        .map((n) => n.id == id ? n.copyWith(isRead: true) : n)
        .toList();
    final newUnread = updated.where((n) => !n.isRead).length;
    state = state.copyWith(items: updated, unreadCount: newUnread);
    await _repository.markRead(id);
    _ref.invalidate(unreadCountProvider);
  }

  Future<void> markAllRead() async {
    final updated =
        state.items.map((n) => n.copyWith(isRead: true)).toList();
    state = state.copyWith(items: updated, unreadCount: 0);
    await _repository.markAllRead();
    _ref.invalidate(unreadCountProvider);
  }

  Future<void> refresh() => load();
}

final notificationsNotifierProvider = StateNotifierProvider.autoDispose<
    NotificationsNotifier, NotificationsState>(
  (ref) => NotificationsNotifier(
    ref.read(notificationRepositoryProvider),
    ref,
  )..load(),
  name: 'notificationsNotifier',
);

class NotificationException implements Exception {
  NotificationException(this.message);
  final String message;
  @override
  String toString() => message;
}
