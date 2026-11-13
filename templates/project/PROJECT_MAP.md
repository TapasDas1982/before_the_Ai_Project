# Project map

> Keep this under ~150 lines. Update it in the same change that alters structure. See `.ai-rules/rules/02-mapping.md`.
> Last reviewed: YYYY-MM-DD

## What this project is

<!-- Two sentences: what it does and who it is for. -->

## How to run

| Task | Command |
|---|---|
| Install | |
| Run locally | |
| Test | |
| Run evals | |
| Ingest / re-index data | |

## Layers → folders

| Layer | Folder(s) | Notes |
|---|---|---|
| Interface | | |
| Application / orchestration | | |
| AI capability (prompts, tools, retrieval, parsing) | | |
| Adapters (LLM, embeddings, vector store) | | |
| Data / ingestion | | |
| Evals | | |

## Request flow

```
user → … → retrieval → model → validation → response
```

## Prompts

| Prompt | File | Used by | Version |
|---|---|---|---|

## Tools available to agents

| Tool | What it does | Side effects (read/write/destructive/external) | Approval needed? |
|---|---|---|---|

## Data sources (RAG)

| Source | Owner | Format | Size | Refresh schedule | Access rules |
|---|---|---|---|---|---|

## External services

| Service | Used for | Config / env var |
|---|---|---|

## Here be dragons

<!-- Fragile areas, generated code, things agents must not touch. -->
