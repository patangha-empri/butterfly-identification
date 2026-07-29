import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/services/location_service.dart';
import '../../home/data/models/observation_summary.dart';
import '../data/map_clusterer.dart';
import '../data/map_remote_datasource.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// MAP PROVIDERS
/// ─────────────────────────────────────────────────────────────────────────────

final mapDataSourceProvider = Provider<IMapRemoteDataSource>(
  (ref) => MapRemoteDataSource(dio: ref.read(dioProvider)),
  name: 'mapDataSource',
);

/// Optional state filter for the map (null = whole of India).
final mapStateFilterProvider = StateProvider<int?>(
  (ref) => null,
  name: 'mapStateFilter',
);

/// Privacy filter for the map ('public', 'private', or 'all').
final mapPrivacyFilterProvider = StateProvider<String>(
  (ref) => 'public',
  name: 'mapPrivacyFilter',
);

/// True only for a finite, in-range lat/lng pair. Guards against bad backend
/// data — an out-of-range value would make `LatLng(...)` throw and blank the
/// whole map screen.
bool isPlottableCoord(double? lat, double? lng) =>
    lat != null &&
    lng != null &&
    lat.isFinite &&
    lng.isFinite &&
    lat >= -90 &&
    lat <= 90 &&
    lng >= -180 &&
    lng <= 180;

/// Approximate state centroids (by india_states.name) used to place sightings
/// that were submitted without a GPS fix. State-level accuracy only.
const Map<String, (double, double)> _stateCentroids = {
  'Andhra Pradesh': (15.91, 79.74),
  'Arunachal Pradesh': (28.22, 94.73),
  'Assam': (26.20, 92.94),
  'Bihar': (25.10, 85.31),
  'Chhattisgarh': (21.28, 81.87),
  'Goa': (15.30, 74.12),
  'Gujarat': (22.26, 71.19),
  'Haryana': (29.06, 76.09),
  'Himachal Pradesh': (31.10, 77.17),
  'Jharkhand': (23.61, 85.28),
  'Karnataka': (14.80, 75.90),
  'Kerala': (10.85, 76.27),
  'Madhya Pradesh': (23.47, 77.95),
  'Maharashtra': (19.75, 75.71),
  'Manipur': (24.66, 93.91),
  'Meghalaya': (25.47, 91.37),
  'Mizoram': (23.16, 92.94),
  'Nagaland': (26.16, 94.56),
  'Odisha': (20.95, 85.10),
  'Punjab': (31.15, 75.34),
  'Rajasthan': (27.02, 74.22),
  'Sikkim': (27.53, 88.51),
  'Tamil Nadu': (11.13, 78.66),
  'Telangana': (18.11, 79.02),
  'Tripura': (23.75, 91.75),
  'Uttar Pradesh': (26.85, 80.91),
  'Uttarakhand': (30.07, 79.09),
  'West Bengal': (22.99, 87.85),
  'Delhi': (28.61, 77.21),
  'Jammu and Kashmir': (33.78, 76.58),
  'Ladakh': (34.21, 77.58),
  'Puducherry': (11.94, 79.81),
};

/// Deterministic small offset (≈ ±0.4°) derived from the sighting id so
/// GPS-less pins spread out around the state centroid instead of stacking,
/// and stay in the same place across reloads.
(double, double) _jitterFor(String id) {
  final h = id.hashCode & 0x7fffffff;
  final dLat = ((h % 1000) / 1000 - 0.5) * 0.8;
  final dLng = (((h ~/ 1000) % 1000) / 1000 - 0.5) * 0.8;
  return (dLat, dLng);
}

/// Sightings positioned for plotting, filtered by state and privacy.
/// GPS-tagged sightings use their exact coordinates; sightings without a GPS
/// fix fall back to an approximate position within their state so they are
/// still visible on the map rather than silently dropped.
final mapSightingsProvider =
    FutureProvider.autoDispose<List<ObservationSummary>>((ref) async {
  final stateId = ref.watch(mapStateFilterProvider);
  final privacy = ref.watch(mapPrivacyFilterProvider);
  final all = await ref
      .read(mapDataSourceProvider)
      .fetchSightings(stateId: stateId, privacy: privacy);

  final plottable = <ObservationSummary>[];
  for (final o in all) {
    if (isPlottableCoord(o.latitude, o.longitude)) {
      plottable.add(o);
      continue;
    }
    final centroid = _stateCentroids[o.stateName];
    if (centroid == null) continue; // unknown state — can't place it
    final (dLat, dLng) = _jitterFor(o.id);
    plottable.add(o.copyWith(
      latitude: centroid.$1 + dLat,
      longitude: centroid.$2 + dLng,
    ));
  }
  return plottable;
}, name: 'mapSightings');

/// Cluster points derived from the loaded sightings.
final mapClusterPointsProvider =
    Provider.autoDispose<List<ClusterPoint>>((ref) {
  final sightings = ref.watch(mapSightingsProvider).valueOrNull ?? const [];
  return [
    for (final o in sightings)
      ClusterPoint(id: o.id, lat: o.latitude!, lng: o.longitude!),
  ];
}, name: 'mapClusterPoints');

/// The user's current GPS coordinates (null if unavailable / denied).
final userLocationProvider =
    FutureProvider.autoDispose<GeoCoords?>((ref) {
  return ref.read(locationServiceProvider).currentCoords();
}, name: 'userLocation');
