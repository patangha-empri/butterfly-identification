import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/features/home/data/models/observation_summary.dart';
import 'package:butterfly_india/features/maps/data/map_remote_datasource.dart';
import 'package:butterfly_india/features/maps/presentation/map_providers.dart';

class _FakeMapDataSource implements IMapRemoteDataSource {
  _FakeMapDataSource(this.sightings);
  final List<ObservationSummary> sightings;

  @override
  Future<List<ObservationSummary>> fetchSightings({
    int? stateId,
    String? privacy,
    int perPage = 100,
  }) async =>
      sightings;
}

void main() {
  group('isPlottableCoord', () {
    test('accepts in-range finite coordinates', () {
      expect(isPlottableCoord(22.5, 79.0), isTrue);
      expect(isPlottableCoord(-90, -180), isTrue);
      expect(isPlottableCoord(90, 180), isTrue);
    });

    test('rejects null / out-of-range / non-finite', () {
      expect(isPlottableCoord(null, 79.0), isFalse);
      expect(isPlottableCoord(22.5, null), isFalse);
      expect(isPlottableCoord(200, 79.0), isFalse); // lat too big
      expect(isPlottableCoord(22.5, 999), isFalse); // lng too big
      expect(isPlottableCoord(double.nan, 0), isFalse);
      expect(isPlottableCoord(0, double.infinity), isFalse);
    });
  });

  group('mapSightingsProvider', () {
    Future<List<ObservationSummary>> run(List<ObservationSummary> data) {
      final container = ProviderContainer(overrides: [
        mapDataSourceProvider.overrideWithValue(_FakeMapDataSource(data)),
      ]);
      addTearDown(container.dispose);
      return container.read(mapSightingsProvider.future);
    }

    test('drops sightings whose state is unknown and coords invalid',
        () async {
      final result = await run(const [
        ObservationSummary(id: 'good', latitude: 12.9, longitude: 77.5),
        ObservationSummary(id: 'bad-range', latitude: 200, longitude: 77.5),
        ObservationSummary(id: 'missing', latitude: null, longitude: null),
      ]);

      expect(result.map((o) => o.id), ['good']);
    });

    test('GPS-less sighting with a known state gets an approximate position',
        () async {
      final result = await run(const [
        ObservationSummary(id: 'no-gps', stateName: 'Karnataka'),
      ]);

      expect(result, hasLength(1));
      final o = result.single;
      // Placed near the Karnataka centroid (14.8, 75.9) ± 0.4°.
      expect(o.latitude, isNotNull);
      expect(o.longitude, isNotNull);
      expect(o.latitude!, closeTo(14.8, 0.5));
      expect(o.longitude!, closeTo(75.9, 0.5));
    });

    test('approximate position is deterministic for the same sighting id',
        () async {
      const sighting =
          ObservationSummary(id: 'stable-id', stateName: 'Karnataka');
      final first = await run(const [sighting]);
      final second = await run(const [sighting]);

      expect(first.single.latitude, second.single.latitude);
      expect(first.single.longitude, second.single.longitude);
    });

    test('exact GPS coordinates are never replaced by the fallback',
        () async {
      final result = await run(const [
        ObservationSummary(
            id: 'gps', stateName: 'Karnataka', latitude: 12.97, longitude: 77.59),
      ]);

      expect(result.single.latitude, 12.97);
      expect(result.single.longitude, 77.59);
    });
  });
}
