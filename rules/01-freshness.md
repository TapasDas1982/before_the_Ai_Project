# 01 · Freshness

AI models, including the one reading this, were trained on a snapshot of the past. In AI tooling, six months is a long time. Freshness rules keep a project from being built on deprecated APIs, retired models and stale prices.

## Rules

1. **Treat remembered facts as hypotheses.** Before you write code that depends on any of the following, confirm it against the **official, current** source:
   - model IDs, model availability, context window, output limits
   - SDK package names, method signatures, required parameters
   - framework APIs (LangChain, LlamaIndex, Vercel AI SDK, etc.), which break often
   - pricing, rate limits, quotas
   - vector database APIs and index options
   - security advisories for the dependencies you add
2. **Prefer primary sources.** Use, in this order: official docs or changelog → official SDK source or types → release notes → reputable recent articles. Forum answers and old blog posts are last.
3. **Record what you verified.** Every external model, SDK, service and framework gets a row in `.ai-rules/project/FRESHNESS.md` with the version and the **date verified**.
4. **Re-verify when stale.** If a row is older than the project's freshness window (default **90 days**; set yours in `FRESHNESS.md`), re-check it before relying on it.
5. **Pin versions.** Lock files are committed. Model IDs are pinned to a dated or versioned ID where the provider offers one, not a floating alias, in production. Use aliases only in prototypes, and say so.
6. **No invented APIs.** If you can't find a method in current docs or types, it doesn't exist. Don't write it hoping it will work.
7. **Date your knowledge.** When docs, prompts or comments state a fact that can go stale ("the latest model is…", "max context is…"), add the date: `(verified 2026-11-13)`.

## Freshness for data, not just code

- **Indexes go stale too.** Every RAG source has an owner, a refresh schedule and a `last_ingested_at` timestamp. See `04-rag.md`.
- **Prompts mentioning dates or "current" facts** should get the date injected at runtime, not hard-coded.
- **Eval sets go stale.** Review golden examples when the product or source data changes.

## Agent checklist before writing integration code

```
[ ] Which external APIs/SDKs/models does this touch?
[ ] Are they in FRESHNESS.md and verified within the window?
[ ] If not: look up current docs → write code → add/update the row
[ ] Any deprecation notices on the pages I read? → note them in FRESHNESS.md
```
