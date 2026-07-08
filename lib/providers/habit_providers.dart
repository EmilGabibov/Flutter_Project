import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';
import 'database_provider.dart';

/// Watches the current user profile from Drift.
final currentUserProvider = StreamProvider<User?>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchCurrentUser();
});

/// Watches all ACTIVE habits for the current user.
final activeHabitsProvider =
    StreamProvider.family<List<Habit>, String>((ref, userId) {
  final db = ref.watch(databaseProvider);
  return db.watchActiveHabits(userId);
});

/// Watches ALL habits (for the Profile screen).
final allHabitsProvider =
    StreamProvider.family<List<Habit>, String>((ref, userId) {
  final db = ref.watch(databaseProvider);
  return db.watchAllHabits(userId);
});

/// Watches logs for a specific habit.
final habitLogsProvider =
    StreamProvider.family<List<Log>, String>((ref, habitId) {
  final db = ref.watch(databaseProvider);
  return db.watchLogsForHabit(habitId);
});

/// Fetches today's log for a habit (to check if already completed/skipped).
final todaysLogProvider =
    FutureProvider.family<Log?, String>((ref, habitId) {
  final db = ref.watch(databaseProvider);
  return db.getTodaysLog(habitId);
});

/// Fetches the current streak for a habit.
final streakProvider =
    FutureProvider.family<int, String>((ref, habitId) {
  final db = ref.watch(databaseProvider);
  return db.getStreak(habitId);
});

/// Fetches log distribution for analytics pie chart.
final logDistributionProvider =
    FutureProvider.family<Map<String, int>, String>((ref, userId) {
  final db = ref.watch(databaseProvider);
  return db.getLogDistribution(userId);
});

/// Fetches 30-day point history for analytics line chart.
final pointHistoryProvider =
    FutureProvider.family<List<MapEntry<DateTime, int>>, String>((ref, userId) {
  final db = ref.watch(databaseProvider);
  return db.get30DayPointHistory(userId);
});
