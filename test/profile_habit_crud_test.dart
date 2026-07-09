import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/database/database.dart';
import 'package:hable/database/tables.dart';
import 'package:hable/providers/database_provider.dart';
import 'package:hable/providers/habit_providers.dart';

void main() {
  test('profile habit CRUD updates local state, provider streams, and sync payloads', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    const userId = 'user-1';
    await db.insertUser(
      UsersCompanion.insert(
        userId: userId,
        username: 'Alice',
      ),
    );

    final container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    final observedHabitLists = <List<Habit>>[];
    final subscription = container.listen<AsyncValue<List<Habit>>>(
      allHabitsProvider(userId),
      (previous, next) {
        if (next.hasValue) {
          observedHabitLists.add(next.requireValue);
        }
      },
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    final habitId = await db.createHabitWithSync(
      'Hydration',
      21,
      false,
      'FF9CAF88',
      userId,
    );

    await pumpEventQueue();

    final createdHabit = await db.getHabit(habitId);
    expect(createdHabit, isNotNull);
    expect(createdHabit!.title, 'Hydration');
    expect(createdHabit.status, HabitStatus.active);

    final createQueue = await db.getPendingSyncItems();
    expect(createQueue, hasLength(1));
    final createPayload = jsonDecode(createQueue.single.payload) as Map<String, dynamic>;
    expect(createPayload['habit_id'], habitId);
    expect(createPayload['status'], 'active');

    expect(container.read(allHabitsProvider(userId)).value, isNotNull);
    expect(container.read(allHabitsProvider(userId)).value, hasLength(1));
    expect(observedHabitLists, isNotEmpty);
    expect(observedHabitLists.last.single.habitId, habitId);

    await db.updateHabitDetails(
      habitId,
      'Hydration+',
      30,
      'FFB8C5D6',
    );

    await pumpEventQueue();

    final updatedHabit = await db.getHabit(habitId);
    expect(updatedHabit, isNotNull);
    expect(updatedHabit!.title, 'Hydration+');
    expect(updatedHabit.targetDuration, 30);
    expect(updatedHabit.colorHex, 'FFB8C5D6');
    expect(updatedHabit.status, HabitStatus.active);

    final updateQueue = await db.getPendingSyncItems();
    expect(updateQueue, hasLength(2));
    final updatePayload = jsonDecode(updateQueue.last.payload) as Map<String, dynamic>;
    expect(updatePayload['habit_id'], habitId);
    expect(updatePayload['title'], 'Hydration+');
    expect(updatePayload['status'], 'active');

    await db.archiveHabit(habitId);

    await pumpEventQueue();

    final archivedHabit = await db.getHabit(habitId);
    expect(archivedHabit, isNotNull);
    expect(archivedHabit!.status, HabitStatus.abandoned);

    final archiveQueue = await db.getPendingSyncItems();
    expect(archiveQueue, hasLength(3));
    final archivePayload = jsonDecode(archiveQueue.last.payload) as Map<String, dynamic>;
    expect(archivePayload['habit_id'], habitId);
    expect(archivePayload['status'], 'abandoned');

    expect(container.read(allHabitsProvider(userId)).value, isNotNull);
    expect(container.read(allHabitsProvider(userId)).value!.single.status, HabitStatus.abandoned);

    await db.restoreHabit(habitId);

    await pumpEventQueue();

    final restoredHabit = await db.getHabit(habitId);
    expect(restoredHabit, isNotNull);
    expect(restoredHabit!.status, HabitStatus.active);

    final restoreQueue = await db.getPendingSyncItems();
    expect(restoreQueue, hasLength(4));
    final restorePayload = jsonDecode(restoreQueue.last.payload) as Map<String, dynamic>;
    expect(restorePayload['habit_id'], habitId);
    expect(restorePayload['status'], 'active');

    expect(container.read(allHabitsProvider(userId)).value, isNotNull);
    expect(container.read(allHabitsProvider(userId)).value!.single.status, HabitStatus.active);
    expect(observedHabitLists.last.single.status, HabitStatus.active);
  });
}
