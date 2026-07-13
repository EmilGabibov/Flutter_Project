import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../services/connectivity_service.dart';
import '../services/local_reminder_service.dart';
import '../services/sync_service.dart';
import 'database_provider.dart';
import 'habit_providers.dart';
import 'notification_providers.dart';
import 'social_providers.dart';

/// Provides the sync service, initialized once and shared globally.
final syncServiceProvider = Provider<SyncService>((ref) {
  final db = ref.watch(databaseProvider);
  final connectivity = ConnectivityService();
  const storage = FlutterSecureStorage(
    mOptions: MacOsOptions(usesDataProtectionKeychain: false),
  );
  final localReminderService = ref.watch(localReminderServiceProvider);

  final service = SyncService(
    db: db,
    connectivity: connectivity,
    storage: storage,
    localReminderService: localReminderService,
  );
  service.init();

  ref.onDispose(() => service.dispose());
  return service;
});

class ForegroundSyncController extends Notifier<bool> {
  Timer? _timer;
  DateTime? _lastSyncAt;

  @override
  bool build() {
    ref.onDispose(stopPolling);
    return false; // isSyncing = false
  }

  void startPolling(String userId) {
    if (_timer != null && _timer!.isActive) return;
    _timer = Timer.periodic(const Duration(seconds: 7), (_) {
      syncNow(userId);
    });
  }

  void stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> syncNow(String userId) async {
    if (state) return; // Already syncing
    
    final now = DateTime.now();
    if (_lastSyncAt != null && now.difference(_lastSyncAt!) < const Duration(seconds: 5)) {
      return; // Debounce
    }

    state = true;
    _lastSyncAt = now;

    try {
      final syncService = ref.read(syncServiceProvider);
      await syncService.pullDailySync(userId);

      // Invalidate relevant providers to force UI refresh with new Drift data
      ref.invalidate(activeHabitsProvider(userId));
      ref.invalidate(habitPartnersProvider);
      ref.invalidate(currentUserProvider);
      ref.invalidate(unreadNotificationCountProvider);
      ref.invalidate(acceptedFriendsProvider);
      ref.invalidate(pendingIncomingFriendRelationshipsProvider);
      ref.invalidate(pendingInvitationsProvider);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Foreground sync failed: $e');
      }
    } finally {
      state = false;
    }
  }
}

final foregroundSyncControllerProvider =
    NotifierProvider<ForegroundSyncController, bool>(
  ForegroundSyncController.new,
);
