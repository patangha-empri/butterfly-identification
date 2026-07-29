import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../data/geography_models.dart';
import '../data/geography_remote_datasource.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// GEOGRAPHY PROVIDERS
/// States are cached for the session; districts are loaded per selected state.
/// ─────────────────────────────────────────────────────────────────────────────

final geographyDataSourceProvider = Provider<IGeographyRemoteDataSource>(
  (ref) => GeographyRemoteDataSource(dio: ref.read(dioProvider)),
  name: 'geographyDataSource',
);

final statesProvider = FutureProvider<List<IndiaState>>(
  (ref) => ref.read(geographyDataSourceProvider).fetchStates(),
  name: 'states',
);

final districtsProvider =
    FutureProvider.family<List<IndiaDistrict>, int>(
  (ref, stateId) =>
      ref.read(geographyDataSourceProvider).fetchDistricts(stateId),
  name: 'districts',
);

/// The app currently operates in Karnataka only, so sightings are not asked
/// for a state — they all default to this one. State ids are assigned by the
/// backend database, so it is resolved by code/name rather than hardcoded.
final defaultStateIdProvider = FutureProvider<int>(
  (ref) async {
    final states = await ref.watch(statesProvider.future);
    return states
        .firstWhere(
          (s) => s.code == 'KA' || s.name.toLowerCase() == 'karnataka',
        )
        .id;
  },
  name: 'defaultStateId',
);
