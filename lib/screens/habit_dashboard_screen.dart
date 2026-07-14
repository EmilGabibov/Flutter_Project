import 'dart:async';
import 'dart:math' as math;

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import '../models/daily_quote.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../theme/app_theme.dart';

import '../database/database.dart';
import '../database/tables.dart' show LogStatus, PartnershipRole, SyncAction;
import '../l10n/app_localizations.dart';
import '../providers/celebration_provider.dart';
import '../providers/database_provider.dart';
import '../providers/habit_providers.dart';
import '../providers/mud_tuning_provider.dart';
import '../providers/quote_provider.dart';
import '../providers/resistance_provider.dart';
import '../providers/social_providers.dart';
import '../providers/sync_provider.dart';
import '../models/celebration_feedback.dart';
import '../services/app_error.dart';
import '../services/celebration_sequence_controller.dart';
import '../utils/habit_timeline.dart';
import '../widgets/badge_reveal_dialog.dart';
import '../widgets/habit_card.dart';
import '../widgets/skip_bottom_sheet.dart';
import 'completion_splash_screen.dart';

const _dashboardSentNudgeFeedbackTtl = Duration(seconds: 4);
const _dashboardNudgeVisibilityTtl = Duration(hours: 24);

class _DashboardCelebrationRequest {
  final Future<void> Function(BuildContext context, WidgetRef ref) present;

  const _DashboardCelebrationRequest({required this.present});
}

class HabitDashboardScreen extends ConsumerStatefulWidget {
  const HabitDashboardScreen({super.key, required this.userId});

  final String userId;

  static int columnsForWidth(double width) {
    if (width >= 1440) return 4;
    if (width >= 1100) return 3;
    if (width >= 760) return 2;
    return 1;
  }

  @override
  ConsumerState<HabitDashboardScreen> createState() =>
      _HabitDashboardScreenState();
}

class _HabitDashboardScreenState extends ConsumerState<HabitDashboardScreen> {
  final CelebrationSequenceController<_DashboardCelebrationRequest>
  _celebrationSequence =
      CelebrationSequenceController<_DashboardCelebrationRequest>();

