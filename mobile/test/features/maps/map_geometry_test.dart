import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/features/maps/data/map_clusterer.dart';
import 'package:butterfly_india/features/maps/data/map_geometry.dart';

/// Guards the "I can only see some of my sightings" bug: six of the 22 public
/// sightings share one identical coordinate, and no zoom level separates those.
/// The map must detect that and list them instead of zooming forever.

ClusterPoint p(String id, double lat, double lng) =>
    ClusterPoint(id: id, lat: lat, lng: lng);

void main() {
  group('isSpread', () {
    test('six sightings on one identical coordinate are not spreadable', () {
      // The real shape from the production feed.
      final stacked = [
        for (var i = 0; i < 6; i++) p('o$i', 12.9726, 77.5417),
      ];
      expect(MapGeometry.isSpread(stacked), isFalse);
    });

    test('GPS jitter within a few metres still counts as one place', () {
      final almost = [
        p('a', 12.9726, 77.5417),
        p('b', 12.97262, 77.54172),
      ];
      expect(MapGeometry.isSpread(almost), isFalse);
    });

    test('sightings a few hundred metres apart can be zoomed apart', () {
      final apart = [
        p('a', 12.8987, 77.5913),
        p('b', 12.8971, 77.5954),
      ];
      expect(MapGeometry.isSpread(apart), isTrue);
    });

    test('a lone point is never spreadable', () {
      expect(MapGeometry.isSpread([p('a', 12.9, 77.5)]), isFalse);
      expect(MapGeometry.isSpread(const []), isFalse);
    });
  });

  group('boundsOf', () {
    test('covers every point', () {
      final bounds = MapGeometry.boundsOf([
        p('a', 12.8971, 77.4809),
        p('b', 22.6239, 88.4253),
      ])!;
      expect(bounds.southwest.latitude, lessThan(12.8971));
      expect(bounds.southwest.longitude, lessThan(77.4809));
      expect(bounds.northeast.latitude, greaterThan(22.6239));
      expect(bounds.northeast.longitude, greaterThan(88.4253));
    });

    test('identical points still produce a non-degenerate box', () {
      // A zero-area LatLngBounds makes the Android SDK throw.
      final bounds = MapGeometry.boundsOf([
        p('a', 12.9726, 77.5417),
        p('b', 12.9726, 77.5417),
      ])!;
      expect(bounds.northeast.latitude, greaterThan(bounds.southwest.latitude));
      expect(
          bounds.northeast.longitude, greaterThan(bounds.southwest.longitude));
    });

    test('nothing to fit returns null rather than an invalid box', () {
      expect(MapGeometry.boundsOf(const []), isNull);
      expect(MapGeometry.boundsOf([p('bad', double.nan, 77.0)]), isNull);
    });

    test('out-of-range coordinates are ignored, not clamped into the box', () {
      final bounds = MapGeometry.boundsOf([
        p('good', 12.9, 77.5),
        p('bogus', 999, 999),
      ])!;
      expect(bounds.northeast.latitude, lessThan(13.0));
      expect(bounds.northeast.longitude, lessThan(78.0));
    });

    test('padding never pushes the box outside legal coordinates', () {
      final bounds = MapGeometry.boundsOf([p('pole', 89.999, 179.999)])!;
      expect(bounds.northeast.latitude, lessThanOrEqualTo(90.0));
      expect(bounds.northeast.longitude, lessThanOrEqualTo(180.0));
    });
  });

  test('a stacked cluster keeps every member reachable', () {
    // The clusterer must not drop members: the sheet lists exactly what the
    // bubble counted.
    final stacked = [for (var i = 0; i < 6; i++) p('o$i', 12.9726, 77.5417)];
    final clusters = MapClusterer.cluster(stacked, zoom: 17);
    expect(clusters, hasLength(1));
    expect(clusters.single.count, 6);
    expect(clusters.single.points.map((e) => e.id).toSet(), hasLength(6));
    expect(MapGeometry.isSpread(clusters.single.points), isFalse);
  });
}
