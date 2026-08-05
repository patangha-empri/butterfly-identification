import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
import '../../data/map_geometry.dart';
import '../../data/map_marker_icons.dart';
import '../map_providers.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// MAP SCREEN (Tab 2) — public sightings on Google Maps
///
/// Runs on the Maps SDK for Android/iOS. Everything billable beyond drawing the
/// map is deliberately avoided:
///   • directions are handed to the installed Google Maps app, not fetched from
///     the Directions API (see NavigationLauncher);
///   • no Places, Geocoding or Static Maps calls anywhere in the app;
///   • sightings come from our own backend in one request, then are clustered
///     on-device, so panning and zooming costs nothing.
/// The remaining budget lever is the key restriction set in Cloud Console —
/// see docs/MAPS_SETUP.md.
/// ─────────────────────────────────────────────────────────────────────────────

const _indiaCenter = LatLng(22.5, 79.0);
const _indiaZoom = 4.2;

/// Keeps the camera over India and its neighbours. A user who flings the map to
/// the Atlantic sees no sightings and assumes the app is broken.
final _indiaBounds = LatLngBounds(
  southwest: const LatLng(5.0, 66.0),
  northeast: const LatLng(37.5, 98.0),
);

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _controller;
  final _icons = MapMarkerIcons(
    pinColor: ColorTokens.brandAccent,
    clusterColor: ColorTokens.brandPrimary,
  );
  double _zoom = _indiaZoom;

  /// Frame-to-fit runs once per screen. Re-fitting on every refresh would yank
  /// the camera away from wherever the user had panned to.
  bool _hasFittedToSightings = false;

  /// Zoom the current marker set was clustered at. Re-clustering on every frame
  /// of a pinch would rebuild hundreds of markers for no visible gain.
  double _clusteredAtZoom = _indiaZoom;

  Set<Marker> _markers = const {};
  int _markerBuildToken = 0;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // ── Camera ────────────────────────────────────────────────────────────────

  void _onCameraMove(CameraPosition position) => _zoom = position.zoom;

  void _onCameraIdle() {
    if ((_zoom - _clusteredAtZoom).abs() < 0.5) return;
    _clusteredAtZoom = _zoom;
    _rebuildMarkers();
  }

  Future<void> _goToMyLocation() async {
    unawaited(Haptics.light());
    final coords = await ref.read(userLocationProvider.future);
    if (!mounted) return;
    if (coords == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Location unavailable. Enable GPS & permission.'),
      ));
      return;
    }
    _zoom = 11;
    _clusteredAtZoom = 11;
    await _controller?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(coords.lat, coords.lng), 11),
    );
    await _rebuildMarkers();
  }

  // ── Markers ───────────────────────────────────────────────────────────────

  /// Rebuilds the marker set for the current data and zoom.
  ///
  /// Async because each icon may need painting; a token guards against an older
  /// build finishing after a newer one and putting stale markers back.
  Future<void> _rebuildMarkers() async {
    final token = ++_markerBuildToken;
    final sightings =
        ref.read(mapSightingsProvider).valueOrNull ?? const <ObservationSummary>[];
    if (sightings.isEmpty) {
      if (mounted && _markers.isNotEmpty) setState(() => _markers = const {});
      return;
    }

    final byId = {for (final o in sightings) o.id: o};
    final clusters = MapClusterer.cluster(
      ref.read(mapClusterPointsProvider),
      zoom: _clusteredAtZoom,
    );

    final dpr = MediaQuery.devicePixelRatioOf(context);
    final built = <Marker>{};
    for (final c in clusters) {
      if (!isPlottableCoord(c.lat, c.lng)) continue;
      final position = LatLng(c.lat, c.lng);

      if (c.isCluster) {
        final members = [
          for (final p in c.points)
            if (byId[p.id] != null) byId[p.id]!,
        ];
        built.add(Marker(
          markerId: MarkerId('cluster-${c.lat}-${c.lng}-${c.count}'),
          position: position,
          icon: await _icons.cluster(c.count, devicePixelRatio: dpr),
          anchor: const Offset(0.5, 0.5),
          consumeTapEvents: true,
          onTap: () => _openCluster(c, members),
        ));
      } else {
        final obs = byId[c.single.id];
        if (obs == null) continue;
        built.add(Marker(
          markerId: MarkerId(obs.id),
          position: position,
          icon: await _icons.single(devicePixelRatio: dpr),
          // The pin's tip is the coordinate, not its middle.
          anchor: const Offset(0.5, 1.0),
          consumeTapEvents: true,
          onTap: () => _openSighting(obs),
        ));
      }
    }

    if (!mounted || token != _markerBuildToken) return;
    setState(() => _markers = built);
  }

  // ── Opening things ────────────────────────────────────────────────────────

  /// A tap on a sighting goes straight to its page — what was photographed,
  /// the notes, the identification. Directions live there too, for the people
  /// who actually want to travel to it.
  void _openSighting(ObservationSummary obs) {
    unawaited(Haptics.selection());
    context.push(AppRoutes.observationDetailPath(obs.id));
  }

  /// A tap on a cluster either zooms in far enough to break it apart, or — when
  /// its sightings share (almost) the same coordinate — lists them.
  ///
  /// Zooming alone was not enough: several sightings logged at one spot, or
  /// placed on the same state centroid because they carry no GPS, sit exactly
  /// on top of each other. No zoom level separates those, so without the list
  /// they were simply unreachable.
  Future<void> _openCluster(
    MapCluster cluster,
    List<ObservationSummary> members,
  ) async {
    unawaited(Haptics.selection());

    final bounds = MapGeometry.boundsOf(cluster.points);
    if (bounds == null || !MapGeometry.isSpread(cluster.points)) {
      _showClusterSheet(members);
      return;
    }

    // Fitting the members' own bounds reveals exactly the area that was hidden,
    // rather than a fixed +2 which can under- or overshoot wildly.
    await _controller?.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 72),
    );
    await _syncZoomFromCamera();
    await _rebuildMarkers();
  }

  /// After an animation the camera picks its own zoom, so read it back rather
  /// than trusting the value we asked for — otherwise the next re-cluster runs
  /// at a zoom the map is not actually at.
  Future<void> _syncZoomFromCamera() async {
    final actual = await _controller?.getZoomLevel();
    if (actual == null) return;
    _zoom = actual;
    _clusteredAtZoom = actual;
  }

  /// Frames every sighting on first load, so nothing sits off-screen waiting to
  /// be discovered by panning.
  Future<void> _fitToSightings(List<ObservationSummary> sightings) async {
    final bounds = MapGeometry.boundsOf(ref.read(mapClusterPointsProvider));
    if (bounds == null || _controller == null) return;
    await _controller!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 48));
    await _syncZoomFromCamera();
    await _rebuildMarkers();
  }

  // ── Sheets ────────────────────────────────────────────────────────────────

  /// The sheet is presented on the ROOT navigator (AppBottomSheet uses
  /// useRootNavigator: true), but this State's `context` sits inside the
  /// shell tab's navigator. A plain Navigator.of(context).pop() would pop the
  /// map page itself — the only page in that branch — crashing go_router.
  void _closeSheet() => Navigator.of(context, rootNavigator: true).pop();

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
              for (final option in const [
                ('public', 'Public Feed'),
                ('private', 'My Private'),
                ('all', 'All Sightings'),
              ])
                ChoiceChip(
                  label: Text(option.$2),
                  selected: currentPrivacy == option.$1,
                  onSelected: (_) {
                    ref.read(mapPrivacyFilterProvider.notifier).state =
                        option.$1;
                    _closeSheet();
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Every sighting stacked on one spot, each opening its own page. This is the
  /// only way to reach sightings that share a coordinate.
  void _showClusterSheet(List<ObservationSummary> members) {
    AppBottomSheet.show(
      context,
      title: '${members.length} sightings here',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final obs in members)
            Padding(
              padding: const EdgeInsets.only(bottom: SpaceTokens.sm),
              child: SightingTile(
                observation: obs,
                onTap: () {
                  _closeSheet();
                  context.push(AppRoutes.observationDetailPath(obs.id));
                },
              ),
            ),
        ],
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Rebuild markers whenever the sighting set changes (filter, refresh, first
    // load) without doing it inside build().
    ref.listen(mapSightingsProvider, (_, next) {
      final loaded = next.valueOrNull;
      if (loaded != null && loaded.isNotEmpty && !_hasFittedToSightings) {
        _hasFittedToSightings = true;
        _fitToSightings(loaded);
      } else {
        _rebuildMarkers();
      }
    });

    final sightingsAsync = ref.watch(mapSightingsProvider);
    final sightings = sightingsAsync.valueOrNull ?? const <ObservationSummary>[];

    final activeStateFilter = ref.watch(mapStateFilterProvider) != null;
    final privacy = ref.watch(mapPrivacyFilterProvider);
    final active = activeStateFilter || privacy != 'public';

    final privacyLabel = switch (privacy) {
      'public' => 'public',
      'private' => 'private',
      _ => 'total',
    };

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _indiaCenter,
              zoom: _indiaZoom,
            ),
            markers: _markers,
            onMapCreated: (controller) {
              _controller = controller;
              // Data may already be loaded by the time the platform view is
              // ready, in which case no provider change will fire.
              final loaded = ref.read(mapSightingsProvider).valueOrNull;
              if (loaded != null && loaded.isNotEmpty && !_hasFittedToSightings) {
                _hasFittedToSightings = true;
                _fitToSightings(loaded);
              } else {
                _rebuildMarkers();
              }
            },
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraIdle,
            cameraTargetBounds: CameraTargetBounds(_indiaBounds),
            minMaxZoomPreference: const MinMaxZoomPreference(3, 17),
            // The blue dot is drawn only after the user asks for it via the
            // locate button, so opening the map never triggers a GPS prompt.
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            // Chrome we replace with our own controls, plus layers that cost
            // frames on low-end devices and add nothing to a sightings map.
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: false,
            trafficEnabled: false,
            buildingsEnabled: false,
            indoorViewEnabled: false,
            tiltGesturesEnabled: false,
            rotateGesturesEnabled: false,
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
