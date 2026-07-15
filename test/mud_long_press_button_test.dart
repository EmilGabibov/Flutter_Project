import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/l10n/app_localizations.dart';
import 'package:hable/models/habit_visual_state.dart';
import 'package:hable/widgets/mud_long_press_button.dart';

void main() {
  Widget buildTestSubject({
    required VoidCallback onCompletion,
    int durationMs = 1200,
    HabitVisualState visualState = HabitVisualState.idle,
    String? habitIcon,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(
          child: MudLongPressButton(
            resistanceCoefficient: 0.5,
            calculatedDurationMs: durationMs,
            onCompletion: onCompletion,
            visualState: visualState,
            habitIcon: habitIcon,
          ),
        ),
      ),
    );
  }

  testWidgets('early release cancels completion', (tester) async {
    var completions = 0;

    await tester.pumpWidget(
      buildTestSubject(onCompletion: () => completions += 1),
    );

    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(MudLongPressButton)),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await gesture.up();
    await tester.pumpAndSettle();

    expect(completions, 0);
  });

  testWidgets('full hold completes exactly once', (tester) async {
    var completions = 0;

    await tester.pumpWidget(
      buildTestSubject(onCompletion: () => completions += 1, durationMs: 600),
    );

    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(MudLongPressButton)),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump();
    expect(completions, 1);

    await gesture.up();
    await tester.pumpAndSettle();

    expect(completions, 1);
  });

  testWidgets('renders idle state with default icon', (tester) async {
    await tester.pumpWidget(buildTestSubject(onCompletion: () {}));
    expect(find.byIcon(Icons.spa_rounded), findsOneWidget);
    expect(find.text('Hold to Complete'), findsOneWidget);
  });

  testWidgets('renders completion flash state', (tester) async {
    await tester.pumpWidget(
      buildTestSubject(
        onCompletion: () {},
        visualState: HabitVisualState.checkInComplete,
      ),
    );
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    expect(find.text('Done!'), findsOneWidget);
  });

  testWidgets('renders established state with habit icon', (tester) async {
    await tester.pumpWidget(
      buildTestSubject(
        onCompletion: () {},
        visualState: HabitVisualState.established,
        habitIcon: '🔥',
      ),
    );
    expect(find.text('🔥'), findsOneWidget);
    expect(find.text('Hold to Complete'), findsNothing);
    expect(find.text('Done!'), findsNothing);
  });

  test('standard ring parameters double after completion', () {
    expect(HabitVisualParameters.standard.idleRingThickness, 6);
    expect(HabitVisualParameters.standard.establishedRingThickness, 12);
  });

  // testWidgets('missed and skipped states apply opacity', (tester) async {
  //   await tester.pumpWidget(
  //     buildTestSubject(
  //       onCompletion: () {},
  //       visualState: HabitVisualState.missed,
  //     ),
  //   );
  //
  //   // Find the Opacity widget wrapped around the icon content
  //   final opacityFinder = find.descendant(
  //     of: find.byType(Center),
  //     matching: find.byType(Opacity),
  //   );
  //   expect(opacityFinder, findsWidgets); // There might be multiple opacity widgets in the tree
  //
  //   // Verify gestures are ignored for missed state
  //   var completions = 0;
  //   await tester.pumpWidget(
  //     buildTestSubject(
  //       onCompletion: () => completions += 1,
  //       durationMs: 600,
  //       visualState: HabitVisualState.missed,
  //     ),
  //   );
  //
  //   final gesture = await tester.startGesture(
  //     tester.getCenter(find.byType(MudLongPressButton)),
  //   );
  //   await tester.pump(const Duration(milliseconds: 700));
  //   await gesture.up();
  //   await tester.pumpAndSettle();
  //   expect(completions, 0);
  // });
}
