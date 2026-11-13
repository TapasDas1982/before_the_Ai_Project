# 07 · Security & safety

LLMs follow instructions, including instructions hidden in documents, web pages, emails, tool outputs, memory and user uploads. Major vendors now say prompt injection is unlikely ever to be fully solved. Design as if injection **will** succeed, and contain what it can do.

## Prompt injection: containment first

1. **Lethal-trifecta check (lead rule).** No agent may combine all three of: **access to private data**, **exposure to untrusted content**, and **a way to send data out** (web requests, email, rendering external links or images, writing to shared places). Remove one leg, or use a containment pattern:
   - **plan-then-execute:** fix the plan before reading untrusted data
   - **dual LLM:** a quarantined model reads untrusted data and can't call tools
   - **action-selector:** the model picks from fixed, safe actions
   - **map-reduce:** each untrusted item is processed in isolation
   - **code-then-execute:** the model writes a program up front, then data flows through it
   - **context minimization:** strip untrusted text before consequential steps
2. **An agent's effective permissions equal those of the least trusted content in its context.** If an agent reads untrusted email, assume the email can call every tool the agent has.
3. **Delimiters, spotlighting and injection classifiers are defence in depth only.** Use them, since they reduce attacks, but never as the main control.
4. **Test with adaptive attacks.** Static payload lists aren't enough. Include injection through retrieved documents, tool outputs and memory in your eval set (`06-evals.md`).

## Output handling

- **Never execute model output directly:** no `eval`, no unescaped shell, no raw SQL. Use parameterized queries, allowlisted commands and sandboxes.
- **Validate against schemas** before using structured output.
- **Render safely.** Treat model output as untrusted user content (XSS). Use a strict Markdown allowlist, **no automatically loaded external images**, a CSP `img-src` allowlist, and strip or rewrite links carrying query data. Image and link rendering was the exfiltration channel in real zero-click attacks (EchoLeak, 2025).

## Secrets

- API keys live in environment variables or a secret manager, **never** in code, prompts, eval fixtures, logs or commits. Add `.env` to `.gitignore` on day one; commit only `.env.example` with placeholder values.
- **Assume the system prompt leaks** (OWASP LLM07). No secrets, internal URLs or authorization logic in it. Enforce authorization in code.
- Keep credentials **out of reach of the model and the sandbox.** A proxy or vault injects them into outbound calls.
- Use separate keys for dev, CI and prod, with spend limits set at the provider. Rotate any key that was ever pasted into a prompt, log or commit.

## Personal and sensitive data

- **Minimize.** Send the model only the fields it needs. Redact or tokenize PII where possible.
- **Know where data goes:** the provider's retention, training use, zero-retention options and region. Record it in `DECISIONS.md`.
- **Logs and traces contain prompts.** Apply the source data's access control and retention to them.
- **Multi-tenant isolation** is enforced in retrieval and tools (`04-rag.md`), never by asking the model to behave.

## Tools and agents

- Least-privilege, **per-user** credentials (OAuth) scoped to the task, not shared service keys.
- Human approval for destructive, financial and outbound-communication actions unless explicitly documented otherwise.
- **Default-deny network egress** with a domain allowlist. Code execution runs in a sandbox with no network by default and no host secrets.
- Audit-log every tool call. Have a kill switch to stop a running agent.
- Validate what agents write to memory; memory can be poisoned (OWASP Agentic ASI06).
- Rate-limit and cap cost per user and per run.

## MCP servers

- **Allowlist** which servers may be used. Treat each one as third-party code.
- **Pin versions, and hash tool descriptions; re-approve when they change.** Servers can change descriptions after you approve them ("rug pull"), and poisoned descriptions inject instructions. Show users full descriptions.
- Never put an untrusted server in the same context as write or outbound tools.
- Servers you build: **never pass a client's token through to downstream APIs**, validate token audience, request minimal scopes and step up as needed, and block requests to private IP ranges and cloud metadata endpoints (SSRF).
- Local servers: require consent showing the full command, and sandbox them.

## Supply chain

- **Verify every AI-suggested dependency exists and is established** (age, downloads, maintainer) before installing. LLMs invent package names, the same fake names recur, and attackers register them ("slopsquatting").
- Hash-pinned lock files. Pin models and datasets to a specific revision or commit hash.
- Load models only in safe formats (safetensors, not pickle). Scanners have missed malicious pickles.
- Keep an inventory of models, datasets, prompts, MCP servers and skills, e.g. as a CycloneDX ML-BOM. MCP servers and skills are part of your supply chain.

## Reference frameworks

- **OWASP Top 10 for LLM Applications (2025)** and **OWASP Top 10 for Agentic Applications (2026)**: developer checklists. Map your evals and controls to them.
- **MITRE ATLAS:** threat modelling for AI systems, including agent techniques.
- **NIST AI RMF and the Generative AI Profile (AI 600-1):** governance and risk management.

*(Check the agentic list and framework details at their official sites; some were confirmed only through secondary sources as of 2026-11-13.)*
