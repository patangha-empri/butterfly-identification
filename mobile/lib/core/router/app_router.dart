import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_routes.dart';
import '../providers/core_providers.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/species/presentation/screens/species_list_screen.dart';
import '../../features/species/presentation/screens/species_detail_screen.dart';
import '../../features/species/presentation/screens/species_search_screen.dart';
import '../../features/observations/presentation/screens/observation_detail_screen.dart';
import '../../features/observations/presentation/screens/submit_observation_screen.dart';
import '../../features/observations/presentation/screens/my_observations_screen.dart';
import '../../features/ai_identification/presentation/screens/ai_scan_screen.dart';
import '../../features/maps/presentation/screens/map_screen.dart';
import '../../features/notifications/presentation/screens/notification_center_screen.dart';
import '../../features/notifications/presentation/screens/notification_preferences_screen.dart';
import '../../features/gamification/presentation/screens/achievements_screen.dart';
import '../../features/community/presentation/screens/community_feed_screen.dart';
import '../../features/community/presentation/screens/public_profile_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/profile/presentation/screens/saved_species_screen.dart';
import '../../features/observations/presentation/providers/sync_providers.dart';
import '../../features/legal/presentation/legal_content.dart';
import '../../features/legal/presentation/legal_document_screen.dart';

// Placeholder screen widgets — replaced in later phases
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(child: Text(title)),
  );
}

/// ─────────────────────────────────────────────────────────────────────────────
/// APP ROUTER (GoRouter)
/// Features:
///   - StatefulShellRoute for bottom-nav persistence
///   - Auth guard (redirects to /login if unauthenticated)
///   - Deep link ready (observation & species share links)
///   - Page transitions: iOS-style slide for all routes
/// ─────────────────────────────────────────────────────────────────────────────

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final GlobalKey<NavigatorState> _speciesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'species');
final GlobalKey<NavigatorState> _mapNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'map');
final GlobalKey<NavigatorState> _communityNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'community');
final GlobalKey<NavigatorState> _profileNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

final appRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authStateListenableProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final isLoggedIn = authNotifier.isLoggedIn;
      final isSplash = state.matchedLocation == AppRoutes.splash;
      final isOnboarding = state.matchedLocation == AppRoutes.onboarding;
      final isAuthRoute = state.matchedLocation.startsWith('/login') ||
          state.matchedLocation.startsWith('/register') ||
          state.matchedLocation.startsWith('/forgot');

      // Always allow splash to render first
      if (isSplash) return null;

      if (!isLoggedIn && !isAuthRoute && !isOnboarding) {
        return '${AppRoutes.login}?redirect=${Uri.encodeComponent(state.uri.toString())}';
      }

      if (isLoggedIn && isAuthRoute) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      // ── Splash ─────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) => _fadePage(
          state,
          const SplashScreen(),
        ),
      ),

      // ── Onboarding ─────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) => _fadePage(
          state,
          const OnboardingScreen(),
        ),
      ),

      // ── Auth routes ────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => _fadePage(
          state,
          LoginScreen(redirect: state.uri.queryParameters['redirect']),
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        pageBuilder: (context, state) => _slidePage(
          state,
          const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        pageBuilder: (context, state) => _slidePage(
          state,
          const ForgotPasswordScreen(),
        ),
      ),

      // ── Main shell with bottom nav ─────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => _ShellScaffold(
          navigationShell: navigationShell,
        ),
        branches: [
          // Tab 0: Home / Discover
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),

          // Tab 1: Explore / Species
          StatefulShellBranch(
            navigatorKey: _speciesNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.speciesList,
                builder: (context, state) => const SpeciesListScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) => _slidePage(
                      state,
                      SpeciesDetailScreen(
                        speciesId: state.pathParameters['id'] ?? '',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Tab 2: Map
          StatefulShellBranch(
            navigatorKey: _mapNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.map,
                builder: (context, state) => const MapScreen(),
              ),
            ],
          ),

          // Tab 3: Community
          StatefulShellBranch(
            navigatorKey: _communityNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.community,
                builder: (context, state) => const CommunityFeedScreen(),
              ),
            ],
          ),

          // Tab 4: Profile
          StatefulShellBranch(
            navigatorKey: _profileNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'edit',
                    pageBuilder: (context, state) => _slidePage(
                      state,
                      const EditProfileScreen(),
                    ),
                  ),
                  GoRoute(
                    path: 'saved',
                    pageBuilder: (context, state) => _slidePage(
                      state,
                      const SavedSpeciesScreen(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // ── Full-screen routes (outside shell) ─────────────────────────────
      GoRoute(
        path: AppRoutes.aiScan,
        pageBuilder: (context, state) => _fullscreenPage(
          state,
          const AiScanScreen(),
        ),
      ),

      GoRoute(
        path: AppRoutes.submitObservation,
        pageBuilder: (context, state) => _fullscreenPage(
          state,
          const SubmitObservationScreen(),
        ),
      ),

      GoRoute(
        path: AppRoutes.myObservations,
        pageBuilder: (context, state) => _slidePage(
          state,
          const MyObservationsScreen(),
        ),
      ),

      GoRoute(
        path: AppRoutes.observationDetail,
        pageBuilder: (context, state) => _slidePage(
          state,
          ObservationDetailScreen(
            observationId: state.pathParameters['id'] ?? '',
          ),
        ),
      ),

      GoRoute(
        path: AppRoutes.userProfile,
        pageBuilder: (context, state) => _slidePage(
          state,
          PublicProfileScreen(
            username: state.pathParameters['username'] ?? '',
          ),
        ),
      ),

      GoRoute(
        path: AppRoutes.notifications,
        pageBuilder: (context, state) {
          final openId = state.uri.queryParameters['open_id'];
          return _slidePage(
            state,
            NotificationCenterScreen(openNotificationId: openId),
          );
        },
        routes: [
          GoRoute(
            path: 'preferences',
            pageBuilder: (context, state) => _slidePage(
              state,
              const NotificationPreferencesScreen(),
            ),
          ),
        ],
      ),

      GoRoute(
        path: AppRoutes.search,
        pageBuilder: (context, state) => _fadePage(
          state,
          const SpeciesSearchScreen(),
        ),
      ),

      GoRoute(
        path: AppRoutes.achievements,
        pageBuilder: (context, state) => _slidePage(
          state,
          const AchievementsScreen(),
        ),
      ),

      GoRoute(
        path: AppRoutes.articles,
        pageBuilder: (context, state) => _slidePage(
          state,
          const _PlaceholderScreen(title: 'Articles'),
        ),
        routes: [
          GoRoute(
            path: ':slug',
            pageBuilder: (context, state) => _slidePage(
              state,
              _PlaceholderScreen(
                title: 'Article ${state.pathParameters['slug']}',
              ),
            ),
          ),
        ],
      ),

      GoRoute(
        path: AppRoutes.settings,
        pageBuilder: (context, state) => _slidePage(
          state,
          const SettingsScreen(),
        ),
      ),

      // ── Legal documents ────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.privacyPolicy,
        pageBuilder: (context, state) => _slidePage(
          state,
          const LegalDocumentScreen(doc: LegalContent.privacyPolicy),
        ),
      ),
      GoRoute(
        path: AppRoutes.terms,
        pageBuilder: (context, state) => _slidePage(
          state,
          const LegalDocumentScreen(doc: LegalContent.terms),
        ),
      ),
      GoRoute(
        path: AppRoutes.communityGuidelines,
        pageBuilder: (context, state) => _slidePage(
          state,
          const LegalDocumentScreen(doc: LegalContent.communityGuidelines),
        ),
      ),

      // ── Fallback 404 ───────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.notFound,
        builder: (context, state) => const _PlaceholderScreen(title: '404'),
      ),
    ],
    errorBuilder: (context, state) =>
        const _PlaceholderScreen(title: 'Page Not Found'),
  );
});

