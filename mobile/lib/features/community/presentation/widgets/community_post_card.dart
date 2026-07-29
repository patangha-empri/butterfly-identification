import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../../../core/utils/relative_time.dart';
import '../../../../shared/widgets/app_avatar.dart';
import '../../../../shared/widgets/loaders/skeleton.dart';
import '../../../home/data/models/observation_summary.dart';
import 'comments_sheet.dart';
import 'like_button.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// COMMUNITY POST CARD
/// Rich feed card: hero image, author, species, location, like + comment actions.
/// ─────────────────────────────────────────────────────────────────────────────

class CommunityPostCard extends StatelessWidget {
  const CommunityPostCard({
    super.key,
    required this.observation,
    this.onLikeChanged,
    this.onCommentCountChanged,
  });

  final ObservationSummary observation;
  final void Function(bool liked, int count)? onLikeChanged;
  final void Function(int count)? onCommentCountChanged;

  @override
  Widget build(BuildContext context) {
    final title = observation.identifiedSpeciesName ??
        observation.title ??
        'Unidentified sighting';
    final location = [observation.locationName, observation.stateName]
        .where((e) => e != null && e.isNotEmpty)
        .join(', ');

    return RepaintBoundary(
      child: Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: SpaceTokens.base),
      shape: RoundedRectangleBorder(borderRadius: RadiusTokens.cardBR),
      child: InkWell(
        onTap: () =>
            context.push(AppRoutes.observationDetailPath(observation.id)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AuthorRow(observation: observation),
            _Image(url: observation.primaryImageUrl),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SpaceTokens.base,
                SpaceTokens.md,
                SpaceTokens.base,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TypographyTokens.textTheme.titleMedium),
                  if (location.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.place_outlined,
                            size: 14,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TypographyTokens.caption.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              )),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            _ActionsRow(
              observation: observation,
              onLikeChanged: onLikeChanged,
              onCommentCountChanged: onCommentCountChanged,
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class _AuthorRow extends StatelessWidget {
  const _AuthorRow({required this.observation});
  final ObservationSummary observation;

  @override
  Widget build(BuildContext context) {
    final name = observation.userName ?? 'Anonymous explorer';
    final targetUsername = observation.userUsername ?? observation.userName;
    final canVisit = targetUsername != null && targetUsername.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        SpaceTokens.md,
        SpaceTokens.md,
        SpaceTokens.sm,
        SpaceTokens.sm,
      ),
      child: Row(
        children: [
          AppAvatar(
            radius: 18,
            imageUrl: observation.userAvatarUrl,
            name: name,
          ),
          const SizedBox(width: SpaceTokens.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TypographyTokens.textTheme.labelLarge),
                Text(RelativeTime.format(observation.createdAt),
                    style: TypographyTokens.caption.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
              ],
            ),
          ),
          if (canVisit)
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.chevron_right),
              onPressed: () =>
                  context.push(AppRoutes.userProfilePath(targetUsername)),
            ),
        ],
      ),
    );
  }
}

class _Image extends StatelessWidget {
  const _Image({required this.url});
  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return Container(
        height: 200,
        color: ColorTokens.brandPrimary.withValues(alpha: 0.1),
        child: const Center(
          child: Icon(Icons.image_outlined,
              size: 40, color: ColorTokens.brandPrimary),
        ),
      );
    }
    final dpr = MediaQuery.maybeOf(context)?.devicePixelRatio ?? 2.0;
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: CachedNetworkImage(
        imageUrl: url!,
        fit: BoxFit.cover,
        memCacheWidth: (MediaQuery.sizeOf(context).width * dpr).round(),
        placeholder: (_, __) => const Skeleton(height: 200, borderRadius: 0),
        errorWidget: (_, __, ___) => Container(
          color: ColorTokens.brandPrimary.withValues(alpha: 0.1),
          child: const Center(
            child: Icon(Icons.broken_image_outlined,
                color: ColorTokens.brandPrimary),
          ),
        ),
      ),
    );
  }
}

class _ActionsRow extends StatelessWidget {
  const _ActionsRow({
    required this.observation,
    this.onLikeChanged,
    this.onCommentCountChanged,
  });
  final ObservationSummary observation;
  final void Function(bool liked, int count)? onLikeChanged;
  final void Function(int count)? onCommentCountChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.sm),
      child: Row(
        children: [
          LikeButton(
            observationId: observation.id,
            initialLiked: observation.isLiked,
            initialCount: observation.likeCount,
            onChanged: onLikeChanged,
          ),
          TextButton.icon(
            onPressed: () => showCommentsSheet(
              context,
              observationId: observation.id,
              onCountChanged: onCommentCountChanged,
            ),
            icon: const Icon(Icons.mode_comment_outlined, size: 20),
            label: Text('${observation.commentCount}'),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
