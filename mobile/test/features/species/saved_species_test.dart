import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/core/database/app_database.dart';
import 'package:butterfly_india/core/providers/core_providers.dart';
import 'package:butterfly_india/features/species/presentation/providers/species_providers.dart';
import '../../helpers/test_helpers.dart';

void main() {
  test('savedSpeciesProvider streams only bookmarked species', () async {
    final container = createTestContainer();
    addTearDown(container.dispose);
    final dao = container.read(appDatabaseProvider).speciesDao;

    // One bookmarked, one not.
    await dao.upsert(const CachedSpeciesTableCompanion(
      id: Value('sp-1'),
      commonName: Value('Crimson Rose'),
      scientificName: Value('Pachliopta hector'),
      isBookmarked: Value(true),
    ));
    await dao.upsert(const CachedSpeciesTableCompanion(
      id: Value('sp-2'),
      commonName: Value('Common Crow'),
      scientificName: Value('Euploea core'),
      isBookmarked: Value(false),
    ));

    final saved = await container.read(savedSpeciesProvider.future);

    expect(saved.map((s) => s.id), ['sp-1']);
    expect(saved.first.commonName, 'Crimson Rose');
  });
}
