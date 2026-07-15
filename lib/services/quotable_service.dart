import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/daily_quote.dart';

final quotableServiceProvider = Provider<QuotableService>((ref) {
  return QuotableService();
});

class QuotableService {
  final http.Client _client;

  QuotableService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches quotes from api.quotable.io.
  /// Uses limit=50 as suggested, then picks one randomly.
  Future<DailyQuote?> fetchInspirationalQuote({int limit = 50}) async {
    try {
      final uri = Uri.parse(
        'https://api.quotable.io/quotes?tags=inspirational&limit=$limit',
      );
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List<dynamic>?;

        if (results != null && results.isNotEmpty) {
          final candidates = results
              .whereType<Map<String, dynamic>>()
              .where(
                (candidate) =>
                    normalizeDailyQuoteText(candidate['content']?.toString()) !=
                    null,
              )
              .toList();
          if (candidates.isEmpty) return null;

          // Shuffle or pick random to rotate if we fetch 50.
          candidates.shuffle();
          final selected = candidates.first;

          final content = normalizeDailyQuoteText(
            selected['content']?.toString(),
          );
          final author = normalizeDailyQuoteAuthor(
            selected['author']?.toString(),
          );

          if (content != null) {
            return DailyQuote(text: content, author: author);
          }
        }
      }
    } catch (e) {
      // Return null on network error, timeouts, or JSON parsing issues
      return null;
    }
    return null;
  }
}
