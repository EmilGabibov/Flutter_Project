import '../database/database.dart';

DateTime _localDate(DateTime value) {
  final local = value.isUtc ? value.toLocal() : value;
  return DateTime(local.year, local.month, local.day);
}

Duration timeUntilNextLocalDay(DateTime now) {
  final tomorrow = DateTime(now.year, now.month, now.day + 1);
  return tomorrow.difference(now);
}

int challengeTimelineDay(Habit habit, {DateTime? now}) {
  final total = habit.targetDuration > 0 ? habit.targetDuration : 1;
  final today = _localDate(now ?? DateTime.now());
  final start = _localDate(habit.createdAt);
  final elapsedDays = today.difference(start).inDays;
  return (elapsedDays + 1).clamp(1, total);
}

int challengeProgressDay(Habit habit) {
  final total = habit.targetDuration > 0 ? habit.targetDuration : 1;
  final completedCheckIns = (total - habit.currentDuration).clamp(0, total);
  return (completedCheckIns + 1).clamp(1, total);
}

double challengeProgressFraction(Habit habit) {
  final total = habit.targetDuration;
  if (total <= 0) return 0.0;
  final completedCheckIns = (total - habit.currentDuration).clamp(0, total);
  return (completedCheckIns / total).clamp(0.0, 1.0);
}
