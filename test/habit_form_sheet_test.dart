import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/database/database.dart';
import 'package:hable/database/tables.dart' show HabitStatus;
import 'package:hable/l10n/app_localizations.dart';
import 'package:hable/providers/habit_actions_provider.dart';
import 'package:hable/providers/social_providers.dart';
import 'package:hable/theme/app_theme.dart';
import 'package:hable/widgets/habit_form_sheet.dart';

class _FakeHabitActions implements HabitActions {
  String? createdTitle;
  String? createdDescription;
  int? createdDuration;
  bool? createdIsCustom;
  String? createdColor;
  List<String>? createdPartnerIds;

  String? updatedHabitId;
  String? updatedTitle;
  String? updatedDescription;
  int? updatedDuration;
  String? updatedColor;

  @override
  Future<void> archiveHabit(String habitId) async {}

  @override
  Future<String?> createHabit(
    String title,
    String? description,
    int targetDuration,
    bool isCustom,
    String colorHex, {
    List<String> partnerIds = const [],
  }) async {
    createdTitle = title;
    createdDescription = description;
    createdDuration = targetDuration;
    createdIsCustom = isCustom;
    createdColor = colorHex;
    createdPartnerIds = partnerIds;
    return 'habit-1';
  }

  @override
  Future<void> deleteHabit(String habitId) async {}

  @override
  Future<void> rerunHabit(String habitId) async {}

  @override
  Future<void> restoreHabit(String habitId) async {}

  @override
  Future<void> updateHabit(
    String habitId,
    String title,
    String? description,
    int targetDuration,
    String colorHex,
  ) async {
    updatedHabitId = habitId;
    updatedTitle = title;
    updatedDescription = description;
    updatedDuration = targetDuration;
    updatedColor = colorHex;
  }
}

AcceptedFriend _friend(String id, String name, String avatar) {
  return AcceptedFriend(
    friendUserId: id,
    username: name,
    avatarUrl: avatar,
    updatedAt: DateTime(2026),
    isSynced: true,
  );
}

Habit _habit({String title = 'Reading', bool isCustom = false}) {
  return Habit(
    habitId: 'habit-1',
    userId: 'user-1',
    title: title,
    description: 'Read for 20 minutes before bed.',
    isCustom: isCustom,
    targetDuration: 33,
    currentDuration: 33,
    status: HabitStatus.active,
    colorHex: 'FFA5B4FC',
    updatedAt: DateTime(2026),
    createdAt: DateTime(2026),
    isSynced: true,
  );
}

