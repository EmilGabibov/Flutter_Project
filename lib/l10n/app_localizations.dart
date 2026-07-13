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

  /// No description provided for @socialTabTooltip.
  ///
  /// In en, this message translates to:
  /// **'Social — friends & partners'**
  String get socialTabTooltip;

  /// No description provided for @profileTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTabTitle;

  /// No description provided for @profileTabTooltip.
  ///
  /// In en, this message translates to:
  /// **'Profile — history & settings'**
  String get profileTabTooltip;

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

  /// No description provided for @appGateRestoredLocalSession.
  ///
  /// In en, this message translates to:
  /// **'Restored local session on macOS.'**
  String get appGateRestoredLocalSession;

  /// No description provided for @appGateUpdatingHable.
  ///
  /// In en, this message translates to:
  /// **'Updating Hable...'**
  String get appGateUpdatingHable;

  /// No description provided for @appGateRestoringSession.
  ///
  /// In en, this message translates to:
  /// **'Restoring session...'**
  String get appGateRestoringSession;

  /// No description provided for @appGatePreparingHabits.
  ///
  /// In en, this message translates to:
  /// **'Preparing your habits...'**
  String get appGatePreparingHabits;

  /// No description provided for @appGateLoadingProfileState.
  ///
  /// In en, this message translates to:
  /// **'Loading profile state...'**
  String get appGateLoadingProfileState;

  /// No description provided for @skipSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Skipping \"{habitTitle}\"'**
  String skipSheetTitle(String habitTitle);

  /// No description provided for @skipSheetBody.
  ///
  /// In en, this message translates to:
  /// **'This will add +2 days to your journey. Write a quick journal entry to continue.'**
  String get skipSheetBody;

  /// No description provided for @skipSheetHint.
  ///
  /// In en, this message translates to:
  /// **'Why are you skipping today?'**
  String get skipSheetHint;

  /// No description provided for @skipSheetConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm Skip'**
  String get skipSheetConfirm;

  /// No description provided for @mudCompleteHabitLabel.
  ///
  /// In en, this message translates to:
  /// **'Complete Habit'**
  String get mudCompleteHabitLabel;

  /// No description provided for @mudLongPressHint.
  ///
  /// In en, this message translates to:
  /// **'Long press to complete'**
  String get mudLongPressHint;

  /// No description provided for @mudDone.
  ///
  /// In en, this message translates to:
  /// **'Done!'**
  String get mudDone;

  /// No description provided for @mudHoldToComplete.
  ///
  /// In en, this message translates to:
  /// **'Hold to Complete'**
  String get mudHoldToComplete;

  /// No description provided for @socialSyncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get socialSyncNow;

  /// No description provided for @socialFindFriends.
  ///
  /// In en, this message translates to:
  /// **'Find friends'**
  String get socialFindFriends;

  /// No description provided for @partnerSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Partners'**
  String get partnerSectionTitle;

  /// No description provided for @partnerTickerStateNotCompletedYet.
  ///
  /// In en, this message translates to:
  /// **'not completed yet'**
  String get partnerTickerStateNotCompletedYet;

  /// No description provided for @partnerTickerProfileSemantics.
  ///
  /// In en, this message translates to:
  /// **'{name}, {state}. Opens profile.'**
  String partnerTickerProfileSemantics(String name, String state);

  /// No description provided for @partnerNoPartnersYet.
  ///
  /// In en, this message translates to:
  /// **'No partners on this habit yet.'**
  String get partnerNoPartnersYet;

  /// No description provided for @partnerNoPartnersShort.
  ///
  /// In en, this message translates to:
  /// **'No partners'**
  String get partnerNoPartnersShort;

  /// No description provided for @partnerStackCollapsedSemantics.
  ///
  /// In en, this message translates to:
  /// **'Partner stack. {count} total. Long press to expand partner states.'**
  String partnerStackCollapsedSemantics(int count);

  /// No description provided for @partnerExpandedSemantics.
  ///
  /// In en, this message translates to:
  /// **'Expanded partner states. Tap to collapse. Each row shows completion, pending, or nudged state.'**
  String get partnerExpandedSemantics;

  /// No description provided for @partnerTapToCollapse.
  ///
  /// In en, this message translates to:
  /// **'Tap to collapse'**
  String get partnerTapToCollapse;

  /// No description provided for @partnerStateCompleted.
  ///
  /// In en, this message translates to:
  /// **'completed'**
  String get partnerStateCompleted;

  /// No description provided for @partnerStateNudged.
  ///
  /// In en, this message translates to:
  /// **'nudged'**
  String get partnerStateNudged;

  /// No description provided for @partnerStateSupporter.
  ///
  /// In en, this message translates to:
  /// **'supporter'**
  String get partnerStateSupporter;

  /// No description provided for @partnerStatePending.
  ///
  /// In en, this message translates to:
  /// **'pending'**
  String get partnerStatePending;

  /// No description provided for @partnerStateCompletedToday.
  ///
  /// In en, this message translates to:
  /// **'completed today'**
  String get partnerStateCompletedToday;

  /// No description provided for @partnerStateSupporting.
  ///
  /// In en, this message translates to:
  /// **'supporting'**
  String get partnerStateSupporting;

  /// No description provided for @partnerStatusSemantics.
  ///
  /// In en, this message translates to:
  /// **'{name} status {state}'**
  String partnerStatusSemantics(String name, String state);

  /// No description provided for @partnerRoleOwner.
  ///
  /// In en, this message translates to:
  /// **'owner'**
  String get partnerRoleOwner;

  /// No description provided for @partnerRolePartner.
  ///
  /// In en, this message translates to:
  /// **'partner'**
  String get partnerRolePartner;

  /// No description provided for @partnerRoleSupporter.
  ///
  /// In en, this message translates to:
  /// **'supporter'**
  String get partnerRoleSupporter;

  /// No description provided for @partnerProfileSemantics.
  ///
  /// In en, this message translates to:
  /// **'{name}, {role}, {state}. Opens profile.'**
  String partnerProfileSemantics(String name, String role, String state);

  /// No description provided for @partnerNudgeSemantics.
  ///
  /// In en, this message translates to:
  /// **'Nudge {name} on this habit.'**
  String partnerNudgeSemantics(String name);

  /// No description provided for @partnerNudgeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Nudge {name}'**
  String partnerNudgeTooltip(String name);

  /// No description provided for @habitFormChooseIconTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose an icon'**
  String get habitFormChooseIconTitle;

  /// No description provided for @habitFormChooseIconBody.
  ///
  /// In en, this message translates to:
  /// **'Custom habits can keep this icon with the title.'**
  String get habitFormChooseIconBody;

  /// No description provided for @habitFormSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'That habit did not stick yet. Please try again.'**
  String get habitFormSaveFailed;

  /// No description provided for @habitFormPresetDescriptionFallback.
  ///
  /// In en, this message translates to:
  /// **'Name the behavior clearly so future you can understand it at a glance.'**
  String get habitFormPresetDescriptionFallback;

  /// No description provided for @habitFormCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Create habit'**
  String get habitFormCreateButton;

  /// No description provided for @habitFormSaveChangesButton.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get habitFormSaveChangesButton;

  /// No description provided for @habitFormCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Build a habit worth repeating'**
  String get habitFormCreateTitle;

  /// No description provided for @habitFormEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Refine this habit'**
  String get habitFormEditTitle;

  /// No description provided for @habitFormCreateBody.
  ///
  /// In en, this message translates to:
  /// **'Choose a pattern, tune the duration, and invite the right people before you commit.'**
  String get habitFormCreateBody;

  /// No description provided for @habitFormEditBody.
  ///
  /// In en, this message translates to:
  /// **'Adjust the title, timeline, and color without breaking the habit you already started.'**
  String get habitFormEditBody;

  /// No description provided for @habitFormNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Habit name'**
  String get habitFormNameLabel;

  /// No description provided for @habitFormNameHint.
  ///
  /// In en, this message translates to:
  /// **'Morning pages, no phone after 10, daily walk...'**
  String get habitFormNameHint;

  /// No description provided for @habitFormNameHelper.
  ///
  /// In en, this message translates to:
  /// **'Tap the icon to the left to personalize custom habits.'**
  String get habitFormNameHelper;

  /// No description provided for @habitFormNameErrorEmpty.
  ///
  /// In en, this message translates to:
  /// **'Give this habit a clear name.'**
  String get habitFormNameErrorEmpty;

  /// No description provided for @habitFormNameErrorShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least 3 characters.'**
  String get habitFormNameErrorShort;

  /// No description provided for @habitFormPresetTitle.
  ///
  /// In en, this message translates to:
  /// **'Start from a proven pattern'**
  String get habitFormPresetTitle;

  /// No description provided for @habitFormPresetBody.
  ///
  /// In en, this message translates to:
  /// **'Pick a template to preload the title, duration, color, and cue copy.'**
  String get habitFormPresetBody;

  /// No description provided for @habitFormDescriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get habitFormDescriptionTitle;

  /// No description provided for @habitFormDescriptionBody.
  ///
  /// In en, this message translates to:
  /// **'Use one or two lines to make the habit specific enough to repeat on rough days.'**
  String get habitFormDescriptionBody;

  /// No description provided for @habitFormDescriptionHelper.
  ///
  /// In en, this message translates to:
  /// **'This can surface on the primary habit card.'**
  String get habitFormDescriptionHelper;

  /// No description provided for @habitFormDescriptionErrorLong.
  ///
  /// In en, this message translates to:
  /// **'Keep the description under 160 characters.'**
  String get habitFormDescriptionErrorLong;

  /// No description provided for @habitFormDurationTitle.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get habitFormDurationTitle;

  /// No description provided for @habitFormDurationBody.
  ///
  /// In en, this message translates to:
  /// **'Popular challenge lengths help users commit to a finite promise.'**
  String get habitFormDurationBody;

  /// No description provided for @habitFormDurationChip.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String habitFormDurationChip(int days);

  /// No description provided for @habitFormCustomDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom number of days'**
  String get habitFormCustomDaysLabel;

  /// No description provided for @habitFormDurationErrorInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a number of days.'**
  String get habitFormDurationErrorInvalid;

  /// No description provided for @habitFormDurationErrorMin.
  ///
  /// In en, this message translates to:
  /// **'Duration must be at least 1 day.'**
  String get habitFormDurationErrorMin;

  /// No description provided for @habitFormColorTitle.
  ///
  /// In en, this message translates to:
  /// **'Ring color'**
  String get habitFormColorTitle;

  /// No description provided for @habitFormColorBody.
  ///
  /// In en, this message translates to:
  /// **'Choose the color this habit will carry across its card and celebrations.'**
  String get habitFormColorBody;

  /// No description provided for @habitFormPartnersTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite partners'**
  String get habitFormPartnersTitle;

  /// No description provided for @habitFormPartnersBody.
  ///
  /// In en, this message translates to:
  /// **'Shared habits can start with friends who already follow you.'**
  String get habitFormPartnersBody;

  /// No description provided for @habitFormNoFriends.
  ///
  /// In en, this message translates to:
  /// **'No friends found. Add friends from the Social tab first.'**
  String get habitFormNoFriends;

  /// No description provided for @habitFormFriendsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Hable could not load your friend list right now.'**
  String get habitFormFriendsLoadFailed;
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
