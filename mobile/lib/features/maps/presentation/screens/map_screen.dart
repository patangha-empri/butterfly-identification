import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../../../core/utils/a11y.dart';
import '../../../../shared/widgets/overlays/app_bottom_sheet.dart';
import '../../../../shared/widgets/states/empty_state.dart';
import '../../../home/data/models/observation_summary.dart';
import '../../../home/presentation/widgets/sighting_tile.dart';
import '../../data/map_clusterer.dart';
import '../map_providers.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// MAP SCREEN (Tab 2) — interactive India biodiversity map (OpenStreetMap)
/// ─────────────────────────────────────────────────────────────────────────────

const _indiaCenter = LatLng(22.5, 79.0);
const _indiaZoom = 4.2;

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final _mapController = MapController();
  double _zoom = _indiaZoom;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _onPositionChanged(MapPosition position, bool hasGesture) {
    // Re-cluster only when the zoom level changes meaningfully.
    final z = position.zoom;
    if (z != null && (z - _zoom).abs() >= 0.5) {
      setState(() => _zoom = z);
    }
  }

  Future<void> _goToMyLocation() async {
    unawaited(Haptics.light());
    final coords = await ref.read(userLocationProvider.future);
    if (coords == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location unavailable. Enable GPS & permission.'),
        ));
      }
      return;
    }
    _mapController.move(LatLng(coords.lat, coords.lng), 11);
    setState(() => _zoom = 11);
  }

  /// The sheet is presented on the ROOT navigator (AppBottomSheet uses
  /// useRootNavigator: true), but this State's `context` sits inside the
  /// shell tab's navigator. A plain Navigator.of(context).pop() would pop the
  /// map page itself — the only page in that branch — crashing go_router.
  void _closeSheet() =>
      Navigator.of(context, rootNavigator: true).pop();

  void _openFilter() {
    final currentPrivacy = ref.read(mapPrivacyFilterProvider);
    AppBottomSheet.show(
      context,
      title: 'Map Filters',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Privacy', style: TypographyTokens.textTheme.titleSmall),
          const SizedBox(height: SpaceTokens.xs),
          Wrap(
            spacing: SpaceTokens.sm,
            runSpacing: SpaceTokens.sm,
            children: [
              ChoiceChip(
                label: const Text('Public Feed'),
                selected: currentPrivacy == 'public',
                onSelected: (_) {
                  ref.read(mapPrivacyFilterProvider.notifier).state = 'public';
                  _closeSheet();
                },
              ),
              ChoiceChip(
                label: const Text('My Private'),
                selected: currentPrivacy == 'private',
                onSelected: (_) {
                  ref.read(mapPrivacyFilterProvider.notifier).state = 'private';
                  _closeSheet();
                },
              ),
              ChoiceChip(
                label: const Text('All Sightings'),
                selected: currentPrivacy == 'all',
                onSelected: (_) {
                  ref.read(mapPrivacyFilterProvider.notifier).state = 'all';
                  _closeSheet();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onClusterTap(MapCluster cluster, Map<String, ObservationSummary> byId) {
    Haptics.selection();
    if (cluster.isCluster) {
      _mapController.move(LatLng(cluster.lat, cluster.lng), _zoom + 2);
      setState(() => _zoom = _zoom + 2);
    } else {
      final obs = byId[cluster.single.id];
      if (obs != null) _showSightingSheet(obs);
    }
  }

  void _showSightingSheet(ObservationSummary obs) {
    AppBottomSheet.show(
      context,
      title: 'Sighting',
      scrollable: false,
      child: SightingTile(
        observation: obs,
        onTap: () {
          _closeSheet();
          context.push(AppRoutes.observationDetailPath(obs.id));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sightingsAsync = ref.watch(mapSightingsProvider);
    final points = ref.watch(mapClusterPointsProvider);
    final sightings = sightingsAsync.valueOrNull ?? const <ObservationSummary>[];
    final byId = {for (final o in sightings) o.id: o};
    final clusters = MapClusterer.cluster(points, zoom: _zoom);
    
    final activeFilter = ref.watch(mapStateFilterProvider) != null;
    final privacy = ref.watch(mapPrivacyFilterProvider);
    final activePrivacyFilter = privacy != 'public';
    final active = activeFilter || activePrivacyFilter;

    final privacyLabel = privacy == 'public'
        ? 'public'
        : privacy == 'private'
            ? 'private'
            : 'total';

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _indiaCenter,
              initialZoom: _indiaZoom,
              minZoom: 3,
              maxZoom: 18,
              onPositionChanged: _onPositionChanged,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.thardeye.butterfly_india',
              ),
              MarkerLayer(
                markers: [
                  for (final c in clusters)
                    if (isPlottableCoord(c.lat, c.lng))
                      Marker(
                        point: LatLng(c.lat, c.lng),
                        width: c.isCluster ? 48 : 40,
                        height: c.isCluster ? 48 : 40,
                        child: _ClusterMarker(
                          cluster: c,
                          onTap: () => _onClusterTap(c, byId),
                        ),
                      ),
                ],
              ),
            ],
          ),

          // ── Top bar (title + filter) ─────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(SpaceTokens.base),
              child: Row(
                children: [
                  _GlassPill(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.map_outlined, size: 18),
                        const SizedBox(width: SpaceTokens.sm),
                        Text('${sightings.length} $privacyLabel sightings',
                            style: TypographyTokens.textTheme.labelLarge),
                      ],
                    ),
                  ),
                  const Spacer(),
                  _GlassIconButton(
                    icon: Icons.tune,
                    highlighted: active,
                    onTap: _openFilter,
                  ),
                ],
              ),
            ),
          ),

          // ── Loading / empty / error overlays ─────────────────────────────
          if (sightingsAsync.isLoading)
            const _MapLoadingOverlay()
          else if (sightingsAsync.hasError)
            Center(
              child: AppEmptyState.error(
                message: 'Could not load the map.',
                onRetry: () => ref.invalidate(mapSightingsProvider),
              ),
            )
          else if (sightings.isEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: 120 + MediaQuery.viewPaddingOf(context).bottom,
              child: const _NoSightingsBanner(),
            ),

          // ── Floating controls ────────────────────────────────────────────
          Positioned(
            right: SpaceTokens.base,
            // Clear the shell's nav bar (64) + FAB margin (16) + FAB (56),
            // plus a gap, so the controls sit above the submit FAB.
            bottom: 64 +
                16 +
                56 +
                SpaceTokens.md +
                MediaQuery.viewPaddingOf(context).bottom,
            child: _GlassIconButton(
                icon: Icons.my_location, onTap: _goToMyLocation),
          ),
        ],
      ),
    );
  }
}

