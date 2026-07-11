import 'dart:convert';
import 'dart:async';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../config/api_config.dart';
import '../../database/database.dart';
import '../../database/tables.dart';
import '../../providers/auth_provider.dart';
import '../../providers/database_provider.dart';
import '../../providers/notification_providers.dart';
import '../../providers/social_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/3d/habit_environment_visualizer.dart';
import '../../widgets/user_avatar.dart';
import '../../widgets/leaderboard_card.dart';
import '../../widgets/skeletons.dart';
import '../../widgets/usage_tracked_screen.dart';
import '../profile_screen.dart';

// ---------------------------------------------------------------------------
// Providers (unchanged — kept at file top per project convention)
// ---------------------------------------------------------------------------

final leaderboardProvider = FutureProvider.autoDispose<List<dynamic>>((
  ref,
) async {
  final auth = ref.watch(authProvider);
  if (auth.token == null) return [];

  final response = await http
      .get(
        Uri.parse('$apiBaseUrl/api/social/leaderboard'),
        headers: {'Authorization': 'Bearer ${auth.token}'},
      )
      .timeout(const Duration(seconds: 10));

  if (response.statusCode == 200) {
    final contentType = response.headers['content-type'] ?? '';
    if (!contentType.toLowerCase().contains('application/json')) {
      throw Exception(
        'Leaderboard endpoint returned ${contentType.isEmpty ? 'non-JSON' : contentType} content.',
      );
    }
    final data = jsonDecode(response.body);
    return data['leaderboard'] ?? [];
  }
  throw Exception('Failed to fetch leaderboard');
});

