import 'package:flutter_test/flutter_test.dart';
import 'package:hable/database/database.dart';
import 'package:hable/services/connectivity_service.dart';
import 'package:hable/services/sync_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' show Value;

void main() {
  late AppDatabase db;
  late SyncService syncService;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    syncService = SyncService(
      db: db,
      connectivity: ConnectivityService(),
      storage: const FlutterSecureStorage(),
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('buildSocialRecapPlan marks stale recap sources', () async {
    final staleTime = DateTime.now().subtract(const Duration(hours: 8));
    await db.upsertPartnerSnapshot(
      PartnerSnapshotsCompanion.insert(
        habitId: 'habit-1',
        partnerUserId: 'user-2',
        username: 'Alice',
        currentDuration: const Value(3),
        hasCompletedToday: const Value(true),
        updatedAt: Value(staleTime),
      ),
    );

    final plan = await syncService.buildSocialRecapPlan('user1');
    expect(plan, isNotNull);
    expect(plan!.isStaleAt(DateTime.now()), isTrue);
  });
}
