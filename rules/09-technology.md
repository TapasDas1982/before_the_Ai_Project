# 09 · Technology choices & updates

This file deliberately doesn't name "the best model" or "the best vector DB". Any such list would be stale within months (`01-freshness.md`). It gives you **how to choose** and **how to keep up**. Time-sensitive specifics live in `99-dated-facts.md`.

## Choosing a model

1. Define the task and success criteria (from your evals) first.
2. Shortlist 2–3 current models from current provider docs: capability, context window, modalities, tool use, structured output, price, latency, data and region policy, **retirement date**.
3. Choose a direction. Either start with the most capable model to prove the task is possible and then step down, or start cheap and step up until evals pass. Both are valid.
4. Run **your** eval set on each. Public benchmarks are a hint; your evals decide.
5. Pick the cheapest model **and effort or reasoning level** that passes. Record choice, scores and date in `DECISIONS.md`.
6. Pin the model ID and API version in config. Expect a pinned model to last roughly a year or so, with a few months between deprecation notice and retirement (shorter for previews). Plan the migration when the notice arrives.

## Choosing a framework

- **Start with the provider SDK and your own thin adapter or gateway.** That's where provider neutrality belongs. Add a framework only when it clearly removes code you'd otherwise write and its current version is stable.
- Prefer libraries that are well maintained (recent releases, responsive issues), typed, show you the prompts they send, and are easy to step out of.
- Avoid deep framework lock-in in layers 2 and 3 (`03-layering.md`). Wrap it.

## Choosing a vector store / search

- **Evaluate managed retrieval as a baseline** (some providers bundle hybrid search, reranking and filters).
- Otherwise start with what you already run (e.g. Postgres with a vector extension, or your search engine) if it supports hybrid search at your scale.
- **Check permission-aware filtering and multi-tenancy** before choosing (`04-rag.md`, OWASP LLM08).
- Move to a dedicated vector database when evals or scale require it. Keep it behind the adapter.

## Choosing embeddings and rerankers

- Evaluate on your retrieval golden set (recall@k), not on leaderboards alone.
- Consider languages, domain, dimensions and storage cost, and whether you can self-host.
- Changing embeddings means re-indexing. Plan the dual-index migration (`04-rag.md`).

## Choosing eval and observability tooling

Criteria: self-hosting and data residency, native traces for your stack (OpenTelemetry GenAI), dataset versioning plus CI integration, human annotation with export, isolated agent trials, and **portability**: keep datasets and graders in your repo so you can leave. A small custom trace viewer often beats a generic UI for error analysis.

## Keeping up: the monthly update routine

```
[ ] Re-verify FRESHNESS.md rows past their window (models/APIs: 30 days; libraries: 90)
[ ] Check deprecation pages / shutdown dates for pinned models AND API versions
[ ] Check parameter support for pinned models (removed/rejected parameters)
[ ] Check the MCP spec version and any servers you depend on
[ ] Re-check caching rules, prices and rate-limit behaviour you rely on (99-dated-facts.md)
[ ] Model changed? → re-run evals; re-test whether harness scaffolding is still needed
[ ] Audit context files: size, contradictions, cross-tool loading (e.g. /memory)
[ ] Update dependencies; run evals; check security advisories
[ ] Try 1 promising new model/technique against the eval set (record in DECISIONS.md)
[ ] Re-run the Before the AI Project installer; skim its CHANGELOG.md
```

## Adopting a new technique

New techniques appear weekly. Adopt one only when:

1. it targets a failure you can see in your evals or production traces,
2. it measurably helps on your eval set, and
3. the added cost, latency and complexity is worth it.

Popular isn't the same as better. Semantic chunking and GraphRAG are both widely promoted, and both underperform simple baselines on many workloads. Record every experiment, including the ones that didn't help, in `DECISIONS.md`.
