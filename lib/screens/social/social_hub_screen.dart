import 'dart:convert';
import 'dart:async';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:hable/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../config/api_config.dart';
import '../../database/database.dart';
import '../../database/tables.dart';
import '../../providers/auth_provider.dart';
import '../../providers/database_provider.dart';
import '../../providers/notification_providers.dart';
import '../../providers/social_providers.dart';
import '../../providers/sync_provider.dart';
import '../../services/app_error.dart';
import '../../theme/app_theme.dart';
import '../../widgets/narrow_layout.dart';
import '../../widgets/3d/habit_environment_visualizer.dart';
import '../../widgets/user_avatar.dart';
import '../../widgets/leaderboard_card.dart';
import '../../widgets/skeletons.dart';
import '../../widgets/usage_tracked_screen.dart';
import '../main_navigation_shell.dart';
import '../profile_screen.dart';

class ActivitySection {
  const ActivitySection({required this.title, required this.items});

  final String title;
  final List<NotificationEvent> items;
}

List<ActivitySection> buildActivitySections(
  List<NotificationEvent> notifications,
  AppLocalizations loc, {
  DateTime? now,
}) {
  final reference = now ?? DateTime.now();
  final startOfToday = DateTime(reference.year, reference.month, reference.day);

  final unread = notifications
      .where((notification) => notification.readAt == null)
      .toList();
  final read = notifications
      .where((notification) => notification.readAt != null)
      .toList();
  final todayRead = read
      .where((notification) => notification.createdAt.isAfter(startOfToday))
      .toList();
  final earlier = read
      .where((notification) => !notification.createdAt.isAfter(startOfToday))
      .toList();

  final sections = <ActivitySection>[];
  if (unread.isNotEmpty) {
    sections.add(
      ActivitySection(title: loc.socialActivityUnread, items: unread),
    );
  }
  if (todayRead.isNotEmpty) {
    sections.add(
      ActivitySection(title: loc.notificationToday, items: todayRead),
    );
  }
  if (earlier.isNotEmpty) {
    sections.add(
      ActivitySection(title: loc.socialActivityEarlier, items: earlier),
    );
  }
  return sections;
}