// ── Marker widgets ────────────────────────────────────────────────────────────

class _ClusterMarker extends StatelessWidget {
  const _ClusterMarker({required this.cluster, required this.onTap});
  final MapCluster cluster;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (cluster.isCluster) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorTokens.brandPrimary,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: ShadowTokens.md,
          ),
          alignment: Alignment.center,
          child: Text(
            cluster.count > 99 ? '99+' : '${cluster.count}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: onTap,
      child: const Icon(Icons.location_on,
          color: ColorTokens.brandAccent, size: 38, shadows: [
        Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 2)),
      ]),
    );
  }
}

// ── Glass UI bits ─────────────────────────────────────────────────────────────

class _GlassPill extends StatelessWidget {
  const _GlassPill({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(
            horizontal: SpaceTokens.base, vertical: SpaceTokens.sm),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.92),
          borderRadius: RadiusTokens.pillBR,
          boxShadow: ShadowTokens.sm,
        ),
        child: child,
      );
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({
    required this.icon,
    required this.onTap,
    this.highlighted = false,
  });
  final IconData icon;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: highlighted
          ? ColorTokens.brandPrimary
          : Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(
            icon,
            color: highlighted
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

/// Scrim + card shown while sightings (re)load — e.g. right after a filter is
/// applied — so the change always has clear visual feedback.
class _MapLoadingOverlay extends StatelessWidget {
  const _MapLoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black.withValues(alpha: 0.08),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: SpaceTokens.lg, vertical: SpaceTokens.base),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.96),
              borderRadius: RadiusTokens.cardBR,
              boxShadow: ShadowTokens.md,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2.4),
                ),
                const SizedBox(width: SpaceTokens.md),
                Text('Updating map…',
                    style: TypographyTokens.textTheme.labelLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NoSightingsBanner extends StatelessWidget {
  const _NoSightingsBanner();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: SpaceTokens.xl),
        padding: const EdgeInsets.all(SpaceTokens.base),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
          borderRadius: RadiusTokens.cardBR,
          boxShadow: ShadowTokens.md,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.travel_explore, color: ColorTokens.brandPrimary),
            const SizedBox(width: SpaceTokens.md),
            Flexible(
              child: Text(
                'No geo-tagged sightings yet. Submit one with GPS to put it '
                'on the map!',
                style: TypographyTokens.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
