import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calendar_provider.dart';
import '../theme/app_theme.dart';
import 'skeletons.dart';

class CalendarSubscriptionCard extends ConsumerWidget {
  const CalendarSubscriptionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarState = ref.watch(calendarFeedProvider);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today_rounded, color: AppTheme.sageGreen),
                const SizedBox(width: 8),
                Text(
                  'Calendar Subscription',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (calendarState.feedUrl != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Subscribe your native calendar to view your habits:',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: calendarState.isLoading
                        ? null
                        : () {
                            Clipboard.setData(
                              ClipboardData(text: calendarState.feedUrl!),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Calendar URL copied to clipboard',
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.sageGreen.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tap to copy',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: AppTheme.sageGreen),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            calendarState.feedUrl!.replaceFirst(
                              RegExp(r'https?://[^/]+'),
                              '...',
                            ),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(overflow: TextOverflow.ellipsis),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Paste this URL into your calendar app (Apple Calendar, Google Calendar, etc.) as an iCalendar subscription.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.warmGray,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              )
            else if (calendarState.isLoading)
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HableSkeletonBlock(width: 220, height: 12),
                  SizedBox(height: 8),
                  HableSkeletonBlock(width: double.infinity, height: 12),
                ],
              )
            else
              Text(
                calendarState.error ?? 'Failed to load calendar feed',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.red),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: calendarState.isLoading
                        ? null
                        : () => ref
                              .read(calendarFeedProvider.notifier)
                              .fetchCalendarFeedUrl(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.sageGreen,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Refresh'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: calendarState.isLoading
                        ? null
                        : () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Rotate Token?'),
                                content: const Text(
                                  'Rotating your calendar token will invalidate the old subscription link. Your calendar app will need the new URL. Continue?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      ref
                                          .read(calendarFeedProvider.notifier)
                                          .rotateCalendarToken();
                                    },
                                    child: const Text('Rotate'),
                                  ),
                                ],
                              ),
                            );
                          },
                    child: const Text('Rotate Token'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
