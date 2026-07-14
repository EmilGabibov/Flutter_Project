import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mascot_reminder_copy.dart';
import '../models/daily_quote.dart';
import 'database_provider.dart';
import 'auth_provider.dart';
import '../services/copy_personalization_service.dart';

/// Provides the daily motivational quote.
/// Priority: cached quote from today → personalized fallback → random fallback.
final quoteProvider = FutureProvider<DailyQuote>((ref) async {
  final db = ref.watch(databaseProvider);
  final userId = ref.watch(authProvider.select((auth) => auth.userId));

  // Try to get a cached quote from today's sync
  final cached = await db.getTodaysQuote();
  if (cached != null) return DailyQuote(text: cached.quoteText, author: cached.author);

  final context = await loadCopyPersonalizationContext(db, userId: userId);
  return MascotReminderCopyHelper.quoteForContext(context);
});
