import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hable/main.dart';

void main() {
  testWidgets('App launches without error', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: HableApp()));
    // Verify the app renders (will show onboarding since no user exists)
    expect(find.text('Welcome to'), findsOneWidget);
  });
}
