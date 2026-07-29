import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/core/network/connectivity_service.dart';
import 'package:butterfly_india/features/ai_identification/presentation/providers/ai_providers.dart';
import 'package:butterfly_india/features/observations/presentation/providers/observation_providers.dart';
import '../../helpers/test_helpers.dart';
import '../../mocks/mock_services.dart';
import '../observations/fake_observation_datasource.dart';
import 'fake_ai_datasource.dart';

void main() {
  late FakeObservationRemoteDataSource obs;
  late FakeAiRemoteDataSource ai;

  ProviderContainer build({MockConnectivityService? connectivity}) =>
      createTestContainer(
        connectivity: connectivity,
        overrides: [
          observationRemoteDataSourceProvider.overrideWithValue(obs),
          aiRemoteDataSourceProvider.overrideWithValue(ai),
        ],
      );

  setUp(() {
    obs = FakeObservationRemoteDataSource();
    ai = FakeAiRemoteDataSource();
  });

  test('initial state is idle', () {
    final c = build();
    addTearDown(c.dispose);
    expect(c.read(aiScanNotifierProvider).status, ScanStatus.idle);
  });

  test('identify transitions to success with result', () async {
    final c = build();
    addTearDown(c.dispose);

    final states = <ScanStatus>[];
    c.listen(aiScanNotifierProvider, (_, n) => states.add(n.status));

    await c.read(aiScanNotifierProvider.notifier).identify(
          image: File('x.jpg'),
          stateId: 11,
          privacy: 'private',
        );

    final state = c.read(aiScanNotifierProvider);
    expect(states.first, ScanStatus.processing);
    expect(state.status, ScanStatus.success);
    expect(state.result!.topMatch!.commonName, 'Crimson Rose');
    expect(state.scan!.observation.id, 'obs-new');
  });

  test('identify error when AI fails', () async {
    ai.fail = true;
    final c = build();
    addTearDown(c.dispose);
    c.listen(aiScanNotifierProvider, (_, __) {}); // keep autoDispose alive

    await c.read(aiScanNotifierProvider.notifier).identify(
          image: File('x.jpg'),
          stateId: 11,
          privacy: 'private',
        );

    expect(c.read(aiScanNotifierProvider).status, ScanStatus.error);
  });

  test('offline → error state', () async {
    final connectivity = MockConnectivityService()
      ..setStatus(ConnectivityStatus.offline);
    final c = build(connectivity: connectivity);
    addTearDown(c.dispose);
    c.listen(aiScanNotifierProvider, (_, __) {});

    await c.read(aiScanNotifierProvider.notifier).identify(
          image: File('x.jpg'),
          stateId: 11,
          privacy: 'private',
        );

    expect(c.read(aiScanNotifierProvider).status, ScanStatus.error);
    expect(obs.createCalls, 0);
  });

  test('reset returns to idle', () async {
    final c = build();
    addTearDown(c.dispose);
    c.listen(aiScanNotifierProvider, (_, __) {});
    await c.read(aiScanNotifierProvider.notifier).identify(
          image: File('x.jpg'),
          stateId: 11,
          privacy: 'private',
        );
    c.read(aiScanNotifierProvider.notifier).reset();
    expect(c.read(aiScanNotifierProvider).status, ScanStatus.idle);
  });
}
