import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' hide Column;
import '../../database/database.dart';
import '../../database/tables.dart';
import '../../providers/database_provider.dart';
import '../../theme/app_theme.dart';
import '../home_screen.dart';

/// Step 4: Commit & Sync — write to Drift and route to Home.
class OnboardingCompleteScreen extends ConsumerStatefulWidget {
  final String userId;
  final String habitTitle;
  final bool isCustomHabit;
  final int duration;

  const OnboardingCompleteScreen({
    super.key,
    required this.userId,
    required this.habitTitle,
    required this.isCustomHabit,
    required this.duration,
  });

  @override
  ConsumerState<OnboardingCompleteScreen> createState() =>
      _OnboardingCompleteScreenState();
}

class _OnboardingCompleteScreenState
    extends ConsumerState<OnboardingCompleteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  bool _isCommitting = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _commit() async {
    if (_isCommitting) return;
    setState(() => _isCommitting = true);

    final db = ref.read(databaseProvider);
    final habitId = const Uuid().v4();

    // Write habit to Drift
    await db.insertHabit(HabitsCompanion(
      habitId: Value(habitId),
      userId: Value(widget.userId),
      title: Value(widget.habitTitle),
      isCustom: Value(widget.isCustomHabit),
      targetDuration: Value(widget.duration),
      currentDuration: Value(widget.duration),
      status: Value(HabitStatus.active),
      updatedAt: Value(DateTime.now()),
      isSynced: const Value(false),
    ));

    // Enqueue background sync
    await db.enqueueSync(SyncQueueCompanion(
      action: Value(SyncAction.createHabit),
      payload: Value('{"habit_id":"$habitId","title":"${widget.habitTitle}","duration":${widget.duration}}'),
      createdAt: Value(DateTime.now()),
    ));

    // Play success animation
    await _animController.forward();
    await Future.delayed(const Duration(milliseconds: 400));

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => HomeScreen(userId: widget.userId),
        ),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),
              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.completionGreen.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.spa_rounded,
                    size: 40,
                    color: AppTheme.completionGreen,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'You\'re all set.',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: [
                    const TextSpan(text: 'You\'ve committed to '),
                    TextSpan(
                      text: widget.habitTitle,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: ' for ${widget.duration} days.'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Day 1 starts now. You got this.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isCommitting ? null : _commit,
                  child: _isCommitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Start My Journey'),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
