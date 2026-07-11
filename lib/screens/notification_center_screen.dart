import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart';
import '../database/tables.dart';
import '../providers/notification_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/usage_tracked_screen.dart';
import 'profile_screen.dart';
import 'social/social_hub_screen.dart';

class NotificationCenterScreen extends ConsumerWidget {
  final String userId;

  const NotificationCenterScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsForUserProvider(userId));
    final actions = ref.read(notificationActionsProvider);

    return UsageTrackedScreen(
      screenName: 'notification_center',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          actions: [
            notificationsAsync.maybeWhen(
              data: (items) => TextButton(
                onPressed: items.isEmpty
                    ? null
                    : () => actions.markAllRead(userId),
                child: const Text('Mark all read'),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        ),
        body: notificationsAsync.when(
          data: (notifications) {
            if (notifications.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.notifications_none_rounded,
                        size: 48,
                        color: AppTheme.warmGray.withValues(alpha: 0.7),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No notifications yet',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Friend requests, invites, nudges, and reminder updates will appear here.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.warmGray.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemCount: notifications.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                final isUnread = notification.readAt == null;
                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isUnread
                          ? AppTheme.sageGreen.withValues(alpha: 0.28)
                          : AppTheme.warmGray.withValues(alpha: 0.12),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: _iconTint(
                        notification.type,
                      ).withValues(alpha: 0.14),
                      child: Icon(
                        _iconForType(notification.type),
                        color: _iconTint(notification.type),
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  fontWeight: isUnread
                                      ? FontWeight.w800
                                      : FontWeight.w700,
                                ),
                          ),
                        ),
                        if (isUnread)
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: AppTheme.sageGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        '${notification.body}\n${_formatTimestamp(notification.createdAt)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.warmGray.withValues(alpha: 0.9),
                          height: 1.35,
                        ),
                      ),
                    ),
                    onTap: () async {
                      if (isUnread) {
                        await actions.markRead(notification.notificationId);
                      }
                      if (!context.mounted) return;
                      await _openNotificationAction(
                        context,
                        notification,
                        userId,
                      );
                    },
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  Future<void> _openNotificationAction(
    BuildContext context,
    NotificationEvent notification,
    String userId,
  ) async {
    switch (notification.actionRoute) {
      case 'social_friends':
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const SocialHubScreen(initialTabIndex: 0),
          ),
        );
        return;
      case 'social_requests':
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const SocialHubScreen(initialTabIndex: 1),
          ),
        );
        return;
      case 'social_inbox':
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const SocialHubScreen(initialTabIndex: 4),
          ),
        );
        return;
      case 'profile':
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProfileScreen(userId: userId, showBackButton: true),
          ),
        );
        return;
      case 'home':
        await Navigator.of(context).maybePop();
        return;
      default:
        return;
    }
  }

  IconData _iconForType(NotificationEventType type) {
    switch (type) {
      case NotificationEventType.nudge:
        return Icons.back_hand_rounded;
      case NotificationEventType.privateMessage:
        return Icons.mail_rounded;
      case NotificationEventType.habitInvitation:
        return Icons.group_add_rounded;
      case NotificationEventType.friendRequest:
        return Icons.person_add_alt_1_rounded;
      case NotificationEventType.friendAccepted:
        return Icons.favorite_rounded;
      case NotificationEventType.reminderSetting:
        return Icons.alarm_rounded;
    }
  }

  Color _iconTint(NotificationEventType type) {
    switch (type) {
      case NotificationEventType.nudge:
        return AppTheme.sageGreen;
      case NotificationEventType.privateMessage:
        return AppTheme.deepCharcoal;
      case NotificationEventType.habitInvitation:
        return AppTheme.skipAmber;
      case NotificationEventType.friendRequest:
        return AppTheme.sageGreen;
      case NotificationEventType.friendAccepted:
        return AppTheme.completionGreen;
      case NotificationEventType.reminderSetting:
        return AppTheme.deepCharcoal;
    }
  }

  String _formatTimestamp(DateTime createdAt) {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    final month = createdAt.month.toString().padLeft(2, '0');
    final day = createdAt.day.toString().padLeft(2, '0');
    return '$month/$day/${createdAt.year}';
  }
}
