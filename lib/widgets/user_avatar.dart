import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class UserAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String? username;
  final double radius;
  final Color? backgroundColor;

  const UserAvatar({
    super.key,
    this.avatarUrl,
    this.username,
    this.radius = 28.0,
    this.backgroundColor,
  });

  bool get _isEmoji {
    if (avatarUrl == null) return false;
    // An emoji is typically short, while URLs are much longer.
    return !avatarUrl!.startsWith('http') && avatarUrl!.length < 15;
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppTheme.sageGreen.withValues(alpha: 0.15);
    final size = radius * 2;

    if (_isEmoji) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            avatarUrl!,
            style: TextStyle(
              fontSize: radius,
            ),
          ),
        ),
      );
    }

    if (avatarUrl != null && avatarUrl!.startsWith('http')) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: bgColor,
        backgroundImage: NetworkImage(avatarUrl!),
      );
    }

    // Fallback to username initial
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          username?.isNotEmpty == true ? username![0].toUpperCase() : '?',
          style: TextStyle(
            fontSize: radius * 0.8,
            fontWeight: FontWeight.w700,
            color: AppTheme.sageGreen,
          ),
        ),
      ),
    );
  }
}
