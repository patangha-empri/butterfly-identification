import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/features/maps/data/navigation_launcher.dart';

/// Directions are handed to the device's maps app rather than fetched from the
/// billable Directions API, so the URL scheme order IS the feature — a wrong
/// scheme means either no navigation or a silent fall through to the browser.

void main() {
  const lat = 12.9716;
  const lng = 77.5946;

  List<Uri> android({String? label}) => NavigationLauncher.candidatesFor(
        lat: lat,
        lng: lng,
        label: label,
        isIOS: false,
      );

  List<Uri> ios() => NavigationLauncher.candidatesFor(
        lat: lat,
        lng: lng,
        isIOS: true,
      );

  test('android tries turn-by-turn before any generic handler', () {
    final uris = android();
    expect(uris.first.scheme, 'google.navigation');
    expect(uris.first.toString(), contains('$lat,$lng'));
    expect(uris[1].scheme, 'geo');
  });

  test('ios tries the Google Maps app, then Apple Maps', () {
    final uris = ios();
    expect(uris.first.scheme, 'comgooglemaps');
    expect(uris[1].host, 'maps.apple.com');
  });

  test('every platform ends on a web URL that always resolves', () {
    for (final uris in [android(), ios()]) {
      final last = uris.last;
      expect(last.scheme, 'https');
      expect(last.host, 'www.google.com');
      expect(last.queryParameters['destination'], '$lat,$lng');
    }
  });

  test('label is encoded so a species name with spaces cannot break the URL',
      () {
    final geo = android(label: 'Crimson Rose & friends')[1];
    expect(geo.toString(), contains('Crimson%20Rose%20%26%20friends'));
    expect(geo.toString(), isNot(contains(' ')));
  });

  test('a missing label still produces a valid geo URL', () {
    final geo = android(label: '')[1];
    expect(geo.toString(), 'geo:$lat,$lng?q=$lat,$lng');
  });
}
