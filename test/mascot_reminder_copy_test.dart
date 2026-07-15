import 'package:flutter_test/flutter_test.dart';
import 'package:hable/data/mascot_reminder_copy.dart';
import 'package:hable/database/tables.dart';

void main() {
  group('MascotReminderCopyHelper', () {
    test('returns deterministic generic copy for the same date', () {
      final date1 = DateTime(2026, 1, 1);

      final copy1 = MascotReminderCopyHelper.getCopyForType(
        ReminderType.dailyHabit,
        now: date1,
      );

      final copy2 = MascotReminderCopyHelper.getCopyForType(
        ReminderType.dailyHabit,
        now: date1,
      );

      expect(copy1.title, equals(copy2.title));
      expect(copy1.body, equals(copy2.body));
    });

    test('returns a recent-skip reminder branch when applicable', () {
      final copy = MascotReminderCopyHelper.getCopyForType(
        ReminderType.dailyHabit,
        now: DateTime(2026, 1, 1, 10),
        context: const CopyPersonalizationContext(hasRecentSkip: true),
      );

      expect(copy.title, anyOf('Pick it back up', 'Reset the rhythm'));
    });

    test('prefers social reminder copy over a generic rotation', () {
      final copy = MascotReminderCopyHelper.getCopyForType(
        ReminderType.dailyHabit,
        now: DateTime(2026, 1, 1, 10),
        context: const CopyPersonalizationContext(recentNudgeCount: 1),
      );

      expect(copy.title, anyOf('Your circle is moving', 'Shared momentum'));
    });

    test('returns different generic variations over time', () {
      final date1 = DateTime(2026, 1, 1);
      final date2 = DateTime(2026, 1, 2);

      final copy1 = MascotReminderCopyHelper.getCopyForType(
        ReminderType.dailyHabit,
        now: date1,
      );

      final copy2 = MascotReminderCopyHelper.getCopyForType(
        ReminderType.dailyHabit,
        now: date2,
      );

      expect(copy1.title, isNot(equals(copy2.title)));
    });
  });

  group('quoteForContext', () {
    test('uses recent-skip quote branch first', () {
      final quote = MascotReminderCopyHelper.quoteForContext(
        const CopyPersonalizationContext(hasRecentSkip: true),
        now: DateTime(2026, 1, 1),
      );

      expect(quote.text, contains('Abraham Lincoln'));
    });

    test('uses social quote branch ahead of streak branch', () {
      final quote = MascotReminderCopyHelper.quoteForContext(
        const CopyPersonalizationContext(
          longestStreak: 12,
          recentNudgeCount: 1,
        ),
        now: DateTime(2026, 1, 2),
      );

      expect(quote.text, contains('Johann Wolfgang von Goethe'));
    });

    test('falls back to a stable generic quote when no context matches', () {
      final quote1 = MascotReminderCopyHelper.quoteForContext(
        const CopyPersonalizationContext(hasActiveHabits: true),
        now: DateTime(2026, 1, 3),
      );
      final quote2 = MascotReminderCopyHelper.quoteForContext(
        const CopyPersonalizationContext(hasActiveHabits: true),
        now: DateTime(2026, 1, 3),
      );

      expect(quote1, equals(quote2));
      expect(quote1.text, isNotEmpty);
    });
  });
}
