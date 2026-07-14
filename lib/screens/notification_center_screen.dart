import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart';
import '../database/tables.dart';
import '../l10n/app_localizations.dart';
import '../providers/notification_providers.dart';
import '../services/app_error.dart';
import '../theme/app_theme.dart';
import '../widgets/skeletons.dart';
import '../widgets/usage_tracked_screen.dart';
import '../widgets/narrow_layout.dart';
import 'habit_dashboard_screen.dart';
import 'profile_screen.dart';
import 'social/social_hub_screen.dart';

class NotificationCenterScreen extends ConsumerWidget {
  final String userId;

  const NotificationCenterScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notificationsAsync = ref.watch(notificationsForUserProvider(userId));
    final actions = ref.read(notificationActionsProvider);

    return UsageTrackedScreen(
      screenName: 'notification_center',
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.notificationTitle),
          actions: [
            notificationsAsync.maybeWhen(
              data: (items) => TextButton(
                onPressed: items.isEmpty
                    ? null
                    : () => actions.markAllRead(userId),
                child: Text(l10n.notificationMarkAllRead),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        ),
        body: NarrowLayout(
          child: notificationsAsync.when(
            data: (notifications) {
              if (notifications.isEmpty) {
                return HableEmptyStateCard(
                  icon: Icons.notifications_none_rounded,
                  title: l10n.notificationEmptyTitle,
                  description: l10n.notificationEmptyBody,
                );
              }

              final now = DateTime.now();
              final today = <NotificationEvent>[];
              final yesterday = <NotificationEvent>[];
              final older = <NotificationEvent>[];

              for (final n in notifications) {
                final diffDays = now.difference(n.createdAt).inDays;
                if (diffDays == 0 && now.day == n.createdAt.day) {
                  today.add(n);
                } else if (diffDays <= 1) {
                  yesterday.add(n);
                } else {
                  older.add(n);
                }
              }

              final groups = [
                if (today.isNotEmpty) MapEntry(l10n.notificationToday, today),
                if (yesterday.isNotEmpty)
                  MapEntry(l10n.notificationYesterday, yesterday),
                if (older.isNotEmpty) MapEntry(l10n.notificationOlder, older),
              ];

              return CustomScrollView(
                slivers: [
                  for (final group in groups) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                        child: Text(
                          group.key,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: AppTheme.warmGray,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final notification = group.value[index];
                          final isUnread = notification.readAt == null;
                          return Card(
                            elevation: 0,
                            margin: const EdgeInsets.only(bottom: 8),
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
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
                                  '${notification.body}\n${_formatTimestamp(context, notification.createdAt)}',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: AppTheme.warmGray.withValues(
                                          alpha: 0.9,
                                        ),
                                        height: 1.35,
                                      ),
                                ),
                              ),
                              onTap: () async {
                                if (isUnread) {
                                  await actions.markRead(
                                    notification.notificationId,
                                  );
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
                        }, childCount: group.value.length),
                      ),
                    ),
                  ],
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              );
            },
            loading: () => const HableSkeletonList(itemCount: 5),
            error: (error, _) => Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Text(
                AppError.fromAny(
                  error,
                  fallbackCode: 'notification_center_load_failed',
                  fallbackMessage: l10n.notificationLoadFailed,
                  fallbackKind: AppErrorKind.inline,
                ).message,
                textAlign: TextAlign.center,
              ),
            ),
          ),
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
      case 'social_requests':
        // Requests are now inline in the Friends tab (index 0).
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const SocialHubScreen(initialTabIndex: 0),
          ),
        );
        return;
      case 'social_inbox':
        // Messages are now in the Activity tab (index 1).
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const SocialHubScreen(initialTabIndex: 1),
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
      case 'habit_dashboard':
        final payload = notification.actionPayloadJson;
        if (payload != null) {
          try {
            final decoded = jsonDecode(payload);
            final habitId = decoded['habit_id'] as String?;
            if (habitId != null) {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => HabitDashboardScreen(userId: userId),
                ),
              );
            }
          } catch (_) {
            // ignore malformed payload
          }
        }
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

  String _formatTimestamp(BuildContext context, DateTime createdAt) {
    final l10n = AppLocalizations.of(context)!;
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) return l10n.notificationJustNow;
    if (diff.inHours < 1) return l10n.notificationMinutesAgo(diff.inMinutes);
    if (diff.inDays < 1) return l10n.notificationHoursAgo(diff.inHours);
    if (diff.inDays < 7) return l10n.notificationDaysAgo(diff.inDays);
    return MaterialLocalizations.of(context).formatShortDate(createdAt);
  }
}
