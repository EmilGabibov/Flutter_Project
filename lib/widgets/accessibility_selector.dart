import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hable/l10n/app_localizations.dart';
import '../providers/accessibility_provider.dart';

class AccessibilitySelector extends ConsumerWidget {
  final bool compact;
  const AccessibilitySelector({super.key, this.compact = true});

  void _showAccessibilityOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return const _AccessibilityBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilityProvider);
    // Determine if any accessibility setting is active
    final isActive = settings.reducedMotion || settings.highContrast || settings.largerText;

    if (compact) {
      return IconButton(
        icon: Icon(
          isActive ? Icons.accessibility_new_rounded : Icons.accessibility_outlined,
          color: isActive ? Theme.of(context).colorScheme.primary : null,
        ),
        tooltip: AppLocalizations.of(context)?.settingsAccessibility ?? 'Accessibility',
        onPressed: () => _showAccessibilityOptions(context, ref),
      );
    }

    return ListTile(
      leading: Icon(
        isActive ? Icons.accessibility_new_rounded : Icons.accessibility_outlined,
        color: isActive ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(AppLocalizations.of(context)?.settingsAccessibility ?? 'Accessibility'),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () => _showAccessibilityOptions(context, ref),
    );
  }
}

class _AccessibilityBottomSheet extends ConsumerWidget {
  const _AccessibilityBottomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilityProvider);
    final notifier = ref.read(accessibilityProvider.notifier);
    final loc = AppLocalizations.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Text(
                loc?.settingsAccessibility ?? 'Accessibility',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Reduced Motion'),
              subtitle: const Text('Disable animations and transitions'),
              value: settings.reducedMotion,
              onChanged: (value) {
                notifier.toggleReducedMotion(value);
              },
            ),
            SwitchListTile(
              title: const Text('High Contrast'),
              subtitle: const Text('Increase color contrast for better readability'),
              value: settings.highContrast,
              onChanged: (value) {
                notifier.toggleHighContrast(value);
              },
            ),
            SwitchListTile(
              title: const Text('Larger Text'),
              subtitle: const Text('Increase the global text scale'),
              value: settings.largerText,
              onChanged: (value) {
                notifier.toggleLargerText(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
