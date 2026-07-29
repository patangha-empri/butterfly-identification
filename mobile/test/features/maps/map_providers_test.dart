import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/features/home/data/models/observation_summary.dart';
import 'package:butterfly_india/features/maps/data/map_remote_datasource.dart';
import 'package:butterfly_india/features/maps/presentation/map_providers.dart';
import '../../helpers/test_helpers.dart';

class _FakeMapDataSource implements IMapRemoteDataSource {
  int? lastStateId;
  String? lastPrivacy;
  @override
  Future<List<ObservationSummary>> fetchSightings({
    int? stateId,
    String? privacy,
    int perPage = 100,
  }) async {
    lastStateId = stateId;
    lastPrivacy = privacy;
    return const [
      ObservationSummary(id: 'a', latitude: 12.9, longitude: 77.5),
      ObservationSummary(id: 'b', latitude: 28.6, longitude: 77.2),
      ObservationSummary(id: 'c'), // no coords → should be filtered out
    ];
  }
}

void main() {
  late _FakeMapDataSource fake;

  setUp(() => fake = _FakeMapDataSource());

  test('mapSightingsProvider keeps only geo-tagged sightings', () async {
    final c = createTestContainer(
      overrides: [mapDataSourceProvider.overrideWithValue(fake)],
    );
    addTearDown(c.dispose);

    final sightings = await c.read(mapSightingsProvider.future);
    expect(sightings.map((o) => o.id), ['a', 'b']); // 'c' filtered out
  });

  test('mapClusterPointsProvider derives points from sightings', () async {
    final c = createTestContainer(
      overrides: [mapDataSourceProvider.overrideWithValue(fake)],
    );
    addTearDown(c.dispose);

    await c.read(mapSightingsProvider.future);
    final points = c.read(mapClusterPointsProvider);
    expect(points, hasLength(2));
    expect(points.first.lat, 12.9);
  });

  test('state filter is forwarded to the datasource', () async {
    final c = createTestContainer(
      overrides: [mapDataSourceProvider.overrideWithValue(fake)],
    );
    addTearDown(c.dispose);

    c.read(mapStateFilterProvider.notifier).state = 11;
    await c.read(mapSightingsProvider.future);
    expect(fake.lastStateId, 11);
  });

  test('privacy filter is forwarded to the datasource', () async {
    final c = createTestContainer(
      overrides: [mapDataSourceProvider.overrideWithValue(fake)],
    );
    addTearDown(c.dispose);

    c.read(mapPrivacyFilterProvider.notifier).state = 'private';
    await c.read(mapSightingsProvider.future);
    expect(fake.lastPrivacy, 'private');
  });
}
