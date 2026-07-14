import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mascot_reminder_copy.dart';
import '../models/daily_quote.dart';
import 'database_provider.dart';
import 'auth_provider.dart';
import '../services/copy_personalization_service.dart';
import '../services/quotable_service.dart';

/// Provides the daily motivational quote.
/// Priority: cached quote from today → Quotable API fallback → personalized fallback → random fallback.
final quoteProvider = FutureProvider<DailyQuote>((ref) async {
  final db = ref.watch(databaseProvider);
  final userId = ref.watch(authProvider.select((auth) => auth.userId));
  final quotableService = ref.watch(quotableServiceProvider);

  // Try to get a cached quote from today's sync
  final cached = await db.getTodaysQuote();
  if (cached != null) return DailyQuote(text: cached.quoteText, author: cached.author);

  // Fallback to Quotable API if no quote was synced today
  final externalQuote = await quotableService.fetchInspirationalQuote(limit: 50);
  if (externalQuote != null) {
    // Cache it so we don't hit the API again today
    await db.cacheQuote(externalQuote.text, author: externalQuote.author);
    return externalQuote;
  }

  // Final offline fallbacks
  final context = await loadCopyPersonalizationContext(db, userId: userId);
  return MascotReminderCopyHelper.quoteForContext(context);
});
