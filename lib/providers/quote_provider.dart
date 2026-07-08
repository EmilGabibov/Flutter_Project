import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/fallback_quotes.dart';
import 'database_provider.dart';

/// Provides the daily motivational quote.
/// Priority: cached quote from today → random fallback.
final quoteProvider = FutureProvider<String>((ref) async {
  final db = ref.watch(databaseProvider);

  // Try to get a cached quote from today's sync
  final cached = await db.getTodaysQuote();
  if (cached != null) return cached.quoteText;

  // Offline fallback — never show blank or error text
  final random = Random();
  return fallbackQuotes[random.nextInt(fallbackQuotes.length)];
});
