import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('fa'),
    Locale('ru'),
    Locale('ta'),
    Locale('ur'),
  ];

  /// No description provided for @homeTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTabTitle;

  /// No description provided for @socialTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get socialTabTitle;

  /// No description provided for @profileTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTabTitle;

  /// No description provided for @activityTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activityTabTitle;

  /// No description provided for @friendsTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friendsTabTitle;

  /// No description provided for @leaderboardTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboardTabTitle;

  /// No description provided for @authWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to\nHable.'**
  String get authWelcomeTitle;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to continue your journey.'**
  String get authLoginSubtitle;

  /// No description provided for @authLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get authLoginButton;

  /// No description provided for @authJoinTitle.
  ///
  /// In en, this message translates to:
  /// **'Join Hable.'**
  String get authJoinTitle;

  /// No description provided for @authJoinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a username and password. You can activate cloud recovery from Profile later.'**
  String get authJoinSubtitle;

  /// No description provided for @authSignUpButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get authSignUpButton;

  /// No description provided for @authResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get authResetTitle;

  /// No description provided for @authResetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive a verification PIN.'**
  String get authResetSubtitle;

  /// No description provided for @authSendPinButton.
  ///
  /// In en, this message translates to:
  /// **'Send PIN'**
  String get authSendPinButton;

  /// No description provided for @authVerifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify PIN'**
  String get authVerifyTitle;

  /// No description provided for @authVerifySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the PIN sent to your email and your new password.'**
  String get authVerifySubtitle;

  /// No description provided for @authResetSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Password reset successful. Please log in.'**
  String get authResetSuccessMessage;

  /// No description provided for @authUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get authUsernameLabel;

  /// No description provided for @authEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// No description provided for @authPinLabel.
  ///
  /// In en, this message translates to:
  /// **'6-digit PIN'**
  String get authPinLabel;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// No description provided for @authNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get authNewPasswordLabel;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get authForgotPassword;

  /// No description provided for @authWorking.
  ///
  /// In en, this message translates to:
  /// **'Working...'**
  String get authWorking;

  /// No description provided for @authNeedAccount.
  ///
  /// In en, this message translates to:
  /// **'Need an account? Sign up'**
  String get authNeedAccount;

  /// No description provided for @authAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Log in'**
  String get authAlreadyHaveAccount;

  /// No description provided for @authBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get authBackToLogin;

  /// No description provided for @authGdprFooter.
  ///
  /// In en, this message translates to:
  /// **'Hable complies with European data protection requirements, including GDPR.'**
  String get authGdprFooter;

  /// No description provided for @onboardingDayOneEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Day one'**
  String get onboardingDayOneEyebrow;

  /// No description provided for @onboardingDayOneTitle.
  ///
  /// In en, this message translates to:
  /// **'Every day is day one.'**
  String get onboardingDayOneTitle;

  /// No description provided for @onboardingDayOneBody.
  ///
  /// In en, this message translates to:
  /// **'Start with a calm read, then one deliberate action. Hable keeps the first step small enough to repeat.'**
  String get onboardingDayOneBody;

  /// No description provided for @onboardingMudEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Mud'**
  String get onboardingMudEyebrow;

  /// No description provided for @onboardingMudTitle.
  ///
  /// In en, this message translates to:
  /// **'Start through the mud.'**
  String get onboardingMudTitle;

  /// No description provided for @onboardingMudBody.
  ///
  /// In en, this message translates to:
  /// **'New habits ask for a steady 1500ms press. That resistance is the point: effort first, stability later.'**
  String get onboardingMudBody;

  /// No description provided for @onboardingCommitEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Commit'**
  String get onboardingCommitEyebrow;

  /// No description provided for @onboardingCommitTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a first commit.'**
  String get onboardingCommitTitle;

  /// No description provided for @onboardingCommitBody.
  ///
  /// In en, this message translates to:
  /// **'Choose a standard habit or set your own day count. The science-backed 21, 33, and 40 day targets stay close by.'**
  String get onboardingCommitBody;

  /// No description provided for @onboardingPartnersEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Partners'**
  String get onboardingPartnersEyebrow;

  /// No description provided for @onboardingPartnersTitle.
  ///
  /// In en, this message translates to:
  /// **'Bring a partner.'**
  String get onboardingPartnersTitle;

  /// No description provided for @onboardingPartnersBody.
  ///
  /// In en, this message translates to:
  /// **'Shared habits show partner progress through habit-colored rings, so support lives directly on the habit card.'**
  String get onboardingPartnersBody;

  /// No description provided for @onboardingRemindersEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get onboardingRemindersEyebrow;

  /// No description provided for @onboardingRemindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Let reminders stay gentle.'**
  String get onboardingRemindersTitle;

  /// No description provided for @onboardingRemindersBody.
  ///
  /// In en, this message translates to:
  /// **'Hable asks before scheduling. Turn reminders on only when you want quiet nudges, not demands.'**
  String get onboardingRemindersBody;

  /// No description provided for @onboardingPrivacyEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get onboardingPrivacyEyebrow;

  /// No description provided for @onboardingPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep reflection private.'**
  String get onboardingPrivacyTitle;

  /// No description provided for @onboardingPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'Email verification waits in Settings, and journal reflections stay private. Partners see progress, not your notes.'**
  String get onboardingPrivacyBody;

  /// No description provided for @onboardingTrackerEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Tracker'**
  String get onboardingTrackerEyebrow;

  /// No description provided for @onboardingTrackerTitle.
  ///
  /// In en, this message translates to:
  /// **'No skip button on the ring.'**
  String get onboardingTrackerTitle;

  /// No description provided for @onboardingTrackerBody.
  ///
  /// In en, this message translates to:
  /// **'The main tracker is built for action. Missed days expire naturally, while private reflection stays available when needed.'**
  String get onboardingTrackerBody;

  /// No description provided for @onboardingStartSetup.
  ///
  /// In en, this message translates to:
  /// **'Start setup'**
  String get onboardingStartSetup;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingLogIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get onboardingLogIn;

  /// No description provided for @habitSkipToday.
  ///
  /// In en, this message translates to:
  /// **'Skip today'**
  String get habitSkipToday;

  /// No description provided for @habitSkippedToday.
  ///
  /// In en, this message translates to:
  /// **'Skipped today'**
  String get habitSkippedToday;

  /// No description provided for @habitCompletedToday.
  ///
  /// In en, this message translates to:
  /// **'Completed today'**
  String get habitCompletedToday;

  /// No description provided for @habitNotCompletedToday.
  ///
  /// In en, this message translates to:
  /// **'Not completed today'**
  String get habitNotCompletedToday;

  /// No description provided for @habitFollowing.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get habitFollowing;

  /// No description provided for @habitContinuous.
  ///
  /// In en, this message translates to:
  /// **'Continuous'**
  String get habitContinuous;

  /// No description provided for @habitDayProgress.
  ///
  /// In en, this message translates to:
  /// **'Day {day} of {total}'**
  String habitDayProgress(int day, int total);

  /// No description provided for @habitNudgedBy.
  ///
  /// In en, this message translates to:
  /// **'Nudged by {name}'**
  String habitNudgedBy(String name);

  /// No description provided for @habitNudgeQueued.
  ///
  /// In en, this message translates to:
  /// **'Nudge queued for {name}'**
  String habitNudgeQueued(String name);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccountTitle;

  /// No description provided for @settingsUserId.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get settingsUserId;

  /// No description provided for @settingsNoEmail.
  ///
  /// In en, this message translates to:
  /// **'No email linked'**
  String get settingsNoEmail;

  /// No description provided for @settingsLogOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get settingsLogOut;

  /// No description provided for @settingsCloudSync.
  ///
  /// In en, this message translates to:
  /// **'Cloud Sync'**
  String get settingsCloudSync;

  /// No description provided for @settingsEnableCloudSync.
  ///
  /// In en, this message translates to:
  /// **'Enable Cloud Sync'**
  String get settingsEnableCloudSync;

  /// No description provided for @settingsCloudSyncActive.
  ///
  /// In en, this message translates to:
  /// **'Cloud sync is active.'**
  String get settingsCloudSyncActive;

  /// No description provided for @settingsDailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminder'**
  String get settingsDailyReminder;

  /// No description provided for @settingsEnableDailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Enable Daily Reminder'**
  String get settingsEnableDailyReminder;

  /// No description provided for @settingsRemindMeAt.
  ///
  /// In en, this message translates to:
  /// **'Remind me at'**
  String get settingsRemindMeAt;

  /// No description provided for @settingsMudTuning.
  ///
  /// In en, this message translates to:
  /// **'Mud Tuning'**
  String get settingsMudTuning;

  /// No description provided for @settingsMudTuningDesc.
  ///
  /// In en, this message translates to:
  /// **'Adjust the resistance and feel of the habit completion ring.'**
  String get settingsMudTuningDesc;

  /// No description provided for @settingsDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get settingsDuration;

  /// No description provided for @settingsFast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get settingsFast;

  /// No description provided for @settingsSlow.
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get settingsSlow;

  /// No description provided for @settingsResistance.
  ///
  /// In en, this message translates to:
  /// **'Resistance'**
  String get settingsResistance;

  /// No description provided for @settingsLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsLight;

  /// No description provided for @settingsHeavy.
  ///
  /// In en, this message translates to:
  /// **'Heavy'**
  String get settingsHeavy;

  /// No description provided for @settingsHaptics.
  ///
  /// In en, this message translates to:
  /// **'Haptics'**
  String get settingsHaptics;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsAccessibility.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get settingsAccessibility;

  /// No description provided for @dashboardMyHabits.
  ///
  /// In en, this message translates to:
  /// **'My Habits'**
  String get dashboardMyHabits;

  /// No description provided for @dashboardAddHabit.
  ///
  /// In en, this message translates to:
  /// **'Add Habit'**
  String get dashboardAddHabit;

  /// No description provided for @dashboardNoHabits.
  ///
  /// In en, this message translates to:
  /// **'No habits yet. Tap the + to start your first challenge.'**
  String get dashboardNoHabits;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'fa',
    'ru',
    'ta',
    'ur',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
    case 'ru':
      return AppLocalizationsRu();
    case 'ta':
      return AppLocalizationsTa();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
