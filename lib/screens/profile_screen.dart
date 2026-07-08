import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/tables.dart' show HabitStatus;
import '../providers/habit_providers.dart';
import '../theme/app_theme.dart';

/// Profile Screen — heavy data layer.
/// All historical data and charts belong here exclusively.
class ProfileScreen extends ConsumerWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                      icon:
                          Icon(Icons.arrow_back_rounded, color: AppTheme.deepCharcoal),
                    ),
                    const SizedBox(width: 8),
                    Text('Profile',
                        style: Theme.of(context).textTheme.headlineMedium),
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
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppTheme.sageGreen.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                user?.username.isNotEmpty == true
                                    ? user!.username[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.sageGreen,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user?.username ?? 'User',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge),
                                Text(
                                  '${user?.totalScore ?? 0} points',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
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
                        Text('Habit Distribution',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 20),
                        distributionAsync.when(
                          data: (dist) {
                            final total = dist.values.fold(0, (a, b) => a + b);
                            if (total == 0) {
                              return SizedBox(
                                height: 160,
                                child: Center(
                                  child: Text('No data yet',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                ),
                              );
                            }
                            return SizedBox(
                              height: 160,
                              child: PieChart(PieChartData(
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
                                        color: Colors.white),
                                    radius: 40,
                                  ),
                                  PieChartSectionData(
                                    value: dist['skipped']!.toDouble(),
                                    color: AppTheme.skipAmber,
                                    title: '${dist['skipped']}',
                                    titleStyle: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                    radius: 40,
                                  ),
                                  PieChartSectionData(
                                    value: dist['overdue']!.toDouble(),
                                    color: AppTheme.overdueRose,
                                    title: '${dist['overdue']}',
                                    titleStyle: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                    radius: 40,
                                  ),
                                ],
                              )),
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
                                label: 'Completed'),
                            _Legend(
                                color: AppTheme.skipAmber, label: 'Skipped'),
                            _Legend(
                                color: AppTheme.overdueRose, label: 'Overdue'),
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
                        Text('30-Day Progress',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 20),
                        historyAsync.when(
                          data: (history) {
                            if (history.isEmpty) {
                              return SizedBox(
                                height: 160,
                                child: Center(
                                  child: Text('No data yet',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                ),
                              );
                            }
                            return SizedBox(
                              height: 160,
                              child: LineChart(LineChartData(
                                gridData: const FlGridData(show: false),
                                titlesData: const FlTitlesData(show: false),
                                borderData: FlBorderData(show: false),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: history
                                        .asMap()
                                        .entries
                                        .map((e) => FlSpot(
                                            e.key.toDouble(),
                                            e.value.value.toDouble()))
                                        .toList(),
                                    isCurved: true,
                                    color: AppTheme.sageGreen,
                                    barWidth: 3,
                                    dotData: const FlDotData(show: false),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: AppTheme.sageGreen
                                          .withValues(alpha: 0.1),
                                    ),
                                  ),
                                ],
                              )),
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
                        Text('Achievements',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 16),
                        allHabitsAsync.when(
                          data: (habits) {
                            final completed = habits
                                .where((h) => h.status == HabitStatus.completed)
                                .toList();
                            if (completed.isEmpty) {
                              return Text(
                                'Complete a habit to earn your first badge!',
                                style:
                                    Theme.of(context).textTheme.bodyMedium,
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

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
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
            color: AppTheme.completionGreen.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.emoji_events_rounded,
              size: 16, color: AppTheme.completionGreen),
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
