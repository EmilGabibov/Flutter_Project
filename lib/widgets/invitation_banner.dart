import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/database_provider.dart';
import '../providers/social_providers.dart';
import '../providers/sync_provider.dart';
import '../theme/app_theme.dart';

class InvitationBanner extends ConsumerWidget {
  const InvitationBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invitationsAsync = ref.watch(pendingInvitationsProvider);
    final friendsAsync = ref.watch(acceptedFriendsProvider);

    return invitationsAsync.when(
      data: (invitations) {
        if (invitations.isEmpty) return const SizedBox.shrink();
        
        final friends = friendsAsync.value ?? [];

        return Column(
          children: invitations.map((inv) {
            String displayUsername = inv.requesterId.length > 8 ? inv.requesterId.substring(0, 8) : inv.requesterId;
            final match = friends.where((f) => f.friendUserId == inv.requesterId);
            if (match.isNotEmpty) {
              displayUsername = match.first.username;
            }

            return Container(
              margin: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.sageGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.sageGreen.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.sageGreen.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.group_add_rounded,
                      color: AppTheme.sageGreen,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'New Habit Partner Request',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$displayUsername wants to partner up!',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {
                          final db = ref.read(databaseProvider);
                          await enqueueDeclineInvitation(
                            db: db,
                            invitationId: inv.invitationId,
                          );
                          final sync = ref.read(syncServiceProvider);
                          await sync.flushPending();
                          final userId = ref.read(authProvider).userId;
                          if (userId != null) {
                            await sync.pullDailySync(userId);
                          }
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          color: AppTheme.warmGray,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final db = ref.read(databaseProvider);
                          await enqueueAcceptInvitation(
                            db: db,
                            invitationId: inv.invitationId,
                          );
                          final sync = ref.read(syncServiceProvider);
                          await sync.flushPending();
                          final userId = ref.read(authProvider).userId;
                          if (userId != null) {
                            await sync.pullDailySync(userId);
                          }
                        },
                        icon: const Icon(
                          Icons.check_rounded,
                          color: AppTheme.sageGreen,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: AppTheme.sageGreen.withValues(
                            alpha: 0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
