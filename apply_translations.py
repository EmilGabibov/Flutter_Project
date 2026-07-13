import os
import re

auth_file = '/Users/h.ettefagh/Documents/VibeCoding/Flutter/hable/lib/screens/auth_screen.dart'
with open(auth_file, 'r') as f:
    content = f.read()

replacements = [
    ("'Welcome to\\nHable.'", "AppLocalizations.of(context)!.authWelcomeTitle"),
    ("'Log in to continue your journey.'", "AppLocalizations.of(context)!.authLoginSubtitle"),
    ("'Log In'", "AppLocalizations.of(context)!.authLoginButton"),
    ("'Join Hable.'", "AppLocalizations.of(context)!.authJoinTitle"),
    ("'Choose a username and password. You can activate cloud recovery from Profile later.'", "AppLocalizations.of(context)!.authJoinSubtitle"),
    ("'Sign Up'", "AppLocalizations.of(context)!.authSignUpButton"),
    ("'Reset Password'", "AppLocalizations.of(context)!.authResetTitle"),
    ("'Enter your email to receive a verification PIN.'", "AppLocalizations.of(context)!.authResetSubtitle"),
    ("'Send PIN'", "AppLocalizations.of(context)!.authSendPinButton"),
    ("'Verify PIN'", "AppLocalizations.of(context)!.authVerifyTitle"),
    ("'Enter the PIN sent to your email and your new password.'", "AppLocalizations.of(context)!.authVerifySubtitle"),
    ("'Password reset successful. Please log in.'", "AppLocalizations.of(context)!.authResetSuccessMessage"),
    ("'Username'", "AppLocalizations.of(context)!.authUsernameLabel"),
    ("'Email'", "AppLocalizations.of(context)!.authEmailLabel"),
    ("'6-digit PIN'", "AppLocalizations.of(context)!.authPinLabel"),
    ("'Password'", "AppLocalizations.of(context)!.authPasswordLabel"),
    ("'New Password'", "AppLocalizations.of(context)!.authNewPasswordLabel"),
    ("'Forgot Password?'", "AppLocalizations.of(context)!.authForgotPassword"),
    ("'Working...'", "AppLocalizations.of(context)!.authWorking"),
    ("'Need an account? Sign up'", "AppLocalizations.of(context)!.authNeedAccount"),
    ("'Already have an account? Log in'", "AppLocalizations.of(context)!.authAlreadyHaveAccount"),
    ("'Back to Login'", "AppLocalizations.of(context)!.authBackToLogin"),
    ("'Hable complies with European data protection requirements, including GDPR.'", "AppLocalizations.of(context)!.authGdprFooter"),
]

for old, new in replacements:
    content = content.replace(old, new)

if 'import \'package:hable/l10n/app_localizations.dart\';' not in content:
    content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:hable/l10n/app_localizations.dart';")

with open(auth_file, 'w') as f:
    f.write(content)

print("Auth screen updated")

onboard_file = '/Users/h.ettefagh/Documents/VibeCoding/Flutter/hable/lib/screens/onboarding/onboarding_slides_screen.dart'
with open(onboard_file, 'r') as f:
    content = f.read()

