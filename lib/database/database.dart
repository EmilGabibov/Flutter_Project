import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Users, Habits, Logs, Partnerships, SyncQueue, CachedQuotes, SearchDocuments])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Bump this when the schema changes.
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.createTable(searchDocuments);
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
      (select(habits)
            ..where(
                (h) => h.userId.equals(userId) & h.status.equalsValue(HabitStatus.active)))
          .watch();

  Stream<List<Habit>> watchAllHabits(String userId) =>
      (select(habits)..where((h) => h.userId.equals(userId))).watch();

  Future<Habit?> getHabit(String habitId) =>
      (select(habits)..where((h) => h.habitId.equals(habitId)))
          .getSingleOrNull();

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

    return (select(logs)
          ..where((l) =>
              l.habitId.equals(habitId) &
              l.actionDate.isBiggerOrEqualValue(startOfDay) &
              l.actionDate.isSmallerThanValue(endOfDay)))
        .getSingleOrNull();
  }

  /// Get consecutive completed days for streak calculation.
  Future<int> getStreak(String habitId) async {
    final allLogs = await (select(logs)
          ..where((l) =>
              l.habitId.equals(habitId) & l.status.equalsValue(LogStatus.completed))
          ..orderBy([(l) => OrderingTerm.desc(l.actionDate)]))
        .get();

    if (allLogs.isEmpty) return 0;

    int streak = 0;
    DateTime checkDate = DateTime.now();

    for (final log in allLogs) {
      final logDay = DateTime(
          log.actionDate.year, log.actionDate.month, log.actionDate.day);
      final expectedDay =
          DateTime(checkDate.year, checkDate.month, checkDate.day)
              .subtract(Duration(days: streak));

      if (logDay == expectedDay || logDay == expectedDay.subtract(const Duration(days: 1))) {
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
    final userHabits = await (select(habits)
          ..where((h) => h.userId.equals(userId)))
        .get();

    final habitIds = userHabits.map((h) => h.habitId).toList();
    if (habitIds.isEmpty) return {'completed': 0, 'skipped': 0, 'overdue': 0};

    final allLogs = await (select(logs)
          ..where((l) => l.habitId.isIn(habitIds)))
        .get();

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
      final daysSinceCreation =
          DateTime.now().difference(habit.updatedAt).inDays;
      totalActiveDays += daysSinceCreation;
    }
    final overdue = (totalActiveDays - completed - skipped).clamp(0, 999999);

    return {'completed': completed, 'skipped': skipped, 'overdue': overdue};
  }

  /// 30-day point accumulation for line chart.
  Future<List<MapEntry<DateTime, int>>> get30DayPointHistory(
      String userId) async {
    final userHabits = await (select(habits)
          ..where((h) => h.userId.equals(userId)))
        .get();
    final habitIds = userHabits.map((h) => h.habitId).toList();
    if (habitIds.isEmpty) return [];

    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));

    final recentLogs = await (select(logs)
          ..where((l) =>
              l.habitId.isIn(habitIds) &
              l.status.equalsValue(LogStatus.completed) &
              l.actionDate.isBiggerOrEqualValue(thirtyDaysAgo))
          ..orderBy([(l) => OrderingTerm.asc(l.actionDate)]))
        .get();

    // Group by day, count completions * 10 points as a baseline
    final Map<DateTime, int> dayPoints = {};
    for (final log in recentLogs) {
      final day = DateTime(
          log.actionDate.year, log.actionDate.month, log.actionDate.day);
      dayPoints[day] = (dayPoints[day] ?? 0) + 10;
    }

    return dayPoints.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
  }

  // ---------------------------------------------------------------------------
  // Sync Queue operations
  // ---------------------------------------------------------------------------

  Future<void> enqueueSync(SyncQueueCompanion entry) =>
      into(syncQueue).insert(entry);

  Future<List<SyncQueueData>> getPendingSyncItems() =>
      (select(syncQueue)..where((s) => s.isProcessed.equals(false))).get();

  Future<void> markSyncProcessed(int id) =>
      (update(syncQueue)..where((s) => s.id.equals(id)))
          .write(const SyncQueueCompanion(isProcessed: Value(true)));

  // ---------------------------------------------------------------------------
  // Quote operations
  // ---------------------------------------------------------------------------

  Future<void> cacheQuote(String text) =>
      into(cachedQuotes).insert(CachedQuotesCompanion(
        quoteText: Value(text),
        fetchedAt: Value(DateTime.now()),
      ));

  Future<CachedQuote?> getTodaysQuote() {
    final startOfDay = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);
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
  // Search Document metadata operations
  // ---------------------------------------------------------------------------

  Future<void> insertSearchDocument(SearchDocumentsCompanion document) =>
      into(searchDocuments).insert(document, mode: InsertMode.insertOrReplace);

  Future<SearchDocument?> getSearchDocumentById(String documentId) =>
      (select(searchDocuments)..where((d) => d.documentId.equals(documentId)))
          .getSingleOrNull();

  Future<List<SearchDocument>> getSearchDocumentsByIds(List<String> documentIds) =>
      (select(searchDocuments)..where((d) => d.documentId.isIn(documentIds))).get();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'hable.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
