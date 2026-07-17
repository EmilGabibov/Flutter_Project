import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';

class LanguageSelector extends ConsumerWidget {
  final bool compact;
  const LanguageSelector({super.key, this.compact = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final loc = AppLocalizations.of(context)!;

    final languages = [
      {'code': 'en', 'name': 'English'},
      {'code': 'de', 'name': 'Deutsch'},
      {'code': 'ur', 'name': 'اردو'},
      {'code': 'ru', 'name': 'Русский'},
      {'code': 'ta', 'name': 'தமிழ்'},
      {'code': 'fa', 'name': 'فارسی'},
      {'code': 'id', 'name': 'Bahasa Indonesia'},
    ];

    if (compact) {
      return DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentLocale.languageCode,
          icon: const Icon(Icons.language, size: 20),
          isDense: true,
          items: languages.map((lang) {
            return DropdownMenuItem<String>(
              value: lang['code'],
              child: Text(lang['name']!),
            );
          }).toList(),
          onChanged: (String? newCode) {
            if (newCode != null) {
              ref.read(localeProvider.notifier).setLocale(Locale(newCode));
            }
          },
        ),
      );
    }

    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(loc.settingsLanguage),
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentLocale.languageCode,
          items: languages.map((lang) {
            return DropdownMenuItem<String>(
              value: lang['code'],
              child: Text(lang['name']!),
            );
          }).toList(),
          onChanged: (String? newCode) {
            if (newCode != null) {
              ref.read(localeProvider.notifier).setLocale(Locale(newCode));
            }
          },
        ),
      ),
    );
  }
}