// ---------------------------------------------------------------------------
// Providers (unchanged — kept at file top per project convention)
// ---------------------------------------------------------------------------

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
      throw Exception('social_search_failed');
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
    throw Exception('social_requests_fetch_failed');
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
    if (auth.userId == targetUserId) return; // Defensive self-guard

    try {
      final loc = AppLocalizations.of(context)!;
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
            'accepted' => loc.socialFriendRequestAlreadyFriends(username),
            'pending_incoming' => loc.socialFriendRequestIncomingExists(
              username,
            ),
            _ => loc.socialFriendRequestSent(username),
          };
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        }
      } else {
        throw AppException(
          AppError.fromResponse(
            response,
            fallbackCode: 'friend_request_send_failed',
            fallbackMessage: loc.socialFriendRequestSendFailed,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final loc = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppError.fromAny(
                e,
                fallbackCode: 'friend_request_send_failed',
                fallbackMessage: loc.socialFriendRequestSendFailed,
              ).message,
            ),
          ),
        );
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
    final loc = AppLocalizations.of(context)!;

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
            SnackBar(content: Text(loc.socialFriendAccepted(username))),
          );
          ref.invalidate(pendingFriendRequestsProvider);
        }
      } else {
        throw AppException(
          AppError.fromResponse(
            response,
            fallbackCode: 'friend_request_accept_failed',
            fallbackMessage: loc.socialFriendRequestAcceptFailed,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppError.fromAny(
                e,
                fallbackCode: 'friend_request_accept_failed',
                fallbackMessage: loc.socialFriendRequestAcceptFailed,
              ).message,
            ),
          ),
        );
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
    final loc = AppLocalizations.of(context)!;

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
            SnackBar(content: Text(loc.socialFriendDeclined(username))),
          );
        }
      } else {
        throw AppException(
          AppError.fromResponse(
            response,
            fallbackCode: 'friend_request_decline_failed',
            fallbackMessage: loc.socialFriendRequestDeclineFailed,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppError.fromAny(
                e,
                fallbackCode: 'friend_request_decline_failed',
                fallbackMessage: loc.socialFriendRequestDeclineFailed,
              ).message,
            ),
          ),
        );
      }
    }
  }

  Future<void> _revokeFriendship({
    required String friendUserId,
    required String username,
    String? avatarUrl,
  }) async {
    final auth = ref.read(authProvider);
    if (auth.token == null) return;
    final loc = AppLocalizations.of(context)!;

    try {
      final response = await http
          .post(
            Uri.parse('$apiBaseUrl/api/social/friend-request/revoke'),
            headers: {
              'Authorization': 'Bearer ${auth.token}',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'target_user_id': friendUserId}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final db = ref.read(databaseProvider);
        await db.removeAcceptedFriend(friendUserId);
        await db.cacheFriendRelationship(
          userId: friendUserId,
          username: username,
          avatarUrl: avatarUrl,
          relationshipState: 'none',
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loc.socialFriendRemoved(username))),
          );
        }
      } else {
        throw AppException(
          AppError.fromResponse(
            response,
            fallbackCode: 'friend_revoke_failed',
            fallbackMessage: loc.socialFriendRevokeFailed,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppError.fromAny(
                e,
                fallbackCode: 'friend_revoke_failed',
                fallbackMessage: loc.socialFriendRevokeFailed,
              ).message,
            ),
          ),
        );
      }
    }
  }

  Future<void> _showFriendActionsMenu({
    required BuildContext context,
    required AcceptedFriend friend,
    required Offset position,
  }) async {
    final loc = AppLocalizations.of(context)!;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final action = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(position.dx, position.dy, 0, 0),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem<String>(
          value: 'unfriend',
          child: Text(loc.socialFriendActionsUnfriend),
        ),
      ],
    );

    if (!context.mounted || action != 'unfriend') return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(loc.socialFriendActionsRemoveTitle),
        content: Text(loc.socialFriendActionsRemoveBody(friend.username)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(loc.settingsCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(loc.commonRemove),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _revokeFriendship(
        friendUserId: friend.friendUserId,
        username: friend.username,
        avatarUrl: friend.avatarUrl,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final isSyncing = ref.watch(foregroundSyncControllerProvider);
    final userId = ref.watch(authProvider).userId ?? '';
    final loc = AppLocalizations.of(context)!;

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
                      loc.socialTabTitle,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const Spacer(),
                    if (isSyncing)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    else
                      IconButton(
                        icon: const Icon(Icons.sync_rounded),
                        tooltip: loc.socialSyncNow,
                        onPressed: () {
                          ref
                              .read(foregroundSyncControllerProvider.notifier)
                              .syncNow(userId);
                        },
                      ),
                    Semantics(
                      label: loc.socialFindFriends,
                      button: true,
                      child: IconButton(
                        tooltip: loc.socialFindFriends,
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
                tabs: [
                  Tab(
                    icon: const Icon(Icons.favorite_rounded),
                    text: loc.friendsTabTitle,
                  ),
                  Tab(
                    icon: const Icon(Icons.notifications_rounded),
                    text: loc.activityTabTitle,
                  ),
                  Tab(
                    icon: const Icon(Icons.leaderboard_rounded),
                    text: loc.leaderboardTabTitle,
                  ),
                ],
                labelColor: AppTheme.sageGreen,
                indicatorColor: AppTheme.sageGreen,
              ),
              Expanded(
                child: NarrowLayout(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildFriendsTab(),
                      _buildActivityTab(),
                      _buildLeaderboardTab(),
                    ],
                  ),
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
    final loc = AppLocalizations.of(context)!;
    final friendsAsync = ref.watch(acceptedFriendsProvider);
    final cachedRequestsAsync = ref.watch(
      pendingIncomingFriendRelationshipsProvider,
    );
    // Kick off network refresh of requests.
    ref.watch(pendingFriendRequestsProvider);

    return CustomScrollView(
      slivers: [
        // 3D Environment Visualizer pinned to Friends tab
        const SliverToBoxAdapter(
          child: HabitEnvironmentVisualizer(height: 250),
        ),
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
                  title: loc.socialNoFriendsTitle,
                  description: loc.socialNoFriendsBody,
                ),
              );
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final friend = friends[index];
                return Card(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onLongPressStart: (details) => _showFriendActionsMenu(
                      context: context,
                      friend: friend,
                      position: details.globalPosition,
                    ),
                    onSecondaryTapDown: (details) => _showFriendActionsMenu(
                      context: context,
                      friend: friend,
                      position: details.globalPosition,
                    ),
                    child: InkWell(
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
                      borderRadius: BorderRadius.circular(16),
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
                        subtitle: Text(loc.socialFriendLongPressActions),
                        trailing: const Icon(
                          Icons.chevron_right_rounded,
                          color: AppTheme.warmGray,
                        ),
                      ),
                    ),
                  ),
                );
              }, childCount: friends.length),
            );
          },
          loading: () =>
              const SliverFillRemaining(child: HableSkeletonList(itemCount: 4)),
          error: (e, _) => SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Text(
                AppError.fromAny(
                  e,
                  fallbackCode: 'friends_load_failed',
                  fallbackMessage: loc.socialFriendsLoadFailed,
                  fallbackKind: AppErrorKind.inline,
                ).message,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Tab 2: Activity (unified notifications + messages)
  // ---------------------------------------------------------------------------

  Widget _buildActivityTab() {
    final loc = AppLocalizations.of(context)!;
    final userId = ref.watch(authProvider.select((a) => a.userId));
    if (userId == null) {
      return Padding(
        padding: EdgeInsets.only(top: 32.0),
        child: Text(loc.socialNotSignedIn, textAlign: TextAlign.center),
      );
    }

    final notificationsAsync = ref.watch(notificationsForUserProvider(userId));
    final actions = ref.read(notificationActionsProvider);

    return notificationsAsync.when(
      data: (notifications) {
        if (notifications.isEmpty) {
          return HableEmptyStateCard(
            icon: Icons.notifications_none_rounded,
            title: loc.socialNoActivityTitle,
            description: loc.socialNoActivityBody,
          );
        }
        final sections = buildActivitySections(notifications, loc);
        final flattenedSections = _flattenActivitySections(sections);
        return Column(
          children: [
            // "Mark all read" action bar.
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: notifications.any((n) => n.readAt == null)
                        ? () => actions.markAllRead(userId)
                        : null,
                    child: Text(loc.notificationMarkAllRead),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                itemCount: flattenedSections.length,
                separatorBuilder: (_, _) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final entry = flattenedSections[index];
                  final sectionTitle = entry.sectionTitle;
                  if (sectionTitle != null) {
                    return _ActivitySectionHeader(title: sectionTitle);
                  }
                  final notification = entry.notification;
                  if (notification == null) {
                    return const SizedBox.shrink();
                  }
                  return _ActivityCard(
                    notification: notification,
                    onTap: () async {
                      if (notification.readAt == null) {
                        await actions.markRead(notification.notificationId);
                      }
                      _openNotificationTarget(notification);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const HableSkeletonList(itemCount: 4),
      error: (e, _) => Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: Text(
          AppError.fromAny(
            e,
            fallbackCode: 'activity_load_failed',
            fallbackMessage: loc.notificationLoadFailed,
            fallbackKind: AppErrorKind.inline,
          ).message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  List<_ActivityListEntry> _flattenActivitySections(
    List<ActivitySection> sections,
  ) {
    final entries = <_ActivityListEntry>[];
    for (final section in sections) {
      entries.add(_ActivityListEntry.section(section.title));
      for (final notification in section.items) {
        entries.add(_ActivityListEntry.notification(notification));
      }
    }
    return entries;
  }

  void _openNotificationTarget(NotificationEvent notification) {
    final shell = context.findAncestorStateOfType<MainNavigationShellState>();
    if (shell == null) return;
    shell.handleNotificationRoute(
      actionRoute: notification.actionRoute,
      actionPayloadJson: notification.actionPayloadJson,
    );
  }

  // ---------------------------------------------------------------------------
  // Tab 3: Leaderboard (unchanged)
  // ---------------------------------------------------------------------------

  Widget _buildLeaderboardTab() {
    final loc = AppLocalizations.of(context)!;
    final leaderboardAsync = ref.watch(leaderboardProvider);
    final currentUserId = ref.watch(authProvider.select((auth) => auth.userId));

    return leaderboardAsync.when(
      data: (users) {
        if (users.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => ref.refresh(leaderboardProvider.future),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 32.0),
                  child: Text(
                    loc.socialLeaderboardEmpty,
                    textAlign: TextAlign.center,
                  ),
                ),
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
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 32.0),
                  child: Text(
                    loc.socialLeaderboardNoValidScores,
                    textAlign: TextAlign.center,
                  ),
                ),
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
                title: loc.socialLeaderboardTitle,
                subtitle: loc.socialLeaderboardSubtitle,
                scopeLabel: loc.socialLeaderboardScopeFriends,
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
                    loc.socialLeaderboardLoadTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppTheme.deepCharcoal,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppError.fromAny(
                      e,
                      fallbackCode: 'leaderboard_load_failed',
                      fallbackMessage: loc.socialLeaderboardLoadFailed,
                      fallbackKind: AppErrorKind.inline,
                    ).message,
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
      builder: (_) => _FindFriendsSheet(onSendRequest: _sendFriendRequest),
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
  })
  onAccept;
  final Future<void> Function({
    required String requestId,
    required String requesterId,
    required String username,
    String? avatarUrl,
  })
  onDecline;

  const _PendingRequestsSection({
    required this.requests,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              loc.socialFriendRequestsTitle,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppTheme.sageGreen,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ...requests.map((req) {
            final requestId = req.requestId;
            return Card(
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
                subtitle: Text(loc.socialFriendRequestIncomingSubtitle),
                trailing: Wrap(
                  spacing: 8,
                  children: [
                    OutlinedButton(
                      onPressed: requestId == null
                          ? null
                          : () => onDecline(
                              requestId: requestId,
                              requesterId: req.userId,
                              username: req.username,
                              avatarUrl: req.avatarUrl,
                            ),
                      child: Text(loc.commonDecline),
                    ),
                    ElevatedButton(
                      onPressed: requestId == null
                          ? null
                          : () => onAccept(
                              requestId: requestId,
                              requesterId: req.userId,
                              username: req.username,
                              avatarUrl: req.avatarUrl,
                            ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.sageGreen,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(loc.commonAccept),
                    ),
                  ],
                ),
              ),
            );
          }),
          const Divider(),
        ],
      ),
    );
  }
}

/// A single notification/activity card in the Activity tab.
class _ActivityListEntry {
  const _ActivityListEntry._({this.sectionTitle, this.notification});

  const _ActivityListEntry.section(String title) : this._(sectionTitle: title);
  const _ActivityListEntry.notification(NotificationEvent notification)
    : this._(notification: notification);

  final String? sectionTitle;
  final NotificationEvent? notification;
}

class _ActivitySectionHeader extends StatelessWidget {
  const _ActivitySectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AppTheme.sageGreen,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            '${notification.body}\n${_formatTimestamp(context, notification.createdAt)}',
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

  static String _formatTimestamp(BuildContext context, DateTime createdAt) {
    final loc = AppLocalizations.of(context)!;
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) return loc.notificationJustNow;
    if (diff.inHours < 1) return loc.notificationMinutesAgo(diff.inMinutes);
    if (diff.inDays < 1) return loc.notificationHoursAgo(diff.inHours);
    if (diff.inDays < 7) return loc.notificationDaysAgo(diff.inDays);
    return MaterialLocalizations.of(context).formatShortDate(createdAt);
  }
}

/// Bottom sheet for finding and adding new friends.
class _FindFriendsSheet extends ConsumerStatefulWidget {
  final Future<void> Function(
    String userId,
    String username, {
    String? avatarUrl,
  })
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
    final loc = AppLocalizations.of(context)!;
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
                loc.socialFindFriendsTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: loc.socialFindFriendsSearchLabel,
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
                    ? Padding(
                        padding: EdgeInsets.only(top: 32.0),
                        child: Text(
                          loc.socialFindFriendsTypeMore,
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Consumer(
                        builder: (context, ref, _) {
                          final searchAsync = ref.watch(
                            userSearchProvider(_searchQuery),
                          );
                          return searchAsync.when(
                            data: (results) {
                              if (results.isEmpty) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 32.0),
                                  child: Text(
                                    loc.socialFindFriendsNoMatches,
                                    textAlign: TextAlign.center,
                                  ),
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
                            error: (e, _) => Padding(
                              padding: const EdgeInsets.only(top: 32.0),
                              child: Text(
                                AppError.fromAny(
                                  e,
                                  fallbackCode: 'social_search_failed',
                                  fallbackMessage: loc.socialSearchFailed,
                                  fallbackKind: AppErrorKind.inline,
                                ).message,
                                textAlign: TextAlign.center,
                              ),
                            ),
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
class _SearchResultTile extends ConsumerWidget {
  final dynamic user;
  final Future<void> Function(
    String userId,
    String username, {
    String? avatarUrl,
  })
  onSendRequest;

  const _SearchResultTile({required this.user, required this.onSendRequest});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final currentUserId = ref.watch(authProvider).userId;
    final userId = (user['user_id'] ?? user['id'])?.toString() ?? '';
    final username = user['username']?.toString() ?? loc.homeFriendFallback;
    final avatarUrl = user['avatar_url']?.toString();
    final state = user['relationship_state']?.toString() ?? 'none';
    final isSelf = userId == currentUserId;

    return ListTile(
      leading: UserAvatar(avatarUrl: avatarUrl, username: username, radius: 20),
      title: Text(username),
      subtitle: Text(
        isSelf
            ? loc.commonYou
            : switch (state) {
                'accepted' => loc.socialRelationshipAcceptedFriend,
                'pending_outgoing' => loc.socialRelationshipRequestSent,
                'pending_incoming' => loc.socialRelationshipWaiting,
                _ => loc.socialRelationshipNotConnected,
              },
      ),
      trailing: isSelf
          ? Chip(label: Text(loc.commonYou))
          : switch (state) {
              'accepted' => Chip(
                avatar: const Icon(Icons.check_rounded, size: 16),
                label: Text(loc.socialChipFriends),
              ),
              'pending_outgoing' => Chip(label: Text(loc.socialChipRequested)),
              'pending_incoming' => Chip(
                label: Text(loc.socialChipRespondInFriends),
              ),
              _ => IconButton(
                tooltip: loc.socialSendFriendRequestTooltip,
                icon: const Icon(
                  Icons.person_add_rounded,
                  color: AppTheme.sageGreen,
                ),
                onPressed: userId.isEmpty
                    ? null
                    : () =>
                          onSendRequest(userId, username, avatarUrl: avatarUrl),
              ),
            },
    );
  }
}
