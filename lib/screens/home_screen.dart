import 'dart:async';

import 'package:flutter/material.dart';
import '../models/daily_quote.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' hide Column;
import '../l10n/app_localizations.dart';
import '../database/database.dart';
import '../database/tables.dart' show LogStatus, PartnershipRole, SyncAction;
import '../providers/database_provider.dart';
import '../providers/habit_providers.dart';
import '../providers/resistance_provider.dart';
import '../providers/quote_provider.dart';
import '../providers/social_providers.dart';
import '../providers/sync_provider.dart';
import '../providers/notification_providers.dart';
import '../providers/mud_tuning_provider.dart';
import '../providers/celebration_provider.dart';
import '../theme/app_theme.dart';
import '../data/standard_habits.dart';
import '../utils/habit_timeline.dart';
import '../models/celebration_feedback.dart';
import '../services/app_error.dart';
import '../services/completion_feedback.dart';
import '../services/celebration_sequence_controller.dart';
import '../widgets/skip_bottom_sheet.dart';
import '../widgets/invitation_banner.dart';

import '../widgets/habit_form_sheet.dart';
import '../widgets/habit_card.dart';
import 'completion_splash_screen.dart';
import '../widgets/badge_reveal_dialog.dart';
import '../widgets/milestone_wish_carousel.dart';
import '../widgets/skeletons.dart';
import '../widgets/usage_tracked_screen.dart';
import 'habit_dashboard_screen.dart';

const _nudgeVisibilityTtl = Duration(hours: 24);
const _sentNudgeFeedbackTtl = Duration(seconds: 4);

class _QueuedNudgeFeedback {
  final String partnerName;
  final DateTime queuedAt;

  const _QueuedNudgeFeedback({
    required this.partnerName,
    required this.queuedAt,
  });
}

class _QueuedCelebrationRequest {
  final Future<void> Function(BuildContext context, WidgetRef ref) present;

  const _QueuedCelebrationRequest({required this.present});
}

/// Home Screen — focuses ONLY on today's action.
/// No dashboard fatigue. No loading spinners for network requests.
class HomeScreen extends ConsumerStatefulWidget {
  final String userId;

  /// Called when the user taps the notification bell.
  /// The shell wires this to switch to the Social → Activity tab.
  final VoidCallback? onOpenActivity;
  final String? focusedHabitId;
  final int focusRequestId;

