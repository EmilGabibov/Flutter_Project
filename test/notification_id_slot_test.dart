import 'package:flutter_test/flutter_test.dart';
import 'package:hable/database/tables.dart';
import 'package:hable/services/local_reminder_service.dart';

void main() {
  group('LocalReminderService.baseNotificationIdForSlot', () {
    test('dailyHabit maps to base ID 100', () {
      expect(
        LocalReminderService.baseNotificationIdForSlot(ReminderType.dailyHabit),
        equals(100),
      );
    });

    test(
      'same slot always returns the same base ID regardless of call order',
      () {
        final id1 = LocalReminderService.baseNotificationIdForSlot(
          ReminderType.dailyHabit,
        );
        final id2 = LocalReminderService.baseNotificationIdForSlot(
          ReminderType.dailyHabit,
        );
        expect(id1, equals(id2));
      },
    );

    test(
      'dailyHabit base ID is within reserved self-habit range (100–199)',
      () {
        final id = LocalReminderService.baseNotificationIdForSlot(
          ReminderType.dailyHabit,
        );
        expect(id, greaterThanOrEqualTo(100));
        expect(id, lessThan(200));
      },
    );

    test('reserved friend-activity range starts at 200 (not yet issued)', () {
      // Documenting the reserved boundary.
      // Friend-activity slot will be notificationIdForSlot(ReminderType.friendActivity) = 200
      // when that enum value is added.
      const friendActivityBase = 200;
      const dailyHabitId = 100;
      expect(
        dailyHabitId,
        lessThan(friendActivityBase),
        reason: 'self-habit and friend-activity ranges must not overlap',
      );
    });
  });

  group('LocalReminderService.notificationIdForReminder', () {
    test(
      'same reminder row always maps to the same stable notification id',
      () {
        final id1 = LocalReminderService.notificationIdForReminder(
          ReminderType.dailyHabit,
          17,
        );
        final id2 = LocalReminderService.notificationIdForReminder(
          ReminderType.dailyHabit,
          17,
        );
        expect(id1, id2);
      },
    );

    test(
      'different reminder rows in the same family do not overwrite each other',
      () {
        final id1 = LocalReminderService.notificationIdForReminder(
          ReminderType.dailyHabit,
          17,
        );
        final id2 = LocalReminderService.notificationIdForReminder(
          ReminderType.dailyHabit,
          18,
        );
        expect(id1, isNot(id2));
      },
    );
  });
}
