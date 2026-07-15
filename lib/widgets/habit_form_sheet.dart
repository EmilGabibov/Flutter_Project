import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/standard_habits.dart';
import '../database/database.dart';
import '../l10n/app_localizations.dart';
import '../providers/habit_actions_provider.dart';
import '../providers/social_providers.dart';
import '../services/app_error.dart';
import '../theme/app_theme.dart';
import 'skeletons.dart';
import 'usage_tracked_screen.dart';
import 'user_avatar.dart';

const List<String> _pastelColors = [
  'FF9CAF88',
  'FFB8C5D6',
  'FFE2C2B3',
  'FFD1C1D7',
  'FFF0E6D2',
  'FFF4D1AE',
  'FFC3DBC5',
  'FFD6B9B9',
  'FFE4D3A2',
];

const List<int> _durationSuggestions = [21, 33, 40];
const List<String> _emojiChoices = [
  '✨',
  '🌱',
  '💧',
  '📖',
  '🧘',
  '🏃',
  '😴',
  '📝',
  '🎯',
  '🔥',
  '🍎',
  '🎨',
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _durationController;
  late String _selectedColor;
  final Set<String> _selectedPartners = <String>{};
  StandardHabit? _selectedPreset;
  late String _selectedEmoji;
  bool _shouldPersistCustomEmoji = false;
  bool _hasAttemptedSubmit = false;
  bool _isSaving = false;
  String? _submissionError;

  bool get _isEditing => widget.existingHabit != null;
  bool get _isCreateFlow => !_isEditing;
  int get _selectedDurationDays =>
      int.tryParse(_durationController.text.trim()) ??
      _selectedPreset?.defaultDurationDays ??
      21;
  int get _durationSliderUpperBound =>
      math.max(90, math.max(_selectedDurationDays, _durationSuggestions.last));

  @override
  void initState() {
    super.initState();
    final startingTitle =
        widget.existingHabit?.title ?? widget.prefilledTitle ?? '';
    _selectedPreset = standardHabitForTitle(startingTitle);
    final startingEmoji = leadingHabitEmoji(startingTitle);
    _selectedEmoji = startingEmoji ?? _selectedPreset?.emoji ?? '✨';
    _shouldPersistCustomEmoji = startingEmoji != null;
    _titleController = TextEditingController(
      text: stripLeadingHabitEmoji(startingTitle),
    );
    _descriptionController = TextEditingController(
      text:
          widget.existingHabit?.description ?? _selectedPreset?.subtitle ?? '',
    );
    _durationController = TextEditingController(
      text: widget.existingHabit != null
          ? widget.existingHabit!.targetDuration.toString()
          : (_selectedPreset?.defaultDurationDays ?? 21).toString(),
    );
    _selectedColor =
        widget.existingHabit?.colorHex ??
        _selectedPreset?.colorHex ??
        _pastelColors.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _showEmojiPicker() async {
    final emoji = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final loc = AppLocalizations.of(context)!;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.habitFormChooseIconTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  loc.habitFormChooseIconBody,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppTheme.warmGray),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _emojiChoices
                      .map(
                        (emoji) => InkWell(
                          onTap: () => Navigator.of(context).pop(emoji),
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            width: 56,
                            height: 56,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(
                              emoji,
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (emoji == null) return;
    setState(() {
      _selectedEmoji = emoji;
      _shouldPersistCustomEmoji = true;
    });
  }

  void _applyPreset(StandardHabit preset) {
    final previousPresetSubtitle = _selectedPreset?.subtitle;
    setState(() {
      _selectedPreset = preset;
      _selectedEmoji = preset.emoji;
      _titleController.text = preset.title;
      if (_descriptionController.text.trim().isEmpty ||
          _descriptionController.text.trim() == previousPresetSubtitle) {
        _descriptionController.text = preset.subtitle;
      }
      _durationController.text = preset.defaultDurationDays.toString();
      if (preset.colorHex != null) {
        _selectedColor = preset.colorHex!;
      }
      _submissionError = null;
    });
  }

  Future<void> _saveHabit() async {
    final loc = AppLocalizations.of(context)!;
    setState(() {
      _hasAttemptedSubmit = true;
      _submissionError = null;
    });
    if (!_formKey.currentState!.validate()) return;

    final cleanTitle = _titleController.text.trim();
    final cleanDescription = _descriptionController.text.trim();
    final normalizedTitle = stripLeadingHabitEmoji(cleanTitle);
    final matchedPreset = standardHabitForTitle(normalizedTitle);
    final durationDays = int.parse(_durationController.text.trim());
    final persistedDescription = cleanDescription.isEmpty
        ? null
        : cleanDescription;
    final persistedTitle = matchedPreset == null && _shouldPersistCustomEmoji
        ? '${_selectedEmoji.trim()} $normalizedTitle'.trim()
        : normalizedTitle;

    setState(() {
      _isSaving = true;
    });

    try {
      final actions = ref.read(habitActionsProvider);
      if (_isCreateFlow) {
        await actions.createHabit(
          persistedTitle,
          persistedDescription,
          durationDays,
          matchedPreset == null,
          _selectedColor,
          partnerIds: _selectedPartners.toList(),
        );
      } else {
        await actions.updateHabit(
          widget.existingHabit!.habitId,
          persistedTitle,
          persistedDescription,
          durationDays,
          _selectedColor,
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      final appError = AppError.fromAny(
        error,
        fallbackCode: 'habit_form_save_failed',
        fallbackMessage: loc.habitFormSaveFailed,
      );
      setState(() {
        _submissionError = appError.message;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_submissionError!)));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final presetDescription =
        _selectedPreset?.subtitle ?? loc.habitFormPresetDescriptionFallback;

    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.92,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Form(
            key: _formKey,
            autovalidateMode: _hasAttemptedSubmit
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildIdentityRow(context),
                if (_isCreateFlow) ...[
                  const SizedBox(height: 24),
                  _buildPresetSection(context),
                ],
                const SizedBox(height: 20),
                _buildDescriptionSection(context, presetDescription),
                const SizedBox(height: 20),
                _buildDurationSection(context),
                const SizedBox(height: 20),
                _buildColorSection(context),
                if (_isCreateFlow) ...[
                  const SizedBox(height: 20),
                  _buildPartnersSection(context),
                ],
                if (_submissionError != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _submissionError!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.overdueRose,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    key: const Key('habit-form-save'),
                    onPressed: _isSaving ? null : _saveHabit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.deepCharcoal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            _isCreateFlow
                                ? loc.habitFormCreateButton
                                : loc.habitFormSaveChangesButton,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isCreateFlow
                    ? loc.habitFormCreateTitle
                    : loc.habitFormEditTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isCreateFlow ? loc.habitFormCreateBody : loc.habitFormEditBody,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.warmGray,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildIdentityRow(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          key: const Key('habit-form-emoji-picker'),
          onTap: _showEmojiPicker,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _hexToColor(_selectedColor).withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: _hexToColor(_selectedColor).withValues(alpha: 0.28),
              ),
            ),
            child: Text(_selectedEmoji, style: const TextStyle(fontSize: 34)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            key: const Key('habit-form-title'),
            controller: _titleController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: loc.habitFormNameLabel,
              hintText: loc.habitFormNameHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onChanged: (value) {
              final matchedPreset = standardHabitForTitle(value);
              if (matchedPreset == null) return;
              setState(() {
                _selectedPreset = matchedPreset;
                _selectedEmoji = matchedPreset.emoji;
              });
            },
            validator: (value) {
              final title = value?.trim() ?? '';
              if (title.isEmpty) return loc.habitFormNameErrorEmpty;
              if (title.length < 3) return loc.habitFormNameErrorShort;
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPresetSection(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.habitFormPresetTitle,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: standardHabits.map((preset) {
            final selected =
                _selectedPreset?.title.toLowerCase() ==
                preset.title.toLowerCase();
            return ChoiceChip(
              key: Key('preset-${preset.title}'),
              avatar: Text(preset.emoji),
              label: Text(preset.title),
              selected: selected,
              onSelected: (_) => _applyPreset(preset),
              selectedColor: _hexToColor(
                preset.colorHex ?? _selectedColor,
              ).withValues(alpha: 0.18),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(BuildContext context, String description) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.habitFormDescriptionTitle,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        TextFormField(
          key: const Key('habit-form-description'),
          controller: _descriptionController,
          minLines: 2,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: description,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
          ),
          validator: (value) {
            final text = value?.trim() ?? '';
            if (text.isNotEmpty && text.length > 160) {
              return loc.habitFormDescriptionErrorLong;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDurationSection(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final selectedDuration = _selectedDurationDays;
    final sliderUpperBound = _durationSliderUpperBound;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.habitFormDurationTitle,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          loc.habitFormDurationBody,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppTheme.warmGray),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  loc.habitFormDurationTitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.warmGray,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                loc.habitFormDurationChip(selectedDuration),
                key: const Key('habit-form-duration-value'),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _durationSuggestions.map((days) {
            final selected = _durationController.text.trim() == '$days';
            return ChoiceChip(
              key: Key('duration-$days'),
              label: Text(loc.habitFormDurationChip(days)),
              selected: selected,
              onSelected: (_) {
                setState(() {
                  _durationController.text = '$days';
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppTheme.deepCharcoal,
            inactiveTrackColor: AppTheme.warmGray.withValues(alpha: 0.24),
            thumbColor: AppTheme.deepCharcoal,
            overlayColor: AppTheme.deepCharcoal.withValues(alpha: 0.12),
            trackHeight: 5,
          ),
          child: Slider(
            key: const Key('habit-form-duration-slider'),
            min: 1,
            max: sliderUpperBound.toDouble(),
            divisions: sliderUpperBound - 1,
            value: selectedDuration.clamp(1, sliderUpperBound).toDouble(),
            label: loc.habitFormDurationChip(selectedDuration),
            onChanged: (value) {
              setState(() {
                _durationController.text = value.round().toString();
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Text(
                '1',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppTheme.warmGray),
              ),
              const Spacer(),
              Text(
                '$sliderUpperBound',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppTheme.warmGray),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColorSection(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.habitFormColorTitle,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _pastelColors.map((hex) {
            final color = _hexToColor(hex);
            final selected = hex == _selectedColor;
            return InkWell(
              key: Key('color-$hex'),
              onTap: () => setState(() => _selectedColor = hex),
              borderRadius: BorderRadius.circular(999),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? AppTheme.deepCharcoal
                        : Colors.transparent,
                    width: 2.5,
                  ),
                ),
                child: selected
                    ? const Icon(
                        Icons.check,
                        size: 18,
                        color: AppTheme.deepCharcoal,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPartnersSection(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.habitFormPartnersTitle,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        Consumer(
          builder: (context, ref, child) {
            final friendsAsync = ref.watch(acceptedFriendsProvider);
            return friendsAsync.when(
              data: (friends) {
                if (friends.isEmpty) {
                  return Text(
                    loc.habitFormNoFriends,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppTheme.warmGray),
                  );
                }
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: friends.map((friend) {
                    final selected = _selectedPartners.contains(
                      friend.friendUserId,
                    );
                    return FilterChip(
                      key: Key('friend-${friend.friendUserId}'),
                      selected: selected,
                      onSelected: (value) {
                        setState(() {
                          if (value) {
                            _selectedPartners.add(friend.friendUserId);
                          } else {
                            _selectedPartners.remove(friend.friendUserId);
                          }
                        });
                      },
                      avatar: UserAvatar(
                        avatarUrl: friend.avatarUrl,
                        username: friend.username,
                        radius: 10,
                        backgroundColor: Colors.white,
                      ),
                      label: Text(friend.username),
                      selectedColor: AppTheme.sageGreen.withValues(alpha: 0.24),
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
              error: (err, _) => Text(
                AppError.fromAny(
                  err,
                  fallbackCode: 'habit_form_friends_load_failed',
                  fallbackMessage: loc.habitFormFriendsLoadFailed,
                  fallbackKind: AppErrorKind.inline,
                ).message,
              ),
            );
          },
        ),
      ],
    );
  }

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write('ff');
    }
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
