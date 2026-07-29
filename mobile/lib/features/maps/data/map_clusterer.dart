import 'dart:math' as math;

/// ─────────────────────────────────────────────────────────────────────────────
/// MAP CLUSTERER
/// Pure, grid-based clustering for map markers. Groups points into square cells
/// whose size shrinks as zoom increases, so dense areas collapse at low zoom
/// and expand as you zoom in. No external dependency → fully unit-testable.
/// ─────────────────────────────────────────────────────────────────────────────

class ClusterPoint {
  const ClusterPoint({required this.id, required this.lat, required this.lng});
  final String id;
  final double lat;
  final double lng;
}

class MapCluster {
  const MapCluster({
    required this.lat,
    required this.lng,
    required this.points,
  });

  final double lat;
  final double lng;
  final List<ClusterPoint> points;

  bool get isCluster => points.length > 1;
  int get count => points.length;

  /// The single underlying point (only valid when [isCluster] is false).
  ClusterPoint get single => points.first;
}

abstract class MapClusterer {
  /// Degrees-per-cell for a given map [zoom]. Larger cells at low zoom →
  /// stronger grouping; smaller cells at high zoom → markers separate.
  static double cellSizeForZoom(double zoom) {
    // 360° across the world halved per zoom level, then a grid factor so a
    // screen shows a reasonable number of cells.
    final size = (360.0 / math.pow(2, zoom)) * 1.4;
    return size.clamp(0.02, 60.0);
  }

  /// Clusters [points] into grid cells sized for [zoom].
  static List<MapCluster> cluster(
    List<ClusterPoint> points, {
    required double zoom,
  }) {
    if (points.isEmpty) return const [];
    final cell = cellSizeForZoom(zoom);
    final buckets = <String, List<ClusterPoint>>{};

    for (final p in points) {
      final cx = (p.lng / cell).floor();
      final cy = (p.lat / cell).floor();
      (buckets['$cx:$cy'] ??= <ClusterPoint>[]).add(p);
    }

    final clusters = <MapCluster>[];
    for (final members in buckets.values) {
      final avgLat =
          members.map((p) => p.lat).reduce((a, b) => a + b) / members.length;
      final avgLng =
          members.map((p) => p.lng).reduce((a, b) => a + b) / members.length;
      clusters.add(MapCluster(lat: avgLat, lng: avgLng, points: members));
    }
    return clusters;
  }
}
