import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/standard_habits.dart';
import 'onboarding_duration_screen.dart';

/// Step 2: Core Selection — pick a standard habit or enter a custom one.
class OnboardingHabitScreen extends StatefulWidget {
  final String userId;

  const OnboardingHabitScreen({super.key, required this.userId});

  @override
  State<OnboardingHabitScreen> createState() => _OnboardingHabitScreenState();
}

class _OnboardingHabitScreenState extends State<OnboardingHabitScreen> {
  String? _selectedHabit;
  final _customController = TextEditingController();
  bool _isCustom = false;

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  void _proceed() {
    final title = _isCustom ? _customController.text.trim() : _selectedHabit;
    if (title == null || title.isEmpty) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => OnboardingDurationScreen(
          userId: widget.userId,
          habitTitle: title,
          isCustom: _isCustom,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canProceed =
        _isCustom ? _customController.text.trim().isNotEmpty : _selectedHabit != null;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Text(
                'Choose your\nfirst habit.',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Pick one to start, or create your own.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 28),

              // Standard habits grid
              Expanded(
                child: ListView(
                  children: [
                    ...standardHabits.map((h) => _HabitTile(
                          emoji: h.emoji,
                          title: h.title,
                          subtitle: h.subtitle,
                          isSelected: !_isCustom && _selectedHabit == h.title,
                          onTap: () {
                            setState(() {
                              _selectedHabit = h.title;
                              _isCustom = false;
                            });
                          },
                        )),
                    const SizedBox(height: 12),
                    // Custom option
                    _HabitTile(
                      emoji: '✨',
                      title: 'Custom',
                      subtitle: 'Define your own habit',
                      isSelected: _isCustom,
                      onTap: () {
                        setState(() {
                          _isCustom = true;
                          _selectedHabit = null;
                        });
                      },
                    ),
                    if (_isCustom) ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: _customController,
                        decoration: const InputDecoration(
                          hintText: 'e.g., Practice guitar',
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: canProceed ? _proceed : null,
                  child: const Text('Continue'),
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

class _HabitTile extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _HabitTile({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isSelected ? AppTheme.sageGreen.withValues(alpha: 0.1) : AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? AppTheme.sageGreen
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: Theme.of(context).textTheme.titleMedium),
                      Text(subtitle,
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle, color: AppTheme.sageGreen, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
