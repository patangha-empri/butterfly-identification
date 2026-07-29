import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../../../core/utils/a11y.dart';
import '../../../../shared/widgets/buttons/app_button.dart';
import '../../../../shared/widgets/overlays/scan_overlay.dart';
import '../../../../shared/widgets/states/empty_state.dart';
import '../../../geography/presentation/geography_providers.dart';
import '../../../observations/data/models/observation.dart';
import '../../data/repositories/ai_repository.dart';
import '../providers/ai_providers.dart';
import '../widgets/ai_result_view.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// AI SCAN SCREEN
/// Single-screen flow: capture → review (+ state) → processing (scan overlay)
/// → cinematic result reveal. Quick-scan creates a real (private) sighting.
/// ─────────────────────────────────────────────────────────────────────────────

class AiScanScreen extends ConsumerStatefulWidget {
  const AiScanScreen({super.key});

  @override
  ConsumerState<AiScanScreen> createState() => _AiScanScreenState();
}

class _AiScanScreenState extends ConsumerState<AiScanScreen> {
  File? _image;
  ObservationPrivacy _privacy = ObservationPrivacy.private;
  GeoCoords? _coords;

  @override
  void initState() {
    super.initState();
    // Geo-tag the quick-scan sighting (best-effort) so it shows on the map.
    unawaited(_captureLocation());
  }

  Future<void> _captureLocation() async {
    final coords = await ref.read(locationServiceProvider).currentCoords();
    if (mounted && coords != null) setState(() => _coords = coords);
  }

  Future<void> _pick(ImageSource source) async {
    try {
      final picked =
          await ImagePicker().pickImage(source: source, imageQuality: 95);
      if (picked != null) setState(() => _image = File(picked.path));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not access the camera/gallery.')),
        );
      }
    }
  }

  Future<void> _identify() async {
    if (_image == null) return;
    unawaited(Haptics.medium());
    // Karnataka-only app: the state is fixed, not user-selected.
    final int stateId;
    try {
      stateId = await ref.read(defaultStateIdProvider.future);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not load region data. Check your connection.'),
        ),
      );
      return;
    }
    if (!mounted) return;
    unawaited(ref.read(aiScanNotifierProvider.notifier).identify(
          image: _image!,
          stateId: stateId,
          privacy: _privacy.value,
          latitude: _coords?.lat,
          longitude: _coords?.lng,
        ));
  }

  void _reset() {
    setState(() => _image = null);
    ref.read(aiScanNotifierProvider.notifier).reset();
  }

  @override
  Widget build(BuildContext context) {
    final scan = ref.watch(aiScanNotifierProvider);

    ref.listen<AiScanState>(aiScanNotifierProvider, (prev, next) {
      if (next.status == ScanStatus.success) Haptics.success();
      if (next.status == ScanStatus.error) Haptics.error();
    });

    return Scaffold(
      backgroundColor: scan.isProcessing ? Colors.black : null,
      appBar: scan.status == ScanStatus.success
          ? AppBar(title: const Text('Identification'))
          : AppBar(
              title: const Text('AI Identify'),
              backgroundColor: scan.isProcessing ? Colors.black : null,
              foregroundColor: scan.isProcessing ? Colors.white : null,
            ),
      body: switch (scan.status) {
        ScanStatus.processing => _ProcessingView(image: _image!, stage: scan.stage),
        ScanStatus.success => AiResultView(
            result: scan.result!,
            observationId: scan.scan!.observation.id,
            onScanAgain: _reset,
          ),
        ScanStatus.error => SafeArea(
            child: scan.isRateLimited
                ? AppEmptyState(
                    icon: Icons.hourglass_bottom,
                    title: 'Daily limit reached',
                    message: scan.error,
                    iconColor: ColorTokens.warning,
                  )
                : AppEmptyState(
                    icon: Icons.cloud_off,
                    title: 'Identification failed',
                    message: scan.error,
                    actionLabel: 'Try again',
                    onAction: _identify,
                  ),
          ),
        ScanStatus.idle =>
          _image == null ? _CapturePrompt(onPick: _pick) : _buildReview(),
      },
    );
  }

  Widget _buildReview() {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(SpaceTokens.base),
        children: [
          ClipRRect(
            borderRadius: RadiusTokens.cardBR,
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.file(_image!, fit: BoxFit.cover),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => setState(() => _image = null),
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Retake'),
            ),
          ),
          const SizedBox(height: SpaceTokens.sm),
          SwitchListTile(
            value: _privacy == ObservationPrivacy.public,
            onChanged: (v) => setState(() => _privacy =
                v ? ObservationPrivacy.public : ObservationPrivacy.private),
            contentPadding: EdgeInsets.zero,
            title: const Text('Share publicly'),
            subtitle: Text(
              _privacy == ObservationPrivacy.public
                  ? 'Visible in the community feed'
                  : 'Private — only you and admins',
              style: TypographyTokens.caption.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: SpaceTokens.lg),
          AppButton(
            label: 'Identify with AI',
            icon: Icons.auto_awesome,
            onPressed: _identify,
          ),
          const SizedBox(height: SpaceTokens.xxl),
        ],
      ),
    );
  }
}

// ── Capture prompt (no image yet) ────────────────────────────────────────────

class _CapturePrompt extends StatelessWidget {
  const _CapturePrompt({required this.onPick});
  final Future<void> Function(ImageSource) onPick;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(SpaceTokens.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: ColorTokens.aiGradient,
              ),
              child: const Icon(Icons.center_focus_strong,
                  size: 56, color: Colors.white),
            ),
            const SizedBox(height: SpaceTokens.xl),
            Text('Identify a butterfly',
                style: TypographyTokens.textTheme.headlineSmall,
                textAlign: TextAlign.center),
            const SizedBox(height: SpaceTokens.sm),
            Text(
              'Take or choose a clear photo and our AI will name the species '
              'in seconds.',
              textAlign: TextAlign.center,
              style: TypographyTokens.textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: SpaceTokens.xxl),
            AppButton(
              label: 'Take a photo',
              icon: Icons.camera_alt,
              onPressed: () => onPick(ImageSource.camera),
            ),
            const SizedBox(height: SpaceTokens.sm),
            AppButton(
              label: 'Choose from gallery',
              variant: AppButtonVariant.outline,
              icon: Icons.photo_library_outlined,
              onPressed: () => onPick(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Processing (scan overlay over the captured photo) ────────────────────────

class _ProcessingView extends StatelessWidget {
  const _ProcessingView({required this.image, required this.stage});
  final File image;
  final ScanStage? stage;

  ScanState get _scanState => switch (stage) {
        ScanStage.analysing => ScanState.processing,
        ScanStage.done => ScanState.locked,
        _ => ScanState.scanning,
      };

  String get _label => switch (stage) {
        ScanStage.compressing => 'Preparing photo…',
        ScanStage.creating => 'Saving sighting…',
        ScanStage.uploading => 'Uploading…',
        ScanStage.analysing => 'AI is analysing the wings…',
        ScanStage.done => 'Done',
        null => 'Scanning…',
      };

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.file(image, fit: BoxFit.cover),
        ScanOverlay(state: _scanState),
        Positioned(
          left: 0,
          right: 0,
          bottom: 64,
          child: Column(
            children: [
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              ),
              const SizedBox(height: SpaceTokens.base),
              Text(
                _label,
                style: TypographyTokens.textTheme.titleMedium
                    ?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
