import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';
import '../database/tables.dart' show HabitStatus, LogStatus, PartnershipRole;
import '../data/standard_habits.dart';
import '../providers/habit_providers.dart';
import '../providers/sync_provider.dart';
import '../services/app_error.dart';
import '../services/local_reminder_service.dart';
import '../services/client_reset_service.dart';
import '../theme/app_theme.dart';
import '../widgets/habit_form_sheet.dart';
import '../widgets/habit_partner_row.dart';
import '../widgets/habit_card.dart';
import '../widgets/user_avatar.dart';
import '../widgets/achievement_share_card.dart';
import '../widgets/avatar_picker_sheet.dart';
import '../widgets/skeletons.dart';
import '../providers/habit_actions_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/notification_providers.dart';
import '../providers/social_providers.dart';
import '../providers/calendar_provider.dart';
import '../providers/database_provider.dart';
import '../providers/mud_tuning_provider.dart';
import '../widgets/usage_tracked_screen.dart';
import '../widgets/narrow_layout.dart';
import '../widgets/language_selector.dart';
import '../widgets/accessibility_selector.dart';

/// Profile Screen — heavy data layer.
/// All historical data and charts belong here exclusively.
class ProfileScreen extends ConsumerStatefulWidget {
  final String userId;
  final bool showBackButton;

  const ProfileScreen({
    super.key,
    required this.userId,
    this.showBackButton = false,
  });

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = ref.watch(authProvider).userId;
    final isFriend = widget.userId != currentUserId && currentUserId != null;

    if (isFriend) {
      return _buildFriendProfile(context, ref);
    }

    final userAsync = ref.watch(currentUserProvider);
    final distributionAsync = ref.watch(logDistributionProvider(widget.userId));
    final historyAsync = ref.watch(pointHistoryProvider(widget.userId));
    final allHabitsAsync = ref.watch(allHabitsProvider(widget.userId));
    final achievementsAsync = ref.watch(
      achievementUnlocksProvider(widget.userId),
    );

