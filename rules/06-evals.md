# 06 · Evals

If you can't measure it, a prompt change is a coin flip. Evals turn "it seems better" into a number.

## Rules

1. **Read traces first.** Before writing metrics, read about 100 real traces (or realistic test runs). Note what went wrong in free text, then group the notes into a counted list of failure types. Build evaluators for the most common failures. For a planned capability with no traces yet, seed 10–20 capability cases. Grow suites to 100+ cases.
2. **Every production bug becomes an eval case.**
3. **Balanced sets.** Include should-do and should-not-do pairs (over- and under-refusal, acting and not acting), empty, long and adversarial inputs, unanswerable questions, prompt injection, and other languages if relevant. Map the safety slice to the OWASP LLM and Agentic top 10 lists.
4. **Prefer deterministic checks:** exact match, schema validity, contains / doesn't contain, regex, numeric tolerance, retrieval hit@k, final environment state. Use LLM judges only for what code can't check.
5. **LLM-as-judge done right:**
   - **binary pass/fail** (or pairwise), **one judge per failure mode**, with a written rubric and pass and fail examples
   - reasoning before the verdict, and an "Unknown" option
   - validate the judge on held-out human labels, at least 30–50 passes and 30–50 fails, and report how many real failures it catches and how many passes it wrongly fails (TPR/TNR)
   - any model that passes validation may judge; a different or stronger model is a sensible default
   - **normalize formatting** before judging (style and markdown bias the judge), and check each judge model for length bias *(based on one 2026 study)*
6. **Three tiers of eval suite:**
   - **Regression suite:** blocking, deterministic-first, expected to pass ~100%
   - **Capability suite:** non-blocking, tracks progress on hard tasks
   - **Judge suites:** scheduled nightly or pre-release

   Gate merges on changes larger than run-to-run noise. Retire evals that always pass.
7. **Track over time.** Store results with prompt version, model ID, API version, config hash, git SHA and date.
8. **Run more than once.** Outputs vary, and determinism can't be forced (some APIs no longer accept sampling parameters). Run **at least 3 trials per task**. Report **pass^k** (all k trials succeed) for reliability claims and **pass@k** (at least one succeeds) where one success is enough. Size samples for confidence intervals: e.g. ~400 samples to tell whether a defect rate is under 5%.
9. **Eval assets live in the repo** in portable formats (JSONL/CSV datasets, grader code, rubrics). Hosted eval platforms get deprecated.

## Agent evals

- **Grade the outcome** (final state of files, database, environment), not the exact sequence of steps.
- **Clean, isolated environment per trial.** Leftover state from earlier trials inflates scores.
- **Separate assertions** for tool choice, arguments, result and resulting state.
- Make graders hard to game, and **read transcripts** before trusting a score.
- **A 0% pass rate usually means a broken task or grader**, not an incapable agent.
- For conversational agents, use a simulated user, and audit the simulator.

## Online evals (production)

- Cheap deterministic checks on every trace.
- Reference-free LLM judges on **sampled** traffic, run asynchronously.
- No LLM judges as inline guardrails on the request path. Use fast deterministic checks there.
- Production failures, user corrections and escalations flow back into the offline sets.

## What to evaluate

| Component | Example checks |
|---|---|
| Retrieval | recall@k, MRR, context precision, distractor robustness |
| Generation | correctness vs. reference, faithfulness, schema validity, correct "no answer" |
| Tool use | right tool, valid args, no unnecessary calls |
| Agents | task success (pass^k), cost per success, steps, trial isolation |
| Safety | injection resistance, over/under-refusal, PII leakage |
| System | latency p95, cost per request, error rate |

## Minimal eval runner contract

```
input → system under test (k trials, clean env each) → outputs
outputs + expected → checks → pass/fail per trial → pass^k / pass@k
results → evals/results/<date>-<git-sha>.jsonl → compare with baseline
```

Keep it boring and fast. A 30-second eval people run beats a 30-minute one they skip.
