import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../database/database.dart';
import 'connectivity_service.dart';

/// Background sync service that processes the outbound queue
/// and pulls inbound data from Cloudflare Workers.
class SyncService {
  final AppDatabase _db;
  final ConnectivityService _connectivity;
  final String _baseUrl = 'http://127.0.0.1:8787'; // Relies on adb reverse tcp:8787 tcp:8787
  
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
    if (item.action == 'NUDGE') {
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
    } else {
      debugPrint('[SyncService] Unsupported action for sync: ${item.action}');
    }
  }

  /// Pull inbound social data and quotes from the daily sync endpoint.
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
        debugPrint('[SyncService] GET /api/sync/daily successful: $data');
        
        final List<dynamic> nudges = data['nudges'] ?? [];
        for (final nudge in nudges) {
          debugPrint('Received Nudge from ${nudge['senderId']} at ${nudge['timestamp']}');
        }

        final List<dynamic> partners = data['partners'] ?? [];
        for (final partner in partners) {
          debugPrint('Partner Progress: ${partner['username']} -> ${partner['current_duration']} days');
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
