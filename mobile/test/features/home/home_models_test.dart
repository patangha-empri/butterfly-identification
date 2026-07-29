import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/features/home/data/models/home_feed.dart';
import 'package:butterfly_india/features/home/data/models/observation_summary.dart';
import 'package:butterfly_india/features/home/data/models/species_summary.dart';

void main() {
  group('SpeciesSummary.fromJson', () {
    test('parses snake_case backend shape', () {
      final json = {
        'id': 'sp-1',
        'common_name': 'Crimson Rose',
        'scientific_name': 'Pachliopta hector',
        'family': 'Papilionidae',
        'rarity': 'uncommon',
        'conservation_status': 'LC',
        'primary_image_url': 'https://cdn/x.jpg',
        'observation_count': 42,
      };
      final s = SpeciesSummary.fromJson(json);
      expect(s.id, 'sp-1');
      expect(s.commonName, 'Crimson Rose');
      expect(s.scientificName, 'Pachliopta hector');
      expect(s.observationCount, 42);
    });

    test('defaults observationCount to 0 when missing', () {
      final s = SpeciesSummary.fromJson({
        'id': 'sp-2',
        'common_name': 'X',
        'scientific_name': 'Y',
      });
      expect(s.observationCount, 0);
    });
  });

  group('ObservationSummary.fromJson', () {
    test('parses fields incl. confidence + created_at', () {
      final o = ObservationSummary.fromJson({
        'id': 'obs-1',
        'title': 'Spotted one',
        'state_name': 'Kerala',
        'identification_confidence': 0.95,
        'primary_image_url': 'https://cdn/o.jpg',
        'like_count': 7,
        'created_at': '2026-01-02T10:00:00Z',
      });
      expect(o.id, 'obs-1');
      expect(o.identificationConfidence, 0.95);
      expect(o.likeCount, 7);
      expect(o.createdAt, isNotNull);
    });

    test('applies defaults for privacy/status/counts', () {
      final o = ObservationSummary.fromJson({'id': 'obs-2'});
      expect(o.privacy, 'public');
      expect(o.status, 'pending');
      expect(o.likeCount, 0);
      expect(o.commentCount, 0);
    });
  });

  group('HomeFeed', () {
    test('isEmpty true when all sections empty', () {
      expect(const HomeFeed().isEmpty, isTrue);
    });

    test('isEmpty false when any section populated', () {
      final feed = HomeFeed(trending: [SpeciesSummary.fromJson(
        {'id': 'a', 'common_name': 'A', 'scientific_name': 'B'},
      )]);
      expect(feed.isEmpty, isFalse);
    });
  });
}
