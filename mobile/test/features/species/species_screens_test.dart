import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:butterfly_india/core/theme/app_theme.dart';
import 'package:butterfly_india/features/species/presentation/providers/species_providers.dart';
import 'package:butterfly_india/features/species/presentation/screens/species_detail_screen.dart';
import 'package:butterfly_india/features/species/presentation/screens/species_list_screen.dart';
import 'package:butterfly_india/shared/widgets/cards/species_card.dart';
import '../../helpers/test_helpers.dart';
import 'fake_species_datasource.dart';

void main() {
  late FakeSpeciesRemoteDataSource remote;

  setUp(() => remote = FakeSpeciesRemoteDataSource(totalItems: 30));

  Widget buildApp(Widget home, {List<GoRoute> extra = const []}) {
    final container = createTestContainer(
      overrides: [speciesRemoteDataSourceProvider.overrideWithValue(remote)],
    );
    addTearDown(container.dispose);
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, __) => home),
        GoRoute(
          path: '/species/:id',
          builder: (_, s) =>
              SpeciesDetailScreen(speciesId: s.pathParameters['id']!),
        ),
        ...extra,
      ],
    );
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    );
  }

  Future<void> pump(WidgetTester tester, Widget app) async {
    tester.view.physicalSize = const Size(420, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(app);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpAndSettle();
    });
  }

  group('SpeciesListScreen', () {
    testWidgets('renders grid of species cards', (tester) async {
      await pump(tester, buildApp(const SpeciesListScreen()));
      expect(find.byType(SpeciesCard), findsWidgets);
    });

    testWidgets('has search field and filter button', (tester) async {
      await pump(tester, buildApp(const SpeciesListScreen()));
      expect(find.byIcon(Icons.tune), findsOneWidget);
      expect(find.text('Search species…'), findsOneWidget);
    });

    testWidgets('opens filter sheet on filter tap', (tester) async {
      await pump(tester, buildApp(const SpeciesListScreen()));
      await tester.tap(find.byIcon(Icons.tune));
      await tester.pumpAndSettle();
      expect(find.text('Filter species'), findsOneWidget);
      expect(find.text('Family'), findsOneWidget);
      expect(find.text('Active in month'), findsOneWidget);
    });

    testWidgets('tapping a card navigates to detail', (tester) async {
      await mockNetworkImagesFor(() async {
        await pump(tester, buildApp(const SpeciesListScreen()));
        await tester.tap(find.byType(SpeciesCard).first);
        await tester.pumpAndSettle();
      });
      expect(find.text('Crimson Rose'), findsOneWidget);
    });

    testWidgets('shows empty state when no results', (tester) async {
      remote.totalItems = 0;
      await pump(tester, buildApp(const SpeciesListScreen()));
      expect(find.text('No species found'), findsOneWidget);
    });

    testWidgets('shows error state retry when datasource fails',
        (tester) async {
      remote.fail = true;
      await pump(tester, buildApp(const SpeciesListScreen()));
      expect(find.text('Try Again'), findsOneWidget);
    });
  });

  group('SpeciesDetailScreen', () {
    testWidgets('renders detail content', (tester) async {
      await pump(
        tester,
        buildApp(const SpeciesDetailScreen(speciesId: 'sp-1')),
      );
      expect(find.text('Crimson Rose'), findsOneWidget);
      expect(find.text('Pachliopta hector'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
      expect(find.text('Flight season'), findsOneWidget);
      expect(find.text('Host plants'), findsOneWidget);
      expect(find.text('Distribution in India'), findsOneWidget);
    });

    testWidgets('shows distribution states as chips', (tester) async {
      await pump(
        tester,
        buildApp(const SpeciesDetailScreen(speciesId: 'sp-1')),
      );
      expect(find.text('Kerala'), findsOneWidget);
      expect(find.text('Karnataka'), findsOneWidget);
    });
  });
}
