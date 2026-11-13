# Changelog

All notable changes to the rule pack. Versions follow [SemVer](https://semver.org/):
**major** = a rule changes meaning or the install layout changes · **minor** = new rules or sections · **patch** = wording fixes and clarifications.

## [1.1.0] - 2026-11-13

Updated against 2025–2026 primary sources (Anthropic, OpenAI, Google, OWASP, OpenTelemetry, MCP spec, peer-reviewed research).

### Added
- `rules/99-dated-facts.md`: prices, limits, parameters and spec versions with verified dates and sources, re-checked monthly.
- Core rule 8, "Scaffolding is temporary": harness workarounds are re-tested on model changes.
- Security: lethal-trifecta check as the lead injection rule, named containment patterns, MCP server rules (pinned/hashed tool descriptions, no token passthrough, SSRF), safe rendering (no auto-loaded external images), slopsquatting checks, ML-BOM, OWASP Agentic Top 10.
- Harness: workflow-level tools, tool search for large tool sets, blocking guardrails, single-writer multi-agent, skeptical evaluator, long-running agent pattern, MCP and Agent Skills.
- Evals: read-traces-first error analysis, three suite tiers, pass^k / pass@k, agent eval rules (outcome grading, isolated trials), online evals, portable eval assets.
- RAG: contextual retrieval, agentic search first for agents and code, chunk size ranges, rerank depths, fail-closed access control, embedding migration, native citations, GraphRAG guidance.
- Ops: OpenTelemetry GenAI conventions, cache-write costs, spend-limit and mid-stream error handling, release gates, CI check for model retirement.
- Mapping: cross-tool context file rules, path-scoped rules, measuring whether the map helps.

### Changed
- **Evals:** removed "temperature 0" (sampling parameters are removed on some APIs); use multiple trials instead. Judges are binary and validated against human labels; any validated model may judge.
- **Layering:** native constrained decoding replaces JSON mode and prefill; config holds "supported generation parameters", not temperatures; the adapter owns API version pins and cache ordering.
- **Security:** delimiters are now defence in depth, not the main injection control.
- **Freshness:** 30-day re-verify window for models and APIs (90 for libraries); pin API version and record retirement dates; parameters retire too; no preview models in production.
- **Mapping / loading order:** only `AGENTS.md` and `00-core.md` are always loaded; the project map is limited to non-inferable facts, following evidence that long context files add cost without improving results.
- `AGENTS.md` block, `PROJECT_MAP.md`, `FRESHNESS.md` and `EVALS.md` templates updated to match. Existing project files are not overwritten; copy template changes across by hand if wanted.

## [1.0.0] - 2026-11-13

### Added
- Rule files: core, freshness, mapping, layering, RAG, harness, evals, security, ops, technology.
- Project templates: `PROJECT_MAP.md`, `FRESHNESS.md`, `DECISIONS.md`, `EVALS.md`, `OVERRIDES.md`.
- `AGENTS.md` entry point plus pointers for Claude Code (`CLAUDE.md`), GitHub Copilot and Cursor.
- `install.sh` and `install.ps1` installers/updaters that never overwrite user-owned files.
