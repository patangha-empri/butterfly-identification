/// ─────────────────────────────────────────────────────────────────────────────
/// APP CONSTANTS
/// ─────────────────────────────────────────────────────────────────────────────

abstract class AppConstants {
  // ── App metadata ──────────────────────────────────────────────────────────
  static const String appName = 'Pathanga';
  static const String appVersion = '1.0.0';
  static const String supportEmail = 'support@butterflyindia.app';
  static const String websiteUrl = 'https://butterflyindia.app';
  static const String privacyUrl = 'https://butterflyindia.app/privacy';
  static const String termsUrl = 'https://butterflyindia.app/terms';

  // ── Pagination ────────────────────────────────────────────────────────────
  static const int defaultPageSize = 20;
  static const int speciesPageSize = 24;
  static const int observationsPageSize = 20;
  static const int feedPageSize = 15;

  // ── Image constraints ─────────────────────────────────────────────────────
  static const int maxImagesPerObservation = 5;
  static const int maxImageSizeBytes = 8 * 1024 * 1024; // 8MB
  static const int compressedImageQuality = 85;
  static const int thumbnailSize = 400;
  static const int maxImageDimension = 1920;

  // ── Cache TTL ─────────────────────────────────────────────────────────────
  static const Duration speciesCacheTtl = Duration(hours: 24);
  static const Duration observationCacheTtl = Duration(hours: 6);
  static const Duration homeFeedCacheTtl = Duration(minutes: 30);
  static const Duration dbPruneAge = Duration(days: 7);

  // ── Offline queue ─────────────────────────────────────────────────────────
  static const int maxQueueRetries = 5;
  static const Duration queueRetryDelay = Duration(minutes: 2);

  // ── AI Identification ─────────────────────────────────────────────────────
  static const int aiRequestTimeoutSeconds = 60;
  static const double minConfidenceThreshold = 0.30;
  static const double certainConfidence = 0.90;
  static const double likelyConfidence = 0.70;
  static const double possibleConfidence = 0.50;

  // ── Gamification ─────────────────────────────────────────────────────────
  static const int streakGracePeriodHours = 30; // 6hr grace past 24h
  static const int xpPerObservation = 10;
  static const int xpPerIdentification = 25;
  static const int xpPerRareSpecies = 50;
  static const int xpPerFirstInDistrict = 100;

  // ── Map ───────────────────────────────────────────────────────────────────
  static const double defaultMapLat = 20.5937; // India center
  static const double defaultMapLng = 78.9629;
  static const double defaultMapZoom = 5.0;
  static const double nearbyRadiusKm = 50.0;

  // ── Secure storage keys ───────────────────────────────────────────────────
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String themePreferenceKey = 'theme_preference';
  static const String notifPermissionAskedKey = 'notif_permission_asked';
  static const String lastSyncTimestampKey = 'last_sync_timestamp';
  static const String fcmTokenKey = 'fcm_token';
}

abstract class IndiaRegions {
  static const Map<int, String> states = {
    1: 'Andhra Pradesh',
    2: 'Arunachal Pradesh',
    3: 'Assam',
    4: 'Bihar',
    5: 'Chhattisgarh',
    6: 'Goa',
    7: 'Gujarat',
    8: 'Haryana',
    9: 'Himachal Pradesh',
    10: 'Jharkhand',
    11: 'Karnataka',
    12: 'Kerala',
    13: 'Madhya Pradesh',
    14: 'Maharashtra',
    15: 'Manipur',
    16: 'Meghalaya',
    17: 'Mizoram',
    18: 'Nagaland',
    19: 'Odisha',
    20: 'Punjab',
    21: 'Rajasthan',
    22: 'Sikkim',
    23: 'Tamil Nadu',
    24: 'Telangana',
    25: 'Tripura',
    26: 'Uttar Pradesh',
    27: 'Uttarakhand',
    28: 'West Bengal',
  };

  /// Biodiversity hotspot states (Western Ghats, NE India, Himalayas)
  static const List<int> hotspotStateIds = [3, 6, 11, 12, 15, 16, 17, 18, 22];
}