final userSearchProvider = FutureProvider.family
    .autoDispose<List<dynamic>, String>((ref, query) async {
      if (query.length < 2) return [];

      final auth = ref.watch(authProvider);
      if (auth.token == null) return [];

      final uri = Uri.parse(
        '$apiBaseUrl/api/social/search',
      ).replace(queryParameters: {'q': query});
      final response = await http
          .get(uri, headers: {'Authorization': 'Bearer ${auth.token}'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'] ?? '';
        if (!contentType.toLowerCase().contains('application/json')) {
          throw Exception(
            'Search endpoint returned ${contentType.isEmpty ? 'non-JSON' : contentType} content.',
          );
        }
        final data = jsonDecode(response.body);
        final results = data['results'] ?? [];
        final db = ref.read(databaseProvider);
        for (final user in results) {
          if (user is! Map) continue;
          final userId = (user['user_id'] ?? user['id'])?.toString() ?? '';
          final username = user['username']?.toString() ?? '';
          if (userId.isEmpty || username.isEmpty) continue;
          await db.cacheFriendRelationship(
            userId: userId,
            username: username,
            avatarUrl: user['avatar_url']?.toString(),
            relationshipState: user['relationship_state']?.toString() ?? 'none',
          );
        }
        return results;
      }
      throw Exception('Failed to search users: ${response.body}');
    });

final pendingFriendRequestsProvider = FutureProvider.autoDispose<List<dynamic>>(
  (ref) async {
    final auth = ref.watch(authProvider);
    if (auth.token == null) return [];

    final response = await http
        .get(
          Uri.parse('$apiBaseUrl/api/social/friend-request'),
          headers: {'Authorization': 'Bearer ${auth.token}'},
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final requests = data['friend_requests'] ?? [];
      final db = ref.read(databaseProvider);
      await db.clearPendingIncomingFriendRelationships();
      for (final request in requests) {
        if (request is! Map) continue;
        final requesterId = request['requester_id']?.toString() ?? '';
        final username = request['requester_username']?.toString() ?? '';
        if (requesterId.isEmpty || username.isEmpty) continue;
        await db.cacheFriendRelationship(
          userId: requesterId,
          username: username,
          avatarUrl: request['requester_avatar']?.toString(),
          relationshipState: 'pending_incoming',
          requestId: request['id']?.toString(),
        );
      }
      return requests;
    }
    throw Exception('Failed to fetch friend requests');
  },
);

// ---------------------------------------------------------------------------
// UI — Three-tab Social screen: Friends, Activity, Leaderboard
// ---------------------------------------------------------------------------

class SocialHubScreen extends ConsumerStatefulWidget {
  final int initialTabIndex;

  const SocialHubScreen({super.key, this.initialTabIndex = 0});

  @override
  SocialHubScreenState createState() => SocialHubScreenState();
}

class SocialHubScreenState extends ConsumerState<SocialHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  /// Public method for the navigation shell to switch to a specific sub-tab
  /// (e.g., Activity when the Home bell icon is tapped).
  void switchToTab(int index) {
    if (mounted && index >= 0 && index < 3) {
      _tabController.animateTo(index);
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTabIndex.clamp(0, 2),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Friend request network actions
  // ---------------------------------------------------------------------------

  Future<void> _sendFriendRequest(
    String targetUserId,
    String username, {
    String? avatarUrl,
  }) async {
    final auth = ref.read(authProvider);
    if (auth.token == null) return;

    try {
      final response = await http
          .post(
            Uri.parse('$apiBaseUrl/api/social/friend-request'),
            headers: {
              'Authorization': 'Bearer ${auth.token}',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'target_user_id': targetUserId}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final relationshipState =
            data['relationship_state']?.toString() ?? 'pending_outgoing';
        final db = ref.read(databaseProvider);
        await db.cacheFriendRelationship(
          userId: targetUserId,
          username: username,
          avatarUrl: avatarUrl,
          relationshipState: relationshipState,
          requestId: data['request_id']?.toString(),
        );
        ref.invalidate(pendingFriendRequestsProvider);

        if (mounted) {
          final message = switch (relationshipState) {
            'accepted' => 'You are already friends with $username.',
            'pending_incoming' =>
              '$username already sent you a request. Check Requests.',
            _ => 'Friend request sent to $username.',
          };
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        }
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to send request: $e')));
      }
    }
  }

  Future<void> _acceptFriendRequest({
    required String requestId,
    required String requesterId,
    required String username,
    String? avatarUrl,
  }) async {
    final auth = ref.read(authProvider);
    if (auth.token == null) return;
    final messenger = ScaffoldMessenger.maybeOf(context);

    try {
      final response = await http
          .post(
            Uri.parse('$apiBaseUrl/api/social/friend-request/accept'),
            headers: {
              'Authorization': 'Bearer ${auth.token}',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'request_id': requestId}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        if (mounted) {
          final db = ref.read(databaseProvider);
          await db.upsertAcceptedFriend(
            AcceptedFriendsCompanion(
              friendUserId: Value(requesterId),
              username: Value(username),
              avatarUrl: Value(avatarUrl),
              updatedAt: Value(DateTime.now()),
              isSynced: const Value(true),
            ),
          );
          await db.cacheFriendRelationship(
            userId: requesterId,
            username: username,
            avatarUrl: avatarUrl,
            relationshipState: 'accepted',
          );

          messenger?.showSnackBar(
            SnackBar(content: Text('You are now friends with $username!')),
          );
          ref.invalidate(pendingFriendRequestsProvider);
        }
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to accept request: $e')));
      }
    }
  }

  Future<void> _declineFriendRequest({
    required String requestId,
    required String requesterId,
    required String username,
    String? avatarUrl,
  }) async {
    final auth = ref.read(authProvider);
    if (auth.token == null) return;

    try {
      final response = await http
          .post(
            Uri.parse('$apiBaseUrl/api/social/friend-request/decline'),
            headers: {
              'Authorization': 'Bearer ${auth.token}',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'request_id': requestId}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final db = ref.read(databaseProvider);
        await db.cacheFriendRelationship(
          userId: requesterId,
          username: username,
          avatarUrl: avatarUrl,
          relationshipState: 'none',
        );
        ref.invalidate(pendingFriendRequestsProvider);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Declined request from $username.')),
          );
        }
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to decline request: $e')),
        );
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return UsageTrackedScreen(
      screenName: 'social_hub',
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Lightweight header (no AppBar to avoid double-header in shell).
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Row(
                  children: [
                    Text(
                      'Social',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const Spacer(),
                    Semantics(
                      label: 'Find friends',
                      button: true,
                      child: IconButton(
                        tooltip: 'Find friends',
                        icon: const Icon(Icons.person_search_rounded),
                        onPressed: () => _showFindFriendsSheet(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(icon: Icon(Icons.favorite_rounded), text: 'Friends'),
                  Tab(
                    icon: Icon(Icons.notifications_rounded),
                    text: 'Activity',
                  ),
                  Tab(
                    icon: Icon(Icons.leaderboard_rounded),
                    text: 'Leaderboard',
                  ),
                ],
                labelColor: AppTheme.sageGreen,
                indicatorColor: AppTheme.sageGreen,
              ),
              const HabitEnvironmentVisualizer(height: 250),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildFriendsTab(),
                    _buildActivityTab(),
                    _buildLeaderboardTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Tab 1: Friends (merged Friends + inline Requests)
  // ---------------------------------------------------------------------------

  Widget _buildFriendsTab() {
    final friendsAsync = ref.watch(acceptedFriendsProvider);
    final cachedRequestsAsync = ref.watch(
      pendingIncomingFriendRelationshipsProvider,
    );
    // Kick off network refresh of requests.
    ref.watch(pendingFriendRequestsProvider);

    return CustomScrollView(
      slivers: [
        // Inline pending requests section (only when there are requests).
        cachedRequestsAsync.when(
          data: (requests) {
            if (requests.isEmpty) return const SliverToBoxAdapter();
            return SliverToBoxAdapter(
              child: _PendingRequestsSection(
                requests: requests,
                onAccept: _acceptFriendRequest,
                onDecline: _declineFriendRequest,
              ),
            );
          },
          loading: () => const SliverToBoxAdapter(),
          error: (_, _) => const SliverToBoxAdapter(),
        ),

        // Accepted friends list.
        friendsAsync.when(
          data: (friends) {
            if (friends.isEmpty) {
              return SliverFillRemaining(
                child: HableEmptyStateCard(
                  icon: Icons.favorite_border_rounded,
                  title: 'No friends yet',
                  description:
                      'Tap the search icon above to find and add friends.',
                ),
              );
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final friend = friends[index];
                  return Card(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: ListTile(
                      leading: UserAvatar(
                        avatarUrl: friend.avatarUrl,
                        username: friend.username,
                        radius: 20,
                      ),
                      title: Text(
                        friend.username,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right_rounded,
                        color: AppTheme.warmGray,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProfileScreen(
                              userId: friend.friendUserId,
                              showBackButton: true,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                childCount: friends.length,
              ),
            );
          },
          loading: () => const SliverFillRemaining(
            child: HableSkeletonList(itemCount: 4),
          ),
          error: (e, _) => SliverFillRemaining(
            child: Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Tab 2: Activity (unified notifications + messages)
  // ---------------------------------------------------------------------------

  Widget _buildActivityTab() {
    final userId = ref.watch(authProvider.select((a) => a.userId));
    if (userId == null) {
      return const Center(child: Text('Not signed in'));
    }

    final notificationsAsync = ref.watch(notificationsForUserProvider(userId));
    final actions = ref.read(notificationActionsProvider);

    return notificationsAsync.when(
      data: (notifications) {
        if (notifications.isEmpty) {
          return const HableEmptyStateCard(
            icon: Icons.notifications_none_rounded,
            title: 'No activity yet',
            description:
                'Nudges, friend requests, invites, and messages from friends will appear here.',
          );
        }
        return Column(
          children: [
            // "Mark all read" action bar.
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: notifications
                            .any((n) => n.readAt == null)
                        ? () => actions.markAllRead(userId)
                        : null,
                    child: const Text('Mark all read'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                itemCount: notifications.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return _ActivityCard(
                    notification: notification,
                    onTap: () async {
                      if (notification.readAt == null) {
                        await actions.markRead(notification.notificationId);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const HableSkeletonList(itemCount: 4),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  // ---------------------------------------------------------------------------
  // Tab 3: Leaderboard (unchanged)
  // ---------------------------------------------------------------------------

  Widget _buildLeaderboardTab() {
    final leaderboardAsync = ref.watch(leaderboardProvider);
    final currentUserId = ref.watch(authProvider.select((auth) => auth.userId));

    return leaderboardAsync.when(
      data: (users) {
        if (users.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => ref.refresh(leaderboardProvider.future),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 120),
                Center(child: Text('No leaderboard scores yet.')),
              ],
            ),
          );
        }

        final rankings = <LeaderboardEntry>[];
        for (var i = 0; i < users.length; i++) {
          final user = users[i];
          if (user is Map<String, dynamic>) {
            rankings.add(LeaderboardEntry.fromJson(user, i + 1));
          } else if (user is Map) {
            rankings.add(
              LeaderboardEntry.fromJson(Map<String, dynamic>.from(user), i + 1),
            );
          }
        }

        if (rankings.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => ref.refresh(leaderboardProvider.future),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 120),
                Center(child: Text('No valid leaderboard scores found.')),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => ref.refresh(leaderboardProvider.future),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              LeaderboardCard(
                title: 'Friends Leaderboard',
                subtitle: 'You and accepted friends only',
                scopeLabel: 'Friends',
                rankings: rankings,
                currentUserId: currentUserId,
              ),
            ],
          ),
        );
      },
      loading: () => const HableSkeletonList(
        itemCount: 3,
        itemHeight: 116,
        padding: EdgeInsets.all(16),
      ),
      error: (e, st) => RefreshIndicator(
        onRefresh: () => ref.refresh(leaderboardProvider.future),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.overdueRose.withValues(alpha: 0.24),
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: AppTheme.overdueRose,
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Could not load leaderboard',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppTheme.deepCharcoal,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$e',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppTheme.warmGray),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Find Friends bottom sheet
  // ---------------------------------------------------------------------------

  void _showFindFriendsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _FindFriendsSheet(
        onSendRequest: _sendFriendRequest,
      ),
    );
  }
}

// =============================================================================
// Private Widgets
// =============================================================================

/// Inline section showing pending incoming friend requests at the top of the
/// Friends tab. Only rendered when there are pending requests.
class _PendingRequestsSection extends StatelessWidget {
  final List<FriendRelationship> requests;
  final Future<void> Function({
    required String requestId,
    required String requesterId,
    required String username,
    String? avatarUrl,
  }) onAccept;
  final Future<void> Function({
    required String requestId,
    required String requesterId,
    required String username,
    String? avatarUrl,
  }) onDecline;

  const _PendingRequestsSection({
    required this.requests,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'Friend Requests',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppTheme.sageGreen,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ...requests.map((req) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: UserAvatar(
                    avatarUrl: req.avatarUrl,
                    username: req.username,
                    radius: 20,
                  ),
                  title: Text(
                    req.username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('Sent you a friend request'),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      OutlinedButton(
                        onPressed: req.requestId == null
                            ? null
                            : () => onDecline(
                                requestId: req.requestId!,
                                requesterId: req.userId,
                                username: req.username,
                                avatarUrl: req.avatarUrl,
                              ),
                        child: const Text('Decline'),
                      ),
                      ElevatedButton(
                        onPressed: req.requestId == null
                            ? null
                            : () => onAccept(
                                requestId: req.requestId!,
                                requesterId: req.userId,
                                username: req.username,
                                avatarUrl: req.avatarUrl,
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.sageGreen,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Accept'),
                      ),
                    ],
                  ),
                ),
              )),
          const Divider(),
        ],
      ),
    );
  }
}

/// A single notification/activity card in the Activity tab.
class _ActivityCard extends StatelessWidget {
  final NotificationEvent notification;
  final VoidCallback onTap;

  const _ActivityCard({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: _iconTint(notification.type).withValues(alpha: 0.14),
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
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: isUnread ? FontWeight.w800 : FontWeight.w700,
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
        onTap: onTap,
      ),
    );
  }

  static IconData _iconForType(NotificationEventType type) {
    return switch (type) {
      NotificationEventType.nudge => Icons.back_hand_rounded,
      NotificationEventType.privateMessage => Icons.mail_rounded,
      NotificationEventType.habitInvitation => Icons.group_add_rounded,
      NotificationEventType.friendRequest => Icons.person_add_alt_1_rounded,
      NotificationEventType.friendAccepted => Icons.favorite_rounded,
      NotificationEventType.reminderSetting => Icons.alarm_rounded,
    };
  }

  static Color _iconTint(NotificationEventType type) {
    return switch (type) {
      NotificationEventType.nudge => AppTheme.sageGreen,
      NotificationEventType.privateMessage => AppTheme.deepCharcoal,
      NotificationEventType.habitInvitation => AppTheme.skipAmber,
      NotificationEventType.friendRequest => AppTheme.sageGreen,
      NotificationEventType.friendAccepted => AppTheme.completionGreen,
      NotificationEventType.reminderSetting => AppTheme.deepCharcoal,
    };
  }

  static String _formatTimestamp(DateTime createdAt) {
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

/// Bottom sheet for finding and adding new friends.
class _FindFriendsSheet extends ConsumerStatefulWidget {
  final Future<void> Function(String userId, String username, {String? avatarUrl})
      onSendRequest;

  const _FindFriendsSheet({required this.onSendRequest});

  @override
  ConsumerState<_FindFriendsSheet> createState() => _FindFriendsSheetState();
}

class _FindFriendsSheetState extends ConsumerState<_FindFriendsSheet> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.warmGray.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Find Friends',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Search username...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.trim();
                  });
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _searchQuery.length < 2
                    ? const Center(
                        child: Text('Type at least 2 characters to search.'),
                      )
                    : Consumer(
                        builder: (context, ref, _) {
                          final searchAsync = ref.watch(
                            userSearchProvider(_searchQuery),
                          );
                          return searchAsync.when(
                            data: (results) {
                              if (results.isEmpty) {
                                return const Center(
                                  child: Text('No matches found.'),
                                );
                              }
                              return ListView.builder(
                                controller: scrollController,
                                itemCount: results.length,
                                itemBuilder: (context, index) {
                                  final user = results[index];
                                  return _SearchResultTile(
                                    user: user,
                                    onSendRequest: widget.onSendRequest,
                                  );
                                },
                              );
                            },
                            loading: () => const HableSkeletonList(
                              itemCount: 4,
                              padding: EdgeInsets.zero,
                            ),
                            error: (e, _) =>
                                Center(child: Text('Error: $e')),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// A single search result tile in the Find Friends sheet.
class _SearchResultTile extends StatelessWidget {
  final dynamic user;
  final Future<void> Function(String userId, String username, {String? avatarUrl})
      onSendRequest;

  const _SearchResultTile({required this.user, required this.onSendRequest});

  @override
  Widget build(BuildContext context) {
    final userId = (user['user_id'] ?? user['id'])?.toString() ?? '';
    final username = user['username']?.toString() ?? 'Friend';
    final avatarUrl = user['avatar_url']?.toString();
    final state = user['relationship_state']?.toString() ?? 'none';

    return ListTile(
      leading: UserAvatar(
        avatarUrl: avatarUrl,
        username: username,
        radius: 20,
      ),
      title: Text(username),
      subtitle: Text(
        switch (state) {
          'accepted' => 'Accepted friend',
          'pending_outgoing' => 'Request sent',
          'pending_incoming' => 'Waiting for your response',
          _ => 'Not connected',
        },
      ),
      trailing: switch (state) {
        'accepted' => const Chip(
            avatar: Icon(Icons.check_rounded, size: 16),
            label: Text('Friends'),
          ),
        'pending_outgoing' => const Chip(label: Text('Requested')),
        'pending_incoming' => const Chip(label: Text('Respond in Friends')),
        _ => IconButton(
            tooltip: 'Send friend request',
            icon: const Icon(
              Icons.person_add_rounded,
              color: AppTheme.sageGreen,
            ),
            onPressed: userId.isEmpty
                ? null
                : () => onSendRequest(userId, username, avatarUrl: avatarUrl),
          ),
      },
    );
  }
}
