import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';
import '../database/tables.dart' show HabitStatus, PartnershipRole;
import '../data/standard_habits.dart';
import '../providers/habit_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/habit_form_sheet.dart';
import '../widgets/habit_partner_row.dart';
import '../widgets/user_avatar.dart';
import '../widgets/avatar_picker_sheet.dart';
import '../widgets/skeletons.dart';
import '../providers/habit_actions_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/notification_providers.dart';
import '../providers/social_providers.dart';
import '../providers/calendar_provider.dart';
import '../providers/database_provider.dart';
import '../providers/sync_provider.dart';
import '../widgets/usage_tracked_screen.dart';

/// Profile Screen — heavy data layer.
/// All historical data and charts belong here exclusively.
class ProfileScreen extends ConsumerWidget {
  final String userId;
  final bool showBackButton;

  const ProfileScreen({
    super.key,
    required this.userId,
    this.showBackButton = false,
  });

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
    final achievementsAsync = ref.watch(achievementUnlocksProvider(userId));

    return UsageTrackedScreen(
      screenName: 'profile',
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Row(
                    children: [
                      if (showBackButton) ...[
                        IconButton(
                          tooltip: 'Back',
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
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
                              builder: (_) => SettingsScreen(userId: userId),
                            ),
                          );
                        },
                        icon: Icon(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                            '${user?.totalScore ?? 0} points',
                                        color: AppTheme.deepCharcoal,
                                        fillColor: AppTheme.surfaceVariant,
                                      ),
                                    ],
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

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Text(
                    'Server-owned progression syncs into Profile and Social Hub through local Drift.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.warmGray.withValues(alpha: 0.9),
                    ),
                  ),
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
                              final total = dist.values.fold(
                                0,
                                (a, b) => a + b,
                              );
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
                            loading: () => const _ChartSkeleton(),
                            error: (_, _) => const _ChartSkeleton(),
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
                                        title: _achievementLabel(
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
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppTheme.warmGray.withValues(
                                    alpha: 0.8,
                                  ),
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
                loading: () =>
                    const SliverToBoxAdapter(child: SizedBox.shrink()),
                error: (_, _) =>
                    const SliverToBoxAdapter(child: SizedBox.shrink()),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
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
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
                                    ),
                                    Text(
                                      '${user['total_score'] ?? 0} points',
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
                          friendUserId: userId,
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
              const _SettingsPlaceholderCard(
                icon: Icons.accessibility_new_rounded,
                title: 'Accessibility',
                description:
                    'Foundation placeholder for reduced motion, larger text, and contrast preferences.',
              ),
              const SizedBox(height: 12),
              const _SettingsPlaceholderCard(
                icon: Icons.language_rounded,
                title: 'Language',
                description:
                    'Foundation placeholder for future app language selection.',
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

class _SettingsPlaceholderCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _SettingsPlaceholderCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$title settings placeholder. $description',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppTheme.warmGray),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
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
    if (oldWidget.user?.email != newEmail && !_pinSent) {
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
    final reminderAsync = ref.watch(reminderSettingForUserProvider(userId));
    final actions = ref.read(notificationActionsProvider);

    return reminderAsync.when(
      data: (setting) {
        final enabled = setting?.isEnabled ?? false;
        final hour = setting?.hour ?? 20;
        final minute = setting?.minute ?? 0;
        final timeLabel = _formatReminderTime(hour, minute);

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
                        'Daily reminder',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Switch(
                      value: enabled,
                      onChanged: (value) async {
                        final success = await actions.updateDailyReminder(
                          userId: userId,
                          enabled: value,
                          hour: hour,
                          minute: minute,
                        );
                        if (!context.mounted) return;
                        if (!success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Reminder permission was denied on this device.',
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  enabled
                      ? 'A local reminder is scheduled for $timeLabel on this device.'
                      : 'Enable one daily reminder to return to today\'s habits.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.warmGray.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () async {
                        final initial = TimeOfDay(hour: hour, minute: minute);
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: initial,
                        );
                        if (picked == null || !context.mounted) return;
                        if (!enabled) {
                          await actions.updateReminderPreferenceTime(
                            userId: userId,
                            enabled: false,
                            hour: picked.hour,
                            minute: picked.minute,
                          );
                        } else {
                          final success = await actions.updateDailyReminder(
                            userId: userId,
                            enabled: true,
                            hour: picked.hour,
                            minute: picked.minute,
                          );
                          if (!context.mounted) return;
                          if (!success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Reminder permission was denied on this device.',
                                ),
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.schedule_rounded),
                      label: Text('Time: $timeLabel'),
                    ),
                    if (enabled)
                      TextButton(
                        onPressed: () async {
                          await actions.updateDailyReminder(
                            userId: userId,
                            enabled: false,
                            hour: hour,
                            minute: minute,
                          );
                        },
                        child: const Text('Turn off'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, _) => Text('Error: $error'),
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
    final habitId = habitData['id']?.toString();
    final duration = habitData['target_duration'] as int? ?? 10;
    final viewerUserId = ref.watch(authProvider).userId;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text('$duration days'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
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
                    unawaited(ref.read(syncServiceProvider).flushPending());
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Encouragement queued for $title.'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppTheme.sageGreen.withValues(
                          alpha: 0.9,
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
            tooltip: 'Encourage on $title',
            icon: const Icon(Icons.back_hand_rounded, size: 16),
            color: AppTheme.sageGreen,
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: () {
              HabitFormSheet.show(context, prefilledTitle: title);
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
    final canEdit = role == PartnershipRole.owner;
    final habitMeta = standardHabitForTitle(habit.title);

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
          Text('${habit.targetDuration} days · ${role.name}'),
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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            onPressed: canEdit
                ? () => HabitFormSheet.show(context, existingHabit: habit)
                : null,
          ),
          if (isActive)
            IconButton(
              icon: const Icon(
                Icons.archive_outlined,
                size: 20,
                color: AppTheme.overdueRose,
              ),
              onPressed: canEdit
                  ? () => ref
                        .read(habitActionsProvider)
                        .archiveHabit(habit.habitId)
                  : null,
            )
          else
            IconButton(
              icon: const Icon(
                Icons.unarchive_outlined,
                size: 20,
                color: AppTheme.sageGreen,
              ),
              onPressed: canEdit
                  ? () => ref
                        .read(habitActionsProvider)
                        .restoreHabit(habit.habitId)
                  : null,
            ),
        ],
      ),
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
