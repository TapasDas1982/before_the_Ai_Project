# 05 · Harness (agents, tools, loops)

The **harness** is everything around the model: the loop, tools, permissions, context management, memory and stop conditions. It matters as much as the model.

## Start simple

1. **Use the simplest thing that works:** one model call → a fixed workflow → one agent → multiple agents. Move up a level only when evals show the simpler level can't do the job.
2. **Workflows when the steps are known; agents when the steps depend on what the model finds.**
3. **Use provider-native features** (tool use, structured output, prompt caching, agent SDKs) before adding a framework. Check current docs (`01-freshness.md`).
4. **Every piece of scaffolding states the model weakness it covers** (e.g. "context resets: model loses track past ~N tokens"). Re-test and remove scaffolding when you upgrade the model.

## Tools

- **Few, workflow-level tools.** Build one tool per task an agent actually performs, not one per API endpoint. Prefer search over list-everything.
- **Clear names, namespaced by service** (`crm_search_contacts`, `crm_update_contact`). The description is a prompt: what the tool does, when to use it, when not to, what each argument means.
- **Typed, validated arguments.** Error messages tell the model how to fix the call, with a valid example.
- **Token-efficient results.** Return the fields that matter and human-readable identifiers rather than opaque UUIDs. Offer a concise/detailed `response_format` option, and paginate or truncate large outputs (e.g. a cap of ~25k tokens), saying so and how to narrow the query.
- **Large tool sets:** use tool search or let the agent call tools from code, instead of loading every definition into context.
- **Stable definitions.** Keep tool order deterministic and don't change tool definitions mid-session. Both break prompt caching.
- **Classify side effects:** `read` · `write` · `destructive` · `external` (sends, pays, publishes). Destructive and external actions need human approval unless the project documents otherwise.
- **Idempotent writes, least-privilege credentials.** Tools get scoped, per-user credentials, never the developer's own keys.

## The loop

- **Hard limits:** maximum steps, tokens, wall-clock time and cost per run, plus per-step deadlines. Fail loudly when one is hit.
- **Clear stop conditions:** the task is done, the model asks the user, or a limit is reached. Repeated failures escalate to a human.
- **Guardrails on side-effecting runs are blocking**, not run in parallel with the action, and they check tool calls as well as input and output.
- **Errors are observations.** Feed tool errors back to the model. Don't crash and don't hide them. Detect repeated identical calls and stop.

## Context management

- **Context is a budget.** Accuracy degrades as context fills. Load information **just in time** through tools rather than preloading it.
- **Stable content first** (tools, system prompt, reference docs) so caching works; volatile content last.
- **Compaction:** when nearing limits, summarize old turns and keep decisions, open tasks and recently touched files. Clear stale tool results.
- **Structured notes outside the window:** progress files, to-do lists and test status that the agent re-reads.
- **Session event log:** keep an append-only log of each run outside the context window for resume and audit.

## Memory

- Persistent memory stores facts with source and date, can be corrected, and never stores secrets.
- **Memory is untrusted when read back.** It can be poisoned (OWASP Agentic ASI06). Validate writes, scope memory per user or tenant, and keep provenance.
- Use structured formats (JSON) for state the agent must not rewrite loosely.

## Multi-agent

- **One writer of shared state.** Extra agents search, review or advise; they don't edit the same files or data in parallel. Parallel writers and manager/worker delegation still fail often.
- Use sub-agents to parallelize **independent, read-heavy** work or to keep large searches out of the main context. They return short summaries (about 1–2k tokens).
- Budget for cost: multi-agent research systems have used about 15× the tokens of a chat.
- **Use a separate, skeptical evaluator** for generated work. Self-evaluation is too lenient.
- Each sub-agent gets a self-contained brief: goal, inputs, constraints, output format.

## Long-running agents

- Start with an initializer pass that sets up the environment, a feature or test list in JSON (the agent may only change pass/fail status), and a progress log.
- Work on one feature at a time. Verify it end to end (e.g. browser automation for UIs), commit it, and update the log.
- Checkpoint and resume from the log and git history; don't restart from scratch.

## MCP and Skills

- Target the **current MCP spec version** and record it in `FRESHNESS.md`. The protocol changes substantially between versions; see `99-dated-facts.md`.
- Treat every MCP server as third-party code with security implications (`07-security.md`).
- Package repeatable procedures as **Agent Skills** (a `SKILL.md` plus resources, loaded on demand) instead of growing the always-loaded context.

## Observability for agents

Log every run as a trace: prompt and harness version, model, each tool call with arguments and result size, tokens, latency, cost and final outcome. Emit OpenTelemetry GenAI agent and tool spans where you can (`08-ops.md`). Watch the ratio of model calls to tool calls: it reveals loops and dithering.
