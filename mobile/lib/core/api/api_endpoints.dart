/// ─────────────────────────────────────────────────────────────────────────────
/// API ENDPOINTS
/// All backend route constants — never use raw strings in API calls.
/// ─────────────────────────────────────────────────────────────────────────────

abstract class ApiEndpoints {
  // ── Base ──────────────────────────────────────────────────────────────────
  static const String _v1 = '/api/v1';

  // ── Auth ──────────────────────────────────────────────────────────────────
  static const String login = '$_v1/auth/login';
  static const String register = '$_v1/auth/register';
  static const String logout = '$_v1/auth/logout';
  static const String refresh = '$_v1/auth/refresh';
  static const String me = '$_v1/auth/me';
  static const String forgotPassword = '$_v1/auth/forgot-password';
  static const String resetPassword = '$_v1/auth/reset-password';
  static const String changePassword = '$_v1/auth/change-password';
  static const String verifyEmail = '$_v1/auth/verify-email';

  // ── Users / Profile ───────────────────────────────────────────────────────
  static const String profile = '$_v1/users/me';
  static const String updateProfile = '$_v1/users/me';
  static const String deleteAccount = '$_v1/users/me';
  static const String uploadAvatar = '$_v1/users/me/avatar';
  static const String registerFcmToken = '$_v1/users/me/fcm-token';
  static String userPublicProfile(String username) =>
      '$_v1/users/$username';
  static String userObservations(String userId) =>
      '$_v1/observations/user/$userId';

  // ── Observations ──────────────────────────────────────────────────────────
  // Trailing slash on the collection route avoids a 308 redirect
  // (backend: `@observations_bp.post("/")` and `get("/")` = my-observations).
  static const String observations = '$_v1/observations/';
  static const String observationsFeed = '$_v1/observations/feed';
  static const String myObservations = '$_v1/observations/';
  static String observation(String id) => '$_v1/observations/$id';
  static String observationImages(String id) =>
      '$_v1/observations/$id/images';
  static String observationPrivacy(String id) =>
      '$_v1/observations/$id/privacy';
  static String observationShare(String id) =>
      '$_v1/observations/$id/share';

  // ── Social: likes & comments ──────────────────────────────────────────────
  static String observationLike(String id) =>
      '$_v1/observations/$id/like';
  static String observationComments(String id) =>
      '$_v1/observations/$id/comments';
  static String observationComment(String id, String commentId) =>
      '$_v1/observations/$id/comments/$commentId';

  // ── AI Identification ─────────────────────────────────────────────────────
  // Backend: identifications_bp at /identifications.
  /// Stateless photo scan — no observation is created.
  static const String aiQuickScan = '$_v1/identifications/scan';
  static String observationIdentify(String id) =>
      '$_v1/identifications/observations/$id/identify';
  static String observationIdentifyResult(String id) =>
      '$_v1/identifications/observations/$id/result';
  static String acceptMatch(String resultId, int matchId) =>
      '$_v1/identifications/results/$resultId/matches/$matchId/accept';

  // ── Species ───────────────────────────────────────────────────────────────
  // Trailing slash on the list route avoids a 308 redirect (backend route is
  // `@species_bp.get("/")`). Detail/sub-routes use no trailing slash.
  static const String species = '$_v1/species/';
  static String speciesDetail(String id) => '$_v1/species/$id';
  static String speciesImages(String id) => '$_v1/species/$id/images';
  static String speciesSimilar(String id) => '$_v1/species/$id/similar';
  static String speciesObservations(String id) =>
      '$_v1/species/$id/observations';
  static const String speciesSearch = '$_v1/species/search';
  static const String speciesFeatured = '$_v1/species/featured';
  static const String speciesTrending = '$_v1/species/trending';

  // ── Geography ─────────────────────────────────────────────────────────────
  static const String states = '$_v1/geography/states';
  static String stateDistricts(int stateId) =>
      '$_v1/geography/states/$stateId/districts';
  static const String nearbyObservations = '$_v1/geography/nearby';
  static const String hotspots = '$_v1/geography/hotspots';

  // ── Maps ──────────────────────────────────────────────────────────────────
  static const String mapObservations = '$_v1/map/observations';
  static const String mapHeatmap = '$_v1/map/heatmap';
  static const String mapClusters = '$_v1/map/clusters';

  // ── Notifications ─────────────────────────────────────────────────────────
  // Trailing slash on the list route avoids a 308 redirect.
  static const String notifications = '$_v1/notifications/';
  static const String notificationPreferences = '$_v1/notifications/preferences';
  static const String notificationsReadAll = '$_v1/notifications/read-all';
  static String notificationRead(String id) =>
      '$_v1/notifications/$id/read';

  // ── Gamification ─────────────────────────────────────────────────────────
  static const String gamificationProfile = '$_v1/gamification/me';
  static const String achievements = '$_v1/gamification/achievements';
  static const String leaderboard = '$_v1/gamification/leaderboard';
  static const String streaks = '$_v1/gamification/streaks';
  static const String challenges = '$_v1/gamification/challenges';
  static String challengeDetail(String id) => '$_v1/gamification/challenges/$id';

  // ── CMS / Articles ────────────────────────────────────────────────────────
  static const String articles = '$_v1/cms/articles';
  static String article(String slug) => '$_v1/cms/articles/$slug';
  static const String articleCategories = '$_v1/cms/categories';

  // ── Analytics (public stats) ──────────────────────────────────────────────
  static const String stats = '$_v1/analytics/stats';
  static const String trendingSpecies = '$_v1/analytics/trending';
  static const String seasonalSpecies = '$_v1/analytics/seasonal';

  // ── Search ────────────────────────────────────────────────────────────────
  static const String globalSearch = '$_v1/search';
}
