import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../database/database.dart';
import '../database/tables.dart';
import '../services/app_error.dart';
import 'database_provider.dart';
import 'auth_provider.dart';

// ---------------------------------------------------------------------------
// Leaderboard Provider
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
      throw const AppException(
        AppError(
          code: 'leaderboard_invalid_response',
          message: 'Hable received an unexpected leaderboard response.',
          kind: AppErrorKind.inline,
        ),
      );
    }
    final data = jsonDecode(response.body);
    return data['leaderboard'] ?? [];
  }
  throw AppException(
    AppError.fromResponse(
      response,
      fallbackCode: 'leaderboard_fetch_failed',
      fallbackMessage: 'Hable could not load the leaderboard right now.',
      fallbackKind: AppErrorKind.inline,
    ),
  );
});

// ---------------------------------------------------------------------------
// Partner Snapshots Provider
// Streams from local Drift table — never blocks UI on network.
// ---------------------------------------------------------------------------

/// Watches all partner snapshots; updated in background by SyncService.
final allPartnersProvider = StreamProvider<List<PartnerSnapshot>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllPartners();
});

/// Watches partners for a specific habit (used per-card).
final habitPartnersProvider =
    StreamProvider.family<List<PartnerSnapshot>, String>((ref, habitId) {
      final db = ref.watch(databaseProvider);
      return db.watchPartnersByHabit(habitId);
    });

// --- Friend Profile Network Provider ---

class FriendProfileData {
  final Map<String, dynamic> user;
  final List<dynamic> habits;
  FriendProfileData({required this.user, required this.habits});
}

final friendProfileProvider = FutureProvider.family<FriendProfileData, String>((
  ref,
  friendId,
) async {
  final token = ref.watch(authProvider).token;
  if (token == null) {
    throw const AppException(
      AppError(
        code: 'friend_profile_not_authenticated',
        message: 'Log in to view that profile.',
        kind: AppErrorKind.auth,
      ),
    );
  }

  final res = await http.get(
    Uri.parse('$apiBaseUrl/api/social/user/$friendId/profile'),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (res.statusCode == 200) {
    final data = jsonDecode(res.body);
    return FriendProfileData(user: data['user'], habits: data['habits']);
  }
  throw AppException(
    AppError.fromResponse(
      res,
      fallbackCode: 'friend_profile_load_failed',
      fallbackMessage: 'Hable could not load that profile right now.',
      fallbackKind: AppErrorKind.inline,
    ),
  );
});

/// Watches private messages for the current user.
final privateMessagesProvider = StreamProvider<List<PrivateMessage>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchPrivateMessages();
});

/// Watches accepted friends (users we are friends with, regardless of shared habits).
final acceptedFriendsProvider = StreamProvider<List<AcceptedFriend>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAcceptedFriends();
});

/// Watches pending incoming friend requests cached from sync or Social Hub refresh.
final pendingIncomingFriendRelationshipsProvider =
    StreamProvider<List<FriendRelationship>>((ref) {
      final db = ref.watch(databaseProvider);
      return db.watchPendingIncomingFriendRelationships();
    });

// ---------------------------------------------------------------------------
// Nudge Action — enqueues NUDGE in SyncQueue (offline-safe)
// ---------------------------------------------------------------------------

/// Enqueue a nudge to a partner. Fire-and-forget; sync picks it up later.
Future<void> enqueueNudge({
  required AppDatabase db,
  required String senderUserId,
  required String targetUserId,
  String? habitId,
}) async {
  final payload = jsonEncode({
    'sender_id': senderUserId,
    'target_user_id': targetUserId,
    if (habitId != null && habitId.isNotEmpty) 'habit_id': habitId,
  });

  await db.enqueueSync(
    SyncQueueCompanion(
      action: const Value(SyncAction.sendNudge),
      payload: Value(payload),
      createdAt: Value(DateTime.now()),
    ),
  );
}

// ---------------------------------------------------------------------------
// Phase 2: Contextual Wishes & Habit Invites
// ---------------------------------------------------------------------------

final pendingInvitationsProvider = StreamProvider<List<HabitInvitation>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchPendingInvitations();
});

final milestoneEventsProvider = StreamProvider<List<MilestoneEvent>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchMilestoneEvents();
});

Future<void> enqueueAcceptInvitation({
  required AppDatabase db,
  required String invitationId,
}) async {
  // Update local state immediately
  await db.updateHabitInvitationStatus(invitationId, 'accepted');

  final payload = jsonEncode({'invitation_id': invitationId});
  await db.enqueueSync(
    SyncQueueCompanion(
      action: const Value(SyncAction.acceptInvitation),
      payload: Value(payload),
      createdAt: Value(DateTime.now()),
    ),
  );
}

Future<void> enqueueDeclineInvitation({
  required AppDatabase db,
  required String invitationId,
}) async {
  // Update local state immediately
  await db.updateHabitInvitationStatus(invitationId, 'declined');

  final payload = jsonEncode({'invitation_id': invitationId});
  await db.enqueueSync(
    SyncQueueCompanion(
      action: const Value(SyncAction.declineInvitation),
      payload: Value(payload),
      createdAt: Value(DateTime.now()),
    ),
  );
}

Future<void> enqueuePrivateMessage({
  required AppDatabase db,
  required String targetUserId,
  required String message,
  String? milestoneType,
  String? eventId,
}) async {
  // If this was from a milestone event, we can delete the event locally so it disappears from the UI
  if (eventId != null) {
    await db.deleteMilestoneEvent(eventId);
  }

  final payload = jsonEncode({
    'target_user_id': targetUserId,
    'message': message,
    'milestone_type': milestoneType,
  });

  await db.enqueueSync(
    SyncQueueCompanion(
      action: const Value(SyncAction.sendPrivateMessage),
      payload: Value(payload),
      createdAt: Value(DateTime.now()),
    ),
  );
}
