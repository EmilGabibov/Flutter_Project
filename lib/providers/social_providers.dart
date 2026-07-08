import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';
import '../database/tables.dart';
import 'database_provider.dart';

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

// ---------------------------------------------------------------------------
// Nudge Action — enqueues NUDGE in SyncQueue (offline-safe)
// ---------------------------------------------------------------------------

/// Enqueue a nudge to a partner. Fire-and-forget; sync picks it up later.
Future<void> enqueueNudge({
  required AppDatabase db,
  required String senderUserId,
  required String targetUserId,
}) async {
  final payload = jsonEncode({
    'sender_id': senderUserId,
    'target_user_id': targetUserId,
  });

  await db.enqueueSync(SyncQueueCompanion(
    action: const Value(SyncAction.sendNudge),
    payload: Value(payload),
    createdAt: Value(DateTime.now()),
  ));
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
  await db.enqueueSync(SyncQueueCompanion(
    action: const Value(SyncAction.acceptInvitation),
    payload: Value(payload),
    createdAt: Value(DateTime.now()),
  ));
}

Future<void> enqueueDeclineInvitation({
  required AppDatabase db,
  required String invitationId,
}) async {
  // Update local state immediately
  await db.updateHabitInvitationStatus(invitationId, 'declined');

  final payload = jsonEncode({'invitation_id': invitationId});
  await db.enqueueSync(SyncQueueCompanion(
    action: const Value(SyncAction.declineInvitation),
    payload: Value(payload),
    createdAt: Value(DateTime.now()),
  ));
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

  await db.enqueueSync(SyncQueueCompanion(
    action: const Value(SyncAction.sendPrivateMessage),
    payload: Value(payload),
    createdAt: Value(DateTime.now()),
  ));
}
