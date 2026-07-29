import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/core_providers.dart';
import '../api/api_endpoints.dart';
import '../router/app_routes.dart';
import '../router/app_router.dart';

final pushNotificationServiceProvider = Provider<PushNotificationService>((ref) {
  return PushNotificationService(ref);
});

class PushNotificationService {
  PushNotificationService(this._ref);

  final Ref _ref;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    final messaging = FirebaseMessaging.instance;

    // ── Request permissions ──────────────────────────────────────────────────
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    // Set notification presentation options for foreground messages
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // ── Register FCM Token on Login & Refresh ──────────────────────────────
    _ref.listen<bool>(
      authStateNotifierProvider.select((s) => s.isAuthenticated),
      (prev, isAuthenticated) async {
        if (isAuthenticated) {
          try {
            final token = await messaging.getToken();
            if (token != null) {
              await _registerToken(token);
            }
          } catch (_) {}
        }
      },
      fireImmediately: true,
    );

    messaging.onTokenRefresh.listen((newToken) {
      unawaited(_registerToken(newToken));
    });

    // ── Handle Taps on Notifications ─────────────────────────────────────────
    // 1. When app is in background but running
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(message);
    });

    // 2. When app is terminated and launched by tapping a notification
    unawaited(messaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        _handleNotificationTap(message, isFromTerminated: true);
      }
    }));

    // ── Foreground Message Handler ───────────────────────────────────────────
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showForegroundNotification(message);
    });
  }

  Future<void> _registerToken(String token) async {
    final auth = _ref.read(authStateNotifierProvider);
    if (!auth.isAuthenticated) return;

    try {
      final dio = _ref.read(dioProvider);
      await dio.post<dynamic>(
        ApiEndpoints.registerFcmToken,
        data: {'fcm_token': token},
      );
    } catch (_) {}
  }

  void _handleNotificationTap(RemoteMessage message, {bool isFromTerminated = false}) {
    final notificationId = message.data['notification_id'] as String?;
    if (notificationId == null || notificationId.isEmpty) return;

    final router = _ref.read(appRouterProvider);
    final delay = isFromTerminated ? const Duration(milliseconds: 1500) : Duration.zero;

    Future.delayed(delay, () {
      router.push('${AppRoutes.notifications}?open_id=$notificationId');
    });
  }

  void _showForegroundNotification(RemoteMessage message) {
    // Show a prominent foreground SnackBar to alert the user
    final title = message.notification?.title ?? 'Notification';
    final body = message.notification?.body ?? '';
    
    final context = _ref.read(appRouterProvider).routerDelegate.navigatorKey.currentContext;
    if (context == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            if (body.isNotEmpty) Text(body, style: const TextStyle(fontSize: 12)),
          ],
        ),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            _handleNotificationTap(message);
          },
        ),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
