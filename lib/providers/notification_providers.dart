import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart';
import '../database/tables.dart';
import '../services/background_sync_service.dart';
import '../services/local_reminder_service.dart';
import '../data/mascot_reminder_copy.dart';
import 'auth_provider.dart';
import 'database_provider.dart';

final backgroundSyncServiceProvider = Provider<BackgroundSyncService>((ref) {
  return BackgroundSyncService();
});

final notificationsForUserProvider =
    StreamProvider.family<List<NotificationEvent>, String>((ref, userId) {
      final db = ref.watch(databaseProvider);
      return db.watchNotificationsForUser(userId);
    });

final unreadNotificationsForUserProvider =
    StreamProvider.family<List<NotificationEvent>, String>((ref, userId) {
      final db = ref.watch(databaseProvider);
      return db.watchUnreadNotificationsForUser(userId);
    });

final unreadNotificationCountProvider = StreamProvider<int>((ref) async* {
  final userId = ref.watch(authProvider.select((auth) => auth.userId));
  if (userId == null) {
    yield 0;
    return;
  }

  final db = ref.watch(databaseProvider);
  await for (final unread in db.watchUnreadNotificationsForUser(userId)) {
    yield unread.length;
  }
});

final reminderSettingsForUserProvider =
    StreamProvider.family<List<ReminderSetting>, String>((ref, userId) {
      final db = ref.watch(databaseProvider);
      return db.watchReminderSettings(userId, ReminderType.dailyHabit);
    });

enum ReminderUpdateResult { success, denied, unsupported }

class NotificationActions {
  final Ref ref;

  NotificationActions(this.ref);

  AppDatabase get _db => ref.read(databaseProvider);
  LocalReminderService get _reminders => ref.read(localReminderServiceProvider);
  BackgroundSyncService get _backgroundSync =>
      ref.read(backgroundSyncServiceProvider);

  Future<void> markRead(String notificationId) async {
    await _db.markNotificationRead(notificationId);
  }

  Future<void> markAllRead(String userId) async {
    await _db.markAllNotificationsRead(userId);
  }

  Future<ReminderUpdateResult> addDailyReminder({
    required String userId,
    required int hour,
    required int minute,
  }) async {
    if (!_reminders.supportsScheduling) {
      return ReminderUpdateResult.unsupported;
    }

    final granted = await _reminders.requestPermission();
    if (!granted) {
      // Add a disabled reminder
      await _db.insertReminderSetting(
        ReminderSettingsCompanion.insert(
          userId: userId,
          type: const Value(ReminderType.dailyHabit),
          isEnabled: const Value(false),
          isPermissionDenied: const Value(true),
          hour: Value(hour),
          minute: Value(minute),
          updatedAt: Value(DateTime.now()),
        ),
      );
      return ReminderUpdateResult.denied;
    }

    // Insert to get ID
    final dbId = await _db.insertReminderSetting(
      ReminderSettingsCompanion.insert(
        userId: userId,
        type: const Value(ReminderType.dailyHabit),
        isEnabled: const Value(true),
        isPermissionDenied: const Value(false),
        hour: Value(hour),
        minute: Value(minute),
        updatedAt: Value(DateTime.now()),
      ),
    );

    final notificationId = LocalReminderService.notificationIdForReminder(
      ReminderType.dailyHabit,
      dbId,
    );

    final copy = MascotReminderCopyHelper.getCopyForType(
      ReminderType.dailyHabit,
    );
    await _reminders.scheduleReminder(
      notificationId: notificationId,
      userId: userId,
      type: ReminderType.dailyHabit,
      hour: hour,
      minute: minute,
      title: copy.title,
      body: copy.body,
    );
    await _backgroundSync.scheduleReminderPrefetch(
      userId: userId,
      type: ReminderType.dailyHabit,
      reminderId: dbId,
      targetHour: hour,
      targetMinute: minute,
    );

    // Record notification event for logging
    await _logReminderEvent(userId, true, hour, minute);

    return ReminderUpdateResult.success;
  }

  Future<ReminderUpdateResult> updateDailyReminder({
    required ReminderSetting setting,
    required bool enabled,
    required int hour,
    required int minute,
  }) async {
    bool permissionDenied = false;
    final notificationId = LocalReminderService.notificationIdForReminder(
      ReminderType.dailyHabit,
      setting.id,
    );
    final legacySlotNotificationId =
        LocalReminderService.legacySlotNotificationIdForReminder(
          ReminderType.dailyHabit,
          setting.id,
        );

    if (enabled) {
      if (!_reminders.supportsScheduling) {
        return ReminderUpdateResult.unsupported;
      }
      final granted = await _reminders.requestPermission();
      if (!granted) {
        permissionDenied = true;
        enabled = false;
      } else {
        await _reminders.cancelReminderVariants(
          notificationId: notificationId,
          legacySlotNotificationId: legacySlotNotificationId,
          userId: setting.userId,
          type: ReminderType.dailyHabit,
        );
        final copy = MascotReminderCopyHelper.getCopyForType(
          ReminderType.dailyHabit,
        );
        await _reminders.scheduleReminder(
          notificationId: notificationId,
          userId: setting.userId,
          type: ReminderType.dailyHabit,
          hour: hour,
          minute: minute,
          title: copy.title,
          body: copy.body,
        );
        await _backgroundSync.scheduleReminderPrefetch(
          userId: setting.userId,
          type: ReminderType.dailyHabit,
          reminderId: setting.id,
          targetHour: hour,
          targetMinute: minute,
        );
      }
    } else {
      await _reminders.cancelReminderVariants(
        notificationId: notificationId,
        legacySlotNotificationId: legacySlotNotificationId,
        userId: setting.userId,
        type: ReminderType.dailyHabit,
      );
      await _backgroundSync.cancelReminderPrefetch(
        userId: setting.userId,
        type: ReminderType.dailyHabit,
        reminderId: setting.id,
      );
    }

    await _db.updateReminderSetting(
      setting.copyWith(
        isEnabled: enabled,
        isPermissionDenied: permissionDenied,
        hour: hour,
        minute: minute,
        updatedAt: DateTime.now(),
      ),
    );

    if (permissionDenied) {
      return ReminderUpdateResult.denied;
    }

    await _logReminderEvent(setting.userId, enabled, hour, minute);

    return ReminderUpdateResult.success;
  }

