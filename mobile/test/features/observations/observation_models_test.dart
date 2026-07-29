import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/features/observations/data/models/observation.dart';
import 'package:butterfly_india/features/observations/data/models/observation_draft.dart';

void main() {
  group('Observation.fromJson', () {
    test('parses identification fields', () {
      final o = Observation.fromJson({
        'id': 'obs-1',
        'title': 'Spotted',
        'state_name': 'Kerala',
        'identified_species_name': 'Pachliopta hector',
        'identification_confidence': 0.93,
        'identification_status': 'identified',
        'like_count': 5,
      });
      expect(o.isIdentified, isTrue);
      expect(o.identificationConfidence, 0.93);
      expect(o.likeCount, 5);
      expect(o.isAnalysing, isFalse);
    });

    test('isAnalysing true while processing', () {
      final o = Observation.fromJson({
        'id': 'obs-2',
        'identification_status': 'processing',
      });
      expect(o.isAnalysing, isTrue);
      expect(o.isIdentified, isFalse);
    });
  });

  group('ObservationPrivacy', () {
    test('uses backend values', () {
      expect(ObservationPrivacy.public.value, 'public');
      expect(ObservationPrivacy.anonymousPublic.value, 'anonymous_public');
      expect(ObservationPrivacy.private.value, 'private');
    });

    test('fromValue maps + defaults to public', () {
      expect(ObservationPrivacy.fromValue('private'), ObservationPrivacy.private);
      expect(ObservationPrivacy.fromValue('x'), ObservationPrivacy.public);
    });
  });

  group('ObservationDraft.toCreateJson', () {
    test('includes required + set fields, omits empties', () {
      final draft = ObservationDraft(
        title: '  Crimson Rose  ',
        notes: '',
        stateId: 11,
        districtId: 3,
        weather: Weather.sunny,
        activity: ButterflyActivity.feeding,
        countObserved: 2,
        privacy: ObservationPrivacy.anonymousPublic,
      );
      final json = draft.toCreateJson();

      expect(json['title'], 'Crimson Rose'); // trimmed
      expect(json.containsKey('notes'), isFalse); // empty omitted
      expect(json['state_id'], 11);
      expect(json['district_id'], 3);
      expect(json['weather'], 'sunny');
      expect(json['butterfly_activity'], 'feeding');
      expect(json['count_observed'], 2);
      expect(json['privacy'], 'anonymous_public');
    });

    test('isValid requires a state', () {
      expect(ObservationDraft().isValid, isFalse);
      expect(ObservationDraft(stateId: 1).isValid, isTrue);
    });
  });
}
