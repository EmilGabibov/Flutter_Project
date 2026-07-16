import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/database/database.dart';
import 'package:hable/database/tables.dart';
import 'package:hable/theme/app_theme.dart';
import 'package:hable/widgets/habit_partner_row.dart';

import 'test_harness.dart';

PartnerSnapshot _partner({
  required String id,
  required String name,
  required PartnershipRole role,
  required bool completed,
  DateTime? lastNudgeAt,
}) {
  return PartnerSnapshot(
    habitId: 'habit-1',
    partnerUserId: id,
    username: name,
    avatarUrl: '😀',
    role: role,
    currentDuration: 3,
    hasCompletedToday: completed,
    lastNudgeAt: lastNudgeAt,
    updatedAt: DateTime(2026),
    isSynced: true,
  );
}

void main() {
  testWidgets(
    'HabitPartnerRow caps visible partners and opens the overflow sheet',
    (tester) async {
      final partners = [
        _partner(
          id: 'p1',
          name: 'Alex',
          role: PartnershipRole.owner,
          completed: true,
        ),
        _partner(
          id: 'p2',
          name: 'Blair',
          role: PartnershipRole.partner,
          completed: false,
        ),
        _partner(
          id: 'p3',
          name: 'Casey',
          role: PartnershipRole.partner,
          completed: true,
        ),
        _partner(
          id: 'p4',
          name: 'Devon',
          role: PartnershipRole.supporter,
          completed: false,
        ),
        _partner(
          id: 'p5',
          name: 'Elliot',
          role: PartnershipRole.supporter,
          completed: false,
        ),
      ];

      await tester.pumpWidget(
        buildHableTestApp(
          theme: AppTheme.lightTheme.copyWith(
            splashFactory: NoSplash.splashFactory,
          ),
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: HabitPartnerRow(
                partners: partners,
                habitColor: AppTheme.sageGreen,
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('partner-stack-collapsed')), findsOneWidget);
      expect(find.byKey(const Key('partner-overflow-badge')), findsOneWidget);
      expect(find.text('Alex'), findsNothing);
      expect(find.text('Elliot'), findsNothing);

      await tester.tap(find.byKey(const Key('partner-overflow-badge')));
      await tester.pumpAndSettle();

      expect(find.text('Partners'), findsOneWidget);
      expect(find.text('Alex'), findsOneWidget);
      expect(find.text('Blair'), findsOneWidget);
      expect(find.text('Casey'), findsOneWidget);
      expect(find.text('Devon'), findsOneWidget);
      expect(find.text('Elliot'), findsOneWidget);
      expect(find.text('owner • completed today'), findsOneWidget);
    },
  );

  testWidgets('HabitPartnerRow separates profile and nudge actions', (
    tester,
  ) async {
    // Exercise the anchored dropdown branch explicitly; Flutter widget tests
    // default to a mobile target on this host.
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    var openedProfileFor = '';
    var nudgedPartner = '';
    final partner = _partner(
      id: 'p1',
      name: 'Alex',
      role: PartnershipRole.partner,
      completed: false,
    );

    await tester.pumpWidget(
      buildHableTestApp(
        theme: AppTheme.lightTheme.copyWith(
          splashFactory: NoSplash.splashFactory,
        ),
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: HabitPartnerRow(
              partners: [partner],
              habitColor: AppTheme.sageGreen,
              onProfileTap: (selected) {
                openedProfileFor = selected.partnerUserId;
              },
              onNudgeTap: (selected) {
                nudgedPartner = selected.partnerUserId;
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('partner-avatar-p1')));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byWidgetPredicate(
        (widget) =>
            widget is PopupMenuItem<String> && widget.value == 'profile',
      ),
    );
    await tester.pumpAndSettle();

    expect(openedProfileFor, 'p1');
    expect(nudgedPartner, isEmpty);
    debugDefaultTargetPlatformOverride = null;

    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    await tester.tap(find.byKey(const Key('partner-avatar-p1')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byWidgetPredicate(
        (widget) => widget is PopupMenuItem<String> && widget.value == 'nudge',
      ),
    );
    await tester.pumpAndSettle();

    expect(openedProfileFor, 'p1');
    expect(nudgedPartner, 'p1');
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('HabitPartnerRow surfaces a recent received nudge', (
    tester,
  ) async {
    final partner = _partner(
      id: 'p1',
      name: 'Alex',
      role: PartnershipRole.partner,
      completed: false,
      lastNudgeAt: DateTime.now(),
    );

    await tester.pumpWidget(
      buildHableTestApp(
        theme: AppTheme.lightTheme.copyWith(
          splashFactory: NoSplash.splashFactory,
        ),
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: HabitPartnerRow(
              partners: [partner],
              habitColor: AppTheme.sageGreen,
            ),
          ),
        ),
      ),
    );

    final ring = tester.widget<Container>(
      find.byKey(const Key('partner-status-ring-p1')),
    );
    final decoration = ring.decoration! as BoxDecoration;
    final border = decoration.border! as Border;

    expect(border.top.color, AppTheme.sageGreen.withValues(alpha: 0.5));
  });

  testWidgets('HabitPartnerRow completed ring uses the habit color', (
    tester,
  ) async {
    const habitColor = Color(0xFF4D8C57);
    final partner = _partner(
      id: 'p1',
      name: 'Alex',
      role: PartnershipRole.partner,
      completed: true,
    );

    await tester.pumpWidget(
      buildHableTestApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: HabitPartnerRow(partners: [partner], habitColor: habitColor),
        ),
      ),
    );

    final ring = tester.widget<Container>(
      find.byKey(const Key('partner-status-ring-p1')),
    );
    final decoration = ring.decoration! as BoxDecoration;
    final border = decoration.border! as Border;
    final size = tester.getSize(
      find.byKey(const Key('partner-status-ring-p1')),
    );

    expect(size.width, 36);
    expect(size.height, 36);
    expect(border.top.color, habitColor);
    expect(decoration.color, habitColor);
    expect(border.top.color, isNot(AppTheme.completionGreen));
  });

  testWidgets('HabitPartnerRow shows empty state when no partners', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildHableTestApp(
        theme: AppTheme.lightTheme.copyWith(
          splashFactory: NoSplash.splashFactory,
        ),
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: HabitPartnerRow(
              partners: const [],
              habitColor: AppTheme.sageGreen,
            ),
          ),
        ),
      ),
    );

    expect(find.text('No partners'), findsOneWidget);
  });

  testWidgets(
    'HabitPartnerRow keeps compact mode as a collapsed avatar stack',
    (tester) async {
      final partners = [
        _partner(
          id: 'p1',
          name: 'CompactAlex',
          role: PartnershipRole.owner,
          completed: true,
        ),
        _partner(
          id: 'p2',
          name: 'CompactBlair',
          role: PartnershipRole.partner,
          completed: false,
        ),
      ];

      await tester.pumpWidget(
        buildHableTestApp(
          theme: AppTheme.lightTheme.copyWith(
            splashFactory: NoSplash.splashFactory,
          ),
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: HabitPartnerRow(
                partners: partners,
                habitColor: AppTheme.sageGreen,
                compactMode: true,
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('partner-stack-collapsed')), findsOneWidget);
      expect(find.byKey(const Key('partner-avatar-p1')), findsOneWidget);
      expect(find.byKey(const Key('partner-avatar-p2')), findsOneWidget);
      expect(find.text('CompactAlex'), findsNothing);
      expect(find.text('CompactBlair'), findsNothing);
    },
  );

  testWidgets(
    'HabitPartnerRow renders distinct state text for completed pending and nudged',
    (tester) async {
      final partners = [
        _partner(
          id: 'complete',
          name: 'Complete',
          role: PartnershipRole.owner,
          completed: true,
        ),
        _partner(
          id: 'pending',
          name: 'Pending',
          role: PartnershipRole.partner,
          completed: false,
        ),
        _partner(
          id: 'nudged',
          name: 'Nudged',
          role: PartnershipRole.partner,
          completed: false,
          lastNudgeAt: DateTime.now(),
        ),
      ];

      await tester.pumpWidget(
        buildHableTestApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: HabitPartnerRow(
              partners: partners,
              habitColor: AppTheme.sageGreen,
              maxVisible: 2,
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('partner-overflow-badge')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('partner-state-complete')), findsOneWidget);
      expect(find.text('owner • completed today'), findsOneWidget);
      expect(find.text('partner • pending'), findsOneWidget);
      expect(find.text('partner • nudged'), findsOneWidget);
    },
  );
}
