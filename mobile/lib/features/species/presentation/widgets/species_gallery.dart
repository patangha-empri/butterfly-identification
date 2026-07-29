import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../shared/widgets/loaders/skeleton.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// SPECIES GALLERY
/// Swipeable hero gallery with page dots + tap-to-open full-screen viewer.
/// ─────────────────────────────────────────────────────────────────────────────

class SpeciesGallery extends StatefulWidget {
  const SpeciesGallery({
    super.key,
    required this.imageUrls,
    this.heroTag,
  });

  final List<String> imageUrls;
  final Object? heroTag;

  @override
  State<SpeciesGallery> createState() => _SpeciesGalleryState();
}

class _SpeciesGalleryState extends State<SpeciesGallery> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) {
      return Container(
        color: ColorTokens.brandPrimary.withValues(alpha: 0.12),
        child: const Center(
          child: Icon(Icons.flutter_dash,
              size: 96, color: ColorTokens.brandPrimary),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: _controller,
          itemCount: widget.imageUrls.length,
          onPageChanged: (i) => setState(() => _index = i),
          itemBuilder: (context, i) {
            final image = CachedNetworkImage(
              imageUrl: widget.imageUrls[i],
              fit: BoxFit.cover,
              memCacheWidth: (MediaQuery.sizeOf(context).width *
                      (MediaQuery.maybeOf(context)?.devicePixelRatio ?? 2.0))
                  .round(),
              placeholder: (_, __) =>
                  const Skeleton(height: double.infinity, borderRadius: 0),
              errorWidget: (_, __, ___) => Container(
                color: ColorTokens.brandPrimary.withValues(alpha: 0.12),
                child: const Icon(Icons.broken_image_outlined, size: 48),
              ),
            );
            return GestureDetector(
              onTap: () => _openViewer(context, i),
              child: i == 0 && widget.heroTag != null
                  ? Hero(tag: widget.heroTag!, child: image)
                  : image,
            );
          },
        ),

        // Scrim for legibility of overlaid controls. Must not intercept
        // touches, or swipes/taps never reach the PageView below.
        const IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(gradient: ColorTokens.heroGradient),
          ),
        ),

        // Page dots
        if (widget.imageUrls.length > 1)
          Positioned(
            bottom: SpaceTokens.base,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.imageUrls.length, (i) {
                  final active = i == _index;
                  return AnimatedContainer(
                    duration: DurationTokens.fast,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: active ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: active ? Colors.white : Colors.white54,
                      borderRadius: RadiusTokens.pillBR,
                    ),
                  );
                }),
              ),
            ),
          ),
      ],
    );
  }

  void _openViewer(BuildContext context, int initial) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (_, __, ___) => _FullScreenViewer(
          imageUrls: widget.imageUrls,
          initialIndex: initial,
        ),
      ),
    );
  }
}

class _FullScreenViewer extends StatelessWidget {
  const _FullScreenViewer({required this.imageUrls, required this.initialIndex});

  final List<String> imageUrls;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    final controller = PageController(initialPage: initialIndex);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: controller,
            itemCount: imageUrls.length,
            itemBuilder: (_, i) => InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: imageUrls[i],
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + SpaceTokens.sm,
            right: SpaceTokens.sm,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              tooltip: 'Close',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
