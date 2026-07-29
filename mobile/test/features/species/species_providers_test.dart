import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/features/species/data/models/species_filter.dart';
import 'package:butterfly_india/features/species/presentation/providers/species_providers.dart';
import '../../helpers/test_helpers.dart';
import 'fake_species_datasource.dart';

void main() {
  late FakeSpeciesRemoteDataSource remote;

  ProviderContainer build() => createTestContainer(
        overrides: [
          speciesRemoteDataSourceProvider.overrideWithValue(remote),
        ],
      );

  setUp(() => remote = FakeSpeciesRemoteDataSource(totalItems: 45));

  Future<void> settle(ProviderContainer c) async {
    // Allow the notifier's loadInitial() future to complete.
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }

  group('speciesListProvider — pagination', () {
    test('loadInitial populates first page', () async {
      final container = build();
      addTearDown(container.dispose);

      final sub = container.listen(speciesListProvider, (_, __) {});
      await settle(container);

      final state = sub.read();
      expect(state.status, SpeciesListStatus.success);
      expect(state.items, hasLength(20));
      expect(state.hasMore, isTrue);
    });

    test('loadMore appends the next page', () async {
      final container = build();
      addTearDown(container.dispose);
      container.listen(speciesListProvider, (_, __) {});
      await settle(container);

      await container.read(speciesListProvider.notifier).loadMore();
      final state = container.read(speciesListProvider);
      expect(state.items, hasLength(40));
      expect(state.page, 2);
    });

    test('hasMore false on final partial page', () async {
      final container = build();
      addTearDown(container.dispose);
      container.listen(speciesListProvider, (_, __) {});
      await settle(container);

      await container.read(speciesListProvider.notifier).loadMore(); // 40
      await container.read(speciesListProvider.notifier).loadMore(); // 45
      final state = container.read(speciesListProvider);
      expect(state.items, hasLength(45));
      expect(state.hasMore, isFalse);
    });

    test('changing filter rebuilds the list', () async {
      final container = build();
      addTearDown(container.dispose);
      container.listen(speciesListProvider, (_, __) {});
      await settle(container);

      container.read(speciesFilterProvider.notifier).state =
          const SpeciesFilter(rarity: 'rare');
      // New notifier instance loads initial again.
      container.listen(speciesListProvider, (_, __) {});
      await settle(container);

      expect(remote.lastFilter, const SpeciesFilter(rarity: 'rare'));
    });

    test('error state when datasource fails', () async {
      remote.fail = true;
      final container = build();
      addTearDown(container.dispose);
      container.listen(speciesListProvider, (_, __) {});
      await settle(container);

      final state = container.read(speciesListProvider);
      expect(state.hasError, isTrue);
    });
  });

  group('speciesDetailProvider', () {
    test('loads detail', () async {
      final container = build();
      addTearDown(container.dispose);

      final detail = await container.read(speciesDetailProvider('sp-1').future);
      expect(detail.commonName, 'Crimson Rose');
    });
  });

  group('similarSpeciesProvider', () {
    test('loads recommendations', () async {
      final container = build();
      addTearDown(container.dispose);

      final similar =
          await container.read(similarSpeciesProvider('sp-1').future);
      expect(similar, hasLength(2));
    });
  });
}
