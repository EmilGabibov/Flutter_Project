import 'package:flutter_test/flutter_test.dart';
import 'package:hable/database/database.dart';
import 'package:hable/services/sync_service.dart';
import 'package:hable/services/connectivity_service.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' as drift;
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:hable/models/daily_quote.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  FlutterSecureStorage.setMockInitialValues({});
  group('Quote Rotation Test (DY State)', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
    });

    tearDown(() async {
      await db.close();
    });

    test('SyncService fetches new quote and updates cache', () async {
      final mockClient = MockClient((request) async {
        if (request.url.path.contains('/api/sync/daily')) {
          return http.Response(
            jsonEncode({
              'quote': {
                'text': 'A fresh daily quote',
                'author': 'Daily Author',
              },
            }),
            200,
          );
        }
        return http.Response('{}', 200);
      });

      // Cache an old quote from "yesterday"
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      await db.into(db.cachedQuotes).insert(
            CachedQuotesCompanion.insert(
              quoteText: 'Old Quote',
              author: const drift.Value('Old Author'),
              fetchedAt: drift.Value(yesterday),
            ),
          );

      // Verify old quote is not valid for "today"
      final preSyncTodaysQuote = await db.getTodaysQuote();
      expect(preSyncTodaysQuote, isNull);

      final syncService = SyncService(
        db: db,
        storage: const FlutterSecureStorage(),
        connectivity: ConnectivityService(),
        client: mockClient,
        tokenProvider: () async => 'test_token',
      );

      // Perform sync
      await syncService.pullDailySync('test_user');

      // Verify new quote is cached for "today"
      final postSyncTodaysQuote = await db.getTodaysQuote();
      expect(postSyncTodaysQuote, isNotNull);
      expect(postSyncTodaysQuote!.quoteText, 'A fresh daily quote');
      expect(postSyncTodaysQuote.author, 'Daily Author');
    });
  });
}
