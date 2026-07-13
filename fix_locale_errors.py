import os
import re

def remove_const_text(filepath):
    with open(filepath, 'r') as f:
        content = f.read()
    
    # regex to remove `const ` before `Text(AppLocalizations`
    content = re.sub(r'const\s+Text\(\s*AppLocalizations\.of\(context\)', r'Text(AppLocalizations.of(context)', content)
    
    # Remove duplicate imports
    content = re.sub(r'(import \'package:hable/l10n/app_localizations\.dart\';\n)+', r'import \'package:hable/l10n/app_localizations.dart\';\n', content)
    
    with open(filepath, 'w') as f:
        f.write(content)

files = [
    '/Users/h.ettefagh/Documents/VibeCoding/Flutter/hable/lib/screens/auth_screen.dart',
    '/Users/h.ettefagh/Documents/VibeCoding/Flutter/hable/lib/screens/onboarding/onboarding_slides_screen.dart',
    '/Users/h.ettefagh/Documents/VibeCoding/Flutter/hable/lib/screens/profile_screen.dart',
    '/Users/h.ettefagh/Documents/VibeCoding/Flutter/hable/lib/widgets/habit_card.dart',
    '/Users/h.ettefagh/Documents/VibeCoding/Flutter/hable/lib/screens/habit_dashboard_screen.dart',
    '/Users/h.ettefagh/Documents/VibeCoding/Flutter/hable/lib/screens/main_navigation_shell.dart',
]

for f in files:
    if os.path.exists(f):
        remove_const_text(f)

# Fix locale_provider
locale_provider_path = '/Users/h.ettefagh/Documents/VibeCoding/Flutter/hable/lib/providers/locale_provider.dart'
new_locale = '''import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(() {
  return LocaleNotifier();
});

class LocaleNotifier extends Notifier<Locale> {
  static const _localeKey = 'hable_locale';

  @override
  Locale build() {
    _loadLocale();
    return const Locale('en');
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeKey);
    if (languageCode != null) {
      state = Locale(languageCode);
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (state == locale) return;
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }
}
'''
with open(locale_provider_path, 'w') as f:
    f.write(new_locale)

print("Fixes applied")
