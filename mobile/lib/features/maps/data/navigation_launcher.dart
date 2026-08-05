import 'dart:io' show Platform;

import 'package:url_launcher/url_launcher.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// NAVIGATION LAUNCHER
/// Hands a sighting's coordinates to the device's own maps app for turn-by-turn
/// directions.
///
/// Deliberately NOT the Directions API: drawing a route inside the app would be
/// a billed request on every tap, plus we would owe the user re-routing, voice
/// and traffic that Google Maps already does better. Opening the installed app
/// costs nothing and is the behaviour people expect from a "Navigate" button.
///
/// Order of attempts:
///   Android  google.navigation: (turn-by-turn) → geo: (any maps app) → web
///   iOS      comgooglemaps://  (if installed)  → Apple Maps → web
/// ─────────────────────────────────────────────────────────────────────────────

class NavigationLauncher {
  const NavigationLauncher();

  /// Opens directions to [lat],[lng]. Returns false when nothing could handle
  /// it, so the caller can tell the user instead of failing silently.
  Future<bool> navigateTo({
    required double lat,
    required double lng,
    String? label,
  }) async {
    for (final uri in _candidates(lat, lng, label)) {
      if (await _tryLaunch(uri)) return true;
    }
    return false;
  }

  List<Uri> _candidates(double lat, double lng, String? label) =>
      candidatesFor(lat: lat, lng: lng, label: label, isIOS: Platform.isIOS);

  /// The URLs tried, in order. Split out from [navigateTo] so the scheme
  /// building can be tested without a platform channel or a real device.
  static List<Uri> candidatesFor({
    required double lat,
    required double lng,
    String? label,
    required bool isIOS,
  }) {
    final coords = '$lat,$lng';
    final web = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$coords&travelmode=driving',
    );

    if (isIOS) {
      return [
        Uri.parse('comgooglemaps://?daddr=$coords&directionsmode=driving'),
        Uri.parse('https://maps.apple.com/?daddr=$coords&dirflg=d'),
        web,
      ];
    }
    return [
      Uri.parse('google.navigation:q=$coords&mode=d'),
      // `geo:` with a query keeps the label visible in whichever app opens it.
      Uri.parse(
        label == null || label.isEmpty
            ? 'geo:$coords?q=$coords'
            : 'geo:$coords?q=$coords(${Uri.encodeComponent(label)})',
      ),
      web,
    ];
  }

  Future<bool> _tryLaunch(Uri uri) async {
    try {
      if (!await canLaunchUrl(uri)) return false;
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      // A scheme the platform refuses to even evaluate must not take the
      // sighting sheet down with it — just move to the next candidate.
      return false;
    }
  }
}
