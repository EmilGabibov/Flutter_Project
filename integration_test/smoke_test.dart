import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hable/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Hable ADB Smoke Tests', () {
    testWidgets('Unauthenticated user is routed to AuthScreen', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify we are on AuthScreen
      expect(find.text('Welcome to\nHable.'), findsOneWidget);
      expect(find.text('Log In'), findsOneWidget);

      // Verify we cannot see Home or Profile
      expect(find.text('Home'), findsNothing);
      expect(find.text('Profile'), findsNothing);
    });

    testWidgets('User can switch to register, enter credentials, and login', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Tap 'Sign up' switch
      final signUpSwitch = find.text('Need an account? Sign up');
      if (signUpSwitch.evaluate().isNotEmpty) {
        await tester.tap(signUpSwitch);
        await tester.pumpAndSettle();
      }

      // We should see Sign Up button now
      expect(find.text('Sign Up'), findsOneWidget);

      // Enter credentials
      await tester.enterText(find.byType(TextField).at(0), 'test_user_${DateTime.now().millisecondsSinceEpoch}');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      
      // Tap Sign Up
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Wait for auth to complete and routing to Home
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    });
  });
}
