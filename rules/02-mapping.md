# 02 · Mapping

Agents and new teammates fail the same way: they don't know where things are, so they guess, duplicate or break boundaries. A short map helps. A long one hurts. A peer-reviewed 2026 study (arXiv 2602.11988) found that context files raised agent cost by more than 20% without generally improving task success, that repository overviews didn't help, and that LLM-generated files slightly hurt. So the map holds only what an agent can't work out for itself.

## Rules

1. **One map, kept short.** `.ai-rules/project/PROJECT_MAP.md` stays under ~150 lines. **Never commit an unedited LLM-generated map.** Write it by hand or edit generated drafts hard.
2. **Lead with what can't be inferred:**
   - exact commands: install, run, test, evals, ingest
   - non-default conventions and boundaries (which layer owns what, what must not import what)
   - "here be dragons": fragile areas, generated code, things not to touch
   - where prompts, tools, the model adapter and eval sets live
   - data flows that aren't obvious from the code

   Leave out anything `ls`, the README or the code already tells an agent.
3. **Update the map in the same change** that moves, adds or removes a module, a data source, a tool or an external service.
4. **Prompts are code.** Keep them in versioned files (e.g. `prompts/`), not inline strings scattered through business logic.
5. **Inventory every tool and MCP server** an agent can call: what it does, what it can touch, read / write / destructive / external, whether it needs approval. For MCP servers also record the pinned version, a hash of the tool descriptions and the granted scopes (see `07-security.md`).
6. **Inventory every RAG data source:** owner, format, size, refresh schedule, access rules.
7. **Check the map earns its keep.** Every so often, run 3–5 real tasks with and without it. If it doesn't help, cut it down.

## Cross-tool context files

- **One canonical `AGENTS.md`**, bridged to each tool rather than copied: `CLAUDE.md` imports it with `@AGENTS.md` (Claude Code skips `AGENTS.md` when a `CLAUDE.md` exists), Copilot and Cursor read pointers, and Gemini CLI can be configured to read `AGENTS.md`. The installer sets this up.
- **Respect size limits.** Some tools cap or truncate context files. Keep each file small. See `99-dated-facts.md`.
- **Prefer path-scoped rules over a bigger root file:** Claude Code `.claude/rules/` with `paths:`, Cursor rule globs, Copilot `applyTo:`, nested `AGENTS.md` in monorepo packages.
- **Hard rules belong in tooling, not prose.** Use hooks, permission settings, linters and CI to enforce them. Context files are advice; agents can ignore advice.
- **Verify what actually loads** (e.g. `/memory` in Claude Code or Gemini CLI) after changing these files.

## Large repos

- A 5–20 line `README.md` in each top-level module explains its job and boundaries. The root map links to these instead of repeating them.
- Generated maps (tree dumps, symbol indexes) are supplements. Store them under `.ai-rules/project/generated/`, don't hand-edit them, and don't load them by default.

## Context loading order (for agents)

1. Always: `AGENTS.md`, `.ai-rules/rules/00-core.md`
2. When relevant: `.ai-rules/project/OVERRIDES.md`, the parts of `PROJECT_MAP.md` you need
3. Then: the topic rule file(s) and source files for the task
