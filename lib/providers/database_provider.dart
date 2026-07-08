import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';

/// Singleton provider for the Drift [AppDatabase].
/// All other providers read from this to enforce the offline-first principle.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});
