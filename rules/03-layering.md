# 03 · Layering

AI projects rot fastest where model calls leak into everything. Keep AI behind clear layers so you can swap models, change retrieval or add evals without rewriting the app.

## Reference layers

```
┌───────────────────────────────────────────────┐
│ 1. Interface      UI, API routes, CLI, bots    │
├───────────────────────────────────────────────┤
│ 2. Application    use cases, orchestration,    │
│                   agent loops, workflows       │
├───────────────────────────────────────────────┤
│ 3. AI capability  prompts, tools, retrieval,   │
│                   output parsing/validation    │
├───────────────────────────────────────────────┤
│ 4. Adapters       model client, embeddings,    │
│                   vector store, rerankers      │
├───────────────────────────────────────────────┤
│ 5. Data           sources, ingestion, storage  │
└───────────────────────────────────────────────┘
     Cross-cutting: config · observability · evals · security
```

## Rules

1. **Dependencies point down.** A layer may use the layers below it, never above. The interface never calls a provider SDK directly.
2. **One model adapter.** All LLM calls go through a single adapter (e.g. `llm/client.*`) that handles provider choice, retries, timeouts, token logging and fallbacks. Provider SDK imports outside the adapter are a review blocker.
3. **One embeddings adapter, one vector store adapter.** Same reason: you will change these.
4. **Prompts live in layer 3** as versioned templates with typed inputs. Business logic passes data in; it doesn't build prompt strings.
5. **Structured output at the boundary.** Layer 3 returns typed, validated objects (schema / JSON mode / tool calls), not raw strings, to layer 2.
6. **Configuration, not constants.** Model IDs, temperatures, top-k, chunk sizes and thresholds live in config so evals can sweep them.
7. **Deterministic code stays deterministic.** Don't use an LLM for what a regex, a lookup or plain code does reliably. Use the model where judgment or language is actually needed.
8. **Evals hook in at layer 3** so you can test retrieval and prompts without the UI.

## Suggested folder shape (adapt it, don't worship it)

```
src/
  interface/      # routes, handlers, UI glue
  app/            # use cases, agent loops, workflows
  ai/
    prompts/      # versioned prompt templates
    tools/        # tool definitions + implementations
    retrieval/    # query building, hybrid search, rerank
    parsing/      # output schemas + validators
  adapters/
    llm/          # the single model client
    embeddings/
    vectorstore/
  data/
    ingest/       # loaders, cleaners, chunkers
evals/            # golden sets, runners, reports
```

Record your actual layout in `PROJECT_MAP.md`.
