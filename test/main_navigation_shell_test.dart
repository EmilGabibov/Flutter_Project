import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/database/database.dart';
import 'package:hable/providers/database_provider.dart';
import 'package:hable/providers/usage_diagnostics_provider.dart';
import 'package:hable/screens/main_navigation_shell.dart';
import 'package:hable/services/usage_diagnostics_service.dart';
import 'package:hable/theme/app_theme.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

Future<({AppDatabase db, Widget widget})> _buildHarness() async {
  final db = AppDatabase(NativeDatabase.memory());
  await db.insertUser(
    UsersCompanion.insert(userId: 'user-1', username: 'Alice'),
  );

  final diagnostics = UsageDiagnosticsService(
    db: db,
    client: MockClient((_) async => http.Response('{}', 200)),
    apiBaseUrl: 'http://localhost',
    localCollectionEnabled: false,
    remoteUploadEnabled: false,
    buildChannel: 'test',
  );

  final widget = ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(db),
      usageDiagnosticsProvider.overrideWithValue(diagnostics),
    ],
    child: MaterialApp(
      theme: AppTheme.lightTheme.copyWith(
        splashFactory: NoSplash.splashFactory,
      ),
      home: const MainNavigationShell(userId: 'user-1'),
    ),
  );

  return (db: db, widget: widget);
}

void main() {
  group('MainNavigationShell', () {
    testWidgets('renders three tabs and Home FAB', (tester) async {
      final harness = await _buildHarness();
      addTearDown(harness.db.close);

      await tester.pumpWidget(harness.widget);
      await tester.pump();

      // Three navigation destinations.
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Social'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      // Home FAB for habit creation.
      expect(find.text('Habit'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 1));
    });

    testWidgets('Social tab shows 3 sub-tabs (Friends, Activity, Leaderboard)',
        (tester) async {
      final harness = await _buildHarness();
      addTearDown(harness.db.close);

      await tester.pumpWidget(harness.widget);
      await tester.pump();

      // Switch to Social tab.
      await tester.tap(find.text('Social'));
      await tester.pump(const Duration(milliseconds: 500));

      // Verify the 3 internal tabs exist.
      expect(find.text('Friends'), findsAtLeast(1));
      expect(find.text('Activity'), findsOneWidget);
      expect(find.text('Leaderboard'), findsOneWidget);

      // Find Friends is now a header icon, not a tab.
      expect(find.byTooltip('Find friends'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 1));
    });

    testWidgets('Profile tab shows settings gear', (tester) async {
      final harness = await _buildHarness();
      addTearDown(harness.db.close);

      await tester.pumpWidget(harness.widget);
      await tester.pump();

      // Switch to Profile tab.
      await tester.tap(find.text('Profile'));
      await tester.pump(const Duration(milliseconds: 500));

      // Gear icon present.
      expect(find.byTooltip('Open settings'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 1));
    });

    testWidgets('Android back from non-Home returns to Home', (tester) async {
      final harness = await _buildHarness();
      addTearDown(harness.db.close);

      await tester.pumpWidget(harness.widget);
      await tester.pump();

      // Switch to Profile tab.
      await tester.tap(find.text('Profile'));
      await tester.pump(const Duration(milliseconds: 500));

      // Simulate system back.
      await tester.binding.handlePopRoute();
      await tester.pump();

      // Should be back on Home (FAB visible).
      expect(find.text('Habit'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 1));
    });
  });
}
