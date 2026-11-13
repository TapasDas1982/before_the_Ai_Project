# Before the AI Project

**Install this before you start any AI project.**

A small, opinionated rule pack that you drop into a repository *before* the first line of AI code is written. It gives you, and every AI coding agent working in the repo (Claude Code, Cursor, GitHub Copilot, Codex and any other tool that reads `AGENTS.md`), the same ground rules for:

| Area | What it covers | File |
|---|---|---|
| Core | Non-negotiables for every AI project | [`rules/00-core.md`](rules/00-core.md) |
| Freshness | Never trust training-data knowledge for versions, APIs, models or prices | [`rules/01-freshness.md`](rules/01-freshness.md) |
| Mapping | Keep a living map of the project so humans and agents load the right context | [`rules/02-mapping.md`](rules/02-mapping.md) |
| Layering | Where AI code lives and what may depend on what | [`rules/03-layering.md`](rules/03-layering.md) |
| RAG | Ingestion, chunking, retrieval, reranking, citations, index freshness | [`rules/04-rag.md`](rules/04-rag.md) |
| Harness | Agent loops, tools, permissions, context management | [`rules/05-harness.md`](rules/05-harness.md) |
| Evals | Golden sets, regression gates, LLM-as-judge done right | [`rules/06-evals.md`](rules/06-evals.md) |
| Security | Prompt injection, secrets, PII, tool sandboxing | [`rules/07-security.md`](rules/07-security.md) |
| Ops | Cost, latency, observability, fallbacks | [`rules/08-ops.md`](rules/08-ops.md) |
| Technology | How to pick and update models, frameworks and vector stores | [`rules/09-technology.md`](rules/09-technology.md) |

---

## Install

Run in the root of your project (new or existing).

**macOS / Linux / Git Bash / WSL**

```bash
curl -fsSL https://raw.githubusercontent.com/TapasDas1982/before_the_Ai_Project/main/install.sh | bash
```

**Windows PowerShell**

```powershell
irm https://raw.githubusercontent.com/TapasDas1982/before_the_Ai_Project/main/install.ps1 | iex
```

**Manual**

```bash
git clone --depth 1 https://github.com/TapasDas1982/before_the_Ai_Project.git /tmp/btap
bash /tmp/btap/install.sh /path/to/your/project
```

### What gets added to your project

```
your-project/
├── AGENTS.md                         # entry point every agent reads (created if missing)
├── CLAUDE.md                         # points Claude Code at AGENTS.md (created if missing)
├── .github/copilot-instructions.md   # points Copilot at AGENTS.md (created if missing)
├── .cursor/rules/before-ai.mdc       # points Cursor at AGENTS.md (created if missing)
└── .ai-rules/
    ├── VERSION                       # rule pack version you installed
    ├── rules/                        # upstream rules – replaced on update, don't edit
    └── project/                      # YOUR files – never overwritten
        ├── PROJECT_MAP.md
        ├── FRESHNESS.md
        ├── DECISIONS.md
        ├── EVALS.md
        └── OVERRIDES.md
```

The installer **never overwrites your files**. If `AGENTS.md` or `CLAUDE.md` already exist, it appends a short marked block that points to `.ai-rules/` instead of replacing them.

## Update

Re-run the same install command. Only `.ai-rules/rules/` and `.ai-rules/VERSION` are refreshed; everything under `.ai-rules/project/` stays yours. See [`CHANGELOG.md`](CHANGELOG.md) for what changed.

## First 30 minutes after installing

1. Fill in `.ai-rules/project/PROJECT_MAP.md`: what the project is, its layers, where things live.
2. Fill in `.ai-rules/project/FRESHNESS.md`: every model, SDK and framework you use, the version, and **the date you verified it** against official docs.
3. Write 10–20 golden examples in `.ai-rules/project/EVALS.md` before building the feature.
4. Record your first decision (model, vector store, framework) in `.ai-rules/project/DECISIONS.md`.
5. Anything in the rules that doesn't fit your project goes in `.ai-rules/project/OVERRIDES.md`, with a reason.

## Philosophy

- **Rules, not frameworks.** No dependencies, no lock-in. Plain Markdown that any human or agent can read.
- **Freshness first.** AI tooling changes monthly. The rules tell agents to *verify*, not to *remember*.
- **Small enough to actually be read.** Each rule file is meant to fit in an agent's context alongside your code.

## Contributing

New techniques, corrections and tool updates are welcome. See [`CONTRIBUTING.md`](CONTRIBUTING.md).

## License

[MIT](LICENSE)
