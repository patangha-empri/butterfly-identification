import 'package:geolocator/geolocator.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// LOCATION SERVICE
/// Interface for device location. Phase 7 ships a real geolocator-backed
/// implementation; the stub remains for tests and graceful fallback.
/// ─────────────────────────────────────────────────────────────────────────────

typedef GeoCoords = ({double lat, double lng});

abstract class ILocationService {
  /// Returns the device's current coordinates, or null if unavailable
  /// (permission denied, service off, or error). Never throws.
  Future<GeoCoords?> currentCoords();

  /// Whether location permission is already granted (no prompt).
  Future<bool> get hasPermission;
}

/// Real GPS implementation backed by the `geolocator` plugin.
/// All failures degrade to `null` so callers can fall back gracefully.
class GeolocatorLocationService implements ILocationService {
  const GeolocatorLocationService();

  @override
  Future<GeoCoords?> currentCoords() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 12),
      );
      return (lat: pos.latitude, lng: pos.longitude);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> get hasPermission async {
    try {
      final p = await Geolocator.checkPermission();
      return p == LocationPermission.always ||
          p == LocationPermission.whileInUse;
    } catch (_) {
      return false;
    }
  }
}

/// No-op implementation for tests / when GPS is intentionally disabled.
class StubLocationService implements ILocationService {
  const StubLocationService();

  @override
  Future<GeoCoords?> currentCoords() async => null;

  @override
  Future<bool> get hasPermission async => false;
}
