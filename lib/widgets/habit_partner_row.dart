import 'package:flutter/material.dart';

import '../database/database.dart';
import '../database/tables.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import 'user_avatar.dart';
import 'context_menu/hable_context_menu.dart';
import 'context_menu/menu_item.dart';

class HabitPartnerRow extends StatelessWidget {
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

  void _showPartnerMenu(
    BuildContext context,
    PartnerSnapshot partner,
    Offset position,
    AppLocalizations loc,
  ) async {
    final action = await showHableContextMenu<String>(
      context: context,
      position: position,
      title: partner.username,
      items: [
        if (onNudgeTap != null)
          HableMenuItem<String>(
            label: loc.partnerNudgeSemantics(partner.username).replaceAll(partner.username, '').trim(), // e.g. "Nudge"
            value: 'nudge',
            icon: Icons.back_hand_rounded,
            intent: MenuIntent.primary,
          ),
        if (onProfileTap != null)
          HableMenuItem<String>(
            label: loc.partnerProfileSemantics(partner.username, '', '').split(' ').first, // Fallback
            value: 'profile',
            icon: Icons.person_rounded,
            intent: MenuIntent.primary,
          ),
      ],
    );

    if (action == 'nudge' && onNudgeTap != null) {
      onNudgeTap!(partner);
    } else if (action == 'profile' && onProfileTap != null) {
      onProfileTap!(partner);
    }
  }

  void _showAllPartners(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final loc = AppLocalizations.of(context)!;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  loc.partnerSectionTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.deepCharcoal,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                for (int i = 0; i < partners.length; i++) ...[
                  _PartnerChip(
                    partner: partners[i],
                    habitColor: habitColor,
                    onProfileTap: onProfileTap == null ? null : () {
                      Navigator.pop(context);
                      onProfileTap!(partners[i]);
                    },
                    onNudgeTap: onNudgeTap == null ? null : () {
                      Navigator.pop(context);
                      onNudgeTap!(partners[i]);
                    },
                  ),
                  if (i != partners.length - 1) const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    if (partners.isEmpty) {
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

    final visiblePartners = partners.take(maxVisible).toList();
    final overflowCount = partners.length - visiblePartners.length;

    return Semantics(
      label: loc.partnerStackCollapsedSemantics(partners.length),
      button: true,
      child: SizedBox(
        key: const Key('partner-stack-collapsed'),
        height: 40,
        width: visiblePartners.length * 24.0 + (overflowCount > 0 ? 44.0 : 16.0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            for (int i = 0; i < visiblePartners.length; i++)
              Positioned(
                left: i * 24.0,
                top: 2,
                child: GestureDetector(
                  onTapDown: (details) {
                    _showPartnerMenu(context, visiblePartners[i], details.globalPosition, loc);
                  },
                  child: _PartnerAvatar(
                    key: Key('partner-avatar-${visiblePartners[i].partnerUserId}'),
                    partner: visiblePartners[i],
                    habitColor: habitColor,
                  ),
                ),
              ),
            if (overflowCount > 0)
              Positioned(
                left: visiblePartners.length * 24.0,
                top: 2,
                child: GestureDetector(
                  onTap: () => _showAllPartners(context),
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
              ),
          ],
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
        fillColor: habitColor,
        innerBorderColor: Colors.white,
        innerBorderWidth: 1.5,
      );
    }
    if (wasNudgedRecently) {
      return _PartnerRingStyle(
        ringColor: habitColor.withValues(alpha: 0.5),
        fillColor: AppTheme.surface,
        innerBorderColor: Colors.transparent,
        innerBorderWidth: 0,
      );
    }
    if (partner.role == PartnershipRole.supporter) {
      return const _PartnerRingStyle(
        ringColor: AppTheme.mutedLavender,
        fillColor: AppTheme.surface,
        innerBorderColor: Colors.transparent,
        innerBorderWidth: 0,
      );
    }
    return const _PartnerRingStyle(
      ringColor: AppTheme.surfaceVariant,
      fillColor: AppTheme.surface,
      innerBorderColor: Colors.transparent,
      innerBorderWidth: 0,
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
