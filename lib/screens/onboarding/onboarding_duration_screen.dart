import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'onboarding_complete_screen.dart';

/// Step 3: Duration Setting — 21 days, 66 days, or custom integer.
class OnboardingDurationScreen extends StatefulWidget {
  final String userId;
  final String habitTitle;
  final bool isCustom;

  const OnboardingDurationScreen({
    super.key,
    required this.userId,
    required this.habitTitle,
    required this.isCustom,
  });

  @override
  State<OnboardingDurationScreen> createState() =>
      _OnboardingDurationScreenState();
}

class _OnboardingDurationScreenState extends State<OnboardingDurationScreen> {
  int? _selectedDuration;
  final _customController = TextEditingController();
  bool _useCustomDuration = false;

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  int? get _effectiveDuration {
    if (_useCustomDuration) {
      return int.tryParse(_customController.text.trim());
    }
    return _selectedDuration;
  }

  void _proceed() {
    final duration = _effectiveDuration;
    if (duration == null || duration < 1) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => OnboardingCompleteScreen(
          userId: widget.userId,
          habitTitle: widget.habitTitle,
          isCustomHabit: widget.isCustom,
          duration: duration,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canProceed = _effectiveDuration != null && _effectiveDuration! > 0;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Text(
                'How long?',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Choose a duration for "${widget.habitTitle}".',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 40),

              // 21 days
              _DurationOption(
                days: 21,
                label: '21 Days',
                subtitle: 'Build the foundation',
                isSelected: !_useCustomDuration && _selectedDuration == 21,
                onTap: () => setState(() {
                  _selectedDuration = 21;
                  _useCustomDuration = false;
                }),
              ),
              const SizedBox(height: 12),

              // 66 days
              _DurationOption(
                days: 66,
                label: '66 Days',
                subtitle: 'Lock it in permanently',
                isSelected: !_useCustomDuration && _selectedDuration == 66,
                onTap: () => setState(() {
                  _selectedDuration = 66;
                  _useCustomDuration = false;
                }),
              ),
              const SizedBox(height: 12),

              // Custom
              _DurationOption(
                days: null,
                label: 'Custom',
                subtitle: 'Set your own number of days',
                isSelected: _useCustomDuration,
                onTap: () => setState(() {
                  _useCustomDuration = true;
                  _selectedDuration = null;
                }),
              ),

              if (_useCustomDuration) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _customController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Number of days (e.g., 30)',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ],

              const Spacer(),

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

class _DurationOption extends StatelessWidget {
  final int? days;
  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _DurationOption({
    required this.days,
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? AppTheme.sageGreen.withValues(alpha: 0.1)
          : AppTheme.surfaceVariant,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppTheme.sageGreen : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              if (days != null)
                Text(
                  '$days',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? AppTheme.sageGreen
                        : AppTheme.deepCharcoal,
                  ),
                )
              else
                Text('⚙️', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
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
    );
  }
}
