import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../../../core/utils/a11y.dart';
import '../../../../shared/widgets/loaders/skeleton.dart';
import '../../../../shared/widgets/states/empty_state.dart';
import '../../../../shared/widgets/buttons/app_button.dart';
import '../../data/models/app_notification.dart';
import '../notification_providers.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// NOTIFICATION CENTER SCREEN
/// ─────────────────────────────────────────────────────────────────────────────

class NotificationCenterScreen extends ConsumerStatefulWidget {
  const NotificationCenterScreen({super.key, this.openNotificationId});

  final String? openNotificationId;

  @override
  ConsumerState<NotificationCenterScreen> createState() =>
      _NotificationCenterScreenState();
}

class _NotificationCenterScreenState
    extends ConsumerState<NotificationCenterScreen> {
  final _scrollController = ScrollController();
  final Set<String> _autoOpenedIds = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300) {
        ref.read(notificationsNotifierProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onTap(AppNotification n) {
    Haptics.light();
    if (!n.isRead) {
      ref.read(notificationsNotifierProvider.notifier).markRead(n.id);
    }
    final kind = n.kind;
    if (kind == NotificationKind.warning || kind == NotificationKind.update) {
      _showDetailDialog(context, n);
      return;
    }
    if (n.observationId != null) {
      context.push(AppRoutes.observationDetailPath(n.observationId!));
    } else if (n.speciesId != null) {
      context.push(AppRoutes.speciesDetailPath(n.speciesId!));
    }
  }

  void _showDetailDialog(BuildContext context, AppNotification n) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close Notification Dialog',
      barrierColor: Colors.black.withValues(alpha: 0.55),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim1, anim2, child) {
        final curve = CurvedAnimation(parent: anim1, curve: Curves.easeOutBack);
        return ScaleTransition(
          scale: Tween<double>(begin: 0.92, end: 1.0).animate(curve),
          child: FadeTransition(
            opacity: CurvedAnimation(parent: anim1, curve: Curves.easeOut),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(RadiusTokens.dialog),
              ),
              contentPadding: EdgeInsets.zero,
              content: ClipRRect(
                borderRadius: BorderRadius.circular(RadiusTokens.dialog),
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.85,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).height * 0.55,
                  ),
                  color: Theme.of(context).colorScheme.surface,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.all(SpaceTokens.base),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Theme.of(context).colorScheme.outlineVariant,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(SpaceTokens.xs + 2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: n.kind.color.withValues(alpha: 0.12),
                              ),
                              child: Icon(n.kind.icon, size: 18, color: n.kind.color),
                            ),
                            const SizedBox(width: SpaceTokens.sm),
                            Expanded(
                              child: Text(
                                n.kind == NotificationKind.warning
                                    ? 'System Warning'
                                    : 'Platform Update',
                                style: TypographyTokens.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 20),
                              onPressed: () => Navigator.of(context).pop(),
                              tooltip: 'Close details',
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ),
                      
                      // Message Content
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(SpaceTokens.base),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                n.title,
                                style: TypographyTokens.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: SpaceTokens.md),
                              Text(
                                n.body,
                                style: TypographyTokens.textTheme.bodyMedium?.copyWith(
                                  height: 1.5,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Footer action
                      Padding(
                        padding: const EdgeInsets.all(SpaceTokens.base),
                        child: AppButton(
                          label: 'Close',
                          variant: AppButtonVariant.primary,
                          size: AppButtonSize.medium,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationsNotifierProvider);

    ref.listen<NotificationsState>(notificationsNotifierProvider, (prev, next) {
      if (widget.openNotificationId != null &&
          next.status == NotificationsStatus.success) {
        AppNotification? notif;
        for (final item in next.items) {
          if (item.id == widget.openNotificationId) {
            notif = item;
            break;
          }
        }
        if (notif != null) {
          if (!_autoOpenedIds.contains(widget.openNotificationId)) {
            _autoOpenedIds.add(widget.openNotificationId!);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _onTap(notif!);
            });
          }
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (state.unreadCount > 0)
            TextButton(
              onPressed: () => ref
                  .read(notificationsNotifierProvider.notifier)
                  .markAllRead(),
              child: const Text('Mark all read'),
            ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Notification settings',
            onPressed: () => context.push(AppRoutes.notificationPreferences),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(notificationsNotifierProvider.notifier).refresh(),
        child: _buildBody(state),
      ),
    );
  }

  Widget _buildBody(NotificationsState state) {
    if (state.isInitialLoading) {
      return ListView(
        padding: const EdgeInsets.all(SpaceTokens.base),
        children: List.generate(
          7,
          (_) => const Padding(
            padding: EdgeInsets.symmetric(vertical: SpaceTokens.xs),
            child: ListTileSkeleton(),
          ),
        ),
      );
    }

    if (state.hasError && state.items.isEmpty) {
      return AppEmptyState.error(
        message: state.error,
        onRetry: () =>
            ref.read(notificationsNotifierProvider.notifier).refresh(),
      );
    }

    if (state.isEmpty) {
      return ListView(
        children: [
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.2),
          const AppEmptyState(
            icon: Icons.notifications_none,
            title: "You're all caught up",
            message: 'New notifications will show up here.',
          ),
        ],
      );
    }

    final groups = _group(state.items);
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.only(
        bottom: SpaceTokens.xxl + MediaQuery.viewPaddingOf(context).bottom,
      ),
      itemCount: groups.length + (state.status == NotificationsStatus.loadingMore ? 1 : 0),
      itemBuilder: (context, i) {
        if (i >= groups.length) {
          return const Padding(
            padding: EdgeInsets.all(SpaceTokens.base),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final group = groups[i];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  SpaceTokens.base, SpaceTokens.base, SpaceTokens.base, SpaceTokens.xs),
              child: Text(group.label,
                  style: TypographyTokens.textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  )),
            ),
            ...group.items.map((n) => Dismissible(
                  key: ValueKey(n.id),
                  direction: n.isRead
                      ? DismissDirection.none
                      : DismissDirection.endToStart,
                  // Swipe marks as read but must NOT remove the row:
                  // returning false makes the tile spring back in place
                  // (onDismissed would collapse it out of the list).
                  confirmDismiss: (_) async {
                    unawaited(Haptics.light());
                    unawaited(ref
                        .read(notificationsNotifierProvider.notifier)
                        .markRead(n.id));
                    return false;
                  },
                  background: Container(
                    color: ColorTokens.brandPrimary.withValues(alpha: 0.1),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: SpaceTokens.lg),
                    child: const Icon(Icons.done_all,
                        color: ColorTokens.brandPrimary),
                  ),
                  child: _NotificationTile(notification: n, onTap: () => _onTap(n)),
                )),
          ],
        );
      },
    );
  }

  List<_Group> _group(List<AppNotification> items) {
    final now = DateTime.now();
    final today = <AppNotification>[];
    final week = <AppNotification>[];
    final earlier = <AppNotification>[];
    for (final n in items) {
      final d = n.createdAt;
      if (d == null) {
        earlier.add(n);
        continue;
      }
      final diff = now.difference(d);
      if (diff.inDays == 0 && d.day == now.day) {
        today.add(n);
      } else if (diff.inDays < 7) {
        week.add(n);
      } else {
        earlier.add(n);
      }
    }
    return [
      if (today.isNotEmpty) _Group('Today', today),
      if (week.isNotEmpty) _Group('This week', week),
      if (earlier.isNotEmpty) _Group('Earlier', earlier),
    ];
  }
}

