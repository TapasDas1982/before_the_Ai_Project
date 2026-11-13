# Contributing

Thanks for helping keep this rule pack useful and current.

## What makes a good rule

- **Actionable.** An agent or developer can follow it and check that they did.
- **Durable.** It describes *how to decide* or *how to verify*, not a specific model, price or version that will be stale in months. Put time-sensitive facts behind "verify in current docs" (see `rules/01-freshness.md`).
- **Short.** Each rule file should stay small enough to load into an agent's context next to real code. If a file grows past ~150 lines, split it.
- **Justified.** Say why when it isn't obvious.

## How to propose a change

1. Open an issue describing the problem: a failure you saw, a technique that measurably helped, or a rule that is wrong or outdated.
2. Fork, edit the relevant file under `rules/` or `templates/`, and open a pull request.
3. Add an entry under an `Unreleased` heading in `CHANGELOG.md`.
4. If you change install behavior, test both `install.sh` and `install.ps1` on a fresh folder **and** on a folder that already has `AGENTS.md` / `CLAUDE.md`.

## Layout

```
rules/        upstream rules, copied to <project>/.ai-rules/rules/ (replaced on update)
templates/    agent pointer blocks + project templates (project/ files are never overwritten)
install.sh    installer/updater for macOS, Linux, Git Bash, WSL
install.ps1   installer/updater for Windows PowerShell
VERSION       current rule pack version (bump on release)
```

## Releasing (maintainers)

1. Move `Unreleased` entries in `CHANGELOG.md` under a new version and date.
2. Bump `VERSION`.
3. Tag the commit `vX.Y.Z` and create a GitHub release.
