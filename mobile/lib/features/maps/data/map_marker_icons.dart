import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// MAP MARKER ICONS
/// Paints the sighting pin and the cluster bubble once, then keeps them.
///
/// Google Maps rebuilds its marker set on every camera idle, and painting a
/// bitmap per marker each time is what makes cluster maps stutter on cheap
/// Android hardware. Counts below ten stay exact; everything above collapses
/// into 10+, 25+, 50+, 100+ or 500+. However many thousands of sightings the
/// map holds, it can never need more than fourteen images.
///
/// Sizes are deliberately restrained: at India-wide zoom a dozen fat bubbles
/// cover the country and hide the very sightings they represent.
/// ─────────────────────────────────────────────────────────────────────────────

class MapMarkerIcons {
  MapMarkerIcons({required this.pinColor, required this.clusterColor});

  final Color pinColor;
  final Color clusterColor;

  final _cache = <String, BitmapDescriptor>{};

  /// Logical size of a sighting pin. The tip sits on the coordinate, so the
  /// marker's anchor must be (0.5, 1.0).
  static const double pinWidth = 20;
  static const double pinHeight = 27;

  /// Buckets a raw count to the label actually drawn, so 37 and 41 share one
  /// bitmap ("25+") instead of forcing two.
  static String bucketLabel(int count) {
    if (count < 10) return '$count';
    if (count < 25) return '10+';
    if (count < 50) return '25+';
    if (count < 100) return '50+';
    if (count < 500) return '100+';
    return '500+';
  }

  /// Bubble radius per bucket. Six small steps: a 500-sighting cluster reads as
  /// bigger than a 3-sighting one without ever dominating the map.
  static double radiusFor(int count) {
    if (count < 10) return 12;
    if (count < 25) return 13.5;
    if (count < 50) return 15;
    if (count < 100) return 16.5;
    if (count < 500) return 18;
    return 20;
  }

  /// Warms the cache for the icons a first frame will ask for, so the initial
  /// map does not pop in marker by marker.
  Future<void> warmUp({double devicePixelRatio = 3.0}) async {
    await single(devicePixelRatio: devicePixelRatio);
    for (final count in const [2, 10, 25, 50, 100, 500]) {
      await cluster(count, devicePixelRatio: devicePixelRatio);
    }
  }

  Future<BitmapDescriptor> single({double devicePixelRatio = 3.0}) =>
      _iconFor(key: 'pin', count: 1, devicePixelRatio: devicePixelRatio);

  Future<BitmapDescriptor> cluster(
    int count, {
    double devicePixelRatio = 3.0,
  }) =>
      _iconFor(
        key: 'cluster-${bucketLabel(count)}',
        count: count,
        devicePixelRatio: devicePixelRatio,
      );

  Future<BitmapDescriptor> _iconFor({
    required String key,
    required int count,
    required double devicePixelRatio,
  }) async {
    // Cap the raster scale: past 3x the extra pixels are invisible on a 20pt
    // marker and only cost memory on high-DPI phones.
    final dpr = devicePixelRatio.clamp(1.0, 3.0);
    final cacheKey = '$key@${dpr.toStringAsFixed(1)}';
    final cached = _cache[cacheKey];
    if (cached != null) return cached;

    final icon = BitmapDescriptor.bytes(
      await pngFor(count: count, devicePixelRatio: dpr),
    );
    _cache[cacheKey] = icon;
    return icon;
  }

  /// The raw PNG behind a marker. Public so the artwork can be rendered and
  /// eyeballed without a device — a marker that is legible in a unit test at
  /// 3x is legible on a phone.
  Future<Uint8List> pngFor({
    required int count,
    double devicePixelRatio = 3.0,
  }) {
    final dpr = devicePixelRatio.clamp(1.0, 3.0);
    return count > 1 ? _paintCluster(count, dpr) : _paintPin(dpr);
  }

  /// A teardrop pin: round head tapering to a point at the coordinate. Reads as
  /// "a place" at a glance, which a plain dot never does.
  Future<Uint8List> _paintPin(double dpr) async {
    final w = pinWidth * dpr;
    final h = pinHeight * dpr;

    return _render(w, h, (canvas) {
      final headRadius = w / 2 - 1.2 * dpr;
      final headCentre = Offset(w / 2, headRadius + 1.2 * dpr);

      final body = Path()
        ..addOval(Rect.fromCircle(center: headCentre, radius: headRadius))
        // Tail: flanks wide enough to merge with the circle rather than look
        // glued on, converging on the exact coordinate at the bottom.
        ..moveTo(headCentre.dx - headRadius * 0.62,
            headCentre.dy + headRadius * 0.78)
        ..lineTo(headCentre.dx + headRadius * 0.62,
            headCentre.dy + headRadius * 0.78)
        ..lineTo(headCentre.dx, h - 0.5 * dpr)
        ..close();

      // White outline first, so the pin stays legible over dark terrain.
      canvas.drawPath(
        body,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.2 * dpr
          ..strokeJoin = StrokeJoin.round,
      );
      canvas.drawPath(body, Paint()..color = pinColor);
      // Hole in the head — the classic map-pin read.
      canvas.drawCircle(
        headCentre,
        headRadius * 0.38,
        Paint()..color = Colors.white,
      );
    });
  }

  Future<Uint8List> _paintCluster(int count, double dpr) async {
    final radius = radiusFor(count);
    final size = (radius + 2) * 2 * dpr;
    final label = bucketLabel(count);

    return _render(size, size, (canvas) {
      final centre = Offset(size / 2, size / 2);
      // A thin ring rather than a thick white disc: less visual weight on a map
      // that already carries terrain and place labels.
      canvas.drawCircle(centre, radius * dpr, Paint()..color = clusterColor);
      canvas.drawCircle(
        centre,
        radius * dpr,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8 * dpr,
      );

      final painter = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: Colors.white,
            // "500+" needs a smaller face than a single digit to stay inside
            // the same bubble.
            fontSize: (radius * (label.length > 2 ? 0.52 : 0.68)) * dpr,
            fontWeight: FontWeight.w700,
            height: 1.0,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(
        canvas,
        centre - Offset(painter.width / 2, painter.height / 2),
      );
    });
  }

  Future<Uint8List> _render(
    double width,
    double height,
    void Function(Canvas) draw,
  ) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    draw(canvas);
    final image =
        await recorder.endRecording().toImage(width.ceil(), height.ceil());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    return bytes!.buffer.asUint8List();
  }

  void clear() => _cache.clear();
}
