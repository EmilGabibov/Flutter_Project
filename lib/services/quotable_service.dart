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
      final uri = Uri.parse('https://api.quotable.io/quotes?tags=inspirational&limit=$limit');
      final response = await _client.get(uri).timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List<dynamic>?;
        
        if (results != null && results.isNotEmpty) {
          // Shuffle or pick random to rotate if we fetch 50
          results.shuffle();
          final selected = results.first;
          
          final content = selected['content']?.toString().trim();
          final author = selected['author']?.toString().trim();
          
          if (content != null && content.isNotEmpty) {
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
