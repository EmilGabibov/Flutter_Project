/// Scoring engine per spec 04 §5.
///
/// +10 base points per completion.
/// +1% multiplier per consecutive day streak.
/// +50 milestone bonus at Day 7, 21, and 66.
/// No point deduction for skipping (penalty is temporal: +2 days).
class ScoringEngine {
  static const int _basePoints = 10;
  static const int _milestoneBonus = 50;
  static const Set<int> _milestoneDays = {7, 21, 66};

  /// Calculate points earned for a single completion.
  static int calculateCompletionPoints({
    required int currentStreak,
    required int currentDay,
  }) {
    // Base points with streak multiplier
    final multiplier = 1.0 + (currentStreak * 0.01);
    int points = (_basePoints * multiplier).round();

    // Milestone bonus
    if (_milestoneDays.contains(currentDay)) {
      points += _milestoneBonus;
    }

    return points;
  }

  /// Calculate total cumulative score from a list of daily completions.
  static int calculateTotalScore({
    required int completedDays,
    required int longestStreak,
  }) {
    int total = 0;
    int currentStreak = 0;

    for (int day = 1; day <= completedDays; day++) {
      if (currentStreak < longestStreak) {
        currentStreak++;
      }
      total += calculateCompletionPoints(
        currentStreak: currentStreak,
        currentDay: day,
      );
    }
    return total;
  }
}
