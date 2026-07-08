import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' hide Column;
import '../database/database.dart';
import '../database/tables.dart' show HabitStatus, LogStatus, SyncAction;
import '../providers/database_provider.dart';
import '../providers/habit_providers.dart';
import '../providers/resistance_provider.dart';
import '../providers/scoring_provider.dart';
import '../providers/quote_provider.dart';
import '../providers/social_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/mud_long_press_button.dart';
import '../widgets/skip_bottom_sheet.dart';
import '../widgets/partner_ticker.dart';
import '../widgets/invitation_banner.dart';
import '../widgets/milestone_wish_carousel.dart';
import 'profile_screen.dart';

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
  Widget build(BuildContext context) {
    final habitsAsync = ref.watch(activeHabitsProvider(widget.userId));
    final quoteAsync = ref.watch(quoteProvider);

    return Scaffold(
      body: SafeArea(
        child: habitsAsync.when(
          data: (habits) => _buildContent(context, habits, quoteAsync),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _greeting(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Consumer(builder: (context, ref, _) {
                      final userAsync = ref.watch(currentUserProvider);
                      return userAsync.when(
                        data: (user) => Text(
                          user?.username ?? 'Friend',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        loading: () => const SizedBox.shrink(),
                        error: (_, _) => const SizedBox.shrink(),
                      );
                    }),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ProfileScreen(userId: widget.userId),
                    ));
                  },
                  icon: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceVariant,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.person_rounded,
                        color: AppTheme.warmGray, size: 22),
                  ),
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

        // Phase 2: Pending Invitations
        const SliverToBoxAdapter(
          child: InvitationBanner(),
        ),

        // Phase 2: Milestone Wishes
        const SliverToBoxAdapter(
          child: MilestoneWishCarousel(),
        ),

        // Habit cards
        if (habits.isEmpty)
          SliverFillRemaining(
            child: Center(
              child: Text(
                'No active habits.\nStart a new one from your profile.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _HabitCard(
                habit: habits[index],
                userId: widget.userId,
              ),
              childCount: habits.length,
            ),
          ),

        // Partner ticker — reads Drift, never network
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Consumer(builder: (context, ref, _) {
              final partnersAsync = ref.watch(allPartnersProvider);
              return partnersAsync.when(
                data: (partners) => PartnerTicker(
                  partners: partners,
                  onNudgeTap: (targetUserId) async {
                    final db = ref.read(databaseProvider);
                    await enqueueNudge(
                      db: db,
                      senderUserId: widget.userId,
                      targetUserId: targetUserId,
                    );
                  },
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              );
            }),
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
}

class _HabitCard extends ConsumerWidget {
  final Habit habit;
  final String userId;

  const _HabitCard({required this.habit, required this.userId});

  /// Convert a stored hex string like 'FF9CAF88' to a Flutter [Color].
  Color _hexToColor(String hex) {
    try {
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return AppTheme.sageGreen;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todaysLogAsync = ref.watch(todaysLogProvider(habit.habitId));
    final streakAsync = ref.watch(streakProvider(habit.habitId));

    // Calculate resistance
    final currentDay = habit.targetDuration - habit.currentDuration + 1;
    final resistance = ref.watch(resistanceProvider((
      currentDay: currentDay.clamp(0, habit.currentDuration),
      totalDuration: habit.currentDuration,
    )));

    final isCompletedToday = todaysLogAsync.when(
      data: (log) => log != null,
      loading: () => false,
      error: (_, _) => false,
    );

    return Card(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Habit title and streak
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    habit.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                streakAsync.when(
                  data: (streak) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.sageGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '🔥 $streak',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.sageGreen,
                      ),
                    ),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Day $currentDay of ${habit.currentDuration}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),

            // Mud button
            Center(
              child: MudLongPressButton(
                resistanceCoefficient: resistance.resistanceCoefficient,
                calculatedDurationMs: resistance.calculatedDurationMs,
                isCompleted: isCompletedToday,
                habitColor: _hexToColor(habit.colorHex),
                onCompletion: () =>
                    _handleCompletion(context, ref, habit, currentDay),
              ),
            ),
            const SizedBox(height: 20),

            // Skip button
            if (!isCompletedToday)
              TextButton(
                onPressed: () => _handleSkip(context, ref, habit),
                child: Text(
                  'Skip today',
                  style: TextStyle(
                    color: AppTheme.warmGray,
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleCompletion(
    BuildContext context,
    WidgetRef ref,
    Habit habit,
    int currentDay,
  ) async {
    final db = ref.read(databaseProvider);
    final logId = const Uuid().v4();
    final now = DateTime.now();

    // 1. Write log to Drift (optimistic)
    await db.insertLog(LogsCompanion(
      logId: Value(logId),
      habitId: Value(habit.habitId),
      actionDate: Value(now),
      status: Value(LogStatus.completed),
      updatedAt: Value(now),
      isSynced: const Value(false),
    ));

    // 2. Calculate and update score
    final streak = await db.getStreak(habit.habitId);
    final points = ScoringEngine.calculateCompletionPoints(
      currentStreak: streak,
      currentDay: currentDay,
    );
    final user = await db.getUser(userId);
    if (user != null) {
      await db.updateUserScore(userId, user.totalScore + points);
    }

    // 3. Enqueue sync
    await db.enqueueSync(SyncQueueCompanion(
      action: Value(SyncAction.logHabit),
      payload: Value(
          '{"log_id":"$logId","habit_id":"${habit.habitId}","status":"completed"}'),
      createdAt: Value(now),
    ));

    // 4. Check if habit is complete
    if (currentDay >= habit.currentDuration) {
      await db.updateHabitStatus(habit.habitId, HabitStatus.completed);
    }

    // Invalidate providers to refresh UI
    ref.invalidate(todaysLogProvider(habit.habitId));
    ref.invalidate(streakProvider(habit.habitId));
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
        await db.insertLog(LogsCompanion(
          logId: Value(logId),
          habitId: Value(habit.habitId),
          actionDate: Value(now),
          status: Value(LogStatus.skipped),
          journalNote: Value(journalEntry),
          updatedAt: Value(now),
          isSynced: const Value(false),
        ));

        // 2. Apply penalty: +2 days
        await db.incrementHabitDuration(habit.habitId, 2);

        // 3. Enqueue sync
        await db.enqueueSync(SyncQueueCompanion(
          action: Value(SyncAction.logHabit),
          payload: Value(
              '{"log_id":"$logId","habit_id":"${habit.habitId}","status":"skipped","journal":"$journalEntry"}'),
          createdAt: Value(now),
        ));

        ref.invalidate(todaysLogProvider(habit.habitId));
        ref.invalidate(activeHabitsProvider(userId));
      },
    );
  }
}
