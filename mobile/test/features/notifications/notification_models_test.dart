import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/features/notifications/data/models/app_notification.dart';
import 'package:butterfly_india/features/notifications/data/models/notification_preferences.dart';

void main() {
  group('AppNotification.fromJson', () {
    test('parses backend shape + extracts deep-link ids', () {
      final n = AppNotification.fromJson({
        'id': 'n1',
        'type': 'identification_complete',
        'title': 'Identified!',
        'body': 'Crimson Rose',
        'data': {'observation_id': 'obs-9', 'species_id': 'sp-2'},
        'is_read': false,
        'created_at': '2026-05-29T10:00:00Z',
      });
      expect(n.isRead, isFalse);
      expect(n.observationId, 'obs-9');
      expect(n.speciesId, 'sp-2');
      expect(n.kind, NotificationKind.identification);
    });

    test('defaults when fields missing', () {
      final n = AppNotification.fromJson({'id': 'n2'});
      expect(n.title, '');
      expect(n.isRead, isFalse);
      expect(n.kind, NotificationKind.system);
    });
  });

  group('NotificationKind.fromType', () {
    test('maps known categories', () {
      expect(NotificationKind.fromType('identification_complete'),
          NotificationKind.identification);
      expect(NotificationKind.fromType('new_like'), NotificationKind.social);
      expect(NotificationKind.fromType('achievement_unlocked'),
          NotificationKind.achievement);
      expect(NotificationKind.fromType('species_nearby'),
          NotificationKind.nearby);
      expect(NotificationKind.fromType('weird'), NotificationKind.system);
    });
  });

  group('NotificationPreferences', () {
    test('round-trips backend keys', () {
      final p = NotificationPreferences.fromJson({
        'identification_complete': false,
        'new_species_nearby': true,
        'admin_verification': false,
        'educational_alerts': true,
        'events': false,
      });
      expect(p.identificationComplete, isFalse);
      expect(p.events, isFalse);
      final json = p.toJson();
      expect(json['identification_complete'], false);
      expect(json['new_species_nearby'], true);
    });

    test('defaults to all-on', () {
      const p = NotificationPreferences();
      expect(p.identificationComplete, isTrue);
      expect(p.events, isTrue);
    });
  });
}
