import 'package:flutter_test/flutter_test.dart';
import 'package:hable/models/daily_quote.dart';
import 'package:hable/services/quotable_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

void main() {
  group('QuotableService', () {
    test('fetchInspirationalQuote parses successful response', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.toString(), contains('api.quotable.io/quotes'));
        expect(request.url.queryParameters['limit'], '50');
        return http.Response(
          jsonEncode({
            'count': 1,
            'results': [
              {'content': 'Test external quote', 'author': 'External Author'},
            ],
          }),
          200,
        );
      });

      final service = QuotableService(client: mockClient);
      final quote = await service.fetchInspirationalQuote(limit: 50);

      expect(quote, isNotNull);
      expect(quote!.text, 'Test external quote');
      expect(quote.author, 'External Author');
    });

    test('fetchInspirationalQuote handles errors gracefully', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Server Error', 500);
      });

      final service = QuotableService(client: mockClient);
      final quote = await service.fetchInspirationalQuote();

      expect(quote, isNull);
    });

    test('filters overlong results before selecting a quote', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'results': [
              {
                'content': 'x' * (maxDailyQuoteTextLength + 1),
                'author': 'Too Long Author',
              },
              {'content': 'A readable quote', 'author': '  Readable Author  '},
            ],
          }),
          200,
        );
      });

      final service = QuotableService(client: mockClient);
      final quote = await service.fetchInspirationalQuote();

      expect(
        quote,
        const DailyQuote(text: 'A readable quote', author: 'Readable Author'),
      );
    });

    test('accepts a quote exactly at the maximum length', () async {
      final text = 'x' * maxDailyQuoteTextLength;
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'results': [
              {'content': text, 'author': ''},
            ],
          }),
          200,
        );
      });

      final quote = await QuotableService(
        client: mockClient,
      ).fetchInspirationalQuote();

      expect(quote, DailyQuote(text: text));
    });
  });
}
