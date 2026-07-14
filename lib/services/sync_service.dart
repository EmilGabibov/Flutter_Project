// ignore_for_file: prefer_initializing_formals

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';
import '../database/database.dart';
import '../models/daily_quote.dart';
import '../database/tables.dart';
import 'connectivity_service.dart';
import 'local_reminder_service.dart';

class SocialRecapPlan {
  const SocialRecapPlan({
    required this.title,
    required this.body,
    required this.payload,
    required this.latestActivityAt,
  });

  final String title;
  final String body;
  final String payload;
  final DateTime latestActivityAt;

  bool isStaleAt(
    DateTime now, {
    Duration staleAfter = const Duration(hours: 6),
  }) {
    return now.difference(latestActivityAt) > staleAfter;
  }
}

/// Background sync service that processes the outbound queue
/// and pulls inbound data from Cloudflare Workers.
class SyncService {
  final AppDatabase _db;
  final ConnectivityService _connectivity;
  final FlutterSecureStorage _storage;
  final Future<String?> Function()? _tokenProvider;
  final LocalReminderService? _localReminderService;
  final http.Client _client;
  final String _apiBaseUrl;

  SyncService({
    required AppDatabase db,
    required ConnectivityService connectivity,
    required FlutterSecureStorage storage,
    Future<String?> Function()? tokenProvider,
    LocalReminderService? localReminderService,
    http.Client? client,
    String? apiBaseUrlOverride,
  }) : _db = db,
       _connectivity = connectivity,
       _storage = storage,
       _tokenProvider = tokenProvider,
       _localReminderService = localReminderService,
       _client = client ?? http.Client(),
       _apiBaseUrl = apiBaseUrlOverride ?? apiBaseUrl;

  /// Initialize the sync engine.
  void init() {
    _connectivity.listen(onOnline: _processQueue);

    // Attempt initial sync on launch
    _processQueue();
  }

