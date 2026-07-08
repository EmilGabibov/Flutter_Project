# 05: Multithreaded Inverted Index Engine

**Core Function:** High-performance text search and retrieval system. Test the engine by indexing classical literary corpora (e.g., evaluating semantic weights and English equivalents of Ferdowsi, Saadi, or Shafiei Kadkani).

## Execution Directives

The workload for this system is strictly divided by architectural layer:

### 1. Database Tier
* **Task:** Relational Schema Creation & SQL Normalization.
* **3NF Relational Schema:** Store persistent document metadata: `DocumentID`, `Author`, `Publication Date`, `Source`.
* **Advanced SQL (Window Functions):** Use `RANK()` or `ROW_NUMBER()` combined with `JOIN` operations to merge the in-memory search hits with persistent relational metadata, generating the final output.

### 2. Algorithmic Tier
* **Task:** Core Inverted Index.
* **Inverted Index Mapping:** Map vocabulary to document IDs and positions for O(1) retrieval.
* **Hash Tables:** Store the inverted index dictionary in memory to minimize time complexity during query execution.
* **Merge Sort:** Implement $O(n \log n)$ sorting to rank search results by term frequency before returning them to the user.

### 3. Operating Systems Tier
* **Task:** Thread Synchronization & Resource Allocation.
* **Producer-Consumer Synchronization:** Construct a multithreaded indexing pipeline. Producer threads parse documents and place text chunks into a bounded buffer. Consumer threads read the buffer, tokenize text, and populate the shared inverted index.
* **Mutexes/Semaphores:** Prevent race conditions when multiple consumer threads attempt to write to the exact same hash table index simultaneously. Bind the database querying and algorithmic processing strictly without deadlocks.
