import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/database/database.dart';
import 'package:hable/database/tables.dart';

void main() {
  testWidgets('HomeScreen SliverGrid smoke test', (tester) async {
    final habits = [
      Habit(
        habitId: 'habit-1',
        title: 'Drink Water',
        userId: 'u1',
        isCustom: false,
        status: HabitStatus.active,
        colorHex: 'FF9CAF88',
        updatedAt: DateTime(2026),
        createdAt: DateTime(2026),
        isSynced: true,
        targetDuration: 30, // 30 day challenge
        currentDuration: 0,
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 400,
                    mainAxisExtent: 216,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Card(child: Text(habits[index].title)),
                    childCount: habits.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Drink Water'), findsOneWidget);
    expect(find.byType(SliverGrid), findsOneWidget);
    expect(tester.getSize(find.byType(Card)).height, 216);
  });
}
