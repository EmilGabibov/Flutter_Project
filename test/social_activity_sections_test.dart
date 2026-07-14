import 'package:flutter_test/flutter_test.dart';
import 'package:hable/database/database.dart';
import 'package:hable/database/tables.dart';
import 'package:hable/l10n/app_localizations_en.dart';
import 'package:hable/screens/social/social_hub_screen.dart';

void main() {
  NotificationEvent buildNotification({
    required String id,
    required DateTime createdAt,
    DateTime? readAt,
  }) {
    return NotificationEvent(
      notificationId: id,
      userId: 'user-1',
      type: NotificationEventType.nudge,
      sourceType: 'nudge',
      sourceId: 'source',
      title: 'Title',
      body: 'Body',
      actionRoute: 'home',
      actionPayloadJson: '{"habit_id":"habit-1"}',
      createdAt: createdAt,
      expiresAt: null,
      readAt: readAt,
      updatedAt: createdAt,
    );
  }

  test(
    'buildActivitySections groups unread, today, and earlier notifications',
    () {
      final now = DateTime(2026, 7, 13, 12);
      final sections = buildActivitySections([
        buildNotification(
          id: '1',
          createdAt: now.subtract(const Duration(hours: 1)),
        ),
        buildNotification(
          id: '2',
          createdAt: now.subtract(const Duration(hours: 2)),
          readAt: now,
        ),
        buildNotification(
          id: '3',
          createdAt: now.subtract(const Duration(days: 2)),
          readAt: now,
        ),
      ], AppLocalizationsEn(), now: now);

      expect(sections.map((section) => section.title).toList(), [
        'Unread',
        'Today',
        'Earlier',
      ]);
      expect(sections[0].items.single.notificationId, '1');
      expect(sections[1].items.single.notificationId, '2');
      expect(sections[2].items.single.notificationId, '3');
    },
  );
}
