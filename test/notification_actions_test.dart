import 'package:drift/native.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/database/database.dart';
import 'package:hable/database/tables.dart';
import 'package:hable/providers/database_provider.dart';
import 'package:hable/providers/notification_providers.dart';
import 'package:hable/services/background_sync_service.dart';
import 'package:hable/services/local_reminder_service.dart';

class FakeLocalReminderService extends LocalReminderService {
  final List<int> scheduledIds = [];
  final List<int> canceledIds = [];
  bool permissionGranted = true;

  @override
  bool get supportsScheduling => true;

  @override
  Future<bool> requestPermission() async => permissionGranted;

  @override
  Future<bool> checkPermission() async => permissionGranted;

  @override
  Future<void> scheduleReminder({
    required int notificationId,
    required String userId,
    required ReminderType type,
    required int hour,
    required int minute,
    required String title,
    required String body,
    String? payload,
  }) async {
    scheduledIds.add(notificationId);
  }

  @override
  Future<void> cancelReminderVariants({
    required int notificationId,
    int? legacySlotNotificationId,
    String? userId,
    ReminderType? type,
  }) async {
    canceledIds.add(notificationId);
    if (legacySlotNotificationId != null) {
      canceledIds.add(legacySlotNotificationId);
    }
  }
}

class FakeBackgroundSyncService extends BackgroundSyncService {
  final List<String> scheduledPrefetchNames = [];
  final List<String> canceledPrefetchNames = [];

  @override
  Future<void> scheduleReminderPrefetch({
    required String userId,
    required ReminderType type,
    required int reminderId,
    required int targetHour,
    required int targetMinute,
  }) async {
    scheduledPrefetchNames.add(uniquePrefetchName(userId, type, reminderId));
  }

  @override
  Future<void> cancelReminderPrefetch({
    required String userId,
    required ReminderType type,
    required int reminderId,
  }) async {
    canceledPrefetchNames.add(uniquePrefetchName(userId, type, reminderId));
  }
}

void main() {
  late AppDatabase db;
  late FakeLocalReminderService reminders;
  late FakeBackgroundSyncService backgroundSync;
  late ProviderContainer container;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    reminders = FakeLocalReminderService();
    backgroundSync = FakeBackgroundSyncService();
    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        localReminderServiceProvider.overrideWithValue(reminders),
        backgroundSyncServiceProvider.overrideWithValue(backgroundSync),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  test(
    'addDailyReminder assigns distinct stable notification identities per row',
    () async {
      const userId = 'user-1';
      final actions = container.read(notificationActionsProvider);

      final firstResult = await actions.addDailyReminder(
        userId: userId,
        hour: 8,
        minute: 0,
      );
      final secondResult = await actions.addDailyReminder(
        userId: userId,
        hour: 20,
        minute: 30,
      );

      expect(firstResult, ReminderUpdateResult.success);
      expect(secondResult, ReminderUpdateResult.success);

      final settings = await db.getReminderSettings(
        userId,
        ReminderType.dailyHabit,
      );
      expect(settings, hasLength(2));

      final expectedIds = settings
          .map(
            (setting) => LocalReminderService.notificationIdForReminder(
              ReminderType.dailyHabit,
              setting.id,
            ),
          )
          .toList();

      expect(reminders.scheduledIds, unorderedEquals(expectedIds));
      expect(expectedIds.toSet(), hasLength(2));
      expect(
        backgroundSync.scheduledPrefetchNames,
        unorderedEquals(
          settings
              .map(
                (setting) => backgroundSync.uniquePrefetchName(
                  userId,
                  ReminderType.dailyHabit,
                  setting.id,
                ),
              )
              .toList(),
        ),
      );
    },
  );

  test(
    'removeDailyReminder only cancels the targeted reminder identity',
    () async {
      const userId = 'user-2';
      final actions = container.read(notificationActionsProvider);

      await actions.addDailyReminder(userId: userId, hour: 9, minute: 0);
      await actions.addDailyReminder(userId: userId, hour: 21, minute: 0);

      final settings = await db.getReminderSettings(
        userId,
        ReminderType.dailyHabit,
      );
      final toRemove = settings.first;
      final toKeep = settings.last;

      await actions.removeDailyReminder(toRemove);

      final remaining = await db.getReminderSettings(
        userId,
        ReminderType.dailyHabit,
      );
      expect(remaining.map((setting) => setting.id), [toKeep.id]);

      final removedNotificationId =
          LocalReminderService.notificationIdForReminder(
            ReminderType.dailyHabit,
            toRemove.id,
          );
      expect(reminders.canceledIds, contains(removedNotificationId));
      expect(
        backgroundSync.canceledPrefetchNames,
        contains(
          backgroundSync.uniquePrefetchName(
            userId,
            ReminderType.dailyHabit,
            toRemove.id,
          ),
        ),
      );
      expect(
        backgroundSync.canceledPrefetchNames,
        isNot(
          contains(
            backgroundSync.uniquePrefetchName(
              userId,
              ReminderType.dailyHabit,
              toKeep.id,
            ),
          ),
        ),
      );
    },
  );

  test(
    'restoreRemindersForUser restores every enabled reminder schedule',
    () async {
      const userId = 'user-3';
      await db.insertReminderSetting(
        ReminderSettingsCompanion.insert(
          userId: userId,
          type: const Value(ReminderType.dailyHabit),
          isEnabled: const Value(true),
          hour: const Value(7),
          minute: const Value(15),
        ),
      );
      await db.insertReminderSetting(
        ReminderSettingsCompanion.insert(
          userId: userId,
          type: const Value(ReminderType.dailyHabit),
          isEnabled: const Value(true),
          hour: const Value(19),
          minute: const Value(45),
        ),
      );

      final actions = container.read(notificationActionsProvider);
      await actions.restoreRemindersForUser(userId);

      final settings = await db.getReminderSettings(
        userId,
        ReminderType.dailyHabit,
      );
      expect(reminders.scheduledIds, hasLength(2));
      expect(
        reminders.scheduledIds,
        unorderedEquals(
          settings
              .map(
                (setting) => LocalReminderService.notificationIdForReminder(
                  ReminderType.dailyHabit,
                  setting.id,
                ),
              )
              .toList(),
        ),
      );
      expect(backgroundSync.scheduledPrefetchNames, hasLength(2));
    },
  );
}
