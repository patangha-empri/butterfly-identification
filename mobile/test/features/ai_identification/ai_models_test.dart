import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/features/ai_identification/data/models/ai_result.dart';

void main() {
  group('AiResult.fromJson', () {
    test('parses result with ranked matches', () {
      final r = AiResult.fromJson({
        'id': 'res-1',
        'observation_id': 'obs-1',
        'status': 'completed',
        'matches': [
          {
            'id': 2,
            'rank': 2,
            'confidence_score': 0.4,
            'matched_common_name': 'Common Rose',
            'matched_scientific_name': 'Pachliopta aristolochiae',
            'species_id': 'sp-2',
          },
          {
            'id': 1,
            'rank': 1,
            'confidence_score': 0.94,
            'matched_common_name': 'Crimson Rose',
            'matched_scientific_name': 'Pachliopta hector',
            'species_id': 'sp-1',
            'species': {'primary_image_url': 'https://cdn/1.jpg', 'rarity': 'rare'},
          },
        ],
      });

      expect(r.isCompleted, isTrue);
      expect(r.topMatch!.rank, 1); // sorted by rank
      expect(r.topMatch!.commonName, 'Crimson Rose');
      expect(r.topMatch!.imageUrl, 'https://cdn/1.jpg');
      expect(r.topMatch!.rarity, 'rare');
      expect(r.alternatives, hasLength(1));
      expect(r.alternatives.first.commonName, 'Common Rose');
    });

    test('hasNoMatch when completed with empty matches', () {
      final r = AiResult.fromJson({
        'id': 'r',
        'status': 'completed',
        'matches': <dynamic>[],
      });
      expect(r.hasNoMatch, isTrue);
      expect(r.topMatch, isNull);
    });

    test('isFailed maps status', () {
      final r = AiResult.fromJson({
        'id': 'r',
        'status': 'failed',
        'error_message': 'gemini error',
      });
      expect(r.isFailed, isTrue);
      expect(r.errorMessage, 'gemini error');
    });

    test('match display fallbacks', () {
      const m = AiMatch(id: 1);
      expect(m.displayCommonName, 'Unknown species');
      expect(m.displayScientificName, '');
      expect(m.imageUrl, isNull);
    });
  });
}
