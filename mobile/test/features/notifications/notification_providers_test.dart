import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/features/notifications/data/models/notification_preferences.dart';
import 'package:butterfly_india/features/notifications/presentation/notification_providers.dart';
import '../../helpers/test_helpers.dart';
import 'fake_notification_datasource.dart';

void main() {
  late FakeNotificationRemoteDataSource fake;

  ProviderContainer build() => createTestContainer(
        overrides: [
          notificationDataSourceProvider.overrideWithValue(fake),
        ],
      );

  setUp(() => fake = FakeNotificationRemoteDataSource(totalPages: 2));

  Future<void> settle() => Future<void>.delayed(const Duration(milliseconds: 10));

  test('unreadCountProvider returns server unread count', () async {
    final c = build();
    addTearDown(c.dispose);
    final count = await c.read(unreadCountProvider.future);
    expect(count, 3);
  });

  group('notificationsNotifier', () {
    test('loads first page on creation', () async {
      final c = build();
      addTearDown(c.dispose);
      c.listen(notificationsNotifierProvider, (_, __) {});
      await settle();

      final state = c.read(notificationsNotifierProvider);
      expect(state.status, NotificationsStatus.success);
      expect(state.items, hasLength(2));
      expect(state.unreadCount, 3);
      expect(state.hasMore, isTrue);
    });

    test('loadMore appends next page', () async {
      final c = build();
      addTearDown(c.dispose);
      c.listen(notificationsNotifierProvider, (_, __) {});
      await settle();

      await c.read(notificationsNotifierProvider.notifier).loadMore();
      final state = c.read(notificationsNotifierProvider);
      expect(state.items, hasLength(4));
      expect(state.page, 2);
      expect(state.hasMore, isFalse);
    });

    test('markRead updates item + decrements unread', () async {
      final c = build();
      addTearDown(c.dispose);
      c.listen(notificationsNotifierProvider, (_, __) {});
      await settle();

      final firstId = c.read(notificationsNotifierProvider).items.first.id;
      await c.read(notificationsNotifierProvider.notifier).markRead(firstId);

      final state = c.read(notificationsNotifierProvider);
      expect(state.items.firstWhere((n) => n.id == firstId).isRead, isTrue);
      expect(fake.markReadCalls, 1);
    });

    test('markAllRead marks everything read', () async {
      final c = build();
      addTearDown(c.dispose);
      c.listen(notificationsNotifierProvider, (_, __) {});
      await settle();

      await c.read(notificationsNotifierProvider.notifier).markAllRead();
      final state = c.read(notificationsNotifierProvider);
      expect(state.items.every((n) => n.isRead), isTrue);
      expect(state.unreadCount, 0);
      expect(fake.markAllCalls, 1);
    });

    test('error state on failure', () async {
      fake.fail = true;
      final c = build();
      addTearDown(c.dispose);
      c.listen(notificationsNotifierProvider, (_, __) {});
      await settle();
      expect(c.read(notificationsNotifierProvider).hasError, isTrue);
    });
  });

  group('preferences', () {
    test('loads preferences', () async {
      final c = build();
      addTearDown(c.dispose);
      final prefs = await c.read(notificationPreferencesProvider.future);
      expect(prefs.identificationComplete, isTrue);
    });

    test('update persists via repository', () async {
      final c = build();
      addTearDown(c.dispose);
      await c.read(notificationRepositoryProvider).updatePreferences(
            const NotificationPreferences().copyWith(events: false),
          );
      expect(fake.lastSavedPrefs?.events, isFalse);
    });
  });
}
