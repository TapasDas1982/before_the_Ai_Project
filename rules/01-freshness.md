# 01 · Freshness

AI models, including the one reading this, were trained on a snapshot of the past. On APIs released after their training cutoff, models score far worse (one 2025 benchmark: 56% before cutoff vs 33% after), and supplying current docs recovers part of the gap. Freshness rules keep a project off deprecated APIs, retired models and stale prices.

## Rules

1. **Treat remembered facts as hypotheses.** Before you write code that depends on any of these, confirm it against the official, current source:
   - model IDs, availability, context and output limits, **retirement dates**
   - API versions and **which request parameters a model still accepts**
   - SDK package names, method signatures, required parameters
   - framework APIs, which break often
   - pricing, caching rules, rate limits, quotas
   - protocol versions you depend on (e.g. the MCP spec)
   - vector database APIs and index options
2. **Prefer primary sources.** Official docs, changelogs and deprecation pages → official SDK source or types → release notes → recent reputable articles. Forum answers and old blog posts come last.
3. **Record what you verified.** Every external model, SDK, service, protocol and framework gets a row in `.ai-rules/project/FRESHNESS.md` with the version and the **date verified**.
4. **Re-verify on a schedule.** Model and API rows: every **30 days**, or automate it (deprecation-page watch, a provider's shutdown-date field, a CI check). Library and service rows: every **90 days**. Recent provider notice periods are 60 days to a few months, and previews can retire in about two weeks.
5. **Pin precisely.** Commit lock files. Pin the **most specific model ID the provider offers** (a dated snapshot where one exists; some providers now issue undated IDs that still retire). Pin the **API version** too. Use floating aliases only in prototypes, and say so.
6. **Parameters retire too.** Check that the parameters you send are still supported for that model and API version, not just that the model exists. Sampling parameters, assistant prefill and forced tool choice have all been removed or rejected on recent APIs. See `99-dated-facts.md`.
7. **No preview or experimental models in production.**
8. **No invented APIs.** If you can't find a method in current docs or types, it doesn't exist. Don't write it hoping it works.
9. **Put current docs in context explicitly.** Point agents at the provider's docs (an `llms.txt` file, Markdown versions of doc pages, or a docs MCP server) and state the exact library versions in use. Agents often ignore docs they were given, so tell them to follow them.
10. **Date your knowledge.** When docs, prompts or comments state a fact that can go stale ("the latest model is…", "max context is…"), add the date: `(verified YYYY-MM-DD)`. Keep such facts in one place (`99-dated-facts.md`, `FRESHNESS.md`) rather than scattered through code.

## Freshness for data, not just code

- **Indexes go stale.** Every RAG source has an owner, a refresh schedule, and `source_updated_at` / `ingested_at` timestamps. See `04-rag.md`.
- **Prompts that mention dates or "current" facts** get the date injected at runtime, not hard-coded.
- **Eval sets go stale.** Review them when the product or source data changes.
- **Context files go stale.** Review `AGENTS.md` and the project map monthly for size, contradictions and dead references.

## Agent checklist before writing integration code

```
[ ] Which external APIs/SDKs/models/protocols does this touch?
[ ] Are they in FRESHNESS.md and verified within their window?
[ ] Do the parameters I'm sending still exist for this model + API version?
[ ] If not verified: read current docs → write code → add/update the row
[ ] Any new dependency: exists in the registry, intended package, maintained (anti-slopsquatting)
[ ] Any deprecation notice on the pages I read? → add to FRESHNESS.md watchlist with its date
```
