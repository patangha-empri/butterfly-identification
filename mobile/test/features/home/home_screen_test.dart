import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:butterfly_india/core/network/connectivity_service.dart';
import 'package:butterfly_india/core/theme/app_theme.dart';
import 'package:butterfly_india/features/home/data/datasources/home_remote_datasource.dart';
import 'package:butterfly_india/features/home/presentation/providers/home_providers.dart';
import 'package:butterfly_india/features/home/presentation/screens/home_screen.dart';
import 'package:butterfly_india/core/database/app_database.dart';
import 'package:butterfly_india/shared/widgets/cards/species_card.dart';
import 'package:butterfly_india/shared/widgets/states/empty_state.dart';
import '../../helpers/test_helpers.dart';
import '../../mocks/mock_services.dart';
import 'fake_home_datasource.dart';

void main() {
  Widget buildHome({
    required FakeHomeRemoteDataSource remote,
    MockConnectivityService? connectivity,
    AppDatabase? database,
  }) {
    final container = createTestContainer(
      database: database,
      connectivity: connectivity,
      overrides: [
        homeRemoteDataSourceProvider.overrideWithValue(remote),
      ],
    );
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
        GoRoute(
            path: '/species/:id',
            builder: (_, s) => Scaffold(
                body: Center(
                    child: Text('SPECIES_${s.pathParameters['id']}')))),
        GoRoute(
            path: '/observations/:id',
            builder: (_, s) => Scaffold(
                body: Center(child: Text('OBS_${s.pathParameters['id']}')))),
        GoRoute(
            path: '/search',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('SEARCH')))),
        GoRoute(
            path: '/scan',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('SCAN')))),
        GoRoute(
            path: '/notifications',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('NOTIFS')))),
      ],
    );
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    );
  }

  Future<void> pumpHome(
    WidgetTester tester, {
    required FakeHomeRemoteDataSource remote,
    MockConnectivityService? connectivity,
    AppDatabase? database,
  }) async {
    tester.view.physicalSize = const Size(400, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(buildHome(
        remote: remote,
        connectivity: connectivity,
        database: database,
      ));
      await tester.pump(); // loading frame
      await tester.pump(const Duration(milliseconds: 100)); // feed resolves
      await tester.pumpAndSettle(); // flush entrance animations
    });
  }

  testWidgets('renders greeting and quick scan card', (tester) async {
    await pumpHome(tester, remote: FakeHomeRemoteDataSource());
    expect(find.textContaining('Hi,'), findsOneWidget);
    expect(find.text('Identify a butterfly'), findsOneWidget);
  });

  testWidgets('shows trending section with species cards', (tester) async {
    await pumpHome(tester, remote: FakeHomeRemoteDataSource());
    expect(find.text('Trending now'), findsOneWidget);
    expect(find.byType(SpeciesCard), findsWidgets);
  });

  testWidgets('tapping a species card navigates to detail', (tester) async {
    await mockNetworkImagesFor(() async {
      await pumpHome(tester, remote: FakeHomeRemoteDataSource());
      await tester.tap(find.byType(SpeciesCard).first);
      await tester.pumpAndSettle();
    });
    expect(find.textContaining('SPECIES_'), findsOneWidget);
  });

  testWidgets('shows empty state when feed has no content', (tester) async {
    await pumpHome(tester, remote: FakeHomeRemoteDataSource(emptyAll: true));
    // emptyAll + offline-less → repository returns empty feed → empty state
    expect(find.byType(AppEmptyState), findsOneWidget);
  });

  testWidgets('shows offline banner when serving cached data', (tester) async {
    final db = AppDatabase.inMemory();
    addTearDown(db.close);

    // Seed the local cache directly.
    await db.speciesDao.upsertAll([
      CachedSpeciesTableCompanion.insert(
        id: 'c1',
        commonName: 'Cached Swallowtail',
        scientificName: 'Papilio cached',
      ),
    ]);
    await db.observationsDao.upsertAll([
      CachedObservationsTableCompanion.insert(id: 'o1'),
    ]);

    final connectivity = MockConnectivityService()
      ..setStatus(ConnectivityStatus.offline);

    await pumpHome(
      tester,
      remote: FakeHomeRemoteDataSource(),
      connectivity: connectivity,
      database: db,
    );

    expect(find.textContaining('offline'), findsOneWidget);
  });

  testWidgets('quick scan navigates to scan route', (tester) async {
    await pumpHome(tester, remote: FakeHomeRemoteDataSource());
    await tester.tap(find.text('Identify a butterfly'));
    await tester.pumpAndSettle();
    expect(find.text('SCAN'), findsOneWidget);
  });
}
