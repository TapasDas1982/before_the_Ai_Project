# 08 · Ops: cost, latency, observability, reliability

## Observability (day one, not later)

Log for every model call:

- timestamp, trace and request ID, provider request ID, user or tenant (hashed if needed)
- feature, **prompt name and version**
- provider, model ID, API version, parameters
- input, output, **cache-read, cache-write and reasoning tokens**; cost estimate
- latency: **time to first token** and total
- finish reason and outcome: success, validation failure, refusal, truncation, error, fallback used

Group calls into **traces** per user request or agent run, with agent and tool spans.

**Use OpenTelemetry's GenAI semantic conventions** (`gen_ai.*` attributes) so traces are portable across tools. They are still marked experimental and their names change, so pin your instrumentation version and keep attribute names in one place. **Don't capture prompt or response content by default.** Enable it in staging, or store content externally with access control and log only a reference. See `99-dated-facts.md`.

## Cost

- **Know the unit cost:** per request, per user, per successful task. Put it on a dashboard.
- **Right-size:** use the smallest model **and effort or reasoning level** that passes your evals for each step. Tune the effort level before switching models. Model routing can save a lot, but prove it on your own traffic.
- **Prompt caching:**
  - put the stable prefix first (tools → system prompt → reference docs → history), with no timestamps or IDs in it
  - never change tool definitions mid-session
  - **cache writes cost extra at some providers**, so don't cache prefixes used only once
  - respect minimum cacheable lengths; use longer cache lifetimes for bursty or batch traffic
  - let the first request start before fanning out parallel calls, so they can share the cache
  - **alert on cache hit rate**
- **Batch or flex processing** (about 50% off at major providers) for anything not user-facing: evals, backfills, enrichment.
- **Cap spend:** provider-side limits plus per-user and per-run limits in your code.
- Check current prices and cache multipliers before estimating (`99-dated-facts.md`). They change often.

## Latency

- Stream user-facing responses. Measure time to first token and per-chunk time, p50 **and** p95.
- **Cut output tokens first.** Output length drives latency more than input.
- Run independent calls (retrieval + classification, parallel tool calls) concurrently.
- Pre-warm new structured-output schemas. The first request with a new schema can be slow.
- Set timeouts on every external call, plus per-step and overall deadlines in agent loops.

## Reliability

- **Retries:** retry rate limits (honouring `retry-after`), overload and 5xx errors and connection failures with jittered exponential backoff and a cap. **Never retry spend-limit errors**: alert a human instead. Don't retry validation failures blindly.
- **Ramp bulk jobs up gradually.** Some providers throttle sudden growth even below your limit.
- **Streams can fail after a 200.** Handle errors mid-stream.
- **Structured output:** prefer native constrained decoding so repair loops become rare. Still handle refusals and max-token truncation explicitly. If validation fails, retry once with the error, then fail cleanly.
- **Fallbacks:** a secondary model or provider for critical paths, behind the single adapter (`03-layering.md`). It starts with a cold cache (higher cost and latency), needs its own prompt variant and evals, and may support schemas differently.
- **Graceful degradation:** when AI is unavailable, the product still does something sensible.

## Releases

- **Version as one unit:** prompt + model ID + API version + tools + schema + parameters, logged on every span.
- **Roll out in gates:** offline evals → shadow traffic → canary (about 5–10% of traffic, scored by judges, with cost and latency compared) → 100%.
- Keep the previous version ready for instant rollback.
- **CI fails when a pinned model is within N days of its retirement date** (from `FRESHNESS.md`).
- Feed production feedback (thumbs, corrections, escalations) back into evals.
