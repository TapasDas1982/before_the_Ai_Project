# 07 · Security & safety

LLMs follow instructions, including instructions hidden in documents, web pages, emails, tool outputs and user uploads. Design as if every input will try to take control.

## Prompt injection

1. **Untrusted content is data, never instructions.** Retrieved documents, web pages, file contents, tool results and user uploads are wrapped in clear delimiters and labeled as untrusted in the prompt.
2. **The model's permissions = the permissions of the least trusted content in its context.** If an agent reads untrusted email, assume the email can call every tool that agent has.
3. **Separate privileges.** An agent that reads untrusted content should not also hold destructive or external tools without human approval.
4. **No exfiltration paths.** Watch for model-generated URLs, markdown images and links that could leak data through query strings. Allowlist domains for rendering and fetching.
5. **Test it.** Keep injection cases in your eval set (`06-evals.md`).

## Output handling

- **Never execute model output directly:** no `eval`, no unescaped shell, no raw SQL. Use parameterized queries, allowlisted commands and sandboxes.
- **Validate against schemas** before using structured output.
- **Escape before rendering.** Model output shown in HTML is untrusted user content (XSS).

## Secrets

- API keys live in environment variables or a secret manager, **never** in code, prompts, eval fixtures, logs or commits.
- Add `.env` and similar files to `.gitignore` on day one. Commit a `.env.example` with placeholder values only.
- Use separate keys for dev, CI and prod, with spend limits set at the provider.
- Rotate any key that was ever pasted into a prompt, a log or a commit.

## Personal and sensitive data

- **Minimize.** Send the model only the fields it needs. Redact or tokenize PII where you can.
- **Know where data goes:** the provider's data retention, training use and region. Record it in `DECISIONS.md`.
- **Logs and traces contain prompts.** Apply the same access control and retention to them as to the source data.
- **Multi-tenant isolation** is enforced in retrieval and tools (`04-rag.md`), not by asking the model to behave.

## Tools and agents

- Least-privilege credentials per tool, scoped to the task.
- Human approval for destructive, financial and outbound-communication actions unless explicitly documented otherwise.
- Run code-execution tools in a sandbox with no network access by default and no host secrets.
- Rate-limit and cap cost per user and per run to limit abuse.

## Supply chain

- Pin dependencies and commit lock files. Check new packages for typosquatting. AI agents hallucinate package names, and attackers register them.
- Only load models, datasets and plugins from trusted sources. Prefer safe serialization formats (e.g. safetensors over pickle).
