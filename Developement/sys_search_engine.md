# 05: Local Search Engine Architecture

**Core Function:** Local text search and retrieval over device-held content. The current implementation is intentionally small: Drift stores document metadata, a pure-Dart inverted index lives in memory, and document tokenization runs off the UI thread with `compute`.

## Current Implemented Architecture

### 1. Metadata Tier
* **Drift metadata store:** `SearchDocuments` persists local document metadata such as `document_id`, `title`, `author`, `publication_date`, `source`, `updated_at`, and `is_synced`.
* **Result join path:** Search returns ranked document IDs from the in-memory index, then `database.dart` resolves those IDs back to Drift metadata for final display.
* **Current boundary:** Metadata is persistent; posting lists are not. Search content must be re-indexed in memory after app restart unless a future persistence task extends the design.

### 2. Index Tier
* **Inverted index mapping:** Vocabulary maps to `document_id -> positions` for fast exact-term lookup.
* **Hash maps in memory:** The active index is a Dart `Map<String, Map<String, List<int>>>`.
* **Ranking:** Results are ranked by term frequency using the custom merge-sort path already implemented in `lib/search/search_engine.dart`.
* **Query scope:** The current engine supports direct token lookup, not fuzzy matching, stemming, phrase ranking, or semantic search.

### 3. Concurrency Tier
* **Off-main-thread tokenization:** `SearchEngine.indexDocument` uses Flutter `compute` to tokenize one document off the UI thread, then merges the result back on the main isolate.
* **Current concurrency model:** This is isolate-based task isolation, not a true multi-consumer shared-memory pipeline. There are no mutexes/semaphores because the main isolate owns index mutation.
* **Reasonable ceiling:** The current design is appropriate for small to moderate local corpora and avoids UI jank without introducing a complex worker scheduler.

## Deferred Scaling Path

* **Persistent posting lists:** If the corpus grows, move posting lists into Drift/SQLite or FTS instead of keeping everything in memory.
* **Batch indexing:** If indexing many documents becomes slow, add chunked/background batch scheduling rather than indexing everything eagerly at startup.
* **Linguistic quality:** Stemming, normalization, phrase search, multilingual tokenization, and semantic ranking are separate follow-up concerns.
* **Advanced SQL ranking:** Window-function ranking is not part of the current implementation and should only be added if search persistence moves into SQL-backed posting lists.
