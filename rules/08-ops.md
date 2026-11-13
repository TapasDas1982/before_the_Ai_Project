# 08 · Ops: cost, latency, observability, reliability

## Observability (day one, not later)

Log for every model call:

- timestamp, request or trace ID, user or tenant (hashed if needed)
- feature or use case, prompt template + version
- model ID and parameters
- input, output and cached tokens, cost estimate
- latency (time to first token, total)
- outcome: success, validation failure, refusal, error, fallback used

Group calls into **traces** per user request or agent run. Use an LLM observability tool or OpenTelemetry. Pick one, record it in `DECISIONS.md`, and check its current docs.

## Cost

- **Know the unit cost:** cost per request, per user, per successful task. Put it on a dashboard.
- **Right-size models.** Use the smallest model that passes your evals for each step. Route easy requests to cheap models and hard ones to strong models.
- **Use prompt caching** for long, stable prefixes (system prompts, tool definitions, reference docs). Structure prompts so stable parts come first.
- **Batch** offline work where the provider offers cheaper batch APIs.
- **Cap spend:** provider-side limits plus per-user and per-run limits in your code.
- Check current pricing before estimating (`01-freshness.md`). It changes often.

## Latency

- Stream responses for user-facing generation.
- Run independent calls (retrieval + classification, parallel tool calls) concurrently.
- Measure p50 **and** p95. Agent loops have long tails.
- Set timeouts on every external call.

## Reliability

- **Retries** with exponential backoff and jitter for rate limits and transient errors only, not for validation failures.
- **Fallbacks:** a secondary model or provider for critical paths, behind the single adapter (`03-layering.md`). Run evals on the fallback too.
- **Graceful degradation:** when AI is unavailable, the product still does something sensible.
- **Validate, then repair once.** If structured output fails validation, retry once with the error message. After that, fail cleanly.

## Releases

- Version prompts and config. Roll out model or prompt changes behind a flag or to a percentage of traffic, and compare metrics before going to 100%.
- Keep the previous prompt, model and config ready for an instant rollback.
- Watch production feedback (thumbs, corrections, escalations) and feed failures back into evals.
