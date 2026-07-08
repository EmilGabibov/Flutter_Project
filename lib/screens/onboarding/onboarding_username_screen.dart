import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' hide Column;
import '../../database/database.dart';
import '../../providers/database_provider.dart';
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _proceed() async {
    final db = ref.read(databaseProvider);
    final userId = const Uuid().v4();
    final username = _controller.text.trim();

    await db.insertUser(UsersCompanion(
      userId: Value(userId),
      username: Value(username),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
      totalScore: const Value(0),
      isSynced: const Value(false),
    ));

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
    return Scaffold(
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
                decoration: const InputDecoration(
                  hintText: 'Your name',
                ),
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
    );
  }
}
