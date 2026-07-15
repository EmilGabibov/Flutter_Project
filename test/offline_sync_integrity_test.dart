import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_secure_storage/test/test_flutter_secure_storage_platform.dart';
import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/database/database.dart';
import 'package:hable/database/tables.dart';
import 'package:hable/models/daily_quote.dart';
import 'package:hable/services/connectivity_service.dart';
import 'package:hable/services/sync_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStoragePlatform.instance = TestFlutterSecureStoragePlatform({
      'jwt_token': 'token-123',
    });
  });

  test(
    'daily sync clears stale pending invites, friend requests, and unread notifications on reconnect',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      const userId = 'user-1';
      await db.insertUser(
        UsersCompanion.insert(userId: userId, username: 'Alice'),
      );

      final responses = [
        _dailySyncPayload(
          invitations: [
            {
              'id': 'invite-1',
              'requester_id': 'friend-1',
              'habit_id': 'habit-1',
              'status': 'pending',
              'created_at': '2026-07-13T09:00:00.000Z',
            },
          ],
          friendRequests: [
            {
              'id': 'request-1',
              'requester_id': 'friend-2',
              'requester_username': 'Bob',
              'created_at': '2026-07-13T09:05:00.000Z',
            },
          ],
        ),
        _dailySyncPayload(),
      ];
      var responseIndex = 0;

      final syncService = SyncService(
        db: db,
        connectivity: ConnectivityService(),
        storage: const FlutterSecureStorage(),
        client: MockClient((request) async {
          expect(request.url.path, '/api/sync/daily');
          final body = responses[responseIndex.clamp(0, responses.length - 1)];
          responseIndex++;
          return http.Response(jsonEncode(body), 200);
        }),
        apiBaseUrlOverride: 'http://offline.test',
      );
      addTearDown(syncService.dispose);

      await syncService.pullDailySync(userId);

      expect(await db.getPendingInvitations(), hasLength(1));
      expect(
        await db.watchPendingIncomingFriendRelationships().first,
        hasLength(1),
      );
      expect(await db.getUnreadNotificationsForUser(userId), hasLength(2));

      await syncService.pullDailySync(userId);

      expect(await db.getPendingInvitations(), isEmpty);
      expect(await db.watchPendingIncomingFriendRelationships().first, isEmpty);
      expect(await db.getUnreadNotificationsForUser(userId), isEmpty);
    },
  );

  test(
    'failed offline queue items stay pending and replay successfully later',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      await db.enqueueSync(
        SyncQueueCompanion.insert(
          action: SyncAction.sendNudge,
          payload: jsonEncode({
            'target_user_id': 'friend-1',
            'habit_id': 'habit-1',
          }),
        ),
      );
      await db.enqueueSync(
        SyncQueueCompanion.insert(
          action: SyncAction.sendHabitInvitation,
          payload: jsonEncode({
            'habit_id': 'habit-1',
            'recipient_id': 'friend-1',
          }),
        ),
      );

      var nudgeAttempts = 0;
      final syncService = SyncService(
        db: db,
        connectivity: ConnectivityService(),
        storage: const FlutterSecureStorage(),
        client: MockClient((request) async {
          if (request.url.path == '/api/social/nudge') {
            nudgeAttempts++;
            if (nudgeAttempts == 1) {
              throw const SocketException('offline');
            }
            return http.Response('{}', 200);
          }
          if (request.url.path == '/api/social/habit-invitation') {
            return http.Response('{}', 200);
          }
          throw StateError('Unexpected request: ${request.url}');
        }),
        apiBaseUrlOverride: 'http://offline.test',
      );
      addTearDown(syncService.dispose);

      await syncService.flushPending();
      expect(await db.getPendingSyncItems(), hasLength(2));

      await syncService.flushPending();
      expect(await db.getPendingSyncItems(), isEmpty);
    },
  );

  test(
    'daily sync persists the synced quote into the local quote cache',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      final syncService = SyncService(
        db: db,
        connectivity: ConnectivityService(),
        storage: const FlutterSecureStorage(),
        client: MockClient((request) async {
          expect(request.url.path, '/api/sync/daily');
          return http.Response(
            jsonEncode(
              _dailySyncPayload(
                quote: {'text': 'A steady start is still a start.'},
              ),
            ),
            200,
          );
        }),
        apiBaseUrlOverride: 'http://offline.test',
      );
      addTearDown(syncService.dispose);

      await syncService.pullDailySync('user-1');

      final quote = await db.getTodaysQuote();
      expect(quote?.quoteText, 'A steady start is still a start.');
    },
  );

  test(
    'daily sync without a quote leaves the local quote cache empty',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      final syncService = SyncService(
        db: db,
        connectivity: ConnectivityService(),
        storage: const FlutterSecureStorage(),
        client: MockClient((request) async {
          expect(request.url.path, '/api/sync/daily');
          return http.Response(jsonEncode(_dailySyncPayload()), 200);
        }),
        apiBaseUrlOverride: 'http://offline.test',
      );
      addTearDown(syncService.dispose);

      await syncService.pullDailySync('user-1');

      expect(await db.getTodaysQuote(), isNull);
    },
  );

  test(
    'daily sync can use an injected token provider without reading secure storage',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      FlutterSecureStoragePlatform.instance = TestFlutterSecureStoragePlatform(
        <String, String>{},
      );

      final syncService = SyncService(
        db: db,
        connectivity: ConnectivityService(),
        storage: const FlutterSecureStorage(),
        tokenProvider: () async => 'in-memory-token',
        client: MockClient((request) async {
          expect(request.headers['Authorization'], 'Bearer in-memory-token');
          return http.Response(jsonEncode(_dailySyncPayload()), 200);
        }),
        apiBaseUrlOverride: 'http://offline.test',
      );
      addTearDown(syncService.dispose);

      await syncService.pullDailySync('user-1');
    },
  );

  test('daily sync does not cache an overlong quote', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final syncService = SyncService(
      db: db,
      connectivity: ConnectivityService(),
      storage: const FlutterSecureStorage(),
      client: MockClient((request) async {
        return http.Response(
          jsonEncode(
            _dailySyncPayload(
              quote: {
                'text': 'x' * (maxDailyQuoteTextLength + 1),
                'author': 'Too Long Author',
              },
            ),
          ),
          200,
        );
      }),
      apiBaseUrlOverride: 'http://offline.test',
    );
    addTearDown(syncService.dispose);

    await syncService.pullDailySync('user-1');

    expect(await db.getTodaysQuote(), isNull);
  });

  test('legacy overlong cached quotes are ignored by the daily read', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await db
        .into(db.cachedQuotes)
        .insert(
          CachedQuotesCompanion.insert(
            quoteText: 'x' * (maxDailyQuoteTextLength + 1),
          ),
        );

    expect(await db.getTodaysQuote(), isNull);
  });
}

Map<String, dynamic> _dailySyncPayload({
  List<Map<String, dynamic>> invitations = const [],
  List<Map<String, dynamic>> friendRequests = const [],
  List<Map<String, dynamic>> nudges = const [],
  Map<String, dynamic>? quote,
}) {
  return {
    'accepted_friends': <Map<String, dynamic>>[],
    'partners': <Map<String, dynamic>>[],
    'nudges': nudges,
    'messages': <Map<String, dynamic>>[],
    'invitations': invitations,
    'friend_requests': friendRequests,
    'gamification': {
      'total_points': 0,
      'level': 'Newbie',
      'badges': <Map<String, dynamic>>[],
    },
    // ignore: use_null_aware_elements
    if (quote != null) 'quote': quote,
  };
}
