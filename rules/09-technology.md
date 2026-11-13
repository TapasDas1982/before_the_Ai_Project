# 09 · Technology choices & updates

This file deliberately doesn't name "the best model" or "the best vector DB". Any such list would be stale within months (`01-freshness.md`). It gives you **how to choose** and **how to keep up**.

## Choosing a model

1. Define the task and the success criteria (from your evals) first.
2. Shortlist 2–3 current models from current provider docs: capability tier, context window, modalities, tool use, structured output, price, latency, data and region policy.
3. Run **your** eval set on each. Public benchmarks are a hint; your evals decide.
4. Pick the cheapest model that passes. Record the choice, scores and date in `DECISIONS.md`.
5. Pin the model ID in config. Re-evaluate when a new model generation ships or every freshness window.

## Choosing a framework

- **Start with the provider SDK + your own thin adapter.** Add a framework only when it clearly removes code you would otherwise write *and* you have checked that its current version is stable.
- Prefer libraries that are well maintained (recent releases, responsive issues), typed and easy to step out of.
- Avoid deep framework lock-in in layer 2 or 3 (`03-layering.md`). Wrap it.

## Choosing a vector store / search

- Start with what you already run (e.g. Postgres with a vector extension, or your existing search engine) if it supports hybrid search and your scale.
- Move to a dedicated vector database when evals or scale require it: filtering performance, recall at your size, multi-tenancy, operational needs.
- Whatever you pick, keep it behind the vector store adapter.

## Choosing embeddings and rerankers

- Evaluate on your retrieval golden set (recall@k), not on leaderboards alone.
- Consider languages, domain (code, legal, medical), dimensions and storage cost, and whether you can host it yourself.
- Changing embeddings = re-indexing. Plan for it (`04-rag.md`).

## Keeping up: the update routine

Set a recurring reminder, monthly or at least every freshness window:

```
[ ] Re-verify every row in FRESHNESS.md older than the window
[ ] Read changelogs and deprecation notices for each provider/SDK/framework in use
[ ] Note retirement dates of pinned models; plan migrations before them
[ ] Try 1 promising new model/technique against the eval set (record result in DECISIONS.md)
[ ] Update dependencies; run evals; check security advisories
[ ] Pull the latest version of this rule pack (re-run the installer) and skim CHANGELOG.md
```

## Adopting a new technique

New techniques appear weekly (new retrieval tricks, agent patterns, prompting methods). Adopt one only when:

1. it targets a failure you can see in your evals or production logs,
2. you have tested it on your eval set and it measurably helps, and
3. the added cost, latency and complexity is worth it.

Record the experiment, whether it helped or not, in `DECISIONS.md` so nobody repeats it blindly.
