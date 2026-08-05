import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/features/maps/data/map_marker_icons.dart';

/// The cache is the point: Google Maps rebuilds its marker set on every camera
/// idle, so a map of thousands of sightings must not paint thousands of images.

void main() {
  test('counts collapse into a small set of buckets', () {
    expect(MapMarkerIcons.bucketLabel(2), '2');
    expect(MapMarkerIcons.bucketLabel(9), '9');
    expect(MapMarkerIcons.bucketLabel(10), '10+');
    expect(MapMarkerIcons.bucketLabel(24), '10+');
    expect(MapMarkerIcons.bucketLabel(25), '25+');
    expect(MapMarkerIcons.bucketLabel(99), '50+');
    expect(MapMarkerIcons.bucketLabel(100), '100+');
    expect(MapMarkerIcons.bucketLabel(12345), '500+');
  });

  test('a thousand distinct counts need a fixed, tiny set of bitmaps', () {
    // 1..9 stay exact because "3 sightings" is worth reading precisely; every
    // larger count collapses into one of five buckets. 14 images, forever.
    final labels = {
      for (var i = 1; i <= 1000; i++) MapMarkerIcons.bucketLabel(i),
    };
    expect(labels.length, 14);
  });

  group('marker size', () {
    // Guards the complaint these numbers came from: at India-wide zoom the
    // earlier markers were big enough to cover the sightings they represented.
    test('a sighting pin is a small teardrop, taller than it is wide', () {
      expect(MapMarkerIcons.pinWidth, lessThanOrEqualTo(22));
      expect(MapMarkerIcons.pinHeight, lessThanOrEqualTo(30));
      expect(MapMarkerIcons.pinHeight, greaterThan(MapMarkerIcons.pinWidth));
    });

    test('cluster bubbles stay small and grow only gently', () {
      final smallest = MapMarkerIcons.radiusFor(2);
      final largest = MapMarkerIcons.radiusFor(10000);
      expect(smallest, lessThanOrEqualTo(13));
      expect(largest, lessThanOrEqualTo(20));
      // A huge cluster must not dwarf a small one.
      expect(largest / smallest, lessThan(2.0));
    });

    test('radius never shrinks as the count grows', () {
      var previous = 0.0;
      for (final count in const [1, 5, 12, 30, 80, 300, 900]) {
        final r = MapMarkerIcons.radiusFor(count);
        expect(r, greaterThanOrEqualTo(previous));
        previous = r;
      }
    });
  });

  // The painting paths (single pin, cluster bubble) are not unit-tested:
  // encoding a PNG goes through the real engine, which never completes under
  // the widget-test binding. They are exercised on device by the map screen.
  // What matters for cost and frame budget - how few distinct images can ever
  // be requested - is pinned by the bucket tests above.
}
