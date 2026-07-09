import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';
import '../providers/database_provider.dart';
import '../providers/social_providers.dart';
import '../theme/app_theme.dart';

class MilestoneWishCarousel extends ConsumerWidget {
  const MilestoneWishCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final milestoneEventsAsync = ref.watch(milestoneEventsProvider);

    return milestoneEventsAsync.when(
      data: (events) {
        if (events.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return _MilestoneCard(event: event);
            },
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _MilestoneCard extends ConsumerWidget {
  final MilestoneEvent event;

  const _MilestoneCard({required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 280,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🎉', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'User ${event.userId} reached a milestone!',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _WishButton(
                  label: 'Keep it up! 🔥',
                  onTap: () => _sendWish(ref, 'Keep it up! 🔥'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _WishButton(
                  label: 'Amazing! 🚀',
                  onTap: () => _sendWish(ref, 'Amazing! 🚀'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _sendWish(WidgetRef ref, String message) async {
    final db = ref.read(databaseProvider);
    await enqueuePrivateMessage(
      db: db,
      targetUserId: event.userId,
      message: message,
      milestoneType: event.milestoneType,
      eventId: event.eventId,
    );
  }
}

class _WishButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _WishButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.sageGreen.withValues(alpha: 0.1),
        foregroundColor: AppTheme.sageGreen,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }
}
