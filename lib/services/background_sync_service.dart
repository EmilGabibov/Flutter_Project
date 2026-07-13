import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:workmanager/workmanager.dart';
import 'package:http/http.dart' as http;

import '../database/database.dart';
import '../database/tables.dart';
import 'connectivity_service.dart';
import 'sync_service.dart';
import 'local_reminder_service.dart';
import 'usage_diagnostics_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      final userId = inputData?['userId'] as String?;
      final reminderId = inputData?['reminderId'] as int?;
      final reminderTypeName = inputData?['reminderType'] as String?;
      final targetHour = inputData?['targetHour'] as int?;
      final targetMinute = inputData?['targetMinute'] as int?;

      if (userId == null) return true;

      final db = AppDatabase();
      final connectivity = ConnectivityService();
      const storage = FlutterSecureStorage(
        mOptions: MacOsOptions(usesDataProtectionKeychain: false),
      );
      final localReminderService = LocalReminderService();
      await localReminderService.initialize();

      final diagnostics = UsageDiagnosticsService(
        db: db,
        client: http.Client(),
        apiBaseUrl: '',
        localCollectionEnabled: true,
        remoteUploadEnabled: false,
        buildChannel: kReleaseMode ? 'production' : 'development',
      );

      final syncService = SyncService(
        db: db,
        connectivity: connectivity,
        storage: storage,
        localReminderService: localReminderService,
      );

      // Record Telemetry
      if (targetHour != null &&
          targetMinute != null &&
          reminderId != null &&
          reminderTypeName != null) {
        final reminderType = ReminderType.values.firstWhere(
          (value) => value.name == reminderTypeName,
          orElse: () => ReminderType.dailyHabit,
        );
        final now = DateTime.now();
        var targetTime = DateTime(
          now.year,
          now.month,
          now.day,
          targetHour,
          targetMinute,
        );

        // Target time was presumably today. If it is already past the target time, we missed the window.
        // If it's before, we made it on time.
        // Wait, if target time is technically tomorrow because it crossed midnight, the heuristic here:
        // Assume targetTime is the closest occurrence in the past 12h or next 12h.

        if (now.difference(targetTime).inHours > 12) {
          targetTime = targetTime.add(const Duration(days: 1));
        } else if (targetTime.difference(now).inHours > 12) {
          targetTime = targetTime.subtract(const Duration(days: 1));
        }

        await diagnostics.recordBackgroundEvent(
          now.isAfter(targetTime) ? 'prefetch_missed' : 'prefetch_on_time',
        );

        // Chain the next task for tomorrow
        final bgService = BackgroundSyncService();
        await bgService.scheduleReminderPrefetch(
          userId: userId,
          type: reminderType,
          reminderId: reminderId,
          targetHour: targetHour,
          targetMinute: targetMinute,
        );
      }

      // Perform a minimal background sync
      await syncService.pullDailySync(userId);

      if (reminderId != null && reminderTypeName != null) {
        final recapPlan = await syncService.buildSocialRecapPlan(userId);
        if (recapPlan == null) {
          await diagnostics.recordBackgroundEvent('prefetch_recap_empty');
        } else if (recapPlan.isStaleAt(DateTime.now())) {
          await diagnostics.recordBackgroundEvent('prefetch_recap_stale');
        } else {
          await diagnostics.recordBackgroundEvent('prefetch_recap_ready');
        }
      }

      // Dispose resources
      diagnostics.dispose();
      await db.close();

      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Background sync task failed: $e');
      }
      return false; // Retry if configured
    }
  });
}

class BackgroundSyncService {
  static const String _prefetchTaskName = "com.hable.sync.prefetch";
  static const int _prefetchLeadMinutes = 10;

  Future<void> initialize() async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return;

    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: kDebugMode,
    );
  }

  String uniquePrefetchName(String userId, ReminderType type, int reminderId) {
    return 'reminder_prefetch_${userId}_${type.name}_$reminderId';
  }

  Future<void> scheduleReminderPrefetch({
    required String userId,
    required ReminderType type,
    required int reminderId,
    required int targetHour,
    required int targetMinute,
  }) async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return;

    final now = DateTime.now();
    var targetTime = DateTime(
      now.year,
      now.month,
      now.day,
      targetHour,
      targetMinute,
    );

    if (targetTime.isBefore(now)) {
      targetTime = targetTime.add(const Duration(days: 1));
    }

    var prefetchTime = targetTime.subtract(
      const Duration(minutes: _prefetchLeadMinutes),
    );
    if (prefetchTime.isBefore(now)) {
      // If subtracting 10 minutes puts it in the past, schedule it for tomorrow
      prefetchTime = prefetchTime.add(const Duration(days: 1));
    }

    final initialDelay = prefetchTime.difference(now);

    // Register a one-off task for precise execution
    await Workmanager().registerOneOffTask(
      uniquePrefetchName(userId, type, reminderId),
      _prefetchTaskName,
      initialDelay: initialDelay,
      inputData: {
        'userId': userId,
        'reminderId': reminderId,
        'reminderType': type.name,
        'targetHour': targetHour,
        'targetMinute': targetMinute,
      },
      constraints: Constraints(
        networkType: NetworkType.connected, // Only run if network is available
      ),
      existingWorkPolicy:
          ExistingWorkPolicy.replace, // Replace existing task for this user
    );
  }

  Future<void> cancelReminderPrefetch({
    required String userId,
    required ReminderType type,
    required int reminderId,
  }) async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return;
    await Workmanager().cancelByUniqueName(
      uniquePrefetchName(userId, type, reminderId),
    );
  }
}
