import 'package:flutter_test/flutter_test.dart';
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
              {
                'content': 'Test external quote',
                'author': 'External Author',
              }
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
  });
}
