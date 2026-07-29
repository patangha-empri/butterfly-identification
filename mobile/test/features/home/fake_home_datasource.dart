import 'package:butterfly_india/features/home/data/datasources/home_remote_datasource.dart';
import 'package:butterfly_india/features/home/data/models/observation_summary.dart';
import 'package:butterfly_india/features/home/data/models/species_summary.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// FAKE HOME REMOTE DATASOURCE
/// Controllable in-memory datasource for repository + provider tests.
/// ─────────────────────────────────────────────────────────────────────────────

class FakeHomeRemoteDataSource implements IHomeRemoteDataSource {
  FakeHomeRemoteDataSource({
    this.failAll = false,
    this.failNearby = false,
    this.emptyAll = false,
  });

  bool failAll;
  bool failNearby;
  bool emptyAll;

  int trendingCalls = 0;
  int nearbyCalls = 0;
  double? lastLat;
  double? lastLng;

  static SpeciesSummary species(String id) => SpeciesSummary(
        id: id,
        commonName: 'Species $id',
        scientificName: 'Genus $id',
        rarity: 'rare',
        primaryImageUrl: 'https://cdn.test/$id.jpg',
      );

  static ObservationSummary obs(String id) => ObservationSummary(
        id: id,
        title: 'Sighting $id',
        stateName: 'Karnataka',
        identifiedSpeciesName: 'Pachliopta hector',
        identificationConfidence: 0.92,
        primaryImageUrl: 'https://cdn.test/obs-$id.jpg',
        likeCount: 3,
      );

  List<SpeciesSummary> _speciesList(String prefix) =>
      emptyAll ? [] : [species('${prefix}1'), species('${prefix}2')];

  List<ObservationSummary> _obsList(String prefix) =>
      emptyAll ? [] : [obs('${prefix}1'), obs('${prefix}2')];

  @override
  Future<List<SpeciesSummary>> fetchTrendingSpecies({int limit = 10}) async {
    trendingCalls++;
    if (failAll) throw Exception('network');
    return _speciesList('t');
  }

  @override
  Future<List<SpeciesSummary>> fetchSeasonalSpecies({int limit = 10}) async {
    if (failAll) throw Exception('network');
    return _speciesList('s');
  }

  @override
  Future<List<SpeciesSummary>> fetchFeaturedSpecies({int limit = 10}) async {
    if (failAll) throw Exception('network');
    return _speciesList('f');
  }

  @override
  Future<List<ObservationSummary>> fetchNearby({
    double? lat,
    double? lng,
    int limit = 10,
  }) async {
    nearbyCalls++;
    lastLat = lat;
    lastLng = lng;
    if (failAll || failNearby) throw Exception('network');
    return _obsList('n');
  }

  @override
  Future<List<ObservationSummary>> fetchRecentObservations({
    int page = 1,
    int perPage = 20,
  }) async {
    if (failAll) throw Exception('network');
    return _obsList('r');
  }
}
