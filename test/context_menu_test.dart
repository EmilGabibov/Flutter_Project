import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/widgets/context_menu/hable_context_menu.dart';
import 'package:hable/widgets/context_menu/menu_item.dart';

void main() {
  testWidgets('Android uses the touch-friendly context menu adapter', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    String? selected;
    try {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return GestureDetector(
                  onLongPress: () async {
                    selected = await showHableContextMenu<String>(
                      context: context,
                      position: Offset.zero,
                      items: const [
                        HableMenuItem<String>(
                          label: 'Remove',
                          value: 'remove',
                          intent: MenuIntent.destructive,
                        ),
                      ],
                    );
                  },
                  child: const Text('Trigger'),
                );
              },
            ),
          ),
        ),
      );

      await tester.longPress(find.text('Trigger'));
      await tester.pumpAndSettle();

      expect(find.text('Remove'), findsOneWidget);
      expect(find.byType(BottomSheet), findsOneWidget);

      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();
      expect(selected, 'remove');
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });
}
