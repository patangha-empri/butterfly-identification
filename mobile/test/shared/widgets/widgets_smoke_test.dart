import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/shared/widgets/widgets.dart';
import '../../helpers/widget_test_harness.dart';

/// Smoke tests — every shared widget builds without throwing, in both themes,
/// and respects accessibility (reduced motion + text scaling).
void main() {
  group('GlassCard', () {
    testWidgets('builds with child', (tester) async {
      await tester.pumpWidget(
        wrapForTest(const GlassCard(child: Text('Glass content'))),
      );
      expect(find.text('Glass content'), findsOneWidget);
    });

    testWidgets('tap fires callback', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrapForTest(GlassCard(
          onTap: () => tapped = true,
          child: const Text('Tap'),
        )),
      );
      await tester.tap(find.byType(GlassCard));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('renders in dark theme', (tester) async {
      await tester.pumpWidget(
        wrapForTest(
          const GlassCard(child: Text('Dark')),
          brightness: Brightness.dark,
        ),
      );
      expect(find.text('Dark'), findsOneWidget);
    });
  });

  group('ExplorerBadge', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(
        wrapForTest(const ExplorerBadge(
          icon: Icons.star,
          label: 'First Sighting',
          animateOnAppear: false,
        )),
      );
      expect(find.text('First Sighting'), findsOneWidget);
    });

    testWidgets('shows lock icon when locked', (tester) async {
      await tester.pumpWidget(
        wrapForTest(const ExplorerBadge(
          icon: Icons.star,
          label: 'Locked',
          isLocked: true,
          animateOnAppear: false,
        )),
      );
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('shows NEW ribbon when isNew', (tester) async {
      await tester.pumpWidget(
        wrapForTest(const ExplorerBadge(
          icon: Icons.star,
          label: 'New badge',
          isNew: true,
          animateOnAppear: false,
        )),
      );
      expect(find.text('NEW'), findsOneWidget);
    });
  });

  group('XpProgressBar', () {
    testWidgets('renders level and XP', (tester) async {
      await tester.pumpWidget(
        wrapForTest(const XpProgressBar(
          currentXp: 150,
          levelXp: 300,
          level: 4,
        )),
      );
      expect(find.text('Level 4'), findsOneWidget);
      expect(find.text('150 / 300 XP'), findsOneWidget);
    });
  });

  group('FloatingSearchBar', () {
    testWidgets('renders hint', (tester) async {
      await tester.pumpWidget(
        wrapForTest(const FloatingSearchBar(hint: 'Search…')),
      );
      expect(find.text('Search…'), findsOneWidget);
    });

    testWidgets('onChanged fires', (tester) async {
      String? value;
      await tester.pumpWidget(
        wrapForTest(FloatingSearchBar(
          onChanged: (v) => value = v,
        )),
      );
      await tester.enterText(find.byType(TextField), 'tiger');
      expect(value, 'tiger');
    });
  });

  group('AppEmptyState', () {
    testWidgets('renders title and message', (tester) async {
      await tester.pumpWidget(
        wrapForTest(const AppEmptyState(
          icon: Icons.inbox,
          title: 'Nothing here',
          message: 'No sightings yet',
        )),
      );
      expect(find.text('Nothing here'), findsOneWidget);
      expect(find.text('No sightings yet'), findsOneWidget);
    });

    testWidgets('offline factory shows retry', (tester) async {
      var retried = false;
      await tester.pumpWidget(
        wrapForTest(AppEmptyState.offline(onRetry: () => retried = true)),
      );
      expect(find.text('Retry'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      await tester.pump();
      expect(retried, isTrue);
    });
  });

  group('Skeleton loaders', () {
    testWidgets('SpeciesCardSkeleton builds', (tester) async {
      await tester.pumpWidget(
        wrapForTest(const SizedBox(width: 180, child: SpeciesCardSkeleton())),
      );
      expect(find.byType(SpeciesCardSkeleton), findsOneWidget);
    });

    testWidgets('respects reduced motion', (tester) async {
      await tester.pumpWidget(
        wrapForTest(
          const SizedBox(width: 180, child: SpeciesCardSkeleton()),
          reduceMotion: true,
        ),
      );
      expect(find.byType(SpeciesCardSkeleton), findsOneWidget);
    });
  });

  group('AnimatedBottomNav', () {
    const items = [
      AnimatedNavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
      AnimatedNavItem(icon: Icons.map_outlined, activeIcon: Icons.map, label: 'Map'),
    ];

    testWidgets('renders all items and fires onTap', (tester) async {
      var tappedIndex = -1;
      await tester.pumpWidget(
        wrapForTest(AnimatedBottomNav(
          items: items,
          currentIndex: 0,
          onTap: (i) => tappedIndex = i,
        )),
      );
      await tester.pump();
      expect(find.text('Home'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.map_outlined));
      await tester.pump();
      expect(tappedIndex, 1);
    });
  });

  group('ScanOverlay', () {
    testWidgets('builds for each ScanState', (tester) async {
      for (final state in ScanState.values) {
        await tester.pumpWidget(
          wrapForTest(SizedBox(
            width: 400,
            height: 600,
            child: ScanOverlay(state: state),
          )),
        );
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.byType(ScanOverlay), findsOneWidget);
      }
    });
  });

  group('Text scaling accessibility', () {
    testWidgets('AppButton survives large text scale', (tester) async {
      await tester.pumpWidget(
        wrapForTest(
          AppButton(label: 'Scaled', onPressed: () {}),
          textScale: 1.4,
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Scaled'), findsOneWidget);
    });
  });
}
