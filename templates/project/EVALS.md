# Evals

> Start by reading ~100 real traces and listing the failure types you see; build checks for the most common ones. Seed 10–20 cases for planned capabilities. Every production bug becomes a new case. Run ≥3 trials per case. See `.ai-rules/rules/06-evals.md`.
> Move to `evals/` (portable JSONL/CSV + grader code) once this grows past ~30 cases.

## Failure taxonomy (from reading traces)

| Failure type | Count | Example trace | Eval check |
|---|---|---|---|

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

<!-- One binary pass/fail judge per failure type. Rubric with pass and fail examples, plus an "Unknown" option.
     Record: judge model, human-labelled validation set size (≥30–50 pass and ≥30–50 fail), TPR and TNR. -->
