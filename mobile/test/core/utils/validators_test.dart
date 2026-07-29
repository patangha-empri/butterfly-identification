import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('accepts valid emails', () {
      expect(Validators.email('a@b.com'), isNull);
      expect(Validators.email('user.name+tag@sub.domain.co'), isNull);
    });

    test('rejects invalid / empty emails', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email('not-an-email'), isNotNull);
      expect(Validators.email('missing@tld'), isNotNull);
      expect(Validators.email('@nodomain.com'), isNotNull);
    });

    test('trims whitespace', () {
      expect(Validators.email('  a@b.com  '), isNull);
    });
  });

  group('Validators.password', () {
    test('requires >= 6 chars', () {
      expect(Validators.password('12345'), isNotNull);
      expect(Validators.password('123456'), isNull);
    });

    test('rejects empty', () {
      expect(Validators.password(''), isNotNull);
      expect(Validators.password(null), isNotNull);
    });
  });

  group('Validators.strongPassword', () {
    test('accepts strong password', () {
      expect(Validators.strongPassword('Abcdef12'), isNull);
    });

    test('rejects without uppercase', () {
      expect(Validators.strongPassword('abcdef12'), 'Add an uppercase letter');
    });

    test('rejects without number', () {
      expect(Validators.strongPassword('Abcdefgh'), 'Add a number');
    });

    test('rejects short password', () {
      expect(Validators.strongPassword('Ab1'), 'Use at least 8 characters');
    });
  });

  group('Validators.confirmPassword', () {
    test('matches', () {
      expect(Validators.confirmPassword('secret')('secret'), isNull);
    });
    test('mismatch', () {
      expect(Validators.confirmPassword('secret')('other'), isNotNull);
    });
  });

  group('Validators.username', () {
    test('accepts valid username', () {
      expect(Validators.username('butterfly_fan'), isNull);
      expect(Validators.username('user123'), isNull);
    });
    test('rejects too short / invalid chars', () {
      expect(Validators.username('ab'), isNotNull);
      expect(Validators.username('has space'), isNotNull);
      expect(Validators.username('bad!char'), isNotNull);
    });
  });

  group('Validators.fullName', () {
    test('accepts a name', () => expect(Validators.fullName('Asha'), isNull));
    test('rejects empty', () => expect(Validators.fullName(''), isNotNull));
  });

  group('Validators.passwordStrength', () {
    test('empty is 0', () => expect(Validators.passwordStrength(''), 0));
    test('weak < strong', () {
      final weak = Validators.passwordStrength('abc');
      final strong = Validators.passwordStrength('Abcdef12!@');
      expect(strong, greaterThan(weak));
    });
    test('clamps to 1.0 max', () {
      expect(Validators.passwordStrength('Abcdefgh123!@#'), lessThanOrEqualTo(1.0));
    });
  });
}
