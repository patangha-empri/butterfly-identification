import 'package:flutter/material.dart';
import '../../core/theme/design_tokens.dart';
import '../../core/theme/typography_tokens.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// SLIVER-COMPATIBLE BUILDING BLOCKS
/// Section header, horizontal carousel and padding helpers for CustomScrollView.
/// ─────────────────────────────────────────────────────────────────────────────

/// A sliver section header with title + optional "See all" action.
class SliverSectionHeader extends StatelessWidget {
  const SliverSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.padding = const EdgeInsets.fromLTRB(
      SpaceTokens.base,
      SpaceTokens.lg,
      SpaceTokens.base,
      SpaceTokens.md,
    ),
  });

  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TypographyTokens.textTheme.headlineSmall),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TypographyTokens.textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (actionLabel != null && onAction != null)
              TextButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
          ],
        ),
      ),
    );
  }
}

/// A horizontally-scrolling carousel rendered inside a sliver.
class SliverHorizontalCarousel extends StatelessWidget {
  const SliverHorizontalCarousel({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.height = 200,
    this.itemWidth = 150,
    this.gap = SpaceTokens.md,
    this.padding = const EdgeInsets.symmetric(horizontal: SpaceTokens.base),
  });

  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final double height;
  final double itemWidth;
  final double gap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: height,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: padding,
          physics: const BouncingScrollPhysics(),
          itemCount: itemCount,
          separatorBuilder: (_, __) => SizedBox(width: gap),
          itemBuilder: (context, index) => SizedBox(
            width: itemWidth,
            child: itemBuilder(context, index),
          ),
        ),
      ),
    );
  }
}

/// Adds horizontal padding around an existing sliver.
class SliverHorizontalPadding extends StatelessWidget {
  const SliverHorizontalPadding({
    super.key,
    required this.sliver,
    this.horizontal = SpaceTokens.base,
  });

  final Widget sliver;
  final double horizontal;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: horizontal),
      sliver: sliver,
    );
  }
}

/// Convenience vertical gap inside a CustomScrollView.
class SliverGap extends StatelessWidget {
  const SliverGap(this.height, {super.key});
  final double height;

  @override
  Widget build(BuildContext context) =>
      SliverToBoxAdapter(child: SizedBox(height: height));
}
