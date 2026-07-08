import 'package:flutter_test/flutter_test.dart';
import 'package:hable/search/search_engine.dart';

void main() {
  group('SearchEngine', () {
    late SearchEngine engine;

    setUp(() {
      engine = SearchEngine();
    });

    test('Indexes and retrieves documents correctly with ranking', () async {
      await engine.indexDocument('doc1', 'The quick brown fox jumps over the lazy dog');
      await engine.indexDocument('doc2', 'A quick brown dog outpaces a quick fox');
      await engine.indexDocument('doc3', 'The dog is very lazy');

      // 'quick' appears once in doc1, twice in doc2.
      final results = engine.search('quick');
      
      expect(results.length, 2);
      // doc2 should be first because term frequency is 2
      expect(results[0].documentId, 'doc2');
      expect(results[0].termFrequency, 2);
      // Positions in doc2: 'A' (0), 'quick' (1), 'brown' (2), 'dog' (3), 'outpaces' (4), 'a' (5), 'quick' (6), 'fox' (7)
      expect(results[0].positions, [1, 6]);
      
      expect(results[1].documentId, 'doc1');
      expect(results[1].termFrequency, 1);
      expect(results[1].positions, [1]);
    });
    
    test('Handles empty query or missing term', () async {
      await engine.indexDocument('doc1', 'Hello world');
      
      expect(engine.search(''), isEmpty);
      expect(engine.search('missing'), isEmpty);
    });

    test('Case insensitivity and punctuation removal', () async {
      await engine.indexDocument('doc1', 'Hello, World!');
      
      final results = engine.search('hello');
      expect(results.length, 1);
      expect(results[0].positions, [0]);
      
      final results2 = engine.search('world');
      expect(results2.length, 1);
      expect(results2[0].positions, [1]);
    });
  });
}
