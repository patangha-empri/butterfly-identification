import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../../../core/utils/a11y.dart';
import '../providers/community_providers.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// LIKE BUTTON
/// Optimistic heart toggle. Calls the backend like endpoint and reconciles with
/// the server's authoritative count; reverts on failure. Reports the result via
/// [onChanged] so parent lists can stay in sync.
/// ─────────────────────────────────────────────────────────────────────────────

class LikeButton extends ConsumerStatefulWidget {
  const LikeButton({
    super.key,
    required this.observationId,
    required this.initialLiked,
    required this.initialCount,
    this.onChanged,
    this.compact = false,
  });

  final String observationId;
  final bool initialLiked;
  final int initialCount;
  final void Function(bool liked, int count)? onChanged;
  final bool compact;

  @override
  ConsumerState<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends ConsumerState<LikeButton> {
  late bool _liked = widget.initialLiked;
  late int _count = widget.initialCount;
  bool _busy = false;

  @override
  void didUpdateWidget(covariant LikeButton old) {
    super.didUpdateWidget(old);
    if (old.observationId != widget.observationId) {
      _liked = widget.initialLiked;
      _count = widget.initialCount;
    }
  }

  Future<void> _toggle() async {
    if (_busy) return;
    unawaited(Haptics.light());
    final prevLiked = _liked;
    final prevCount = _count;

    // Optimistic flip.
    setState(() {
      _busy = true;
      _liked = !_liked;
      _count = (_count + (_liked ? 1 : -1)).clamp(0, 1 << 30);
    });

    try {
      final toggle = ref.read(likeToggleProvider);
      final result = await toggle(widget.observationId);
      if (!mounted) return;
      setState(() {
        _liked = result.liked;
        _count = result.likeCount;
      });
      widget.onChanged?.call(result.liked, result.likeCount);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _liked = prevLiked;
        _count = prevCount;
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _liked
        ? ColorTokens.error
        : Theme.of(context).colorScheme.onSurfaceVariant;
    return Semantics(
      button: true,
      label: _liked ? 'Unlike, $_count likes' : 'Like, $_count likes',
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: _toggle,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: widget.compact ? 6 : 8,
            vertical: 6,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                scale: _busy ? 1.2 : 1.0,
                duration: const Duration(milliseconds: 150),
                child: Icon(
                  _liked ? Icons.favorite : Icons.favorite_border,
                  size: widget.compact ? 18 : 22,
                  color: color,
                ),
              ),
              const SizedBox(width: 6),
              Text('$_count',
                  style: TypographyTokens.textTheme.labelLarge
                      ?.copyWith(color: color)),
            ],
          ),
        ),
      ),
    );
  }
}
