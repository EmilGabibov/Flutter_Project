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
      'Pick a name, choose a finite challenge length, and start cleanly.';

  @override
  String get habitFormEditBody =>
      'Adjust the title, timeline, and color without resetting your progress.';

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
      'Default is 21 days. Use anchors for the usual milestones or slide for any finite plan.';

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

  @override
  String get homeCreateHabitSemantics => 'Create a new habit';

  @override
  String get homeCreateHabitCta => 'Habit';

  @override
  String get homeLoadFailed =>
      'Hable could not load today\'s habits right now.';

  @override
  String get homeFriendFallback => 'Friend';

  @override
  String get homeOpenDashboard => 'Open dashboard';

  @override
  String get homeOpenNotifications => 'Open notifications';

  @override
  String get homeNoHabits => 'No active habits yet.\nStart one from Home.';

  @override
  String get homeAddHabit => 'Add habit';

  @override
  String get homeGreetingMorning => 'Good morning';

  @override
  String get homeGreetingAfternoon => 'Good afternoon';

  @override
  String get homeGreetingEvening => 'Good evening';

  @override
  String get homeSuggestedHabits => 'Suggested Habits';

  @override
  String get profileBack => 'Back';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileOpenSettings => 'Open settings';

  @override
  String get profileUserFallback => 'User';

  @override
  String get profileUsernameFallback => 'user';

  @override
  String get profileLevelFallback => 'Newbie';

  @override
  String profileLifetimePoints(int points) {
    return '$points lifetime pts';
  }

  @override
  String get profileLifetimeScoreHint =>
      'Lifetime score comes from backend sync. Journey and history show per-check-in awards.';

  @override
  String get profileTrophyRoomTab => 'Trophy Room';

  @override
  String get profileJourneyTab => 'Journey';

  @override
  String get profileAchievementsTitle => 'Achievements';

  @override
  String get profileFirstBadgeHint =>
      'Complete a habit to earn your first badge!';

  @override
  String get profileHabitDistributionTitle => 'Habit Distribution';

  @override
  String get profileNoData => 'No data yet';

  @override
  String get profileCompletedLegend => 'Completed';

  @override
  String get profileSkippedLegend => 'Skipped';

  @override
  String get profileOverdueLegend => 'Overdue';

  @override
  String get profileThirtyDayPointsTitle => '30-Day Points Earned';

  @override
  String get profileThirtyDayPointsHint =>
      'Per-check-in awards from local history. Lifetime score updates separately from daily sync.';

  @override
  String get profileCalendarSubscriptionTitle => 'Calendar Subscription';

  @override
  String get profileCalendarSubscriptionBody =>
      'Add your habits to your native calendar app';

  @override
  String get profileManageHabitsTitle => 'Manage Habits';

  @override
  String get profileAddNew => 'Add New';

  @override
  String get profileSectionActive => 'Active';

  @override
  String get profileSectionHallOfFame => 'Hall of Fame';

  @override
  String get profileSectionArchivedHistory => 'Archived history';

  @override
  String get profileFriendProfileTitle => 'Friend Profile';

  @override
  String profileFriendLevel(String level) {
    return '$level level';
  }

  @override
  String get profileActiveHabitsTitle => 'Active Habits';

  @override
  String get profileNoActiveHabits => 'No active habits.';

  @override
  String get profileFriendLoadFailed => 'Failed to load friend profile.';

  @override
  String get dashboardTitle => 'Habit Dashboard';

  @override
  String get dashboardAchievementUnlocked => 'You unlocked a new badge!';

  @override
  String get dashboardLoadFailed =>
      'Hable could not load this habit dashboard right now.';

  @override
  String get dashboardEmptyState =>
      'No active habits yet. Create one from Home to see it here.';

  @override
  String get dashboardSummaryTitle => 'Dashboard Summary';

  @override
  String get dashboardActiveHabitsLabel => 'Active habits';

  @override
  String get dashboardChallengeHabitsLabel => 'Challenge habits';

  @override
  String get dashboardContinuousHabitsLabel => 'Continuous habits';

  @override
  String get dashboardQuoteOfDayTitle => 'Quote of the day';

  @override
  String get dashboardQuoteLoading => 'Loading quote...';

  @override
  String get dashboardQuoteFallback =>
      'Keep going. The dashboard is here when you need the full field view.';

  @override
  String get notificationTitle => 'Notifications';

  @override
  String get notificationMarkAllRead => 'Mark all read';

  @override
  String get notificationEmptyTitle => 'No notifications yet';

  @override
  String get notificationEmptyBody =>
      'Friend requests, invites, nudges, and reminder updates will appear here.';

  @override
  String get notificationToday => 'Today';

  @override
  String get notificationYesterday => 'Yesterday';

  @override
  String get notificationOlder => 'Older';

  @override
  String get notificationLoadFailed =>
      'Hable could not load your notifications right now.';

  @override
  String get notificationJustNow => 'Just now';

  @override
  String notificationMinutesAgo(int minutes) {
    return '${minutes}m ago';
  }

  @override
  String notificationHoursAgo(int hours) {
    return '${hours}h ago';
  }

  @override
  String notificationDaysAgo(int days) {
    return '${days}d ago';
  }

  @override
  String get settingsSessionTitle => 'Session';

  @override
  String get settingsSessionBody =>
      'Sign out of this device. Local reminder scheduling is canceled for this user.';

  @override
  String get settingsRecoverTitle => 'Recover This Device';

  @override
  String get settingsRecoverBody =>
      'This clears local Hable data on this device and sends you back to login. Use it if the app is stuck or showing old cached state.';

  @override
  String get settingsCancel => 'Cancel';

  @override
  String get settingsClearAndSignInAgain => 'Clear and Sign In Again';

  @override
  String get settingsRecoverAction => 'Update / Recover App';

  @override
  String get settingsSignOut => 'Sign out';

  @override
  String get commonAccept => 'Accept';

  @override
  String get commonDecline => 'Decline';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonRemove => 'Remove';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonYou => 'You';

  @override
  String get socialActivityUnread => 'Unread';

  @override
  String get socialActivityEarlier => 'Earlier';

  @override
  String get socialSearchFailed =>
      'Hable could not search for friends just now. Please try again.';

  @override
  String get socialFriendRequestSendFailed =>
      'Hable could not send that friend request just now.';

  @override
  String get socialFriendRequestAcceptFailed =>
      'Hable could not accept that request right now.';

  @override
  String get socialFriendRequestDeclineFailed =>
      'Hable could not decline that request right now.';

  @override
  String get socialFriendRevokeFailed =>
      'Hable could not update that friendship right now.';

  @override
  String socialFriendRequestAlreadyFriends(String username) {
    return 'You are already friends with $username.';
  }

  @override
  String socialFriendRequestIncomingExists(String username) {
    return '$username already sent you a request. Check Requests.';
  }

  @override
  String socialFriendRequestSent(String username) {
    return 'Friend request sent to $username.';
  }

  @override
  String socialFriendAccepted(String username) {
    return 'You are now friends with $username!';
  }

  @override
  String socialFriendDeclined(String username) {
    return 'Declined request from $username.';
  }

  @override
  String socialFriendRemoved(String username) {
    return 'Removed $username from friends.';
  }

  @override
  String get socialFriendActionsUnfriend => 'Unfriend';

  @override
  String get socialFriendActionsRemoveTitle => 'Remove friend?';

  @override
  String socialFriendActionsRemoveBody(String username) {
    return 'Remove $username from your friends list?';
  }

  @override
  String get socialNoFriendsTitle => 'No friends yet';

  @override
  String get socialNoFriendsBody =>
      'Tap the search icon above to find and add friends.';

  @override
  String get socialFriendLongPressActions => 'Long-press for actions';

  @override
  String get socialFriendsLoadFailed =>
      'Hable could not load your friends right now.';

  @override
  String get socialNotSignedIn => 'Not signed in';

  @override
  String get socialNoActivityTitle => 'No activity yet';

  @override
  String get socialNoActivityBody =>
      'Nudges, friend requests, invites, and messages from friends will appear here.';

  @override
  String get socialLeaderboardEmpty => 'No leaderboard scores yet.';

  @override
  String get socialLeaderboardNoValidScores =>
      'No valid leaderboard scores found.';

  @override
  String get socialLeaderboardTitle => 'Friends Leaderboard';

  @override
  String get socialLeaderboardSubtitle =>
      'Accepted friends ranked by lifetime score';

  @override
  String get socialLeaderboardScopeFriends => 'Friends';

  @override
  String get socialLeaderboardLoadTitle => 'Could not load leaderboard';

  @override
  String get socialLeaderboardLoadFailed =>
      'Hable could not load the leaderboard right now.';

  @override
  String get socialFriendRequestsTitle => 'Friend Requests';

  @override
  String get socialFriendRequestIncomingSubtitle => 'Sent you a friend request';

  @override
  String get socialFindFriendsTitle => 'Find Friends';

  @override
  String get socialFindFriendsSearchLabel => 'Search username...';

  @override
  String get socialFindFriendsTypeMore =>
      'Type at least 2 characters to search.';

  @override
  String get socialFindFriendsNoMatches => 'No matches found.';

  @override
  String get socialRelationshipAcceptedFriend => 'Accepted friend';

  @override
  String get socialRelationshipRequestSent => 'Request sent';

  @override
  String get socialRelationshipWaiting => 'Waiting for your response';

  @override
  String get socialRelationshipNotConnected => 'Not connected';

  @override
  String get socialChipFriends => 'Friends';

  @override
  String get socialChipRequested => 'Requested';

  @override
  String get socialChipRespondInFriends => 'Respond in Friends';

  @override
  String get socialSendFriendRequestTooltip => 'Send friend request';

  @override
  String habitCompletionProgressSemantics(int percent) {
    return 'Completion progress $percent percent.';
  }

  @override
  String get leaderboardRankingsTitle => 'Rankings';

  @override
  String leaderboardShowMore(int count) {
    return 'Show $count more';
  }

  @override
  String leaderboardShowingAll(int count) {
    return 'Showing all $count';
  }

  @override
  String get leaderboardYou => 'You';

  @override
  String get leaderboardUnknownUser => 'Unknown';

  @override
  String get leaderboardLifetime => 'lifetime';

  @override
  String get leaderboardLifetimeScoreByline => 'Lifetime score';

  @override
  String get settingsNoVerifiedEmailYet => 'No verified email yet';

  @override
  String get settingsCustomizeAvatar => 'Customize avatar';

  @override
  String get settingsMudFeelTitle => 'Mud feel';

  @override
  String get settingsMudFeelBody =>
      'Tune hold resistance and haptic feedback on this device with bounded presets.';

  @override
  String get settingsMudPresetGentle => 'Gentle';

  @override
  String get settingsMudPresetStandard => 'Standard';

  @override
  String get settingsMudPresetIntense => 'Intense';

  @override
  String get settingsMudHapticsTitle => 'Mud haptics';

  @override
  String get settingsMudHapticsSoft =>
      'Soft taps during hold and a light completion pulse.';

  @override
  String get settingsMudHapticsStandard =>
      'Balanced hold taps and standard completion feedback.';

  @override
  String get settingsMudHapticsStrong =>
      'Heavier completion feedback with denser hold taps.';

  @override
  String get settingsVerificationPinSent => 'Verification PIN sent.';

  @override
  String get settingsCloudSyncActivated => 'Cloud sync activated.';

  @override
  String get settingsCloudSyncActiveTitle => 'Cloud sync active';

  @override
  String get settingsActivateCloudSyncTitle => 'Activate cloud sync';

  @override
  String settingsCloudSyncLinkedToEmail(String email) {
    return 'Progress recovery is linked to $email.';
  }

  @override
  String get settingsCloudSyncInactiveBody =>
      'Add a verified email when you want recoverable cloud progress and password reset support.';

  @override
  String get settingsChangeEmail => 'Change email';

  @override
  String get settingsDailyRemindersTitle => 'Daily reminders';

  @override
  String get settingsDailyRemindersEmpty =>
      'Enable daily reminders to return to your habits.';

  @override
  String get settingsDailyRemindersEnabled =>
      'Hable will remind you each day at these times.';

  @override
  String get settingsEnableInSystemSettings => 'Enable in System Settings';

  @override
  String get settingsAddTime => 'Add Time';

  @override
  String get settingsStatusActive => 'Active';

  @override
  String get settingsStatusSaved => 'Saved';

  @override
  String get settingsStatusOn => 'On';

  @override
  String get settingsStatusOff => 'Off';

  @override
  String get settingsReminderUnsupported =>
      'Reminder scheduling is not available on this platform.';

  @override
  String get settingsRemindersBlocked =>
      'Notifications are blocked. Enable them in System Settings.';

  @override
  String get settingsRemoveReminderTooltip => 'Remove reminder';

  @override
  String get settingsRemindersLoadFailed =>
      'Hable could not load your reminders right now.';

  @override
  String get profileHabitFallbackTitle => 'Habit';

  @override
  String profileDaysLabel(int days) {
    return '$days days';
  }

  @override
  String profileDaysLeft(int days) {
    return '$days days left';
  }

  @override
  String profileDayChallenge(int days) {
    return '$days day challenge';
  }

  @override
  String get profileFriendHabitBody =>
      'Encourage your friend or follow the same habit yourself.';

  @override
  String profileEncouragementQueued(String title) {
    return 'Encouragement queued for $title.';
  }

  @override
  String get profileEncourage => 'Encourage';

  @override
  String get profileFollow => 'Follow';

  @override
  String get profileAchievementFirstCheckIn => 'First check-in';

  @override
  String get profileAchievementTenStreak => '10-day streak';

  @override
  String get profileAchievementHundredStreak => '100-day streak';

  @override
  String get profileAchievementThousandStreak => '1000-day streak';

  @override
  String get profileAchievementFirstNudge => 'First nudge';

  @override
  String get profileAchievementFirstSupporter => 'First supporter';

  @override
  String get profileSharedHabit => 'Shared habit';

  @override
  String get profileSoloHabit => 'Solo habit';

  @override
  String get profileOpenHabitActions => 'Open habit actions';

  @override
  String get profileDeleteHabitTitle => 'Delete habit?';

  @override
  String profileDeleteHabitBody(String title) {
    return 'This will permanently delete \"$title\" and remove it from synced devices.';
  }

  @override
  String get profileArchive => 'Archive';

  @override
  String get profileViewHistory => 'View History';

  @override
  String get profileRerun => 'Rerun';

  @override
  String get profileRoleOwnerView => 'Owner view';

  @override
  String get profileRolePartnerView => 'Partner view';

  @override
  String get profileRoleSupporterView => 'Supporter view';

  @override
  String get profileHistoryIntro =>
      'Archived challenge history and per-check-in awards';

  @override
  String get profileNoHistoryYet => 'No history recorded yet.';

  @override
  String profilePointsAwarded(int points) {
    return '+$points pts';
  }

  @override
  String get profileUnableLoadHistory => 'Unable to load habit history.';

  @override
  String get profileHistoryCompleted => 'Completed';

  @override
  String profileHistorySkippedWithNote(String note) {
    return 'Skipped: $note';
  }

  @override
  String get profileHistorySkipped => 'Skipped';

  @override
  String get profileCalendarUnknownError => 'Unknown error';

  @override
  String get profileCalendarGenerateLink => 'Generate Subscription Link';

  @override
  String get profileCalendarSubscriptionUrl => 'Subscription URL';

  @override
  String get profileCalendarCopied => 'Calendar feed URL copied to clipboard';

  @override
  String get profileCalendarCopyTooltip => 'Copy subscription URL';

  @override
  String get profileCalendarPasteHint =>
      'Paste this URL into your native calendar app to subscribe';

  @override
  String get profileCalendarRotateToken => 'Rotate Token';

  @override
  String get profileCalendarRotateHint =>
      'Rotating the token will invalidate the old subscription link';

  @override
  String get accessibilityReducedMotionTitle => 'Reduced Motion';

  @override
  String get accessibilityReducedMotionBody =>
      'Disable animations and transitions';

  @override
  String get accessibilityHighContrastTitle => 'High Contrast';

  @override
  String get accessibilityHighContrastBody =>
      'Increase color contrast for better readability';

  @override
  String get accessibilityLargerTextTitle => 'Larger Text';

  @override
  String get accessibilityLargerTextBody => 'Globale Textgroesse erhoehen';

  @override
  String get webPushEnabled =>
      'Web-Erinnerungen sind fuer diesen Browser aktiviert.';

  @override
  String get webPushUnavailable =>
      'Web-Erinnerungen sind nicht verfuegbar oder die Berechtigung wurde verweigert.';

  @override
  String get webPushEnabling => 'Web-Erinnerungen werden aktiviert...';

  @override
  String get webPushEnable => 'Web-Erinnerungen aktivieren';

  @override
  String get socialJointCompletion =>
      'Gemeinsamer Abschluss fuer diese gemeinsame Gewohnheit registriert.';

  @override
  String get completionContinue => 'Weiter';
}
