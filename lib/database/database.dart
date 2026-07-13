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
    FriendRelationships,
    AchievementUnlocks,
    NotificationEvents,
    ReminderSettings,
    UsageAggregateBuckets,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  /// Bump this when the schema changes.
  @override
  int get schemaVersion => 16;

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
      if (from < 6) {
        await m.addColumn(partnerships, partnerships.role);
        await m.addColumn(partnerSnapshots, partnerSnapshots.role);
      }
      if (from < 7) {
        await m.addColumn(users, users.levelName);
        await m.createTable(achievementUnlocks);
      }
      if (from < 8) {
        await m.addColumn(users, users.email);
        await m.addColumn(users, users.emailVerifiedAt);
      }
      if (from < 9) {
        await m.createTable(usageAggregateBuckets);
      }
      if (from < 10) {
        await m.createTable(notificationEvents);
        await m.createTable(reminderSettings);
      }
      if (from < 11) {
        await m.createTable(friendRelationships);
      }
      if (from < 13) {
        await m.addColumn(
          reminderSettings,
          reminderSettings.isPermissionDenied,
        );
      }
      if (from < 14) {
        await m.alterTable(TableMigration(reminderSettings));
      }
      if (from < 15) {
        await m.addColumn(logs, logs.pointsAwarded);
      }
      if (from < 16) {
        await m.addColumn(habits, habits.description);
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

  Stream<User?> watchUser(String userId) => (select(
    users,
  )..where((u) => u.userId.equals(userId))).watchSingleOrNull();

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

  Future<void> updateServerGamification(
    String userId, {
    required int totalScore,
    required String levelName,
  }) => (update(users)..where((u) => u.userId.equals(userId))).write(
    UsersCompanion(
      totalScore: Value(totalScore),
      levelName: Value(levelName),
      updatedAt: Value(DateTime.now()),
      isSynced: const Value(true),
    ),
  );

  Future<void> updateUserEmailVerification(
    String userId, {
    required String email,
    required DateTime emailVerifiedAt,
  }) => (update(users)..where((u) => u.userId.equals(userId))).write(
    UsersCompanion(
      email: Value(email),
      emailVerifiedAt: Value(emailVerifiedAt),
      updatedAt: Value(DateTime.now()),
      isSynced: const Value(true),
    ),
  );

  Future<void> clearAllLocalData() async {
    await transaction(() async {
      await delete(logs).go();
      await delete(partnerships).go();
      await delete(syncQueue).go();
      await delete(cachedQuotes).go();
      await delete(searchDocuments).go();
      await delete(partnerSnapshots).go();
      await delete(privateMessages).go();
      await delete(habitInvitations).go();
      await delete(milestoneEvents).go();
      await delete(acceptedFriends).go();
      await delete(friendRelationships).go();
      await delete(achievementUnlocks).go();
      await delete(notificationEvents).go();
      await delete(reminderSettings).go();
      await delete(usageAggregateBuckets).go();
      await delete(habits).go();
      await delete(users).go();
    });
  }

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

  Future<void> completeHabitDay(
    String habitId, {
    bool keepActiveWhenDurationEnds = false,
  }) async {
    final habit = await getHabit(habitId);
    if (habit == null) return;

    final hasPartners =
        await (select(partnerships)..where((p) => p.habitId.equals(habitId)))
            .get()
            .then((list) => list.isNotEmpty);

    final remainingDays = habit.currentDuration > 0
        ? habit.currentDuration - 1
        : 0;

    // Distinguish between Daily Check-In and Challenge Lifecycle Completion.
    // Shared habits never automatically complete their lifecycle just because
    // duration hits 0. Owner-controlled solo challenges move into the existing
    // archived/history lane instead of a separate completed-only state.
    final nextStatus =
        remainingDays == 0 && !keepActiveWhenDurationEnds && !hasPartners
        ? HabitStatus.finished
        : HabitStatus.active;

    final now = DateTime.now();
    await transaction(() async {
      await (update(habits)..where((h) => h.habitId.equals(habitId))).write(
        HabitsCompanion(
          currentDuration: Value(remainingDays),
          status: Value(nextStatus),
          updatedAt: Value(now),
          isSynced: const Value(false),
        ),
      );

      if (nextStatus == HabitStatus.abandoned ||
          nextStatus == HabitStatus.finished) {
        await enqueueSync(
          SyncQueueCompanion.insert(
            action: SyncAction.updateHabit,
            payload: jsonEncode({
              'habit_id': habitId,
              'title': habit.title,
              'target_duration': habit.targetDuration,
              'color_hex': habit.colorHex,
              'status': 'abandoned',
              'updated_at': now.toIso8601String(),
            }),
          ),
        );
      }
    });
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
    String? description,
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
          description: Value(description),
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
            'description': description,
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
    String? description,
    int targetDuration,
    String colorHex,
  ) async {
    final now = DateTime.now();
    await transaction(() async {
      await (update(habits)..where((h) => h.habitId.equals(habitId))).write(
        HabitsCompanion(
          title: Value(title),
          description: Value(description),
          targetDuration: Value(targetDuration),
          colorHex: Value(colorHex),
          updatedAt: Value(now),
          isSynced: const Value(false),
        ),
      );
      await enqueueSync(
        SyncQueueCompanion.insert(
          action: SyncAction.updateHabit,
          payload: jsonEncode({
            'habit_id': habitId,
            'title': title,
            'description': description,
            'target_duration': targetDuration,
            'color_hex': colorHex,
            'status': 'active',
            'updated_at': now.toIso8601String(),
          }),
        ),
      );
    });
  }

  Future<void> archiveHabit(String habitId) async {
    final habit = await getHabit(habitId);
    if (habit == null) return;
    final now = DateTime.now();
    await transaction(() async {
      await (update(habits)..where((h) => h.habitId.equals(habitId))).write(
        HabitsCompanion(
          status: const Value(HabitStatus.abandoned),
          updatedAt: Value(now),
          isSynced: const Value(false),
        ),
      );
      await enqueueSync(
        SyncQueueCompanion.insert(
          action: SyncAction.updateHabit,
          payload: jsonEncode({
            'habit_id': habitId,
            'title': habit.title,
            'target_duration': habit.targetDuration,
            'color_hex': habit.colorHex,
            'status': 'abandoned',
            'updated_at': now.toIso8601String(),
          }),
        ),
      );
    });
  }

  Future<void> removeHabitLocally(String habitId) async {
    await transaction(() async {
      await (delete(logs)..where((l) => l.habitId.equals(habitId))).go();
      await (delete(
        partnerships,
      )..where((p) => p.habitId.equals(habitId))).go();
      await (delete(
        partnerSnapshots,
      )..where((p) => p.habitId.equals(habitId))).go();
      await (delete(
        habitInvitations,
      )..where((i) => i.habitId.equals(habitId))).go();
      await (delete(habits)..where((h) => h.habitId.equals(habitId))).go();
    });
  }

  Future<void> restoreHabit(String habitId) async {
    final habit = await getHabit(habitId);
    if (habit == null) return;
    final now = DateTime.now();
    await transaction(() async {
      await (update(habits)..where((h) => h.habitId.equals(habitId))).write(
        HabitsCompanion(
          status: const Value(HabitStatus.active),
          updatedAt: Value(now),
          isSynced: const Value(false),
        ),
      );
      await enqueueSync(
        SyncQueueCompanion.insert(
          action: SyncAction.updateHabit,
          payload: jsonEncode({
            'habit_id': habitId,
            'title': habit.title,
            'target_duration': habit.targetDuration,
            'color_hex': habit.colorHex,
            'status': 'active',
            'updated_at': now.toIso8601String(),
          }),
        ),
      );
    });
  }

  Future<void> rerunHabit(String habitId) async {
    final habit = await getHabit(habitId);
    if (habit == null) return;

    final now = DateTime.now();
    await transaction(() async {
      await (delete(logs)..where((l) => l.habitId.equals(habitId))).go();
      await (update(habits)..where((h) => h.habitId.equals(habitId))).write(
        HabitsCompanion(
          currentDuration: Value(habit.targetDuration),
          status: const Value(HabitStatus.active),
          updatedAt: Value(now),
          isSynced: const Value(false),
        ),
      );
      await enqueueSync(
        SyncQueueCompanion.insert(
          action: SyncAction.updateHabit,
          payload: jsonEncode({
            'habit_id': habitId,
            'title': habit.title,
            'target_duration': habit.targetDuration,
            'color_hex': habit.colorHex,
            'status': 'active',
            'reset_progress': true,
            'updated_at': now.toIso8601String(),
          }),
        ),
      );
    });
  }

  // ---------------------------------------------------------------------------
  // Log operations
  // ---------------------------------------------------------------------------

  Future<void> insertLog(LogsCompanion log) =>
      into(logs).insert(log, mode: InsertMode.insertOrReplace);

  Future<void> updateLogPoints(String logId, int pointsAwarded) =>
      (update(logs)..where((l) => l.logId.equals(logId))).write(
        LogsCompanion(
          pointsAwarded: Value(pointsAwarded),
          updatedAt: Value(DateTime.now()),
          isSynced: const Value(false),
        ),
      );

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

  Future<void> upgradeTodaysCompletionPoints(String habitId, int points) async {
    final log = await getTodaysLog(habitId);
    if (log == null || log.status != LogStatus.completed) return;
    if (log.pointsAwarded >= points) return;
    await updateLogPoints(log.logId, points);
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

    // Use persisted per-log awards so Profile analytics match completion and
    // history surfaces. Legacy rows without awards fall back to the base
    // completed-check-in value.
    final Map<DateTime, int> dayPoints = {};
    for (final log in recentLogs) {
      final day = DateTime(
        log.actionDate.year,
        log.actionDate.month,
        log.actionDate.day,
      );
      final awardedPoints = log.pointsAwarded > 0 ? log.pointsAwarded : 5;
      dayPoints[day] = (dayPoints[day] ?? 0) + awardedPoints;
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

  Future<void> markHabitSynced(String habitId) =>
      (update(habits)..where((h) => h.habitId.equals(habitId))).write(
        HabitsCompanion(
          updatedAt: Value(DateTime.now()),
          isSynced: const Value(true),
        ),
      );

  Future<void> markLogSynced(String logId) =>
      (update(logs)..where((l) => l.logId.equals(logId))).write(
        LogsCompanion(
          updatedAt: Value(DateTime.now()),
          isSynced: const Value(true),
        ),
      );

  // ---------------------------------------------------------------------------
  // Quote operations
  // ---------------------------------------------------------------------------

  Future<void> cacheQuote(String text) async {
    final normalized = text.trim();
    if (normalized.isEmpty) return;
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    await transaction(() async {
      await (delete(
        cachedQuotes,
      )..where((q) => q.fetchedAt.isBiggerOrEqualValue(startOfDay))).go();
      await into(cachedQuotes).insert(
        CachedQuotesCompanion(
          quoteText: Value(normalized),
          fetchedAt: Value(now),
        ),
      );
    });
  }

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
  // Usage diagnostics
  // ---------------------------------------------------------------------------

  Future<void> incrementUsageAggregateBucket({
    required String bucketDate,
    required String platform,
    required String buildChannel,
    required String screenName,
    required String metricName,
    required int countDelta,
    required int durationMsDelta,
    required DateTime updatedAt,
  }) async {
    await customStatement(
      '''
      INSERT INTO usage_aggregate_buckets (
        bucket_date,
        platform,
        build_channel,
        screen_name,
        metric_name,
        count,
        total_duration_ms,
        updated_at
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      ON CONFLICT(bucket_date, platform, build_channel, screen_name, metric_name)
      DO UPDATE SET
        count = usage_aggregate_buckets.count + excluded.count,
        total_duration_ms = usage_aggregate_buckets.total_duration_ms + excluded.total_duration_ms,
        updated_at = excluded.updated_at
      ''',
      [
        bucketDate,
        platform,
        buildChannel,
        screenName,
        metricName,
        countDelta,
        durationMsDelta,
        updatedAt.millisecondsSinceEpoch,
      ],
    );
  }

  Future<List<UsageAggregateBucket>> getUsageAggregateBuckets() =>
      (select(usageAggregateBuckets)..orderBy([
            (t) => OrderingTerm.desc(t.bucketDate),
            (t) => OrderingTerm.asc(t.screenName),
            (t) => OrderingTerm.asc(t.metricName),
          ]))
          .get();

  Future<List<UsageAggregateBucket>> getPendingUsageAggregateBuckets() =>
      (select(usageAggregateBuckets)..where(
            (t) =>
                t.count.isBiggerThan(t.uploadedCount) |
                t.totalDurationMs.isBiggerThan(t.uploadedTotalDurationMs),
          ))
          .get();

  Future<void> markUsageAggregateBucketUploaded(UsageAggregateBucket row) =>
      (update(usageAggregateBuckets)..where(
            (t) =>
                t.bucketDate.equals(row.bucketDate) &
                t.platform.equals(row.platform) &
                t.buildChannel.equals(row.buildChannel) &
                t.screenName.equals(row.screenName) &
                t.metricName.equals(row.metricName),
          ))
          .write(
            UsageAggregateBucketsCompanion(
              uploadedCount: Value(row.count),
              uploadedTotalDurationMs: Value(row.totalDurationMs),
              updatedAt: Value(DateTime.now().toUtc()),
            ),
          );

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

  Future<void> reconcilePendingHabitInvitations(
    Set<String> validInvitationIds,
  ) async {
    final query = delete(habitInvitations)
      ..where(
        (invitation) =>
            invitation.status.equals('pending') &
            (validInvitationIds.isEmpty
                ? const Constant(true)
                : invitation.invitationId.isNotIn(validInvitationIds)),
      );
    await query.go();
  }

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

  /// Coalesce a received nudge into the local partner snapshot read model.
  Future<void> markPartnerNudgeReceived(
    String partnerUserId, {
    String? habitId,
    DateTime? nudgedAt,
  }) {
    final updateStatement = update(partnerSnapshots)
      ..where((s) => s.partnerUserId.equals(partnerUserId));
    if (habitId != null && habitId.isNotEmpty) {
      updateStatement.where((s) => s.habitId.equals(habitId));
    }

    return updateStatement.write(
      PartnerSnapshotsCompanion(
        lastNudgeAt: Value(nudgedAt ?? DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

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

  Future<void> removeAcceptedFriend(String friendUserId) => (delete(
    acceptedFriends,
  )..where((friend) => friend.friendUserId.equals(friendUserId))).go();

  Future<void> clearAcceptedFriends() => delete(acceptedFriends).go();

  Future<void> replaceAcceptedFriends(
    Iterable<AcceptedFriendsCompanion> friends,
  ) async {
    await transaction(() async {
      await clearAcceptedFriends();
      for (final friend in friends) {
        await into(acceptedFriends).insertOnConflictUpdate(friend);
      }
    });
  }

  Future<AcceptedFriend?> getAcceptedFriend(String friendUserId) => (select(
    acceptedFriends,
  )..where((f) => f.friendUserId.equals(friendUserId))).getSingleOrNull();

  Stream<List<AcceptedFriend>> watchAcceptedFriends() =>
      select(acceptedFriends).watch();

  Future<void> upsertFriendRelationship(
    FriendRelationshipsCompanion relationship,
  ) => into(friendRelationships).insertOnConflictUpdate(relationship);

  Future<void> cacheFriendRelationship({
    required String userId,
    required String username,
    required String relationshipState,
    String? avatarUrl,
    String? requestId,
  }) {
    return upsertFriendRelationship(
      FriendRelationshipsCompanion(
        userId: Value(userId),
        username: Value(username),
        avatarUrl: Value(avatarUrl),
        relationshipState: Value(relationshipState),
        requestId: Value(requestId),
        updatedAt: Value(DateTime.now()),
        isSynced: const Value(true),
      ),
    );
  }

  Future<void> updateFriendRelationshipState({
    required String userId,
    required String relationshipState,
    String? requestId,
  }) {
    return (update(
      friendRelationships,
    )..where((relationship) => relationship.userId.equals(userId))).write(
      FriendRelationshipsCompanion(
        relationshipState: Value(relationshipState),
        requestId: Value(requestId),
        updatedAt: Value(DateTime.now()),
        isSynced: const Value(true),
      ),
    );
  }

  Future<void> clearPendingIncomingFriendRelationships() =>
      (delete(friendRelationships)..where(
            (relationship) =>
                relationship.relationshipState.equals('pending_incoming'),
          ))
          .go();

  Future<void> reconcilePendingIncomingFriendRelationships(
    Set<String> validUserIds,
  ) async {
    final query = delete(friendRelationships)
      ..where(
        (relationship) =>
            relationship.relationshipState.equals('pending_incoming') &
            (validUserIds.isEmpty
                ? const Constant(true)
                : relationship.userId.isNotIn(validUserIds)),
      );
    await query.go();
  }

  Stream<List<FriendRelationship>> watchPendingIncomingFriendRelationships() =>
      (select(friendRelationships)
            ..where(
              (relationship) =>
                  relationship.relationshipState.equals('pending_incoming'),
            )
            ..orderBy([
              (relationship) => OrderingTerm.desc(relationship.updatedAt),
            ]))
          .watch();

  Future<void> removeSelfFromSocialCaches(String currentUserId) async {
    await (delete(
      acceptedFriends,
    )..where((f) => f.friendUserId.equals(currentUserId))).go();
    await (delete(
      friendRelationships,
    )..where((r) => r.userId.equals(currentUserId))).go();
  }

  // ---------------------------------------------------------------------------
  // Achievement operations
  // ---------------------------------------------------------------------------

  Future<void> upsertAchievementUnlock(AchievementUnlocksCompanion unlock) =>
      into(achievementUnlocks).insertOnConflictUpdate(unlock);

  Stream<List<AchievementUnlock>> watchAchievementUnlocks(String userId) =>
      (select(achievementUnlocks)
            ..where((a) => a.userId.equals(userId))
            ..orderBy([(a) => OrderingTerm.desc(a.unlockedAt)]))
          .watch();

  // ---------------------------------------------------------------------------
  // Notification center operations
  // ---------------------------------------------------------------------------

  Future<void> upsertNotificationEvent(NotificationEventsCompanion event) =>
      into(notificationEvents).insertOnConflictUpdate(event);

  Stream<List<NotificationEvent>> watchNotificationsForUser(String userId) =>
      (select(notificationEvents)
            ..where((n) => n.userId.equals(userId))
            ..orderBy([(n) => OrderingTerm.desc(n.createdAt)]))
          .watch();

  Stream<List<NotificationEvent>> watchUnreadNotificationsForUser(
    String userId,
  ) =>
      (select(notificationEvents)
            ..where((n) => n.userId.equals(userId) & n.readAt.isNull())
            ..orderBy([(n) => OrderingTerm.desc(n.createdAt)]))
          .watch();

  Future<List<NotificationEvent>> getUnreadNotificationsForUser(
    String userId,
  ) =>
      (select(notificationEvents)
            ..where((n) => n.userId.equals(userId) & n.readAt.isNull())
            ..orderBy([(n) => OrderingTerm.desc(n.createdAt)]))
          .get();

  Future<void> markNotificationRead(String notificationId) =>
      (update(
        notificationEvents,
      )..where((n) => n.notificationId.equals(notificationId))).write(
        NotificationEventsCompanion(
          readAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<void> markAllNotificationsRead(String userId) {
    final now = DateTime.now();
    return (update(
      notificationEvents,
    )..where((n) => n.userId.equals(userId) & n.readAt.isNull())).write(
      NotificationEventsCompanion(readAt: Value(now), updatedAt: Value(now)),
    );
  }

  Future<void> deleteExpiredNotificationEvents() =>
      (delete(notificationEvents)..where(
            (n) =>
                n.expiresAt.isNotNull() &
                n.expiresAt.isSmallerThanValue(DateTime.now()),
          ))
          .go();

  Future<void> reconcileNotificationEventsForType({
    required String userId,
    required NotificationEventType type,
    required Set<String> validNotificationIds,
  }) async {
    final query = delete(notificationEvents)
      ..where(
        (notification) =>
            notification.userId.equals(userId) &
            notification.type.equalsValue(type) &
            (validNotificationIds.isEmpty
                ? const Constant(true)
                : notification.notificationId.isNotIn(validNotificationIds)),
      );
    await query.go();
  }

  // ---------------------------------------------------------------------------
  // Reminder settings operations
  // ---------------------------------------------------------------------------

  Future<int> insertReminderSetting(ReminderSettingsCompanion setting) =>
      into(reminderSettings).insert(setting);

  Future<void> updateReminderSetting(ReminderSetting setting) =>
      update(reminderSettings).replace(setting);

  Future<void> deleteReminderSetting(int id) =>
      (delete(reminderSettings)..where((r) => r.id.equals(id))).go();

  Future<List<ReminderSetting>> getReminderSettings(
    String userId,
    ReminderType type,
  ) =>
      (select(reminderSettings)
            ..where((r) => r.userId.equals(userId) & r.type.equalsValue(type))
            ..orderBy([
              (r) => OrderingTerm(expression: r.hour),
              (r) => OrderingTerm(expression: r.minute),
            ]))
          .get();

  Stream<List<ReminderSetting>> watchReminderSettings(
    String userId,
    ReminderType type,
  ) =>
      (select(reminderSettings)
            ..where((r) => r.userId.equals(userId) & r.type.equalsValue(type))
            ..orderBy([
              (r) => OrderingTerm(expression: r.hour),
              (r) => OrderingTerm(expression: r.minute),
            ]))
          .watch();

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
