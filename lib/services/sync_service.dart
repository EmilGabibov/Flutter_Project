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
      try {
        final response = await http.post(
          Uri.parse('$apiBaseUrl/api/sync/score'),
          headers: headers,
          body: item.payload,
        );
        if (response.statusCode != 200) {
          throw Exception(
            'Failed to sync score: ${response.statusCode} - ${response.body}',
          );
        }
        debugPrint('[SyncService] POST SYNC_SCORE successful');
      } catch (e) {
        debugPrint('[SyncService] Sync score failed: $e');
        rethrow;
      }
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
              currentDuration: Value(
                (partner['current_duration'] as num?)?.toInt() ?? 0,
              ),
              updatedAt: Value(DateTime.now()),
            ),
          );
          
          // UX Fix: Upsert the shared habit into the local habits table 
          // so it shows up on the recipient's home screen.
          await _db.into(_db.habits).insertOnConflictUpdate(
            HabitsCompanion(
              habitId: Value(habitId),
              userId: Value(userId),
              title: Value(partner['title']?.toString() ?? 'Shared Habit'),
              isCustom: const Value(false),
              targetDuration: Value((partner['target_duration'] as num?)?.toInt() ?? 30),
              currentDuration: const Value(0), // user's own current duration is fetched elsewhere or starts at 0
              status: const Value(HabitStatus.active),
              colorHex: Value(partner['color_hex']?.toString() ?? 'FF9CAF88'),
              updatedAt: Value(DateTime.now()),
              isSynced: const Value(true),
            ),
          );

          debugPrint(
            '[SyncService] Upserted partner ${partner['username']} for habit $habitId',
          );
        }

        // Log nudges (will be surfaced in UI in future task)
        final List<dynamic> nudges = data['nudges'] ?? [];
        for (final nudge in nudges) {
          debugPrint('[SyncService] Received Nudge from ${nudge['senderId']}');
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
        }

        // Persist accepted friends
        final List<dynamic> acceptedFriends = data['accepted_friends'] ?? [];
        for (final friend in acceptedFriends) {
          await _db.upsertAcceptedFriend(
            AcceptedFriendsCompanion(
              friendUserId: Value(friend['friend_id'].toString()),
              username: Value(friend['username'].toString()),
              avatarUrl: Value(friend['avatar_url']?.toString()),
              updatedAt: Value(DateTime.now()),
              isSynced: const Value(true),
            ),
          );
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
}