  /// Get the standard auth headers
  Future<Map<String, String>> _getAuthHeaders() async {
    final headers = {'Content-Type': 'application/json'};
    final token =
        _tokenProvider != null
            ? await _tokenProvider()
            : await _storage.read(key: 'jwt_token');
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// Process all pending outbound mutations from the sync queue.
  Future<void> flushPending() => _processQueue();

  /// Process all pending outbound mutations from the sync queue.
  Future<void> _processQueue() async {
    final pending = await _db.getPendingSyncItems();
    if (pending.isEmpty) return;

    for (final item in pending) {
      try {
        await _sendToCloudflare(item);
        await _db.markSyncProcessed(item.id);
      } catch (e) {
        // Retry on next connectivity restore
        debugPrint('Sync failed for item ${item.id}: $e');
        break;
      }
    }
  }

  Future<SocialRecapPlan?> buildSocialRecapPlan(String userId) async {
    final unread = await _db.getUnreadNotificationsForUser(userId);
    final socialTypes = {
      NotificationEventType.nudge,
      NotificationEventType.habitInvitation,
      NotificationEventType.friendRequest,
      NotificationEventType.friendAccepted,
    };
    final socialUnread = unread
        .where((n) => socialTypes.contains(n.type))
        .toList();
    final nudges = socialUnread
        .where((n) => n.type == NotificationEventType.nudge)
        .toList();
    final invites = socialUnread
        .where((n) => n.type == NotificationEventType.habitInvitation)
        .toList();
    final friendRequests = socialUnread
        .where((n) => n.type == NotificationEventType.friendRequest)
        .toList();
    final newFriends = socialUnread
        .where((n) => n.type == NotificationEventType.friendAccepted)
        .toList();
    final partnerCheckIns = await _recentPartnerCheckIns();

    if (socialUnread.isEmpty && partnerCheckIns.isEmpty) {
      return null;
    }

    Future<String> formatUserNames(
      List<String> sourceIds,
      String actionVerb,
    ) async {
      final ids = sourceIds.toSet().toList();
      final names = <String>[];
      for (final id in ids) {
        final user = await _db.getUser(id);
        if (user != null) {
          names.add(user.username.isNotEmpty ? user.username : 'Someone');
        } else {
          names.add('Someone');
        }
      }
      if (names.isEmpty) return 'You have new ${actionVerb}s.';
      if (names.length == 1) return '${names[0]} $actionVerb you.';
      if (names.length == 2) {
        return '${names[0]} and ${names[1]} $actionVerb you.';
      }
      return '${names[0]}, ${names[1]}, and ${names.length - 2} other${names.length - 2 > 1 ? 's' : ''} $actionVerb you.';
    }

    String summarizePartnerCheckIns(List<PartnerSnapshot> snapshots) {
      if (snapshots.length == 1) {
        return '${snapshots.first.username} checked in on a shared habit today.';
      }
      return '${snapshots.length} friends checked in on shared habits today.';
    }

    String summarizeCount(int count, String singular, {String? plural}) {
      final label = count == 1 ? singular : (plural ?? '${singular}s');
      return '$count $label';
    }

    final latestActivityAt = [
      ...socialUnread.map((event) => event.createdAt),
      ...partnerCheckIns.map((snapshot) => snapshot.updatedAt),
    ].reduce((latest, value) => value.isAfter(latest) ? value : latest);

    const title = 'Social Recap';
    String body;
    String payload;

    if (socialUnread.length == 1) {
      body = socialUnread.first.body;
      payload = socialUnread.first.actionPayloadJson ?? '{"route": "social"}';
    } else if (socialUnread.isEmpty && partnerCheckIns.isNotEmpty) {
      body = summarizePartnerCheckIns(partnerCheckIns);
      payload = '{"route": "social"}';
    } else if (partnerCheckIns.isNotEmpty) {
      final parts = <String>[
        summarizeCount(partnerCheckIns.length, 'friend checked in'),
      ];
      if (nudges.isNotEmpty) {
        parts.add(summarizeCount(nudges.length, 'nudge'));
      }
      if (invites.isNotEmpty) {
        parts.add(summarizeCount(invites.length, 'invite'));
      }
      if (friendRequests.isNotEmpty) {
        parts.add(summarizeCount(friendRequests.length, 'friend request'));
      }
      if (newFriends.isNotEmpty) {
        parts.add(summarizeCount(newFriends.length, 'new friend'));
      }
      body = _joinRecapParts(parts);
      payload = '{"route": "social"}';
    } else if (nudges.isNotEmpty && invites.isNotEmpty) {
      body =
          'You have ${nudges.length} nudge${nudges.length == 1 ? '' : 's'} and ${invites.length} invite${invites.length == 1 ? '' : 's'}.';
      payload = '{"route": "social"}';
    } else if (nudges.length > 1 &&
        invites.isEmpty &&
        friendRequests.isEmpty &&
        newFriends.isEmpty) {
      body = 'You have ${nudges.length} new nudges from friends.';
      payload = '{"route": "social"}';
    } else if (nudges.isNotEmpty) {
      final sourceIds = nudges
          .map((n) => n.sourceId)
          .whereType<String>()
          .toList();
      body = await formatUserNames(sourceIds, 'nudged');
      payload = '{"route": "social"}';
    } else if (invites.isNotEmpty) {
      final sourceIds = invites
          .map((n) => n.sourceId)
          .whereType<String>()
          .toList();
      body = await formatUserNames(sourceIds, 'invited');
      payload = '{"route": "social"}';
    } else {
      body =
          'You have ${socialUnread.length} new social interaction${socialUnread.length == 1 ? '' : 's'}.';
      payload = '{"route": "social"}';
    }

    return SocialRecapPlan(
      title: title,
      body: body,
      payload: payload,
      latestActivityAt: latestActivityAt,
    );
  }

  /// Evaluates local social state to build a recap payload and schedules it.
  Future<void> coalesceAndScheduleSocialRecap(String userId) async {
    if (_localReminderService == null ||
        !_localReminderService.supportsScheduling) {
      return;
    }

    final recapPlan = await buildSocialRecapPlan(userId);
    if (recapPlan == null) return;

    final now = DateTime.now();
    final scheduleMinute = now.minute + 1 >= 60 ? 0 : now.minute + 1;
    final scheduleHour = now.minute + 1 >= 60 ? (now.hour + 1) % 24 : now.hour;

    await _localReminderService.scheduleReminder(
      notificationId: 299, // Social recap
      userId: userId,
      type:
          ReminderType.dailyHabit, // Reusing slot type for now, but explicit ID
      hour: scheduleHour,
      minute: scheduleMinute,
      title: recapPlan.title,
      body: recapPlan.body,
      payload: recapPlan.payload,
    );
    debugPrint('[SyncService] Scheduled social recap → "${recapPlan.body}"');
  }

  Future<List<PartnerSnapshot>> _recentPartnerCheckIns() async {
    final cutoff = DateTime.now().subtract(const Duration(days: 1));
    return (await (_db.select(_db.partnerSnapshots)
          ..where(
            (snapshot) =>
                snapshot.hasCompletedToday.equals(true) &
                snapshot.updatedAt.isBiggerOrEqualValue(cutoff),
          )
          ..orderBy([(snapshot) => OrderingTerm.desc(snapshot.updatedAt)]))
        .get());
  }

  String _joinRecapParts(List<String> parts) {
    if (parts.isEmpty) return 'You have new social activity.';
    if (parts.length == 1) return '${parts.first}.';
    if (parts.length == 2) return '${parts[0]} and ${parts[1]}.';
    final head = parts.sublist(0, parts.length - 1).join(', ');
    return '$head, and ${parts.last}.';
  }

  /// Send a mutation payload to the Cloudflare Worker.
  Future<void> _sendToCloudflare(SyncQueueData item) async {
    final headers = await _getAuthHeaders();
    final payload = jsonDecode(item.payload) as Map<String, dynamic>;
    if (item.action == SyncAction.sendNudge) {
      try {
        final response = await _client.post(
          Uri.parse('$_apiBaseUrl/api/social/nudge'),
          headers: headers,
          body: item.payload,
        );
        if (response.statusCode != 200) {
          throw Exception(
            'Failed to send nudge: ${response.statusCode} - ${response.body}',
          );
        }
        debugPrint('[SyncService] POST NUDGE successful');
      } catch (e) {
        debugPrint('[SyncService] Nudge sync failed: $e');
        rethrow;
      }
    } else if (item.action == SyncAction.sendPrivateMessage) {
      try {
        final response = await _client.post(
          Uri.parse('$_apiBaseUrl/api/social/private-message'),
          headers: headers,
          body: item.payload,
        );
        if (response.statusCode != 200) {
          throw Exception(
            'Failed to send private message: ${response.statusCode} - ${response.body}',
          );
        }
        debugPrint('[SyncService] POST PRIVATE_MESSAGE successful');
      } catch (e) {
        debugPrint('[SyncService] Private message sync failed: $e');
        rethrow;
      }
    } else if (item.action == SyncAction.acceptInvitation) {
      try {
        final response = await _client.post(
          Uri.parse('$_apiBaseUrl/api/social/habit-invitation/accept'),
          headers: headers,
          body: item.payload,
        );
        if (response.statusCode != 200) {
          throw Exception(
            'Failed to accept invitation: ${response.statusCode} - ${response.body}',
          );
        }
        debugPrint('[SyncService] POST ACCEPT_INVITATION successful');
      } catch (e) {
        debugPrint('[SyncService] Accept invitation sync failed: $e');
        rethrow;
      }
    } else if (item.action == SyncAction.declineInvitation) {
      try {
        final response = await _client.post(
          Uri.parse('$_apiBaseUrl/api/social/habit-invitation/decline'),
          headers: headers,
          body: item.payload,
        );
        if (response.statusCode != 200) {
          throw Exception(
            'Failed to decline invitation: ${response.statusCode} - ${response.body}',
          );
        }
        debugPrint('[SyncService] POST DECLINE_INVITATION successful');
      } catch (e) {
        debugPrint('[SyncService] Decline invitation sync failed: $e');
        rethrow;
      }
    } else if (item.action == SyncAction.syncScore) {
      debugPrint('[SyncService] Ignoring deprecated client score sync');
    } else if (item.action == SyncAction.createHabit ||
        item.action == SyncAction.updateHabit) {
      try {
        final response = await _client.post(
          Uri.parse('$_apiBaseUrl/api/sync/habit'),
          headers: headers,
          body: item.payload,
        );
        if (response.statusCode != 200) {
          throw Exception(
            'Failed to sync habit: ${response.statusCode} - ${response.body}',
          );
        }
        final habitId = payload['habit_id']?.toString();
        if (habitId != null && habitId.isNotEmpty) {
          await _db.markHabitSynced(habitId);
        }
        debugPrint('[SyncService] POST SYNC_HABIT successful');
      } catch (e) {
        debugPrint('[SyncService] Habit sync failed: $e');
        rethrow;
      }
    } else if (item.action == SyncAction.logHabit) {
      try {
        final response = await _client.post(
          Uri.parse('$_apiBaseUrl/api/sync/log'),
          headers: headers,
          body: item.payload,
        );
        if (response.statusCode != 200) {
          throw Exception(
            'Failed to log habit: ${response.statusCode} - ${response.body}',
          );
        }
        final logId = payload['log_id']?.toString();
        if (logId != null && logId.isNotEmpty) {
          await _db.markLogSynced(logId);
        }
        debugPrint('[SyncService] POST SYNC_LOG successful');
      } catch (e) {
        debugPrint('[SyncService] Log sync failed: $e');
        rethrow;
      }
    } else if (item.action == SyncAction.sendHabitInvitation) {
      try {
        final response = await _client.post(
          Uri.parse('$_apiBaseUrl/api/social/habit-invitation'),
          headers: headers,
          body: item.payload,
        );
        if (response.statusCode != 200) {
          throw Exception(
            'Failed to send habit invitation: ${response.statusCode} - ${response.body}',
          );
        }
        debugPrint('[SyncService] POST HABIT_INVITATION successful');
      } catch (e) {
        debugPrint('[SyncService] Habit invitation sync failed: $e');
        rethrow;
      }
    } else {
      debugPrint('[SyncService] Unsupported action for sync: ${item.action}');
    }
  }

  /// Pull inbound social data and persist into Drift for offline-first access.
  Future<void> pullDailySync(String userId) async {
    final headers = await _getAuthHeaders();
    if (!headers.containsKey('Authorization')) {
      debugPrint('[SyncService] Cannot pull daily sync: missing auth token');
      return;
    }

    try {
      final response = await _client.get(
        Uri.parse('$_apiBaseUrl/api/sync/daily'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('[SyncService] GET /api/sync/daily successful');

        await _db.deleteExpiredNotificationEvents();
        final syncedQuote = _syncedQuote(data['quote']);
        if (syncedQuote != null) {
          await _db.cacheQuote(syncedQuote.text, author: syncedQuote.author);
        }

        // Persist accepted friends first so later notification rows can resolve
        // usernames without waiting for another sync cycle.
        final List<dynamic> acceptedFriends = data['accepted_friends'] ?? [];
        final acceptedFriendRows = <AcceptedFriendsCompanion>[];
        for (final friend in acceptedFriends) {
          final friendId = friend['friend_id']?.toString() ?? '';
          if (friendId.isEmpty || friendId == userId) continue;
          acceptedFriendRows.add(
            AcceptedFriendsCompanion(
              friendUserId: Value(friendId),
              username: Value(friend['username']?.toString() ?? 'Friend'),
              avatarUrl: Value(friend['avatar_url']?.toString()),
              updatedAt: Value(DateTime.now()),
              isSynced: const Value(true),
            ),
          );
        }
        final existingFriends = await _db.watchAcceptedFriends().first;
        final existingFriendIds = existingFriends
            .map((friend) => friend.friendUserId)
            .toSet();
        final existingFriendById = {
          for (final friend in existingFriends) friend.friendUserId: friend,
        };
        final nextFriendIds = acceptedFriendRows
            .map((friend) => friend.friendUserId.value)
            .toSet();
        final revokedFriendIds = existingFriendIds.difference(nextFriendIds);
        await _db.replaceAcceptedFriends(acceptedFriendRows);
        for (final friend in acceptedFriends) {
          final friendId = friend['friend_id']?.toString() ?? '';
          if (friendId.isEmpty || friendId == userId) continue;
          await _db.cacheFriendRelationship(
            userId: friendId,
            username: friend['username']?.toString() ?? 'Friend',
            avatarUrl: friend['avatar_url']?.toString(),
            relationshipState: 'accepted',
          );
          if (!existingFriendIds.contains(friendId)) {
            await _upsertNotificationEvent(
              userId: userId,
              notificationId: 'friend_accepted:$friendId',
              type: NotificationEventType.friendAccepted,
              sourceType: 'accepted_friend',
              sourceId: friendId,
              title: 'New friend connected',
              body: 'You are now connected with ${friend['username']}.',
              actionRoute: 'social_friends',
              actionPayload: {'friend_id': friendId},
            );
          }
        }
        for (final revokedFriendId in revokedFriendIds) {
          final revokedFriend = existingFriendById[revokedFriendId];
          await _db.cacheFriendRelationship(
            userId: revokedFriendId,
            username: revokedFriend?.username ?? revokedFriendId,
            avatarUrl: revokedFriend?.avatarUrl,
            relationshipState: 'none',
          );
        }

        // Persist partner snapshots → Drift (offline-first)
        final List<dynamic> partners = data['partners'] ?? [];
        final existingPartnerHabits = await _db.watchAllPartners().first;
        final existingPartnerHabitIds = existingPartnerHabits
            .map((partner) => partner.habitId)
            .toSet();
        final nextPartnerHabitIds = <String>{};
        final partnerCompletionByHabit = <String, List<PartnerSnapshot>>{};
        for (final partner in partners) {
          final habitId = partner['habit_id']?.toString() ?? '';
          final partnerUserId = partner['partner_id']?.toString() ?? '';
          if (habitId.isEmpty || partnerUserId.isEmpty) continue;
          nextPartnerHabitIds.add(habitId);
          final role = PartnershipRole.values.firstWhere(
            (value) => value.name == partner['role']?.toString(),
            orElse: () => PartnershipRole.partner,
          );
          final hasCompletedToday =
              partner['has_completed_today'] == true ||
              partner['has_completed_today'] == 1;

          await _db.upsertPartnerSnapshot(
            PartnerSnapshotsCompanion(
              habitId: Value(habitId),
              partnerUserId: Value(partnerUserId),
              username: Value(partner['username']?.toString() ?? 'Friend'),
              avatarUrl: Value(partner['avatar_url']?.toString()),
              role: Value(role),
              currentDuration: Value(
                (partner['current_duration'] as num?)?.toInt() ?? 0,
              ),
              hasCompletedToday: Value(hasCompletedToday),
              updatedAt: Value(DateTime.now()),
            ),
          );
          partnerCompletionByHabit
              .putIfAbsent(habitId, () => [])
              .add(
                PartnerSnapshot(
                  habitId: habitId,
                  partnerUserId: partnerUserId,
                  username: partner['username']?.toString() ?? 'Friend',
                  avatarUrl: partner['avatar_url']?.toString(),
                  role: role,
                  currentDuration:
                      (partner['current_duration'] as num?)?.toInt() ?? 0,
                  hasCompletedToday: hasCompletedToday,
                  lastNudgeAt: null,
                  updatedAt: DateTime.now(),
                  isSynced: true,
                ),
              );

          // UX Fix: Upsert the shared habit into the local habits table
          // so it shows up on the recipient's home screen.
          await _db
              .into(_db.habits)
              .insertOnConflictUpdate(
                HabitsCompanion(
                  habitId: Value(habitId),
                  userId: Value(userId),
                  title: Value(partner['title']?.toString() ?? 'Shared Habit'),
                  description: Value(partner['description']?.toString()),
                  isCustom: const Value(false),
                  targetDuration: Value(
                    (partner['target_duration'] as num?)?.toInt() ?? 30,
                  ),
                  currentDuration: Value(
                    (partner['viewer_remaining_days'] as num?)?.toInt() ??
                        ((partner['target_duration'] as num?)?.toInt() ?? 30),
                  ),
                  status: Value(
                    // Distinguish between Daily Check-In and Challenge Lifecycle Completion.
                    // Ignore non-lifecycle completion signals for shared habits.
                    (partner['status']?.toString() ?? 'active') == 'abandoned'
                        ? HabitStatus.abandoned
                        : HabitStatus.active,
                  ),
                  colorHex: Value(
                    partner['color_hex']?.toString() ?? 'FF9CAF88',
                  ),
                  updatedAt: Value(DateTime.now()),
                  isSynced: const Value(true),
                ),
              );

          debugPrint(
            '[SyncService] Upserted partner ${partner['username']} for habit $habitId',
          );
        }
        final revokedSharedHabitIds = existingPartnerHabitIds.difference(
          nextPartnerHabitIds,
        );
        for (final habitId in revokedSharedHabitIds) {
          await _db.removeHabitLocally(habitId);
        }
        for (final entry in partnerCompletionByHabit.entries) {
          final relevantPartners = entry.value
              .where((partner) => partner.role != PartnershipRole.supporter)
              .toList();
          if (relevantPartners.isEmpty) continue;
          final everyoneElseCompleted = relevantPartners.every(
            (partner) => partner.hasCompletedToday,
          );
          if (everyoneElseCompleted) {
            await _db.upgradeTodaysCompletionPoints(entry.key, 10);
          }
        }

        // Persist nudges as notification rows.
        final List<dynamic> nudges = data['nudges'] ?? [];
        final activeNudgeNotificationIds = <String>{};
        for (final nudge in nudges) {
          final senderId = nudge['senderId']?.toString() ?? '';
          final rawHabitId =
              nudge['habitId']?.toString() ?? nudge['habit_id']?.toString();
          final habitId = rawHabitId == null || rawHabitId.isEmpty
              ? null
              : rawHabitId;
          final timestamp = nudge['timestamp']?.toString();
          if (senderId.isEmpty) continue;
          final nudgedAt = DateTime.tryParse(timestamp ?? '') ?? DateTime.now();
          final friend = await _db.getAcceptedFriend(senderId);
          await _db.markPartnerNudgeReceived(
            senderId,
            habitId: habitId,
            nudgedAt: nudgedAt,
          );
          final actionPayload = <String, dynamic>{'sender_id': senderId};
          String? habitName;
          if (habitId != null) {
            actionPayload['habit_id'] = habitId;
            final habit = await _db.getHabit(habitId);
            habitName = habit?.title;
          }
          if (timestamp != null) actionPayload['timestamp'] = timestamp;

          final senderName = friend?.username ?? 'A friend';
          final bodyText = habitName != null
              ? '$senderName nudged you to check-in on $habitName'
              : '$senderName sent you a reminder on a shared habit.';

          final notificationId = 'nudge:$senderId:${habitId ?? 'any'}';
          activeNudgeNotificationIds.add(notificationId);
          await _upsertNotificationEvent(
            userId: userId,
            notificationId: notificationId,
            type: NotificationEventType.nudge,
            sourceType: 'nudge',
            sourceId: senderId,
            title: 'You were nudged',
            body: bodyText,
            actionRoute: 'home',
            actionPayload: actionPayload,
            createdAt: nudgedAt,
            expiresAt: timestamp == null
                ? null
                : DateTime.tryParse(timestamp)?.add(const Duration(hours: 24)),
          );
        }
        await _db.reconcileNotificationEventsForType(
          userId: userId,
          type: NotificationEventType.nudge,
          validNotificationIds: activeNudgeNotificationIds,
        );

        // Persist private messages
        final List<dynamic> messages = data['messages'] ?? [];
        for (final msg in messages) {
          await _db.insertPrivateMessage(
            PrivateMessagesCompanion(
              messageId: Value(msg['id'].toString()),
              senderId: Value(msg['sender_id'].toString()),
              recipientId: Value(userId),
              message: Value(msg['message'].toString()),
              milestoneType: Value(msg['milestone_type']?.toString()),
              createdAt: Value(DateTime.parse(msg['created_at'].toString())),
              updatedAt: Value(DateTime.now()),
              isSynced: const Value(true),
            ),
          );

          await _upsertNotificationEvent(
            userId: userId,
            notificationId: 'private_message:${msg['id']}',
            type: NotificationEventType.privateMessage,
            sourceType: 'private_message',
            sourceId: msg['id']?.toString(),
            title: 'New private message',
            body: msg['message']?.toString() ?? 'Open Social Hub to read it.',
            actionRoute: 'social_inbox',
            actionPayload: {'message_id': msg['id']?.toString()},
            createdAt:
                DateTime.tryParse(msg['created_at']?.toString() ?? '') ??
                DateTime.now(),
          );
        }

        // Persist habit invitations
        final List<dynamic> invitations = data['invitations'] ?? [];
        final pendingInvitationIds = <String>{};
        final invitationNotificationIds = <String>{};
        for (final inv in invitations) {
          final invitationId = inv['id']?.toString() ?? '';
          if (invitationId.isEmpty) continue;
          pendingInvitationIds.add(invitationId);
          await _db.insertHabitInvitation(
            HabitInvitationsCompanion(
              invitationId: Value(invitationId),
              requesterId: Value(inv['requester_id'].toString()),
              recipientId: Value(userId),
              habitId: Value(inv['habit_id'].toString()),
              status: Value(inv['status'].toString()),
              createdAt: Value(DateTime.parse(inv['created_at'].toString())),
              updatedAt: Value(DateTime.now()),
              isSynced: const Value(true),
            ),
          );

          final requesterId = inv['requester_id']?.toString() ?? '';
          final requester = requesterId.isEmpty
              ? null
              : await _db.getAcceptedFriend(requesterId);
          final notificationId = 'habit_invitation:$invitationId';
          invitationNotificationIds.add(notificationId);
          await _upsertNotificationEvent(
            userId: userId,
            notificationId: notificationId,
            type: NotificationEventType.habitInvitation,
            sourceType: 'habit_invitation',
            sourceId: inv['id']?.toString(),
            title: 'Habit invite',
            body:
                '${requester?.username ?? 'A friend'} invited you to a shared habit.',
            actionRoute: 'home',
            actionPayload: {
              'invitation_id': inv['id']?.toString(),
              'habit_id': inv['habit_id']?.toString(),
            },
            createdAt:
                DateTime.tryParse(inv['created_at']?.toString() ?? '') ??
                DateTime.now(),
          );
        }
        await _db.reconcilePendingHabitInvitations(pendingInvitationIds);
        await _db.reconcileNotificationEventsForType(
          userId: userId,
          type: NotificationEventType.habitInvitation,
          validNotificationIds: invitationNotificationIds,
        );

        // Persist friend requests as notification rows.
        final List<dynamic> friendRequests = data['friend_requests'] ?? [];
        final pendingRequesterIds = <String>{};
        final friendRequestNotificationIds = <String>{};
        for (final request in friendRequests) {
          final requesterId = request['requester_id']?.toString() ?? '';
          if (requesterId.isNotEmpty && requesterId != userId) {
            pendingRequesterIds.add(requesterId);
            await _db.cacheFriendRelationship(
              userId: requesterId,
              username: request['requester_username']?.toString() ?? 'Friend',
              avatarUrl: request['requester_avatar']?.toString(),
              relationshipState: 'pending_incoming',
              requestId: request['id']?.toString(),
            );
          }

          final requestId = request['id']?.toString() ?? '';
          final notificationId = 'friend_request:$requestId';
          friendRequestNotificationIds.add(notificationId);
          await _upsertNotificationEvent(
            userId: userId,
            notificationId: notificationId,
            type: NotificationEventType.friendRequest,
            sourceType: 'friend_request',
            sourceId: request['id']?.toString(),
            title: 'Friend request',
            body:
                '${request['requester_username'] ?? 'Someone'} wants to connect.',
            actionRoute: 'social_requests',
            actionPayload: {'request_id': request['id']?.toString()},
            createdAt:
                DateTime.tryParse(request['created_at']?.toString() ?? '') ??
                DateTime.now(),
          );
        }
        await _db.reconcilePendingIncomingFriendRelationships(
          pendingRequesterIds,
        );
        await _db.reconcileNotificationEventsForType(
          userId: userId,
          type: NotificationEventType.friendRequest,
          validNotificationIds: friendRequestNotificationIds,
        );

        final gamification = data['gamification'];
        if (gamification is Map<String, dynamic>) {
          final totalPoints =
              (gamification['total_points'] as num?)?.toInt() ?? 0;
          final levelName =
              gamification['level']?.toString().trim().isNotEmpty == true
              ? gamification['level'].toString()
              : 'Newbie';
          await _db.updateServerGamification(
            userId,
            totalScore: totalPoints,
            levelName: levelName,
          );

          final badges = gamification['badges'];
          if (badges is List) {
            for (final badge in badges) {
              if (badge is! Map<String, dynamic>) continue;
              final achievementId = badge['achievement_id']?.toString() ?? '';
              if (achievementId.isEmpty) continue;
              final unlockedAt =
                  DateTime.tryParse(badge['unlocked_at']?.toString() ?? '') ??
                  DateTime.now();
              await _db.upsertAchievementUnlock(
                AchievementUnlocksCompanion(
                  achievementId: Value(achievementId),
                  userId: Value(userId),
                  sourceEventId: Value(
                    badge['source_event_id']?.toString() ?? achievementId,
                  ),
                  unlockedAt: Value(unlockedAt),
                  updatedAt: Value(DateTime.now()),
                  isSynced: const Value(true),
                ),
              );
            }
          }
        }
      } else {
        debugPrint(
          '[SyncService] Failed to pull daily sync: ${response.statusCode} - ${response.body}',
        );
      }

      // After syncing social data, refresh the recap reminder from local state.
      await coalesceAndScheduleSocialRecap(userId);
    } catch (e) {
      debugPrint('[SyncService] Pull Daily Sync Failed: $e');
    }
  }

  void dispose() {
    _client.close();
    _connectivity.dispose();
  }

  DailyQuote? _syncedQuote(Object? value) {
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : DailyQuote(text: trimmed);
    }
    if (value is Map<String, dynamic>) {
      final text = value['text']?.toString().trim();
      final author = value['author']?.toString().trim();
      return text == null || text.isEmpty
          ? null
          : DailyQuote(text: text, author: author?.isEmpty == true ? null : author);
    }
    return null;
  }

  Future<void> _upsertNotificationEvent({
    required String userId,
    required String notificationId,
    required NotificationEventType type,
    required String sourceType,
    String? sourceId,
    required String title,
    required String body,
    String? actionRoute,
    Map<String, dynamic>? actionPayload,
    DateTime? createdAt,
    DateTime? expiresAt,
  }) async {
    final now = DateTime.now();
    await _db.upsertNotificationEvent(
      NotificationEventsCompanion(
        notificationId: Value(notificationId),
        userId: Value(userId),
        type: Value(type),
        sourceType: Value(sourceType),
        sourceId: Value(sourceId),
        title: Value(title),
        body: Value(body),
        actionRoute: Value(actionRoute),
        actionPayloadJson: Value(
          actionPayload == null ? null : jsonEncode(actionPayload),
        ),
        createdAt: Value(createdAt ?? now),
        expiresAt: Value(expiresAt),
        readAt: const Value.absent(),
        updatedAt: Value(now),
      ),
    );
  }
}
