import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/core/theme/app_theme.dart';
import 'package:butterfly_india/features/gamification/data/gamification_repository.dart';
import 'package:butterfly_india/features/gamification/presentation/gamification_providers.dart';
import 'package:butterfly_india/features/gamification/presentation/screens/achievements_screen.dart';
import 'package:butterfly_india/shared/widgets/explorer_badge.dart';
import 'fake_gamification_repository.dart';

void main() {
  Future<void> pump(WidgetTester tester, {bool fail = false}) async {
    tester.view.physicalSize = const Size(420, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final container = ProviderContainer(overrides: [
      gamificationRepositoryProvider
          .overrideWithValue(FakeGamificationRepository(fail: fail)),
    ]);
    addTearDown(container.dispose);

    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: AchievementsScreen()),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pumpAndSettle();
  }

  testWidgets('renders explorer header with level + stats', (tester) async {
    await pump(tester);
    expect(find.text('Level 3 Explorer'), findsOneWidget);
    expect(find.text('Badges'), findsOneWidget);
    // stat labels
    expect(find.text('Sightings'), findsOneWidget);
    expect(find.text('Species'), findsOneWidget);
  });

  testWidgets('renders earned + locked badges', (tester) async {
    await pump(tester);
    expect(find.byType(ExplorerBadge), findsNWidgets(2));
    expect(find.text('First Flutter'), findsOneWidget);
    expect(find.text('Streak 7'), findsOneWidget);
  });

  testWidgets('tapping a badge shows its detail sheet', (tester) async {
    await pump(tester);
    await tester.tap(find.text('First Flutter'));
    await tester.pumpAndSettle();
    expect(find.text('Log your first sighting'), findsOneWidget);
    expect(find.textContaining('Earned'), findsOneWidget);
  });

  testWidgets('shows error state on failure', (tester) async {
    await pump(tester, fail: true);
    expect(find.text('Try Again'), findsWidgets);
  });
}
