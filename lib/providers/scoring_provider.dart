/// Deprecated local score helper.
///
/// Server-side gamification is authoritative. Keep this only for old imports or
/// isolated display estimates; never use it to update leaderboard totals.
@Deprecated('Use /api/sync/daily gamification from SyncService instead.')
class ScoringEngine {
  static const int _basePoints = 5;

  /// Estimate points earned for a single completion.
  static int calculateCompletionPoints({
    required int currentStreak,
    required int currentDay,
  }) {
    return _basePoints;
  }

  /// Calculate total cumulative score from a list of daily completions.
  static int calculateTotalScore({
    required int completedDays,
    required int longestStreak,
  }) {
    int total = 0;
    for (int day = 1; day <= completedDays; day++) {
      total += calculateCompletionPoints(
        currentStreak: longestStreak,
        currentDay: day,
      );
    }
    return total;
  }
}
