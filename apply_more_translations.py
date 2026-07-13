import os
import re

shell_file = '/Users/h.ettefagh/Documents/VibeCoding/Flutter/hable/lib/screens/main_navigation_shell.dart'
with open(shell_file, 'r') as f:
    content = f.read()

replacements_shell = [
    ("'Home'", "AppLocalizations.of(context)!.homeTabTitle"),
    ("'Social'", "AppLocalizations.of(context)!.socialTabTitle"),
    ("'Profile'", "AppLocalizations.of(context)!.profileTabTitle"),
]
for old, new in replacements_shell:
    content = content.replace(old, new)
if 'import \'package:hable/l10n/app_localizations.dart\';' not in content:
    content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:hable/l10n/app_localizations.dart';")
with open(shell_file, 'w') as f:
    f.write(content)


habit_card_file = '/Users/h.ettefagh/Documents/VibeCoding/Flutter/hable/lib/widgets/habit_card.dart'
with open(habit_card_file, 'r') as f:
    content = f.read()

replacements_hc = [
    ("'Skipped today'", "AppLocalizations.of(context)!.habitSkippedToday"),
    ("'Skip today'", "AppLocalizations.of(context)!.habitSkipToday"),
    ("'Following'", "AppLocalizations.of(context)!.habitFollowing"),
    ("'Continuous'", "AppLocalizations.of(context)!.habitContinuous"),
]
for old, new in replacements_hc:
    content = content.replace(old, new)
if 'import \'package:hable/l10n/app_localizations.dart\';' not in content:
    content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:hable/l10n/app_localizations.dart';")
with open(habit_card_file, 'w') as f:
    f.write(content)

dashboard_file = '/Users/h.ettefagh/Documents/VibeCoding/Flutter/hable/lib/screens/habit_dashboard_screen.dart'
with open(dashboard_file, 'r') as f:
    content = f.read()

replacements_dash = [
    ("'My Habits'", "AppLocalizations.of(context)!.dashboardMyHabits"),
    ("'Add Habit'", "AppLocalizations.of(context)!.dashboardAddHabit"),
    ("'No habits yet. Tap the + to start your first challenge.'", "AppLocalizations.of(context)!.dashboardNoHabits"),
]
for old, new in replacements_dash:
    content = content.replace(old, new)
if 'import \'package:hable/l10n/app_localizations.dart\';' not in content:
    content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:hable/l10n/app_localizations.dart';")
with open(dashboard_file, 'w') as f:
    f.write(content)

print("More files updated")
