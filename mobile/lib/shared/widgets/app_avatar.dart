import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/theme/color_tokens.dart';
import '../../core/theme/typography_tokens.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// APP AVATAR
/// Circular user avatar with an initials fallback. Decodes the network image at
/// (roughly) display resolution via [CachedNetworkImageProvider.maxWidth] so a
/// large source photo never inflates the image cache for a 36–88px circle.
/// ─────────────────────────────────────────────────────────────────────────────

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    required this.radius,
    this.imageUrl,
    this.name,
    this.backgroundColor,
    this.foregroundColor,
  });

  final double radius;
  final String? imageUrl;
  final String? name;
  final Color? backgroundColor;
  final Color? foregroundColor;

  String get _initials {
    final n = (name ?? '').trim();
    if (n.isEmpty) return '?';
    final parts = n.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    final letters = parts.take(2).map((p) => p[0].toUpperCase()).join();
    return letters.isEmpty ? '?' : letters;
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    final dpr = MediaQuery.maybeOf(context)?.devicePixelRatio ?? 2.0;
    final bg = backgroundColor ?? ColorTokens.brandPrimary.withValues(alpha: 0.15);
    final fg = foregroundColor ?? ColorTokens.brandPrimary;

    return Semantics(
      label: name != null && name!.isNotEmpty ? '$name profile photo' : 'Profile photo',
      image: true,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: bg,
        backgroundImage: hasImage
            ? CachedNetworkImageProvider(
                imageUrl!,
                maxWidth: (radius * 2 * dpr).round(),
              )
            : null,
        child: hasImage
            ? null
            : Text(
                _initials,
                style: TypographyTokens.textTheme.titleMedium
                    ?.copyWith(color: fg, fontSize: radius * 0.7),
              ),
      ),
    );
  }
}
