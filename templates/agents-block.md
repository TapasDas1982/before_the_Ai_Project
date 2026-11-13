## AI project rules (Before the AI Project)

This repository follows the **Before the AI Project** rule pack, installed in `.ai-rules/`.

**Before any task, read in this order:**

1. `.ai-rules/rules/00-core.md`: non-negotiables and definition of done
2. `.ai-rules/project/PROJECT_MAP.md`: what this project is and where things live
3. `.ai-rules/project/OVERRIDES.md`: project-specific exceptions (these win over the rules)

**Then load only what the task touches:**

| Task touches… | Read |
|---|---|
| any external model, SDK, API, version or price | `.ai-rules/rules/01-freshness.md` + `.ai-rules/project/FRESHNESS.md` |
| project structure, new modules, prompts, tools | `.ai-rules/rules/02-mapping.md` |
| where code goes, model and vector store adapters | `.ai-rules/rules/03-layering.md` |
| retrieval, embeddings, chunking, indexes | `.ai-rules/rules/04-rag.md` |
| agent loops, tools, context, memory | `.ai-rules/rules/05-harness.md` |
| tests, quality, prompt or model changes | `.ai-rules/rules/06-evals.md` + `.ai-rules/project/EVALS.md` |
| user input, secrets, PII, tool permissions | `.ai-rules/rules/07-security.md` |
| cost, latency, logging, retries, releases | `.ai-rules/rules/08-ops.md` |
| choosing or upgrading models, frameworks, DBs | `.ai-rules/rules/09-technology.md` + `.ai-rules/project/DECISIONS.md` |

**Golden rule:** verify current versions and APIs in official docs; don't rely on memory. Record what you verified in `.ai-rules/project/FRESHNESS.md`.
