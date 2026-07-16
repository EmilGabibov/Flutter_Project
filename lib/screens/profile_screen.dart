import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';
import '../database/tables.dart' show HabitStatus, LogStatus, PartnershipRole;
import '../models/history_display.dart';
import '../data/standard_habits.dart';
import '../l10n/app_localizations.dart';
import '../providers/habit_providers.dart';
import '../providers/sync_provider.dart';
import '../services/app_error.dart';
import '../services/local_reminder_service.dart';
import '../services/web_push_client.dart';
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
    final l10n = AppLocalizations.of(context)!;
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
                              tooltip: l10n.profileBack,
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(
                                Icons.arrow_back_rounded,
                                color: AppTheme.deepCharcoal,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            l10n.profileTitle,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const Spacer(),
                          IconButton(
                            tooltip: l10n.profileOpenSettings,
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
                                        user?.username ??
                                            l10n.profileUserFallback,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleLarge,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '@${user?.username ?? l10n.profileUsernameFallback}',
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
                                            label:
                                                user?.levelName ??
                                                l10n.profileLevelFallback,
                                            color: AppTheme.sageGreen,
                                          ),
                                          _InfoPill(
                                            label: l10n.profileLifetimePoints(
                                              user?.totalScore ?? 0,
                                            ),
                                            color: AppTheme.deepCharcoal,
                                            fillColor: AppTheme.surfaceVariant,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        l10n.profileLifetimeScoreHint,
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
                        tabs: [
                          Tab(text: l10n.profileTrophyRoomTab),
                          Tab(text: l10n.profileJourneyTab),
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
    final l10n = AppLocalizations.of(context)!;
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
                          l10n.profileAchievementsTitle,
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
                            l10n.profileFirstBadgeHint,
                            style: Theme.of(context).textTheme.bodyMedium,
                          );
                        }
                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: achievements
                              .map(
                                (a) => _AchievementBadge(
                                  title: _achievementLabel(
                                    l10n,
                                    a.achievementId,
                                  ),
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
    final l10n = AppLocalizations.of(context)!;
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
                      l10n.profileHabitDistributionTitle,
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
                                l10n.profileNoData,
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
                          label: l10n.profileCompletedLegend,
                        ),
                        _Legend(
                          color: AppTheme.skipAmber,
                          label: l10n.profileSkippedLegend,
                        ),
                        _Legend(
                          color: AppTheme.overdueRose,
                          label: l10n.profileOverdueLegend,
                        ),
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
                      l10n.profileThirtyDayPointsTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.profileThirtyDayPointsHint,
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
                                l10n.profileNoData,
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
                      l10n.profileCalendarSubscriptionTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.profileCalendarSubscriptionBody,
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
                  l10n.profileManageHabitsTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton.icon(
                  onPressed: () => HabitFormSheet.show(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(l10n.profileAddNew),
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(24, 16, 24, 8),
                    child: Text(
                      l10n.profileSectionActive,
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
                    child: Text(
                      l10n.profileSectionHallOfFame,
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
                    child: Text(
                      l10n.profileSectionArchivedHistory,
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
    final l10n = AppLocalizations.of(context)!;
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
                        l10n.profileFriendProfileTitle,
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
                  final achievements = data.achievements;

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
                                            l10n.homeFriendFallback,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleLarge,
                                      ),
                                      if ((user['level_name'] as String?) !=
                                          null)
                                        Text(
                                          l10n.profileFriendLevel(
                                            user['level_name'] as String,
                                          ),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: AppTheme.warmGray,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                      Text(
                                        l10n.profileLifetimePoints(
                                          (user['total_score'] as num?)
                                                  ?.toInt() ??
                                              0,
                                        ),
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

                      Padding(
                        padding: EdgeInsets.fromLTRB(24, 32, 24, 8),
                        child: Text(
                          l10n.profileActiveHabitsTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.sageGreen,
                          ),
                        ),
                      ),

                      if (habits.isEmpty)
                        Padding(
                          padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
                          child: Text(l10n.profileNoActiveHabits),
                        )
                      else
                        ...habits.map(
                          (h) => _FriendHabitListTile(
                            habitData: h,
                            friendUserId: widget.userId,
                          ),
                        ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                        child: Text(
                          l10n.profileAchievementsTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.sageGreen,
                          ),
                        ),
                      ),
                      if (achievements.isEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                          child: Text(
                            l10n.profileFirstBadgeHint,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppTheme.warmGray),
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: achievements.map<Widget>((
                              rawAchievement,
                            ) {
                              final achievement = Map<String, dynamic>.from(
                                rawAchievement as Map? ?? const {},
                              );
                              final achievementId =
                                  achievement['achievement_id']?.toString() ??
                                  '';
                              final unlockedAt = achievement['unlocked_at']
                                  ?.toString();
                              final chip = Chip(
                                avatar: const Icon(
                                  Icons.workspace_premium_rounded,
                                  size: 18,
                                  color: AppTheme.sageGreen,
                                ),
                                label: Text(
                                  achievementId.isEmpty
                                      ? l10n.dashboardAchievementUnlocked
                                      : _achievementLabel(l10n, achievementId),
                                ),
                                backgroundColor: AppTheme.surfaceVariant,
                                side: BorderSide(
                                  color: AppTheme.sageGreen.withValues(
                                    alpha: 0.18,
                                  ),
                                ),
                              );
                              if (unlockedAt == null || unlockedAt.isEmpty) {
                                return chip;
                              }
                              return Tooltip(message: unlockedAt, child: chip);
                            }).toList(),
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
                error: (err, _) => SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Text(
                      l10n.profileFriendLoadFailed,
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
    final l10n = AppLocalizations.of(context)!;
    final userAsync = ref.watch(currentUserProvider);

    return UsageTrackedScreen(
      screenName: 'settings',
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.settingsTitle)),
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
                        l10n.settingsSessionTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.settingsSessionBody,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final shouldReset = await showDialog<bool>(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: Text(l10n.settingsRecoverTitle),
                              content: Text(l10n.settingsRecoverBody),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(false),
                                  child: Text(l10n.settingsCancel),
                                ),
                                FilledButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(true),
                                  child: Text(l10n.settingsClearAndSignInAgain),
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
                        label: Text(l10n.settingsRecoverAction),
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
                        label: Text(l10n.settingsSignOut),
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
    final loc = AppLocalizations.of(context)!;
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
                        user?.username ?? loc.profileUserFallback,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        user?.email ?? loc.settingsNoVerifiedEmailYet,
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
              label: Text(loc.settingsCustomizeAvatar),
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
    final loc = AppLocalizations.of(context)!;
    final tuning = ref.watch(mudTuningProvider);
    final actions = ref.read(mudTuningProvider.notifier);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.settingsMudFeelTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              loc.settingsMudFeelBody,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            SegmentedButton<MudTuningPreset>(
              segments: [
                ButtonSegment(
                  value: MudTuningPreset.gentle,
                  label: Text(loc.settingsMudPresetGentle),
                ),
                ButtonSegment(
                  value: MudTuningPreset.standard,
                  label: Text(loc.settingsMudPresetStandard),
                ),
                ButtonSegment(
                  value: MudTuningPreset.intense,
                  label: Text(loc.settingsMudPresetIntense),
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
              title: Text(loc.settingsMudHapticsTitle),
              subtitle: Text(switch (tuning.hapticProfile) {
                MudHapticProfile.soft => loc.settingsMudHapticsSoft,
                MudHapticProfile.standard => loc.settingsMudHapticsStandard,
                MudHapticProfile.strong => loc.settingsMudHapticsStrong,
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
    final loc = AppLocalizations.of(context)!;
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
      ).showSnackBar(SnackBar(content: Text(loc.settingsVerificationPinSent)));
    }
  }

  Future<void> _verifyPin() async {
    final loc = AppLocalizations.of(context)!;
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
      ).showSnackBar(SnackBar(content: Text(loc.settingsCloudSyncActivated)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
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
                    isVerified
                        ? loc.settingsCloudSyncActiveTitle
                        : loc.settingsActivateCloudSyncTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isVerified
                  ? loc.settingsCloudSyncLinkedToEmail(
                      user?.email ?? loc.settingsNoVerifiedEmailYet,
                    )
                  : loc.settingsCloudSyncInactiveBody,
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
                decoration: InputDecoration(
                  labelText: loc.authEmailLabel,
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
                  decoration: InputDecoration(
                    labelText: loc.authPinLabel,
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
                      label: Text(
                        _pinSent ? loc.authVerifyTitle : loc.authSendPinButton,
                      ),
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
                      child: Text(loc.settingsChangeEmail),
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
    final l10n = AppLocalizations.of(context)!;
    final reminderAsync = ref.watch(reminderSettingsForUserProvider(userId));
    final actions = ref.read(notificationActionsProvider);
    final reminderService = ref.read(localReminderServiceProvider);
    final supportsScheduling = reminderService.supportsScheduling;

    return reminderAsync.when(
      data: (settings) {
        final hasDenied = settings.any((s) => s.isPermissionDenied);
        final hasSettings = settings.isNotEmpty;
        final hasEnabledSetting = settings.any((s) => s.isEnabled);
        final bodyText = hasSettings
            ? l10n.settingsDailyRemindersEnabled
            : l10n.settingsDailyRemindersEmpty;

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
                        l10n.settingsDailyRemindersTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    if (hasSettings)
                      _StatusPill(
                        label: hasEnabledSetting
                            ? l10n.settingsStatusOn
                            : l10n.settingsStatusOff,
                        color: hasEnabledSetting
                            ? AppTheme.completionGreen
                            : AppTheme.warmGray,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  bodyText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.warmGray.withValues(alpha: 0.9),
                  ),
                ),
                if (kIsWeb) const _WebPushReminderOptIn(),
                if (!supportsScheduling) ...[
                  const SizedBox(height: 12),
                  _ReminderNotice(
                    icon: Icons.phone_iphone_rounded,
                    text: l10n.settingsReminderUnsupported,
                  ),
                ],
                if (hasDenied)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          ref.read(localReminderServiceProvider).openSettings(),
                      icon: const Icon(Icons.settings),
                      label: Text(l10n.settingsEnableInSystemSettings),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                if (hasSettings) ...[
                  for (final setting in settings)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                              .withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outlineVariant
                                .withValues(alpha: 0.65),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: supportsScheduling
                                      ? () async {
                                          final initial = TimeOfDay(
                                            hour: setting.hour,
                                            minute: setting.minute,
                                          );
                                          final picked = await showTimePicker(
                                            context: context,
                                            initialTime: initial,
                                          );
                                          if (picked == null ||
                                              !context.mounted) {
                                            return;
                                          }
                                          await actions.updateDailyReminder(
                                            setting: setting,
                                            enabled: setting.isEnabled,
                                            hour: picked.hour,
                                            minute: picked.minute,
                                          );
                                        }
                                      : null,
                                  icon: const Icon(Icons.schedule_rounded),
                                  label: Text(
                                    _formatReminderTime(
                                      context,
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
                              Switch.adaptive(
                                value: setting.isEnabled,
                                onChanged: supportsScheduling
                                    ? (value) async {
                                        await actions.updateDailyReminder(
                                          setting: setting,
                                          enabled: value,
                                          hour: setting.hour,
                                          minute: setting.minute,
                                        );
                                      }
                                    : null,
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                tooltip: l10n.settingsRemoveReminderTooltip,
                                onPressed: supportsScheduling
                                    ? () async {
                                        await actions.removeDailyReminder(
                                          setting,
                                        );
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                ],
                FilledButton.icon(
                  onPressed: supportsScheduling
                      ? () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: const TimeOfDay(hour: 20, minute: 0),
                          );
                          if (picked == null || !context.mounted) return;
                          final result = await actions.addDailyReminder(
                            userId: userId,
                            hour: picked.hour,
                            minute: picked.minute,
                          );
                          if (!context.mounted) return;
                          if (result == ReminderUpdateResult.denied) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.settingsRemindersBlocked),
                              ),
                            );
                          } else if (result ==
                              ReminderUpdateResult.unsupported) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.settingsReminderUnsupported),
                              ),
                            );
                          }
                        }
                      : null,
                  icon: const Icon(Icons.add),
                  label: Text(
                    hasSettings
                        ? l10n.settingsAddTime
                        : l10n.settingsEnableDailyReminder,
                  ),
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
          fallbackMessage: l10n.settingsRemindersLoadFailed,
          fallbackKind: AppErrorKind.inline,
        ).message,
      ),
    );
  }

  String _formatReminderTime(BuildContext context, int hour, int minute) {
    final localizations = MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(TimeOfDay(hour: hour, minute: minute));
  }
}

class _WebPushReminderOptIn extends ConsumerStatefulWidget {
  const _WebPushReminderOptIn();

  @override
  ConsumerState<_WebPushReminderOptIn> createState() =>
      _WebPushReminderOptInState();
}

class _WebPushReminderOptInState extends ConsumerState<_WebPushReminderOptIn> {
  bool _busy = false;
  bool _enabled = false;

  Future<void> _enable() async {
    final token = ref.read(authProvider).token;
    if (token == null || _busy) return;
    setState(() => _busy = true);
    final enabled = await WebPushClient().subscribe(token: token);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _enabled = enabled;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          enabled
              ? AppLocalizations.of(context)!.webPushEnabled
              : AppLocalizations.of(context)!.webPushUnavailable,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: OutlinedButton.icon(
        onPressed: _enabled ? null : _enable,
        icon: Icon(_enabled ? Icons.notifications_active : Icons.notifications),
        label: Text(
          _busy
              ? AppLocalizations.of(context)!.webPushEnabling
              : _enabled
              ? AppLocalizations.of(context)!.webPushEnabled
              : AppLocalizations.of(context)!.webPushEnable,
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _ReminderNotice extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ReminderNotice({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppTheme.warmGray),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppTheme.warmGray),
            ),
          ),
        ],
      ),
    );
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
    final loc = AppLocalizations.of(context)!;
    final title =
        habitData['title'] as String? ?? loc.profileHabitFallbackTitle;
    final description = habitData['description'] as String?;
    final habitId = habitData['id']?.toString();
    final duration = habitData['target_duration'] as int? ?? 10;
    final currentDuration =
        (habitData['current_duration'] as num?)?.toInt() ?? 0;
    final role = _partnershipRoleFromWire(habitData['role']?.toString());
    final habitColor = _tileColor(habitData['color_hex'] as String?);
    final habitMeta = standardHabitForTitle(title);
    final viewerUserId = ref.watch(authProvider).userId;
    final progressLabel = currentDuration > 0
        ? loc.habitDayProgress(currentDuration.clamp(1, duration), duration)
        : loc.profileDayChallenge(duration);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: HabitCardShell(
        semanticsLabel:
            '$title.${description == null || description.trim().isEmpty ? '' : ' ${description.trim()}.'} $progressLabel. ${_roleLabel(loc, role)}. ${loc.profileFriendHabitBody}',
        title: title,
        subtitle: description,
        minHeight: 220,
        centerPadding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
        topTrailing: _ProfileHabitPill(
          label: loc.profileDaysLabel(duration),
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
            Text(progressLabel, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              _roleLabel(loc, role),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.warmGray),
            ),
            const SizedBox(height: 6),
            Text(
              loc.profileFriendHabitBody,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppTheme.warmGray),
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
                              content: Text(
                                loc.profileEncouragementQueued(title),
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: habitColor.withValues(
                                alpha: 0.9,
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                  icon: const Icon(Icons.back_hand_rounded, size: 16),
                  label: Text(loc.profileEncourage),
                  style: FilledButton.styleFrom(backgroundColor: habitColor),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    HabitFormSheet.show(context, prefilledTitle: title);
                  },
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  label: Text(loc.profileFollow),
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

String _achievementLabel(AppLocalizations loc, String achievementId) {
  switch (achievementId) {
    case 'first_check_in':
      return loc.profileAchievementFirstCheckIn;
    case '10_streak':
      return loc.profileAchievementTenStreak;
    case '100_streak':
      return loc.profileAchievementHundredStreak;
    case '1000_streak':
      return loc.profileAchievementThousandStreak;
    case 'first_nudge':
      return loc.profileAchievementFirstNudge;
    case 'first_supporter':
      return loc.profileAchievementFirstSupporter;
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
    final loc = AppLocalizations.of(context)!;
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
              '${habit.title}.${description == null || description.trim().isEmpty ? '' : ' ${description.trim()}.'} ${loc.profileDaysLeft(habit.currentDuration)}. ${_roleLabel(loc, role)}.',
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
                loc.profileDaysLeft(habit.currentDuration),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                _roleLabel(loc, role),
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
                  label: hasPartners
                      ? loc.profileSharedHabit
                      : loc.profileSoloHabit,
                  color: habitColor,
                ),
                Text(
                  loc.profileSectionActive,
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
                ? '${loc.profileDaysLeft(habit.currentDuration)} · ${_roleLabel(loc, role)}'
                : '${loc.profileDayChallenge(habit.targetDuration)} · ${_roleLabel(loc, role)}',
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
              tooltip: loc.profileOpenHabitActions,
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
                        title: Text(loc.profileDeleteHabitTitle),
                        content: Text(loc.profileDeleteHabitBody(habit.title)),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(false),
                            child: Text(loc.settingsCancel),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(true),
                            child: Text(loc.commonDelete),
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
                      PopupMenuItem(value: 'edit', child: Text(loc.commonEdit)),
                      PopupMenuItem(
                        value: 'archive',
                        child: Text(loc.profileArchive),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          loc.commonDelete,
                          style: TextStyle(color: AppTheme.overdueRose),
                        ),
                      ),
                    ]
                  : [
                      PopupMenuItem(
                        value: 'history',
                        child: Text(loc.profileViewHistory),
                      ),
                      if (!hasPartners)
                        PopupMenuItem(
                          value: 'rerun',
                          child: Text(loc.profileRerun),
                        ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          loc.commonDelete,
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
    final loc = AppLocalizations.of(context)!;
    return PopupMenuButton<String>(
      tooltip: loc.profileOpenHabitActions,
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
                title: Text(loc.profileDeleteHabitTitle),
                content: Text(loc.profileDeleteHabitBody(habit.title)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    child: Text(loc.settingsCancel),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                    child: Text(loc.commonDelete),
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
              PopupMenuItem(value: 'edit', child: Text(loc.commonEdit)),
              PopupMenuItem(value: 'archive', child: Text(loc.profileArchive)),
              PopupMenuItem(
                value: 'delete',
                child: Text(
                  loc.commonDelete,
                  style: TextStyle(color: AppTheme.overdueRose),
                ),
              ),
            ]
          : [
              PopupMenuItem(
                value: 'history',
                child: Text(loc.profileViewHistory),
              ),
              if (!hasPartners)
                PopupMenuItem(value: 'rerun', child: Text(loc.profileRerun)),
              PopupMenuItem(
                value: 'delete',
                child: Text(
                  loc.commonDelete,
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

String _roleLabel(AppLocalizations loc, PartnershipRole role) {
  switch (role) {
    case PartnershipRole.owner:
      return loc.profileRoleOwnerView;
    case PartnershipRole.partner:
      return loc.profileRolePartnerView;
    case PartnershipRole.supporter:
      return loc.profileRoleSupporterView;
  }
}

PartnershipRole _partnershipRoleFromWire(String? role) {
  switch (role) {
    case 'partner':
      return PartnershipRole.partner;
    case 'supporter':
      return PartnershipRole.supporter;
    case 'owner':
    default:
      return PartnershipRole.owner;
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
    final loc = AppLocalizations.of(context)!;
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
              loc.profileHistoryIntro,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.warmGray),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: logsAsync.when(
                data: (logs) {
                  if (logs.isEmpty) {
                    return Text(loc.profileNoHistoryYet);
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: logs.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      final points = historyPointsForLog(log);
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(_historyLabel(loc, log)),
                        subtitle: Text(
                          _formatHistoryDate(context, log.actionDate),
                        ),
                        trailing: points != null
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
                                  loc.profilePointsAwarded(points),
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
                error: (_, _) => Text(loc.profileUnableLoadHistory),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _historyLabel(AppLocalizations loc, Log log) {
    if (log.status == LogStatus.completed) {
      return loc.profileHistoryCompleted;
    }
    final note = log.journalNote?.trim();
    return note?.isNotEmpty == true
        ? loc.profileHistorySkippedWithNote(note!)
        : loc.profileHistorySkipped;
  }

  String _formatHistoryDate(BuildContext context, DateTime date) {
    return MaterialLocalizations.of(context).formatMediumDate(date);
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
    final loc = AppLocalizations.of(context)!;
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
            calendarState.error ?? loc.profileCalendarUnknownError,
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
            label: Text(loc.commonRetry),
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
        label: Text(loc.profileCalendarGenerateLink),
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
                      loc.profileCalendarSubscriptionUrl,
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
                    SnackBar(
                      content: Text(loc.profileCalendarCopied),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                tooltip: loc.profileCalendarCopyTooltip,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text(
                loc.profileCalendarPasteHint,
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
          label: Text(loc.profileCalendarRotateToken),
        ),
        const SizedBox(height: 8),
        Text(
          loc.profileCalendarRotateHint,
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