    return UsageTrackedScreen(
      screenName: 'profile',
      child: Scaffold(
        body: SafeArea(
          child: NarrowLayout(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  // Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                      child: Row(
                        children: [
                          if (widget.showBackButton) ...[
                            IconButton(
                              tooltip: 'Back',
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(
                                Icons.arrow_back_rounded,
                                color: AppTheme.deepCharcoal,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            'Profile',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const Spacer(),
                          IconButton(
                            tooltip: 'Open settings',
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      SettingsScreen(userId: widget.userId),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.settings_rounded,
                              color: AppTheme.deepCharcoal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // User card
                  SliverToBoxAdapter(
                    child: userAsync.when(
                      data: (user) => Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    UserAvatar(
                                      avatarUrl: user?.avatarUrl,
                                      username: user?.username,
                                      radius: 28,
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user?.username ?? 'User',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleLarge,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '@${user?.username ?? 'user'}',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                      const SizedBox(height: 10),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: [
                                          _InfoPill(
                                            label: user?.levelName ?? 'Newbie',
                                            color: AppTheme.sageGreen,
                                          ),
                                          _InfoPill(
                                            label:
                                                '${user?.totalScore ?? 0} lifetime pts',
                                            color: AppTheme.deepCharcoal,
                                            fillColor: AppTheme.surfaceVariant,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Lifetime score comes from backend sync. Journey and history show per-check-in awards.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: AppTheme.warmGray,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, _) => const SizedBox.shrink(),
                    ),
                  ),

                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        controller: _tabController,
                        labelColor: AppTheme.deepCharcoal,
                        unselectedLabelColor: AppTheme.warmGray,
                        indicatorColor: AppTheme.sageGreen,
                        tabs: const [
                          Tab(text: 'Trophy Room'),
                          Tab(text: 'Journey'),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  _buildTrophyRoom(context, userAsync, achievementsAsync),
                  _buildJourney(
                    context,
                    distributionAsync,
                    historyAsync,
                    allHabitsAsync,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrophyRoom(
    BuildContext context,
    AsyncValue<User?> userAsync,
    AsyncValue<List<AchievementUnlock>> achievementsAsync,
  ) {
    return CustomScrollView(
      slivers: [
        // Achievement badges
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Achievements',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        userAsync.when(
                          data: (user) => achievementsAsync.when(
                            data: (achievements) => IconButton(
                              icon: const Icon(
                                Icons.ios_share_rounded,
                                size: 20,
                              ),
                              color: AppTheme.sageGreen,
                              onPressed: () {
                                if (user == null) return;
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => AchievementSharePreview(
                                      user: user,
                                      achievements: achievements,
                                    ),
                                  ),
                                );
                              },
                            ),
                            loading: () => const SizedBox.shrink(),
                            error: (_, _) => const SizedBox.shrink(),
                          ),
                          loading: () => const SizedBox.shrink(),
                          error: (_, _) => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    achievementsAsync.when(
                      data: (achievements) {
                        if (achievements.isEmpty) {
                          return Text(
                            'Complete a habit to earn your first badge!',
                            style: Theme.of(context).textTheme.bodyMedium,
                          );
                        }
                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: achievements
                              .map(
                                (a) => _AchievementBadge(
                                  title: _achievementLabel(a.achievementId),
                                ),
                              )
                              .toList(),
                        );
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, _) => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  Widget _buildJourney(
    BuildContext context,
    AsyncValue<Map<String, int>> distributionAsync,
    AsyncValue<List<MapEntry<DateTime, int>>> historyAsync,
    AsyncValue<List<Habit>> allHabitsAsync,
  ) {
    return CustomScrollView(
      slivers: [
        // Pie chart — Completion Distribution
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Habit Distribution',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 20),
                    distributionAsync.when(
                      data: (dist) {
                        final completed = dist['completed'] ?? 0;
                        final skipped = dist['skipped'] ?? 0;
                        final overdue = dist['overdue'] ?? 0;
                        final total = dist.values.fold(0, (a, b) => a + b);
                        if (total == 0) {
                          return SizedBox(
                            height: 160,
                            child: Center(
                              child: Text(
                                'No data yet',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          );
                        }
                        return SizedBox(
                          height: 160,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 3,
                              centerSpaceRadius: 36,
                              sections: [
                                PieChartSectionData(
                                  value: completed.toDouble(),
                                  color: AppTheme.completionGreen,
                                  title: '$completed',
                                  titleStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  radius: 40,
                                ),
                                PieChartSectionData(
                                  value: skipped.toDouble(),
                                  color: AppTheme.skipAmber,
                                  title: '$skipped',
                                  titleStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  radius: 40,
                                ),
                                PieChartSectionData(
                                  value: overdue.toDouble(),
                                  color: AppTheme.overdueRose,
                                  title: '$overdue',
                                  titleStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  radius: 40,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      loading: () => const _ChartSkeleton(),
                      error: (_, _) => const _ChartSkeleton(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _Legend(
                          color: AppTheme.completionGreen,
                          label: 'Completed',
                        ),
                        _Legend(color: AppTheme.skipAmber, label: 'Skipped'),
                        _Legend(color: AppTheme.overdueRose, label: 'Overdue'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Line chart — 30-day point velocity
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '30-Day Points Earned',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Per-check-in awards from local history. Lifetime score updates separately from daily sync.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppTheme.warmGray),
                    ),
                    const SizedBox(height: 20),
                    historyAsync.when(
                      data: (history) {
                        if (history.isEmpty) {
                          return SizedBox(
                            height: 160,
                            child: Center(
                              child: Text(
                                'No data yet',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          );
                        }
                        return SizedBox(
                          height: 160,
                          child: LineChart(
                            LineChartData(
                              gridData: const FlGridData(show: false),
                              titlesData: const FlTitlesData(show: false),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: history
                                      .asMap()
                                      .entries
                                      .map(
                                        (e) => FlSpot(
                                          e.key.toDouble(),
                                          e.value.value.toDouble(),
                                        ),
                                      )
                                      .toList(),
                                  isCurved: true,
                                  color: AppTheme.sageGreen,
                                  barWidth: 3,
                                  dotData: const FlDotData(show: false),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: AppTheme.sageGreen.withValues(
                                      alpha: 0.1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      loading: () => const _ChartSkeleton(),
                      error: (_, _) => const _ChartSkeleton(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Calendar Feed Subscription
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calendar Subscription',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add your habits to your native calendar app',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.warmGray.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _CalendarSubscriptionCard(),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Manage Habits
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Manage Habits',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton.icon(
                  onPressed: () => HabitFormSheet.show(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add New'),
                ),
              ],
            ),
          ),
        ),
        allHabitsAsync.when(
          data: (habits) {
            if (habits.isEmpty) {
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            }

            final active = habits
                .where((h) => h.status == HabitStatus.active)
                .toList();
            final abandoned = habits
                .where((h) => h.status == HabitStatus.abandoned)
                .toList();
            final finished = habits
                .where((h) => h.status == HabitStatus.finished)
                .toList();

            return SliverList(
              delegate: SliverChildListDelegate([
                if (active.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 16, 24, 8),
                    child: Text(
                      'Active',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.sageGreen,
                      ),
                    ),
                  ),
                  ...active.map(
                    (h) => _HabitListTile(habit: h, isActive: true),
                  ),
                ],
                if (finished.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
                    child: Text(
                      'Hall of Fame',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.mutedLavender,
                      ),
                    ),
                  ),
                  ...finished.map(
                    (h) => _HabitListTile(habit: h, isActive: false),
                  ),
                ],
                if (abandoned.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
                    child: Text(
                      'Archived history',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.overdueRose,
                      ),
                    ),
                  ),
                  ...abandoned.map(
                    (h) => _HabitListTile(habit: h, isActive: false),
                  ),
                ],
              ]),
            );
          },
          loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
          error: (_, _) => const SliverToBoxAdapter(child: SizedBox.shrink()),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  Widget _buildFriendProfile(BuildContext context, WidgetRef ref) {
    final friendProfileAsync = ref.watch(friendProfileProvider(widget.userId));

    return Scaffold(
      body: SafeArea(
        child: NarrowLayout(
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: AppTheme.deepCharcoal,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Friend Profile',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
              ),
              // Content
              friendProfileAsync.when(
                data: (data) {
                  final user = data.user;
                  final habits = data.habits;

                  return SliverList(
                    delegate: SliverChildListDelegate([
                      // Friend Info Card
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Row(
                              children: [
                                UserAvatar(
                                  avatarUrl: user['avatar_url'] as String?,
                                  username: user['username'] as String?,
                                  radius: 28,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (user['username'] as String?) ??
                                            'Friend',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleLarge,
                                      ),
                                      if ((user['level_name'] as String?) !=
                                          null)
                                        Text(
                                          '${user['level_name']} level',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: AppTheme.warmGray,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                      Text(
                                        '${user['total_score'] ?? 0} lifetime pts',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: AppTheme.sageGreen,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.fromLTRB(24, 32, 24, 8),
                        child: Text(
                          'Active Habits',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.sageGreen,
                          ),
                        ),
                      ),

                      if (habits.isEmpty)
                        const Padding(
                          padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
                          child: Text('No active habits.'),
                        )
                      else
                        ...habits.map(
                          (h) => _FriendHabitListTile(
                            habitData: h,
                            friendUserId: widget.userId,
                          ),
                        ),
                    ]),
                  );
                },
                loading: () => const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 16, 20, 24),
                    child: Column(
                      children: [
                        HableSkeletonCard(height: 86),
                        HableSkeletonCard(height: 96),
                        HableSkeletonCard(height: 96),
                      ],
                    ),
                  ),
                ),
                error: (err, _) => const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 32.0),
                    child: Text(
                      'Failed to load friend profile.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsScreen extends ConsumerWidget {
  final String userId;

  const SettingsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return UsageTrackedScreen(
      screenName: 'settings',
      child: Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              userAsync.when(
                data: (user) => _SettingsAccountCard(user: user),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 12),
              userAsync.when(
                data: (user) => _CloudSyncActivationCard(user: user),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 12),
              _DailyReminderCard(userId: userId),
              const SizedBox(height: 12),
              const _MudTuningCard(),
              const SizedBox(height: 12),
              const Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: AccessibilitySelector(compact: false),
                ),
              ),
              const SizedBox(height: 12),
              const Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: LanguageSelector(compact: false),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Session',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign out of this device. Local reminder scheduling is canceled for this user.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final shouldReset = await showDialog<bool>(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: const Text('Recover This Device'),
                              content: const Text(
                                'This clears local Hable data on this device and sends you back to login. Use it if the app is stuck or showing old cached state.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(true),
                                  child: const Text('Clear and Sign In Again'),
                                ),
                              ],
                            ),
                          );
                          if (shouldReset != true || !context.mounted) return;
                          await performManualRecoveryReset(
                            database: ref.read(databaseProvider),
                            authNotifier: ref.read(authProvider.notifier),
                          );
                          if (!context.mounted) return;
                          Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst);
                        },
                        icon: const Icon(Icons.system_update_alt_rounded),
                        label: const Text('Update / Recover App'),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () async {
                          await ref.read(authProvider.notifier).logout();
                          if (!context.mounted) return;
                          Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst);
                        },
                        icon: const Icon(Icons.logout_rounded),
                        label: const Text('Sign out'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.deepCharcoal,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChartSkeleton extends StatelessWidget {
  const _ChartSkeleton();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 160,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HableSkeletonBlock(width: 180, height: 14),
          SizedBox(height: 14),
          HableSkeletonBlock(width: double.infinity, height: 18),
          SizedBox(height: 10),
          HableSkeletonBlock(width: 260, height: 18),
          SizedBox(height: 10),
          HableSkeletonBlock(width: 210, height: 18),
        ],
      ),
    );
  }
}

class _SettingsAccountCard extends StatelessWidget {
  final User? user;

  const _SettingsAccountCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                UserAvatar(
                  avatarUrl: user?.avatarUrl,
                  username: user?.username,
                  radius: 28,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.username ?? 'User',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        user?.email ?? 'No verified email yet',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => const AvatarPickerSheet(),
                );
              },
              icon: const Icon(Icons.face_retouching_natural_rounded),
              label: const Text('Customize avatar'),
            ),
          ],
        ),
      ),
    );
  }
}


class _MudTuningCard extends ConsumerWidget {
  const _MudTuningCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tuning = ref.watch(mudTuningProvider);
    final actions = ref.read(mudTuningProvider.notifier);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mud feel', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Tune hold resistance and haptic feedback on this device with bounded presets.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            SegmentedButton<MudTuningPreset>(
              segments: const [
                ButtonSegment(
                  value: MudTuningPreset.gentle,
                  label: Text('Gentle'),
                ),
                ButtonSegment(
                  value: MudTuningPreset.standard,
                  label: Text('Standard'),
                ),
                ButtonSegment(
                  value: MudTuningPreset.intense,
                  label: Text('Intense'),
                ),
              ],
              selected: {tuning.preset},
              onSelectionChanged: (selection) {
                actions.updatePreset(selection.first);
              },
            ),
            const SizedBox(height: 12),
            SwitchListTile.adaptive(
              value: tuning.hapticsEnabled,
              contentPadding: EdgeInsets.zero,
              title: const Text('Mud haptics'),
              subtitle: Text(switch (tuning.hapticProfile) {
                MudHapticProfile.soft =>
                  'Soft taps during hold and a light completion pulse.',
                MudHapticProfile.standard =>
                  'Balanced hold taps and standard completion feedback.',
                MudHapticProfile.strong =>
                  'Heavier completion feedback with denser hold taps.',
              }),
              onChanged: actions.setHapticsEnabled,
            ),
          ],
        ),
      ),
    );
  }
}

class _CloudSyncActivationCard extends ConsumerStatefulWidget {
  final User? user;

  const _CloudSyncActivationCard({required this.user});

  @override
  ConsumerState<_CloudSyncActivationCard> createState() =>
      _CloudSyncActivationCardState();
}

class _CloudSyncActivationCardState
    extends ConsumerState<_CloudSyncActivationCard> {
  late final TextEditingController _emailController;
  final _pinController = TextEditingController();
  bool _pinSent = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.user?.email ?? '');
  }

  @override
  void didUpdateWidget(covariant _CloudSyncActivationCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newEmail = widget.user?.email ?? '';
    if (!_pinSent && _emailController.text.isEmpty && newEmail.isNotEmpty) {
      _emailController.text = newEmail;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _requestPin() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    final success = await ref
        .read(authProvider.notifier)
        .requestProfileActivationPin(email);
    if (!mounted) return;
    if (success) {
      setState(() => _pinSent = true);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Verification PIN sent.')));
    }
  }

  Future<void> _verifyPin() async {
    final email = _emailController.text.trim();
    final pin = _pinController.text.trim();
    if (email.isEmpty || pin.isEmpty) return;

    final success = await ref
        .read(authProvider.notifier)
        .verifyProfileActivationPin(email, pin);
    if (!mounted) return;
    if (success) {
      setState(() {
        _pinSent = false;
        _pinController.clear();
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cloud sync activated.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = widget.user;
    final isVerified = user?.emailVerifiedAt != null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isVerified
                      ? Icons.cloud_done_rounded
                      : Icons.cloud_sync_rounded,
                  color: isVerified
                      ? AppTheme.completionGreen
                      : AppTheme.sageGreen,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isVerified ? 'Cloud sync active' : 'Activate cloud sync',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isVerified
                  ? 'Progress recovery is linked to ${user?.email ?? 'your verified email'}.'
                  : 'Add a verified email when you want recoverable cloud progress and password reset support.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.warmGray.withValues(alpha: 0.9),
              ),
            ),
            if (!isVerified) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: _pinSent
                    ? TextInputAction.next
                    : TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                onSubmitted: (_) {
                  if (!_pinSent) _requestPin();
                },
              ),
              if (_pinSent) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: '6-digit PIN',
                    prefixIcon: Icon(Icons.pin_outlined),
                  ),
                  onSubmitted: (_) => _verifyPin(),
                ),
              ],
              if (authState.error != null) ...[
                const SizedBox(height: 12),
                Text(
                  authState.error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: authState.isLoading
                          ? null
                          : (_pinSent ? _verifyPin : _requestPin),
                      icon: authState.isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(
                              _pinSent
                                  ? Icons.verified_rounded
                                  : Icons.mark_email_read_rounded,
                            ),
                      label: Text(_pinSent ? 'Verify PIN' : 'Send PIN'),
                    ),
                  ),
                  if (_pinSent) ...[
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: authState.isLoading
                          ? null
                          : () => setState(() {
                              _pinSent = false;
                              _pinController.clear();
                            }),
                      child: const Text('Change email'),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DailyReminderCard extends ConsumerWidget {
  final String userId;

  const _DailyReminderCard({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminderAsync = ref.watch(reminderSettingsForUserProvider(userId));
    final actions = ref.read(notificationActionsProvider);

    return reminderAsync.when(
      data: (settings) {
        final hasDenied = settings.any((s) => s.isPermissionDenied);

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.alarm_rounded,
                      color: AppTheme.deepCharcoal,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Daily reminders',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  settings.isEmpty
                      ? 'Enable daily reminders to return to your habits.'
                      : 'Hable will remind you each day at these times.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.warmGray.withValues(alpha: 0.9),
                  ),
                ),
                if (hasDenied)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          ref.read(localReminderServiceProvider).openSettings(),
                      icon: const Icon(Icons.settings),
                      label: const Text('Enable in System Settings'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                if (settings.isNotEmpty) ...[
                  for (final setting in settings)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final initial = TimeOfDay(
                                  hour: setting.hour,
                                  minute: setting.minute,
                                );
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: initial,
                                );
                                if (picked == null || !context.mounted) return;
                                await actions.updateDailyReminder(
                                  setting: setting,
                                  enabled: setting.isEnabled,
                                  hour: picked.hour,
                                  minute: picked.minute,
                                );
                              },
                              icon: const Icon(Icons.schedule_rounded),
                              label: Text(
                                _formatReminderTime(
                                  setting.hour,
                                  setting.minute,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Switch(
                            value: setting.isEnabled,
                            onChanged: (value) async {
                              await actions.updateDailyReminder(
                                setting: setting,
                                enabled: value,
                                hour: setting.hour,
                                minute: setting.minute,
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () async {
                              await actions.removeDailyReminder(setting);
                            },
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 8),
                ],
                FilledButton.icon(
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 20, minute: 0),
                    );
                    if (picked == null || !context.mounted) return;
                    await actions.addDailyReminder(
                      userId: userId,
                      hour: picked.hour,
                      minute: picked.minute,
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Time'),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Text(
        AppError.fromAny(
          e,
          fallbackCode: 'profile_reminders_load_failed',
          fallbackMessage: 'Hable could not load your reminders right now.',
          fallbackKind: AppErrorKind.inline,
        ).message,
      ),
    );
  }

  String _formatReminderTime(int hour, int minute) {
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    final minuteText = minute.toString().padLeft(2, '0');
    return '$hour12:$minuteText $period';
  }
}

class _FriendHabitListTile extends ConsumerWidget {
  final dynamic habitData;
  final String friendUserId;

  const _FriendHabitListTile({
    required this.habitData,
    required this.friendUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = habitData['title'] as String? ?? 'Habit';
    final description = habitData['description'] as String?;
    final habitId = habitData['id']?.toString();
    final duration = habitData['target_duration'] as int? ?? 10;
    final habitColor = _tileColor(habitData['color_hex'] as String?);
    final habitMeta = standardHabitForTitle(title);
    final viewerUserId = ref.watch(authProvider).userId;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: HabitCardShell(
        semanticsLabel:
            '$title.${description == null || description.trim().isEmpty ? '' : ' ${description.trim()}.'} $duration day challenge on friend profile. Encourage or follow this habit.',
        title: title,
        subtitle: description,
        minHeight: 220,
        centerPadding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
        topTrailing: _ProfileHabitPill(
          label: '$duration days',
          color: habitColor,
        ),
        centerChild: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: habitColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                habitMeta?.emoji ?? '•',
                style: TextStyle(
                  fontSize: 26,
                  color: habitMeta == null ? habitColor : null,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '$duration day challenge',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              'Encourage your friend or follow the same habit yourself.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.warmGray),
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton.icon(
                  onPressed: viewerUserId == null
                      ? null
                      : () async {
                          final db = ref.read(databaseProvider);
                          await enqueueNudge(
                            db: db,
                            senderUserId: viewerUserId,
                            targetUserId: friendUserId,
                            habitId: habitId,
                          );
                          unawaited(
                            ref.read(syncServiceProvider).flushPending(),
                          );
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Encouragement queued for $title.'),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: habitColor.withValues(
                                alpha: 0.9,
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                  icon: const Icon(Icons.back_hand_rounded, size: 16),
                  label: const Text('Encourage'),
                  style: FilledButton.styleFrom(backgroundColor: habitColor),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    HabitFormSheet.show(context, prefilledTitle: title);
                  },
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  label: const Text('Follow'),
                  style: OutlinedButton.styleFrom(foregroundColor: habitColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _achievementLabel(String achievementId) {
  switch (achievementId) {
    case 'first_check_in':
      return 'First check-in';
    case '10_streak':
      return '10-day streak';
    case '100_streak':
      return '100-day streak';
    case '1000_streak':
      return '1000-day streak';
    case 'first_nudge':
      return 'First nudge';
    case 'first_supporter':
      return 'First supporter';
    default:
      return achievementId
          .split('_')
          .where((part) => part.isNotEmpty)
          .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
          .join(' ');
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;

  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final String title;

  const _AchievementBadge({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.completionGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.completionGreen.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.emoji_events_rounded,
            size: 16,
            color: AppTheme.completionGreen,
          ),
          const SizedBox(width: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.completionGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class _HabitListTile extends ConsumerWidget {
  final Habit habit;
  final bool isActive;

  const _HabitListTile({required this.habit, required this.isActive});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partnersAsync = ref.watch(habitPartnersProvider(habit.habitId));
    final role = partnersAsync.when(
      data: _viewerRoleForPartners,
      loading: () => PartnershipRole.owner,
      error: (_, _) => PartnershipRole.owner,
    );
    final hasPartners = partnersAsync.when(
      data: (partners) => partners.isNotEmpty,
      loading: () => false,
      error: (_, _) => false,
    );
    final canEdit = role == PartnershipRole.owner;
    final habitMeta = standardHabitForTitle(habit.title);
    final habitColor = _tileColor(habit.colorHex);
    final description = habit.description;

    if (isActive) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: HabitCardShell(
          semanticsLabel:
              '${habit.title}.${description == null || description.trim().isEmpty ? '' : ' ${description.trim()}.'} ${habit.currentDuration} days left. ${_roleLabel(role)} habit on profile.',
          title: habit.title,
          subtitle: description,
          minHeight: 236,
          titleRightInset: canEdit ? 56 : 16,
          centerPadding: const EdgeInsets.fromLTRB(20, 56, 20, 56),
          topTrailing: canEdit
              ? _buildActionsMenu(
                  context: context,
                  ref: ref,
                  canEdit: canEdit,
                  hasPartners: hasPartners,
                )
              : null,
          centerChild: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: habitColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  habitMeta?.emoji ?? '•',
                  style: TextStyle(
                    fontSize: 26,
                    color: habitMeta == null ? habitColor : null,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${habit.currentDuration} days left',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                _roleLabel(role),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.warmGray),
              ),
              if (hasPartners) ...[
                const SizedBox(height: 14),
                partnersAsync.when(
                  data: (partners) => HabitPartnerRow(
                    partners: partners,
                    habitColor: habitColor,
                    compactMode: true,
                    maxVisible: 3,
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
              ],
            ],
          ),
          bottomChild: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: habitColor.withValues(alpha: 0.08),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ProfileHabitPill(
                  label: hasPartners ? 'Shared habit' : 'Solo habit',
                  color: habitColor,
                ),
                Text(
                  'Active',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: habitColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: AppTheme.surfaceVariant,
        child: Text(
          habitMeta?.emoji ?? '•',
          style: TextStyle(
            color: habitMeta == null ? AppTheme.sageGreen : null,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      title: Text(
        habit.title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isActive
                ? '${habit.currentDuration} days left · ${role.name}'
                : '${habit.targetDuration} day challenge · ${role.name}',
          ),
          const SizedBox(height: 6),
          partnersAsync.when(
            data: (partners) => HabitPartnerRow(
              partners: partners,
              habitColor: _tileColor(habit.colorHex),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
        ],
      ),
      trailing: canEdit
          ? PopupMenuButton<String>(
              tooltip: 'Open habit actions',
              icon: const Icon(Icons.more_horiz_rounded),
              onSelected: (value) async {
                final actions = ref.read(habitActionsProvider);
                switch (value) {
                  case 'edit':
                    HabitFormSheet.show(context, existingHabit: habit);
                    break;
                  case 'archive':
                    await actions.archiveHabit(habit.habitId);
                    break;
                  case 'restore':
                    await actions.restoreHabit(habit.habitId);
                    break;
                  case 'delete':
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text('Delete habit?'),
                        content: Text(
                          'This will permanently delete "${habit.title}" and remove it from synced devices.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      await actions.deleteHabit(habit.habitId);
                    }
                    break;
                  case 'rerun':
                    await actions.rerunHabit(habit.habitId);
                    break;
                  case 'history':
                    await showModalBottomSheet<void>(
                      context: context,
                      builder: (_) => _HabitHistorySheet(habit: habit),
                    );
                    break;
                }
              },
              itemBuilder: (context) => isActive
                  ? [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem(
                        value: 'archive',
                        child: Text('Archive'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          'Delete',
                          style: TextStyle(color: AppTheme.overdueRose),
                        ),
                      ),
                    ]
                  : [
                      const PopupMenuItem(
                        value: 'history',
                        child: Text('View History'),
                      ),
                      if (!hasPartners)
                        const PopupMenuItem(
                          value: 'rerun',
                          child: Text('Rerun'),
                        ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          'Delete',
                          style: TextStyle(color: AppTheme.overdueRose),
                        ),
                      ),
                    ],
            )
          : null,
      isThreeLine: true,
    );
  }

  PopupMenuButton<String> _buildActionsMenu({
    required BuildContext context,
    required WidgetRef ref,
    required bool canEdit,
    required bool hasPartners,
  }) {
    return PopupMenuButton<String>(
      tooltip: 'Open habit actions',
      icon: const Icon(Icons.more_horiz_rounded),
      onSelected: (value) async {
        final actions = ref.read(habitActionsProvider);
        switch (value) {
          case 'edit':
            HabitFormSheet.show(context, existingHabit: habit);
            break;
          case 'archive':
            await actions.archiveHabit(habit.habitId);
            break;
          case 'restore':
            await actions.restoreHabit(habit.habitId);
            break;
          case 'delete':
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: const Text('Delete habit?'),
                content: Text(
                  'This will permanently delete "${habit.title}" and remove it from synced devices.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
            if (confirmed == true) {
              await actions.deleteHabit(habit.habitId);
            }
            break;
          case 'rerun':
            await actions.rerunHabit(habit.habitId);
            break;
          case 'history':
            await showModalBottomSheet<void>(
              context: context,
              builder: (_) => _HabitHistorySheet(habit: habit),
            );
            break;
        }
      },
      itemBuilder: (context) => isActive
          ? [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(value: 'archive', child: Text('Archive')),
              const PopupMenuItem(
                value: 'delete',
                child: Text(
                  'Delete',
                  style: TextStyle(color: AppTheme.overdueRose),
                ),
              ),
            ]
          : [
              const PopupMenuItem(
                value: 'history',
                child: Text('View History'),
              ),
              if (!hasPartners)
                const PopupMenuItem(value: 'rerun', child: Text('Rerun')),
              const PopupMenuItem(
                value: 'delete',
                child: Text(
                  'Delete',
                  style: TextStyle(color: AppTheme.overdueRose),
                ),
              ),
            ],
    );
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

  Color _tileColor(String hex) {
    try {
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return AppTheme.sageGreen;
    }
  }
}

class _ProfileHabitPill extends StatelessWidget {
  final String label;
  final Color color;

  const _ProfileHabitPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

String _roleLabel(PartnershipRole role) {
  switch (role) {
    case PartnershipRole.owner:
      return 'Owner view';
    case PartnershipRole.partner:
      return 'Partner view';
    case PartnershipRole.supporter:
      return 'Supporter view';
  }
}

Color _tileColor(String? hex) {
  if (hex == null || hex.isEmpty) {
    return AppTheme.sageGreen;
  }
  try {
    return Color(int.parse(hex, radix: 16));
  } catch (_) {
    return AppTheme.sageGreen;
  }
}

class _HabitHistorySheet extends ConsumerWidget {
  final Habit habit;

  const _HabitHistorySheet({required this.habit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(habitLogsProvider(habit.habitId));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(habit.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              'Archived challenge history and per-check-in awards',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.warmGray),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: logsAsync.when(
                data: (logs) {
                  if (logs.isEmpty) {
                    return const Text('No history recorded yet.');
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: logs.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(_historyLabel(log)),
                        subtitle: Text(_formatHistoryDate(log.actionDate)),
                        trailing: log.pointsAwarded > 0
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.sageGreen.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  '+${log.pointsAwarded} pts',
                                  style: Theme.of(context).textTheme.labelMedium
                                      ?.copyWith(
                                        color: AppTheme.sageGreen,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                              )
                            : null,
                        dense: true,
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) => const Text('Unable to load habit history.'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _historyLabel(Log log) {
    if (log.status == LogStatus.completed) {
      return 'Completed';
    }
    final note = log.journalNote?.trim();
    return note?.isNotEmpty == true ? 'Skipped: $note' : 'Skipped';
  }

  String _formatHistoryDate(DateTime date) {
    const months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final month = months[date.month - 1];
    final day = date.day.toString().padLeft(2, '0');
    return '$month $day, ${date.year}';
  }
}

class _InfoPill extends StatelessWidget {
  final String label;
  final Color color;
  final Color? fillColor;

  const _InfoPill({required this.label, required this.color, this.fillColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: fillColor ?? color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CalendarSubscriptionCard extends ConsumerWidget {
  const _CalendarSubscriptionCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarState = ref.watch(calendarFeedProvider);

    // Load feed URL on first build
    ref.listen(calendarFeedProvider, (prev, next) {
      if (prev?.feedUrl != next.feedUrl &&
          next.feedUrl == null &&
          !next.isLoading) {
        // Trigger initial load if not already loaded
        Future.microtask(() {
          ref.read(calendarFeedProvider.notifier).fetchCalendarFeedUrl();
        });
      }
    });

    if (calendarState.isLoading && calendarState.feedUrl == null) {
      return const SizedBox(
        height: 60,
        child: Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.sageGreen),
            ),
          ),
        ),
      );
    }

    if (calendarState.error != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            calendarState.error ?? 'Unknown error',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.overdueRose),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {
              ref.read(calendarFeedProvider.notifier).fetchCalendarFeedUrl();
            },
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Retry'),
          ),
        ],
      );
    }

    if (calendarState.feedUrl == null) {
      return FilledButton.icon(
        onPressed: () {
          ref.read(calendarFeedProvider.notifier).fetchCalendarFeedUrl();
        },
        icon: const Icon(Icons.link, size: 18),
        label: const Text('Generate Subscription Link'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.warmGray.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Subscription URL',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.warmGray.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      calendarState.feedUrl!.replaceAll(
                        RegExp(r'^https?://'),
                        '',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.copy_outlined, size: 20),
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: calendarState.feedUrl!),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Calendar feed URL copied to clipboard'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                tooltip: 'Copy subscription URL',
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text(
                'Paste this URL into your native calendar app to subscribe',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.warmGray.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: calendarState.isLoading
              ? null
              : () {
                  ref.read(calendarFeedProvider.notifier).rotateCalendarToken();
                },
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Rotate Token'),
        ),
        const SizedBox(height: 8),
        Text(
          'Rotating the token will invalidate the old subscription link',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.warmGray.withValues(alpha: 0.6),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: AppTheme.surface, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
