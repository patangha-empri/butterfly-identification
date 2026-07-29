import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/features/species/data/models/species_detail.dart';
import 'package:butterfly_india/features/species/data/models/species_filter.dart';

void main() {
  group('SpeciesDetail.fromJson', () {
    test('parses full payload', () {
      final json = {
        'id': 'sp-1',
        'common_name': 'Crimson Rose',
        'scientific_name': 'Pachliopta hector',
        'family': 'Papilionidae',
        'conservation_status': 'LC',
        'wingspan_mm': '90-110 mm',
        'flight_months': [1, 2, 11, 12],
        'host_plants': [
          {'name': 'Aristolochia', 'scientific_name': 'A. indica'}
        ],
        'states': ['Kerala', 'Karnataka'],
        'images': [
          {'image_url': 'https://cdn/1.jpg', 'is_primary': true}
        ],
        'primary_image_url': 'https://cdn/1.jpg',
        'observation_count': 12,
      };
      final d = SpeciesDetail.fromJson(json);
      expect(d.commonName, 'Crimson Rose');
      expect(d.flightMonths, [1, 2, 11, 12]);
      expect(d.hostPlants.single.name, 'Aristolochia');
      expect(d.states, hasLength(2));
      expect(d.images.single.url, 'https://cdn/1.jpg');
    });

    test('defaults collections to empty', () {
      final d = SpeciesDetail.fromJson({
        'id': 'sp-2',
        'common_name': 'X',
        'scientific_name': 'Y',
      });
      expect(d.flightMonths, isEmpty);
      expect(d.hostPlants, isEmpty);
      expect(d.states, isEmpty);
      expect(d.hasDistribution, isFalse);
      expect(d.hasFlightData, isFalse);
    });

    test('galleryUrls prepends primary image when missing from images', () {
      final d = SpeciesDetail.fromJson({
        'id': 'sp-3',
        'common_name': 'X',
        'scientific_name': 'Y',
        'primary_image_url': 'https://cdn/primary.jpg',
        'images': [
          {'image_url': 'https://cdn/other.jpg'}
        ],
      });
      expect(d.galleryUrls.first, 'https://cdn/primary.jpg');
      expect(d.galleryUrls, hasLength(2));
    });
  });

  group('SpeciesFilter', () {
    test('activeCount counts only facet filters', () {
      const f = SpeciesFilter(query: 'rose', rarity: 'rare', family: 'X');
      expect(f.activeCount, 2); // query excluded
    });

    test('isEmpty true for default filter', () {
      expect(const SpeciesFilter().isEmpty, isTrue);
    });

    test('copyWith clears via flags', () {
      const f = SpeciesFilter(rarity: 'rare', family: 'X');
      final cleared = f.copyWith(clearRarity: true);
      expect(cleared.rarity, isNull);
      expect(cleared.family, 'X');
    });

    test('clearedFacets keeps query + sort', () {
      const f = SpeciesFilter(
        query: 'rose',
        rarity: 'rare',
        sort: SpeciesSort.mostObserved,
      );
      final cleared = f.clearedFacets();
      expect(cleared.query, 'rose');
      expect(cleared.sort, SpeciesSort.mostObserved);
      expect(cleared.activeCount, 0);
    });

    test('toQueryParameters maps to backend params (search/family/state)', () {
      const f = SpeciesFilter(query: 'rose', family: 'Pieridae', stateId: 11);
      final params = f.toQueryParameters(page: 2, perPage: 10);
      expect(params['page'], 2);
      expect(params['per_page'], 10);
      // Backend expects `search`, not `q`.
      expect(params['search'], 'rose');
      expect(params['family'], 'Pieridae');
      expect(params['state_id'], 11);
    });

    test('toQueryParameters omits unsupported facets (rarity/month/sort)', () {
      const f = SpeciesFilter(rarity: 'rare', month: 5, sort: SpeciesSort.rarity);
      final params = f.toQueryParameters(page: 1);
      expect(params.containsKey('rarity'), isFalse);
      expect(params.containsKey('month'), isFalse);
      expect(params.containsKey('sort'), isFalse);
      expect(params.containsKey('q'), isFalse);
    });

    test('equality by value (provider family key)', () {
      expect(const SpeciesFilter(rarity: 'rare'),
          const SpeciesFilter(rarity: 'rare'));
      expect(const SpeciesFilter(rarity: 'rare'),
          isNot(const SpeciesFilter(rarity: 'common')));
    });
  });
}
