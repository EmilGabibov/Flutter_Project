import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/habit_timeline.dart';

/// Emits immediately and again just after every local calendar-day boundary.
///
/// Habit rows otherwise rebuild only when their stored data changes, which can
/// leave a calendar-based challenge label showing yesterday's day indefinitely.
final localDayProvider = StreamProvider<DateTime>((ref) async* {
  while (true) {
    final now = DateTime.now();
    yield now;
    await Future<void>.delayed(
      timeUntilNextLocalDay(now) + const Duration(milliseconds: 50),
    );
  }
});