  void _enqueueAchievementCelebrations(List<AchievementUnlock> unlocks) {
    for (final badge in unlocks) {
      final parts = badge.achievementId.replaceAll('_', ' ').split(' ');
      final title = parts
          .map(
            (part) => part.isEmpty
                ? ''
                : '${part[0].toUpperCase()}${part.substring(1)}',
          )
          .join(' ');
      _celebrationSequence.enqueue(
        _DashboardCelebrationRequest(
          present: (context, ref) async {
            final l10n = AppLocalizations.of(context)!;
            await BadgeRevealDialog.show(
              context,
              title,
              l10n.dashboardAchievementUnlocked,
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
      _DashboardCelebrationRequest(
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

    return Scaffold(
      appBar: AppBar(title: Text(l10n.dashboardTitle)),
      body: habitsAsync.when(
        data: (habits) => LayoutBuilder(
          builder: (context, constraints) {
            final columns = HabitDashboardScreen.columnsForWidth(
              constraints.maxWidth,
            );
            final showSummaryRail = constraints.maxWidth >= 1100;

            final content = _DashboardGrid(
              userId: widget.userId,
              habits: habits,
              columns: columns,
              onQueueCompletionCelebration: _queueCompletionCelebration,
            );

            if (!showSummaryRail) {
              return ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _DashboardSummaryCard(habits: habits, quoteAsync: quoteAsync),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: math.max(
                      520,
                      (habits.length * 280 / columns).ceilToDouble(),
                    ),
                    child: content,
                  ),
                ],
              );
            }

            return Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: content),
                  const SizedBox(width: 24),
                  SizedBox(
                    width: 320,
                    child: _DashboardSummaryCard(
                      habits: habits,
                      quoteAsync: quoteAsync,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              AppError.fromAny(
                error,
                fallbackCode: 'habit_dashboard_load_failed',
                fallbackMessage: l10n.dashboardLoadFailed,
                fallbackKind: AppErrorKind.inline,
              ).message,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardGrid extends StatelessWidget {
  const _DashboardGrid({
    required this.userId,
    required this.habits,
    required this.columns,
    required this.onQueueCompletionCelebration,
  });

  final String userId;
  final List<Habit> habits;
  final int columns;
  final void Function({
    required Habit habit,
    required String? emoji,
    required CompletionCelebrationSpec celebration,
    required int pointsEarned,
  })
  onQueueCompletionCelebration;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (habits.isEmpty) {
      return Center(child: Text(l10n.dashboardEmptyState));
    }

    return GridView.builder(
      key: ValueKey('habit-dashboard-grid-$columns'),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: columns == 1 ? 1.45 : 0.96,
      ),
      itemCount: habits.length,
      itemBuilder: (context, index) {
        return _DashboardHabitTile(
          habit: habits[index],
          userId: userId,
          onQueueCompletionCelebration: onQueueCompletionCelebration,
        );
      },
    );
  }
}

class _DashboardSummaryCard extends StatelessWidget {
  const _DashboardSummaryCard({required this.habits, required this.quoteAsync});

  final List<Habit> habits;
  final AsyncValue<DailyQuote> quoteAsync;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final totalHabits = habits.length;
    final challengeHabits = habits
        .where((habit) => habit.targetDuration > 0)
        .length;
    final continuousHabits = totalHabits - challengeHabits;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.dashboardSummaryTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _SummaryRow(
              label: l10n.dashboardActiveHabitsLabel,
              value: '$totalHabits',
            ),
            _SummaryRow(
              label: l10n.dashboardChallengeHabitsLabel,
              value: '$challengeHabits',
            ),
            _SummaryRow(
              label: l10n.dashboardContinuousHabitsLabel,
              value: '$continuousHabits',
            ),
            const SizedBox(height: 20),
            Text(
              l10n.dashboardQuoteOfDayTitle,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            quoteAsync.when(
              data: (quote) => Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: quote.text),
                    if (quote.author != null && quote.author!.isNotEmpty)
                      TextSpan(
                        text: '\n— ${quote.author}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.warmGray,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                  ],
                ),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              loading: () => Text(l10n.dashboardQuoteLoading),
              error: (_, _) => Text(l10n.dashboardQuoteFallback),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _DashboardHabitTile extends ConsumerStatefulWidget {
  const _DashboardHabitTile({
    required this.habit,
    required this.userId,
    required this.onQueueCompletionCelebration,
  });

  final Habit habit;
  final String userId;
  final void Function({
    required Habit habit,
    required String? emoji,
    required CompletionCelebrationSpec celebration,
    required int pointsEarned,
  })
  onQueueCompletionCelebration;

  @override
  ConsumerState<_DashboardHabitTile> createState() =>
      _DashboardHabitTileState();
}

class _DashboardHabitTileState extends ConsumerState<_DashboardHabitTile> {
  QueuedNudgeFeedback? _sentNudgeFeedback;
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
    final todaysLogAsync = ref.watch(todaysLogProvider(habit.habitId));
    final streakAsync = ref.watch(streakProvider(habit.habitId));
    final partnersAsync = ref.watch(habitPartnersProvider(habit.habitId));

    final challengeDay = challengeTimelineDay(habit);
    final progressDay = challengeProgressDay(habit);
    final targetDays = habit.targetDuration > 0 ? habit.targetDuration : 1;
    final progressFraction = challengeProgressFraction(habit);
    final isContinuous = habit.targetDuration <= 0;
    final mudTuning = ref.watch(mudTuningProvider);
    final resistance = ref.watch(
      resistanceProvider((
        currentDay: progressDay.clamp(0, targetDays),
        totalDuration: targetDays,
      )),
    );
    final todaysLog = todaysLogAsync.when(
      data: (log) => log,
      loading: () => null,
      error: (_, _) => null,
    );
    final isCompletedToday = todaysLog?.status == LogStatus.completed;
    final isSkippedToday = todaysLog?.status == LogStatus.skipped;

    final partners = partnersAsync.when(
      data: (value) => value,
      loading: () => const <PartnerSnapshot>[],
      error: (_, _) => const <PartnerSnapshot>[],
    );
    final viewerRole = _viewerRoleForPartners(partners);
    final recentNudge = _latestRecentNudge(partners);

    return HabitCard(
      habit: habit,
      userId: widget.userId,
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
      onCompletion: () =>
          _handleCompletion(context, habit, challengeDay, viewerRole, partners),
      onSkip: () => _handleSkip(context, habit),
      onNudgeTap: _handleNudgeTap,
      isShowingCompletionFeedback: _isShowingCompletionFeedback,
      sentNudgeFeedback: _visibleSentNudgeFeedback,
    );
  }

  QueuedNudgeFeedback? get _visibleSentNudgeFeedback {
    final feedback = _sentNudgeFeedback;
    if (feedback == null) return null;
    if (DateTime.now().difference(feedback.queuedAt) >=
        _dashboardSentNudgeFeedbackTtl) {
      return null;
    }
    return feedback;
  }

  PartnerSnapshot? _latestRecentNudge(List<PartnerSnapshot> partners) {
    final cutoff = DateTime.now().subtract(_dashboardNudgeVisibilityTtl);
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

  Future<void> _handleNudgeTap(PartnerSnapshot partner) async {
    final queuedAt = DateTime.now();
    setState(() {
      _sentNudgeFeedback = QueuedNudgeFeedback(
        partnerName: partner.username,
        queuedAt: queuedAt,
      );
    });
    _clearSentNudgeTimer?.cancel();
    _clearSentNudgeTimer = Timer(_dashboardSentNudgeFeedbackTtl, () {
      if (!mounted) return;
      setState(() {
        if (_sentNudgeFeedback?.queuedAt == queuedAt) {
          _sentNudgeFeedback = null;
        }
      });
    });

    await enqueueNudge(
      db: ref.read(databaseProvider),
      senderUserId: widget.userId,
      targetUserId: partner.partnerUserId,
      habitId: widget.habit.habitId,
    );
    await ref.read(syncServiceProvider).flushPending();
  }

  Future<void> _handleCompletion(
    BuildContext context,
    Habit habit,
    int challengeDay,
    PartnershipRole viewerRole,
    List<PartnerSnapshot> partners,
  ) async {
    final db = ref.read(databaseProvider);
    final mudTuning = ref.read(mudTuningProvider);
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

    if (mounted) {
      if (mudTuning.hapticsEnabled) {
        if (isMilestone) {
          switch (mudTuning.hapticProfile) {
            case MudHapticProfile.soft:
              HapticFeedback.lightImpact();
              break;
            case MudHapticProfile.standard:
              HapticFeedback.heavyImpact();
              break;
            case MudHapticProfile.strong:
              HapticFeedback.vibrate();
              break;
          }
        } else {
          switch (mudTuning.hapticProfile) {
            case MudHapticProfile.soft:
              HapticFeedback.selectionClick();
              break;
            case MudHapticProfile.standard:
              HapticFeedback.mediumImpact();
              break;
            case MudHapticProfile.strong:
              HapticFeedback.heavyImpact();
              break;
          }
        }
      }
      setState(() {
        _isShowingCompletionFeedback = true;
      });
      _completionFeedbackTimer?.cancel();
      _completionFeedbackTimer = Timer(const Duration(milliseconds: 1200), () {
        if (!mounted) return;
        setState(() {
          _isShowingCompletionFeedback = false;
        });
      });

      widget.onQueueCompletionCelebration(
        habit: habit,
        emoji: null,
        celebration: resolveCompletionCelebration(
          habit: habit,
          streakCount: newStreak,
          sharedBonusEarned: sharedBonusEarned,
        ),
        pointsEarned: pointsEarned,
      );

      if (sharedBonusEarned && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Joint completion registered for this shared habit.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    final logId = const Uuid().v4();
    final now = DateTime.now();

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
    await db.enqueueSync(
      SyncQueueCompanion(
        action: Value(SyncAction.logHabit),
        payload: Value(
          '{"log_id":"$logId","habit_id":"${habit.habitId}","status":"completed","logged_at":"${now.toIso8601String()}"}',
        ),
        createdAt: Value(now),
      ),
    );
    await db.completeHabitDay(
      habit.habitId,
      keepActiveWhenDurationEnds: viewerRole != PartnershipRole.owner,
    );
    await ref.read(syncServiceProvider).flushPending();
    ref.invalidate(todaysLogProvider(habit.habitId));
    ref.invalidate(streakProvider(habit.habitId));
    ref.invalidate(activeHabitsProvider(widget.userId));
  }

  void _handleSkip(BuildContext context, Habit habit) {
    SkipBottomSheet.show(
      context,
      habitTitle: habit.title,
      onSkipConfirmed: (journalEntry) async {
        final db = ref.read(databaseProvider);
        final logId = const Uuid().v4();
        final now = DateTime.now();

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
        await db.incrementHabitDuration(habit.habitId, 2);
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
