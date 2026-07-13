import 'package:flutter/material.dart';

import '../database/database.dart';
import '../database/tables.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import 'user_avatar.dart';

class HabitPartnerRow extends StatefulWidget {
  final List<PartnerSnapshot> partners;
  final Color habitColor;
  final int maxVisible;
  final bool compactMode;
  final void Function(PartnerSnapshot partner)? onProfileTap;
  final void Function(PartnerSnapshot partner)? onNudgeTap;

  const HabitPartnerRow({
    super.key,
    required this.partners,
    required this.habitColor,
    this.maxVisible = 4,
    this.compactMode = false,
    this.onProfileTap,
    this.onNudgeTap,
  });

  @override
  State<HabitPartnerRow> createState() => _HabitPartnerRowState();
}

class _HabitPartnerRowState extends State<HabitPartnerRow> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    if (widget.partners.isEmpty) {
      return Semantics(
        label: loc.partnerNoPartnersYet,
        child: Text(
          loc.partnerNoPartnersShort,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppTheme.warmGray),
        ),
      );
    }

    final visiblePartners = widget.partners.take(widget.maxVisible).toList();
    final overflowCount = widget.partners.length - visiblePartners.length;

    if (!_isExpanded) {
      return Semantics(
        label: loc.partnerStackCollapsedSemantics(widget.partners.length),
        button: true,
        child: GestureDetector(
          onLongPress: _toggleExpanded,
          onTap: _toggleExpanded,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            key: const Key('partner-stack-collapsed'),
            height: 40,
            width:
                visiblePartners.length * 24.0 +
                (overflowCount > 0 ? 44.0 : 16.0),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                for (int i = 0; i < visiblePartners.length; i++)
                  Positioned(
                    left: i * 24.0,
                    top: 2,
                    child: _PartnerAvatar(
                      key: Key(
                        'partner-avatar-${visiblePartners[i].partnerUserId}',
                      ),
                      partner: visiblePartners[i],
                      habitColor: widget.habitColor,
                    ),
                  ),
                if (overflowCount > 0)
                  Positioned(
                    left: visiblePartners.length * 24.0,
                    top: 2,
                    child: Container(
                      key: const Key('partner-overflow-badge'),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceVariant,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '+$overflowCount',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.deepCharcoal,
                          fontWeight: FontWeight.w700,
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

    return Semantics(
      label: loc.partnerExpandedSemantics,
      child: GestureDetector(
        onLongPress: _toggleExpanded,
        onTap: _toggleExpanded,
        behavior: HitTestBehavior.opaque,
        child: Container(
          key: const Key('partner-stack-expanded'),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariant.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: widget.habitColor.withValues(alpha: 0.2)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    loc.partnerSectionTitle,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.deepCharcoal,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    loc.partnerTapToCollapse,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppTheme.warmGray),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              for (int i = 0; i < widget.partners.length; i++) ...[
                _PartnerChip(
                  partner: widget.partners[i],
                  habitColor: widget.habitColor,
                  onProfileTap: widget.onProfileTap == null
                      ? null
                      : () => widget.onProfileTap!(widget.partners[i]),
                  onNudgeTap: widget.onNudgeTap == null
                      ? null
                      : () => widget.onNudgeTap!(widget.partners[i]),
                ),
                if (i != widget.partners.length - 1) const SizedBox(height: 8),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PartnerAvatar extends StatelessWidget {
  final PartnerSnapshot partner;
  final Color habitColor;

  const _PartnerAvatar({
    super.key,
    required this.partner,
    required this.habitColor,
  });

  String _stateLabel(AppLocalizations loc) {
    if (partner.hasCompletedToday) return loc.partnerStateCompleted;
    if (_wasNudgedRecently(partner.lastNudgeAt)) return loc.partnerStateNudged;
    if (partner.role == PartnershipRole.supporter) {
      return loc.partnerStateSupporter;
    }
    return loc.partnerStatePending;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final wasNudgedRecently = _wasNudgedRecently(partner.lastNudgeAt);
    final ringStyle = _PartnerRingStyle.resolve(
      partner: partner,
      habitColor: habitColor,
      wasNudgedRecently: wasNudgedRecently,
    );

    return Semantics(
      label: loc.partnerStatusSemantics(partner.username, _stateLabel(loc)),
      child: Container(
        key: Key('partner-status-ring-${partner.partnerUserId}'),
        width: 36,
        height: 36,
        padding: const EdgeInsets.all(2.5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ringStyle.fillColor,
          border: Border.all(color: ringStyle.ringColor, width: 2.5),
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: ringStyle.innerBorderColor,
              width: ringStyle.innerBorderWidth,
            ),
          ),
          child: UserAvatar(
            avatarUrl: partner.avatarUrl,
            username: partner.username,
            radius: 14,
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _PartnerRingStyle {
  final Color ringColor;
  final Color fillColor;
  final Color innerBorderColor;
  final double innerBorderWidth;

  const _PartnerRingStyle({
    required this.ringColor,
    required this.fillColor,
    required this.innerBorderColor,
    required this.innerBorderWidth,
  });

  factory _PartnerRingStyle.resolve({
    required PartnerSnapshot partner,
    required Color habitColor,
    required bool wasNudgedRecently,
  }) {
    if (partner.hasCompletedToday) {
      return _PartnerRingStyle(
        ringColor: habitColor,
        fillColor: habitColor.withValues(alpha: 0.18),
        innerBorderColor: habitColor.withValues(alpha: 0.34),
        innerBorderWidth: 1.2,
      );
    }
    if (wasNudgedRecently) {
      return _PartnerRingStyle(
        ringColor: habitColor.withValues(alpha: 0.8),
        fillColor: habitColor.withValues(alpha: 0.1),
        innerBorderColor: habitColor.withValues(alpha: 0.18),
        innerBorderWidth: 1.1,
      );
    }
    if (partner.role == PartnershipRole.supporter) {
      return _PartnerRingStyle(
        ringColor: AppTheme.mutedLavender,
        fillColor: AppTheme.mutedLavender.withValues(alpha: 0.14),
        innerBorderColor: AppTheme.mutedLavender.withValues(alpha: 0.2),
        innerBorderWidth: 1.1,
      );
    }
    return _PartnerRingStyle(
      ringColor: AppTheme.warmGray.withValues(alpha: 0.5),
      fillColor: AppTheme.surface,
      innerBorderColor: AppTheme.warmGray.withValues(alpha: 0.12),
      innerBorderWidth: 1.0,
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
    final loc = AppLocalizations.of(context)!;
    final roleLabel = switch (partner.role) {
      PartnershipRole.owner => loc.partnerRoleOwner,
      PartnershipRole.partner => loc.partnerRolePartner,
      PartnershipRole.supporter => loc.partnerRoleSupporter,
    };
    final wasNudgedRecently = _wasNudgedRecently(partner.lastNudgeAt);
    final stateLabel = partner.hasCompletedToday
        ? loc.partnerStateCompletedToday
        : wasNudgedRecently
        ? loc.partnerStateNudged
        : partner.role == PartnershipRole.supporter
        ? loc.partnerStateSupporting
        : loc.partnerStatePending;
    final ringStyle = _PartnerRingStyle.resolve(
      partner: partner,
      habitColor: habitColor,
      wasNudgedRecently: wasNudgedRecently,
    );
    final fillColor = partner.hasCompletedToday
        ? habitColor.withValues(alpha: 0.12)
        : wasNudgedRecently
        ? habitColor.withValues(alpha: 0.1)
        : AppTheme.surface;

    return Container(
      constraints: const BoxConstraints(maxWidth: 260),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ringStyle.ringColor, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Semantics(
              label: loc.partnerProfileSemantics(
                partner.username,
                roleLabel,
                stateLabel,
              ),
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
                    children: [
                      _PartnerAvatar(partner: partner, habitColor: habitColor),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              partner.username,
                              key: Key('partner-name-${partner.partnerUserId}'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: AppTheme.deepCharcoal,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            Text(
                              '$roleLabel • $stateLabel',
                              key: Key(
                                'partner-state-${partner.partnerUserId}',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: wasNudgedRecently
                                        ? habitColor
                                        : partner.role ==
                                              PartnershipRole.supporter
                                        ? AppTheme.mutedLavender
                                        : ringStyle.ringColor,
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
              label: loc.partnerNudgeSemantics(partner.username),
              button: true,
              child: Tooltip(
                message: loc.partnerNudgeTooltip(partner.username),
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
}

bool _wasNudgedRecently(DateTime? lastNudgeAt) {
  if (lastNudgeAt == null) return false;
  return lastNudgeAt.isAfter(
    DateTime.now().subtract(const Duration(hours: 24)),
  );
}
