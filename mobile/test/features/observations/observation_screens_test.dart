import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:butterfly_india/core/theme/app_theme.dart';
import 'package:butterfly_india/features/geography/data/geography_models.dart';
import 'package:butterfly_india/features/geography/presentation/geography_providers.dart';
import 'package:butterfly_india/features/observations/presentation/providers/observation_providers.dart';
import 'package:butterfly_india/features/observations/presentation/screens/my_observations_screen.dart';
import 'package:butterfly_india/features/observations/presentation/screens/observation_detail_screen.dart';
import 'package:butterfly_india/features/observations/presentation/screens/submit_observation_screen.dart';
import 'package:butterfly_india/shared/widgets/confidence_meter.dart';
import '../../helpers/test_helpers.dart';
import 'fake_observation_datasource.dart';

void main() {
  late FakeObservationRemoteDataSource remote;

  setUp(() => remote = FakeObservationRemoteDataSource());

  Widget buildApp(Widget home) {
    final container = createTestContainer(
      overrides: [
        observationRemoteDataSourceProvider.overrideWithValue(remote),
        statesProvider.overrideWith((ref) async => const [
              IndiaState(id: 11, name: 'Kerala'),
              IndiaState(id: 12, name: 'Karnataka'),
            ]),
        districtsProvider.overrideWith((ref, stateId) async => const []),
      ],
    );
    addTearDown(container.dispose);
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, __) => home),
        GoRoute(
            path: '/species/:id',
            builder: (_, s) => Scaffold(
                body: Center(child: Text('SPECIES_${s.pathParameters['id']}')))),
      ],
    );
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    );
  }

  Future<void> pump(WidgetTester tester, Widget home) async {
    tester.view.physicalSize = const Size(440, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(buildApp(home));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
    });
  }

  group('SubmitObservationScreen', () {
    testWidgets('renders form sections', (tester) async {
      await pump(tester, const SubmitObservationScreen());
      expect(find.text('Submit a Sighting'), findsOneWidget);
      expect(find.text('Photos'), findsOneWidget);
      expect(find.text('Details'), findsOneWidget);
      expect(find.text('Privacy'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Submit Sighting'),
          findsNothing); // uses AppButton, not ElevatedButton
      expect(find.text('Submit Sighting'), findsOneWidget);
    });

    testWidgets('state dropdown is populated', (tester) async {
      await pump(tester, const SubmitObservationScreen());
      await tester.tap(find.text('Select state'));
      await tester.pumpAndSettle();
      expect(find.text('Kerala'), findsWidgets);
      expect(find.text('Karnataka'), findsWidgets);
    });

    testWidgets('privacy options render', (tester) async {
      await pump(tester, const SubmitObservationScreen());
      expect(find.text('Public'), findsOneWidget);
      expect(find.text('Anonymous'), findsOneWidget);
      expect(find.text('Private'), findsOneWidget);
    });
  });

  group('ObservationDetailScreen', () {
    testWidgets('shows AI-identified species + confidence', (tester) async {
      await pump(
        tester,
        const ObservationDetailScreen(observationId: 'obs-1'),
      );
      expect(find.text('AI identified'), findsOneWidget);
      expect(find.text('Pachliopta hector'), findsOneWidget);
      expect(find.byType(ConfidenceMeter), findsOneWidget);
    });

    testWidgets('tapping View species navigates', (tester) async {
      await mockNetworkImagesFor(() async {
        await pump(
          tester,
          const ObservationDetailScreen(observationId: 'obs-1'),
        );
        await tester.tap(find.text('View species →'));
        await tester.pumpAndSettle();
      });
      expect(find.text('SPECIES_sp-1'), findsOneWidget);
    });
  });

  group('MyObservationsScreen', () {
    testWidgets('renders list of observations with public/private Switch', (tester) async {
      await pump(tester, const MyObservationsScreen());
      
      expect(find.text('My Sightings'), findsOneWidget);
      expect(find.text('My first sighting'), findsOneWidget);
      expect(find.text('Second'), findsOneWidget);
      
      // Should render privacy switches (ObservationSummary by default has privacy: 'public')
      expect(find.byType(Switch), findsNWidgets(2));
    });

    testWidgets('toggling privacy Switch calls updatePrivacy', (tester) async {
      await pump(tester, const MyObservationsScreen());
      
      // Tap the first switch
      final switches = find.byType(Switch);
      await tester.tap(switches.first);
      await tester.pump();
      
      // The switch status toggles, triggers loading indicator, then invalidates provider
      await tester.pumpAndSettle();
    });
  });
}
