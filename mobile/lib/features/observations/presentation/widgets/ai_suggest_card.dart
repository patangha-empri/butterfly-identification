import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../../../core/utils/a11y.dart';
import '../../../ai_identification/data/classifier/butterfly_classifier.dart';
import '../../../ai_identification/presentation/providers/ai_providers.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// AI SUGGEST CARD
/// Inline recognition for the submit-sighting form. Prefers the backend Gemini
/// quick-scan (authoritative, knows Indian species); falls back to the bundled
/// on-device TFLite model when the backend is unreachable. Offers the top
/// match as the sighting title.
/// ─────────────────────────────────────────────────────────────────────────────

enum _Outcome { butterfly, notButterfly, unrecognised }

class _ScanDisplay {
  const _ScanDisplay({
    required this.outcome,
    this.name,
    this.scientific,
    this.pct,
    this.alternatives = const [],
  });

  final _Outcome outcome;
  final String? name;
  final String? scientific;
  final int? pct;
  final List<String> alternatives;
}

class AiSuggestCard extends ConsumerStatefulWidget {
  const AiSuggestCard({
    super.key,
    required this.image,
    this.onUseLabel,
  });

  /// The photo to classify (the primary image of the draft).
  final File image;

  /// Called when the user taps "Use as title" with the species name.
  final void Function(String label)? onUseLabel;

  @override
  ConsumerState<AiSuggestCard> createState() => _AiSuggestCardState();
}

class _AiSuggestCardState extends ConsumerState<AiSuggestCard> {
  bool _running = false;
  _ScanDisplay? _scan;
  String? _error;

