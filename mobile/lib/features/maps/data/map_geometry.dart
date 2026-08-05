import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'map_clusterer.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// MAP GEOMETRY
/// Camera maths kept out of the widget so it can be tested.
///
/// Exists because of a real data shape: of 22 public sightings, six were logged
/// at one identical coordinate. Zooming never separates those, so the map needs
/// to know when a cluster is un-splittable and offer a list instead.
/// ─────────────────────────────────────────────────────────────────────────────

abstract class MapGeometry {
  /// Two points closer than this in both axes are the same place for our
  /// purposes — roughly 50 m at the equator, well inside phone GPS error.
  static const double stackedEpsilon = 0.0005;

  /// Padding added around a bounds so markers are never flush with the screen
  /// edge, and so a zero-area box (every point identical) stays valid — Android
  /// throws on a degenerate LatLngBounds.
  static const double boundsPadding = 0.01;

  /// True when zooming in will actually pull these points apart.
  static bool isSpread(
    List<ClusterPoint> points, {
    double epsilon = stackedEpsilon,
  }) {
    if (points.length < 2) return false;
    final box = _extent(points);
    if (box == null) return false;
    return (box.maxLat - box.minLat) > epsilon ||
        (box.maxLng - box.minLng) > epsilon;
  }

  /// A padded bounding box around [points], or null if there is nothing to fit.
  static LatLngBounds? boundsOf(
    List<ClusterPoint> points, {
    double padding = boundsPadding,
  }) {
    final box = _extent(points);
    if (box == null) return null;
    return LatLngBounds(
      southwest: LatLng(
        (box.minLat - padding).clamp(-90.0, 90.0),
        (box.minLng - padding).clamp(-180.0, 180.0),
      ),
      northeast: LatLng(
        (box.maxLat + padding).clamp(-90.0, 90.0),
        (box.maxLng + padding).clamp(-180.0, 180.0),
      ),
    );
  }

  static _Extent? _extent(List<ClusterPoint> points) {
    var minLat = 90.0, maxLat = -90.0, minLng = 180.0, maxLng = -180.0;
    var seen = 0;
    for (final p in points) {
      if (!p.lat.isFinite || !p.lng.isFinite) continue;
      if (p.lat < -90 || p.lat > 90 || p.lng < -180 || p.lng > 180) continue;
      seen++;
      if (p.lat < minLat) minLat = p.lat;
      if (p.lat > maxLat) maxLat = p.lat;
      if (p.lng < minLng) minLng = p.lng;
      if (p.lng > maxLng) maxLng = p.lng;
    }
    if (seen == 0) return null;
    return _Extent(minLat, maxLat, minLng, maxLng);
  }
}

class _Extent {
  const _Extent(this.minLat, this.maxLat, this.minLng, this.maxLng);
  final double minLat;
  final double maxLat;
  final double minLng;
  final double maxLng;
}
