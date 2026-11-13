# 02 · Mapping

Agents and new teammates fail in the same way: they don't know where things are, so they guess, duplicate or break boundaries. A short, current project map fixes most of it.

## Rules

1. **One map, one place.** `.ai-rules/project/PROJECT_MAP.md` is the source of truth for structure. Keep it under ~150 lines so it fits in context cheaply.
2. **Map what isn't obvious from `ls`:**
   - what the project does, in two sentences
   - layers and which folders implement them (see `03-layering.md`)
   - entry points: how to run, test, ingest, evaluate
   - where prompts live, where tools are defined, where the model adapter is
   - data flows: user request → retrieval → model → validation → response
   - external services and what each is used for
   - "Here be dragons": fragile areas, generated code, things not to touch
3. **Update the map in the same change** that moves, adds or removes a module, a data source, a tool or an external service.
4. **Prompts are code.** Keep them in versioned files (e.g. `prompts/`), not inline strings scattered through business logic. List them in the map.
5. **Tools are inventoried.** Every tool or function an agent can call is listed with what it does, what it can touch and whether it has side effects.
6. **Data sources are inventoried.** Every corpus that feeds RAG is listed with its owner, format, size and refresh schedule.

## Large repos

- Add a short `README.md` (5–20 lines) in each top-level module folder that explains its job and boundaries. The root map links to these instead of repeating them.
- Generated maps (tree dumps, symbol indexes) are fine as **supplements**. Store them under `.ai-rules/project/generated/` and don't hand-edit them. The hand-written map explains *why*; generated maps show *what*.

## Context loading order (for agents)

1. `AGENTS.md`
2. `.ai-rules/rules/00-core.md`
3. `.ai-rules/project/PROJECT_MAP.md`
4. `.ai-rules/project/OVERRIDES.md`
5. Only then: the rule file(s) and source files relevant to the task
