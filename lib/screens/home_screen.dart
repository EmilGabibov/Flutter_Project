import 'dart:async';

import 'package:flutter/material.dart';
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
import '../theme/app_theme.dart';
import '../data/standard_habits.dart';
import '../models/habit_visual_state.dart';
import '../widgets/habit_partner_row.dart';
import '../widgets/mud_long_press_button.dart';
import '../widgets/skip_bottom_sheet.dart';
import '../widgets/invitation_banner.dart';
import '../widgets/3d/habit_environment_visualizer.dart';
import '../widgets/habit_form_sheet.dart';
import '../widgets/milestone_wish_carousel.dart';
import '../widgets/usage_tracked_screen.dart';
import 'notification_center_screen.dart';
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

  const HomeScreen({super.key, required this.userId});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _pullDailySync();
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId) {
      _pullDailySync();
    }
  }

  void _pullDailySync() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(syncServiceProvider).pullDailySync(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
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
            loading: () => const Center(child: CircularProgressIndicator()),
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
                            loading: () => const SizedBox.shrink(),
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
                          tooltip: 'Open notifications',
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => NotificationCenterScreen(
                                  userId: widget.userId,
                                ),
                              ),
                            );
                          },
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

        // Daily quote
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.sageGreen.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text('💬', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: quoteAsync.when(
                      data: (quote) => Text(
                        quote,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: AppTheme.deepCharcoal.withValues(alpha: 0.7),
                        ),
                      ),
                      loading: () => const SizedBox.shrink(),
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
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) =>
                  _HabitCard(habit: habits[index], userId: widget.userId),
              childCount: habits.length,
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

  @override
  void dispose() {
    _clearSentNudgeTimer?.cancel();
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
    final canLogProgress = viewerRole != PartnershipRole.supporter;
    final recentNudge = partnersAsync.when(
      data: _latestRecentNudge,
      loading: () => null,
      error: (_, _) => null,
    );
    final visibleSentNudgeFeedback =
        _sentNudgeFeedback != null &&
            DateTime.now().difference(_sentNudgeFeedback!.queuedAt) <
                _sentNudgeFeedbackTtl
        ? _sentNudgeFeedback
        : null;

    return Semantics(
      label:
          '${habit.title}. Challenge day $challengeDay of $targetDays. ${isCompletedToday
              ? "Completed today."
              : isSkippedToday
              ? "Skipped today."
              : "Not completed today."}${recentNudge == null ? "" : " ${recentNudge.username} nudged this habit."}',
      child: Card(
        margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // ─── Ring-focused content area ───
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Main ring with habit icon inside
                  Center(
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
                            resistanceCoefficient:
                                resistance.resistanceCoefficient,
                            calculatedDurationMs:
                                resistance.calculatedDurationMs,
                            isCompleted: isCompletedToday,
                            habitColor: habitColor,
                            habitIcon: habitMeta?.emoji,
                            visualParameters: HabitVisualParameters.standard,
                            onCompletion: () => _handleCompletion(
                              context,
                              ref,
                              habit,
                              challengeDay,
                              viewerRole,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Partner avatars - now larger and more visible
                  partnersAsync.when(
                    data: (partners) => HabitPartnerRow(
                      partners: partners,
                      habitColor: habitColor,
                      maxVisible: 4,
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

                  const SizedBox(height: 12),

                  if (recentNudge != null) ...[
                    _HabitNudgeChip(
                      label: 'Nudged by ${recentNudge.username}',
                      color: habitColor,
                      icon: Icons.notifications_active_rounded,
                    ),
                    const SizedBox(height: 8),
                  ],

                  if (visibleSentNudgeFeedback != null) ...[
                    _HabitNudgeChip(
                      label:
                          'Nudge queued for ${visibleSentNudgeFeedback.partnerName}',
                      color: habitColor,
                      icon: Icons.back_hand_rounded,
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Streak badge
                  streakAsync.when(
                    data: (streak) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: habitColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '🔥 $streak',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: habitColor,
                        ),
                      ),
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),

                  const SizedBox(height: 16),

                  // Skip button - only show if not completed
                  if (!canLogProgress)
                    Text(
                      'Supporters can follow progress and send nudges.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    )
                  else if (!isCompletedToday)
                    TextButton(
                      onPressed: () => _handleSkip(context, ref, habit),
                      child: Text(
                        isSkippedToday ? 'Skipped today' : 'Skip today',
                        style: TextStyle(
                          color: AppTheme.warmGray,
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ─── Bottom progress area with habit name and challenge info ───
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: habitColor.withValues(alpha: 0.08),
              ),
              child: Column(
                children: [
                  // Progress bar
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

                  // Habit name and challenge info
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Challenge: Day $challengeDay of $targetDays',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppTheme.deepCharcoal.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                        ),
                      ],
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
  ) async {
    final db = ref.read(databaseProvider);
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
