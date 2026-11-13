# Project map

> Only what an agent **can't** infer from the code, `ls` or the README. Keep it under ~150 lines, written by a human. Don't commit an unedited LLM-generated version. See `.ai-rules/rules/02-mapping.md`.
> Last reviewed: YYYY-MM-DD

## Commands

| Task | Command |
|---|---|
| Install | |
| Run locally | |
| Test | |
| Run evals | |
| Ingest / re-index data | |

## Conventions that aren't obvious

<!-- Non-default rules: naming, which layer owns what, what must never import what, where prompts/tools/the model adapter/eval sets live. -->

## Here be dragons

<!-- Fragile areas, generated code, things agents must not touch, and why. -->

## Non-obvious data flows

<!-- Only flows the code doesn't make obvious, e.g. "user request → permission filter → hybrid search → rerank → model → schema validation". -->

## Tools and MCP servers available to agents

| Tool / server | What it does | Side effects (read/write/destructive/external) | Approval needed? | Pinned version / description hash / scopes |
|---|---|---|---|---|

## Data sources (RAG)

| Source | Owner | Format | Size | Refresh schedule | Access rules |
|---|---|---|---|---|---|

## External services

| Service | Used for | Config / env var |
|---|---|---|
