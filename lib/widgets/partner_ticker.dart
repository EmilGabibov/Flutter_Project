import 'package:flutter/material.dart';
import '../database/database.dart';
import '../theme/app_theme.dart';

/// Horizontal partner ticker at the bottom of the Home Screen.
/// Subtle \"Partner Whisper\" UI per spec 04 §3.
/// Reads from local Drift [PartnerSnapshot] — offline-first.
class PartnerTicker extends StatelessWidget {
  final List<PartnerSnapshot> partners;
  final Color habitColor;

  /// Called with the partner's userId when an avatar is tapped (enqueues nudge).
  final void Function(String partnerUserId)? onNudgeTap;

  const PartnerTicker({
    super.key,
    required this.partners,
    this.habitColor = AppTheme.sageGreen,
    this.onNudgeTap,
  });

  @override
  Widget build(BuildContext context) {
    if (partners.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Text(
            'Partners',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: AppTheme.warmGray,
            ),
          ),
        ),
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: partners.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final partner = partners[index];
              return GestureDetector(
                onTap: () {
                  onNudgeTap?.call(partner.partnerUserId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Nudge sent to ${partner.username}! 👋'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: habitColor.withValues(alpha: 0.9),
                      duration: const Duration(seconds: 2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                child: _PartnerAvatar(
                  partner: partner,
                  habitColor: habitColor,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PartnerAvatar extends StatelessWidget {
  final PartnerSnapshot partner;
  final Color habitColor;

  const _PartnerAvatar({required this.partner, required this.habitColor});

  @override
  Widget build(BuildContext context) {
    final initial =
        partner.username.isNotEmpty ? partner.username[0].toUpperCase() : '?';

    return Semantics(
      label: '${partner.username}, ${partner.hasCompletedToday ? "completed today" : "not completed yet"}. Tap to nudge.',
      button: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: partner.hasCompletedToday
                  ? habitColor.withValues(alpha: 0.15)
                  : AppTheme.warmGray.withValues(alpha: 0.1),
              border: Border.all(
                color: partner.hasCompletedToday
                    ? habitColor
                    : AppTheme.warmGray.withValues(alpha: 0.3),
                width: partner.hasCompletedToday ? 2.5 : 1.5,
              ),
              boxShadow: partner.hasCompletedToday
                  ? [
                      BoxShadow(
                        color: habitColor.withValues(alpha: 0.35),
                        blurRadius: 14,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                initial,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: partner.hasCompletedToday
                      ? habitColor
                      : AppTheme.warmGray,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            partner.username.length > 6
                ? '${partner.username.substring(0, 6)}…'
                : partner.username,
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.warmGray,
            ),
          ),
        ],
      ),
    );
  }
}
