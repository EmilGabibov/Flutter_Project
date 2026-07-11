import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class HableSkeletonBlock extends StatelessWidget {
  final double? width;
  final double height;
  final BorderRadiusGeometry borderRadius;

  const HableSkeletonBlock({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(999)),
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Loading',
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariant.withValues(alpha: 0.72),
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

class HableSkeletonCircle extends StatelessWidget {
  final double size;

  const HableSkeletonCircle({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return HableSkeletonBlock(
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(size / 2),
    );
  }
}

class HableSkeletonCard extends StatelessWidget {
  final double height;
  final EdgeInsetsGeometry margin;

  const HableSkeletonCard({
    super.key,
    this.height = 96,
    this.margin = const EdgeInsets.only(bottom: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.warmGray.withValues(alpha: 0.10)),
      ),
      child: const Row(
        children: [
          HableSkeletonCircle(size: 44),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HableSkeletonBlock(width: 150, height: 14),
                SizedBox(height: 10),
                HableSkeletonBlock(width: 220, height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HableSkeletonList extends StatelessWidget {
  final int itemCount;
  final EdgeInsetsGeometry padding;
  final double itemHeight;

  const HableSkeletonList({
    super.key,
    this.itemCount = 4,
    this.padding = const EdgeInsets.all(16),
    this.itemHeight = 96,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (_, _) => HableSkeletonCard(height: itemHeight),
    );
  }
}

class HableEmptyStateCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Widget? action;

  const HableEmptyStateCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: AppTheme.warmGray.withValues(alpha: 0.12),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.sageGreen.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppTheme.sageGreen, size: 28),
                ),
                const SizedBox(height: 14),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppTheme.warmGray),
                ),
                if (action != null) ...[const SizedBox(height: 18), action!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
