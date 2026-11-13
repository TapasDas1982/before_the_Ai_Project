## AI project rules (Before the AI Project)

This repository follows the **Before the AI Project** rule pack, installed in `.ai-rules/`.

**Always read:** `.ai-rules/rules/00-core.md` (short: non-negotiables and definition of done).

**Read when relevant:** `.ai-rules/project/OVERRIDES.md` (project exceptions; these win over the rules), `.ai-rules/project/PROJECT_MAP.md` (commands, conventions, what not to touch), and only the topic files the task touches:

| Task touches… | Read |
|---|---|
| any external model, SDK, API, parameter, version or price | `.ai-rules/rules/01-freshness.md` + `.ai-rules/project/FRESHNESS.md` |
| project structure, context files, prompts, tools, MCP servers | `.ai-rules/rules/02-mapping.md` |
| where code goes, model/vector store adapters, structured output | `.ai-rules/rules/03-layering.md` |
| retrieval, embeddings, chunking, indexes | `.ai-rules/rules/04-rag.md` |
| agent loops, tools, context, memory, multi-agent, MCP | `.ai-rules/rules/05-harness.md` |
| tests, quality, prompt or model changes | `.ai-rules/rules/06-evals.md` + `.ai-rules/project/EVALS.md` |
| untrusted input, secrets, PII, permissions, dependencies | `.ai-rules/rules/07-security.md` |
| cost, caching, latency, logging, retries, releases | `.ai-rules/rules/08-ops.md` |
| choosing or upgrading models, frameworks, DBs, tooling | `.ai-rules/rules/09-technology.md` + `.ai-rules/project/DECISIONS.md` |
| a specific price, limit, parameter or spec version | `.ai-rules/rules/99-dated-facts.md` (then verify at the source) |

**Golden rule:** verify current versions, parameters and APIs in official docs; don't rely on memory. Record what you verified in `.ai-rules/project/FRESHNESS.md`.
