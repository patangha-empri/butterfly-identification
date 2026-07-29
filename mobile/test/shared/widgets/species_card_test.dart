import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:butterfly_india/shared/widgets/cards/species_card.dart';
import 'package:butterfly_india/shared/widgets/cards/rarity_badge.dart';
import '../../helpers/widget_test_harness.dart';

void main() {
  group('SpeciesCard', () {
    testWidgets('renders common + scientific name', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          wrapForTest(const SizedBox(
            width: 180,
            child: SpeciesCard(
              id: 'sp-1',
              commonName: 'Crimson Rose',
              scientificName: 'Pachliopta hector',
            ),
          )),
        );
        await tester.pump();
        expect(find.text('Crimson Rose'), findsOneWidget);
        expect(find.text('Pachliopta hector'), findsOneWidget);
      });
    });

    testWidgets('shows rarity badge when provided', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          wrapForTest(const SizedBox(
            width: 180,
            child: SpeciesCard(
              id: 'sp-1',
              commonName: 'Crimson Rose',
              scientificName: 'Pachliopta hector',
              rarity: RarityTier.rare,
            ),
          )),
        );
        await tester.pump();
        expect(find.byType(RarityBadge), findsOneWidget);
      });
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          wrapForTest(SizedBox(
            width: 180,
            child: SpeciesCard(
              id: 'sp-1',
              commonName: 'Crimson Rose',
              scientificName: 'Pachliopta hector',
              onTap: () => tapped = true,
            ),
          )),
        );
        await tester.pump();
        await tester.tap(find.byType(SpeciesCard));
        await tester.pump();
        expect(tapped, isTrue);
      });
    });

    testWidgets('bookmark toggle fires callback', (tester) async {
      var toggled = false;
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          wrapForTest(SizedBox(
            width: 180,
            child: SpeciesCard(
              id: 'sp-1',
              commonName: 'Crimson Rose',
              scientificName: 'Pachliopta hector',
              onBookmarkToggle: () => toggled = true,
            ),
          )),
        );
        await tester.pump();
        await tester.tap(find.byIcon(Icons.bookmark_border));
        await tester.pump();
        expect(toggled, isTrue);
      });
    });

    testWidgets('has accessible semantics label', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          wrapForTest(const SizedBox(
            width: 180,
            child: SpeciesCard(
              id: 'sp-1',
              commonName: 'Crimson Rose',
              scientificName: 'Pachliopta hector',
            ),
          )),
        );
        await tester.pump();
        expect(
          find.bySemanticsLabel(RegExp('Crimson Rose')),
          findsWidgets,
        );
      });
    });
  });

  group('RarityBadge', () {
    test('fromString maps known tiers', () {
      expect(RarityTier.fromString('rare'), RarityTier.rare);
      expect(RarityTier.fromString('endangered'), RarityTier.endangered);
      expect(RarityTier.fromString('unknown'), RarityTier.common);
      expect(RarityTier.fromString(null), RarityTier.common);
    });

    testWidgets('renders label in non-compact mode', (tester) async {
      await tester.pumpWidget(
        wrapForTest(const RarityBadge(tier: RarityTier.rare)),
      );
      expect(find.text('RARE'), findsOneWidget);
    });
  });
}
