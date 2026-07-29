import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../../../core/utils/relative_time.dart';
import '../../../../shared/widgets/app_avatar.dart';
import '../../../../shared/widgets/overlays/app_bottom_sheet.dart';
import '../../../../shared/widgets/states/empty_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/comment.dart';
import '../providers/community_providers.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// COMMENTS SHEET
/// Presented from a sighting. Lists comments, lets the user post a new one and
/// delete their own. Reports the resulting count via [onCountChanged].
/// ─────────────────────────────────────────────────────────────────────────────

Future<void> showCommentsSheet(
  BuildContext context, {
  required String observationId,
  void Function(int count)? onCountChanged,
}) {
  return AppBottomSheet.show(
    context,
    title: 'Comments',
    scrollable: false,
    child: _CommentsBody(
      observationId: observationId,
      onCountChanged: onCountChanged,
    ),
  );
}

class _CommentsBody extends ConsumerStatefulWidget {
  const _CommentsBody({required this.observationId, this.onCountChanged});
  final String observationId;
  final void Function(int count)? onCountChanged;

  @override
  ConsumerState<_CommentsBody> createState() => _CommentsBodyState();
}

class _CommentsBodyState extends ConsumerState<_CommentsBody> {
  final _controller = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final body = _controller.text.trim();
    if (body.isEmpty || _sending) return;
    setState(() => _sending = true);
    final notifier = ref.read(commentsProvider(widget.observationId).notifier);
    final ok = await notifier.add(body);
    if (!mounted) return;
    setState(() => _sending = false);
    if (ok) {
      _controller.clear();
      FocusScope.of(context).unfocus();
      final count = ref.read(commentsProvider(widget.observationId)).value?.length ?? 0;
      widget.onCountChanged?.call(count);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not post comment. Try again.')),
      );
    }
  }

  Future<void> _delete(Comment c) async {
    final notifier = ref.read(commentsProvider(widget.observationId).notifier);
    final ok = await notifier.remove(c.id);
    if (!mounted) return;
    if (ok) {
      final count = ref.read(commentsProvider(widget.observationId)).value?.length ?? 0;
      widget.onCountChanged?.call(count);
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(commentsProvider(widget.observationId));
    final myId = ref.watch(currentUserProvider)?.id;

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.6,
      child: Column(
        children: [
          Expanded(
            child: async.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => AppEmptyState.error(
                message: e.toString(),
                onRetry: () => ref
                    .read(commentsProvider(widget.observationId).notifier)
                    .load(),
              ),
              data: (comments) {
                if (comments.isEmpty) {
                  return const AppEmptyState(
                    icon: Icons.mode_comment_outlined,
                    title: 'No comments yet',
                    message: 'Be the first to share your thoughts.',
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: SpaceTokens.sm),
                  itemCount: comments.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: SpaceTokens.md),
                  itemBuilder: (_, i) => _CommentRow(
                    comment: comments[i],
                    canDelete: comments[i].user?.id == myId,
                    onDelete: () => _delete(comments[i]),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.only(top: SpaceTokens.sm),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _submit(),
                    decoration: const InputDecoration(
                      hintText: 'Add a comment…',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: SpaceTokens.sm),
                IconButton.filled(
                  onPressed: _sending ? null : _submit,
                  tooltip: 'Post comment',
                  color: Colors.white,
                  style: IconButton.styleFrom(foregroundColor: Colors.white),
                  icon: _sending
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Icon(Icons.send_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentRow extends StatelessWidget {
  const _CommentRow({
    required this.comment,
    required this.canDelete,
    required this.onDelete,
  });
  final Comment comment;
  final bool canDelete;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final author = comment.user;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppAvatar(
          radius: 18,
          imageUrl: author?.profileImageUrl,
          name: author?.displayName,
        ),
        const SizedBox(width: SpaceTokens.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      author?.displayName ?? 'User',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TypographyTokens.textTheme.labelLarge,
                    ),
                  ),
                  const SizedBox(width: SpaceTokens.sm),
                  Text(
                    RelativeTime.format(comment.createdAt),
                    style: TypographyTokens.caption.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(comment.body,
                  style: TypographyTokens.textTheme.bodyMedium),
            ],
          ),
        ),
        if (canDelete)
          IconButton(
            visualDensity: VisualDensity.compact,
            iconSize: 18,
            tooltip: 'Delete comment',
            onPressed: onDelete,
            icon: Icon(Icons.delete_outline,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
      ],
    );
  }
}
