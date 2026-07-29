import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'observation_providers.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// OFFLINE SYNC
/// A connectivity-triggered driver that drains the offline observation queue
/// when the device is online and authenticated. Pairs with a live count of the
/// pending queue so the UI can react as items upload.
/// ─────────────────────────────────────────────────────────────────────────────

/// Live count of sightings waiting in the offline queue (updates as it drains).
final pendingSyncCountProvider = StreamProvider<int>((ref) {
  final dao = ref.watch(appDatabaseProvider).observationsDao;
  return dao.watchPendingQueue().map((rows) => rows.length);
}, name: 'pendingSyncCount');

enum SyncStatus { idle, syncing, success, error }

class SyncState {
  const SyncState({
    this.status = SyncStatus.idle,
    this.syncedJustNow = 0,
    this.error,
  });

  final SyncStatus status;

  /// How many queued items were uploaded by the most recent drain (for a toast).
  final int syncedJustNow;
  final String? error;

  bool get isSyncing => status == SyncStatus.syncing;
}

class SyncController extends StateNotifier<SyncState> {
  SyncController(this._ref) : super(const SyncState());

  final Ref _ref;

  /// Guards against concurrent drains. Claimed synchronously (before any await)
  /// so a startup trigger and a connectivity trigger can't both drain the queue
  /// and upload everything twice.
  bool _running = false;

  /// Drains the queue if online + authenticated. Safe to call repeatedly —
  /// concurrent invocations and empty queues are no-ops.
  Future<void> syncNow() async {
    if (_running) return;
    if (_ref.read(currentUserProvider) == null) return; // needs auth
    if (!_ref.read(connectivityServiceProvider).isOnline) return;

    _running = true;
    try {
      final repo = _ref.read(observationRepositoryProvider);
      final before = await repo.pendingQueueCount();
      if (before == 0) return;

      state = const SyncState(status: SyncStatus.syncing);
      await repo.syncPending();
      final after = await repo.pendingQueueCount();
      final uploaded = (before - after).clamp(0, before);
      // Surface freshly-synced sightings in the user's list.
      _ref.invalidate(myObservationsProvider);
      state = SyncState(status: SyncStatus.success, syncedJustNow: uploaded);
    } catch (e) {
      state = SyncState(status: SyncStatus.error, error: e.toString());
    } finally {
      _running = false;
    }
  }
}

final syncControllerProvider =
    StateNotifierProvider<SyncController, SyncState>((ref) {
  final controller = SyncController(ref);

  // Drain whenever connectivity transitions to online.
  ref.listen<AsyncValue<ConnectivityStatus>>(
    connectivityStatusProvider,
    (prev, next) {
      if (next.valueOrNull == ConnectivityStatus.online) {
        controller.syncNow();
      }
    },
  );

  // Drain once whoever first keeps this provider alive (e.g. after login).
  Future.microtask(controller.syncNow);

  return controller;
}, name: 'syncController');
