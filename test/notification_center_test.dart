import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/database/database.dart';
import 'package:hable/database/tables.dart';
import 'package:hable/providers/database_provider.dart';
import 'package:hable/providers/usage_diagnostics_provider.dart';
import 'package:hable/screens/notification_center_screen.dart';
import 'package:hable/services/usage_diagnostics_service.dart';
import 'package:hable/theme/app_theme.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'test_harness.dart';

void main() {
  group('notification persistence', () {
    test('upsert stays idempotent and unread state can be cleared', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      const userId = 'user-1';
      final createdAt = DateTime(2026, 7, 11, 9, 30);

      await db.insertUser(
        UsersCompanion.insert(userId: userId, username: 'Alice'),
      );

      await db.upsertNotificationEvent(
        NotificationEventsCompanion(
          notificationId: const Value('nudge:1'),
          userId: const Value(userId),
          type: const Value(NotificationEventType.nudge),
          sourceType: const Value('nudge'),
          sourceId: const Value('friend-1'),
          title: const Value('You were nudged'),
          body: const Value('First body'),
          actionRoute: const Value('home'),
          createdAt: Value(createdAt),
          updatedAt: Value(createdAt),
        ),
      );

      await db.upsertNotificationEvent(
        NotificationEventsCompanion(
          notificationId: const Value('nudge:1'),
          userId: const Value(userId),
          type: const Value(NotificationEventType.nudge),
          sourceType: const Value('nudge'),
          sourceId: const Value('friend-1'),
          title: const Value('You were nudged'),
          body: const Value('Updated body'),
          actionRoute: const Value('home'),
          createdAt: Value(createdAt),
          updatedAt: Value(createdAt.add(const Duration(minutes: 1))),
        ),
      );

      await db.upsertNotificationEvent(
        NotificationEventsCompanion(
          notificationId: const Value('invite:1'),
          userId: const Value(userId),
          type: const Value(NotificationEventType.habitInvitation),
          sourceType: const Value('habit_invitation'),
          sourceId: const Value('invite-1'),
          title: const Value('Habit invite'),
          body: const Value('Join this shared habit'),
          actionRoute: const Value('home'),
          createdAt: Value(createdAt.add(const Duration(minutes: 5))),
          updatedAt: Value(createdAt.add(const Duration(minutes: 5))),
        ),
      );

      final allNotifications = await db.watchNotificationsForUser(userId).first;
      expect(allNotifications, hasLength(2));
      expect(allNotifications.first.notificationId, 'invite:1');
      expect(
        allNotifications
            .singleWhere((row) => row.notificationId == 'nudge:1')
            .body,
        'Updated body',
      );

      final unreadBefore = await db
          .watchUnreadNotificationsForUser(userId)
          .first;
      expect(unreadBefore, hasLength(2));

      await db.markNotificationRead('nudge:1');
      final unreadAfterSingle = await db
          .watchUnreadNotificationsForUser(userId)
          .first;
      expect(unreadAfterSingle, hasLength(1));
      expect(unreadAfterSingle.single.notificationId, 'invite:1');

      await db.markAllNotificationsRead(userId);
      final unreadAfterAll = await db
          .watchUnreadNotificationsForUser(userId)
          .first;
      expect(unreadAfterAll, isEmpty);
    });
  });

  group('notification center widget', () {
    testWidgets('shows empty state from local Drift stream', (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      await db.insertUser(
        UsersCompanion.insert(userId: 'user-1', username: 'Alice'),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            usageDiagnosticsProvider.overrideWithValue(
              _buildUsageDiagnostics(db),
            ),
          ],
          child: buildHableTestApp(
            theme: AppTheme.lightTheme,
            home: const NotificationCenterScreen(userId: 'user-1'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('No notifications yet'), findsOneWidget);
      expect(find.text('Mark all read'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1));
    });

    testWidgets('renders unread notification content', (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      const userId = 'user-1';
      final createdAt = DateTime(2026, 7, 11, 10, 0);

      await db.insertUser(
        UsersCompanion.insert(userId: userId, username: 'Alice'),
      );
      await db.upsertNotificationEvent(
        NotificationEventsCompanion(
          notificationId: const Value('message:1'),
          userId: const Value(userId),
          type: const Value(NotificationEventType.privateMessage),
          sourceType: const Value('private_message'),
          sourceId: const Value('pm-1'),
          title: const Value('New message'),
          body: const Value('Bob sent you a note'),
          actionRoute: const Value('social_inbox'),
          createdAt: Value(createdAt),
          updatedAt: Value(createdAt),
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            usageDiagnosticsProvider.overrideWithValue(
              _buildUsageDiagnostics(db),
            ),
          ],
          child: buildHableTestApp(
            theme: AppTheme.lightTheme,
            home: const NotificationCenterScreen(userId: userId),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('New message'), findsOneWidget);
      expect(find.textContaining('Bob sent you a note'), findsOneWidget);
      expect(find.text('Mark all read'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1));
    });
  });
}

UsageDiagnosticsService _buildUsageDiagnostics(AppDatabase db) {
  return UsageDiagnosticsService(
    db: db,
    client: MockClient((request) async {
      return http.Response('{}', 200);
    }),
    apiBaseUrl: 'http://127.0.0.1:8787',
    localCollectionEnabled: false,
    remoteUploadEnabled: false,
    buildChannel: 'test',
  );
}
