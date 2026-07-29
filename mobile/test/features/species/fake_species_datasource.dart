import 'package:butterfly_india/features/home/data/models/species_summary.dart';
import 'package:butterfly_india/features/species/data/datasources/species_remote_datasource.dart';
import 'package:butterfly_india/features/species/data/models/species_detail.dart';
import 'package:butterfly_india/features/species/data/models/species_filter.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// FAKE SPECIES REMOTE DATASOURCE
/// ─────────────────────────────────────────────────────────────────────────────

class FakeSpeciesRemoteDataSource implements ISpeciesRemoteDataSource {
  FakeSpeciesRemoteDataSource({
    this.totalItems = 45,
    this.fail = false,
  });

  /// Total number of species the fake "server" holds (for pagination).
  int totalItems;
  bool fail;

  int fetchCalls = 0;
  int? lastPage;
  SpeciesFilter? lastFilter;
  String? lastSearchQuery;

  static SpeciesSummary species(int n) => SpeciesSummary(
        id: 'sp-$n',
        commonName: 'Species $n',
        scientificName: 'Genus species $n',
        rarity: n.isEven ? 'common' : 'rare',
        primaryImageUrl: 'https://cdn.test/$n.jpg',
      );

  @override
  Future<List<SpeciesSummary>> fetchSpecies({
    required int page,
    int perPage = 20,
    SpeciesFilter filter = const SpeciesFilter(),
  }) async {
    fetchCalls++;
    lastPage = page;
    lastFilter = filter;
    if (fail) throw Exception('network');

    final start = (page - 1) * perPage;
    if (start >= totalItems) return [];
    final end = (start + perPage).clamp(0, totalItems);
    return [for (var i = start; i < end; i++) species(i + 1)];
  }

  @override
  Future<List<SpeciesSummary>> searchSpecies(String query, {int page = 1}) async {
    lastSearchQuery = query;
    if (fail) throw Exception('network');
    return [species(1), species(2)];
  }

  @override
  Future<SpeciesDetail> fetchDetail(String id) async {
    if (fail) throw Exception('network');
    return SpeciesDetail(
      id: id,
      commonName: 'Crimson Rose',
      scientificName: 'Pachliopta hector',
      family: 'Papilionidae',
      rarity: 'uncommon',
      conservationStatus: 'LC',
      description: 'A striking swallowtail of peninsular India.',
      wingspanMm: '90–110 mm',
      flightMonths: const [1, 2, 9, 10, 11, 12],
      hostPlants: const [HostPlant(name: 'Aristolochia', scientificName: 'A. indica')],
      states: const ['Kerala', 'Karnataka', 'Tamil Nadu'],
      images: const [SpeciesImage(url: 'https://cdn.test/1.jpg', isPrimary: true)],
      primaryImageUrl: 'https://cdn.test/1.jpg',
      observationCount: 120,
    );
  }

  @override
  Future<List<SpeciesSummary>> fetchSimilar(String id) async {
    if (fail) throw Exception('network');
    return [species(10), species(11)];
  }
}
