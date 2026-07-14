import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'dart:async';
import '../database/tables.dart';

class LocalReminderService {
  static const int _slotFamilyMultiplier = 1000;
  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;
  bool _pluginAvailable = true;

  final _payloadStreamController = StreamController<String?>.broadcast();
  Stream<String?> get onPayloadTapped => _payloadStreamController.stream;

  LocalReminderService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  bool get supportsScheduling =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.windows);

  Future<void> initialize() async {
    if (_initialized || !_pluginAvailable) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_notification',
    );
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const windowsSettings = WindowsInitializationSettings(
      appName: 'Hable',
      appUserModelId: 'com.hable.app',
      guid: 'A1B2C3D4-E5F6-7890-1234-567890ABCDEF',
    );
    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
      windows: windowsSettings,
    );

    try {
      await _plugin.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          if (response.payload != null) {
            _payloadStreamController.add(response.payload);
          }
        },
      );
    } catch (_) {
      _pluginAvailable = false;
      return;
    }

    if (supportsScheduling) {
      tz.initializeTimeZones();
      try {
        final timezoneInfo = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
      } catch (_) {
        tz.setLocalLocation(tz.UTC);
      }

      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              'habit_reminders',
              'Habit reminders',
              description: 'Daily Hable reminder notifications',
              importance: Importance.high,
              playSound: true,
            ),
          );
    }

    _initialized = true;
  }

  Future<bool> requestPermission() async {
    if (!supportsScheduling) return false;
    await initialize();
    if (!_pluginAvailable) return false;

    final status = await Permission.notification.request();
    if (status.isGranted) {
      if (defaultTargetPlatform == TargetPlatform.android) {
        await _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission();
      } else if (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS) {
        if (defaultTargetPlatform == TargetPlatform.iOS) {
          await _plugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >()
              ?.requestPermissions(alert: true, badge: true, sound: true);
        } else {
          await _plugin
              .resolvePlatformSpecificImplementation<
                MacOSFlutterLocalNotificationsPlugin
              >()
              ?.requestPermissions(alert: true, badge: true, sound: true);
        }
      }
      return true;
    }

    return false;
  }

  Future<bool> checkPermission() async {
    if (!supportsScheduling) return false;
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  Future<bool> openSettings() async {
    return await openAppSettings();
  }

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
    if (!supportsScheduling) return;
    await initialize();
    if (!_pluginAvailable) return;

    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id: notificationId,
      title: title,
      body: body,
      scheduledDate: scheduled,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'habit_reminders',
          'Habit reminders',
          channelDescription: 'Daily Hable reminder notifications',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(),
        macOS: DarwinNotificationDetails(),
        windows: WindowsNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload ?? 'home',
    );
  }

  Future<String?> getInitialPayload() async {
    if (!supportsScheduling) return null;
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      return details.notificationResponse?.payload;
    }
    return null;
  }

  Future<void> cancelReminder(
    int notificationId, {
    String? userId,
    ReminderType? type,
  }) async {
    if (!supportsScheduling) return;
    await initialize();
    if (!_pluginAvailable) return;

    // Cancel legacy hash-based ID if provided, for backwards compatibility
    if (userId != null && type != null) {
      await _plugin.cancel(id: _legacyHashIdForUserAndType(userId, type));
    }

    await _plugin.cancel(id: notificationId);
  }

  Future<void> cancelReminderVariants({
    required int notificationId,
    int? legacySlotNotificationId,
    String? userId,
    ReminderType? type,
  }) async {
    if (!supportsScheduling) return;
    await initialize();
    if (!_pluginAvailable) return;

    if (userId != null && type != null) {
      await _plugin.cancel(id: _legacyHashIdForUserAndType(userId, type));
    }
    if (legacySlotNotificationId != null) {
      await _plugin.cancel(id: legacySlotNotificationId);
    }
    await _plugin.cancel(id: notificationId);
  }

  /// Returns the base OS notification ID for [type].
  ///
  /// Reserved ranges:
  ///   100 – 199  → self-habit daily reminders  (dailyHabit = 100)
  ///   200 – 299  → friend-activity reminders   (friendActivity = 200, reserved)
  ///
  /// IDs are global to the device (one user at a time) and require no user hash.
  static int baseNotificationIdForSlot(ReminderType type) {
    switch (type) {
      case ReminderType.dailyHabit:
        return 100;
      // Future: add friendActivity to ReminderType
      // case ReminderType.friendActivity:
      //   return 200;
    }
  }

  /// Stable per-reminder notification id inside a slot family.
  static int notificationIdForReminder(ReminderType type, int reminderId) {
    return baseNotificationIdForSlot(type) * _slotFamilyMultiplier + reminderId;
  }

  /// Previous slot-family mapping used after the schema first allowed
  /// multiple rows. Retained so updated builds can cancel old schedules.
  static int legacySlotNotificationIdForReminder(
    ReminderType type,
    int reminderId,
  ) {
    return baseNotificationIdForSlot(type) + (reminderId % 100);
  }

  /// Legacy: hash-based ID used before slot ranges were introduced.
  /// Only used during the one-time migration cancel in [cancelReminder].
  static int _legacyHashIdForUserAndType(String userId, ReminderType type) {
    var hash = 17;
    for (final codeUnit in userId.codeUnits) {
      hash = 37 * hash + codeUnit;
    }
    final stableUserInt = hash & 0x7FFFFFFF;
    switch (type) {
      case ReminderType.dailyHabit:
        return 1000 + (stableUserInt % 1000);
    }
  }
}

final localReminderServiceProvider = Provider<LocalReminderService>((ref) {
  return LocalReminderService();
});
