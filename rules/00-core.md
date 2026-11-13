# 00 · Core rules

These apply to every AI project, every agent, every change. They come first because every other rule depends on them.

## Non-negotiables

1. **Verify, don't remember.** Model names, SDK methods, framework APIs, prices, context limits and rate limits change faster than any model's training data. Check official docs before you use them. See `01-freshness.md`.
2. **Map before you build.** Read `.ai-rules/project/PROJECT_MAP.md` before you change code, and update it when structure changes. See `02-mapping.md`.
3. **Evals before features.** No prompt, retrieval or agent change ships without an eval that shows it didn't get worse. See `06-evals.md`.
4. **AI output is untrusted input.** Validate model output before it touches a database, a shell, a user or another tool. See `07-security.md`.
5. **Decisions are written down.** Choosing a model, vector store, chunking strategy or framework goes in `.ai-rules/project/DECISIONS.md` with the date and the reason.
6. **Keep the LLM swappable.** Call models through one thin adapter in your code. Never scatter provider SDK calls across business logic. See `03-layering.md`.
7. **Measure cost and latency from day one.** Log tokens, latency and model per request. See `08-ops.md`.

## How agents should work in this repo

- Read `AGENTS.md` → this file → `.ai-rules/project/PROJECT_MAP.md` → `.ai-rules/project/OVERRIDES.md` before starting.
- Load the other rule files only when the task touches them (RAG work → `04-rag.md`, etc.). Don't pull everything into context.
- Prefer the smallest change that solves the task. Don't add frameworks, abstractions or dependencies the task doesn't need.
- When you're unsure whether something is current (an API, a model ID, a library version), say so and look it up. Don't guess.
- When the rules and the project's `OVERRIDES.md` disagree, `OVERRIDES.md` wins.
- When you finish, update `PROJECT_MAP.md`, `FRESHNESS.md` or `DECISIONS.md` if what you did changed them.

## Definition of done for an AI change

- [ ] Versions and APIs used were checked against current official docs (recorded in `FRESHNESS.md`)
- [ ] Evals run; results no worse than baseline (or the regression is explained and accepted)
- [ ] Model output is validated or schema-checked where it is consumed
- [ ] No secrets, keys or PII in prompts, logs, fixtures or commits
- [ ] Token cost and latency of the change are known
- [ ] `PROJECT_MAP.md` / `DECISIONS.md` updated if structure or choices changed
