// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get homeTabTitle => 'Home';

  @override
  String get socialTabTitle => 'Social';

  @override
  String get profileTabTitle => 'Profile';

  @override
  String get activityTabTitle => 'Activity';

  @override
  String get friendsTabTitle => 'Friends';

  @override
  String get leaderboardTabTitle => 'Leaderboard';

  @override
  String get authWelcomeTitle => 'Welcome to\nHable.';

  @override
  String get authLoginSubtitle => 'Log in to continue your journey.';

  @override
  String get authLoginButton => 'Log In';

  @override
  String get authJoinTitle => 'Join Hable.';

  @override
  String get authJoinSubtitle =>
      'Choose a username and password. You can activate cloud recovery from Profile later.';

  @override
  String get authSignUpButton => 'Sign Up';

  @override
  String get authResetTitle => 'Reset Password';

  @override
  String get authResetSubtitle =>
      'Enter your email to receive a verification PIN.';

  @override
  String get authSendPinButton => 'Send PIN';

  @override
  String get authVerifyTitle => 'Verify PIN';

  @override
  String get authVerifySubtitle =>
      'Enter the PIN sent to your email and your new password.';

  @override
  String get authResetSuccessMessage =>
      'Password reset successful. Please log in.';

  @override
  String get authUsernameLabel => 'Username';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPinLabel => '6-digit PIN';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authNewPasswordLabel => 'New Password';

  @override
  String get authForgotPassword => 'Forgot Password?';

  @override
  String get authWorking => 'Working...';

  @override
  String get authNeedAccount => 'Need an account? Sign up';

  @override
  String get authAlreadyHaveAccount => 'Already have an account? Log in';

  @override
  String get authBackToLogin => 'Back to Login';

  @override
  String get authGdprFooter =>
      'Hable complies with European data protection requirements, including GDPR.';

  @override
  String get onboardingDayOneEyebrow => 'Day one';

  @override
  String get onboardingDayOneTitle => 'Every day is day one.';

  @override
  String get onboardingDayOneBody =>
      'Start with a calm read, then one deliberate action. Hable keeps the first step small enough to repeat.';

  @override
  String get onboardingMudEyebrow => 'Mud';

  @override
  String get onboardingMudTitle => 'Start through the mud.';

  @override
  String get onboardingMudBody =>
      'New habits ask for a steady 1500ms press. That resistance is the point: effort first, stability later.';

  @override
  String get onboardingCommitEyebrow => 'Commit';

  @override
  String get onboardingCommitTitle => 'Pick a first commit.';

  @override
  String get onboardingCommitBody =>
      'Choose a standard habit or set your own day count. The science-backed 21, 33, and 40 day targets stay close by.';

  @override
  String get onboardingPartnersEyebrow => 'Partners';

  @override
  String get onboardingPartnersTitle => 'Bring a partner.';

  @override
  String get onboardingPartnersBody =>
      'Shared habits show partner progress through habit-colored rings, so support lives directly on the habit card.';

  @override
  String get onboardingRemindersEyebrow => 'Reminders';

  @override
  String get onboardingRemindersTitle => 'Let reminders stay gentle.';

  @override
  String get onboardingRemindersBody =>
      'Hable asks before scheduling. Turn reminders on only when you want quiet nudges, not demands.';

  @override
  String get onboardingPrivacyEyebrow => 'Privacy';

  @override
  String get onboardingPrivacyTitle => 'Keep reflection private.';

  @override
  String get onboardingPrivacyBody =>
      'Email verification waits in Settings, and journal reflections stay private. Partners see progress, not your notes.';

  @override
  String get onboardingTrackerEyebrow => 'Tracker';

  @override
  String get onboardingTrackerTitle => 'No skip button on the ring.';

  @override
  String get onboardingTrackerBody =>
      'The main tracker is built for action. Missed days expire naturally, while private reflection stays available when needed.';

  @override
  String get onboardingStartSetup => 'Start setup';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingLogIn => 'Log in';

  @override
  String get habitSkipToday => 'Skip today';

  @override
  String get habitSkippedToday => 'Skipped today';

  @override
  String get habitCompletedToday => 'Completed today';

  @override
  String get habitNotCompletedToday => 'Not completed today';

  @override
  String get habitFollowing => 'Following';

  @override
  String get habitContinuous => 'Continuous';

  @override
  String habitDayProgress(int day, int total) {
    return 'Day $day of $total';
  }

  @override
  String habitNudgedBy(String name) {
    return 'Nudged by $name';
  }

  @override
  String habitNudgeQueued(String name) {
    return 'Nudge queued for $name';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAccountTitle => 'Account';

  @override
  String get settingsUserId => 'User ID';

  @override
  String get settingsNoEmail => 'No email linked';

  @override
  String get settingsLogOut => 'Log Out';

  @override
  String get settingsCloudSync => 'Cloud Sync';

  @override
  String get settingsEnableCloudSync => 'Enable Cloud Sync';

  @override
  String get settingsCloudSyncActive => 'Cloud sync is active.';

  @override
  String get settingsDailyReminder => 'Daily Reminder';

  @override
  String get settingsEnableDailyReminder => 'Enable Daily Reminder';

  @override
  String get settingsRemindMeAt => 'Remind me at';

  @override
  String get settingsMudTuning => 'Mud Tuning';

  @override
  String get settingsMudTuningDesc =>
      'Adjust the resistance and feel of the habit completion ring.';

  @override
  String get settingsDuration => 'Duration';

  @override
  String get settingsFast => 'Fast';

  @override
  String get settingsSlow => 'Slow';

  @override
  String get settingsResistance => 'Resistance';

  @override
  String get settingsLight => 'Light';

  @override
  String get settingsHeavy => 'Heavy';

  @override
  String get settingsHaptics => 'Haptics';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsAccessibility => 'Accessibility';

  @override
  String get dashboardMyHabits => 'My Habits';

  @override
  String get dashboardAddHabit => 'Add Habit';

  @override
  String get dashboardNoHabits =>
      'No habits yet. Tap the + to start your first challenge.';
}