Widget _buildSheet({
  Habit? existingHabit,
  String? prefilledTitle,
  required HabitActions actions,
  List<AcceptedFriend> friends = const [],
}) {
  return ProviderScope(
    overrides: [
      habitActionsProvider.overrideWithValue(actions),
      acceptedFriendsProvider.overrideWith((ref) => Stream.value(friends)),
    ],
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: HabitFormSheet(
          existingHabit: existingHabit,
          prefilledTitle: prefilledTitle,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('HabitFormSheet shows visible validation in create mode', (
    tester,
  ) async {
    final actions = _FakeHabitActions();

    await tester.pumpWidget(_buildSheet(actions: actions));

    await tester.enterText(find.byKey(const Key('habit-form-title')), '');
    await tester.ensureVisible(find.byKey(const Key('habit-form-save')));
    await tester.tap(find.byKey(const Key('habit-form-save')));
    await tester.pumpAndSettle();

    final durationSlider = tester.widget<Slider>(
      find.byKey(const Key('habit-form-duration-slider')),
    );

    expect(find.text('Create habit'), findsOneWidget);
    expect(find.text('Give this habit a clear name.'), findsOneWidget);
    expect(durationSlider.min, 1);
    expect(durationSlider.value, 21);
    expect(actions.createdTitle, isNull);
  });

  testWidgets('HabitFormSheet applies preset copy and duration suggestions', (
    tester,
  ) async {
    final actions = _FakeHabitActions();

    await tester.pumpWidget(_buildSheet(actions: actions));

    await tester.tap(find.byKey(const Key('preset-Hydration')));
    await tester.pumpAndSettle();

    final titleField = tester.widget<TextFormField>(
      find.byKey(const Key('habit-form-title')),
    );

    expect(titleField.controller!.text, 'Hydration');
    expect(find.text('21 days'), findsWidgets);
    final descriptionField = tester.widget<TextFormField>(
      find.byKey(const Key('habit-form-description')),
    );
    expect(descriptionField.controller!.text, 'Drink 8 glasses of water daily');
    expect(find.byKey(const Key('duration-66')), findsNothing);
    expect(find.byKey(const Key('duration-90')), findsNothing);

    await tester.ensureVisible(find.byKey(const Key('duration-40')));
    await tester.tap(find.byKey(const Key('duration-40')));
    await tester.pump();

    final durationValue = tester.widget<Text>(
      find.byKey(const Key('habit-form-duration-value')),
    );
    expect(durationValue.data, '40 days');
  });

  testWidgets('HabitFormSheet creates habit with selected partners', (
    tester,
  ) async {
    final actions = _FakeHabitActions();

    await tester.pumpWidget(
      _buildSheet(
        actions: actions,
        friends: [_friend('friend-1', 'Mina', '🦊')],
      ),
    );

    await tester.enterText(
      find.byKey(const Key('habit-form-title')),
      'Evening Walk',
    );
    await tester.enterText(
      find.byKey(const Key('habit-form-description')),
      'A calm walk after dinner.',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('friend-friend-1')));
    await tester.tap(find.byKey(const Key('friend-friend-1')));
    await tester.pump();
    await tester.ensureVisible(find.byKey(const Key('habit-form-save')));
    await tester.tap(find.byKey(const Key('habit-form-save')));
    await tester.pumpAndSettle();

    expect(actions.createdTitle, 'Evening Walk');
    expect(actions.createdDescription, 'A calm walk after dinner.');
    expect(actions.createdDuration, 21);
    expect(actions.createdIsCustom, isTrue);
    expect(actions.createdPartnerIds, ['friend-1']);
    expect(find.text('Mina'), findsNothing);
  });

  testWidgets('HabitFormSheet updates existing habit in edit mode', (
    tester,
  ) async {
    final actions = _FakeHabitActions();

    await tester.pumpWidget(
      _buildSheet(existingHabit: _habit(), actions: actions),
    );

    expect(find.text('Save changes'), findsOneWidget);
    expect(find.text('Invite partners'), findsNothing);
    final descriptionField = tester.widget<TextFormField>(
      find.byKey(const Key('habit-form-description')),
    );
    expect(
      descriptionField.controller!.text,
      'Read for 20 minutes before bed.',
    );

    await tester.enterText(
      find.byKey(const Key('habit-form-title')),
      'Deep Reading',
    );
    await tester.enterText(
      find.byKey(const Key('habit-form-description')),
      'Read without distractions before sleep.',
    );
    await tester.ensureVisible(find.byKey(const Key('habit-form-save')));
    await tester.tap(find.byKey(const Key('habit-form-save')));
    await tester.pumpAndSettle();

    expect(actions.updatedHabitId, 'habit-1');
    expect(actions.updatedTitle, 'Deep Reading');
    expect(
      actions.updatedDescription,
      'Read without distractions before sleep.',
    );
    expect(actions.updatedDuration, 33);
  });

  testWidgets(
    'HabitFormSheet preserves a persisted custom emoji when editing',
    (tester) async {
      final actions = _FakeHabitActions();

      await tester.pumpWidget(
        _buildSheet(
          existingHabit: _habit(title: '👩‍💻 Sketching', isCustom: true),
          actions: actions,
        ),
      );

      final titleField = tester.widget<TextFormField>(
        find.byKey(const Key('habit-form-title')),
      );
      expect(titleField.controller!.text, 'Sketching');
      expect(find.text('👩‍💻'), findsOneWidget);

      await tester.ensureVisible(find.byKey(const Key('habit-form-save')));
      await tester.tap(find.byKey(const Key('habit-form-save')));
      await tester.pumpAndSettle();

      expect(actions.updatedTitle, '👩‍💻 Sketching');
    },
  );
}