class _Group {
  _Group(this.label, this.items);
  final String label;
  final List<AppNotification> items;
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification, required this.onTap});
  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final kind = notification.kind;
    return InkWell(
      onTap: onTap,
      child: Container(
        color: notification.isRead
            ? null
            : ColorTokens.brandPrimary.withValues(alpha: 0.04),
        padding: const EdgeInsets.symmetric(
            horizontal: SpaceTokens.base, vertical: SpaceTokens.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kind.color.withValues(alpha: 0.15),
              ),
              child: Icon(kind.icon, size: 20, color: kind.color),
            ),
            const SizedBox(width: SpaceTokens.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TypographyTokens.textTheme.titleSmall?.copyWith(
                      fontWeight:
                          notification.isRead ? FontWeight.w500 : FontWeight.w700,
                    ),
                  ),
                  if (notification.body.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      notification.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TypographyTokens.textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    _timeAgo(notification.createdAt),
                    style: TypographyTokens.caption.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (!notification.isRead)
              Container(
                margin: const EdgeInsets.only(top: 6, left: SpaceTokens.sm),
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorTokens.brandPrimary,
                ),
              ),
          ],
        ),
      ),
    );
  }

  static String _timeAgo(DateTime? d) {
    if (d == null) return '';
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${d.day}/${d.month}/${d.year}';
  }
}