  const HomeScreen({
    super.key,
    required this.userId,
    this.onOpenActivity,
    this.focusedHabitId,
    this.focusRequestId = 0,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final Map<String, GlobalKey> _habitCardKeys = {};
  final CelebrationSequenceController<_QueuedCelebrationRequest>
  _celebrationSequence =
      CelebrationSequenceController<_QueuedCelebrationRequest>();

  @override
  void initState() {
    super.initState();
    _pullDailySync();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusRequestedHabit();
    });
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId) {
      _pullDailySync();
    }
    if (oldWidget.focusRequestId != widget.focusRequestId ||
        oldWidget.focusedHabitId != widget.focusedHabitId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusRequestedHabit();
      });
    }
  }

  void _pullDailySync() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(syncServiceProvider).pullDailySync(widget.userId);
    });
  }

  GlobalKey _habitKey(String habitId) {
    return _habitCardKeys.putIfAbsent(habitId, GlobalKey.new);
  }

  void _focusRequestedHabit() {
    final habitId = widget.focusedHabitId;
    if (!mounted || habitId == null || habitId.isEmpty) return;
    final targetContext = _habitCardKeys[habitId]?.currentContext;
    if (targetContext == null) return;
    Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      alignment: 0.2,
    );
  }

  void _enqueueAchievementCelebrations(List<AchievementUnlock> unlocks) {
    for (final badge in unlocks) {
      final parts = badge.achievementId.replaceAll('_', ' ').split(' ');
      final title = parts
          .map(
            (e) => e.isNotEmpty ? '${e[0].toUpperCase()}${e.substring(1)}' : '',
          )
          .join(' ');
      _celebrationSequence.enqueue(
        _QueuedCelebrationRequest(
          present: (context, ref) async {
            await BadgeRevealDialog.show(
              context,
              title,
              'You unlocked a new badge!',
            );
            await ref
                .read(celebrationProvider.notifier)
                .markRevealed(badge.achievementId);
          },
        ),
        dedupeKey: 'achievement:${badge.achievementId}',
      );
    }
    unawaited(_drainCelebrations());
  }

  void _queueCompletionCelebration({
    required Habit habit,
    required String? emoji,
    required CompletionCelebrationSpec celebration,
    required int pointsEarned,
  }) {
    _celebrationSequence.enqueue(
      _QueuedCelebrationRequest(
        present: (context, _) {
          return Navigator.of(context).push(
            PageRouteBuilder<void>(
              opaque: false,
              pageBuilder: (_, _, _) => CompletionSplashScreen(
                habit: habit,
                emoji: emoji,
                celebration: celebration,
                pointsEarned: pointsEarned,
              ),
            ),
          );
        },
      ),
      dedupeKey:
          'completion:${habit.habitId}:${DateTime.now().microsecondsSinceEpoch}',
    );
    unawaited(_drainCelebrations());
  }

  Future<void> _drainCelebrations() async {
    if (!mounted) return;
    await _celebrationSequence.drain((request) async {
      if (!mounted) return;
      await request.present(context, ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    ref.listen<List<AchievementUnlock>>(celebrationProvider, (previous, next) {
      if (next.isEmpty) return;
      _enqueueAchievementCelebrations(next);
    });

    final habitsAsync = ref.watch(activeHabitsProvider(widget.userId));
    final quoteAsync = ref.watch(quoteProvider);

    return UsageTrackedScreen(
      screenName: 'home',
      child: Scaffold(
        floatingActionButton: Semantics(
          label: l10n.homeCreateHabitSemantics,
          button: true,
          child: FloatingActionButton.extended(
            heroTag: 'home-create-habit',
            onPressed: () => HabitFormSheet.show(context),
            backgroundColor: AppTheme.deepCharcoal,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add_rounded),
            label: Text(l10n.homeCreateHabitCta),
          ),
        ),
        body: SafeArea(
          child: habitsAsync.when(
            data: (habits) => _buildContent(context, habits, quoteAsync),
            loading: () => const _HomeSkeleton(),
            error: (err, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  AppError.fromAny(
                    err,
                    fallbackCode: 'home_habits_load_failed',
                    fallbackMessage: l10n.homeLoadFailed,
                    fallbackKind: AppErrorKind.inline,
                  ).message,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<Habit> habits,
    AsyncValue<DailyQuote> quoteAsync,
  ) {
    final l10n = AppLocalizations.of(context)!;
    bool allEmpty = true;
    for (final h in habits) {
      final log = ref.watch(todaysLogProvider(h.habitId)).value;
      if (log != null && log.status == LogStatus.completed) {
        allEmpty = false;
        break;
      }
    }
    final encouragement = resolveHomeEncouragement(
      hasActiveHabits: habits.isNotEmpty,
      hasCompletedToday: !allEmpty,
    );

    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _greeting(context),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Consumer(
                        builder: (context, ref, _) {
                          final userAsync = ref.watch(currentUserProvider);
                          return userAsync.when(
                            data: (user) => Text(
                              user?.username ?? l10n.homeFriendFallback,
                              style: Theme.of(context).textTheme.headlineMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                            loading: () => const Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: HableSkeletonBlock(width: 128, height: 22),
                            ),
                            error: (_, _) => const SizedBox.shrink(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Consumer(
                      builder: (context, ref, _) {
                        ref.watch(unreadNotificationCountProvider);
                        return IconButton(
                          tooltip: l10n.homeOpenDashboard,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    HabitDashboardScreen(userId: widget.userId),
                              ),
                            );
                          },
                          icon: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceVariant,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.grid_view_rounded,
                              color: AppTheme.deepCharcoal,
                              size: 20,
                            ),
                          ),
                        );
                      },
                    ),
                    Consumer(
                      builder: (context, ref, _) {
                        final unreadAsync = ref.watch(
                          unreadNotificationCountProvider,
                        );
                        final unreadCount = unreadAsync.value ?? 0;
                        return IconButton(
                          tooltip: l10n.homeOpenNotifications,
                          onPressed: widget.onOpenActivity,
                          icon: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceVariant,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.notifications_none_rounded,
                                  color: AppTheme.deepCharcoal,
                                  size: 22,
                                ),
                              ),
                              if (unreadCount > 0)
                                Positioned(
                                  right: -2,
                                  top: -2,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 2,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: AppTheme.overdueRose,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(999),
                                      ),
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 18,
                                      minHeight: 18,
                                    ),
                                    child: Text(
                                      unreadCount > 9
                                          ? '9+'
                                          : unreadCount.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Daily quote or empty-day encouragement
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                color: encouragement.backgroundColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Text(
                    encouragement.emoji,
                    style: const TextStyle(fontSize: 36),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: allEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                encouragement.title,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: encouragement.accentColor,
                                    ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                encouragement.body,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: encouragement.accentColor,
                                      height: 1.3,
                                    ),
                              ),
                            ],
                          )
                        : quoteAsync.when(
                            data: (quote) => Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(text: quote.text),
                                  if (quote.author != null &&
                                      quote.author!.isNotEmpty)
                                    TextSpan(
                                      text: '\n— ${quote.author}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w500,
                                            color: AppTheme.warmGray,
                                          ),
                                    ),
                                ],
                              ),
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.deepCharcoal.withValues(
                                      alpha: 0.8,
                                    ),
                                    height: 1.4,
                                  ),
                            ),
                            loading: () => const HableSkeletonBlock(
                              width: double.infinity,
                              height: 18,
                            ),
                            error: (_, _) => const SizedBox.shrink(),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Phase 2: Pending Invitations
        const SliverToBoxAdapter(child: InvitationBanner()),

        // Phase 2: Milestone Wishes
        const SliverToBoxAdapter(child: MilestoneWishCarousel()),

        // Phase 3: Suggested Habits
        if (habits.isEmpty) SliverToBoxAdapter(child: _buildSuggestedHabits()),

        // Habit cards
        if (habits.isEmpty)
          SliverFillRemaining(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.homeNoHabits,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => HabitFormSheet.show(context),
                      icon: const Icon(Icons.add_rounded),
                      label: Text(l10n.homeAddHabit),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                mainAxisExtent: 216,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => KeyedSubtree(
                  key: _habitKey(habits[index].habitId),
                  child: _HabitCard(
                    habit: habits[index],
                    userId: widget.userId,
                    onQueueCompletionCelebration: _queueCompletionCelebration,
                  ),
                ),
                childCount: habits.length,
              ),
            ),
          ),
      ],
    );
  }

  String _greeting(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.homeGreetingMorning;
    if (hour < 17) return l10n.homeGreetingAfternoon;
    return l10n.homeGreetingEvening;
  }

  Widget _buildSuggestedHabits() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Text(
            l10n.homeSuggestedHabits,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.sageGreen,
            ),
          ),
        ),
        SizedBox(
          height: 136,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: standardHabits.length,
            itemBuilder: (context, index) {
              final habit = standardHabits[index];
              return Container(
                width: 140,
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.sageGreen.withValues(alpha: 0.2),
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    HabitFormSheet.show(context, prefilledTitle: habit.title);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          habitTitleWithEmoji(habit.title),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Flexible(
                          child: Text(
                            habit.subtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              color: AppTheme.deepCharcoal.withValues(
                                alpha: 0.7,
                              ),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 96),
      children: const [
        HableSkeletonBlock(width: 92, height: 12),
        SizedBox(height: 8),
        HableSkeletonBlock(width: 150, height: 26),
        SizedBox(height: 24),
        HableSkeletonCard(height: 86),
        SizedBox(height: 16),
        HableSkeletonBlock(width: 120, height: 18),
        SizedBox(height: 16),
        HableSkeletonCard(height: 180),
        HableSkeletonCard(height: 180),
      ],
    );
  }
}

class _HabitCard extends ConsumerStatefulWidget {
  final Habit habit;
  final String userId;
  final void Function({
    required Habit habit,
    required String? emoji,
    required CompletionCelebrationSpec celebration,
    required int pointsEarned,
  })
  onQueueCompletionCelebration;

  const _HabitCard({
    required this.habit,
    required this.userId,
    required this.onQueueCompletionCelebration,
  });

  @override
  ConsumerState<_HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends ConsumerState<_HabitCard> {
  _QueuedNudgeFeedback? _sentNudgeFeedback;
  Timer? _clearSentNudgeTimer;
  bool _isShowingCompletionFeedback = false;
  Timer? _completionFeedbackTimer;

  @override
  void dispose() {
    _clearSentNudgeTimer?.cancel();
    _completionFeedbackTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final habit = widget.habit;
    final userId = widget.userId;
    final todaysLogAsync = ref.watch(todaysLogProvider(habit.habitId));
    final streakAsync = ref.watch(streakProvider(habit.habitId));
    final partnersAsync = ref.watch(habitPartnersProvider(habit.habitId));

    final isContinuous = habit.targetDuration <= 0;
    final challengeDay = challengeTimelineDay(habit);
    final progressDay = challengeProgressDay(habit);
    final progressFraction = challengeProgressFraction(habit);
    final targetDays = habit.targetDuration > 0 ? habit.targetDuration : 1;
    final resistance = ref.watch(
      resistanceProvider((
        currentDay: progressDay.clamp(0, targetDays),
        totalDuration: targetDays,
      )),
    );

    final isCompletedToday = todaysLogAsync.when(
      data: (log) => log?.status == LogStatus.completed,
      loading: () => false,
      error: (_, _) => false,
    );
    final isSkippedToday = todaysLogAsync.when(
      data: (log) => log?.status == LogStatus.skipped,
      loading: () => false,
      error: (_, _) => false,
    );

    final viewerRole = partnersAsync.when(
      data: _viewerRoleForPartners,
      loading: () => PartnershipRole.owner,
      error: (_, _) => PartnershipRole.owner,
    );
    final mudTuning = ref.watch(mudTuningProvider);
    final recentNudge = partnersAsync.when(
      data: _latestRecentNudge,
      loading: () => null,
      error: (_, _) => null,
    );
    final partners = partnersAsync.when(
      data: (p) => p,
      loading: () => const <PartnerSnapshot>[],
      error: (_, _) => const <PartnerSnapshot>[],
    );
    final visibleSentNudgeFeedback =
        _sentNudgeFeedback != null &&
            DateTime.now().difference(_sentNudgeFeedback!.queuedAt) <
                _sentNudgeFeedbackTtl
        ? _sentNudgeFeedback
        : null;

    return HabitCard(
      habit: habit,
      userId: userId,
      challengeDay: challengeDay,
      targetDays: targetDays,
      progressFraction: progressFraction,
      isContinuous: isContinuous,
      isCompletedToday: isCompletedToday,
      isSkippedToday: isSkippedToday,
      viewerRole: viewerRole,
      recentNudge: recentNudge,
      streak: streakAsync.when(
        data: (value) => value,
        loading: () => 0,
        error: (_, _) => 0,
      ),
      resistanceCoefficient: resistance.resistanceCoefficient,
      calculatedDurationMs: resistance.calculatedDurationMs,
      partners: partners,
      hapticsEnabled: mudTuning.hapticsEnabled,
      hapticProfile: mudTuning.hapticProfile,
      onCompletion: () => _handleCompletion(
        context,
        ref,
        habit,
        challengeDay,
        viewerRole,
        partners,
      ),
      onSkip: () => _handleSkip(context, ref, habit),
      onNudgeTap: (partner) async {
        final db = ref.read(databaseProvider);
        final queuedAt = DateTime.now();
        setState(() {
          _sentNudgeFeedback = _QueuedNudgeFeedback(
            partnerName: partner.username,
            queuedAt: queuedAt,
          );
        });
        _clearSentNudgeTimer?.cancel();
        _clearSentNudgeTimer = Timer(_sentNudgeFeedbackTtl, () {
          if (!mounted) return;
          setState(() {
            if (_sentNudgeFeedback?.queuedAt == queuedAt) {
              _sentNudgeFeedback = null;
            }
          });
        });
        await enqueueNudge(
          db: db,
          senderUserId: userId,
          targetUserId: partner.partnerUserId,
          habitId: habit.habitId,
        );
        unawaited(ref.read(syncServiceProvider).flushPending());
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Nudge queued for ${partner.username} on ${habitTitleWithEmoji(habit.title)}.',
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color(
              int.tryParse(habit.colorHex, radix: 16) ?? 0xFF9CAF88,
            ).withValues(alpha: 0.92),
          ),
        );
      },
      isShowingCompletionFeedback: _isShowingCompletionFeedback,
      sentNudgeFeedback: visibleSentNudgeFeedback == null
          ? null
          : QueuedNudgeFeedback(
              partnerName: visibleSentNudgeFeedback.partnerName,
              queuedAt: visibleSentNudgeFeedback.queuedAt,
            ),
    );
  }

  PartnerSnapshot? _latestRecentNudge(List<PartnerSnapshot> partners) {
    final cutoff = DateTime.now().subtract(_nudgeVisibilityTtl);
    final nudgedPartners =
        partners
            .where((partner) => partner.lastNudgeAt?.isAfter(cutoff) == true)
            .toList()
          ..sort((a, b) {
            final left = a.lastNudgeAt;
            final right = b.lastNudgeAt;
            if (left == null && right == null) return 0;
            if (left == null) return 1;
            if (right == null) return -1;
            return right.compareTo(left);
          });
    return nudgedPartners.isEmpty ? null : nudgedPartners.first;
  }

  PartnershipRole _viewerRoleForPartners(List<PartnerSnapshot> partners) {
    if (partners.isEmpty) return PartnershipRole.owner;
    if (partners.any((partner) => partner.role == PartnershipRole.owner)) {
      return PartnershipRole.owner;
    }
    if (partners.any((partner) => partner.role == PartnershipRole.partner)) {
      return PartnershipRole.partner;
    }
    return PartnershipRole.supporter;
  }

  Future<void> _handleCompletion(
    BuildContext context,
    WidgetRef ref,
    Habit habit,
    int currentDay,
    PartnershipRole viewerRole,
    List<PartnerSnapshot> partners,
  ) async {
    final db = ref.read(databaseProvider);
    final mudTuning = ref.read(mudTuningProvider);
    final feedbackDuration = completionFeedbackDurationFor(context);
    final currentStreak = await db.getStreak(habit.habitId);
    final newStreak = currentStreak + 1;
    final isMilestone = newStreak > 0 && (newStreak == 3 || newStreak % 7 == 0);
    final sharedBonusEarned =
        partners.isNotEmpty &&
        partners
            .where((partner) => partner.role != PartnershipRole.supporter)
            .every((partner) => partner.hasCompletedToday);
    final pointsEarned = scoreAwardForCompletion(
      sharedBonusEarned: sharedBonusEarned,
    );

    // Show transient completion feedback on the ring
    if (mounted) {
      playCompletionHaptic(mudTuning, milestone: isMilestone);

      setState(() {
        _isShowingCompletionFeedback = true;
      });
      _completionFeedbackTimer?.cancel();
      _completionFeedbackTimer = Timer(feedbackDuration, () {
        if (mounted) {
          setState(() {
            _isShowingCompletionFeedback = false;
          });
        }
      });

      widget.onQueueCompletionCelebration(
        habit: habit,
        emoji: standardHabitForTitle(habit.title)?.emoji,
        celebration: resolveCompletionCelebration(
          habit: habit,
          streakCount: newStreak,
          sharedBonusEarned: sharedBonusEarned,
        ),
        pointsEarned: pointsEarned,
      );

      if (!context.mounted) return;
      // Check for joint completion
      if (sharedBonusEarned) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              '🎉 Joint Completion! You and your partner matched today!',
            ),
            backgroundColor: AppTheme.mutedLavender,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    final logId = const Uuid().v4();
    final now = DateTime.now();

    // 1. Write log to Drift (optimistic)
    await db.insertLog(
      LogsCompanion(
        logId: Value(logId),
        habitId: Value(habit.habitId),
        actionDate: Value(now),
        status: Value(LogStatus.completed),
        pointsAwarded: Value(pointsEarned),
        updatedAt: Value(now),
        isSynced: const Value(false),
      ),
    );

    // 2. Enqueue sync. Server-side gamification owns final score totals.
    await db.enqueueSync(
      SyncQueueCompanion(
        action: Value(SyncAction.logHabit),
        payload: Value(
          '{"log_id":"$logId","habit_id":"${habit.habitId}","status":"completed","logged_at":"${now.toIso8601String()}"}',
        ),
        createdAt: Value(now),
      ),
    );

    // 3. Update optimistic local progression.
    await db.completeHabitDay(
      habit.habitId,
      keepActiveWhenDurationEnds: viewerRole != PartnershipRole.owner,
    );

    await ref.read(syncServiceProvider).flushPending();

    // Invalidate providers to refresh UI
    ref.invalidate(todaysLogProvider(habit.habitId));
    ref.invalidate(streakProvider(habit.habitId));
    ref.invalidate(activeHabitsProvider(widget.userId));
  }

  void _handleSkip(BuildContext context, WidgetRef ref, Habit habit) {
    SkipBottomSheet.show(
      context,
      habitTitle: habitTitleWithEmoji(habit.title),
      onSkipConfirmed: (journalEntry) async {
        final db = ref.read(databaseProvider);
        final logId = const Uuid().v4();
        final now = DateTime.now();

        // 1. Write skip log with journal (optimistic)
        await db.insertLog(
          LogsCompanion(
            logId: Value(logId),
            habitId: Value(habit.habitId),
            actionDate: Value(now),
            status: Value(LogStatus.skipped),
            journalNote: Value(journalEntry),
            updatedAt: Value(now),
            isSynced: const Value(false),
          ),
        );

        // 2. Apply penalty: +2 days
        await db.incrementHabitDuration(habit.habitId, 2);

        // 3. Enqueue sync
        await db.enqueueSync(
          SyncQueueCompanion(
            action: Value(SyncAction.logHabit),
            payload: Value(
              '{"log_id":"$logId","habit_id":"${habit.habitId}","status":"skipped","logged_at":"${now.toIso8601String()}"}',
            ),
            createdAt: Value(now),
          ),
        );

        await ref.read(syncServiceProvider).flushPending();

        ref.invalidate(todaysLogProvider(habit.habitId));
        ref.invalidate(activeHabitsProvider(widget.userId));
      },
    );
  }
}
