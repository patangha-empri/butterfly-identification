import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/features/community/presentation/providers/community_providers.dart';
import 'package:butterfly_india/features/community/presentation/screens/community_feed_screen.dart';
import 'package:butterfly_india/features/community/presentation/screens/public_profile_screen.dart';
import 'package:butterfly_india/features/community/presentation/widgets/community_post_card.dart';
import 'package:butterfly_india/features/community/presentation/widgets/like_button.dart';
import 'fake_community_repository.dart';

void main() {
  Future<ProviderContainer> pump(
    WidgetTester tester,
    Widget child, {
    FakeCommunityRepository? repo,
  }) async {
    tester.view.physicalSize = const Size(420, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final container = ProviderContainer(overrides: [
      communityRepositoryProvider
          .overrideWithValue(repo ?? FakeCommunityRepository()),
    ]);
    addTearDown(container.dispose);

    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: MaterialApp(home: child),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    return container;
  }

  group('CommunityFeedScreen', () {
    testWidgets('renders posts from the feed', (tester) async {
      await pump(tester, const CommunityFeedScreen());
      await tester.pumpAndSettle();

      expect(find.byType(CommunityPostCard), findsNWidgets(2));
      expect(find.text('Asha'), findsOneWidget);
      expect(find.text('Ravi'), findsOneWidget);
      expect(find.text('Tirumala limniace'), findsOneWidget);
    });

    testWidgets('shows error state and retries', (tester) async {
      await pump(tester, const CommunityFeedScreen(),
          repo: FakeCommunityRepository(fail: true));
      await tester.pumpAndSettle();

      expect(find.text('Try Again'), findsOneWidget);
    });

    testWidgets('shows empty state when no sightings', (tester) async {
      await pump(tester, const CommunityFeedScreen(),
          repo: FakeCommunityRepository(empty: true));
      await tester.pumpAndSettle();

      expect(find.text('No sightings yet'), findsOneWidget);
    });
  });

  group('LikeButton', () {
    testWidgets('optimistically toggles and reconciles with server',
        (tester) async {
      final repo = FakeCommunityRepository();
      await pump(
        tester,
        const Scaffold(
          body: Center(
            child: LikeButton(
              observationId: 'obs-1',
              initialLiked: false,
              initialCount: 5,
            ),
          ),
        ),
        repo: repo,
      );

      expect(find.text('5'), findsOneWidget);
      await tester.tap(find.byType(LikeButton));
      await tester.pumpAndSettle();

      expect(repo.likeCalls, 1);
      // Server returns likeCount 6.
      expect(find.text('6'), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });
  });

  group('PublicProfileScreen', () {
    testWidgets('renders profile header and sightings grid', (tester) async {
      await pump(tester, const PublicProfileScreen(username: 'asha'));
      await tester.pumpAndSettle();

      expect(find.text('Asha Nair'), findsOneWidget);
      expect(find.text('@asha'), findsWidgets);
      expect(find.text('Lepidoptera lover'), findsOneWidget);
      expect(find.byIcon(Icons.verified), findsOneWidget);
      expect(find.text('Sightings'), findsOneWidget);
    });

    testWidgets('shows error state on failure', (tester) async {
      await pump(tester, const PublicProfileScreen(username: 'ghost'),
          repo: FakeCommunityRepository(fail: true));
      await tester.pumpAndSettle();

      expect(find.text('Try Again'), findsWidgets);
    });
  });
}
