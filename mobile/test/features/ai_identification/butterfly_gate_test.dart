import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/features/ai_identification/data/classifier/butterfly_classifier.dart';

/// The bundled TFLite model is a closed-set classifier — it always returns a
/// label. [ButterflyGate] is what stops a phone/leaf/moth from being shown as a
/// butterfly. These tests lock its decision boundaries.
void main() {
  group('ButterflyGate.evaluate', () {
    test('confident, dominant butterfly → butterfly', () {
      final verdict = ButterflyGate.evaluate(const [
        Classification(label: 'BLUE MORPHO', confidence: 0.92),
        Classification(label: 'MONARCH', confidence: 0.03),
      ]);
      expect(verdict, GateVerdict.butterfly);
    });

    test('confident moth class → moth (not butterfly)', () {
      final verdict = ButterflyGate.evaluate(const [
        Classification(label: 'ATLAS MOTH', confidence: 0.90),
        Classification(label: 'LUNA MOTH', confidence: 0.04),
      ]);
      expect(verdict, GateVerdict.moth);
    });

    test('low top confidence (random object) → unrecognised', () {
      final verdict = ButterflyGate.evaluate(const [
        Classification(label: 'BLUE MORPHO', confidence: 0.42),
        Classification(label: 'MONARCH', confidence: 0.31),
      ]);
      expect(verdict, GateVerdict.unrecognised);
    });

    test('high top-1 but flat spread (no clear winner) → unrecognised', () {
      final verdict = ButterflyGate.evaluate(const [
        Classification(label: 'BLUE MORPHO', confidence: 0.72),
        Classification(label: 'MONARCH', confidence: 0.60),
      ]);
      expect(verdict, GateVerdict.unrecognised);
    });

    test('empty predictions → unrecognised', () {
      expect(ButterflyGate.evaluate(const []), GateVerdict.unrecognised);
    });

    test('isMothLabel matches any MOTH class', () {
      expect(ButterflyGate.isMothLabel('ATLAS MOTH'), isTrue);
      expect(ButterflyGate.isMothLabel('cinnabar moth'), isTrue);
      expect(ButterflyGate.isMothLabel('BLUE MORPHO'), isFalse);
    });
  });
}
