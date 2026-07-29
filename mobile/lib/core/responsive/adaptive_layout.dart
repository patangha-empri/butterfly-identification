import 'package:flutter/material.dart';
import 'app_breakpoints.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// ADAPTIVE LAYOUT BUILDER
/// Renders different widget trees per device class.
/// Usage:
///   AdaptiveLayout(
///     mobile: (_) => MobileView(),
///     tablet: (_) => TabletView(),
///     foldable: (_) => FoldableView(),      // optional — falls back to mobile
///   )
/// ─────────────────────────────────────────────────────────────────────────────

class AdaptiveLayout extends StatelessWidget {
  const AdaptiveLayout({
    super.key,
    required this.mobile,
    this.foldable,
    this.tablet,
    this.tabletLarge,
  });

  final WidgetBuilder mobile;
  final WidgetBuilder? foldable;
  final WidgetBuilder? tablet;
  final WidgetBuilder? tabletLarge;

  @override
  Widget build(BuildContext context) {
    if (AppBreakpoints.isTabletLarge(context)) {
      return (tabletLarge ?? tablet ?? mobile)(context);
    }
    if (AppBreakpoints.isTablet(context)) {
      return (tablet ?? mobile)(context);
    }
    if (AppBreakpoints.isFoldable(context)) {
      return (foldable ?? mobile)(context);
    }
    return mobile(context);
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
/// ADAPTIVE TWO-PANEL LAYOUT
/// Renders a master-detail split on tablets, single panel on phones.
/// ─────────────────────────────────────────────────────────────────────────────

class AdaptiveTwoPanel extends StatelessWidget {
  const AdaptiveTwoPanel({
    super.key,
    required this.primary,
    required this.secondary,
    this.primaryFlex = 1,
    this.secondaryFlex = 1,
    this.dividerWidth = 0.5,
    this.dividerColor,
    this.showPrimaryOnPhone = true,
  });

  final Widget primary;
  final Widget secondary;
  final int primaryFlex;
  final int secondaryFlex;
  final double dividerWidth;
  final Color? dividerColor;
  final bool showPrimaryOnPhone;

  @override
  Widget build(BuildContext context) {
    if (!AppBreakpoints.isTablet(context)) {
      return showPrimaryOnPhone ? primary : secondary;
    }
    return Row(
      children: [
        Flexible(flex: primaryFlex, child: primary),
        if (dividerWidth > 0)
          VerticalDivider(
            width: dividerWidth,
            thickness: dividerWidth,
            color: dividerColor ?? Theme.of(context).dividerColor,
          ),
        Flexible(flex: secondaryFlex, child: secondary),
      ],
    );
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
/// ADAPTIVE GRID
/// Responsive cross-axis count based on breakpoint.
/// ─────────────────────────────────────────────────────────────────────────────

class AdaptiveGrid extends StatelessWidget {
  const AdaptiveGrid({
    super.key,
    required this.children,
    this.crossAxisSpacing = 12,
    this.mainAxisSpacing = 12,
    this.childAspectRatio = 1.0,
    this.customColumnCount,
  });

  final List<Widget> children;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;
  final int? customColumnCount;

  @override
  Widget build(BuildContext context) {
    final columns = customColumnCount ?? AppBreakpoints.gridColumns(context);
    return GridView.count(
      crossAxisCount: columns,
      crossAxisSpacing: crossAxisSpacing,
      mainAxisSpacing: mainAxisSpacing,
      childAspectRatio: childAspectRatio,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
/// ADAPTIVE NAVIGATION SCAFFOLD
/// Switches between BottomNavigationBar and NavigationRail per breakpoint.
/// ─────────────────────────────────────────────────────────────────────────────

class AdaptiveNavigationScaffold extends StatelessWidget {
  const AdaptiveNavigationScaffold({
    super.key,
    required this.body,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.floatingActionButton,
    this.extendBody = true,
  });

  final Widget body;
  final List<NavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget? floatingActionButton;
  final bool extendBody;

  @override
  Widget build(BuildContext context) {
    final navType = AppBreakpoints.navType(context);

    if (navType == AppNavigationType.rail) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              destinations: destinations
                  .map((d) => NavigationRailDestination(
                        icon: d.icon,
                        selectedIcon: d.selectedIcon ?? d.icon,
                        label: Text(d.label),
                      ))
                  .toList(),
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              labelType: NavigationRailLabelType.all,
              leading: const SizedBox(height: 16),
            ),
            const VerticalDivider(width: 0.5),
            Expanded(child: body),
          ],
        ),
        floatingActionButton: floatingActionButton,
      );
    }

    return Scaffold(
      extendBody: extendBody,
      body: body,
      bottomNavigationBar: NavigationBar(
        destinations: destinations,
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
/// MAX WIDTH CONTAINER
/// Centers + constrains content width for large screens.
/// ─────────────────────────────────────────────────────────────────────────────

class MaxWidthContainer extends StatelessWidget {
  const MaxWidthContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
  });

  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final max = maxWidth ?? AppBreakpoints.maxContentWidth(context);
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: max),
        child: padding != null
            ? Padding(padding: padding!, child: child)
            : child,
      ),
    );
  }
}
