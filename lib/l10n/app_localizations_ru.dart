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
}
