import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' hide Column;
import '../../database/database.dart';
import '../../database/tables.dart' show HabitStatus;
import '../../providers/database_provider.dart';
import '../../widgets/usage_tracked_screen.dart';
import '../main_navigation_shell.dart';
import 'onboarding_habit_screen.dart';

/// Step 1: Profile Initialization — username input, UUID generation.
class OnboardingUsernameScreen extends ConsumerStatefulWidget {
  const OnboardingUsernameScreen({super.key});

  @override
  ConsumerState<OnboardingUsernameScreen> createState() =>
      _OnboardingUsernameScreenState();
}

class _OnboardingUsernameScreenState
    extends ConsumerState<OnboardingUsernameScreen> {
  final _controller = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    // ── Twin-App Test Harness Auto-Seeding ──
    const seedUserId = String.fromEnvironment('SEED_USER_ID');
    const seedUsername = String.fromEnvironment('SEED_USERNAME');
    final allowSeedHarness = defaultTargetPlatform != TargetPlatform.macOS;
    if (seedUserId.isNotEmpty &&
        seedUsername.isNotEmpty &&
        allowSeedHarness) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _proceedWithSeed(seedUserId, seedUsername);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Bypasses normal onboarding and injects test user + test habit directly.
  Future<void> _proceedWithSeed(String userId, String username) async {
    final db = ref.read(databaseProvider);

    // Seed User
    await db.insertUser(
      UsersCompanion(
        userId: Value(userId),
        username: Value(username),
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
        totalScore: const Value(0),
        isSynced: const Value(false),
      ),
    );

    // Seed Shared Habit
    const habitId = 'shared-habit-1';
    await db
        .into(db.habits)
        .insert(
          HabitsCompanion(
            habitId: const Value(habitId),
            userId: Value(userId),
            title: const Value('Shared Dev Habit'),
            targetDuration: const Value(60),
            currentDuration: const Value(0),
            status: const Value(HabitStatus.active),
            isCustom: const Value(true),
          ),
        );
    await db.assignHabitColorIfMissing(habitId, 0);

    if (mounted) {
      // Skip the rest of onboarding, go straight to Home
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => MainNavigationShell(userId: userId)),
      );
    }
  }

  Future<void> _proceed() async {
    final db = ref.read(databaseProvider);
    final userId = const Uuid().v4();
    final username = _controller.text.trim();

    await db.insertUser(
      UsersCompanion(
        userId: Value(userId),
        username: Value(username),
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
        totalScore: const Value(0),
        isSynced: const Value(false),
      ),
    );

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => OnboardingHabitScreen(userId: userId),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return UsageTrackedScreen(
      screenName: 'onboarding',
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 2),
                Text(
                  'Welcome to\nHable.',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  'Build habits that stick. Start by choosing a name.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _controller,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(hintText: 'Your name'),
                  onChanged: (value) {
                    setState(() {
                      _isValid = value.trim().length >= 2;
                    });
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isValid ? _proceed : null,
                    child: const Text('Continue'),
                  ),
                ),
                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
