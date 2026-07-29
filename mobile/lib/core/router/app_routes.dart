/// ─────────────────────────────────────────────────────────────────────────────
/// APP ROUTES — named path constants
/// ─────────────────────────────────────────────────────────────────────────────

abstract class AppRoutes {
  // ── Shell paths ───────────────────────────────────────────────────────────
  static const String home = '/';
  static const String explore = '/explore';
  static const String community = '/community';
  static const String profile = '/profile';

  // ── Community / Public profiles ─────────────────────────────────────────────
  static const String userProfile = '/users/:username';
  static String userProfilePath(String username) => '/users/$username';

  // ── Auth ──────────────────────────────────────────────────────────────────
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  // ── Species ───────────────────────────────────────────────────────────────
  static const String speciesList = '/species';
  static const String speciesDetail = '/species/:id';

  static String speciesDetailPath(String id) => '/species/$id';

  // ── Observations ──────────────────────────────────────────────────────────
  static const String submitObservation = '/submit';
  static const String observationDetail = '/observations/:id';
  static const String myObservations = '/my-observations';

  static String observationDetailPath(String id) => '/observations/$id';

  // ── AI Identification ─────────────────────────────────────────────────────
  static const String aiScan = '/scan';
  static const String aiResult = '/scan/result';
  static const String aiProcessing = '/scan/processing';

  // ── Maps ──────────────────────────────────────────────────────────────────
  static const String map = '/map';

  // ── Notifications ─────────────────────────────────────────────────────────
  static const String notifications = '/notifications';
  static const String notificationPreferences = '/notifications/preferences';

  // ── Gamification ─────────────────────────────────────────────────────────
  static const String achievements = '/achievements';
  static const String leaderboard = '/leaderboard';

  // ── Articles ─────────────────────────────────────────────────────────────
  static const String articles = '/articles';
  static const String articleDetail = '/articles/:slug';

  static String articleDetailPath(String slug) => '/articles/$slug';

  // ── Settings / Profile ───────────────────────────────────────────────────
  static const String settings = '/settings';
  static const String editProfile = '/profile/edit';
  static const String savedSpecies = '/profile/saved';
  static const String privacySettings = '/settings/privacy';

  // ── Legal ──────────────────────────────────────────────────────────────────
  static const String privacyPolicy = '/legal/privacy';
  static const String terms = '/legal/terms';
  static const String communityGuidelines = '/legal/guidelines';

  // ── Search ────────────────────────────────────────────────────────────────
  static const String search = '/search';

  // ── Error / Fallback ─────────────────────────────────────────────────────
  static const String notFound = '/404';
}
