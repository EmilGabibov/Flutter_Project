import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';
import '../database/tables.dart' show HabitStatus;
import '../providers/habit_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/habit_form_sheet.dart';
import '../widgets/user_avatar.dart';
import '../widgets/avatar_picker_sheet.dart';
import '../providers/habit_actions_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/social_providers.dart';

/// Profile Screen — heavy data layer.
/// All historical data and charts belong here exclusively.
class ProfileScreen extends ConsumerWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(authProvider).userId;
    final isFriend = userId != currentUserId && currentUserId != null;

    if (isFriend) {
      return _buildFriendProfile(context, ref);
    }

    final userAsync = ref.watch(currentUserProvider);
    final distributionAsync = ref.watch(logDistributionProvider(userId));
    final historyAsync = ref.watch(pointHistoryProvider(userId));
    final allHabitsAsync = ref.watch(allHabitsProvider(userId));

    return Scaffold(
      body: SafeArea(
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
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: AppTheme.deepCharcoal,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Profile',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ),

            // Score card
            SliverToBoxAdapter(
              child: userAsync.when(
                data: (user) => Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              InkWell(
                                borderRadius: BorderRadius.circular(28),
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (ctx) => const AvatarPickerSheet(),
                                  );
                                },
                                child: UserAvatar(
                                  avatarUrl: user?.avatarUrl,
                                  username: user?.username,
                                  radius: 28,
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: AppTheme.sageGreen,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
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
                                  '${user?.totalScore ?? 0} points',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: AppTheme.sageGreen),
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
                            final total = dist.values.fold(0, (a, b) => a + b);
                            if (total == 0) {
                              return SizedBox(
                                height: 160,
                                child: Center(
                                  child: Text(
                                    'No data yet',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
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
                                      value: dist['completed']!.toDouble(),
                                      color: AppTheme.completionGreen,
                                      title: '${dist['completed']}',
                                      titleStyle: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                      radius: 40,
                                    ),
                                    PieChartSectionData(
                                      value: dist['skipped']!.toDouble(),
                                      color: AppTheme.skipAmber,
                                      title: '${dist['skipped']}',
                                      titleStyle: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                      radius: 40,
                                    ),
                                    PieChartSectionData(
                                      value: dist['overdue']!.toDouble(),
                                      color: AppTheme.overdueRose,
                                      title: '${dist['overdue']}',
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
                          loading: () => const SizedBox(height: 160),
                          error: (_, _) => const SizedBox(height: 160),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _Legend(
                              color: AppTheme.completionGreen,
                              label: 'Completed',
                            ),
                            _Legend(
                              color: AppTheme.skipAmber,
                              label: 'Skipped',
                            ),
                            _Legend(
                              color: AppTheme.overdueRose,
                              label: 'Overdue',
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
                          '30-Day Progress',
                          style: Theme.of(context).textTheme.titleMedium,
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
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
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
                          loading: () => const SizedBox(height: 160),
                          error: (_, _) => const SizedBox(height: 160),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

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
                        Text(
                          'Achievements',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        allHabitsAsync.when(
                          data: (habits) {
                            final completed = habits
                                .where((h) => h.status == HabitStatus.completed)
                                .toList();
                            if (completed.isEmpty) {
                              return Text(
                                'Complete a habit to earn your first badge!',
                                style: Theme.of(context).textTheme.bodyMedium,
                              );
                            }
                            return Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: completed
                                  .map((h) => _AchievementBadge(title: h.title))
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
                final archived = habits
                    .where((h) => h.status == HabitStatus.abandoned)
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
                    if (archived.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
                        child: Text(
                          'Archived',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.overdueRose,
                          ),
                        ),
                      ),
                      ...archived.map(
                        (h) => _HabitListTile(habit: h, isActive: false),
                      ),
                    ],
                  ]),
                );
              },
              loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
              error: (_, _) =>
                  const SliverToBoxAdapter(child: SizedBox.shrink()),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendProfile(BuildContext context, WidgetRef ref) {
    final friendProfileAsync = ref.watch(friendProfileProvider(userId));

    return Scaffold(
      body: SafeArea(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (user['username'] as String?) ?? 'Friend',
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                    Text(
                                      '${user['total_score'] ?? 0} points',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.sageGreen),
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
                      ...habits.map((h) => _FriendHabitListTile(habitData: h)),
                  ]),
                );
              },
              loading: () => const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (err, _) => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(child: Text('Failed to load friend profile.')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FriendHabitListTile extends ConsumerWidget {
  final dynamic habitData;

  const _FriendHabitListTile({required this.habitData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = habitData['title'] as String? ?? 'Habit';
    final duration = habitData['target_duration'] as int? ?? 10;
    
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text('$duration min / day'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Nudged! 👋'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppTheme.sageGreen.withValues(alpha: 0.9),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.back_hand, size: 16),
            tooltip: 'Nudge',
            color: AppTheme.sageGreen,
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: () async {
              HabitFormSheet.show(
                context,
                prefilledTitle: title,
              );
            },
            icon: const Icon(Icons.copy, size: 16),
            label: const Text('Follow'),
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.sageGreen.withValues(alpha: 0.1),
              foregroundColor: AppTheme.sageGreen,
              elevation: 0,
            ),
          ),
        ],
      ),
    );
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
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      title: Text(
        habit.title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text('${habit.targetDuration} days'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            onPressed: () => HabitFormSheet.show(context, existingHabit: habit),
          ),
          if (isActive)
            IconButton(
              icon: const Icon(
                Icons.archive_outlined,
                size: 20,
                color: AppTheme.overdueRose,
              ),
              onPressed: () =>
                  ref.read(habitActionsProvider).archiveHabit(habit.habitId),
            )
          else
            IconButton(
              icon: const Icon(
                Icons.unarchive_outlined,
                size: 20,
                color: AppTheme.sageGreen,
              ),
              onPressed: () =>
                  ref.read(habitActionsProvider).restoreHabit(habit.habitId),
            ),
        ],
      ),
    );
  }
}
