import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/responsive/app_breakpoints.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../shared/widgets/cards/rarity_badge.dart';
import '../../../../shared/widgets/cards/species_card.dart';
import '../../../../shared/widgets/inputs/floating_search_bar.dart';
import '../../../../shared/widgets/loaders/skeleton.dart';
import '../../../../shared/widgets/states/empty_state.dart';
import '../../../home/data/models/species_summary.dart';
import '../providers/species_providers.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// SPECIES SEARCH SCREEN
/// Dedicated full-screen search with debounce + result grid.
/// ─────────────────────────────────────────────────────────────────────────────

final _searchQueryProvider = StateProvider.autoDispose<String>((_) => '');

final _searchResultsProvider =
    FutureProvider.autoDispose<List<SpeciesSummary>>((ref) async {
  final query = ref.watch(_searchQueryProvider);
  if (query.trim().length < 2) return [];
  final result = await ref.read(speciesRepositoryProvider).search(query);
  return result.fold((_) => <SpeciesSummary>[], (list) => list);
});

class SpeciesSearchScreen extends ConsumerStatefulWidget {
  const SpeciesSearchScreen({super.key});

  @override
  ConsumerState<SpeciesSearchScreen> createState() =>
      _SpeciesSearchScreenState();
}

class _SpeciesSearchScreenState extends ConsumerState<SpeciesSearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      ref.read(_searchQueryProvider.notifier).state = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(_searchQueryProvider);
    final resultsAsync = ref.watch(_searchResultsProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(SpaceTokens.base),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    tooltip: 'Back',
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: FloatingSearchBar(
                      hint: 'Search butterflies…',
                      controller: _controller,
                      autofocus: true,
                      onChanged: _onChanged,
                      trailing: query.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              tooltip: 'Clear search',
                              onPressed: () {
                                _controller.clear();
                                ref.read(_searchQueryProvider.notifier).state = '';
                              },
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildResults(context, query, resultsAsync)),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(
    BuildContext context,
    String query,
    AsyncValue<List<SpeciesSummary>> resultsAsync,
  ) {
    if (query.trim().length < 2) {
      return const AppEmptyState(
        icon: Icons.search,
        title: 'Search species',
        message: 'Type at least 2 characters to find butterflies by name.',
      );
    }

    return resultsAsync.when(
      loading: () => SkeletonGrid(
        crossAxisCount: AppBreakpoints.gridColumns(context),
        itemCount: 6,
      ),
      error: (e, _) => AppEmptyState.error(message: e.toString()),
      data: (results) {
        if (results.isEmpty) {
          return AppEmptyState(
            icon: Icons.search_off,
            title: 'No matches',
            message: 'No species found for "$query".',
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(SpaceTokens.base),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: AppBreakpoints.gridColumns(context),
            crossAxisSpacing: SpaceTokens.md,
            mainAxisSpacing: SpaceTokens.md,
            childAspectRatio: 0.72,
          ),
          itemCount: results.length,
          itemBuilder: (context, i) {
            final s = results[i];
            return SpeciesCard(
              id: s.id,
              commonName: s.commonName,
              scientificName: s.scientificName,
              imageUrl: s.primaryImageUrl,
              rarity:
                  s.rarity != null ? RarityTier.fromString(s.rarity) : null,
              onTap: () => context.push(AppRoutes.speciesDetailPath(s.id)),
            );
          },
        );
      },
    );
  }
}
