import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../database/database.dart';
import '../database/tables.dart';
import 'connectivity_service.dart';

/// Background sync service that processes the outbound queue
/// and pulls inbound data from Cloudflare Workers.
class SyncService {
  final AppDatabase _db;
  final ConnectivityService _connectivity;
  final String _baseUrl = 'https://hable.pages.dev';
  
  String? _jwtToken;

  // ignore: prefer_initializing_formals
  SyncService({
    required AppDatabase db,
    required ConnectivityService connectivity,
  })  : _db = db,
        _connectivity = connectivity;

  /// Initialize the sync engine.
  void init() {
    _connectivity.listen(onOnline: _processQueue);

    // Attempt initial sync on launch
    _processQueue();
  }

  /// Authenticate with the Cloudflare Worker and store the JWT.
  Future<bool> authenticate(String userId) async {
    if (!_connectivity.isOnline) return false;
    
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _jwtToken = data['token'];
        debugPrint('[SyncService] Authenticated successfully');
        return true;
      } else {
        debugPrint('[SyncService] Auth failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('[SyncService] Auth error: $e');
      return false;
    }
  }

  /// Get the standard auth headers
  Map<String, String> _getAuthHeaders() {
    final headers = {'Content-Type': 'application/json'};
    if (_jwtToken != null) {
      headers['Authorization'] = 'Bearer $_jwtToken';
    }
    return headers;
  }

  /// Process all pending outbound mutations from the sync queue.
  Future<void> _processQueue() async {
    if (!_connectivity.isOnline) return;

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
    if (item.action == SyncAction.sendNudge) {
      try {
        final response = await http.post(
          Uri.parse('$_baseUrl/api/social/nudge'),
          headers: _getAuthHeaders(),
          body: item.payload,
        );
        if (response.statusCode != 200) {
          throw Exception('Failed to send nudge: ${response.statusCode} - ${response.body}');
        }
        debugPrint('[SyncService] POST NUDGE successful');
      } catch (e) {
        debugPrint('[SyncService] Nudge sync failed: $e');
        rethrow;
      }
    } else if (item.action == SyncAction.sendPrivateMessage) {
      try {
        final response = await http.post(
          Uri.parse('$_baseUrl/api/social/private-message'),
          headers: _getAuthHeaders(),
          body: item.payload,
        );
        if (response.statusCode != 200) {
          throw Exception('Failed to send private message: ${response.statusCode} - ${response.body}');
        }
        debugPrint('[SyncService] POST PRIVATE_MESSAGE successful');
      } catch (e) {
        debugPrint('[SyncService] Private message sync failed: $e');
        rethrow;
      }
    } else if (item.action == SyncAction.acceptInvitation) {
      try {
        final response = await http.post(
          Uri.parse('$_baseUrl/api/social/habit-invitation/accept'),
          headers: _getAuthHeaders(),
          body: item.payload,
        );
        if (response.statusCode != 200) {
          throw Exception('Failed to accept invitation: ${response.statusCode} - ${response.body}');
        }
        debugPrint('[SyncService] POST ACCEPT_INVITATION successful');
      } catch (e) {
        debugPrint('[SyncService] Accept invitation sync failed: $e');
        rethrow;
      }
    } else if (item.action == SyncAction.declineInvitation) {
      try {
        final response = await http.post(
          Uri.parse('$_baseUrl/api/social/habit-invitation/decline'),
          headers: _getAuthHeaders(),
          body: item.payload,
        );
        if (response.statusCode != 200) {
          throw Exception('Failed to decline invitation: ${response.statusCode} - ${response.body}');
        }
        debugPrint('[SyncService] POST DECLINE_INVITATION successful');
      } catch (e) {
        debugPrint('[SyncService] Decline invitation sync failed: $e');
        rethrow;
      }
    } else {
      debugPrint('[SyncService] Unsupported action for sync: ${item.action}');
    }
  }

  /// Pull inbound social data and persist into Drift for offline-first access.
  Future<void> pullDailySync(String userId) async {
    if (!_connectivity.isOnline) return;

    // Auto-authenticate if we don't have a token yet
    if (_jwtToken == null) {
      final success = await authenticate(userId);
      if (!success) return;
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/sync/daily'),
        headers: _getAuthHeaders(),
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

          await _db.upsertPartnerSnapshot(PartnerSnapshotsCompanion(
            habitId: Value(habitId),
            partnerUserId: Value(partnerUserId),
            username: Value(partner['username']?.toString() ?? 'Friend'),
            avatarUrl: Value(partner['avatar_url']?.toString()),
            currentDuration: Value((partner['current_duration'] as num?)?.toInt() ?? 0),
            updatedAt: Value(DateTime.now()),
          ));
          debugPrint('[SyncService] Upserted partner ${partner['username']} for habit $habitId');
        }

        // Log nudges (will be surfaced in UI in future task)
        final List<dynamic> nudges = data['nudges'] ?? [];
        for (final nudge in nudges) {
          debugPrint('[SyncService] Received Nudge from ${nudge['senderId']}');
        }

        // Persist private messages
        final List<dynamic> messages = data['messages'] ?? [];
        for (final msg in messages) {
          await _db.insertPrivateMessage(PrivateMessagesCompanion(
            messageId: Value(msg['id'].toString()),
            senderId: Value(msg['sender_id'].toString()),
            recipientId: Value(userId),
            message: Value(msg['message'].toString()),
            milestoneType: Value(msg['milestone_type']?.toString()),
            createdAt: Value(DateTime.parse(msg['created_at'].toString())),
            updatedAt: Value(DateTime.now()),
            isSynced: const Value(true),
          ));
        }

        // Persist habit invitations
        final List<dynamic> invitations = data['invitations'] ?? [];
        for (final inv in invitations) {
          await _db.insertHabitInvitation(HabitInvitationsCompanion(
            invitationId: Value(inv['id'].toString()),
            requesterId: Value(inv['requester_id'].toString()),
            recipientId: Value(userId),
            habitId: Value(inv['habit_id'].toString()),
            status: Value(inv['status'].toString()),
            createdAt: Value(DateTime.parse(inv['created_at'].toString())),
            updatedAt: Value(DateTime.now()),
            isSynced: const Value(true),
          ));
        }
      } else {
        debugPrint('[SyncService] Failed to pull daily sync: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('[SyncService] Pull Daily Sync Failed: $e');
    }
  }

  void dispose() {
    _connectivity.dispose();
  }
}
