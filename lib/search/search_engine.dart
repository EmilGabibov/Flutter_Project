import 'package:flutter/foundation.dart';

class SearchHit {
  final String documentId;
  final int termFrequency;
  final List<int> positions;

  SearchHit({
    required this.documentId,
    required this.termFrequency,
    required this.positions,
  });
}

class TokenizationResult {
  final String documentId;
  // Map of Term -> List of Positions
  final Map<String, List<int>> invertedIndex;

  TokenizationResult(this.documentId, this.invertedIndex);
}

class _TokenizationTask {
  final String documentId;
  final String text;
  
  _TokenizationTask(this.documentId, this.text);
}

class SearchEngine {
  // Vocabulary -> Document ID -> Positions
  final Map<String, Map<String, List<int>>> _index = {};

  /// Add a document to the index asynchronously using isolates
  Future<void> indexDocument(String documentId, String text) async {
    final task = _TokenizationTask(documentId, text);
    final result = await compute(_tokenize, task);
    
    // Merge the result safely in the main isolate
    _mergeIndex(result);
  }

  /// Internal tokenization logic that runs in an isolate
  static TokenizationResult _tokenize(_TokenizationTask task) {
    final Map<String, List<int>> localIndex = {};
    
    // Simple tokenizer: lowercase, replace punctuation with spaces, split by whitespace
    final normalized = task.text.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), ' ');
    final tokens = normalized.split(RegExp(r'\s+'));
    
    for (int i = 0; i < tokens.length; i++) {
      final token = tokens[i].trim();
      if (token.isNotEmpty) {
        localIndex.putIfAbsent(token, () => []).add(i);
      }
    }
    
    return TokenizationResult(task.documentId, localIndex);
  }

  /// Merge an isolated index result into the main shared index
  void _mergeIndex(TokenizationResult result) {
    for (final entry in result.invertedIndex.entries) {
      final term = entry.key;
      final positions = entry.value;
      
      _index.putIfAbsent(term, () => {})[result.documentId] = positions;
    }
  }

  /// Search for a term and rank hits by term frequency using merge sort
  List<SearchHit> search(String query) {
    final term = query.toLowerCase().trim();
    if (term.isEmpty || !_index.containsKey(term)) {
      return [];
    }

    final docMap = _index[term]!;
    final unsortedHits = docMap.entries.map((e) => SearchHit(
      documentId: e.key,
      termFrequency: e.value.length,
      positions: e.value,
    )).toList();

    // Use custom merge sort for ranking
    return _mergeSortHits(unsortedHits);
  }

  /// O(n log n) merge sort implementation to rank hits by TF (descending)
  List<SearchHit> _mergeSortHits(List<SearchHit> list) {
    if (list.length <= 1) {
      return list;
    }

    final middle = list.length ~/ 2;
    final left = _mergeSortHits(list.sublist(0, middle));
    final right = _mergeSortHits(list.sublist(middle));

    return _merge(left, right);
  }

  List<SearchHit> _merge(List<SearchHit> left, List<SearchHit> right) {
    final List<SearchHit> result = [];
    int i = 0;
    int j = 0;

    while (i < left.length && j < right.length) {
      // Sort descending by term frequency
      if (left[i].termFrequency >= right[j].termFrequency) {
        result.add(left[i]);
        i++;
      } else {
        result.add(right[j]);
        j++;
      }
    }

    while (i < left.length) {
      result.add(left[i]);
      i++;
    }

    while (j < right.length) {
      result.add(right[j]);
      j++;
    }

    return result;
  }
}
