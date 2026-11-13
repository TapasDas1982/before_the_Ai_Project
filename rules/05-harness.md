# 05 · Harness (agents, tools, loops)

The **harness** is everything around the model: the loop, the tools, permissions, context management, memory, and the stop conditions. A good harness matters as much as the model.

## Start simple

1. **Use the simplest thing that works:** one model call → a fixed chain or workflow → an agent loop. Move up a level only when evals show the simpler level can't do the job.
2. **Use a workflow when the steps are known.** Use an agent when the steps depend on what the model finds.
3. **Know your provider's native features** (tool use, structured output, prompt caching, built-in agent SDKs) before adding a framework. Check current docs (`01-freshness.md`).

## Tools

- **Few, well-named, well-described tools.** The description is a prompt: say what the tool does, when to use it, when *not* to, and what the arguments mean, with examples.
- **Typed, validated arguments.** Reject bad arguments with an error message the model can act on.
- **Return compact, relevant results.** Paginate or truncate large outputs, and tell the model they were truncated.
- **Classify side effects:** `read` · `write` · `destructive` · `external` (sends, pays, publishes). Anything beyond `read` needs an explicit policy, and destructive or external actions need human approval unless the project documents otherwise.
- **Idempotency.** Write tools should be safe to retry, or detect duplicates.
- **Least privilege.** Tools get scoped credentials for exactly what they need, never the developer's own keys.

## The loop

- **Hard limits:** maximum steps, maximum tokens, maximum wall-clock time, maximum cost per run. Fail loudly when one is hit.
- **Clear stop conditions:** the task is done, the model asks the user, or a limit is reached.
- **Errors are observations.** Feed tool errors back to the model as results it can reason about. Don't crash the loop, and don't hide errors.
- **No infinite retries.** Detect repeated identical calls and stop.

## Context management

- **Context is a budget.** Put stable content (system prompt, tool definitions, reference docs) first so prompt caching can work. Put volatile content last.
- **Summarize or trim** old turns and large tool outputs when nearing limits. Keep decisions and open tasks.
- **Load on demand.** Give the agent a way to fetch files or docs when needed instead of preloading everything. These rule files are designed for that.
- **Memory must be curated.** Persistent memory stores facts with sources and dates, can be corrected, and never stores secrets.

## Multi-agent

- Use sub-agents for **independent, parallelizable** work or to keep a large search out of the main context. Don't use them for steps that depend on each other.
- Each sub-agent gets a self-contained brief: goal, inputs, constraints, output format. It doesn't see the parent's context.
- Treat a sub-agent's output like any model output: verify before relying on it.

## Observability for agents

Log every run as a trace: prompt version, model, each tool call with arguments and result size, tokens, latency, cost and final outcome. You can't debug what you can't replay.
