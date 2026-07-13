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
  String get profileTabTitle => 'Profil';

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
}
