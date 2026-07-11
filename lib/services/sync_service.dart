// ignore_for_file: prefer_initializing_formals

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';
import '../database/database.dart';
import '../database/tables.dart';
import 'connectivity_service.dart';

/// Background sync service that processes the outbound queue
/// and pulls inbound data from Cloudflare Workers.
class SyncService {
  final AppDatabase _db;
  final ConnectivityService _connectivity;
  final FlutterSecureStorage _storage;

  SyncService({
    required AppDatabase db,
    required ConnectivityService connectivity,
    required FlutterSecureStorage storage,
  }) : _db = db,
       _connectivity = connectivity,
       _storage = storage;

  /// Initialize the sync engine.
  void init() {
    _connectivity.listen(onOnline: _processQueue);

    // Attempt initial sync on launch
    _processQueue();
  }

  /// Get the standard auth headers
  Future<Map<String, String>> _getAuthHeaders() async {
    final headers = {'Content-Type': 'application/json'};
    final token = await _storage.read(key: 'jwt_token');
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

  /// Send a mutation payload to the Cloudflare Worker.
  Future<void> _sendToCloudflare(SyncQueueData item) async {
    final headers = await _getAuthHeaders();
    final payload = jsonDecode(item.payload) as Map<String, dynamic>;
    if (item.action == SyncAction.sendNudge) {
      try {
        final response = await http.post(
          Uri.parse('$apiBaseUrl/api/social/nudge'),
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
        final response = await http.post(
          Uri.parse('$apiBaseUrl/api/social/private-message'),
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
        final response = await http.post(
          Uri.parse('$apiBaseUrl/api/social/habit-invitation/accept'),
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
        final response = await http.post(
          Uri.parse('$apiBaseUrl/api/social/habit-invitation/decline'),
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
        final response = await http.post(
          Uri.parse('$apiBaseUrl/api/sync/habit'),
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
        final response = await http.post(
          Uri.parse('$apiBaseUrl/api/sync/log'),
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
        final response = await http.post(
          Uri.parse('$apiBaseUrl/api/social/habit-invitation'),
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
      final response = await http.get(
        Uri.parse('$apiBaseUrl/api/sync/daily'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('[SyncService] GET /api/sync/daily successful');

        await _db.deleteExpiredNotificationEvents();

        // Persist accepted friends first so later notification rows can resolve
        // usernames without waiting for another sync cycle.
        final List<dynamic> acceptedFriends = data['accepted_friends'] ?? [];
        for (final friend in acceptedFriends) {
          final friendId = friend['friend_id']?.toString() ?? '';
          if (friendId.isEmpty) continue;
          final existingFriend = await _db.getAcceptedFriend(friendId);
          await _db.upsertAcceptedFriend(
            AcceptedFriendsCompanion(
              friendUserId: Value(friendId),
              username: Value(friend['username'].toString()),
              avatarUrl: Value(friend['avatar_url']?.toString()),
              updatedAt: Value(DateTime.now()),
              isSynced: const Value(true),
            ),
          );
          await _db.cacheFriendRelationship(
            userId: friendId,
            username: friend['username']?.toString() ?? 'Friend',
            avatarUrl: friend['avatar_url']?.toString(),
            relationshipState: 'accepted',
          );

          if (existingFriend == null) {
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

        // Persist partner snapshots → Drift (offline-first)
        final List<dynamic> partners = data['partners'] ?? [];
        for (final partner in partners) {
          final habitId = partner['habit_id']?.toString() ?? '';
          final partnerUserId = partner['partner_id']?.toString() ?? '';
          if (habitId.isEmpty || partnerUserId.isEmpty) continue;

          await _db.upsertPartnerSnapshot(
            PartnerSnapshotsCompanion(
              habitId: Value(habitId),
              partnerUserId: Value(partnerUserId),
              username: Value(partner['username']?.toString() ?? 'Friend'),
              avatarUrl: Value(partner['avatar_url']?.toString()),
              role: Value(
                PartnershipRole.values.firstWhere(
                  (value) => value.name == partner['role']?.toString(),
                  orElse: () => PartnershipRole.partner,
                ),
              ),
              currentDuration: Value(
                (partner['current_duration'] as num?)?.toInt() ?? 0,
              ),
              hasCompletedToday: Value(
                partner['has_completed_today'] == true ||
                    partner['has_completed_today'] == 1,
              ),
              updatedAt: Value(DateTime.now()),
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
                  isCustom: const Value(false),
                  targetDuration: Value(
                    (partner['target_duration'] as num?)?.toInt() ?? 30,
                  ),
                  currentDuration: Value(
                    (partner['viewer_remaining_days'] as num?)?.toInt() ??
                        ((partner['target_duration'] as num?)?.toInt() ?? 30),
                  ),
                  status: Value(
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

        // Persist nudges as notification rows.
        final List<dynamic> nudges = data['nudges'] ?? [];
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
          if (habitId != null) actionPayload['habit_id'] = habitId;
          if (timestamp != null) actionPayload['timestamp'] = timestamp;
          await _upsertNotificationEvent(
            userId: userId,
            notificationId: 'nudge:$senderId:${habitId ?? 'any'}',
            type: NotificationEventType.nudge,
            sourceType: 'nudge',
            sourceId: senderId,
            title: 'You were nudged',
            body:
                '${friend?.username ?? 'A friend'} sent you a reminder on a shared habit.',
            actionRoute: 'home',
            actionPayload: actionPayload,
            createdAt: nudgedAt,
            expiresAt: timestamp == null
                ? null
                : DateTime.tryParse(timestamp)?.add(const Duration(hours: 24)),
          );
        }

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
        for (final inv in invitations) {
          await _db.insertHabitInvitation(
            HabitInvitationsCompanion(
              invitationId: Value(inv['id'].toString()),
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
          await _upsertNotificationEvent(
            userId: userId,
            notificationId: 'habit_invitation:${inv['id']}',
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

        // Persist friend requests as notification rows.
        final List<dynamic> friendRequests = data['friend_requests'] ?? [];
        for (final request in friendRequests) {
          final requesterId = request['requester_id']?.toString() ?? '';
          if (requesterId.isNotEmpty) {
            await _db.cacheFriendRelationship(
              userId: requesterId,
              username: request['requester_username']?.toString() ?? 'Friend',
              avatarUrl: request['requester_avatar']?.toString(),
              relationshipState: 'pending_incoming',
              requestId: request['id']?.toString(),
            );
          }

          await _upsertNotificationEvent(
            userId: userId,
            notificationId: 'friend_request:${request['id']}',
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
    } catch (e) {
      debugPrint('[SyncService] Pull Daily Sync Failed: $e');
    }
  }

  void dispose() {
    _connectivity.dispose();
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
