import 'package:flutter_test/flutter_test.dart';
import 'package:hable/screens/main_navigation_shell.dart';

void main() {
  test('resolveNotificationNavigation maps social requests to friends tab', () {
    final decision = resolveNotificationNavigation(
      actionRoute: 'social_requests',
    );
    expect(decision, isNotNull);
    expect(decision!.tabIndex, 1);
    expect(decision.socialSubTab, 0);
  });

  test('resolveNotificationNavigation preserves home habit focus payload', () {
    final decision = resolveNotificationNavigation(
      actionRoute: 'home',
      actionPayload: {'habit_id': 'habit-42'},
    );
    expect(decision, isNotNull);
    expect(decision!.tabIndex, 0);
    expect(decision.homeHabitId, 'habit-42');
  });

  test('unsupported and malformed notification routes are ignored', () {
    expect(resolveNotificationNavigation(actionRoute: 'settings'), isNull);
    expect(
      resolveNotificationNavigation(actionPayloadJson: '{not-json'),
      isNull,
    );
  });
}
