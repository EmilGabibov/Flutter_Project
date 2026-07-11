import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/database/database.dart';
import 'package:hable/database/tables.dart';

void main() {
  test(
    'completeHabitDay decrements remaining days and completes at zero',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      const userId = 'user-1';
      const habitId = 'habit-1';

      await db.insertUser(
        UsersCompanion.insert(userId: userId, username: 'Alice'),
      );

      await db.insertHabit(
        HabitsCompanion.insert(
          habitId: habitId,
          userId: userId,
          title: 'Hydration',
          isCustom: const Value(false),
          targetDuration: 3,
          currentDuration: 3,
          status: HabitStatus.active,
        ),
      );

      await db.completeHabitDay(habitId);
      final afterOne = await db.getHabit(habitId);
      expect(afterOne, isNotNull);
      expect(afterOne!.currentDuration, 2);
      expect(afterOne.status, HabitStatus.active);
      expect(afterOne.isSynced, isFalse);

      await db.completeHabitDay(habitId);
      final afterTwo = await db.getHabit(habitId);
      expect(afterTwo, isNotNull);
      expect(afterTwo!.currentDuration, 1);
      expect(afterTwo.status, HabitStatus.active);

      await db.completeHabitDay(habitId);
      final afterThree = await db.getHabit(habitId);
      expect(afterThree, isNotNull);
      expect(afterThree!.currentDuration, 0);
      expect(afterThree.status, HabitStatus.completed);
    },
  );

  test('completeHabitDay can keep shared habit cards active at zero', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    const userId = 'partner-1';
    const habitId = 'shared-habit-1';

    await db.insertUser(UsersCompanion.insert(userId: userId, username: 'Bob'));

    await db.insertHabit(
      HabitsCompanion.insert(
        habitId: habitId,
        userId: userId,
        title: 'Shared Cooking',
        isCustom: const Value(false),
        targetDuration: 1,
        currentDuration: 1,
        status: HabitStatus.active,
      ),
    );

    await db.completeHabitDay(habitId, keepActiveWhenDurationEnds: true);

    final sharedHabit = await db.getHabit(habitId);
    expect(sharedHabit, isNotNull);
    expect(sharedHabit!.currentDuration, 0);
    expect(sharedHabit.status, HabitStatus.active);

    final activeHabits = await db.watchActiveHabits(userId).first;
    expect(activeHabits.map((habit) => habit.habitId), contains(habitId));
  });

  test('markPartnerNudgeReceived coalesces by partner and habit', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    const habitId = 'habit-1';
    const otherHabitId = 'habit-2';
    const partnerId = 'partner-1';
    final firstNudge = DateTime(2026, 7, 11, 12);
    final secondNudge = DateTime(2026, 7, 11, 13);

    await db.upsertPartnerSnapshot(
      PartnerSnapshotsCompanion.insert(
        habitId: habitId,
        partnerUserId: partnerId,
        username: 'Alice',
        role: const Value(PartnershipRole.partner),
      ),
    );
    await db.upsertPartnerSnapshot(
      PartnerSnapshotsCompanion.insert(
        habitId: otherHabitId,
        partnerUserId: partnerId,
        username: 'Alice',
        role: const Value(PartnershipRole.partner),
      ),
    );

    await db.markPartnerNudgeReceived(
      partnerId,
      habitId: habitId,
      nudgedAt: firstNudge,
    );
    await db.markPartnerNudgeReceived(
      partnerId,
      habitId: habitId,
      nudgedAt: secondNudge,
    );

    final nudgedHabit = await db.watchPartnersByHabit(habitId).first;
    final untouchedHabit = await db.watchPartnersByHabit(otherHabitId).first;

    expect(nudgedHabit.single.lastNudgeAt, secondNudge);
    expect(untouchedHabit.single.lastNudgeAt, isNull);
  });
}
