// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get homeTabTitle => 'Startseite';

  @override
  String get socialTabTitle => 'Soziales';

  @override
  String get socialTabTooltip => 'Soziales — Freunde & Partner';

  @override
  String get profileTabTitle => 'Profil';

  @override
  String get profileTabTooltip => 'Profil — Verlauf & Einstellungen';

  @override
  String get activityTabTitle => 'Aktivität';

  @override
  String get friendsTabTitle => 'Freunde';

  @override
  String get leaderboardTabTitle => 'Bestenliste';

  @override
  String get authWelcomeTitle => 'Willkommen bei\nHable.';

  @override
  String get authLoginSubtitle => 'Melde dich an, um deine Reise fortzusetzen.';

  @override
  String get authLoginButton => 'Einloggen';

  @override
  String get authJoinTitle => 'Mach mit bei Hable.';

  @override
  String get authJoinSubtitle =>
      'Wähle einen Benutzernamen und ein Passwort. Du kannst die Cloud-Wiederherstellung später im Profil aktivieren.';

  @override
  String get authSignUpButton => 'Registrieren';

  @override
  String get authResetTitle => 'Passwort zurücksetzen';

  @override
  String get authResetSubtitle =>
      'Gib deine E-Mail-Adresse ein, um einen Bestätigungs-PIN zu erhalten.';

  @override
  String get authSendPinButton => 'PIN senden';

  @override
  String get authVerifyTitle => 'PIN bestätigen';

  @override
  String get authVerifySubtitle =>
      'Gib den an deine E-Mail gesendeten PIN und dein neues Passwort ein.';

  @override
  String get authResetSuccessMessage =>
      'Passwort erfolgreich zurückgesetzt. Bitte melde dich an.';

  @override
  String get authUsernameLabel => 'Benutzername';

  @override
  String get authEmailLabel => 'E-Mail';

  @override
  String get authPinLabel => '6-stelliger PIN';

  @override
  String get authPasswordLabel => 'Passwort';

  @override
  String get authNewPasswordLabel => 'Neues Passwort';

  @override
  String get authForgotPassword => 'Passwort vergessen?';

  @override
  String get authWorking => 'Wird bearbeitet...';

  @override
  String get authNeedAccount => 'Noch kein Konto? Registrieren';

  @override
  String get authAlreadyHaveAccount => 'Bereits ein Konto? Einloggen';

  @override
  String get authBackToLogin => 'Zurück zum Login';

  @override
  String get authGdprFooter =>
      'Hable erfüllt die europäischen Datenschutzanforderungen, einschließlich der DSGVO.';

  @override
  String get onboardingDayOneEyebrow => 'Tag eins';

  @override
  String get onboardingDayOneTitle => 'Jeder Tag ist Tag eins.';

  @override
  String get onboardingDayOneBody =>
      'Beginne mit einer ruhigen Lektüre und dann mit einer bewussten Handlung. Hable hält den ersten Schritt klein genug, um ihn zu wiederholen.';

  @override
  String get onboardingMudEyebrow => 'Schlamm';

  @override
  String get onboardingMudTitle => 'Starte durch den Schlamm.';

  @override
  String get onboardingMudBody =>
      'Neue Gewohnheiten erfordern einen stetigen Druck von 1500 ms. Dieser Widerstand ist der Punkt: erst Anstrengung, dann Stabilität.';

  @override
  String get onboardingCommitEyebrow => 'Verpflichten';

  @override
  String get onboardingCommitTitle => 'Wähle eine erste Verpflichtung.';

  @override
  String get onboardingCommitBody =>
      'Wähle eine Standardgewohnheit oder lege deine eigene Tagesanzahl fest. Die wissenschaftlich fundierten Ziele von 21, 33 und 40 Tagen sind immer griffbereit.';

  @override
  String get onboardingPartnersEyebrow => 'Partner';

  @override
  String get onboardingPartnersTitle => 'Bringe einen Partner mit.';

  @override
  String get onboardingPartnersBody =>
      'Gemeinsame Gewohnheiten zeigen den Fortschritt des Partners durch farbige Ringe an, sodass die Unterstützung direkt auf der Gewohnheitskarte sichtbar ist.';

  @override
  String get onboardingRemindersEyebrow => 'Erinnerungen';

  @override
  String get onboardingRemindersTitle => 'Lass Erinnerungen sanft sein.';

  @override
  String get onboardingRemindersBody =>
      'Hable fragt vor der Planung. Schalte Erinnerungen nur ein, wenn du ruhige Anstöße und keine Forderungen möchtest.';

  @override
  String get onboardingPrivacyEyebrow => 'Privatsphäre';

  @override
  String get onboardingPrivacyTitle => 'Halte Reflexionen privat.';

  @override
  String get onboardingPrivacyBody =>
      'Die E-Mail-Verifizierung wartet in den Einstellungen und Tagebuchreflexionen bleiben privat. Partner sehen den Fortschritt, nicht deine Notizen.';

  @override
  String get onboardingTrackerEyebrow => 'Tracker';

  @override
  String get onboardingTrackerTitle => 'Kein Überspringen-Button auf dem Ring.';

  @override
  String get onboardingTrackerBody =>
      'Der Haupt-Tracker ist auf Aktion ausgelegt. Verpasste Tage verfallen natürlich, während private Reflexionen bei Bedarf verfügbar bleiben.';

  @override
  String get onboardingStartSetup => 'Einrichtung starten';

  @override
  String get onboardingNext => 'Weiter';

  @override
  String get onboardingLogIn => 'Einloggen';

  @override
  String get habitSkipToday => 'Heute überspringen';

  @override
  String get habitSkippedToday => 'Heute übersprungen';

  @override
  String get habitCompletedToday => 'Heute abgeschlossen';

  @override
  String get habitNotCompletedToday => 'Heute nicht abgeschlossen';

  @override
  String get habitFollowing => 'Folgend';

  @override
  String get habitContinuous => 'Kontinuierlich';

  @override
  String habitDayProgress(int day, int total) {
    return 'Tag $day von $total';
  }

  @override
  String habitNudgedBy(String name) {
    return 'Angestoßen von $name';
  }

  @override
  String habitNudgeQueued(String name) {
    return 'Anstoß in der Warteschlange für $name';
  }

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsAccountTitle => 'Konto';

  @override
  String get settingsUserId => 'Benutzer-ID';

  @override
  String get settingsNoEmail => 'Keine E-Mail verknüpft';

  @override
  String get settingsLogOut => 'Abmelden';

  @override
  String get settingsCloudSync => 'Cloud-Synchronisation';

  @override
  String get settingsEnableCloudSync => 'Cloud-Synchronisation aktivieren';

  @override
  String get settingsCloudSyncActive => 'Cloud-Synchronisation ist aktiv.';

  @override
  String get settingsDailyReminder => 'Tägliche Erinnerung';

  @override
  String get settingsEnableDailyReminder => 'Tägliche Erinnerung aktivieren';

  @override
  String get settingsRemindMeAt => 'Erinnere mich um';

  @override
  String get settingsMudTuning => 'Schlamm-Anpassung';

  @override
  String get settingsMudTuningDesc =>
      'Passe den Widerstand und das Gefühl des Gewohnheits-Abschlussrings an.';

  @override
  String get settingsDuration => 'Dauer';

  @override
  String get settingsFast => 'Schnell';

  @override
  String get settingsSlow => 'Langsam';

  @override
  String get settingsResistance => 'Widerstand';

  @override
  String get settingsLight => 'Leicht';

  @override
  String get settingsHeavy => 'Schwer';

  @override
  String get settingsHaptics => 'Haptik';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsAccessibility => 'Barrierefreiheit';

  @override
  String get dashboardMyHabits => 'Meine Gewohnheiten';

  @override
  String get dashboardAddHabit => 'Gewohnheit hinzufügen';

  @override
  String get dashboardNoHabits =>
      'Noch keine Gewohnheiten. Tippe auf das +, um deine erste Herausforderung zu starten.';

  @override
  String get appGateRestoredLocalSession => 'Restored local session on macOS.';

  @override
  String get appGateUpdatingHable => 'Updating Hable...';

  @override
  String get appGateRestoringSession => 'Restoring session...';

  @override
  String get appGatePreparingHabits => 'Preparing your habits...';

  @override
  String get appGateLoadingProfileState => 'Loading profile state...';

  @override
  String skipSheetTitle(String habitTitle) {
    return 'Skipping \"$habitTitle\"';
  }

  @override
  String get skipSheetBody =>
      'This will add +2 days to your journey. Write a quick journal entry to continue.';

  @override
  String get skipSheetHint => 'Why are you skipping today?';

  @override
  String get skipSheetConfirm => 'Confirm Skip';

  @override
  String get mudCompleteHabitLabel => 'Complete Habit';

  @override
  String get mudLongPressHint => 'Long press to complete';

  @override
  String get mudDone => 'Done!';

  @override
  String get mudHoldToComplete => 'Hold to Complete';

  @override
  String get socialSyncNow => 'Sync now';

  @override
  String get socialFindFriends => 'Find friends';

  @override
  String get partnerSectionTitle => 'Partners';

  @override
  String get partnerTickerStateNotCompletedYet => 'not completed yet';

  @override
  String partnerTickerProfileSemantics(String name, String state) {
    return '$name, $state. Opens profile.';
  }

  @override
  String get partnerNoPartnersYet => 'No partners on this habit yet.';

  @override
  String get partnerNoPartnersShort => 'No partners';

  @override
  String partnerStackCollapsedSemantics(int count) {
    return 'Partner stack. $count total. Long press to expand partner states.';
  }

  @override
  String get partnerExpandedSemantics =>
      'Expanded partner states. Tap to collapse. Each row shows completion, pending, or nudged state.';

  @override
  String get partnerTapToCollapse => 'Tap to collapse';

  @override
  String get partnerStateCompleted => 'completed';

  @override
  String get partnerStateNudged => 'nudged';

  @override
  String get partnerStateSupporter => 'supporter';

  @override
  String get partnerStatePending => 'pending';

  @override
  String get partnerStateCompletedToday => 'completed today';

  @override
  String get partnerStateSupporting => 'supporting';

  @override
  String partnerStatusSemantics(String name, String state) {
    return '$name status $state';
  }

  @override
  String get partnerRoleOwner => 'owner';

  @override
  String get partnerRolePartner => 'partner';

  @override
  String get partnerRoleSupporter => 'supporter';

  @override
  String partnerProfileSemantics(String name, String role, String state) {
    return '$name, $role, $state. Opens profile.';
  }

  @override
  String partnerNudgeSemantics(String name) {
    return 'Nudge $name on this habit.';
  }

  @override
  String partnerNudgeTooltip(String name) {
    return 'Nudge $name';
  }

  @override
  String get habitFormChooseIconTitle => 'Choose an icon';

  @override
  String get habitFormChooseIconBody =>
      'Custom habits can keep this icon with the title.';

  @override
  String get habitFormSaveFailed =>
      'That habit did not stick yet. Please try again.';

  @override
  String get habitFormPresetDescriptionFallback =>
      'Name the behavior clearly so future you can understand it at a glance.';

  @override
  String get habitFormCreateButton => 'Create habit';

  @override
  String get habitFormSaveChangesButton => 'Save changes';

  @override
  String get habitFormCreateTitle => 'Build a habit worth repeating';

  @override
  String get habitFormEditTitle => 'Refine this habit';

  @override
  String get habitFormCreateBody =>
      'Choose a pattern, tune the duration, and invite the right people before you commit.';

  @override
  String get habitFormEditBody =>
      'Adjust the title, timeline, and color without breaking the habit you already started.';

  @override
  String get habitFormNameLabel => 'Habit name';

  @override
  String get habitFormNameHint =>
      'Morning pages, no phone after 10, daily walk...';

  @override
  String get habitFormNameHelper =>
      'Tap the icon to the left to personalize custom habits.';

  @override
  String get habitFormNameErrorEmpty => 'Give this habit a clear name.';

  @override
  String get habitFormNameErrorShort => 'Use at least 3 characters.';

  @override
  String get habitFormPresetTitle => 'Start from a proven pattern';

  @override
  String get habitFormPresetBody =>
      'Pick a template to preload the title, duration, color, and cue copy.';

  @override
  String get habitFormDescriptionTitle => 'Description';

  @override
  String get habitFormDescriptionBody =>
      'Use one or two lines to make the habit specific enough to repeat on rough days.';

  @override
  String get habitFormDescriptionHelper =>
      'This can surface on the primary habit card.';

  @override
  String get habitFormDescriptionErrorLong =>
      'Keep the description under 160 characters.';

  @override
  String get habitFormDurationTitle => 'Duration';

  @override
  String get habitFormDurationBody =>
      'Popular challenge lengths help users commit to a finite promise.';

  @override
  String habitFormDurationChip(int days) {
    return '$days days';
  }

  @override
  String get habitFormCustomDaysLabel => 'Custom number of days';

  @override
  String get habitFormDurationErrorInvalid => 'Enter a number of days.';

  @override
  String get habitFormDurationErrorMin => 'Duration must be at least 1 day.';

  @override
  String get habitFormColorTitle => 'Ring color';

  @override
  String get habitFormColorBody =>
      'Choose the color this habit will carry across its card and celebrations.';

  @override
  String get habitFormPartnersTitle => 'Invite partners';

  @override
  String get habitFormPartnersBody =>
      'Shared habits can start with friends who already follow you.';

  @override
  String get habitFormNoFriends =>
      'No friends found. Add friends from the Social tab first.';

  @override
  String get habitFormFriendsLoadFailed =>
      'Hable could not load your friend list right now.';
}
