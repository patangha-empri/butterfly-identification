import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/theme/typography_tokens.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// SPLASH SCREEN
/// Cinematic brand reveal. Waits for app init (session restore) + minimum
/// display duration, then routes to onboarding / home / login.
/// ─────────────────────────────────────────────────────────────────────────────

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _decideNextRoute();
  }

  Future<void> _decideNextRoute() async {
    // Run init + a minimum splash display in parallel.
    await Future.wait([
      ref.read(appInitProvider.future).catchError((_) {}),
      Future.delayed(DurationTokens.splash),
    ]);

    if (!mounted) return;

    final prefs = ref.read(appPreferencesProvider);
    final isLoggedIn = ref.read(authStateListenableProvider).isLoggedIn;

    final String destination;
    if (!prefs.onboardingCompleted) {
      destination = AppRoutes.onboarding;
    } else if (isLoggedIn) {
      destination = AppRoutes.home;
    } else {
      destination = AppRoutes.login;
    }

    context.go(destination);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: ColorTokens.primaryGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 132,
                height: 132,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Image.asset(
                  'assets/images/pathanga_logo.png',
                  fit: BoxFit.contain,
                ),
              )
                  .animate()
                  .scale(
                    duration: 700.ms,
                    curve: Curves.elasticOut,
                    begin: const Offset(0.4, 0.4),
                    end: const Offset(1, 1),
                  )
                  .fadeIn(duration: 400.ms),
              const SizedBox(height: 24),
              Text(
                'Pathanga',
                style: TypographyTokens.heroTitle.copyWith(
                  color: Colors.white,
                  fontSize: 34,
                ),
              )
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 600.ms)
                  .moveY(begin: 16, end: 0, delay: 400.ms, duration: 600.ms),
              const SizedBox(height: 8),
              Text(
                'Discover · Identify · Protect',
                style: TypographyTokens.textTheme.titleSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  letterSpacing: 2,
                ),
              ).animate().fadeIn(delay: 800.ms, duration: 600.ms),
              const SizedBox(height: 56),
              SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor:
                      AlwaysStoppedAnimation(Colors.white.withValues(alpha: 0.7)),
                ),
              ).animate().fadeIn(delay: 1200.ms),
            ],
          ),
        ),
      ),
    );
  }
}
