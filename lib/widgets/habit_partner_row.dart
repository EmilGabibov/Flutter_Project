import 'package:flutter/material.dart';

import '../database/database.dart';
import '../database/tables.dart';
import '../theme/app_theme.dart';
import 'user_avatar.dart';

class HabitPartnerRow extends StatelessWidget {
  final List<PartnerSnapshot> partners;
  final Color habitColor;
  final int maxVisible;
  final void Function(PartnerSnapshot partner)? onProfileTap;
  final void Function(PartnerSnapshot partner)? onNudgeTap;

  const HabitPartnerRow({
    super.key,
    required this.partners,
    required this.habitColor,
    this.maxVisible = 4,
    this.onProfileTap,
    this.onNudgeTap,
  });

  @override
  Widget build(BuildContext context) {
    if (partners.isEmpty) {
      return Semantics(
        label: 'No partners on this habit yet.',
        child: Text(
          'Solo today',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppTheme.warmGray),
        ),
      );
    }

    final visiblePartners = partners.take(maxVisible).toList();
    final overflowCount = (partners.length - visiblePartners.length).clamp(
      0,
      partners.length,
    );

    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final partner in visiblePartners)
                _PartnerChip(
                  partner: partner,
                  habitColor: habitColor,
                  onProfileTap: onProfileTap == null
                      ? null
                      : () => onProfileTap!(partner),
                  onNudgeTap: onNudgeTap == null
                      ? null
                      : () => onNudgeTap!(partner),
                ),
              if (overflowCount > 0)
                Semantics(
                  label: '$overflowCount more partners hidden.',
                  child: Container(
                    key: const Key('partner-overflow-chip'),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '+$overflowCount',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.deepCharcoal,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PartnerChip extends StatelessWidget {
  final PartnerSnapshot partner;
  final Color habitColor;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNudgeTap;

  const _PartnerChip({
    required this.partner,
    required this.habitColor,
    this.onProfileTap,
    this.onNudgeTap,
  });

  @override
  Widget build(BuildContext context) {
    final roleLabel = switch (partner.role) {
      PartnershipRole.owner => 'owner',
      PartnershipRole.partner => 'partner',
      PartnershipRole.supporter => 'supporter',
    };
    final statusLabel = partner.hasCompletedToday
        ? 'completed today'
        : 'not completed today';
    final wasNudgedRecently = _wasNudgedRecently(partner.lastNudgeAt);
    final borderColor = partner.hasCompletedToday
        ? habitColor
        : wasNudgedRecently
        ? habitColor.withValues(alpha: 0.85)
        : partner.role == PartnershipRole.supporter
        ? AppTheme.mutedLavender
        : AppTheme.warmGray.withValues(alpha: 0.5);
    final fillColor = partner.hasCompletedToday
        ? habitColor.withValues(alpha: 0.12)
        : wasNudgedRecently
        ? habitColor.withValues(alpha: 0.1)
        : AppTheme.surfaceVariant;

    return Container(
      constraints: const BoxConstraints(maxWidth: 204),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Semantics(
              label:
                  '${partner.username}, $roleLabel, $statusLabel${wasNudgedRecently ? ", nudged recently" : ""}. Opens profile.',
              button: onProfileTap != null,
              child: InkWell(
                key: Key('partner-profile-${partner.partnerUserId}'),
                onTap: onProfileTap,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: borderColor,
                                width: 2.5,
                              ),
                            ),
                            child: UserAvatar(
                              avatarUrl: partner.avatarUrl,
                              username: partner.username,
                              radius: 16,
                              backgroundColor: Colors.white,
                            ),
                          ),
                          Positioned(
                            right: -2,
                            bottom: -2,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: partner.hasCompletedToday
                                    ? AppTheme.completionGreen
                                    : partner.role == PartnershipRole.supporter
                                    ? AppTheme.mutedLavender
                                    : AppTheme.warmGray,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              partner.username,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: AppTheme.deepCharcoal,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            Text(
                              wasNudgedRecently ? 'nudged' : roleLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: wasNudgedRecently
                                        ? habitColor
                                        : partner.role ==
                                              PartnershipRole.supporter
                                        ? AppTheme.mutedLavender
                                        : borderColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (onNudgeTap != null)
            Semantics(
              label: 'Nudge ${partner.username} on this habit.',
              button: true,
              child: Tooltip(
                message: 'Nudge ${partner.username}',
                child: IconButton(
                  key: Key('partner-nudge-${partner.partnerUserId}'),
                  onPressed: onNudgeTap,
                  icon: const Icon(Icons.back_hand_rounded, size: 18),
                  color: habitColor,
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          if (onNudgeTap != null) const SizedBox(width: 4),
        ],
      ),
    );
  }

  bool _wasNudgedRecently(DateTime? lastNudgeAt) {
    if (lastNudgeAt == null) return false;
    return lastNudgeAt.isAfter(
      DateTime.now().subtract(const Duration(hours: 24)),
    );
  }
}
