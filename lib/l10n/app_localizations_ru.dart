// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get homeTabTitle => 'Главная';

  @override
  String get socialTabTitle => 'Сообщество';

  @override
  String get socialTabTooltip => 'Сообщество — друзья и партнеры';

  @override
  String get profileTabTitle => 'Профиль';

  @override
  String get profileTabTooltip => 'Профиль — история и настройки';

  @override
  String get activityTabTitle => 'Активность';

  @override
  String get friendsTabTitle => 'Друзья';

  @override
  String get leaderboardTabTitle => 'Таблица лидеров';

  @override
  String get authWelcomeTitle => 'Добро пожаловать в\nHable.';

  @override
  String get authLoginSubtitle => 'Войдите, чтобы продолжить свое путешествие.';

  @override
  String get authLoginButton => 'Войти';

  @override
  String get authJoinTitle => 'Присоединяйтесь к Hable.';

  @override
  String get authJoinSubtitle =>
      'Выберите имя пользователя и пароль. Вы сможете активировать облачное восстановление позже в Профиле.';

  @override
  String get authSignUpButton => 'Регистрация';

  @override
  String get authResetTitle => 'Сброс пароля';

  @override
  String get authResetSubtitle =>
      'Введите свой адрес электронной почты, чтобы получить PIN-код подтверждения.';

  @override
  String get authSendPinButton => 'Отправить PIN';

  @override
  String get authVerifyTitle => 'Подтвердить PIN';

  @override
  String get authVerifySubtitle =>
      'Введите PIN-код, отправленный на вашу электронную почту, и ваш новый пароль.';

  @override
  String get authResetSuccessMessage =>
      'Пароль успешно сброшен. Пожалуйста, войдите.';

  @override
  String get authUsernameLabel => 'Имя пользователя';

  @override
  String get authEmailLabel => 'Электронная почта';

  @override
  String get authPinLabel => '6-значный PIN';

  @override
  String get authPasswordLabel => 'Пароль';

  @override
  String get authNewPasswordLabel => 'Новый пароль';

  @override
  String get authForgotPassword => 'Забыли пароль?';

  @override
  String get authWorking => 'Обработка...';

  @override
  String get authNeedAccount => 'Нет аккаунта? Зарегистрироваться';

  @override
  String get authAlreadyHaveAccount => 'Уже есть аккаунт? Войти';

  @override
  String get authBackToLogin => 'Вернуться ко входу';

  @override
  String get authGdprFooter =>
      'Hable соответствует европейским требованиям по защите данных, включая GDPR.';

  @override
  String get onboardingDayOneEyebrow => 'День первый';

  @override
  String get onboardingDayOneTitle => 'Каждый день - это первый день.';

  @override
  String get onboardingDayOneBody =>
      'Начните со спокойного чтения, затем одно осознанное действие. Hable делает первый шаг достаточно маленьким, чтобы его можно было повторить.';

  @override
  String get onboardingMudEyebrow => 'Грязь';

  @override
  String get onboardingMudTitle => 'Начни сквозь грязь.';

  @override
  String get onboardingMudBody =>
      'Новые привычки требуют устойчивого нажатия в течение 1500 мс. Это сопротивление и есть суть: сначала усилие, затем стабильность.';

  @override
  String get onboardingCommitEyebrow => 'Обязательство';

  @override
  String get onboardingCommitTitle => 'Выберите первое обязательство.';

  @override
  String get onboardingCommitBody =>
      'Выберите стандартную привычку или установите свое собственное количество дней. Научно обоснованные цели в 21, 33 и 40 дней всегда рядом.';

  @override
  String get onboardingPartnersEyebrow => 'Партнеры';

  @override
  String get onboardingPartnersTitle => 'Приведите партнера.';

  @override
  String get onboardingPartnersBody =>
      'Общие привычки показывают прогресс партнера через цветные кольца, поэтому поддержка находится прямо на карточке привычки.';

  @override
  String get onboardingRemindersEyebrow => 'Напоминания';

  @override
  String get onboardingRemindersTitle => 'Пусть напоминания будут мягкими.';

  @override
  String get onboardingRemindersBody =>
      'Hable спрашивает перед планированием. Включайте напоминания только тогда, когда вам нужны тихие толчки, а не требования.';

  @override
  String get onboardingPrivacyEyebrow => 'Конфиденциальность';

  @override
  String get onboardingPrivacyTitle => 'Держите размышления в секрете.';

  @override
  String get onboardingPrivacyBody =>
      'Проверка электронной почты ждет в Настройках, а размышления в дневнике остаются конфиденциальными. Партнеры видят прогресс, а не ваши заметки.';

  @override
  String get onboardingTrackerEyebrow => 'Трекер';

  @override
  String get onboardingTrackerTitle => 'На кольце нет кнопки пропуска.';

  @override
  String get onboardingTrackerBody =>
      'Главный трекер создан для действий. Пропущенные дни истекают естественным образом, в то время как личные размышления остаются доступными при необходимости.';

  @override
  String get onboardingStartSetup => 'Начать настройку';

  @override
  String get onboardingNext => 'Далее';

  @override
  String get onboardingLogIn => 'Войти';

  @override
  String get habitSkipToday => 'Пропустить сегодня';

  @override
  String get habitSkippedToday => 'Пропущено сегодня';

  @override
  String get habitCompletedToday => 'Завершено сегодня';

  @override
  String get habitNotCompletedToday => 'Не завершено сегодня';

  @override
  String get habitFollowing => 'Читаю';

  @override
  String get habitContinuous => 'Непрерывно';

  @override
  String habitDayProgress(int day, int total) {
    return 'День $day из $total';
  }

  @override
  String habitNudgedBy(String name) {
    return 'Подтолкнул $name';
  }

  @override
  String habitNudgeQueued(String name) {
    return 'Толчок в очереди для $name';
  }

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsAccountTitle => 'Аккаунт';

  @override
  String get settingsUserId => 'ID пользователя';

  @override
  String get settingsNoEmail => 'Электронная почта не привязана';

  @override
  String get settingsLogOut => 'Выйти';

  @override
  String get settingsCloudSync => 'Облачная синхронизация';

  @override
  String get settingsEnableCloudSync => 'Включить облачную синхронизацию';

  @override
  String get settingsCloudSyncActive => 'Облачная синхронизация активна.';

  @override
  String get settingsDailyReminder => 'Ежедневное напоминание';

  @override
  String get settingsEnableDailyReminder => 'Включить ежедневное напоминание';

  @override
  String get settingsRemindMeAt => 'Напомнить в';

  @override
  String get settingsMudTuning => 'Настройка грязи';

  @override
  String get settingsMudTuningDesc =>
      'Отрегулируйте сопротивление и ощущение кольца завершения привычки.';

  @override
  String get settingsDuration => 'Продолжительность';

  @override
  String get settingsFast => 'Быстро';

  @override
  String get settingsSlow => 'Медленно';

  @override
  String get settingsResistance => 'Сопротивление';

  @override
  String get settingsLight => 'Легко';

  @override
  String get settingsHeavy => 'Тяжело';

  @override
  String get settingsHaptics => 'Тактильность';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsAccessibility => 'Доступность';

  @override
  String get dashboardMyHabits => 'Мои привычки';

  @override
  String get dashboardAddHabit => 'Добавить привычку';

  @override
  String get dashboardNoHabits =>
      'Пока нет привычек. Нажмите +, чтобы начать свой первый вызов.';

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
  String get accessibilityLargerTextBody => 'Increase the global text scale';
}
