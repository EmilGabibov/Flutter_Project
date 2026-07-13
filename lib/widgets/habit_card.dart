import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../database/database.dart';
import '../database/tables.dart' show PartnershipRole;
import '../data/standard_habits.dart';
import '../models/habit_visual_state.dart';
import '../providers/mud_tuning_provider.dart';
import '../widgets/mud_long_press_button.dart';
import '../widgets/habit_partner_row.dart';
import '../screens/profile_screen.dart';

class QueuedNudgeFeedback {
  final String partnerName;
  final DateTime queuedAt;
  QueuedNudgeFeedback({required this.partnerName, required this.queuedAt});
}

class HabitCard extends StatefulWidget {
  final Habit habit;
  final String userId;
  final int challengeDay;
  final int targetDays;
  final double progressFraction;
  final bool isContinuous;
  final bool isCompletedToday;
  final bool isSkippedToday;
  final PartnershipRole viewerRole;
  final PartnerSnapshot? recentNudge;
  final int streak;
  final double resistanceCoefficient;
  final int calculatedDurationMs;
  final List<PartnerSnapshot> partners;
  final bool hapticsEnabled;
  final MudHapticProfile hapticProfile;

  final VoidCallback onCompletion;
  final VoidCallback onSkip;
  final Future<void> Function(PartnerSnapshot partner) onNudgeTap;

  final bool isShowingCompletionFeedback;
  final QueuedNudgeFeedback? sentNudgeFeedback;

  const HabitCard({
    Key? key,
    required this.habit,
    required this.userId,
    required this.challengeDay,
    required this.targetDays,
    required this.progressFraction,
    required this.isContinuous,
    required this.isCompletedToday,
    required this.isSkippedToday,
    required this.viewerRole,
    required this.recentNudge,
    required this.streak,
    required this.resistanceCoefficient,
    required this.calculatedDurationMs,
    required this.partners,
    required this.hapticsEnabled,
    required this.hapticProfile,
    required this.onCompletion,
    required this.onSkip,
    required this.onNudgeTap,
    this.isShowingCompletionFeedback = false,
    this.sentNudgeFeedback,
  }) : super(key: key);

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  Color _hexToColor(String hex) {
    try {
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return AppTheme.sageGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final habit = widget.habit;
    final habitMeta = standardHabitForTitle(habit.title);
    final habitColor = _hexToColor(habit.colorHex);

    final canLogProgress = widget.viewerRole != PartnershipRole.supporter;
    final visibleSentNudgeFeedback = widget.sentNudgeFeedback;

    HabitVisualState visualState = HabitVisualState.idle;
    if (widget.isShowingCompletionFeedback) {
      visualState = HabitVisualState.checkInComplete;
    } else if (widget.isCompletedToday) {
      visualState = HabitVisualState.established;
    } else if (widget.isSkippedToday) {
      visualState = HabitVisualState.skipped;
    } else if (widget.recentNudge != null) {
      visualState = HabitVisualState.nudged;
    }

    return Semantics(
      label:
          '${habit.title}. Challenge day ${widget.challengeDay} of ${widget.targetDays}. ${widget.isCompletedToday
              ? "Completed today."
              : widget.isSkippedToday
              ? "Skipped today."
              : "Not completed today."}${widget.recentNudge == null ? "" : " ${widget.recentNudge!.username} nudged this habit."}',
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Title
            Positioned(
              top: 16,
              left: 16,
              right: 64,
              child: Text(
                habit.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),

            // Partners
            Positioned(
              top: 12,
              right: 12,
              child: HabitPartnerRow(
                partners: widget.partners,
                habitColor: habitColor,
                compactMode: true,
                maxVisible: 3,
                onProfileTap: (partner) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          ProfileScreen(userId: partner.partnerUserId),
                    ),
                  );
                },
                onNudgeTap: widget.onNudgeTap,
              ),
            ),

            // Center Ring
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 48),
                child: Opacity(
                  opacity: canLogProgress ? 1 : 0.45,
                  child: IgnorePointer(
                    ignoring: !canLogProgress,
                    child: _NudgedRingPulse(
                      isActive:
                          widget.recentNudge != null &&
                          !widget.isCompletedToday,
                      color: habitColor,
                      pulseKey: widget
                          .recentNudge
                          ?.lastNudgeAt
                          ?.millisecondsSinceEpoch,
                      child: MudLongPressButton(
                        resistanceCoefficient: widget.resistanceCoefficient,
                        calculatedDurationMs: widget.calculatedDurationMs,
                        visualState: visualState,
                        habitColor: habitColor,
                        habitIcon: habitMeta?.emoji,
                        visualParameters: HabitVisualParameters.standard,
                        hapticsEnabled: widget.hapticsEnabled,
                        hapticProfile: widget.hapticProfile,
                        onCompletion: widget.onCompletion,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Nudge Feedbacks
            Positioned(
              left: 0,
              right: 0,
              bottom: 40,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.recentNudge != null) ...[
                    _HabitNudgeChip(
                      label: 'Nudged by ${widget.recentNudge!.username}',
                      color: habitColor,
                      icon: Icons.notifications_active_rounded,
                    ),
                    const SizedBox(height: 4),
                  ],
                  if (visibleSentNudgeFeedback != null) ...[
                    _HabitNudgeChip(
                      label:
                          'Nudge queued for ${visibleSentNudgeFeedback.partnerName}',
                      color: habitColor,
                      icon: Icons.back_hand_rounded,
                    ),
                    const SizedBox(height: 4),
                  ],
                  if (!canLogProgress)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Following',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.warmGray,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else if (!widget.isCompletedToday)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: InkWell(
                        onTap: widget.onSkip,
                        child: Text(
                          widget.isSkippedToday
                              ? 'Skipped today'
                              : 'Skip today',
                          style: TextStyle(
                            color: AppTheme.warmGray,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Bottom Progress
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: habitColor.withValues(alpha: 0.08),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.isContinuous
                              ? 'Continuous'
                              : 'Day ${widget.challengeDay} of ${widget.targetDays}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppTheme.deepCharcoal.withValues(
                                  alpha: 0.7,
                                ),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          '🔥 ${widget.streak}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: habitColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Semantics(
                    label:
                        'Progress ${((widget.progressFraction * 100).round())} percent.',
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: habitColor.withValues(alpha: 0.12),
                      ),
                      child: FractionallySizedBox(
                        widthFactor: widget.progressFraction,
                        alignment: Alignment.centerLeft,
                        child: Container(color: habitColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NudgedRingPulse extends StatelessWidget {
  final bool isActive;
  final Color color;
  final int? pulseKey;
  final Widget child;

  const _NudgedRingPulse({
    required this.isActive,
    required this.color,
    required this.pulseKey,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!isActive) return child;

    return TweenAnimationBuilder<double>(
      key: ValueKey('nudge-pulse-$pulseKey'),
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final pulse = 1 - value;
        return Transform.scale(
          scale: 1 + (pulse * 0.04),
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.28 * pulse),
                  blurRadius: 34,
                  spreadRadius: 12,
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _HabitNudgeChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _HabitNudgeChip({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      child: Container(
        key: ValueKey(label),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withValues(alpha: 0.45)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.deepCharcoal,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
