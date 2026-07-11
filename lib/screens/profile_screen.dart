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
import '../providers/habit_actions_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/social_providers.dart';
import '../providers/calendar_provider.dart';

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
    final achievementsAsync = ref.watch(achievementUnlocksProvider(userId));

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
                    const Spacer(),
                    IconButton(
                      tooltip: 'Sign out',
                      onPressed: () async {
                        await ref.read(authProvider.notifier).logout();
                        if (!context.mounted) return;
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      },
                      icon: Icon(
                        Icons.logout_rounded,
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
                                const SizedBox(height: 2),
                                Text(
                                  '@${user?.username ?? 'user'}',
                                  style: Theme.of(context).textTheme.bodyMedium,
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
                                      label: '${user?.totalScore ?? 0} points',
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

            SliverToBoxAdapter(
              child: userAsync.when(
                data: (user) => Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: _CloudSyncActivationCard(user: user),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification PIN sent.')),
      );
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cloud sync activated.')),
      );
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
      if (prev?.feedUrl != next.feedUrl && next.feedUrl == null && !next.isLoading) {
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.overdueRose,
            ),
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
            border: Border.all(
              color: AppTheme.warmGray.withValues(alpha: 0.2),
            ),
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
                      calendarState.feedUrl!.replaceAll(RegExp(r'^https?://'), ''),
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
                  Clipboard.setData(ClipboardData(text: calendarState.feedUrl!));
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