  @override
  void didUpdateWidget(covariant AiSuggestCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.image.path != widget.image.path) {
      setState(() {
        _running = false;
        _scan = null;
        _error = null;
      });
    }
  }

  Future<void> _run() async {
    unawaited(Haptics.medium());
    setState(() {
      _running = true;
      _error = null;
    });

    _ScanDisplay? display;
    String? error;
    try {
      // Authoritative path: backend Gemini scan (no observation created).
      display = await _scanRemote();
    } catch (_) {
      // Offline / backend unreachable → bundled on-device model.
      try {
        display = await _scanOnDevice();
      } on ClassifierUnavailable {
        error = 'AI recognition needs an internet connection right now. '
            'Your photo will still be identified after you submit.';
      } catch (_) {
        error = 'Could not analyse the photo. Try again.';
      }
    }

    if (!mounted) return;
    setState(() {
      _running = false;
      _scan = display;
      _error = error;
    });
  }

  Future<_ScanDisplay> _scanRemote() async {
    final result =
        await ref.read(aiRemoteDataSourceProvider).quickScan(widget.image);
    if (!result.isButterfly) {
      return const _ScanDisplay(outcome: _Outcome.notButterfly);
    }
    final top = result.topMatch;
    if (top == null) {
      return const _ScanDisplay(outcome: _Outcome.unrecognised);
    }
    return _ScanDisplay(
      outcome: _Outcome.butterfly,
      name: top.commonName,
      scientific: top.scientificName.isEmpty ? null : top.scientificName,
      pct: (top.confidence * 100).round(),
      alternatives:
          result.matches.skip(1).map((m) => m.commonName).toList(),
    );
  }

  Future<_ScanDisplay> _scanOnDevice() async {
    final classifier = ref.read(butterflyClassifierProvider);
    final results = await classifier.classify(widget.image, topK: 3);
    switch (ButterflyGate.evaluate(results)) {
      case GateVerdict.moth:
        return const _ScanDisplay(outcome: _Outcome.notButterfly);
      case GateVerdict.unrecognised:
        return const _ScanDisplay(outcome: _Outcome.unrecognised);
      case GateVerdict.butterfly:
        final top = results.first;
        return _ScanDisplay(
          outcome: _Outcome.butterfly,
          name: _pretty(top.label),
          pct: (top.confidence * 100).round(),
          alternatives: results
              .skip(1)
              .where((r) =>
                  r.confidence >= 0.15 && !ButterflyGate.isMothLabel(r.label))
              .map((r) => _pretty(r.label))
              .toList(),
        );
    }
  }

  /// "BLUE MORPHO" → "Blue Morpho" for display.
  static String _pretty(String label) => label
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .map((w) => w[0].toUpperCase() + w.substring(1))
      .join(' ');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SpaceTokens.md),
      decoration: BoxDecoration(
        color: ColorTokens.brandPrimary.withValues(alpha: 0.06),
        borderRadius: RadiusTokens.cardBR,
        border: Border.all(
          color: ColorTokens.brandPrimary.withValues(alpha: 0.25),
        ),
      ),
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_running) {
      return Row(
        children: [
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation(ColorTokens.brandPrimary),
            ),
          ),
          const SizedBox(width: SpaceTokens.md),
          Expanded(
            child: Text('AI is analysing the photo…',
                style: TypographyTokens.textTheme.bodyMedium),
          ),
        ],
      );
    }

    if (_error != null) {
      return _Message(
        icon: Icons.info_outline,
        text: _error!,
        actionLabel: 'Try again',
        onAction: _run,
      );
    }

    final scan = _scan;
    if (scan == null) {
      return Row(
        children: [
          const Icon(Icons.auto_awesome, color: ColorTokens.brandPrimary),
          const SizedBox(width: SpaceTokens.md),
          Expanded(
            child: Text(
              'Not sure which species? Let AI recognise it from your photo.',
              style: TypographyTokens.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: SpaceTokens.sm),
          FilledButton.tonal(
            onPressed: _run,
            child: const Text('Identify'),
          ),
        ],
      );
    }

    switch (scan.outcome) {
      case _Outcome.notButterfly:
        return _Message(
          icon: Icons.search_off,
          text: 'No butterfly was found in this photo. Try a clear photo of '
              'a butterfly.',
          actionLabel: 'Retry',
          onAction: _run,
        );
      case _Outcome.unrecognised:
        return _Message(
          icon: Icons.search_off,
          text: "Couldn't identify the species from this photo. You can "
              'still submit — our AI takes a closer look after upload.',
          actionLabel: 'Retry',
          onAction: _run,
        );
      case _Outcome.butterfly:
        break;
    }

    final name = scan.name ?? 'Unknown';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.auto_awesome,
                size: 18, color: ColorTokens.brandPrimary),
            const SizedBox(width: SpaceTokens.sm),
            Expanded(
              child: Text(
                'Looks like: $name · ${scan.pct}%',
                style: TypographyTokens.textTheme.titleSmall,
              ),
            ),
          ],
        ),
        if (scan.scientific != null) ...[
          const SizedBox(height: SpaceTokens.xs),
          Text(
            scan.scientific!,
            style: TypographyTokens.caption.copyWith(
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        if (scan.alternatives.isNotEmpty) ...[
          const SizedBox(height: SpaceTokens.xs),
          Text(
            'Could also be: ${scan.alternatives.join(', ')}',
            style: TypographyTokens.caption.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: SpaceTokens.sm),
        Row(
          children: [
            FilledButton.tonal(
              onPressed: () {
                Haptics.selection();
                widget.onUseLabel?.call(name);
              },
              child: const Text('Use as title'),
            ),
            const SizedBox(width: SpaceTokens.sm),
            TextButton(onPressed: _run, child: const Text('Re-scan')),
          ],
        ),
      ],
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.text,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String text;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: ColorTokens.warning),
        const SizedBox(width: SpaceTokens.md),
        Expanded(
          child: Text(text, style: TypographyTokens.textTheme.bodySmall),
        ),
        TextButton(onPressed: onAction, child: Text(actionLabel)),
      ],
    );
  }
}
