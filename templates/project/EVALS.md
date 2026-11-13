# Evals

> Write 10–20 golden cases **before** building the feature. Every production bug becomes a new case. See `.ai-rules/rules/06-evals.md`.
> Move to `evals/` with a runner once this grows past ~30 cases.

## How to run

```
<command to run evals>
```

**Baseline:** <score> on <date> (git <sha>, model <id>, prompt <version>)
**Regression threshold:** block merge if score drops more than <x>

## Golden cases

| # | Input | Expected / pass criteria | Check type (exact, schema, contains, judge…) | Tags (edge, injection, no-answer…) |
|---|---|---|---|---|
| 1 | | | | |

## Retrieval cases (if RAG)

| # | Question | Source doc/chunk that must be retrieved | k |
|---|---|---|---|
| 1 | | | 5 |

## Judge rubric (if using LLM-as-judge)

<!-- Criteria, with one pass and one fail example each. Record the judge model and its agreement rate with human labels. -->
