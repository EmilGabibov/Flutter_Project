import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hable/screens/completion_splash_screen.dart';
import 'package:hable/models/daily_quote.dart';
import 'package:hable/database/database.dart';
import 'package:hable/database/tables.dart' show HabitStatus;
import 'package:hable/models/celebration_feedback.dart';
import 'package:hable/providers/quote_provider.dart';
import 'package:hable/l10n/app_localizations.dart';

void main() {
  testWidgets('CompletionSplashScreen renders habit info and daily quote', (
    tester,
  ) async {
    final testHabit = Habit(
      habitId: 'test_habit_1',
      userId: 'user1',
      title: 'Morning Yoga',
      isCustom: false,
      targetDuration: 30,
      currentDuration: 30,
      status: HabitStatus.active,
      colorHex: 'FF9CAF88',
      updatedAt: DateTime.now(),
      createdAt: DateTime.now(),
      isSynced: false,
    );

    // Provide a mocked quote
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          quoteProvider.overrideWith(
            (ref) => Future.value(
              const DailyQuote(
                text: 'Testing is believing.',
                author: 'Test Author',
              ),
            ),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: CompletionSplashScreen(
            habit: testHabit,
            emoji: '🧘‍♂️',
            pointsEarned: 5,
          ),
        ),
      ),
    );

    // Initial state might be waiting for the animation to start
    await tester.pump();

    expect(find.text('🧘‍♂️'), findsOneWidget);
    expect(find.text('Great job!'), findsOneWidget);
    expect(find.text('You completed Morning Yoga today.'), findsOneWidget);
    expect(find.text('5 points earned'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);

    // Wait for quote future to resolve
    await tester.pumpAndSettle();

    final quoteFinder = find.textContaining('"Testing is believing."');
    final headlineFinder = find.text('Great job!');

    expect(quoteFinder, findsOneWidget);
    expect(find.textContaining('Test Author'), findsOneWidget);
    expect(
      tester.getTopLeft(quoteFinder).dy,
      lessThan(tester.getTopLeft(headlineFinder).dy),
    );
  });

  testWidgets('CompletionSplashScreen renders a shared milestone variant', (
    tester,
  ) async {
    final testHabit = Habit(
      habitId: 'test_habit_2',
      userId: 'user1',
      title: 'Hydration',
      isCustom: false,
      targetDuration: 21,
      currentDuration: 14,
      status: HabitStatus.active,
      colorHex: 'FF9CAF88',
      updatedAt: DateTime.now(),
      createdAt: DateTime.now(),
      isSynced: false,
    );

    final celebration = resolveCompletionCelebration(
      habit: testHabit,
      streakCount: 7,
      sharedBonusEarned: true,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          quoteProvider.overrideWith(
            (ref) =>
                Future.value(const DailyQuote(text: 'Momentum compounds.')),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: CompletionSplashScreen(
            habit: testHabit,
            celebration: celebration,
            pointsEarned: 10,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Shared milestone'), findsOneWidget);
    expect(find.text('Day 7 lands louder together.'), findsOneWidget);
    expect(find.text('10 points earned'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });
}
