import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:butterfly_india/core/theme/app_theme.dart';
import 'package:butterfly_india/features/notifications/data/models/notification_preferences.dart';
import 'package:butterfly_india/features/notifications/data/notification_remote_datasource.dart';
import 'package:butterfly_india/features/notifications/presentation/notification_providers.dart';
import 'package:butterfly_india/features/notifications/presentation/screens/notification_center_screen.dart';
import '../../helpers/test_helpers.dart';
import 'fake_notification_datasource.dart';

/// Datasource that returns an empty page (for the empty-state test).
class _EmptyDataSource implements INotificationRemoteDataSource {
  @override
  Future<NotificationPage> fetch({int page = 1, int perPage = 30}) async =>
      const NotificationPage(items: [], unreadCount: 0, hasMore: false, page: 1);
  @override
  Future<void> markRead(String id) async {}
  @override
  Future<void> markAllRead() async {}
  @override
  Future<NotificationPreferences> getPreferences() async =>
      const NotificationPreferences();
  @override
  Future<NotificationPreferences> updatePreferences(
          NotificationPreferences prefs) async =>
      prefs;
}

void main() {
  Future<void> pumpScreen(
    WidgetTester tester,
    INotificationRemoteDataSource ds,
  ) async {
    tester.view.physicalSize = const Size(420, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final container = createTestContainer(
      overrides: [notificationDataSourceProvider.overrideWithValue(ds)],
    );
    addTearDown(container.dispose);
    final router = GoRouter(
      initialLocation: '/n',
      routes: [
        GoRoute(
            path: '/n', builder: (_, __) => const NotificationCenterScreen()),
        GoRoute(
            path: '/observations/:id',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('OBS')))),
        GoRoute(
            path: '/notifications/preferences',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('PREFS')))),
      ],
    );
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pumpAndSettle();
  }

  testWidgets('renders notifications grouped with Today header', (tester) async {
    await pumpScreen(tester, FakeNotificationRemoteDataSource());
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.textContaining('Notification'), findsWidgets);
  });

  testWidgets('mark all read clears the action', (tester) async {
    final fake = FakeNotificationRemoteDataSource();
    await pumpScreen(tester, fake);
    expect(find.text('Mark all read'), findsOneWidget);
    await tester.tap(find.text('Mark all read'));
    await tester.pumpAndSettle();
    expect(fake.markAllCalls, 1);
    expect(find.text('Mark all read'), findsNothing);
  });

  testWidgets('settings icon navigates to preferences', (tester) async {
    await pumpScreen(tester, FakeNotificationRemoteDataSource());
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('PREFS'), findsOneWidget);
  });

  testWidgets('empty state when no notifications', (tester) async {
    await pumpScreen(tester, _EmptyDataSource());
    expect(find.text("You're all caught up"), findsOneWidget);
  });
}