// ── Page builders ─────────────────────────────────────────────────────────────

Page<void> _fadePage(GoRouterState state, Widget child) => CustomTransitionPage(
  key: state.pageKey,
  child: child,
  transitionDuration: const Duration(milliseconds: 300),
  transitionsBuilder: (context, animation, secondary, child) =>
      FadeTransition(opacity: animation, child: child),
);

Page<void> _slidePage(GoRouterState state, Widget child) =>
    CustomTransitionPage(
  key: state.pageKey,
  child: child,
  transitionDuration: const Duration(milliseconds: 350),
  transitionsBuilder: (context, animation, secondary, child) =>
      SlideTransition(
    position: Tween(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    )),
    child: child,
  ),
);

Page<void> _fullscreenPage(GoRouterState state, Widget child) =>
    CustomTransitionPage(
  key: state.pageKey,
  fullscreenDialog: true,
  child: child,
  transitionDuration: const Duration(milliseconds: 400),
  transitionsBuilder: (context, animation, secondary, child) =>
      SlideTransition(
    position: Tween(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    )),
    child: child,
  ),
);

// ── Shell scaffold ─────────────────────────────────────────────────────────────

class _ShellScaffold extends ConsumerWidget {
  const _ShellScaffold({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _destinations = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.flutter_dash_outlined),
      selectedIcon: Icon(Icons.flutter_dash),
      label: 'Species',
    ),
    NavigationDestination(
      icon: Icon(Icons.map_outlined),
      selectedIcon: Icon(Icons.map),
      label: 'Map',
    ),
    NavigationDestination(
      icon: Icon(Icons.people_outlined),
      selectedIcon: Icon(Icons.people),
      label: 'Community',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outlined),
      selectedIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Keep the offline-sync driver alive for the whole authenticated session
    // and toast when queued sightings finish uploading.
    ref.watch(syncControllerProvider);
    ref.listen<SyncState>(syncControllerProvider, (prev, next) {
      if (next.status == SyncStatus.success && next.syncedJustNow > 0) {
        final n = next.syncedJustNow;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$n sighting${n > 1 ? 's' : ''} synced')),
        );
      }
    });

    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      // The "submit a sighting" FAB only belongs on the Home tab. The other
      // tabs (Species, Map, Community, Profile) hide it.
      floatingActionButton: navigationShell.currentIndex == 0
          ? FloatingActionButton(
              onPressed: () => context.push(AppRoutes.submitObservation),
              tooltip: 'Submit a sighting',
              child: const Icon(Icons.add_a_photo),
            )
          : null,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 16,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          // Solid surface (white in light mode) so content can't bleed through.
          backgroundColor: colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          destinations: _destinations,
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) => navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          ),
          height: 64,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        ),
      ),
    );
  }
}
