import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'database_connection.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Users,
    Habits,
    Logs,
    Partnerships,
    SyncQueue,
    CachedQuotes,
    SearchDocuments,
    PartnerSnapshots,
    PrivateMessages,
    HabitInvitations,
    MilestoneEvents,
    AcceptedFriends,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Bump this when the schema changes.
  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(searchDocuments);
      }
      if (from < 3) {
        await m.createTable(partnerSnapshots);
        await m.addColumn(habits, habits.colorHex);
      }
      if (from < 4) {
        await m.createTable(privateMessages);
        await m.createTable(habitInvitations);
        await m.createTable(milestoneEvents);
      }
      if (from < 5) {
        await m.createTable(acceptedFriends);
      }
    },
  );

  // ---------------------------------------------------------------------------
  // User operations
  // ---------------------------------------------------------------------------

  Future<void> insertUser(UsersCompanion user) =>
      into(users).insert(user, mode: InsertMode.insertOrReplace);

  Future<User?> getUser(String userId) =>
      (select(users)..where((u) => u.userId.equals(userId))).getSingleOrNull();

  Stream<User?> watchCurrentUser() =>
      (select(users)..limit(1)).watchSingleOrNull();

  Future<void> updateUserScore(String userId, int newScore) =>
      (update(users)..where((u) => u.userId.equals(userId))).write(
        UsersCompanion(
          totalScore: Value(newScore),
          updatedAt: Value(DateTime.now()),
          isSynced: const Value(false),
        ),
      );

  // ---------------------------------------------------------------------------
  // Habit operations
  // ---------------------------------------------------------------------------

  Future<void> insertHabit(HabitsCompanion habit) =>
      into(habits).insert(habit, mode: InsertMode.insertOrReplace);

  Stream<List<Habit>> watchActiveHabits(String userId) =>
      (select(habits)..where(
            (h) =>
                h.userId.equals(userId) &
                h.status.equalsValue(HabitStatus.active),
          ))
          .watch();

  Stream<List<Habit>> watchAllHabits(String userId) =>
      (select(habits)..where((h) => h.userId.equals(userId))).watch();

  Future<Habit?> getHabit(String habitId) => (select(
    habits,
  )..where((h) => h.habitId.equals(habitId))).getSingleOrNull();

  Future<void> incrementHabitDuration(String habitId, int extraDays) async {
    final habit = await getHabit(habitId);
    if (habit != null) {
      (update(habits)..where((h) => h.habitId.equals(habitId))).write(
        HabitsCompanion(
          currentDuration: Value(habit.currentDuration + extraDays),
          updatedAt: Value(DateTime.now()),
          isSynced: const Value(false),
        ),
      );
    }
  }

  Future<void> updateHabitStatus(String habitId, HabitStatus newStatus) =>
      (update(habits)..where((h) => h.habitId.equals(habitId))).write(
        HabitsCompanion(
          status: Value(newStatus),
          updatedAt: Value(DateTime.now()),
          isSynced: const Value(false),
        ),
      );

  Future<String> createHabitWithSync(
    String title,
    int targetDuration,
    bool isCustom,
    String colorHex,
    String userId, {
    List<String> partnerIds = const [],
  }) async {
    final habitId = const Uuid().v4();
    final now = DateTime.now();
    await transaction(() async {
      await into(habits).insert(
        HabitsCompanion(
          habitId: Value(habitId),
          userId: Value(userId),
          title: Value(title),
          targetDuration: Value(targetDuration),
          currentDuration: Value(targetDuration),
          isCustom: Value(isCustom),
          colorHex: Value(colorHex),
          status: const Value(HabitStatus.active),
          updatedAt: Value(now),
          isSynced: const Value(false),
        ),
      );
      await enqueueSync(
        SyncQueueCompanion.insert(
          action: SyncAction.createHabit,
          payload: jsonEncode({
            'habit_id': habitId,
            'title': title,
            'target_duration': targetDuration,
            'color_hex': colorHex,
            'status': 'active',
            'updated_at': now.toIso8601String(),
          }),
        ),
      );

      for (final partnerId in partnerIds) {
        await enqueueSync(
          SyncQueueCompanion.insert(
            action: SyncAction.sendHabitInvitation,
            payload: jsonEncode({
              'habit_id': habitId,
              'target_user_id': partnerId,
            }),
          ),
        );
      }
    });
    return habitId;
  }

  Future<void> updateHabitDetails(
    String habitId,
    String title,
    int targetDuration,
    String colorHex,
  ) async {
    await transaction(() async {
      await (update(habits)..where((h) => h.habitId.equals(habitId))).write(
        HabitsCompanion(
          title: Value(title),
          targetDuration: Value(targetDuration),
          colorHex: Value(colorHex),
          updatedAt: Value(DateTime.now()),
          isSynced: const Value(false),
        ),
      );
      await enqueueSync(
        SyncQueueCompanion.insert(
          action: SyncAction.updateHabit,
          payload: jsonEncode({
            'habit_id': habitId,
            'title': title,
            'target_duration': targetDuration,
            'color_hex': colorHex,
            'updated_at': DateTime.now().toIso8601String(),
          }),
        ),
      );
    });
  }

  Future<void> archiveHabit(String habitId) async {
    await transaction(() async {
      await (update(habits)..where((h) => h.habitId.equals(habitId))).write(
        HabitsCompanion(
          status: const Value(HabitStatus.abandoned),
          updatedAt: Value(DateTime.now()),
          isSynced: const Value(false),
        ),
      );
      await enqueueSync(
        SyncQueueCompanion.insert(
          action: SyncAction.updateHabit,
          payload: jsonEncode({'habitId': habitId}),
        ),
      );
    });
  }

  Future<void> restoreHabit(String habitId) async {
    await transaction(() async {
      await (update(habits)..where((h) => h.habitId.equals(habitId))).write(
        HabitsCompanion(
          status: const Value(HabitStatus.active),
          updatedAt: Value(DateTime.now()),
          isSynced: const Value(false),
        ),
      );
      await enqueueSync(
        SyncQueueCompanion.insert(
          action: SyncAction.updateHabit,
          payload: jsonEncode({'habitId': habitId}),
        ),
      );
    });
  }

  // ---------------------------------------------------------------------------
  // Log operations
  // ---------------------------------------------------------------------------

  Future<void> insertLog(LogsCompanion log) =>
      into(logs).insert(log, mode: InsertMode.insertOrReplace);

  Stream<List<Log>> watchLogsForHabit(String habitId) =>
      (select(logs)
            ..where((l) => l.habitId.equals(habitId))
            ..orderBy([(l) => OrderingTerm.desc(l.actionDate)]))
          .watch();

  /// Count logs for today to determine if the habit was already acted on.
  Future<Log?> getTodaysLog(String habitId) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(logs)..where(
          (l) =>
              l.habitId.equals(habitId) &
              l.actionDate.isBiggerOrEqualValue(startOfDay) &
              l.actionDate.isSmallerThanValue(endOfDay),
        ))
        .getSingleOrNull();
  }

  /// Get consecutive completed days for streak calculation.
  Future<int> getStreak(String habitId) async {
    final allLogs =
        await (select(logs)
              ..where(
                (l) =>
                    l.habitId.equals(habitId) &
                    l.status.equalsValue(LogStatus.completed),
              )
              ..orderBy([(l) => OrderingTerm.desc(l.actionDate)]))
            .get();

    if (allLogs.isEmpty) return 0;

    int streak = 0;
    DateTime checkDate = DateTime.now();

    for (final log in allLogs) {
      final logDay = DateTime(
        log.actionDate.year,
        log.actionDate.month,
        log.actionDate.day,
      );
      final expectedDay = DateTime(
        checkDate.year,
        checkDate.month,
        checkDate.day,
      ).subtract(Duration(days: streak));

      if (logDay == expectedDay ||
          logDay == expectedDay.subtract(const Duration(days: 1))) {
        streak++;
        checkDate = log.actionDate;
      } else {
        break;
      }
    }
    return streak;
  }

  // ---------------------------------------------------------------------------
  // Analytics queries
  // ---------------------------------------------------------------------------

  /// Counts of completed, skipped, and overdue for pie chart.
  Future<Map<String, int>> getLogDistribution(String userId) async {
    final userHabits = await (select(
      habits,
    )..where((h) => h.userId.equals(userId))).get();

    final habitIds = userHabits.map((h) => h.habitId).toList();
    if (habitIds.isEmpty) return {'completed': 0, 'skipped': 0, 'overdue': 0};

    final allLogs = await (select(
      logs,
    )..where((l) => l.habitId.isIn(habitIds))).get();

    int completed = 0, skipped = 0;
    for (final log in allLogs) {
      if (log.status == LogStatus.completed) {
        completed++;
      } else if (log.status == LogStatus.skipped) {
        skipped++;
      }
    }

    // Overdue: days where the habit was active but no log exists
    // Simplified: total active days - completed - skipped
    int totalActiveDays = 0;
    for (final habit in userHabits) {
      final daysSinceCreation = DateTime.now()
          .difference(habit.updatedAt)
          .inDays;
      totalActiveDays += daysSinceCreation;
    }
    final overdue = (totalActiveDays - completed - skipped).clamp(0, 999999);

    return {'completed': completed, 'skipped': skipped, 'overdue': overdue};
  }

  /// 30-day point accumulation for line chart.
  Future<List<MapEntry<DateTime, int>>> get30DayPointHistory(
    String userId,
  ) async {
    final userHabits = await (select(
      habits,
    )..where((h) => h.userId.equals(userId))).get();
    final habitIds = userHabits.map((h) => h.habitId).toList();
    if (habitIds.isEmpty) return [];

    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));

    final recentLogs =
        await (select(logs)
              ..where(
                (l) =>
                    l.habitId.isIn(habitIds) &
                    l.status.equalsValue(LogStatus.completed) &
                    l.actionDate.isBiggerOrEqualValue(thirtyDaysAgo),
              )
              ..orderBy([(l) => OrderingTerm.asc(l.actionDate)]))
            .get();

    // Group by day, count completions * 10 points as a baseline
    final Map<DateTime, int> dayPoints = {};
    for (final log in recentLogs) {
      final day = DateTime(
        log.actionDate.year,
        log.actionDate.month,
        log.actionDate.day,
      );
      dayPoints[day] = (dayPoints[day] ?? 0) + 10;
    }

    return dayPoints.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
  }

  // ---------------------------------------------------------------------------
  // Sync Queue operations
  // ---------------------------------------------------------------------------

  Future<void> enqueueSync(SyncQueueCompanion entry) =>
      into(syncQueue).insert(entry);

  Future<List<SyncQueueData>> getPendingSyncItems() =>
      (select(syncQueue)..where((s) => s.isProcessed.equals(false))).get();

  Future<void> markSyncProcessed(int id) =>
      (update(syncQueue)..where((s) => s.id.equals(id))).write(
        const SyncQueueCompanion(isProcessed: Value(true)),
      );

  // ---------------------------------------------------------------------------
  // Quote operations
  // ---------------------------------------------------------------------------

  Future<void> cacheQuote(String text) => into(cachedQuotes).insert(
    CachedQuotesCompanion(
      quoteText: Value(text),
      fetchedAt: Value(DateTime.now()),
    ),
  );

  Future<CachedQuote?> getTodaysQuote() {
    final startOfDay = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    return (select(cachedQuotes)
          ..where((q) => q.fetchedAt.isBiggerOrEqualValue(startOfDay))
          ..limit(1))
        .getSingleOrNull();
  }

  // ---------------------------------------------------------------------------
  // Unsynced records for background push
  // ---------------------------------------------------------------------------

  Future<List<Habit>> getUnsyncedHabits() =>
      (select(habits)..where((h) => h.isSynced.equals(false))).get();

  Future<List<Log>> getUnsyncedLogs() =>
      (select(logs)..where((l) => l.isSynced.equals(false))).get();

  // ---------------------------------------------------------------------------
  // Search operations
  // ---------------------------------------------------------------------------

  Future<void> insertSearchDocument(SearchDocumentsCompanion doc) =>
      into(searchDocuments).insert(doc, mode: InsertMode.insertOrReplace);

  Future<List<SearchDocument>> getAllSearchDocuments() =>
      select(searchDocuments).get();

  // ---------------------------------------------------------------------------
  // Social Social & 3D operations (Phase 1)
  // ---------------------------------------------------------------------------

  Future<void> insertPrivateMessage(PrivateMessagesCompanion msg) =>
      into(privateMessages).insert(msg, mode: InsertMode.insertOrReplace);

  Future<List<PrivateMessage>> getPrivateMessages() =>
      select(privateMessages).get();

  Stream<List<PrivateMessage>> watchPrivateMessages() =>
      select(privateMessages).watch();

  Future<void> insertHabitInvitation(HabitInvitationsCompanion invite) =>
      into(habitInvitations).insert(invite, mode: InsertMode.insertOrReplace);

  Future<void> updateHabitInvitationStatus(String id, String newStatus) =>
      (update(habitInvitations)..where((i) => i.invitationId.equals(id))).write(
        HabitInvitationsCompanion(status: Value(newStatus)),
      );

  Future<List<HabitInvitation>> getPendingInvitations() => (select(
    habitInvitations,
  )..where((i) => i.status.equals('pending'))).get();

  Stream<List<HabitInvitation>> watchPendingInvitations() => (select(
    habitInvitations,
  )..where((i) => i.status.equals('pending'))).watch();

  Future<void> insertMilestoneEvent(MilestoneEventsCompanion event) =>
      into(milestoneEvents).insert(event, mode: InsertMode.insertOrReplace);

  Stream<List<MilestoneEvent>> watchMilestoneEvents() =>
      select(milestoneEvents).watch();

  Future<void> deleteMilestoneEvent(String eventId) =>
      (delete(milestoneEvents)..where((e) => e.eventId.equals(eventId))).go();

  Future<SearchDocument?> getSearchDocumentById(String documentId) => (select(
    searchDocuments,
  )..where((d) => d.documentId.equals(documentId))).getSingleOrNull();

  Future<List<SearchDocument>> getSearchDocumentsByIds(
    List<String> documentIds,
  ) => (select(
    searchDocuments,
  )..where((d) => d.documentId.isIn(documentIds))).get();

  // ---------------------------------------------------------------------------
  // Partner Snapshot operations
  // ---------------------------------------------------------------------------

  /// Upsert a partner's habit snapshot pulled from the daily sync.
  Future<void> upsertPartnerSnapshot(PartnerSnapshotsCompanion snapshot) =>
      into(partnerSnapshots).insertOnConflictUpdate(snapshot);

  /// Watch all partner snapshots for a given habit — drives PartnerTicker.
  Stream<List<PartnerSnapshot>> watchPartnersByHabit(String habitId) =>
      (select(partnerSnapshots)
            ..where((s) => s.habitId.equals(habitId))
            ..orderBy([(s) => OrderingTerm.desc(s.updatedAt)]))
          .watch();

  /// Watch all distinct partners across all habits for home screen ticker.
  Stream<List<PartnerSnapshot>> watchAllPartners() =>
      select(partnerSnapshots).watch();

  // ---------------------------------------------------------------------------
  // Accepted Friends operations
  // ---------------------------------------------------------------------------

  Future<void> upsertAcceptedFriend(AcceptedFriendsCompanion friend) =>
      into(acceptedFriends).insertOnConflictUpdate(friend);

  Stream<List<AcceptedFriend>> watchAcceptedFriends() =>
      select(acceptedFriends).watch();

  // ---------------------------------------------------------------------------
  // Habit color palette assignment
  // ---------------------------------------------------------------------------

  static const List<String> _pastelPalette = [
    'FF9CAF88', // sage green
    'FFC4B5D4', // muted lavender
    'FFFBBF24', // warm amber
    'FFFB7185', // soft rose
    'FF67E8F9', // sky teal
    'FFFDBA74', // peach
    'FFA5B4FC', // periwinkle
    'FF86EFAC', // mint
  ];

  /// Assigns a stable pastel color to a habit that has none yet.
  /// Call after inserting a new habit.
  Future<void> assignHabitColorIfMissing(String habitId, int habitIndex) async {
    final habit = await (select(
      habits,
    )..where((h) => h.habitId.equals(habitId))).getSingleOrNull();
    if (habit == null) return;
    if (habit.colorHex != 'FF9CAF88') return; // already set
    final color = _pastelPalette[habitIndex % _pastelPalette.length];
    await (update(habits)..where((h) => h.habitId.equals(habitId))).write(
      HabitsCompanion(colorHex: Value(color)),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    return openConnection();
  });
}
