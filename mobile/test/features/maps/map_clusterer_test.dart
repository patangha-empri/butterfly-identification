import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/features/maps/data/map_clusterer.dart';

void main() {
  group('MapClusterer.cellSizeForZoom', () {
    test('cells shrink as zoom increases', () {
      expect(MapClusterer.cellSizeForZoom(4),
          greaterThan(MapClusterer.cellSizeForZoom(10)));
    });

    test('clamps to sane bounds', () {
      expect(MapClusterer.cellSizeForZoom(1), lessThanOrEqualTo(60.0));
      expect(MapClusterer.cellSizeForZoom(20), greaterThanOrEqualTo(0.02));
    });
  });

  group('MapClusterer.cluster', () {
    final points = [
      // Two very close points (Bangalore-ish)
      const ClusterPoint(id: 'a', lat: 12.97, lng: 77.59),
      const ClusterPoint(id: 'b', lat: 12.98, lng: 77.60),
      // One far away (Delhi-ish)
      const ClusterPoint(id: 'c', lat: 28.61, lng: 77.20),
    ];

    test('empty input → empty output', () {
      expect(MapClusterer.cluster(const [], zoom: 5), isEmpty);
    });

    test('low zoom groups nearby points into a cluster', () {
      final clusters = MapClusterer.cluster(points, zoom: 4);
      // a+b should merge; c separate (or all merge at very low zoom).
      final clustered = clusters.where((c) => c.isCluster).toList();
      expect(clustered, isNotEmpty);
      // total points preserved across all clusters
      final total = clusters.fold<int>(0, (s, c) => s + c.count);
      expect(total, 3);
    });

    test('high zoom separates all points', () {
      final clusters = MapClusterer.cluster(points, zoom: 16);
      expect(clusters.length, 3);
      expect(clusters.every((c) => !c.isCluster), isTrue);
    });

    test('cluster centroid is the average of members', () {
      final clusters = MapClusterer.cluster([
        const ClusterPoint(id: 'a', lat: 10.0, lng: 20.0),
        const ClusterPoint(id: 'b', lat: 12.0, lng: 22.0),
      ], zoom: 3);
      expect(clusters.single.isCluster, isTrue);
      expect(clusters.single.lat, closeTo(11.0, 0.001));
      expect(clusters.single.lng, closeTo(21.0, 0.001));
    });
  });
}
