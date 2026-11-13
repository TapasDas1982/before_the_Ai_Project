# 04 · RAG (Retrieval-Augmented Generation)

Most RAG failures are retrieval failures, not generation failures. Measure retrieval first.

## Before building

1. **Check whether you need RAG.** If the corpus fits comfortably in the model's context and changes rarely, try long-context prompting (with prompt caching) first and compare quality and cost. Record the decision.
2. **Write 20+ real questions with known answers and source passages** before choosing chunk sizes or embedding models. That is your retrieval eval (`06-evals.md`).
3. **Inventory the sources** in `PROJECT_MAP.md`: owner, format, size, update frequency, access rules.

## Ingestion

- **Clean before chunking.** Strip navigation, boilerplate, duplicated headers and footers. Keep headings, tables and lists intact. Garbage in becomes confident garbage out.
- **Chunk by structure first** (headings, sections, functions for code), then by size. Start around a few hundred tokens with modest overlap, then **tune with evals**, not intuition.
- **Keep context with each chunk:** document title, section path, source URL or ID, timestamps, access-control tags. Prepending a short document- or section-level summary to each chunk before embedding often improves recall.
- **Stable IDs.** Chunk IDs come from source ID + position or content hash, so re-ingestion updates chunks instead of duplicating them.
- **Track freshness:** store `source_updated_at` and `ingested_at` on every chunk. Schedule refreshes per source and remove chunks whose sources were deleted.
- **Version the pipeline.** Changing the embedding model or chunker means re-indexing into a new index or namespace and running evals before you switch traffic.

## Retrieval

- **Hybrid by default:** combine keyword (BM25 or similar) and vector search. Pure vector search misses exact terms, IDs, codes and names.
- **Rerank** the top candidates with a reranker or cross-encoder before sending them to the model. It is usually the cheapest big quality win.
- **Filter with metadata** (tenant, permissions, date, product) **before** ranking, never after generation.
- **Rewrite queries** (expansion, decomposition, HyDE-style) only when evals show it helps. Each step adds latency.
- **Enforce access control in retrieval.** A user must never get chunks they couldn't open in the source system.

## Generation

- **Cite sources.** The answer references the chunk or document IDs it used, and the UI can show them.
- **Allow "I don't know".** The prompt explicitly lets the model say the answer isn't in the provided context. Test that it does.
- **Separate instructions from retrieved text.** Wrap retrieved content in clear delimiters and treat it as data. Retrieved documents can contain prompt injections (`07-security.md`).
- **Inject today's date** when questions can be time-sensitive.

## Measure (minimum set)

| Stage | Metric |
|---|---|
| Retrieval | recall@k / hit rate on golden questions, MRR or nDCG |
| Generation | faithfulness (claims supported by context), answer correctness, citation accuracy |
| System | latency p50/p95, cost per query, "no answer" rate |

Re-run on every change to chunking, embeddings, retrieval parameters, reranker, prompt or model.
