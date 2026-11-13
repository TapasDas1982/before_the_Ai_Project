# 04 · RAG (Retrieval-Augmented Generation)

Most RAG failures are retrieval failures, not generation failures. Measure retrieval first.

## Before building

1. **Check whether you need RAG.** If the corpus is small (roughly under 200k tokens), mostly static and queried often, try putting it all in the prompt with prompt caching, and compare quality and cost. Even then, filter for relevance: accuracy drops as inputs grow and as similar-but-wrong passages pile up ("context rot", Chroma 2025). Choose RAG for large, changing, permissioned or citation-heavy corpora. Record the decision.
2. **For agents and code or file corpora, start with agentic search:** give the agent search tools (grep, find, keyword search) and let it search iteratively. Add embeddings when speed or corpus size requires them.
3. **Try managed retrieval as a baseline.** Some providers ship hybrid search, reranking and filters built in. Build your own only if it beats the baseline on your evals.
4. **Write 20+ real questions with known answers and source passages** before choosing chunk sizes or embedding models. Include unanswerable questions and questions surrounded by look-alike distractors. This is your retrieval eval (`06-evals.md`).
5. **Inventory the sources** in `PROJECT_MAP.md`: owner, format, size, update frequency, access rules.

## Ingestion

- **Clean before chunking.** Strip navigation, boilerplate, duplicated headers and footers. Keep headings, tables and lists intact.
- **Chunk by structure or recursively, about 300–800 tokens, 10–50% overlap, no chunks under ~200 tokens.** Then tune with evals. Semantic chunking is optional: in comparisons it often matched or lost to plain fixed-size chunking. Use it only if it wins on your data.
- **Give each chunk its context.** Losing document context hurts more than imperfect boundaries. Use **contextual retrieval**: an LLM writes 50–100 tokens situating each chunk in its document, prepended before both embedding and keyword indexing. Anthropic reported 49% fewer retrieval failures, and 67% with reranking added. Use prompt caching to keep it cheap. Late chunking is an alternative that needs no LLM pass.
- **Store metadata with each chunk:** title, section path, source ID or URL, `source_updated_at`, `ingested_at`, access-control tags, **embedding model and version**.
- **Stable IDs** from source ID + position or content hash, so re-ingestion updates instead of duplicating.
- **Deletes propagate.** Removed or changed sources tombstone their old chunks. Re-index whole changed documents rather than patching chunks.
- **Embedding migrations:** write to a second index or named vector, backfill in the background, run evals, then switch reads. Never mix vectors from two embedding models in one search.

## Retrieval

- **Hybrid by default:** keyword (BM25 or similar) plus vector search, combined with reciprocal rank fusion. **Tune fusion weights on labelled queries.** Untuned fusion can lose to plain BM25.
- **Rerank:** retrieve about 50–150 candidates, rerank with a cross-encoder or reranker, and pass about 5–20 chunks to the model.
- **Access control is enforced in retrieval, and fails closed:**
  - bind each query to the **end user's identity**, not a service account
  - filter by permission **inside** the vector or keyword query, not after
  - a chunk with **missing ACL data is not accessible**
  - track when ACLs were last synced
  - test that one tenant can't retrieve another's data (OWASP LLM08)
- **Rewrite queries** (expansion, decomposition, HyDE-style) only when evals show it helps. Each step adds latency.
- **GraphRAG** (or the cheaper LazyGraphRAG) only for relationship-heavy, multi-hop or corpus-wide summary questions, and only after plain RAG fails your evals. It often underperforms plain RAG on simple lookups.

## Generation

- **Cite sources.** Prefer the provider's **native citations feature** where available. Check citations mechanically: the cited passage exists and supports the claim.
- **Allow "I don't know".** The prompt lets the model say the answer isn't in the context, and your evals test that it does.
- **Retrieved text is untrusted data.** Wrap it in clear delimiters as one layer of defence, but rely on the containment rules in `07-security.md`. Retrieved documents can carry injection attacks.
- **Inject today's date** when questions can be time-sensitive.

## Measure (minimum set)

| Stage | Metric |
|---|---|
| Retrieval | recall@k / hit rate on golden questions, MRR or nDCG, context precision/recall |
| Generation | faithfulness (claims supported by context), answer correctness, citation accuracy, correct "no answer" on unanswerable cases |
| Security | cross-tenant leakage tests pass |
| System | latency p50/p95, cost per query |

Re-run on every change to chunking, contextualization, embeddings, fusion weights, reranker, prompt or model.
