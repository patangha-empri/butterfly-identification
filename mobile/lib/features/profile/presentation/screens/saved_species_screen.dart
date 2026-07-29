import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/responsive/app_breakpoints.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../shared/widgets/cards/rarity_badge.dart';
import '../../../../shared/widgets/cards/species_card.dart';
import '../../../../shared/widgets/loaders/skeleton.dart';
import '../../../../shared/widgets/states/empty_state.dart';
import '../../../species/presentation/providers/species_providers.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// SAVED SPECIES SCREEN (/profile/saved)
/// Lists the species the user has bookmarked. Bookmarks are stored locally on
/// the device (see SpeciesRepository.toggleBookmark) so this works offline.
/// ─────────────────────────────────────────────────────────────────────────────

class SavedSpeciesScreen extends ConsumerWidget {
  const SavedSpeciesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedAsync = ref.watch(savedSpeciesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Saved species')),
      body: savedAsync.when(
        loading: () => SkeletonGrid(
          crossAxisCount: AppBreakpoints.gridColumns(context),
        ),
        error: (e, _) => AppEmptyState.error(
          message: e.toString(),
          onRetry: () => ref.invalidate(savedSpeciesProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const AppEmptyState(
              icon: Icons.bookmark_outline,
              title: 'No saved species yet',
              message:
                  'Tap the bookmark on any species to save it here for quick access.',
            );
          }
          return GridView.builder(
            padding: EdgeInsets.fromLTRB(
              SpaceTokens.base,
              SpaceTokens.base,
              SpaceTokens.base,
              SpaceTokens.base + MediaQuery.viewPaddingOf(context).bottom,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: AppBreakpoints.gridColumns(context),
              crossAxisSpacing: SpaceTokens.md,
              mainAxisSpacing: SpaceTokens.md,
              childAspectRatio: 0.72,
            ),
            itemCount: items.length,
            itemBuilder: (context, i) {
              final s = items[i];
              return SpeciesCard(
                id: s.id,
                commonName: s.commonName,
                scientificName: s.scientificName,
                imageUrl: s.primaryImageUrl,
                rarity: s.rarity != null
                    ? RarityTier.fromString(s.rarity)
                    : null,
                isBookmarked: true,
                onBookmarkToggle: () => ref
                    .read(speciesRepositoryProvider)
                    .toggleBookmark(s.id),
                onTap: () => context.push(AppRoutes.speciesDetailPath(s.id)),
              );
            },
          );
        },
      ),
    );
  }
}
