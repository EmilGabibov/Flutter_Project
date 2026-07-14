import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../theme/app_theme.dart';
import 'menu_item.dart';

/// Unified context menu system.
/// Uses a bottom sheet on mobile and a standard dropdown menu on desktop/web.
/// Handles spatial logic, flip/mirror collision, intent grouping, and keyboard accessibility.
Future<T?> showHableContextMenu<T>({
  required BuildContext context,
  required Offset position,
  required List<HableMenuItem<T>> items,
  String? title,
}) async {
  if (defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android) {
    return _showBottomSheet(context, items, title);
  } else {
    return _showDesktopMenu(context, position, items, title);
  }
}

Future<T?> _showBottomSheet<T>(
  BuildContext context,
  List<HableMenuItem<T>> items,
  String? title,
) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: AppTheme.surface,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (title != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppTheme.warmGray,
                    ),
                  ),
                ),
                const Divider(height: 16, color: AppTheme.surfaceVariant),
              ],
              ...items.map((item) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.withDividerBefore)
                      const Divider(height: 1, color: AppTheme.surfaceVariant),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(item.value),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Row(
                          children: [
                            if (item.icon != null) ...[
                              Icon(
                                item.icon,
                                color: _colorForIntent(item.intent),
                                size: 22,
                              ),
                              const SizedBox(width: 16),
                            ],
                            Expanded(
                              child: Text(
                                item.label,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: _colorForIntent(item.intent),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      );
    },
  );
}

Future<T?> _showDesktopMenu<T>(
  BuildContext context,
  Offset position,
  List<HableMenuItem<T>> items,
  String? title,
) {
  final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
  final relativeRect = RelativeRect.fromRect(
    Rect.fromLTWH(position.dx, position.dy, 0, 0),
    Offset.zero & overlay.size,
  );

  final popupItems = <PopupMenuEntry<T>>[];
  
  if (title != null) {
    popupItems.add(
      PopupMenuItem<T>(
        enabled: false,
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.warmGray,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
    popupItems.add(const PopupMenuDivider(height: 1));
  }

  for (final item in items) {
    if (item.withDividerBefore && popupItems.isNotEmpty) {
      popupItems.add(const PopupMenuDivider(height: 1));
    }
    popupItems.add(
      PopupMenuItem<T>(
        value: item.value,
        child: Row(
          children: [
            if (item.icon != null) ...[
              Icon(
                item.icon,
                color: _colorForIntent(item.intent),
                size: 20,
              ),
              const SizedBox(width: 12),
            ],
            Text(
              item.label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _colorForIntent(item.intent),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  return showMenu<T>(
    context: context,
    position: relativeRect,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: AppTheme.warmGray.withValues(alpha: 0.2)),
    ),
    color: AppTheme.surface,
    elevation: 8,
    items: popupItems,
  );
}

Color _colorForIntent(MenuIntent intent) {
  switch (intent) {
    case MenuIntent.primary:
      return AppTheme.deepCharcoal;
    case MenuIntent.edit:
      return AppTheme.sageGreen;
    case MenuIntent.share:
      return AppTheme.mutedLavender;
    case MenuIntent.destructive:
      return AppTheme.overdueRose;
  }
}
