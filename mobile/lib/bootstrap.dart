import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'core/database/app_database.dart';
import 'core/providers/core_providers.dart';
import 'core/services/app_preferences.dart';
import 'core/services/push_notification_service.dart';
import 'app.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// BOOTSTRAP
/// Application entry-point initialization sequence:
///   1. Flutter binding init
///   2. System UI configuration (edge-to-edge)
///   3. Riverpod container + DB provider
///   4. Async service initialization
///   5. Orientation unlock
///   6. runApp
/// ─────────────────────────────────────────────────────────────────────────────

Future<void> bootstrap() async {
  await runZonedGuarded(_bootstrap, _onUncaughtError);
}

Future<void> _bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Global error capture ──────────────────────────────────────────────────
  // Route framework + platform errors through our logger. A crash-reporting
  // backend (e.g. Sentry's free tier) can later be slotted into these sinks.
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    Logger().e('FlutterError',
        error: details.exception, stackTrace: details.stack);
  };
  WidgetsBinding.instance.platformDispatcher.onError = (error, stack) {
    Logger().e('Uncaught platform error', error: error, stackTrace: stack);
    return true;
  };

  // ── System UI ─────────────────────────────────────────────────────────────
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // ── Portrait-only lock during splash ─────────────────────────────────────
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // ── Database & Preferences ────────────────────────────────────────────────
  final db = AppDatabase();
  final prefs = await AppPreferences.create();

  // ── Riverpod container ────────────────────────────────────────────────────
  final container = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      appPreferencesProvider.overrideWithValue(prefs),
    ],
    observers: [
      if (_isDebug) _ProviderLogger(),
    ],
  );

  // ── Async service init ────────────────────────────────────────────────────
  // Restore auth session, warm up DB
  await container.read(appInitProvider.future).timeout(
    const Duration(seconds: 10),
    onTimeout: () {
      // Proceed even if init times out — splash will handle state
    },
  );

  // ── Initialize Push Notifications ─────────────────────────────────────────
  try {
    await container.read(pushNotificationServiceProvider).initialize();
  } catch (_) {}

  // ── Unlock orientations ───────────────────────────────────────────────────
  await SystemChrome.setPreferredOrientations([]);

  // ── Run ───────────────────────────────────────────────────────────────────
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const ButterflyApp(),
    ),
  );
}

void _onUncaughtError(Object error, StackTrace stack) {
  Logger().e(
    'Uncaught error — zone caught',
    error: error,
    stackTrace: stack,
  );
  // TODO: Phase 14 — wire up Crashlytics/Sentry here
}

bool get _isDebug {
  bool debug = false;
  assert(() {
    debug = true;
    return true;
  }());
  return debug;
}

class _ProviderLogger extends ProviderObserver {
  final _log = Logger(
    printer: SimplePrinter(colors: true),
    level: Level.debug,
  );

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    _log.d('[Riverpod] ${provider.name ?? provider.runtimeType}');
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    _log.e(
      '[Riverpod] FAIL ${provider.name ?? provider.runtimeType}',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
