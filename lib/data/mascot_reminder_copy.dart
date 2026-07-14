import '../database/tables.dart';
import '../models/daily_quote.dart';
import 'fallback_quotes.dart';

class ReminderCopy {
  final String title;
  final String body;

  const ReminderCopy(this.title, this.body);
}

class CopyPersonalizationContext {
  final bool hasActiveHabits;
  final bool hasRecentSkip;
  final int longestStreak;
  final int recentNudgeCount;
  final int partnerCompletionsToday;
  final int completedTodayCount;

  const CopyPersonalizationContext({
    this.hasActiveHabits = false,
    this.hasRecentSkip = false,
    this.longestStreak = 0,
    this.recentNudgeCount = 0,
    this.partnerCompletionsToday = 0,
    this.completedTodayCount = 0,
  });

  bool get hasSocialMomentum =>
      recentNudgeCount > 0 || partnerCompletionsToday > 0;
}

class MascotReminderCopyHelper {
  static ReminderCopy getCopyForType(
    ReminderType type, {
    DateTime? now,
    CopyPersonalizationContext context = const CopyPersonalizationContext(),
  }) {
    final date = now ?? DateTime.now();
    final seed = date.year * 1000 + date.month * 100 + date.day;

    switch (type) {
      case ReminderType.dailyHabit:
        return _dailyHabitCopyForContext(context, date, seed);
    }
  }

  static DailyQuote quoteForContext(
    CopyPersonalizationContext context, {
    DateTime? now,
  }) {
    final date = now ?? DateTime.now();
    final seed = date.year * 1000 + date.month * 100 + date.day;

    if (context.hasRecentSkip) {
      return DailyQuote(text: _recentSkipQuotes[seed % _recentSkipQuotes.length]);
    }
    if (context.hasSocialMomentum) {
      return DailyQuote(text: _socialMomentumQuotes[seed % _socialMomentumQuotes.length]);
    }
    if (context.longestStreak >= 7) {
      return DailyQuote(text: _streakQuotes[seed % _streakQuotes.length]);
    }
    if (!context.hasActiveHabits) {
      return DailyQuote(text: _freshStartQuotes[seed % _freshStartQuotes.length]);
    }

    return fallbackQuoteForSeed(seed);
  }

  static ReminderCopy _dailyHabitCopyForContext(
    CopyPersonalizationContext context,
    DateTime date,
    int seed,
  ) {
    if (context.hasRecentSkip) {
      return _recentSkipReminderCopies[seed % _recentSkipReminderCopies.length];
    }
    if (context.hasSocialMomentum) {
      return _socialReminderCopies[seed % _socialReminderCopies.length];
    }
    if (context.longestStreak >= 7) {
      return _streakReminderCopies[seed % _streakReminderCopies.length];
    }
    if (date.hour < 9) {
      return _earlyReminderCopies[seed % _earlyReminderCopies.length];
    }
    if (date.hour >= 21) {
      return _lateReminderCopies[seed % _lateReminderCopies.length];
    }
    return _dailyHabitCopies[seed % _dailyHabitCopies.length];
  }

  static const _dailyHabitCopies = [
    ReminderCopy('Hable time!', 'Open Hable and check today\'s habits.'),
    ReminderCopy('Your daily check-in', 'Take a moment for your habits.'),
    ReminderCopy('Stay on track', 'Don\'t forget your daily habits!'),
    ReminderCopy('Habit time!', 'Let\'s get those habits done.'),
    ReminderCopy('A gentle nudge', 'Time to review your daily goals.'),
  ];

  static const _earlyReminderCopies = [
    ReminderCopy(
      'Start softly',
      'A small morning check-in can steady the day.',
    ),
    ReminderCopy('Before the rush', 'Take a quiet moment for today\'s habit.'),
  ];

  static const _lateReminderCopies = [
    ReminderCopy('Close the loop', 'There is still time to land today well.'),
    ReminderCopy(
      'One calm check-in',
      'A quick habit review can finish the day.',
    ),
  ];

  static const _recentSkipReminderCopies = [
    ReminderCopy('Pick it back up', 'Yesterday slipped. Today still counts.'),
    ReminderCopy(
      'Reset the rhythm',
      'One check-in is enough to restart momentum.',
    ),
  ];

  static const _socialReminderCopies = [
    ReminderCopy(
      'Your circle is moving',
      'A partner touched base. Meet them in today\'s check-in.',
    ),
    ReminderCopy(
      'Shared momentum',
      'Someone around you is active. Add your check-in too.',
    ),
  ];

  static const _streakReminderCopies = [
    ReminderCopy(
      'Keep the streak warm',
      'You have momentum. Protect it with today\'s check-in.',
    ),
    ReminderCopy('Streak in motion', 'A quick check-in keeps your run alive.'),
  ];

  static const _recentSkipQuotes = [
    'A stumble is not a fall. Get back up.',
    'Missing a day does not erase your progress. Return gently.',
    'Rest happened. Now begin again.',
    'Progress bends. It does not break here.',
  ];

  static const _socialMomentumQuotes = [
    'Shared effort travels farther than solo pressure.',
    'Support counts. Let today be one answered nudge.',
    'Momentum can be borrowed. Use the energy around you.',
    'Someone showed up in your orbit. Meet them halfway.',
  ];

  static const _streakQuotes = [
    'Consistency is getting louder than doubt.',
    'The streak is proof that ordinary days compound.',
    'You do not need a perfect day. You need the next one.',
    'Momentum becomes identity when you keep returning.',
  ];

  static const _freshStartQuotes = [
    'Every habit starts smaller than the life it changes.',
    'A new routine begins with one unremarkable repeat.',
    'Today is enough for a first step.',
    'You can build the rhythm before you feel ready.',
  ];
}

DailyQuote fallbackQuoteForSeed(int seed) {
  if (fallbackQuotes.isEmpty) {
    return const DailyQuote(text: 'Small steps every day.');
  }
  return DailyQuote(text: fallbackQuotes[seed % fallbackQuotes.length]);
}
