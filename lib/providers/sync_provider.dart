import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/sync_service.dart';
import '../services/connectivity_service.dart';
import 'database_provider.dart';

/// Provides the sync service, initialized once and shared globally.
final syncServiceProvider = Provider<SyncService>((ref) {
  final db = ref.watch(databaseProvider);
  final connectivity = ConnectivityService();

  final service = SyncService(db: db, connectivity: connectivity);
  service.init();

  ref.onDispose(() => service.dispose());
  return service;
});
