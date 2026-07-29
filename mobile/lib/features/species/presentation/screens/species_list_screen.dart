import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/responsive/app_breakpoints.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../../../shared/widgets/cards/rarity_badge.dart';
import '../../../../shared/widgets/cards/species_card.dart';
import '../../../../shared/widgets/inputs/floating_search_bar.dart';
import '../../../../shared/widgets/loaders/skeleton.dart';
import '../../../../shared/widgets/overlays/app_bottom_sheet.dart';
import '../../../../shared/widgets/states/empty_state.dart';
import '../../data/models/species_filter.dart';
import '../providers/species_providers.dart';
import '../widgets/species_filter_sheet.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// SPECIES LIST SCREEN (Tab 1)
/// Responsive grid + debounced search + filter sheet + infinite scroll.
/// ─────────────────────────────────────────────────────────────────────────────

class SpeciesListScreen extends ConsumerStatefulWidget {
  const SpeciesListScreen({super.key});

  @override
  ConsumerState<SpeciesListScreen> createState() => _SpeciesListScreenState();
}

class _SpeciesListScreenState extends ConsumerState<SpeciesListScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.text = ref.read(speciesFilterProvider).query ?? '';
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 400) {
      ref.read(speciesListProvider.notifier).loadMore();
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final current = ref.read(speciesFilterProvider);
      ref.read(speciesFilterProvider.notifier).state = value.trim().isEmpty
          ? current.copyWith(clearQuery: true)
          : current.copyWith(query: value.trim());
    });
  }

  void _openFilterSheet() {
    final current = ref.read(speciesFilterProvider);
    AppBottomSheet.show(
      context,
      title: 'Filter species',
      scrollable: false,
      child: SpeciesFilterSheet(
        initial: current,
        onApply: (f) => ref.read(speciesFilterProvider.notifier).state = f,
      ),
    );
  }

  int _columns(BuildContext context) => AppBreakpoints.gridColumns(context);

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(speciesListProvider);
    final filter = ref.watch(speciesFilterProvider);
    final bookmarks = ref.watch(bookmarkedSpeciesProvider).valueOrNull ?? {};

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Header: search + filter ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SpaceTokens.base,
                SpaceTokens.sm,
                SpaceTokens.base,
                SpaceTokens.sm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: FloatingSearchBar(
                      hint: 'Search species…',
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                    ),
                  ),
                  const SizedBox(width: SpaceTokens.sm),
                  _FilterButton(
                    count: filter.activeCount,
                    onTap: _openFilterSheet,
                  ),
                ],
              ),
            ),

            // ── Active filter chips ────────────────────────────────────────
            if (filter.activeCount > 0)
              _ActiveFilterBar(
                filter: filter,
                onClear: () => ref.read(speciesFilterProvider.notifier).state =
                    filter.clearedFacets(),
              ),

            // ── Grid ───────────────────────────────────────────────────────
            Expanded(child: _buildBody(context, state, bookmarks)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    SpeciesListState state,
    Set<String> bookmarks,
  ) {
    if (state.isInitialLoading) {
      return SkeletonGrid(crossAxisCount: _columns(context), itemCount: 8);
    }

    if (state.hasError && state.items.isEmpty) {
      return AppEmptyState.error(
        message: state.error,
        onRetry: () => ref.read(speciesListProvider.notifier).refresh(),
      );
    }

    if (state.isEmpty) {
      return const AppEmptyState(
        icon: Icons.search_off,
        title: 'No species found',
        message: 'Try adjusting your search or filters.',
      );
    }

    final columns = _columns(context);
    // Clear the shell's bottom nav bar (extendBody) + the device gesture inset.
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom + 80;
    return RefreshIndicator(
      onRefresh: () => ref.read(speciesListProvider.notifier).refresh(),
      child: GridView.builder(
        controller: _scrollController,
        padding: EdgeInsets.fromLTRB(
          SpaceTokens.base,
          SpaceTokens.xs,
          SpaceTokens.base,
          bottomInset,
        ),
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: SpaceTokens.md,
          mainAxisSpacing: SpaceTokens.md,
          childAspectRatio: 0.72,
        ),
        itemCount: state.items.length + (state.isLoadingMore ? columns : 0),
        itemBuilder: (context, index) {
          if (index >= state.items.length) {
            return const SpeciesCardSkeleton();
          }
          final s = state.items[index];
          return SpeciesCard(
            id: s.id,
            commonName: s.commonName,
            scientificName: s.scientificName,
            imageUrl: s.primaryImageUrl,
            rarity:
                s.rarity != null ? RarityTier.fromString(s.rarity) : null,
            heroTag: 'species-list-${s.id}',
            isBookmarked: bookmarks.contains(s.id),
            onBookmarkToggle: () =>
                ref.read(speciesRepositoryProvider).toggleBookmark(s.id),
            onTap: () => context.push(AppRoutes.speciesDetailPath(s.id)),
          );
        },
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.count, required this.onTap});
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Badge(
      isLabelVisible: count > 0,
      label: Text('$count'),
      backgroundColor: ColorTokens.brandAccent,
      child: Material(
        color: count > 0
            ? ColorTokens.brandPrimary
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: RadiusTokens.pillBR,
        child: InkWell(
          borderRadius: RadiusTokens.pillBR,
          onTap: onTap,
          child: SizedBox(
            width: 52,
            height: 52,
            child: Icon(
              Icons.tune,
              color: count > 0
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _ActiveFilterBar extends StatelessWidget {
  const _ActiveFilterBar({required this.filter, required this.onClear});
  final SpeciesFilter filter;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Row(
        children: [
          const SizedBox(width: SpaceTokens.base),
          Text(
            '${filter.activeCount} filter${filter.activeCount > 1 ? 's' : ''}',
            style: TypographyTokens.textTheme.labelMedium,
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: onClear,
            icon: const Icon(Icons.close, size: 14),
            label: const Text('Clear'),
          ),
          const SizedBox(width: SpaceTokens.sm),
        ],
      ),
    );
  }
}
