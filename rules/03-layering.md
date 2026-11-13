# 03 · Layering

AI projects rot fastest where model calls leak into everything. Keep AI behind clear layers so you can swap models, change retrieval or add evals without rewriting the app.

## Reference layers

```
┌───────────────────────────────────────────────┐
│ 1. Interface      UI, API routes, CLI, bots    │
├───────────────────────────────────────────────┤
│ 2. Application    use cases, orchestration,    │
│                   agent loops, sessions        │
├───────────────────────────────────────────────┤
│ 3. AI capability  prompts, tools, retrieval,   │
│                   output schemas/validation    │
├───────────────────────────────────────────────┤
│ 4. Adapters       model client or gateway,     │
│                   embeddings, vector store,    │
│                   rerankers, MCP clients       │
├───────────────────────────────────────────────┤
│ 5. Data           sources, ingestion, storage  │
└───────────────────────────────────────────────┘
     Cross-cutting: config · observability · evals · security
```

## Rules

1. **Dependencies point down.** A layer may use the layers below it, never above. The interface never calls a provider SDK directly.
2. **One model adapter.** All LLM calls go through a single adapter or gateway. It owns: provider choice, **model ID and API version pins**, supported-parameter validation, retries, timeouts, fallbacks, **cache-breakpoint placement, deterministic tool ordering**, and emitting token, cost and prompt-version telemetry on every call. Provider SDK imports outside it are a review blocker.
3. **One embeddings adapter, one vector store adapter.** Same reason: you will change these.
4. **Prompts live in layer 3** as versioned templates with typed inputs. Business logic passes data in; it doesn't build prompt strings.
5. **Structured output at the boundary.** Layer 3 returns typed, validated objects to layer 2. Use the provider's **native constrained decoding** (structured outputs or strict tool schemas) where supported. JSON mode and assistant prefill are legacy. Still handle refusals, truncation and business-rule validation.
6. **Configuration, not constants.** Model IDs, API versions, **whatever generation parameters the provider supports**, top-k, chunk sizes and thresholds live in config so evals can sweep them.
7. **Stable prefix by construction.** Layer 3 assembles prompts in a fixed order (tool definitions → system prompt → reference material → conversation history → per-request data), with no timestamps, request IDs or random ordering in the stable part. This is what makes prompt caching work.
8. **Deterministic code stays deterministic.** Don't use an LLM for what a regex, a lookup or plain code does reliably.
9. **Evals hook in at layer 3** so you can test retrieval and prompts without the UI.

## Suggested folder shape (adapt it, don't worship it)

```
src/
  interface/      # routes, handlers, UI glue
  app/            # use cases, agent loops, workflows
    session/      # append-only event log for agent runs (resume, audit)
  ai/
    prompts/      # versioned prompt templates
    tools/        # tool definitions + implementations
    retrieval/    # query building, hybrid search, rerank
    schemas/      # output schemas + validators
  adapters/
    llm/          # the single model client or gateway config
    embeddings/
    vectorstore/
    mcp/          # MCP clients + pinned tool manifests
  data/
    ingest/       # loaders, cleaners, chunkers
evals/            # datasets, graders, runners, results (portable formats)
```

Record your actual layout in `PROJECT_MAP.md`.
