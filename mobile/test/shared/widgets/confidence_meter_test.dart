import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/shared/widgets/confidence_meter.dart';
import '../../helpers/widget_test_harness.dart';

void main() {
  group('ConfidenceTier', () {
    test('maps >=0.90 to certain', () {
      expect(ConfidenceTier.fromValue(0.95), ConfidenceTier.certain);
      expect(ConfidenceTier.fromValue(0.90), ConfidenceTier.certain);
    });

    test('maps 0.70-0.89 to likely', () {
      expect(ConfidenceTier.fromValue(0.80), ConfidenceTier.likely);
      expect(ConfidenceTier.fromValue(0.70), ConfidenceTier.likely);
    });

    test('maps 0.50-0.69 to possible', () {
      expect(ConfidenceTier.fromValue(0.60), ConfidenceTier.possible);
    });

    test('maps <0.50 to uncertain', () {
      expect(ConfidenceTier.fromValue(0.30), ConfidenceTier.uncertain);
      expect(ConfidenceTier.fromValue(0.0), ConfidenceTier.uncertain);
    });

    test('each tier has a distinct color', () {
      final colors = ConfidenceTier.values.map((t) => t.color).toSet();
      expect(colors.length, ConfidenceTier.values.length);
    });
  });

  group('ConfidenceMeter widget', () {
    testWidgets('renders percentage label', (tester) async {
      await tester.pumpWidget(
        wrapForTest(const ConfidenceMeter(value: 0.95, animate: false)),
      );
      await tester.pump();
      expect(find.text('95%'), findsOneWidget);
    });

    testWidgets('renders tier label', (tester) async {
      await tester.pumpWidget(
        wrapForTest(const ConfidenceMeter(value: 0.95, animate: false)),
      );
      await tester.pump();
      expect(find.text('Certain'), findsOneWidget);
    });

    testWidgets('exposes accessible semantics', (tester) async {
      await tester.pumpWidget(
        wrapForTest(const ConfidenceMeter(value: 0.95, animate: false)),
      );
      expect(
        find.bySemanticsLabel(RegExp('AI confidence Certain')),
        findsOneWidget,
      );
    });

    testWidgets('hides label when showLabel false', (tester) async {
      await tester.pumpWidget(
        wrapForTest(const ConfidenceMeter(
          value: 0.95,
          showLabel: false,
          animate: false,
        )),
      );
      await tester.pump();
      expect(find.text('95%'), findsNothing);
    });

    testWidgets('animates from 0 to value', (tester) async {
      await tester.pumpWidget(
        wrapForTest(const ConfidenceMeter(value: 0.90)),
      );
      // Mid-animation — value still climbing
      await tester.pump(const Duration(milliseconds: 100));
      // Complete
      await tester.pump(const Duration(milliseconds: 900));
      expect(find.text('90%'), findsOneWidget);
    });
  });

  group('ConfidenceBar widget', () {
    testWidgets('renders percentage', (tester) async {
      await tester.pumpWidget(
        wrapForTest(const SizedBox(
          width: 200,
          child: ConfidenceBar(value: 0.75, animate: false),
        )),
      );
      await tester.pump();
      expect(find.text('75%'), findsOneWidget);
    });
  });
}
