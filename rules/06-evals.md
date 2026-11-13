# 06 · Evals

If you can't measure it, a prompt change is a coin flip. Evals turn "it seems better" into a number.

## Rules

1. **Golden set first.** Before building a feature, write 10–20 realistic inputs with expected outputs or pass criteria in `.ai-rules/project/EVALS.md` (or `evals/`). Grow it to 50–200 as real failures appear.
2. **Every production bug becomes an eval case.**
3. **Cover the edges:** empty input, adversarial or injection input, out-of-scope questions, "the answer isn't in the docs", multilingual input if relevant, long inputs.
4. **Prefer deterministic checks:** exact match, schema validity, contains or doesn't contain, regex, numeric tolerance, retrieval hit@k. Use LLM-as-judge only for what code can't check.
5. **LLM-as-judge done right:**
   - give the judge a written rubric with concrete pass and fail examples
   - ask for reasoning before the score, and use binary or small-scale scores
   - use a different (ideally stronger) model than the one being judged where possible
   - spot-check the judge against human labels and record the agreement rate
6. **Regression gate.** Evals run in CI, or at least before merge, for any change to prompts, models, retrieval, tools or parsing. A drop beyond your threshold blocks the merge unless someone accepts it explicitly.
7. **Track over time.** Store results with prompt version, model ID, config hash and date so you can compare runs.
8. **Run more than once.** Model output varies. Run important evals several times or at temperature 0 where it is supported, and look at variance, not one run.

## What to evaluate

| Component | Example checks |
|---|---|
| Retrieval | recall@k, MRR, "right doc in top 5" |
| Generation | correctness vs. reference, faithfulness to context, format and schema validity |
| Tool use | right tool chosen, valid arguments, no unnecessary calls |
| Agents | task success rate, steps taken, cost per success, safety violations |
| Safety | injection resistance, refusal on disallowed requests, PII leakage |
| System | latency p95, cost per request, error rate |

## Minimal eval runner contract

```
input → system under test → output
output + expected → checks → pass/fail + score
results → results/<date>-<git-sha>.json → compare with baseline
```

Keep it boring and fast. A 30-second eval that people run beats a 30-minute one they skip.