replacements_onboard = [
    ("'Day one'", "AppLocalizations.of(context)!.onboardingDayOneEyebrow"),
    ("'Every day is day one.'", "AppLocalizations.of(context)!.onboardingDayOneTitle"),
    ("'Start with a calm read, then one deliberate action. Hable keeps the first step small enough to repeat.'", "AppLocalizations.of(context)!.onboardingDayOneBody"),
    ("'Mud'", "AppLocalizations.of(context)!.onboardingMudEyebrow"),
    ("'Start through the mud.'", "AppLocalizations.of(context)!.onboardingMudTitle"),
    ("'New habits ask for a steady 1500ms press. That resistance is the point: effort first, stability later.'", "AppLocalizations.of(context)!.onboardingMudBody"),
    ("'Commit'", "AppLocalizations.of(context)!.onboardingCommitEyebrow"),
    ("'Pick a first commit.'", "AppLocalizations.of(context)!.onboardingCommitTitle"),
    ("'Choose a standard habit or set your own day count. The science-backed 21, 33, and 40 day targets stay close by.'", "AppLocalizations.of(context)!.onboardingCommitBody"),
    ("'Partners'", "AppLocalizations.of(context)!.onboardingPartnersEyebrow"),
    ("'Bring a partner.'", "AppLocalizations.of(context)!.onboardingPartnersTitle"),
    ("'Shared habits show partner progress through habit-colored rings, so support lives directly on the habit card.'", "AppLocalizations.of(context)!.onboardingPartnersBody"),
    ("'Reminders'", "AppLocalizations.of(context)!.onboardingRemindersEyebrow"),
    ("'Let reminders stay gentle.'", "AppLocalizations.of(context)!.onboardingRemindersTitle"),
    ("'Hable asks before scheduling. Turn reminders on only when you want quiet nudges, not demands.'", "AppLocalizations.of(context)!.onboardingRemindersBody"),
    ("'Privacy'", "AppLocalizations.of(context)!.onboardingPrivacyEyebrow"),
    ("'Keep reflection private.'", "AppLocalizations.of(context)!.onboardingPrivacyTitle"),
    ("'Email verification waits in Settings, and journal reflections stay private. Partners see progress, not your notes.'", "AppLocalizations.of(context)!.onboardingPrivacyBody"),
    ("'Tracker'", "AppLocalizations.of(context)!.onboardingTrackerEyebrow"),
    ("'No skip button on the ring.'", "AppLocalizations.of(context)!.onboardingTrackerTitle"),
    ("'The main tracker is built for action. Missed days expire naturally, while private reflection stays available when needed.'", "AppLocalizations.of(context)!.onboardingTrackerBody"),
    ("'Start setup'", "AppLocalizations.of(context)!.onboardingStartSetup"),
    ("'Next'", "AppLocalizations.of(context)!.onboardingNext"),
    ("'Log in'", "AppLocalizations.of(context)!.onboardingLogIn"),
]

for old, new in replacements_onboard:
    content = content.replace(old, new)

if 'import \'package:hable/l10n/app_localizations.dart\';' not in content:
    content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:hable/l10n/app_localizations.dart';")

with open(onboard_file, 'w') as f:
    f.write(content)
print("Onboard screen updated")

profile_file = '/Users/h.ettefagh/Documents/VibeCoding/Flutter/hable/lib/screens/profile_screen.dart'
with open(profile_file, 'r') as f:
    content = f.read()

replacements_profile = [
    ("'Settings'", "AppLocalizations.of(context)!.settingsTitle"),
    ("'Account'", "AppLocalizations.of(context)!.settingsAccountTitle"),
    ("'User ID'", "AppLocalizations.of(context)!.settingsUserId"),
    ("'No email linked'", "AppLocalizations.of(context)!.settingsNoEmail"),
    ("'Log Out'", "AppLocalizations.of(context)!.settingsLogOut"),
    ("'Cloud Sync'", "AppLocalizations.of(context)!.settingsCloudSync"),
    ("'Enable Cloud Sync'", "AppLocalizations.of(context)!.settingsEnableCloudSync"),
    ("'Cloud sync is active.'", "AppLocalizations.of(context)!.settingsCloudSyncActive"),
    ("'Daily Reminder'", "AppLocalizations.of(context)!.settingsDailyReminder"),
    ("'Enable Daily Reminder'", "AppLocalizations.of(context)!.settingsEnableDailyReminder"),
    ("'Remind me at'", "AppLocalizations.of(context)!.settingsRemindMeAt"),
    ("'Mud Tuning'", "AppLocalizations.of(context)!.settingsMudTuning"),
    ("'Adjust the resistance and feel of the habit completion ring.'", "AppLocalizations.of(context)!.settingsMudTuningDesc"),
    ("'Duration'", "AppLocalizations.of(context)!.settingsDuration"),
    ("'Fast'", "AppLocalizations.of(context)!.settingsFast"),
    ("'Slow'", "AppLocalizations.of(context)!.settingsSlow"),
    ("'Resistance'", "AppLocalizations.of(context)!.settingsResistance"),
    ("'Light'", "AppLocalizations.of(context)!.settingsLight"),
    ("'Heavy'", "AppLocalizations.of(context)!.settingsHeavy"),
    ("'Haptics'", "AppLocalizations.of(context)!.settingsHaptics"),
    ("'Language'", "AppLocalizations.of(context)!.settingsLanguage"),
    ("'Accessibility'", "AppLocalizations.of(context)!.settingsAccessibility"),
]

for old, new in replacements_profile:
    content = content.replace(old, new)

if 'import \'package:hable/l10n/app_localizations.dart\';' not in content:
    content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:hable/l10n/app_localizations.dart';")

with open(profile_file, 'w') as f:
    f.write(content)
print("Profile screen updated")

