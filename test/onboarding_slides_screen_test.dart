import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/models/daily_quote.dart';
import 'package:hable/providers/quote_provider.dart';
import 'package:hable/screens/auth_screen.dart';
import 'package:hable/screens/onboarding/onboarding_slides_screen.dart';

import 'test_harness.dart';

Widget _wrap(Widget child, {Future<DailyQuote> Function()? quote}) {
  return ProviderScope(
    overrides: [
      quoteProvider.overrideWith(
        (ref) =>
            quote?.call() ??
            Future.value(const DailyQuote(text: 'Small steps still count.')),
      ),
    ],
    child: buildHableTestApp(home: child),
  );
}

void main() {
  testWidgets('OnboardingSlidesScreen renders quote and slide order', (
    tester,
  ) async {
    var started = false;
    var loggedIn = false;

    await tester.pumpWidget(
      _wrap(
        OnboardingSlidesScreen(
          onGetStarted: () => started = true,
          onLogIn: () => loggedIn = true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Every day is day one.'), findsOneWidget);
    expect(find.text('"Small steps still count."'), findsOneWidget);

    await tester.tap(find.byKey(const Key('onboarding-primary-action')));
    await tester.pumpAndSettle();

    expect(find.text('Start through the mud.'), findsOneWidget);
    expect(find.textContaining('1500ms press'), findsOneWidget);
    expect(started, isFalse);
    expect(loggedIn, isFalse);
  });

  testWidgets('OnboardingSlidesScreen renders quote provider fallback copy', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        OnboardingSlidesScreen(onGetStarted: () {}, onLogIn: () {}),
        quote: () =>
            Future.value(const DailyQuote(text: 'Every day is day one.')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('"Every day is day one."'), findsOneWidget);
  });

  testWidgets('OnboardingSlidesScreen routes final slide to setup', (
    tester,
  ) async {
    var started = false;

    await tester.pumpWidget(
      _wrap(
        OnboardingSlidesScreen(
          onGetStarted: () => started = true,
          onLogIn: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    for (var i = 0; i < 6; i++) {
      await tester.tap(find.byKey(const Key('onboarding-primary-action')));
      await tester.pumpAndSettle();
    }

    expect(find.text('No skip button on the ring.'), findsOneWidget);
    expect(find.text('Start setup'), findsOneWidget);

    await tester.tap(find.byKey(const Key('onboarding-primary-action')));
    await tester.pumpAndSettle();

    expect(started, isTrue);
  });

  testWidgets('AuthScreen intro can route to login and sign up forms', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const AuthScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('onboarding-log-in')));
    await tester.pumpAndSettle();

    expect(find.text('Log In'), findsOneWidget);
    expect(find.text('Welcome to\nHable.'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();

    await tester.pumpWidget(_wrap(const AuthScreen()));
    await tester.pumpAndSettle();

    for (var i = 0; i < 7; i++) {
      await tester.tap(find.byKey(const Key('onboarding-primary-action')));
      await tester.pumpAndSettle();
    }

    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('Join Hable.'), findsOneWidget);
  });
}
