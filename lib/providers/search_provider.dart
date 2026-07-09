import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../database/database.dart';
import '../search/search_engine.dart';
import 'database_provider.dart';

part 'search_provider.g.dart';

class SearchResult {
  final SearchDocument document;
  final int termFrequency;

  SearchResult(this.document, this.termFrequency);
}

@riverpod
SearchEngine searchEngine(Ref ref) {
  return SearchEngine();
}

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  Future<List<SearchResult>> build(String query) async {
    if (query.isEmpty) return [];

    final engine = ref.watch(searchEngineProvider);
    final hits = engine.search(query);

    if (hits.isEmpty) return [];

    final db = ref.watch(databaseProvider);
    final documentIds = hits.map((h) => h.documentId).toList();
    final metadataList = await db.getSearchDocumentsByIds(documentIds);

    // Map to preserve ranking order
    final metadataMap = {for (var doc in metadataList) doc.documentId: doc};

    final results = <SearchResult>[];
    for (var hit in hits) {
      final meta = metadataMap[hit.documentId];
      if (meta != null) {
        results.add(SearchResult(meta, hit.termFrequency));
      }
    }

    return results;
  }
}
