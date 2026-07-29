import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../../../shared/widgets/buttons/circle_back_button.dart';
import '../../../../shared/widgets/confidence_meter.dart';
import '../../../../shared/widgets/loaders/skeleton.dart';
import '../../../../shared/widgets/states/empty_state.dart';
import '../../../../shared/widgets/cards/species_insights_card.dart';
import '../../../community/presentation/widgets/comments_sheet.dart';
import '../../../community/presentation/widgets/like_button.dart';
import '../../../species/presentation/widgets/species_gallery.dart';
import '../../../species/presentation/providers/species_providers.dart';
import '../../../species/data/models/species_detail.dart';
import '../../../../core/utils/a11y.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/observation.dart';
import '../providers/observation_providers.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// OBSERVATION DETAIL SCREEN (replaces the Phase 3 stub)
/// ─────────────────────────────────────────────────────────────────────────────

class ObservationDetailScreen extends ConsumerWidget {
  const ObservationDetailScreen({super.key, required this.observationId});

  final String observationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(observationDetailProvider(observationId));

    return Scaffold(
      body: async.when(
        loading: () => const _DetailSkeleton(),
        error: (err, _) => SafeArea(
          child: AppEmptyState.error(
            message: err.toString(),
            onRetry: () =>
                ref.invalidate(observationDetailProvider(observationId)),
          ),
        ),
        data: (obs) => CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: obs.imageUrls.isEmpty ? 120 : 300,
              pinned: true,
              leading: const CircleBackButton(),
              flexibleSpace: FlexibleSpaceBar(
                background: obs.imageUrls.isEmpty
                    ? Container(color: ColorTokens.brandPrimary.withValues(alpha: 0.15))
                    : SpeciesGallery(imageUrls: obs.imageUrls),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                SpaceTokens.lg,
                SpaceTokens.lg,
                SpaceTokens.lg,
                SpaceTokens.lg + MediaQuery.viewPaddingOf(context).bottom,
              ),
              sliver: SliverList.list(children: _content(context, obs)),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _content(BuildContext context, Observation obs) {
    return [
      // Moderation outcome — only the owner/staff ever receive this state.
      if (obs.isRejected) ...[
        _RejectedBanner(reason: obs.adminNotes),
        const SizedBox(height: SpaceTokens.lg),
      ],

      // AI identification status
      _IdentificationCard(obs: obs),
      const SizedBox(height: SpaceTokens.lg),

      _PrivacyToggleCard(obs: obs),
      const SizedBox(height: SpaceTokens.lg),

      if (obs.title != null && obs.title!.isNotEmpty) ...[
        Text(obs.title!, style: TypographyTokens.textTheme.headlineSmall),
        const SizedBox(height: SpaceTokens.xs),
      ],

      Row(
        children: [
          Icon(Icons.place_outlined,
              size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: SpaceTokens.xs),
          Expanded(
            child: Text(
              [obs.locationName, obs.districtName, obs.stateName]
                  .where((e) => e != null && e.isNotEmpty)
                  .join(', '),
              style: TypographyTokens.textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),

      if (obs.notes != null && obs.notes!.isNotEmpty) ...[
        const SizedBox(height: SpaceTokens.lg),
        Text('Notes', style: TypographyTokens.textTheme.titleMedium),
        const SizedBox(height: SpaceTokens.xs),
        Text(obs.notes!,
            style: TypographyTokens.textTheme.bodyLarge?.copyWith(height: 1.5)),
      ],

      const SizedBox(height: SpaceTokens.lg),
      Wrap(
        spacing: SpaceTokens.sm,
        runSpacing: SpaceTokens.sm,
        children: [
          if (obs.weather != null)
            _MetaChip(icon: Icons.wb_sunny_outlined, label: obs.weather!),
          if (obs.butterflyActivity != null)
            _MetaChip(icon: Icons.flutter_dash, label: obs.butterflyActivity!),
          _MetaChip(icon: Icons.numbers, label: '${obs.countObserved} seen'),
        ],
      ),

      const SizedBox(height: SpaceTokens.md),
      const Divider(),
      _SocialBar(obs: obs),
      const SizedBox(height: SpaceTokens.xxl),
    ];
  }
}

/// Like + comment actions for an observation detail.
class _SocialBar extends StatelessWidget {
  const _SocialBar({required this.obs});
  final Observation obs;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        LikeButton(
          observationId: obs.id,
          initialLiked: obs.isLiked,
          initialCount: obs.likeCount,
        ),
        const SizedBox(width: SpaceTokens.sm),
        TextButton.icon(
          onPressed: () =>
              showCommentsSheet(context, observationId: obs.id),
          icon: const Icon(Icons.mode_comment_outlined, size: 20),
          label: Text('${obs.commentCount}'),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _RejectedBanner extends StatelessWidget {
  const _RejectedBanner({this.reason});
  final String? reason;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SpaceTokens.md),
      decoration: BoxDecoration(
        color: ColorTokens.error.withValues(alpha: 0.10),
        borderRadius: RadiusTokens.cardBR,
        border: Border.all(color: ColorTokens.error.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.block, color: ColorTokens.error, size: 20),
          const SizedBox(width: SpaceTokens.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rejected by moderators',
                  style: TypographyTokens.textTheme.titleSmall?.copyWith(
                    color: ColorTokens.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  reason != null && reason!.trim().isNotEmpty
                      ? 'Reason: ${reason!}'
                      : 'This sighting is hidden from the community. '
                          'Only you can see it.',
                  style: TypographyTokens.textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                if (reason != null && reason!.trim().isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'This sighting is hidden from the community. Only you can see it.',
                    style: TypographyTokens.textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IdentificationCard extends ConsumerStatefulWidget {
  const _IdentificationCard({required this.obs});
  final Observation obs;

  @override
  ConsumerState<_IdentificationCard> createState() => _IdentificationCardState();
}

class _IdentificationCardState extends ConsumerState<_IdentificationCard> {
  bool _isRetrying = false;

  Future<void> _triggerIdentify(BuildContext context) async {
    setState(() => _isRetrying = true);
    try {
      await ref.read(observationRemoteDataSourceProvider).triggerIdentify(widget.obs.id);
      // Invalidate the detail provider to force a refresh of the UI
      ref.invalidate(observationDetailProvider(widget.obs.id));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to trigger AI identification: $e'),
            backgroundColor: ColorTokens.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isRetrying = false);
      }
    }
  }

  Widget _buildIdentifiedCard(BuildContext context, Observation obs, SpeciesDetail? speciesDetail) {
    final locationText = [obs.locationName, obs.districtName, obs.stateName]
        .where((e) => e != null && e.isNotEmpty)
        .join(', ');
    final rangeText = speciesDetail?.states.join(', ');
    final descriptionText = obs.identificationReasoning ?? speciesDetail?.description;

    return Container(
      padding: const EdgeInsets.all(SpaceTokens.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: RadiusTokens.cardBR,
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AI identified',
                style: TypographyTokens.textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              if (obs.identifiedSpeciesId != null)
                GestureDetector(
                  onTap: () => context.push('/species/${obs.identifiedSpeciesId}'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View species →',
                        style: TypographyTokens.textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: SpaceTokens.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (obs.imageUrls.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(RadiusTokens.md),
                  child: CachedNetworkImage(
                    imageUrl: obs.imageUrls.first,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: SpaceTokens.md),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      obs.identifiedSpeciesName ?? 'Unknown species',
                      style: TypographyTokens.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (speciesDetail?.scientificName != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        speciesDetail!.scientificName,
                        style: TypographyTokens.scientificName.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    const SizedBox(height: SpaceTokens.sm),
                    if (obs.identificationConfidence != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: ColorTokens.brandPrimary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(RadiusTokens.xs),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ConfidenceMeter(
                              value: obs.identificationConfidence!,
                              size: 14,
                              strokeWidth: 2.2,
                              showLabel: false,
                              animate: false,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${(obs.identificationConfidence! * 100).toStringAsFixed(0)}% AI Accuracy',
                              style: TypographyTokens.textTheme.labelSmall?.copyWith(
                                color: ColorTokens.brandPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: SpaceTokens.md),
          const Divider(),
          const SizedBox(height: SpaceTokens.sm),

          if (locationText.isNotEmpty)
            _buildDetailField(
              context,
              icon: Icons.place_outlined,
              label: 'Where we found it',
              value: locationText,
            ),

          if (rangeText != null && rangeText.isNotEmpty)
            _buildDetailField(
              context,
              icon: Icons.map_outlined,
              label: 'Typical distribution area',
              value: rangeText,
            ),

          if (descriptionText != null && descriptionText.isNotEmpty)
            _buildDetailField(
              context,
              icon: Icons.info_outline,
              label: 'Description',
              value: descriptionText,
            ),

          if (speciesDetail != null) ...[
            const SizedBox(height: SpaceTokens.md),
            const Divider(),
            if (obs.rawGeminiResponse?['species_profile'] != null)
              SpeciesInsightsCard(profile: obs.rawGeminiResponse!['species_profile'])
            else
              SpeciesInsightsCard.fromDetail(speciesDetail),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailField(BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SpaceTokens.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: SpaceTokens.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TypographyTokens.textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TypographyTokens.textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final obs = widget.obs;

    if (obs.imageUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    if (obs.isAnalysing || _isRetrying) {
      return Container(
        padding: const EdgeInsets.all(SpaceTokens.base),
        decoration: BoxDecoration(
          color: ColorTokens.brandSecondary.withValues(alpha: 0.1),
          borderRadius: RadiusTokens.cardBR,
          border: Border.all(
              color: ColorTokens.brandSecondary.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.4),
            ),
            const SizedBox(width: SpaceTokens.base),
            Expanded(
              child: Text(
                _isRetrying
                    ? 'Starting AI identification…'
                    : 'AI is analysing this sighting to identify the species. Check back shortly.',
                style: TypographyTokens.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      );
    }

    if (obs.isIdentified && obs.identifiedSpeciesId != null) {
      final speciesDetailAsync = ref.watch(speciesDetailProvider(obs.identifiedSpeciesId!));
      return speciesDetailAsync.when(
        loading: () => Container(
          padding: const EdgeInsets.all(SpaceTokens.md),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
            borderRadius: RadiusTokens.cardBR,
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: const Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: SpaceTokens.md),
              Text('Loading species details…'),
            ],
          ),
        ),
        error: (err, _) => _buildIdentifiedCard(context, obs, null),
        data: (speciesDetail) => _buildIdentifiedCard(context, obs, speciesDetail),
      );
    }

    return const SizedBox.shrink();
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(
            horizontal: SpaceTokens.md, vertical: SpaceTokens.xs),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: RadiusTokens.pillBR,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: SpaceTokens.xs),
            Text(label, style: TypographyTokens.textTheme.labelMedium),
          ],
        ),
      );
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();
  @override
  Widget build(BuildContext context) => const SkeletonShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Skeleton(height: 300, borderRadius: 0),
            Padding(
              padding: EdgeInsets.all(SpaceTokens.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Skeleton(height: 80, borderRadius: RadiusTokens.card),
                  SizedBox(height: SpaceTokens.lg),
                  Skeleton(width: 180, height: 22),
                  SizedBox(height: SpaceTokens.sm),
                  Skeleton(width: 240, height: 14),
                ],
              ),
            ),
          ],
        ),
      );
}

class _PrivacyToggleCard extends ConsumerStatefulWidget {
  const _PrivacyToggleCard({required this.obs});
  final Observation obs;

  @override
  ConsumerState<_PrivacyToggleCard> createState() => _PrivacyToggleCardState();
}

class _PrivacyToggleCardState extends ConsumerState<_PrivacyToggleCard> {
  bool _isLoading = false;

  Future<void> _togglePrivacy(bool makePublic) async {
    setState(() => _isLoading = true);
    final newPrivacy = makePublic ? 'public' : 'private';
    
    final result = await ref
        .read(observationRepositoryProvider)
        .updatePrivacy(widget.obs.id, newPrivacy);

    if (mounted) {
      setState(() => _isLoading = false);
      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update privacy: ${failure.message}'),
              backgroundColor: ColorTokens.error,
            ),
          );
        },
        (updatedObs) {
          // Invalidate the detail provider to fetch updated observation detail
          ref.invalidate(observationDetailProvider(widget.obs.id));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                makePublic
                    ? 'Sighting is now shared publicly!'
                    : 'Sighting is now private.',
              ),
              backgroundColor: ColorTokens.success,
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final isOwner = currentUser?.id == widget.obs.userId;

    // If the viewer is not the owner, do not show the privacy control card
    if (!isOwner) return const SizedBox.shrink();

    final isPublic = widget.obs.privacy == 'public';

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: RadiusTokens.cardBR),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SpaceTokens.md,
          vertical: SpaceTokens.sm,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(SpaceTokens.sm),
              decoration: BoxDecoration(
                color: isPublic
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.amber.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPublic ? Icons.public : Icons.lock_outline,
                color: isPublic ? Colors.green : Colors.amber,
                size: 20,
              ),
            ),
            const SizedBox(width: SpaceTokens.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isPublic ? 'Shared Publicly' : 'Private Sighting',
                    style: TypographyTokens.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    isPublic
                        ? 'Visible to the community feed'
                        : 'Only visible to you',
                    style: TypographyTokens.caption.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Switch(
                value: isPublic,
                activeColor: ColorTokens.brandPrimary,
                onChanged: (val) {
                  Haptics.selection();
                  _togglePrivacy(val);
                },
              ),
          ],
        ),
      ),
    );
  }
}
