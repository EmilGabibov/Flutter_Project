import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Partner avatar data model.
class PartnerInfo {
  final String username;
  final bool hasCompletedToday;

  const PartnerInfo({
    required this.username,
    this.hasCompletedToday = false,
  });
}

/// Horizontal partner ticker at the bottom of the Home Screen.
/// Subtle "Partner Whisper" UI per spec 04 §3.
class PartnerTicker extends StatelessWidget {
  final List<PartnerInfo> partners;
  final void Function(PartnerInfo partner)? onPartnerTap;

  const PartnerTicker({
    super.key,
    required this.partners,
    this.onPartnerTap,
  });

  @override
  Widget build(BuildContext context) {
    if (partners.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: partners.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final partner = partners[index];
          return GestureDetector(
            onTap: () => onPartnerTap?.call(partner),
            child: _PartnerAvatar(partner: partner),
          );
        },
      ),
    );
  }
}

class _PartnerAvatar extends StatelessWidget {
  final PartnerInfo partner;

  const _PartnerAvatar({required this.partner});

  @override
  Widget build(BuildContext context) {
    final initial = partner.username.isNotEmpty
        ? partner.username[0].toUpperCase()
        : '?';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: partner.hasCompletedToday
                ? AppTheme.sageGreen.withValues(alpha: 0.15)
                : AppTheme.warmGray.withValues(alpha: 0.1),
            border: Border.all(
              color: partner.hasCompletedToday
                  ? AppTheme.completionGreen
                  : AppTheme.warmGray.withValues(alpha: 0.3),
              width: partner.hasCompletedToday ? 2.5 : 1.5,
            ),
            boxShadow: partner.hasCompletedToday
                ? [
                    BoxShadow(
                      color:
                          AppTheme.completionGlow.withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 1,
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
                    ? AppTheme.completionGreen
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
    );
  }
}
