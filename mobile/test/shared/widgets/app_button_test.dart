import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/shared/widgets/buttons/app_button.dart';
import '../../helpers/widget_test_harness.dart';

void main() {
  group('AppButton', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(
        wrapForTest(const AppButton(label: 'Submit')),
      );
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        wrapForTest(AppButton(
          label: 'Tap me',
          onPressed: () => pressed = true,
        )),
      );

      await tester.tap(find.byType(AppButton));
      await tester.pump();
      expect(pressed, isTrue);
    });

    testWidgets('does not call onPressed when disabled', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        wrapForTest(AppButton(
          label: 'Disabled',
          onPressed: null,
        )),
      );

      await tester.tap(find.byType(AppButton));
      await tester.pump();
      expect(pressed, isFalse);
    });

    testWidgets('shows loading indicator when isLoading', (tester) async {
      await tester.pumpWidget(
        wrapForTest(AppButton(
          label: 'Loading',
          isLoading: true,
          onPressed: () {},
        )),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Label hidden during loading
      expect(find.text('Loading'), findsNothing);
    });

    testWidgets('does not call onPressed while loading', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        wrapForTest(AppButton(
          label: 'Loading',
          isLoading: true,
          onPressed: () => pressed = true,
        )),
      );

      await tester.tap(find.byType(AppButton));
      await tester.pump();
      expect(pressed, isFalse);
    });

    testWidgets('renders leading icon', (tester) async {
      await tester.pumpWidget(
        wrapForTest(AppButton(
          label: 'With Icon',
          icon: Icons.add,
          onPressed: () {},
        )),
      );
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('exposes button semantics', (tester) async {
      await tester.pumpWidget(
        wrapForTest(AppButton(label: 'Accessible', onPressed: () {})),
      );

      final semantics = tester.widget<Semantics>(
        find
            .descendant(
              of: find.byType(AppButton),
              matching: find.byType(Semantics),
            )
            .first,
      );
      expect(semantics.properties.button, isTrue);
      expect(semantics.properties.label, 'Accessible');
    });

    testWidgets('renders in both light and dark themes', (tester) async {
      await testBothThemes(
        tester,
        AppButton(label: 'Themed', onPressed: () {}),
        (brightness) async {
          expect(find.text('Themed'), findsOneWidget);
        },
      );
    });

    testWidgets('all variants render without error', (tester) async {
      for (final variant in AppButtonVariant.values) {
        await tester.pumpWidget(
          wrapForTest(AppButton(
            label: variant.name,
            variant: variant,
            onPressed: () {},
          )),
        );
        expect(find.text(variant.name), findsOneWidget);
      }
    });
  });
}
