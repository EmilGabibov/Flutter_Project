import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' hide Column;
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
import '../models/habit_visual_state.dart';
import '../widgets/habit_partner_row.dart';
import '../widgets/mud_long_press_button.dart';
import '../widgets/skip_bottom_sheet.dart';
import '../widgets/invitation_banner.dart';
import '../widgets/3d/habit_environment_visualizer.dart';
import '../widgets/habit_form_sheet.dart';
import 'completion_splash_screen.dart';
import '../widgets/badge_reveal_dialog.dart';
import '../widgets/milestone_wish_carousel.dart';
import '../widgets/skeletons.dart';
import '../widgets/usage_tracked_screen.dart';
import 'habit_dashboard_screen.dart';
import 'profile_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    ref.listen<List<AchievementUnlock>>(celebrationProvider, (previous, next) {
      if (next.isNotEmpty) {
        final badge = next.first;
        final parts = badge.achievementId.replaceAll('_', ' ').split(' ');
        final title = parts
            .map(
              (e) =>
                  e.isNotEmpty ? '${e[0].toUpperCase()}${e.substring(1)}' : '',
            )
            .join(' ');

        BadgeRevealDialog.show(context, title, 'You unlocked a new badge!', () {
          ref
              .read(celebrationProvider.notifier)
              .markRevealed(badge.achievementId);
        });
      }
    });

    final habitsAsync = ref.watch(activeHabitsProvider(widget.userId));
    final quoteAsync = ref.watch(quoteProvider);

    return UsageTrackedScreen(
      screenName: 'home',
      child: Scaffold(
        floatingActionButton: Semantics(
          label: 'Create a new habit',
          button: true,
          child: FloatingActionButton.extended(
            heroTag: 'home-create-habit',
            onPressed: () => HabitFormSheet.show(context),
            backgroundColor: AppTheme.deepCharcoal,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Habit'),
          ),
        ),
        body: SafeArea(
          child: habitsAsync.when(
            data: (habits) => _buildContent(context, habits, quoteAsync),
            loading: () => const _HomeSkeleton(),
            error: (err, _) => Center(child: Text('Error: $err')),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<Habit> habits,
    AsyncValue<String> quoteAsync,
  ) {
    bool allEmpty = true;
    for (final h in habits) {
      final log = ref.watch(todaysLogProvider(h.habitId)).value;
      if (log != null && log.status == LogStatus.completed) {
        allEmpty = false;
        break;
      }
    }

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
                        _greeting(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Consumer(
                        builder: (context, ref, _) {
                          final userAsync = ref.watch(currentUserProvider);
                          return userAsync.when(
                            data: (user) => Text(
                              user?.username ?? 'Friend',
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
                        final unreadAsync = ref.watch(
                          unreadNotificationCountProvider,
                        );
                        final unreadCount = unreadAsync.value ?? 0;
                        return IconButton(
                          tooltip: 'Open dashboard',
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
                          tooltip: 'Open notifications',
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
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: allEmpty
                    ? AppTheme.mutedLavender.withValues(alpha: 0.1)
                    : AppTheme.sageGreen.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text(
                    allEmpty ? '🚀' : '💬',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: allEmpty
                        ? Text(
                            "A new day, a fresh start! Ready to build your streak today?",
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.mutedLavender,
                                ),
                          )
                        : quoteAsync.when(
                            data: (quote) => Text(
                              quote,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: AppTheme.deepCharcoal.withValues(
                                      alpha: 0.7,
                                    ),
                                  ),
                            ),
                            loading: () => const HableSkeletonBlock(
                              width: double.infinity,
                              height: 14,
                            ),
                            error: (_, _) => const SizedBox.shrink(),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Phase 2: 3D Environment
        const SliverToBoxAdapter(
          child: HabitEnvironmentVisualizer(height: 250),
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
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'No active habits yet.\nStart one from Home.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => HabitFormSheet.show(context),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Add habit'),
                  ),
                ],
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
                childAspectRatio: 0.85, // Adjust for tile proportions
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => KeyedSubtree(
                  key: _habitKey(habits[index].habitId),
                  child: _HabitCard(
                    habit: habits[index],
                    userId: widget.userId,
                  ),
                ),
                childCount: habits.length,
              ),
            ),
          ),
      ],
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  Widget _buildSuggestedHabits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Text(
            'Suggested Habits',
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
                        Text(habit.emoji, style: const TextStyle(fontSize: 24)),
                        const SizedBox(height: 6),
                        Text(
                          habit.title,
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

  const _HabitCard({required this.habit, required this.userId});

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

  /// Convert a stored hex string like 'FF9CAF88' to a Flutter [Color].
  Color _hexToColor(String hex) {
    try {
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return AppTheme.sageGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final habit = widget.habit;
    final userId = widget.userId;
    final todaysLogAsync = ref.watch(todaysLogProvider(habit.habitId));
    final streakAsync = ref.watch(streakProvider(habit.habitId));
    final partnersAsync = ref.watch(habitPartnersProvider(habit.habitId));
    final habitMeta = standardHabitForTitle(habit.title);
    final habitColor = _hexToColor(habit.colorHex);

    // Calculate resistance
    final isContinuous = habit.targetDuration <= 0;
    final challengeDay = _challengeDay(habit);
    final progressFraction = _progressFraction(habit);
    final targetDays = habit.targetDuration > 0 ? habit.targetDuration : 1;
    final resistance = ref.watch(
      resistanceProvider((
        currentDay: challengeDay.clamp(0, targetDays),
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
    final canLogProgress = viewerRole != PartnershipRole.supporter;
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

    HabitVisualState visualState = HabitVisualState.idle;
    if (_isShowingCompletionFeedback) {
      visualState = HabitVisualState.checkInComplete;
    } else if (isCompletedToday) {
      visualState = HabitVisualState.established;
    } else if (isSkippedToday) {
      visualState = HabitVisualState.skipped;
    } else if (recentNudge != null) {
      visualState = HabitVisualState.nudged;
    }

    return Semantics(
      label:
          '${habit.title}. Challenge day $challengeDay of $targetDays. ${isCompletedToday
              ? "Completed today."
              : isSkippedToday
              ? "Skipped today."
              : "Not completed today."}${recentNudge == null ? "" : " ${recentNudge.username} nudged this habit."}',
      child: Card(
        margin:
            EdgeInsets.zero, // Padding handled by SliverPadding/Grid spacing
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // ─── Top-left title ───
            Positioned(
              top: 16,
              left: 16,
              right: 64, // Leave room for partner avatars
              child: Text(
                habit.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),

            // ─── Top-right partners ───
            Positioned(
              top: 12,
              right: 12,
              child: partnersAsync.when(
                data: (partners) => HabitPartnerRow(
                  partners: partners,
                  habitColor: habitColor,
                  compactMode: true,
                  maxVisible: 3,
                  onProfileTap: (partner) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            ProfileScreen(userId: partner.partnerUserId),
                      ),
                    );
                  },
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
                          'Nudge queued for ${partner.username} on ${habit.title}.',
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: habitColor.withValues(alpha: 0.92),
                      ),
                    );
                  },
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
            ),

            // ─── Center Ring ───
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 24,
                  bottom: 48,
                ), // offset for bottom bar
                child: Opacity(
                  opacity: canLogProgress ? 1 : 0.45,
                  child: IgnorePointer(
                    ignoring: !canLogProgress,
                    child: _NudgedRingPulse(
                      isActive: recentNudge != null && !isCompletedToday,
                      color: habitColor,
                      pulseKey:
                          recentNudge?.lastNudgeAt?.millisecondsSinceEpoch,
                      child: MudLongPressButton(
                        resistanceCoefficient: resistance.resistanceCoefficient,
                        calculatedDurationMs: resistance.calculatedDurationMs,
                        visualState: visualState,
                        habitColor: habitColor,
                        habitIcon: habitMeta?.emoji,
                        visualParameters: HabitVisualParameters.standard,
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
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ─── Nudge Feedbacks (Overlay above bottom bar) ───
            Positioned(
              left: 0,
              right: 0,
              bottom: 40,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (recentNudge != null) ...[
                    _HabitNudgeChip(
                      label: 'Nudged by ${recentNudge.username}',
                      color: habitColor,
                      icon: Icons.notifications_active_rounded,
                    ),
                    const SizedBox(height: 4),
                  ],
                  if (visibleSentNudgeFeedback != null) ...[
                    _HabitNudgeChip(
                      label:
                          'Nudge queued for ${visibleSentNudgeFeedback.partnerName}',
                      color: habitColor,
                      icon: Icons.back_hand_rounded,
                    ),
                    const SizedBox(height: 4),
                  ],
                  if (!canLogProgress)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Following',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.warmGray,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else if (!isCompletedToday)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: InkWell(
                        onTap: () => _handleSkip(context, ref, habit),
                        child: Text(
                          isSkippedToday ? 'Skipped today' : 'Skip today',
                          style: TextStyle(
                            color: AppTheme.warmGray,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ─── Bottom Progress Area ───
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: habitColor.withValues(alpha: 0.08),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isContinuous
                              ? 'Continuous'
                              : 'Day $challengeDay of $targetDays',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppTheme.deepCharcoal.withValues(
                                  alpha: 0.7,
                                ),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        streakAsync.when(
                          data: (streak) => Text(
                            '🔥 $streak',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: habitColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                          ),
                          loading: () => const SizedBox.shrink(),
                          error: (_, _) => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                  Semantics(
                    label:
                        'Progress ${((progressFraction * 100).round())} percent.',
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: habitColor.withValues(alpha: 0.12),
                      ),
                      child: FractionallySizedBox(
                        widthFactor: progressFraction,
                        alignment: Alignment.centerLeft,
                        child: Container(color: habitColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PartnerSnapshot? _latestRecentNudge(List<PartnerSnapshot> partners) {
    final cutoff = DateTime.now().subtract(_nudgeVisibilityTtl);
    final nudgedPartners =
        partners
            .where(
              (partner) =>
                  partner.lastNudgeAt != null &&
                  partner.lastNudgeAt!.isAfter(cutoff),
            )
            .toList()
          ..sort((a, b) => b.lastNudgeAt!.compareTo(a.lastNudgeAt!));
    return nudgedPartners.isEmpty ? null : nudgedPartners.first;
  }

  int _challengeDay(Habit habit) {
    final total = habit.targetDuration > 0 ? habit.targetDuration : 1;
    final raw = total - habit.currentDuration + 1;
    return raw.clamp(1, total);
  }

  double _progressFraction(Habit habit) {
    final total = habit.targetDuration > 0 ? habit.targetDuration : 1;
    final day = _challengeDay(habit);
    return (day / total).clamp(0.0, 1.0);
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
    final currentStreak = await db.getStreak(habit.habitId);
    final newStreak = currentStreak + 1;
    final isMilestone = newStreak > 0 && (newStreak == 3 || newStreak % 7 == 0);

    // Show transient completion feedback on the ring
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
        if (mounted) {
          setState(() {
            _isShowingCompletionFeedback = false;
          });
        }
      });

      // Push the completion splash screen overlay
      Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) {
            return CompletionSplashScreen(
              habit: habit,
              emoji: standardHabitForTitle(habit.title)?.emoji,
            );
          },
        ),
      );

      if (!context.mounted) return;
      // Check for joint completion
      if (partners.any((p) => p.hasCompletedToday)) {
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
      habitTitle: habit.title,
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

class _NudgedRingPulse extends StatelessWidget {
  final bool isActive;
  final Color color;
  final int? pulseKey;
  final Widget child;

  const _NudgedRingPulse({
    required this.isActive,
    required this.color,
    required this.pulseKey,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!isActive) return child;

    return TweenAnimationBuilder<double>(
      key: ValueKey('nudge-pulse-$pulseKey'),
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final pulse = 1 - value;
        return Transform.scale(
          scale: 1 + (pulse * 0.04),
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.28 * pulse),
                  blurRadius: 34,
                  spreadRadius: 12,
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _HabitNudgeChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _HabitNudgeChip({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      child: Container(
        key: ValueKey(label),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withValues(alpha: 0.45)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.deepCharcoal,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
