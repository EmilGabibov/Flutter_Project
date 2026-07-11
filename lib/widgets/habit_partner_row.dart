import 'package:flutter/material.dart';

import '../database/database.dart';
import '../database/tables.dart';
import '../theme/app_theme.dart';
import 'user_avatar.dart';

class HabitPartnerRow extends StatelessWidget {
  final List<PartnerSnapshot> partners;
  final Color habitColor;
  final int maxVisible;
  final void Function(PartnerSnapshot partner)? onPartnerTap;

  const HabitPartnerRow({
    super.key,
    required this.partners,
    required this.habitColor,
    this.maxVisible = 4,
    this.onPartnerTap,
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
                  onTap: onPartnerTap == null
                      ? null
                      : () => onPartnerTap!(partner),
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
  final VoidCallback? onTap;

  const _PartnerChip({
    required this.partner,
    required this.habitColor,
    this.onTap,
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
    final borderColor = partner.hasCompletedToday
        ? habitColor
        : partner.role == PartnershipRole.supporter
        ? AppTheme.mutedLavender
        : AppTheme.warmGray.withValues(alpha: 0.5);
    final fillColor = partner.hasCompletedToday
        ? habitColor.withValues(alpha: 0.12)
        : AppTheme.surfaceVariant;

    return Semantics(
      label: '${partner.username}, $roleLabel, $statusLabel.',
      button: onTap != null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 140),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor, width: 1.5),
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
                      border: Border.all(color: borderColor, width: 2),
                    ),
                    child: UserAvatar(
                      avatarUrl: partner.avatarUrl,
                      username: partner.username,
                      radius: 12,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  Positioned(
                    right: -1,
                    bottom: -1,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: partner.hasCompletedToday
                            ? AppTheme.completionGreen
                            : partner.role == PartnershipRole.supporter
                            ? AppTheme.mutedLavender
                            : AppTheme.warmGray,
                        border: Border.all(color: Colors.white, width: 1.2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      partner.username,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.deepCharcoal,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      roleLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 11,
                        color: partner.role == PartnershipRole.supporter
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
    );
  }
}
