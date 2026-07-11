import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/theme/app_theme.dart';
import 'package:hable/widgets/skeletons.dart';

void main() {
  testWidgets('HableEmptyStateCard scrolls instead of overflowing when short', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const SizedBox(
          height: 120,
          child: HableEmptyStateCard(
            icon: Icons.inbox_rounded,
            title: 'Nothing here',
            description: 'This placeholder should keep shape in small spaces.',
          ),
        ),
      ),
    );

    expect(find.text('Nothing here'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
