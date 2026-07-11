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
  testWidgets('MainNavigationShell exposes three tabs and Home FAB', (
    tester,
  ) async {
    final harness = await _buildHarness();
    addTearDown(harness.db.close);

    await tester.pumpWidget(harness.widget);
    await tester.pump();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Social'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Habit'), findsOneWidget);

    await tester.tap(find.text('Habit'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('New Habit'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close));
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.text('Social'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Social Hub'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byTooltip('Open settings'), findsOneWidget);
  });
}
