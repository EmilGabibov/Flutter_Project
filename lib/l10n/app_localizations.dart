import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_id.dart';
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
    Locale('id'),
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

  /// No description provided for @appStartupOpening.
  ///
  /// In en, this message translates to:
  /// **'Opening Hable'**
  String get appStartupOpening;

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
  /// **'Pick a name, choose a finite challenge length, and start cleanly.'**
  String get habitFormCreateBody;

  /// No description provided for @habitFormEditBody.
  ///
  /// In en, this message translates to:
  /// **'Adjust the title, timeline, and color without resetting your progress.'**
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
  /// **'Default is 21 days. Use anchors for the usual milestones or slide for any finite plan.'**
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

  /// No description provided for @homeCreateHabitSemantics.
  ///
  /// In en, this message translates to:
  /// **'Create a new habit'**
  String get homeCreateHabitSemantics;

  /// No description provided for @homeCreateHabitCta.
  ///
  /// In en, this message translates to:
  /// **'Habit'**
  String get homeCreateHabitCta;

  /// No description provided for @homeLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Hable could not load today\'s habits right now.'**
  String get homeLoadFailed;

  /// No description provided for @homeFriendFallback.
  ///
  /// In en, this message translates to:
  /// **'Friend'**
  String get homeFriendFallback;

  /// No description provided for @homeOpenDashboard.
  ///
  /// In en, this message translates to:
  /// **'Open dashboard'**
  String get homeOpenDashboard;

  /// No description provided for @homeOpenNotifications.
  ///
  /// In en, this message translates to:
  /// **'Open notifications'**
  String get homeOpenNotifications;

  /// No description provided for @homeNoHabits.
  ///
  /// In en, this message translates to:
  /// **'No active habits yet.\nStart one from Home.'**
  String get homeNoHabits;

  /// No description provided for @homeAddHabit.
  ///
  /// In en, this message translates to:
  /// **'Add habit'**
  String get homeAddHabit;

  /// No description provided for @homeGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get homeGreetingMorning;

  /// No description provided for @homeGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get homeGreetingAfternoon;

  /// No description provided for @homeGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get homeGreetingEvening;

  /// No description provided for @homeSuggestedHabits.
  ///
  /// In en, this message translates to:
  /// **'Suggested Habits'**
  String get homeSuggestedHabits;

  /// No description provided for @profileBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get profileBack;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get profileOpenSettings;

  /// No description provided for @profileUserFallback.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get profileUserFallback;

  /// No description provided for @profileUsernameFallback.
  ///
  /// In en, this message translates to:
  /// **'user'**
  String get profileUsernameFallback;

  /// No description provided for @profileLevelFallback.
  ///
  /// In en, this message translates to:
  /// **'Newbie'**
  String get profileLevelFallback;

  /// No description provided for @profileLifetimePoints.
  ///
  /// In en, this message translates to:
  /// **'{points} lifetime pts'**
  String profileLifetimePoints(int points);

  /// No description provided for @profileLifetimeScoreHint.
  ///
  /// In en, this message translates to:
  /// **'Lifetime score comes from backend sync. Journey and history show per-check-in awards.'**
  String get profileLifetimeScoreHint;

  /// No description provided for @profileTrophyRoomTab.
  ///
  /// In en, this message translates to:
  /// **'Trophy Room'**
  String get profileTrophyRoomTab;

  /// No description provided for @profileJourneyTab.
  ///
  /// In en, this message translates to:
  /// **'Journey'**
  String get profileJourneyTab;

  /// No description provided for @profileAchievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get profileAchievementsTitle;

  /// No description provided for @profileFirstBadgeHint.
  ///
  /// In en, this message translates to:
  /// **'Complete a habit to earn your first badge!'**
  String get profileFirstBadgeHint;

  /// No description provided for @profileHabitDistributionTitle.
  ///
  /// In en, this message translates to:
  /// **'Habit Distribution'**
  String get profileHabitDistributionTitle;

  /// No description provided for @profileNoData.
  ///
  /// In en, this message translates to:
  /// **'No data yet'**
  String get profileNoData;

  /// No description provided for @profileCompletedLegend.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get profileCompletedLegend;

  /// No description provided for @profileSkippedLegend.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get profileSkippedLegend;

  /// No description provided for @profileOverdueLegend.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get profileOverdueLegend;

  /// No description provided for @profileThirtyDayPointsTitle.
  ///
  /// In en, this message translates to:
  /// **'30-Day Points Earned'**
  String get profileThirtyDayPointsTitle;

  /// No description provided for @profileThirtyDayPointsHint.
  ///
  /// In en, this message translates to:
  /// **'Per-check-in awards from local history. Lifetime score updates separately from daily sync.'**
  String get profileThirtyDayPointsHint;

  /// No description provided for @profileCalendarSubscriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar Subscription'**
  String get profileCalendarSubscriptionTitle;

  /// No description provided for @profileCalendarSubscriptionBody.
  ///
  /// In en, this message translates to:
  /// **'Add your habits to your native calendar app'**
  String get profileCalendarSubscriptionBody;

  /// No description provided for @profileManageHabitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Habits'**
  String get profileManageHabitsTitle;

  /// No description provided for @profileAddNew.
  ///
  /// In en, this message translates to:
  /// **'Add New'**
  String get profileAddNew;

  /// No description provided for @profileSectionActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get profileSectionActive;

  /// No description provided for @profileSectionHallOfFame.
  ///
  /// In en, this message translates to:
  /// **'Hall of Fame'**
  String get profileSectionHallOfFame;

  /// No description provided for @profileSectionArchivedHistory.
  ///
  /// In en, this message translates to:
  /// **'Archived history'**
  String get profileSectionArchivedHistory;

  /// No description provided for @profileFriendProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Friend Profile'**
  String get profileFriendProfileTitle;

  /// No description provided for @profileFriendLevel.
  ///
  /// In en, this message translates to:
  /// **'{level} level'**
  String profileFriendLevel(String level);

  /// No description provided for @profileActiveHabitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Active Habits'**
  String get profileActiveHabitsTitle;

  /// No description provided for @profileNoActiveHabits.
  ///
  /// In en, this message translates to:
  /// **'No active habits.'**
  String get profileNoActiveHabits;

  /// No description provided for @profileFriendLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load friend profile.'**
  String get profileFriendLoadFailed;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Habit Dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashboardAchievementUnlocked.
  ///
  /// In en, this message translates to:
  /// **'You unlocked a new badge!'**
  String get dashboardAchievementUnlocked;

  /// No description provided for @dashboardLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Hable could not load this habit dashboard right now.'**
  String get dashboardLoadFailed;

  /// No description provided for @dashboardEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No active habits yet. Create one from Home to see it here.'**
  String get dashboardEmptyState;

  /// No description provided for @dashboardSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard Summary'**
  String get dashboardSummaryTitle;

  /// No description provided for @dashboardActiveHabitsLabel.
  ///
  /// In en, this message translates to:
  /// **'Active habits'**
  String get dashboardActiveHabitsLabel;

  /// No description provided for @dashboardChallengeHabitsLabel.
  ///
  /// In en, this message translates to:
  /// **'Challenge habits'**
  String get dashboardChallengeHabitsLabel;

  /// No description provided for @dashboardContinuousHabitsLabel.
  ///
  /// In en, this message translates to:
  /// **'Continuous habits'**
  String get dashboardContinuousHabitsLabel;

  /// No description provided for @dashboardQuoteOfDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Quote of the day'**
  String get dashboardQuoteOfDayTitle;

  /// No description provided for @dashboardQuoteLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading quote...'**
  String get dashboardQuoteLoading;

  /// No description provided for @dashboardQuoteFallback.
  ///
  /// In en, this message translates to:
  /// **'Keep going. The dashboard is here when you need the full field view.'**
  String get dashboardQuoteFallback;

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationTitle;

  /// No description provided for @notificationMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get notificationMarkAllRead;

  /// No description provided for @notificationEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notificationEmptyTitle;

  /// No description provided for @notificationEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Friend requests, invites, nudges, and reminder updates will appear here.'**
  String get notificationEmptyBody;

  /// No description provided for @notificationToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get notificationToday;

  /// No description provided for @notificationYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get notificationYesterday;

  /// No description provided for @notificationOlder.
  ///
  /// In en, this message translates to:
  /// **'Older'**
  String get notificationOlder;

  /// No description provided for @notificationLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Hable could not load your notifications right now.'**
  String get notificationLoadFailed;

  /// No description provided for @notificationJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get notificationJustNow;

  /// No description provided for @notificationMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String notificationMinutesAgo(int minutes);

  /// No description provided for @notificationHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String notificationHoursAgo(int hours);

  /// No description provided for @notificationDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String notificationDaysAgo(int days);

  /// No description provided for @settingsSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get settingsSessionTitle;

  /// No description provided for @settingsSessionBody.
  ///
  /// In en, this message translates to:
  /// **'Sign out of this device. Local reminder scheduling is canceled for this user.'**
  String get settingsSessionBody;

  /// No description provided for @settingsRecoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Recover This Device'**
  String get settingsRecoverTitle;

  /// No description provided for @settingsRecoverBody.
  ///
  /// In en, this message translates to:
  /// **'This clears local Hable data on this device and sends you back to login. Use it if the app is stuck or showing old cached state.'**
  String get settingsRecoverBody;

  /// No description provided for @settingsCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsCancel;

  /// No description provided for @settingsClearAndSignInAgain.
  ///
  /// In en, this message translates to:
  /// **'Clear and Sign In Again'**
  String get settingsClearAndSignInAgain;

  /// No description provided for @settingsRecoverAction.
  ///
  /// In en, this message translates to:
  /// **'Update / Recover App'**
  String get settingsRecoverAction;

  /// No description provided for @settingsSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get settingsSignOut;

  /// No description provided for @commonAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get commonAccept;

  /// No description provided for @commonDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get commonDecline;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get commonRemove;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get commonYou;

  /// No description provided for @socialActivityUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get socialActivityUnread;

  /// No description provided for @socialActivityEarlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get socialActivityEarlier;

  /// No description provided for @socialSearchFailed.
  ///
  /// In en, this message translates to:
  /// **'Hable could not search for friends just now. Please try again.'**
  String get socialSearchFailed;

  /// No description provided for @socialFriendRequestSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Hable could not send that friend request just now.'**
  String get socialFriendRequestSendFailed;

  /// No description provided for @socialFriendRequestAcceptFailed.
  ///
  /// In en, this message translates to:
  /// **'Hable could not accept that request right now.'**
  String get socialFriendRequestAcceptFailed;

  /// No description provided for @socialFriendRequestDeclineFailed.
  ///
  /// In en, this message translates to:
  /// **'Hable could not decline that request right now.'**
  String get socialFriendRequestDeclineFailed;

  /// No description provided for @socialFriendRevokeFailed.
  ///
  /// In en, this message translates to:
  /// **'Hable could not update that friendship right now.'**
  String get socialFriendRevokeFailed;

  /// No description provided for @socialFriendRequestAlreadyFriends.
  ///
  /// In en, this message translates to:
  /// **'You are already friends with {username}.'**
  String socialFriendRequestAlreadyFriends(String username);

  /// No description provided for @socialFriendRequestIncomingExists.
  ///
  /// In en, this message translates to:
  /// **'{username} already sent you a request. Check Requests.'**
  String socialFriendRequestIncomingExists(String username);

  /// No description provided for @socialFriendRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Friend request sent to {username}.'**
  String socialFriendRequestSent(String username);

  /// No description provided for @socialFriendAccepted.
  ///
  /// In en, this message translates to:
  /// **'You are now friends with {username}!'**
  String socialFriendAccepted(String username);

  /// No description provided for @socialFriendDeclined.
  ///
  /// In en, this message translates to:
  /// **'Declined request from {username}.'**
  String socialFriendDeclined(String username);

  /// No description provided for @socialFriendRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed {username} from friends.'**
  String socialFriendRemoved(String username);

  /// No description provided for @socialFriendActionsUnfriend.
  ///
  /// In en, this message translates to:
  /// **'Unfriend'**
  String get socialFriendActionsUnfriend;

  /// No description provided for @socialFriendActionsRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove friend?'**
  String get socialFriendActionsRemoveTitle;

  /// No description provided for @socialFriendActionsRemoveBody.
  ///
  /// In en, this message translates to:
  /// **'Remove {username} from your friends list?'**
  String socialFriendActionsRemoveBody(String username);

  /// No description provided for @socialNoFriendsTitle.
  ///
  /// In en, this message translates to:
  /// **'No friends yet'**
  String get socialNoFriendsTitle;

  /// No description provided for @socialNoFriendsBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the search icon above to find and add friends.'**
  String get socialNoFriendsBody;

  /// No description provided for @socialFriendLongPressActions.
  ///
  /// In en, this message translates to:
  /// **'Long-press for actions'**
  String get socialFriendLongPressActions;

  /// No description provided for @socialFriendsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Hable could not load your friends right now.'**
  String get socialFriendsLoadFailed;

  /// No description provided for @socialNotSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Not signed in'**
  String get socialNotSignedIn;

  /// No description provided for @socialNoActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'No activity yet'**
  String get socialNoActivityTitle;

  /// No description provided for @socialNoActivityBody.
  ///
  /// In en, this message translates to:
  /// **'Nudges, friend requests, invites, and messages from friends will appear here.'**
  String get socialNoActivityBody;

  /// No description provided for @socialLeaderboardEmpty.
  ///
  /// In en, this message translates to:
  /// **'No leaderboard scores yet.'**
  String get socialLeaderboardEmpty;

  /// No description provided for @socialLeaderboardNoValidScores.
  ///
  /// In en, this message translates to:
  /// **'No valid leaderboard scores found.'**
  String get socialLeaderboardNoValidScores;

  /// No description provided for @socialLeaderboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Friends Leaderboard'**
  String get socialLeaderboardTitle;

  /// No description provided for @socialLeaderboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Accepted friends ranked by lifetime score'**
  String get socialLeaderboardSubtitle;

  /// No description provided for @socialLeaderboardScopeFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get socialLeaderboardScopeFriends;

  /// No description provided for @socialLeaderboardLoadTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load leaderboard'**
  String get socialLeaderboardLoadTitle;

  /// No description provided for @socialLeaderboardLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Hable could not load the leaderboard right now.'**
  String get socialLeaderboardLoadFailed;

  /// No description provided for @socialFriendRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Friend Requests'**
  String get socialFriendRequestsTitle;

  /// No description provided for @socialFriendRequestIncomingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sent you a friend request'**
  String get socialFriendRequestIncomingSubtitle;

  /// No description provided for @socialFindFriendsTitle.
  ///
  /// In en, this message translates to:
  /// **'Find Friends'**
  String get socialFindFriendsTitle;

  /// No description provided for @socialFindFriendsSearchLabel.
  ///
  /// In en, this message translates to:
  /// **'Search username...'**
  String get socialFindFriendsSearchLabel;

  /// No description provided for @socialFindFriendsTypeMore.
  ///
  /// In en, this message translates to:
  /// **'Type at least 2 characters to search.'**
  String get socialFindFriendsTypeMore;

  /// No description provided for @socialFindFriendsNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No matches found.'**
  String get socialFindFriendsNoMatches;

  /// No description provided for @socialRelationshipAcceptedFriend.
  ///
  /// In en, this message translates to:
  /// **'Accepted friend'**
  String get socialRelationshipAcceptedFriend;

  /// No description provided for @socialRelationshipRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Request sent'**
  String get socialRelationshipRequestSent;

  /// No description provided for @socialRelationshipWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for your response'**
  String get socialRelationshipWaiting;

  /// No description provided for @socialRelationshipNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get socialRelationshipNotConnected;

  /// No description provided for @socialChipFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get socialChipFriends;

  /// No description provided for @socialChipRequested.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get socialChipRequested;

  /// No description provided for @socialChipRespondInFriends.
  ///
  /// In en, this message translates to:
  /// **'Respond in Friends'**
  String get socialChipRespondInFriends;

  /// No description provided for @socialSendFriendRequestTooltip.
  ///
  /// In en, this message translates to:
  /// **'Send friend request'**
  String get socialSendFriendRequestTooltip;

  /// No description provided for @habitCompletionProgressSemantics.
  ///
  /// In en, this message translates to:
  /// **'Completion progress {percent} percent.'**
  String habitCompletionProgressSemantics(int percent);

  /// No description provided for @leaderboardRankingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Rankings'**
  String get leaderboardRankingsTitle;

  /// No description provided for @leaderboardShowMore.
  ///
  /// In en, this message translates to:
  /// **'Show {count} more'**
  String leaderboardShowMore(int count);

  /// No description provided for @leaderboardShowingAll.
  ///
  /// In en, this message translates to:
  /// **'Showing all {count}'**
  String leaderboardShowingAll(int count);

  /// No description provided for @leaderboardYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get leaderboardYou;

  /// No description provided for @leaderboardUnknownUser.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get leaderboardUnknownUser;

  /// No description provided for @leaderboardLifetime.
  ///
  /// In en, this message translates to:
  /// **'lifetime'**
  String get leaderboardLifetime;

  /// No description provided for @leaderboardLifetimeScoreByline.
  ///
  /// In en, this message translates to:
  /// **'Lifetime score'**
  String get leaderboardLifetimeScoreByline;

  /// No description provided for @settingsNoVerifiedEmailYet.
  ///
  /// In en, this message translates to:
  /// **'No verified email yet'**
  String get settingsNoVerifiedEmailYet;

  /// No description provided for @settingsCustomizeAvatar.
  ///
  /// In en, this message translates to:
  /// **'Customize avatar'**
  String get settingsCustomizeAvatar;

  /// No description provided for @settingsMudFeelTitle.
  ///
  /// In en, this message translates to:
  /// **'Mud feel'**
  String get settingsMudFeelTitle;

  /// No description provided for @settingsMudFeelBody.
  ///
  /// In en, this message translates to:
  /// **'Tune hold resistance and haptic feedback on this device with bounded presets.'**
  String get settingsMudFeelBody;

  /// No description provided for @settingsMudPresetGentle.
  ///
  /// In en, this message translates to:
  /// **'Gentle'**
  String get settingsMudPresetGentle;

  /// No description provided for @settingsMudPresetStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get settingsMudPresetStandard;

  /// No description provided for @settingsMudPresetIntense.
  ///
  /// In en, this message translates to:
  /// **'Intense'**
  String get settingsMudPresetIntense;

  /// No description provided for @settingsMudHapticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Mud haptics'**
  String get settingsMudHapticsTitle;

  /// No description provided for @settingsMudHapticsSoft.
  ///
  /// In en, this message translates to:
  /// **'Soft taps during hold and a light completion pulse.'**
  String get settingsMudHapticsSoft;

  /// No description provided for @settingsMudHapticsStandard.
  ///
  /// In en, this message translates to:
  /// **'Balanced hold taps and standard completion feedback.'**
  String get settingsMudHapticsStandard;

  /// No description provided for @settingsMudHapticsStrong.
  ///
  /// In en, this message translates to:
  /// **'Heavier completion feedback with denser hold taps.'**
  String get settingsMudHapticsStrong;

  /// No description provided for @settingsVerificationPinSent.
  ///
  /// In en, this message translates to:
  /// **'Verification PIN sent.'**
  String get settingsVerificationPinSent;

  /// No description provided for @settingsCloudSyncActivated.
  ///
  /// In en, this message translates to:
  /// **'Cloud sync activated.'**
  String get settingsCloudSyncActivated;

  /// No description provided for @settingsCloudSyncActiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Cloud sync active'**
  String get settingsCloudSyncActiveTitle;

  /// No description provided for @settingsActivateCloudSyncTitle.
  ///
  /// In en, this message translates to:
  /// **'Activate cloud sync'**
  String get settingsActivateCloudSyncTitle;

  /// No description provided for @settingsCloudSyncLinkedToEmail.
  ///
  /// In en, this message translates to:
  /// **'Progress recovery is linked to {email}.'**
  String settingsCloudSyncLinkedToEmail(String email);

  /// No description provided for @settingsCloudSyncInactiveBody.
  ///
  /// In en, this message translates to:
  /// **'Add a verified email when you want recoverable cloud progress and password reset support.'**
  String get settingsCloudSyncInactiveBody;

  /// No description provided for @settingsChangeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change email'**
  String get settingsChangeEmail;

  /// No description provided for @settingsDailyRemindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily reminders'**
  String get settingsDailyRemindersTitle;

  /// No description provided for @settingsDailyRemindersEmpty.
  ///
  /// In en, this message translates to:
  /// **'Enable daily reminders to return to your habits.'**
  String get settingsDailyRemindersEmpty;

  /// No description provided for @settingsDailyRemindersEnabled.
  ///
  /// In en, this message translates to:
  /// **'Hable will remind you each day at these times.'**
  String get settingsDailyRemindersEnabled;

  /// No description provided for @settingsEnableInSystemSettings.
  ///
  /// In en, this message translates to:
  /// **'Enable in System Settings'**
  String get settingsEnableInSystemSettings;

  /// No description provided for @settingsAddTime.
  ///
  /// In en, this message translates to:
  /// **'Add Time'**
  String get settingsAddTime;

  /// No description provided for @settingsStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get settingsStatusActive;

  /// No description provided for @settingsStatusSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get settingsStatusSaved;

  /// No description provided for @settingsStatusOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get settingsStatusOn;

  /// No description provided for @settingsStatusOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get settingsStatusOff;

  /// No description provided for @settingsReminderUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Reminder scheduling is not available on this platform.'**
  String get settingsReminderUnsupported;

  /// No description provided for @settingsRemindersBlocked.
  ///
  /// In en, this message translates to:
  /// **'Notifications are blocked. Enable them in System Settings.'**
  String get settingsRemindersBlocked;

  /// No description provided for @settingsRemoveReminderTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove reminder'**
  String get settingsRemoveReminderTooltip;

  /// No description provided for @settingsRemindersLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Hable could not load your reminders right now.'**
  String get settingsRemindersLoadFailed;

  /// No description provided for @profileHabitFallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Habit'**
  String get profileHabitFallbackTitle;

  /// No description provided for @profileDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String profileDaysLabel(int days);

  /// No description provided for @profileDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{days} days left'**
  String profileDaysLeft(int days);

  /// No description provided for @profileDayChallenge.
  ///
  /// In en, this message translates to:
  /// **'{days} day challenge'**
  String profileDayChallenge(int days);

  /// No description provided for @profileFriendHabitBody.
  ///
  /// In en, this message translates to:
  /// **'Encourage your friend or follow the same habit yourself.'**
  String get profileFriendHabitBody;

  /// No description provided for @profileEncouragementQueued.
  ///
  /// In en, this message translates to:
  /// **'Encouragement queued for {title}.'**
  String profileEncouragementQueued(String title);

  /// No description provided for @profileEncourage.
  ///
  /// In en, this message translates to:
  /// **'Encourage'**
  String get profileEncourage;

  /// No description provided for @profileFollow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get profileFollow;

  /// No description provided for @profileAchievementFirstCheckIn.
  ///
  /// In en, this message translates to:
  /// **'First check-in'**
  String get profileAchievementFirstCheckIn;

  /// No description provided for @profileAchievementTenStreak.
  ///
  /// In en, this message translates to:
  /// **'10-day streak'**
  String get profileAchievementTenStreak;

  /// No description provided for @profileAchievementHundredStreak.
  ///
  /// In en, this message translates to:
  /// **'100-day streak'**
  String get profileAchievementHundredStreak;

  /// No description provided for @profileAchievementThousandStreak.
  ///
  /// In en, this message translates to:
  /// **'1000-day streak'**
  String get profileAchievementThousandStreak;

  /// No description provided for @profileAchievementFirstNudge.
  ///
  /// In en, this message translates to:
  /// **'First nudge'**
  String get profileAchievementFirstNudge;

  /// No description provided for @profileAchievementFirstSupporter.
  ///
  /// In en, this message translates to:
  /// **'First supporter'**
  String get profileAchievementFirstSupporter;

  /// No description provided for @profileSharedHabit.
  ///
  /// In en, this message translates to:
  /// **'Shared habit'**
  String get profileSharedHabit;

  /// No description provided for @profileSoloHabit.
  ///
  /// In en, this message translates to:
  /// **'Solo habit'**
  String get profileSoloHabit;

  /// No description provided for @profileOpenHabitActions.
  ///
  /// In en, this message translates to:
  /// **'Open habit actions'**
  String get profileOpenHabitActions;

  /// No description provided for @profileDeleteHabitTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete habit?'**
  String get profileDeleteHabitTitle;

  /// No description provided for @profileDeleteHabitBody.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete \"{title}\" and remove it from synced devices.'**
  String profileDeleteHabitBody(String title);

  /// No description provided for @profileArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get profileArchive;

  /// No description provided for @profileViewHistory.
  ///
  /// In en, this message translates to:
  /// **'View History'**
  String get profileViewHistory;

  /// No description provided for @profileRerun.
  ///
  /// In en, this message translates to:
  /// **'Rerun'**
  String get profileRerun;

  /// No description provided for @profileRoleOwnerView.
  ///
  /// In en, this message translates to:
  /// **'Owner view'**
  String get profileRoleOwnerView;

  /// No description provided for @profileRolePartnerView.
  ///
  /// In en, this message translates to:
  /// **'Partner view'**
  String get profileRolePartnerView;

  /// No description provided for @profileRoleSupporterView.
  ///
  /// In en, this message translates to:
  /// **'Supporter view'**
  String get profileRoleSupporterView;

  /// No description provided for @profileHistoryIntro.
  ///
  /// In en, this message translates to:
  /// **'Archived challenge history and per-check-in awards'**
  String get profileHistoryIntro;

  /// No description provided for @profileNoHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No history recorded yet.'**
  String get profileNoHistoryYet;

  /// No description provided for @profilePointsAwarded.
  ///
  /// In en, this message translates to:
  /// **'+{points} pts'**
  String profilePointsAwarded(int points);

  /// No description provided for @profileUnableLoadHistory.
  ///
  /// In en, this message translates to:
  /// **'Unable to load habit history.'**
  String get profileUnableLoadHistory;

  /// No description provided for @profileHistoryCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get profileHistoryCompleted;

  /// No description provided for @profileHistorySkippedWithNote.
  ///
  /// In en, this message translates to:
  /// **'Skipped: {note}'**
  String profileHistorySkippedWithNote(String note);

  /// No description provided for @profileHistorySkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get profileHistorySkipped;

  /// No description provided for @profileCalendarUnknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get profileCalendarUnknownError;

  /// No description provided for @profileCalendarGenerateLink.
  ///
  /// In en, this message translates to:
  /// **'Generate Subscription Link'**
  String get profileCalendarGenerateLink;

  /// No description provided for @profileCalendarSubscriptionUrl.
  ///
  /// In en, this message translates to:
  /// **'Subscription URL'**
  String get profileCalendarSubscriptionUrl;

  /// No description provided for @profileCalendarCopied.
  ///
  /// In en, this message translates to:
  /// **'Calendar feed URL copied to clipboard'**
  String get profileCalendarCopied;

  /// No description provided for @profileCalendarCopyTooltip.
  ///
  /// In en, this message translates to:
  /// **'Copy subscription URL'**
  String get profileCalendarCopyTooltip;

  /// No description provided for @profileCalendarPasteHint.
  ///
  /// In en, this message translates to:
  /// **'Paste this URL into your native calendar app to subscribe'**
  String get profileCalendarPasteHint;

  /// No description provided for @profileCalendarRotateToken.
  ///
  /// In en, this message translates to:
  /// **'Rotate Token'**
  String get profileCalendarRotateToken;

  /// No description provided for @profileCalendarRotateHint.
  ///
  /// In en, this message translates to:
  /// **'Rotating the token will invalidate the old subscription link'**
  String get profileCalendarRotateHint;

  /// No description provided for @accessibilityReducedMotionTitle.
  ///
  /// In en, this message translates to:
  /// **'Reduced Motion'**
  String get accessibilityReducedMotionTitle;

  /// No description provided for @accessibilityReducedMotionBody.
  ///
  /// In en, this message translates to:
  /// **'Disable animations and transitions'**
  String get accessibilityReducedMotionBody;

  /// No description provided for @accessibilityHighContrastTitle.
  ///
  /// In en, this message translates to:
  /// **'High Contrast'**
  String get accessibilityHighContrastTitle;

  /// No description provided for @accessibilityHighContrastBody.
  ///
  /// In en, this message translates to:
  /// **'Increase color contrast for better readability'**
  String get accessibilityHighContrastBody;

  /// No description provided for @accessibilityLargerTextTitle.
  ///
  /// In en, this message translates to:
  /// **'Larger Text'**
  String get accessibilityLargerTextTitle;

  /// No description provided for @accessibilityLargerTextBody.
  ///
  /// In en, this message translates to:
  /// **'Increase the global text scale'**
  String get accessibilityLargerTextBody;

  /// No description provided for @webPushEnabled.
  ///
  /// In en, this message translates to:
  /// **'Web reminders enabled for this browser.'**
  String get webPushEnabled;

  /// No description provided for @webPushUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Web reminders are unavailable or permission was denied.'**
  String get webPushUnavailable;

  /// No description provided for @webPushEnabling.
  ///
  /// In en, this message translates to:
  /// **'Enabling web reminders...'**
  String get webPushEnabling;

  /// No description provided for @webPushEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable web reminders'**
  String get webPushEnable;

  /// No description provided for @socialJointCompletion.
  ///
  /// In en, this message translates to:
  /// **'Joint completion registered for this shared habit.'**
  String get socialJointCompletion;

  /// No description provided for @completionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get completionContinue;
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
    'id',
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
    case 'id':
      return AppLocalizationsId();
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
