import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';
import '../providers/habit_actions_provider.dart';
import '../providers/social_providers.dart';
import '../theme/app_theme.dart';
import 'skeletons.dart';
import '../data/standard_habits.dart';
import 'usage_tracked_screen.dart';

const List<String> _pastelColors = [
  'FF9CAF88', // Sage Green
  'FFB8C5D6', // Serene Blue
  'FFE2C2B3', // Warm Terracotta
  'FFD1C1D7', // Soft Lavender
  'FFF0E6D2', // Oat Milk
  'FFF4D1AE', // Peachy Sand
  'FFC3DBC5', // Mint Frost
  'FFD6B9B9', // Dusty Rose
  'FFE4D3A2', // Muted Mustard
];

class HabitFormSheet extends ConsumerStatefulWidget {
  final Habit? existingHabit;
  final String? prefilledTitle;

  const HabitFormSheet({super.key, this.existingHabit, this.prefilledTitle});

  static void show(
    BuildContext context, {
    Habit? existingHabit,
    String? prefilledTitle,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => UsageTrackedScreen(
        screenName: 'habit_form',
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: HabitFormSheet(
            existingHabit: existingHabit,
            prefilledTitle: prefilledTitle,
          ),
        ),
      ),
    );
  }

  @override
  ConsumerState<HabitFormSheet> createState() => _HabitFormSheetState();
}

class _HabitFormSheetState extends ConsumerState<HabitFormSheet> {
  late TextEditingController _titleController;
  late TextEditingController _durationController;
  late String _selectedColor;
  final Set<String> _selectedPartners = {};

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.existingHabit?.title ?? widget.prefilledTitle ?? '',
    );
    _durationController = TextEditingController(
      text: widget.existingHabit != null
          ? widget.existingHabit!.targetDuration.toString()
          : '21',
    );
    _selectedColor = widget.existingHabit?.colorHex ?? _pastelColors[0];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _saveHabit() async {
    final title = _titleController.text.trim();
    final durationDays = int.tryParse(_durationController.text) ?? 21;
    if (title.isEmpty) return;
    if (durationDays < 1) return;

    if (widget.existingHabit == null) {
      await ref
          .read(habitActionsProvider)
          .createHabit(
            title,
            durationDays,
            false,
            _selectedColor,
            partnerIds: _selectedPartners.toList(),
          );
    } else {
      await ref
          .read(habitActionsProvider)
          .updateHabit(
            widget.existingHabit!.habitId,
            title,
            durationDays,
            _selectedColor,
          );
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.86,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.existingHabit == null ? 'New Habit' : 'Edit Habit',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (widget.existingHabit == null) ...[
                Text(
                  'Quick Select',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: standardHabits.map((preset) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ActionChip(
                          avatar: Text(preset.emoji),
                          label: Text(preset.title),
                          onPressed: () {
                            setState(() {
                              _titleController.text = preset.title;
                              _durationController.text = preset
                                  .defaultDurationDays
                                  .toString();
                              if (preset.colorHex != null) {
                                _selectedColor = preset.colorHex!;
                              }
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Habit Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Challenge Duration (days)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              Text('Color', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _pastelColors.map((hex) {
                  final color = _hexToColor(hex);
                  final isSelected = hex == _selectedColor;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = hex),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.deepCharcoal
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: AppTheme.deepCharcoal,
                              size: 20,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
              if (widget.existingHabit == null) ...[
                const SizedBox(height: 24),
                Text(
                  'Invite Partners',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 12),
                Consumer(
                  builder: (context, ref, child) {
                    final friendsAsync = ref.watch(acceptedFriendsProvider);
                    return friendsAsync.when(
                      data: (friends) {
                        if (friends.isEmpty) {
                          return Text(
                            'No friends found. Add friends from the Social tab first.',
                            style: TextStyle(
                              color: AppTheme.deepCharcoal.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          );
                        }
                        return Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: friends.map((f) {
                            final isSelected = _selectedPartners.contains(
                              f.friendUserId,
                            );
                            return FilterChip(
                              label: Text(f.username),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedPartners.add(f.friendUserId);
                                  } else {
                                    _selectedPartners.remove(f.friendUserId);
                                  }
                                });
                              },
                              selectedColor: AppTheme.sageGreen.withValues(
                                alpha: 0.3,
                              ),
                              checkmarkColor: AppTheme.deepCharcoal,
                            );
                          }).toList(),
                        );
                      },
                      loading: () => const Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          HableSkeletonBlock(width: 82, height: 36),
                          HableSkeletonBlock(width: 96, height: 36),
                          HableSkeletonBlock(width: 74, height: 36),
                        ],
                      ),
                      error: (err, _) => Text('Error: $err'),
                    );
                  },
                ),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saveHabit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.deepCharcoal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
