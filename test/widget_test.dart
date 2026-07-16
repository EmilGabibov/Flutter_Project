import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:hable/app/hable_app.dart';

void main() {
  testWidgets('App launches without error', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: HableApp()));
    // Verify the app shell renders; the gate may show Auth, loading, or Home.
    expect(find.byType(MaterialApp), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });
}
