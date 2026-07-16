import 'package:flutter_test/flutter_test.dart';
import 'package:hable/database/database.dart';
import 'package:hable/database/tables.dart';
import 'package:hable/utils/habit_timeline.dart';

Habit _habit({
  required DateTime createdAt,
  required int targetDuration,
  required int currentDuration,
}) {
  return Habit(
    habitId: 'habit-1',
    title: 'Hydration',
    userId: 'user-1',
    isCustom: false,
    status: HabitStatus.active,
    colorHex: 'FF9CAF88',
    createdAt: createdAt,
    updatedAt: createdAt,
    isSynced: true,
    targetDuration: targetDuration,
    currentDuration: currentDuration,
  );
}

void main() {
  test('timeline day stays stable across same-day completion changes', () {
    final createdAt = DateTime(2026, 7, 10, 8, 30);
    final now = DateTime(2026, 7, 12, 21, 45);

    final beforeCheckIn = _habit(
      createdAt: createdAt,
      targetDuration: 7,
      currentDuration: 5,
    );
    final afterCheckIn = _habit(
      createdAt: createdAt,
      targetDuration: 7,
      currentDuration: 4,
    );

    expect(challengeTimelineDay(beforeCheckIn, now: now), 3);
    expect(challengeTimelineDay(afterCheckIn, now: now), 3);
  });

  test('timeline day advances on the next local calendar day', () {
    final createdAt = DateTime(2026, 7, 10, 23, 55);
    final sameDay = _habit(
      createdAt: createdAt,
      targetDuration: 7,
      currentDuration: 5,
    );

    expect(
      challengeTimelineDay(sameDay, now: DateTime(2026, 7, 10, 23, 58)),
      1,
    );
    expect(challengeTimelineDay(sameDay, now: DateTime(2026, 7, 11, 0, 1)), 2);
  });

  test('timeline converts a synced UTC start timestamp to the local day', () {
    final localStart = DateTime(2026, 7, 10, 23, 30);
    final habit = _habit(
      createdAt: localStart.toUtc(),
      targetDuration: 7,
      currentDuration: 7,
    );

    expect(challengeTimelineDay(habit, now: localStart), 1);
  });

  test('day-boundary refresh delay targets the next local midnight', () {
    expect(
      timeUntilNextLocalDay(DateTime(2026, 7, 10, 23, 59, 30)),
      const Duration(seconds: 30),
    );
    expect(
      timeUntilNextLocalDay(DateTime(2026, 7, 10, 8, 15)),
      const Duration(hours: 15, minutes: 45),
    );
  });

  test('progress fraction stays tied to earned completion count', () {
    final habit = _habit(
      createdAt: DateTime(2026, 7, 10, 8, 30),
      targetDuration: 10,
      currentDuration: 7,
    );

    expect(challengeProgressDay(habit), 4);
    expect(challengeProgressFraction(habit), 0.3);
  });

  test(
    'timeline day clamps to challenge duration and progress clamps safely',
    () {
      final habit = _habit(
        createdAt: DateTime(2026, 7, 1, 9),
        targetDuration: 5,
        currentDuration: 9,
      );

      expect(challengeTimelineDay(habit, now: DateTime(2026, 7, 20, 10)), 5);
      expect(challengeProgressFraction(habit), 0.0);
      expect(challengeProgressDay(habit), 1);
    },
  );
}
