# 99 · Dated facts (re-verify monthly)

Specific facts behind the rules, each with the date it was verified. **These go stale.** Before relying on one, check the linked source. If a fact here is wrong, open an issue or PR on the rule pack.

The rules themselves are written to stay true when these details change. This file is where the details live.

## Model lifecycle and API parameters (verified 2026-11-13)

| Fact | Source |
|---|---|
| Anthropic gives at least 60 days' notice before retiring a model. Recent notice-to-retirement windows were 2–4 months. | https://platform.claude.com/docs/en/about-claude/model-deprecations |
| Anthropic model IDs from Opus 4.6 onward have no date suffix, but still retire. Pin the ID and the API version header. | same |
| Anthropic API version `2026-10-21` removed `temperature`, `top_p` and `top_k` (requests with them return 400). Assistant prefill is rejected on Claude 4.6+ models; forced `tool_choice` is rejected on the newest models. | https://platform.claude.com/docs/en/api/errors |
| OpenAI: at least 6 months' notice for generally available models, ~3 months for specialised variants, as little as ~2 weeks for previews. The models API exposes a `shutdown_date`. | https://developers.openai.com/api/docs/deprecations |
| OpenAI's hosted Evals platform became read-only 2026-10-31 and shuts down 2026-11-30. | https://developers.openai.com/api/docs/guides/evaluation-best-practices |

## Prompt caching and cost (verified 2026-11-13)

| Fact | Source |
|---|---|
| Anthropic: cache reads cost ~0.1× base input; writes cost 1.25× (5-minute lifetime) or 2× (1-hour). Up to 4 explicit breakpoints, plus automatic caching. Cache reads don't count toward input-token rate limits. | https://platform.claude.com/docs/en/build-with-claude/prompt-caching |
| OpenAI: on newer models (GPT-5.6+), cache writes cost extra (1.25× for 30 min, 2.5× for 12 h); reads ~0.1×. Cached tokens still count toward rate limits. | https://developers.openai.com/api/docs/guides/prompt-caching |
| Gemini: implicit caching on 2.5 and newer; minimum cacheable prompt 2,048–4,096 tokens depending on model. | https://ai.google.dev/gemini-api/docs/caching |
| Batch processing is ~50% off at Anthropic, OpenAI and Google. | provider batch docs |
| Anthropic spend-limit errors are 429 with `enforced_spend_limit_reached` and no `retry-after`. Do not retry. A separate `ramp_limit_exceeded` 429 can fire after sudden usage growth. | https://platform.claude.com/docs/en/api/rate-limits |

## Protocols and standards (verified 2026-11-13)

| Fact | Source |
|---|---|
| Current MCP spec: **2026-07-28**. Stateless (no session handshake); Roots, Sampling, Logging and HTTP+SSE deprecated; CIMD replaces dynamic client registration. Servers should return tools in deterministic order. | https://modelcontextprotocol.io/specification/2026-07-28/changelog |
| MCP security best practices: no token passthrough, audience validation, SSRF protection, consent for local servers, minimal scopes. | https://modelcontextprotocol.io/docs/tutorials/security/security_best_practices |
| OpenTelemetry GenAI semantic conventions are still at Development (experimental) status. They moved to `open-telemetry/semantic-conventions-genai` on 2026-06-12. `gen_ai.provider.name` replaces `gen_ai.system`; content capture defaults to off. | https://github.com/open-telemetry/semantic-conventions-genai |
| OWASP Top 10 for LLM Applications 2025 added LLM07 System Prompt Leakage and LLM08 Vector and Embedding Weaknesses. | https://genai.owasp.org/llm-top-10/ |
| OWASP Top 10 for Agentic Applications (ASI01–ASI10) published 2025-12-09. *(Item details confirmed only via secondary sources.)* | https://genai.owasp.org/resource/2025-12-09/owasp-top-10-for-agentic-applications-for-2026 |
| Agent Skills is an open standard (`SKILL.md` with progressive disclosure). *(Verify.)* | https://agentskills.io/ |

## Context files (verified 2026-11-13)

| Fact | Source |
|---|---|
| Claude Code: keep each `CLAUDE.md` under ~200 lines. It reads `AGENTS.md` only when no `CLAUDE.md` exists, so `CLAUDE.md` should import it with `@AGENTS.md`. `.claude/rules/` files can be scoped with `paths:`. | https://code.claude.com/docs/en/memory |
| Codex concatenates `AGENTS.md` files from the repo root to the working directory, capped at 32 KiB by default; the excess is silently dropped. | https://learn.chatgpt.com/docs/agent-configuration/agents-md |
| `AGENTS.md` is a plain-Markdown open format, now stewarded under the Linux Foundation (Agentic AI Foundation). | https://agents.md/ |
| Context files raised agent inference cost by >20% without generally improving task success; LLM-generated files slightly hurt (ICLR 2026). | https://arxiv.org/abs/2602.11988 |

## Research numbers cited in the rules

| Fact | Source |
|---|---|
| Contextual retrieval cut top-20 retrieval failures by 35% (embeddings), 49% (+ contextual BM25), 67% (+ reranking). (2024-09-19) | https://www.anthropic.com/news/contextual-retrieval |
| Context rot: accuracy falls as input length grows across 18 models; focused ~300-token prompts beat ~113k-token prompts. (2025-07-14) | https://www.trychroma.com/research/context-rot |
| Semantic chunking's costs "are not justified by consistent performance gains" over fixed-size chunking. (2024-10) | https://arxiv.org/abs/2410.13070 |
| ~20% of LLM code samples referenced a non-existent package; 43% of hallucinated names recurred on every repeat. (USENIX Security 2025) | https://www.usenix.org/conference/usenixsecurity25/presentation/spracklen |
| Lethal trifecta: private data + untrusted content + external communication. (2025-06-16) | https://simonwillison.net/2025/Jun/16/the-lethal-trifecta/ |
| Six design patterns for securing LLM agents against prompt injection. (2025-06) | https://arxiv.org/abs/2506.08837 |
