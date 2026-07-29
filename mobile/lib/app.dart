import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'core/responsive/app_breakpoints.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_mode_provider.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// BUTTERFLY APP — Root widget
/// Sets up:
///   - ScreenUtilInit (device-relative scaling)
///   - ResponsiveFramework (named breakpoints)
///   - MaterialApp.router (GoRouter)
///   - Light/dark theme
///   - Localization delegates
/// ─────────────────────────────────────────────────────────────────────────────

class ButterflyApp extends ConsumerWidget {
  const ButterflyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return ScreenUtilInit(
      // Design reference size (Figma frame) — 390×844 iPhone 14
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Pathanga',
          debugShowCheckedModeBanner: false,

          // ── Themes ────────────────────────────────────────────────────
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,

          // ── Router ───────────────────────────────────────────────────
          routerConfig: router,

          // ── Responsive framework ──────────────────────────────────────
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: _MediaQueryWrapper(child: child ?? const SizedBox.shrink()),
            breakpoints: AppBreakpoints.breakpoints,
          ),

          // ── Localization ─────────────────────────────────────────────
          locale: const Locale('en', 'IN'),
          supportedLocales: const [
            Locale('en', 'IN'),
            Locale('en', 'US'),
          ],
        );
      },
    );
  }
}

/// Ensures MediaQuery properly reflects edge-to-edge rendering.
class _MediaQueryWrapper extends StatelessWidget {
  const _MediaQueryWrapper({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.noScaling, // Disable OS text scale — we handle it
      ),
      child: child,
    );
  }
}
