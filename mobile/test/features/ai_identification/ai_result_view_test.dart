import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:butterfly_india/core/theme/app_theme.dart';
import 'package:butterfly_india/features/ai_identification/data/models/ai_result.dart';
import 'package:butterfly_india/features/ai_identification/presentation/widgets/ai_result_view.dart';
import 'package:butterfly_india/shared/widgets/confidence_meter.dart';

void main() {
  Widget wrap(Widget child) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, __) => Scaffold(body: child)),
        GoRoute(
            path: '/species/:id',
            builder: (_, s) => Scaffold(
                body: Center(child: Text('SPECIES_${s.pathParameters['id']}')))),
        GoRoute(
            path: '/observations/:id',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('SIGHTING')))),
      ],
    );
    return ProviderScope(
      child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    );
  }

  const result = AiResult(
    id: 'r1',
    observationId: 'obs-1',
    status: 'completed',
    matches: [
      AiMatch(
        id: 1,
        rank: 1,
        confidenceScore: 0.94,
        commonName: 'Crimson Rose',
        scientificName: 'Pachliopta hector',
        speciesId: 'sp-1',
      ),
      AiMatch(
        id: 2,
        rank: 2,
        confidenceScore: 0.4,
        commonName: 'Common Rose',
        speciesId: 'sp-2',
      ),
    ],
  );

  testWidgets('renders top match + confidence + alternatives', (tester) async {
    tester.view.physicalSize = const Size(420, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(wrap(
        AiResultView(result: result, observationId: 'obs-1', onScanAgain: () {}),
      ));
      await tester.pump();
      await tester.pumpAndSettle();
    });

    expect(find.text('Crimson Rose'), findsOneWidget);
    expect(find.text('Pachliopta hector'), findsOneWidget);
    expect(find.byType(ConfidenceMeter), findsOneWidget);
    expect(find.text('Other possibilities'), findsOneWidget);
    expect(find.text('Common Rose'), findsOneWidget);
  });

  testWidgets('no-match state shows recovery UI', (tester) async {
    tester.view.physicalSize = const Size(420, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    var scanAgain = false;
    await tester.pumpWidget(wrap(
      AiResultView(
        result: const AiResult(id: 'r', status: 'completed', matches: []),
        observationId: 'obs-1',
        onScanAgain: () => scanAgain = true,
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text("Couldn't identify it"), findsOneWidget);
    await tester.tap(find.text('Try another photo'));
    expect(scanAgain, isTrue);
  });

  testWidgets('tapping View species navigates', (tester) async {
    tester.view.physicalSize = const Size(420, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(wrap(
        AiResultView(result: result, observationId: 'obs-1', onScanAgain: () {}),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.text('View species'));
      await tester.pumpAndSettle();
    });
    expect(find.text('SPECIES_sp-1'), findsOneWidget);
  });
}
