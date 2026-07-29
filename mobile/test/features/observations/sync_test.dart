import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/core/database/app_database.dart';
import 'package:butterfly_india/core/network/connectivity_service.dart';
import 'package:butterfly_india/core/providers/core_providers.dart';
import 'package:butterfly_india/features/auth/domain/entities/user_entity.dart';
import 'package:butterfly_india/features/auth/presentation/providers/auth_provider.dart';
import 'package:butterfly_india/features/observations/data/repositories/observation_repository.dart';
import 'package:butterfly_india/features/observations/presentation/providers/observation_providers.dart';
import 'package:butterfly_india/features/observations/presentation/providers/sync_providers.dart';
import '../../helpers/test_helpers.dart';
import '../../mocks/mock_services.dart';
import 'fake_observation_repository.dart';

void main() {
  const user = UserEntity(
    id: 'u-1',
    username: 'asha',
    email: 'asha@example.com',
    fullName: 'Asha',
  );

  ProviderContainer makeContainer({
    required FakeObservationRepository repo,
    required MockConnectivityService connectivity,
    bool authed = true,
  }) {
    final c = createTestContainer(
      connectivity: connectivity,
      overrides: [
        observationRepositoryProvider.overrideWithValue(repo),
        connectivityServiceProvider.overrideWithValue(connectivity),
        if (authed) currentUserProvider.overrideWith((ref) => user),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  group('SyncController.syncNow', () {
    test('drains the queue when online and authenticated', () async {
      final repo = FakeObservationRepository(pending: 3);
      final conn = MockConnectivityService()..setStatus(ConnectivityStatus.online);
      final c = makeContainer(repo: repo, connectivity: conn);

      await c.read(syncControllerProvider.notifier).syncNow();

      expect(repo.syncCalls, 1);
      expect(repo.pending, 0);
      final state = c.read(syncControllerProvider);
      expect(state.status, SyncStatus.success);
      expect(state.syncedJustNow, 3);
    });

    test('is a no-op when offline', () async {
      final repo = FakeObservationRepository(pending: 2);
      final conn = MockConnectivityService()
        ..setStatus(ConnectivityStatus.offline);
      final c = makeContainer(repo: repo, connectivity: conn);

      await c.read(syncControllerProvider.notifier).syncNow();

      expect(repo.syncCalls, 0);
      expect(repo.pending, 2);
    });

    test('is a no-op when unauthenticated', () async {
      final repo = FakeObservationRepository(pending: 2);
      final conn = MockConnectivityService()
        ..setStatus(ConnectivityStatus.online);
      final c = makeContainer(repo: repo, connectivity: conn, authed: false);

      await c.read(syncControllerProvider.notifier).syncNow();

      expect(repo.syncCalls, 0);
    });

    test('is a no-op when the queue is empty', () async {
      final repo = FakeObservationRepository(pending: 0);
      final conn = MockConnectivityService()
        ..setStatus(ConnectivityStatus.online);
      final c = makeContainer(repo: repo, connectivity: conn);

      await c.read(syncControllerProvider.notifier).syncNow();

      expect(repo.syncCalls, 0);
      expect(c.read(syncControllerProvider).status, SyncStatus.idle);
    });

    test('records an error when draining throws', () async {
      final repo = FakeObservationRepository(pending: 1, failSync: true);
      final conn = MockConnectivityService()
        ..setStatus(ConnectivityStatus.online);
      final c = makeContainer(repo: repo, connectivity: conn);

      await c.read(syncControllerProvider.notifier).syncNow();

      expect(repo.syncCalls, 1);
      expect(c.read(syncControllerProvider).status, SyncStatus.error);
    });
  });

  group('SyncController auto-trigger', () {
    test('drains on a connectivity online transition', () async {
      final repo = FakeObservationRepository(pending: 1);
      final conn = MockConnectivityService()
        ..setStatus(ConnectivityStatus.offline);
      final c = makeContainer(repo: repo, connectivity: conn);

      // Instantiate the controller (sets up the connectivity listener).
      c.read(syncControllerProvider);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(repo.syncCalls, 0); // still offline

      conn.setStatus(ConnectivityStatus.online);
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(repo.syncCalls, 1);
      expect(repo.pending, 0);
    });
  });

  group('ObservationsDao offline queue', () {
    test('resetProcessingToPending requeues stuck rows', () async {
      final c = createTestContainer();
      addTearDown(c.dispose);
      final dao = c.read(appDatabaseProvider).observationsDao;

      // Two pending rows; mark one processing (simulate interrupted drain).
      final id1 = await dao.addToQueue(_queueRow());
      await dao.addToQueue(_queueRow());
      await dao.markProcessing(id1);
      expect(await dao.getPendingCount(), 1);

      final reset = await dao.resetProcessingToPending();
      expect(reset, 1);
      expect(await dao.getPendingCount(), 2);
    });

    test('incrementRetry keeps a row pending until maxRetries', () async {
      final c = createTestContainer();
      addTearDown(c.dispose);
      final dao = c.read(appDatabaseProvider).observationsDao;

      final id = await dao.addToQueue(_queueRow(maxRetries: 2));
      await dao.incrementRetry(id); // 1 -> still pending
      expect(await dao.getPendingCount(), 1);
      await dao.incrementRetry(id); // 2 -> failed
      expect(await dao.getPendingCount(), 0);
    });
  });
}

OfflineQueueTableCompanion _queueRow({int maxRetries = 5}) =>
    OfflineQueueTableCompanion(
      type: const Value('observation'),
      payload: const Value('{}'),
      endpoint: const Value('/api/v1/observations/'),
      maxRetries: Value(maxRetries),
    );
