import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/utils/a11y.dart';
import '../../../../shared/widgets/loaders/skeleton.dart';
import '../../../../shared/widgets/states/empty_state.dart';
import '../../../home/data/models/observation_summary.dart';
import '../../../home/presentation/widgets/sighting_tile.dart';
import '../providers/observation_providers.dart';
import '../providers/sync_providers.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// MY OBSERVATIONS SCREEN
/// ─────────────────────────────────────────────────────────────────────────────

class MyObservationsScreen extends ConsumerStatefulWidget {
  const MyObservationsScreen({super.key});

  @override
  ConsumerState<MyObservationsScreen> createState() =>
      _MyObservationsScreenState();
}

class _MyObservationsScreenState extends ConsumerState<MyObservationsScreen> {
  final Map<String, bool> _loadingObservations = {};

  Future<void> _togglePrivacy(ObservationSummary obs, bool makePublic) async {
    setState(() => _loadingObservations[obs.id] = true);
    
    final newPrivacy = makePublic ? 'public' : 'private';
    
    final result = await ref
        .read(observationRepositoryProvider)
        .updatePrivacy(obs.id, newPrivacy);

    if (mounted) {
      setState(() => _loadingObservations[obs.id] = false);
      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update privacy: ${failure.message}'),
              backgroundColor: ColorTokens.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        (updatedObs) {
          ref.invalidate(myObservationsProvider);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                makePublic
                    ? 'Sighting is now shared publicly!'
                    : 'Sighting is now private.',
              ),
              backgroundColor: ColorTokens.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(myObservationsProvider);
    final pending = ref.watch(pendingSyncCountProvider).valueOrNull ?? 0;
    final isSyncing = ref.watch(syncControllerProvider).isSyncing;

    return Scaffold(
      appBar: AppBar(title: const Text('My Sightings')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.submitObservation),
        icon: const Icon(Icons.add_a_photo),
        label: const Text('New'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(myObservationsProvider);
          await ref.read(syncControllerProvider.notifier).syncNow();
          await ref.read(myObservationsProvider.future);
        },
        child: async.when(
          loading: () => ListView(
            padding: const EdgeInsets.all(SpaceTokens.base),
            children: List.generate(6, (_) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: SpaceTokens.sm),
                  child: ListTileSkeleton(),
                )),
          ),
          error: (err, _) => AppEmptyState.error(
            message: err.toString(),
            onRetry: () => ref.invalidate(myObservationsProvider),
          ),
          data: (items) {
            if (items.isEmpty && pending == 0) {
              return _EmptyMine(context);
            }
            return ListView(
              padding: EdgeInsets.fromLTRB(
                  SpaceTokens.base,
                  SpaceTokens.sm,
                  SpaceTokens.base,
                  96 + MediaQuery.viewPaddingOf(context).bottom),
              children: [
                if (pending > 0)
                  _PendingBanner(
                    count: pending,
                    isSyncing: isSyncing,
                    onSyncNow: () =>
                        ref.read(syncControllerProvider.notifier).syncNow(),
                  ),
                ...items.map((o) => SightingTile(
                      observation: o,
                      onTap: () => context
                          .push(AppRoutes.observationDetailPath(o.id)),
                      onPrivacyChanged: (val) {
                        Haptics.selection();
                        _togglePrivacy(o, val);
                      },
                      isPrivacyLoading: _loadingObservations[o.id] ?? false,
                    )),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _EmptyMine(BuildContext context) => ListView(
        children: [
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.15),
          AppEmptyState(
            icon: Icons.camera_alt_outlined,
            title: 'No sightings yet',
            message: 'Submit your first butterfly sighting to see it here.',
            actionLabel: 'Submit a Sighting',
            onAction: () => context.push(AppRoutes.submitObservation),
          ),
        ],
      );
}

class _PendingBanner extends StatelessWidget {
  const _PendingBanner({
    required this.count,
    required this.isSyncing,
    required this.onSyncNow,
  });
  final int count;
  final bool isSyncing;
  final VoidCallback onSyncNow;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: SpaceTokens.sm),
      padding: const EdgeInsets.fromLTRB(
          SpaceTokens.md, SpaceTokens.sm, SpaceTokens.sm, SpaceTokens.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: RadiusTokens.buttonBR,
      ),
      child: Row(
        children: [
          if (isSyncing)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            const Icon(Icons.cloud_upload_outlined, size: 18),
          const SizedBox(width: SpaceTokens.sm),
          Expanded(
            child: Text(
              isSyncing
                  ? 'Uploading $count sighting${count > 1 ? 's' : ''}…'
                  : '$count sighting${count > 1 ? 's' : ''} waiting to upload',
            ),
          ),
          if (!isSyncing)
            TextButton(
              onPressed: onSyncNow,
              child: const Text('Sync now'),
            ),
        ],
      ),
    );
  }
}