  Future<void> removeDailyReminder(ReminderSetting setting) async {
    final notificationId = LocalReminderService.notificationIdForReminder(
      ReminderType.dailyHabit,
      setting.id,
    );
    await _reminders.cancelReminderVariants(
      notificationId: notificationId,
      legacySlotNotificationId:
          LocalReminderService.legacySlotNotificationIdForReminder(
            ReminderType.dailyHabit,
            setting.id,
          ),
      userId: setting.userId,
      type: ReminderType.dailyHabit,
    );
    await _backgroundSync.cancelReminderPrefetch(
      userId: setting.userId,
      type: ReminderType.dailyHabit,
      reminderId: setting.id,
    );
    await _db.deleteReminderSetting(setting.id);
  }

  Future<void> restoreRemindersForUser(String userId) async {
    final settings = await _db.getReminderSettings(
      userId,
      ReminderType.dailyHabit,
    );
    for (final setting in settings) {
      if (!setting.isEnabled) continue;
      try {
        final hasPerm = await _reminders.checkPermission();
        if (!hasPerm) {
          await _db.updateReminderSetting(
            setting.copyWith(
              isPermissionDenied: true,
              isEnabled: false,
              updatedAt: DateTime.now(),
            ),
          );
          continue;
        }

        final notificationId = LocalReminderService.notificationIdForReminder(
          ReminderType.dailyHabit,
          setting.id,
        );
        await _reminders.cancelReminderVariants(
          notificationId: notificationId,
          legacySlotNotificationId:
              LocalReminderService.legacySlotNotificationIdForReminder(
                ReminderType.dailyHabit,
                setting.id,
              ),
          userId: userId,
          type: ReminderType.dailyHabit,
        );
        await _reminders.scheduleReminder(
          notificationId: notificationId,
          userId: userId,
          type: ReminderType.dailyHabit,
          hour: setting.hour,
          minute: setting.minute,
          title: 'Hable reminder',
          body: 'Open Hable and check today\'s habits.',
          payload: 'home',
        );
        await _backgroundSync.scheduleReminderPrefetch(
          userId: userId,
          type: ReminderType.dailyHabit,
          reminderId: setting.id,
          targetHour: setting.hour,
          targetMinute: setting.minute,
        );
      } catch (error) {
        debugPrint('Failed to restore reminder schedule: $error');
      }
    }
  }

  Future<void> cancelRemindersForUser(String userId) async {
    final settings = await _db.getReminderSettings(
      userId,
      ReminderType.dailyHabit,
    );
    for (final setting in settings) {
      try {
        final notificationId = LocalReminderService.notificationIdForReminder(
          ReminderType.dailyHabit,
          setting.id,
        );
        await _reminders.cancelReminderVariants(
          notificationId: notificationId,
          legacySlotNotificationId:
              LocalReminderService.legacySlotNotificationIdForReminder(
                ReminderType.dailyHabit,
                setting.id,
              ),
          userId: userId,
          type: ReminderType.dailyHabit,
        );
        await _backgroundSync.cancelReminderPrefetch(
          userId: userId,
          type: ReminderType.dailyHabit,
          reminderId: setting.id,
        );
      } catch (error) {
        debugPrint('Failed to cancel reminder schedule: $error');
      }
    }
  }

  Future<void> _logReminderEvent(
    String userId,
    bool enabled,
    int hour,
    int minute,
  ) async {
    final now = DateTime.now();
    final timeLabel = _formatTime(hour, minute);
    final title = enabled ? 'Daily reminder set' : 'Daily reminder turned off';
    final body = enabled
        ? 'Hable will remind you each day at $timeLabel.'
        : 'Daily habit reminders are turned off for $timeLabel.';

    await _db.upsertNotificationEvent(
      NotificationEventsCompanion(
        notificationId: Value(
          'reminder_setting_${userId}_${now.millisecondsSinceEpoch}',
        ),
        userId: Value(userId),
        type: const Value(NotificationEventType.reminderSetting),
        sourceType: const Value('reminder_setting'),
        sourceId: Value(userId),
        title: Value(title),
        body: Value(body),
        actionRoute: const Value('profile'),
        actionPayloadJson: Value(
          jsonEncode({'kind': 'reminder_setting', 'enabled': enabled}),
        ),
        createdAt: Value(now),
        readAt: const Value(null),
        updatedAt: Value(now),
      ),
    );
  }

  String _formatTime(int hour, int minute) {
    final normalizedHour = hour % 24;
    final normalizedMinute = minute % 60;
    final period = normalizedHour >= 12 ? 'PM' : 'AM';
    final hour12 = normalizedHour % 12 == 0 ? 12 : normalizedHour % 12;
    final minuteText = normalizedMinute.toString().padLeft(2, '0');
    return '$hour12:$minuteText $period';
  }
}

final notificationActionsProvider = Provider<NotificationActions>((ref) {
  return NotificationActions(ref);
});
