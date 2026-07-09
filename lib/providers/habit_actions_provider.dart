import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';
import '../providers/auth_provider.dart';
import 'database_provider.dart';
import 'sync_provider.dart';

final habitActionsProvider = Provider((ref) => HabitActionsController(ref));

class HabitActionsController {
  final Ref _ref;

  HabitActionsController(this._ref);

  AppDatabase get _db => _ref.read(databaseProvider);
  String? get _userId => _ref.read(authProvider).userId;

  Future<String?> createHabit(
    String title,
    int targetDuration,
    bool isCustom,
    String colorHex, {
    List<String> partnerIds = const [],
  }) async {
    if (_userId == null) return null;
    final habitId = await _db.createHabitWithSync(
      title,
      targetDuration,
      isCustom,
      colorHex,
      _userId!,
      partnerIds: partnerIds,
    );
    await _ref.read(syncServiceProvider).flushPending();
    return habitId;
  }

  Future<void> updateHabit(
    String habitId,
    String title,
    int targetDuration,
    String colorHex,
  ) async {
    await _db.updateHabitDetails(habitId, title, targetDuration, colorHex);
    await _ref.read(syncServiceProvider).flushPending();
  }

  Future<void> archiveHabit(String habitId) async {
    await _db.archiveHabit(habitId);
  }

  Future<void> restoreHabit(String habitId) async {
    await _db.restoreHabit(habitId);
  }
}
