# CLAUDE.md - AUGUR

Closed research project (n = 2 time-locked models, DOI 10.5281/zenodo.22309658, v1.0.4); maintained for corrections only.
Doc of record: `HANDOFF.md` (its "Repo state" section is stale: the repo is public with CI) - read it, then `FINDING.md`, before changing anything.

## Run

| What | Command |
|---|---|
| Activate env | n/a (standard library plus pytest) |
| Install | `pip install pytest` |
| Run the battery | `powershell -File run_probes.ps1 -Model <ollama-tag> -AnchorYear <1938|1930> -OutFile <new file>` (needs local Ollama and GGUF weights outside the repo) |
| Tests | `python -m pytest -q` - expected: `9 passed` |
| Lint / typecheck | n/a |
| Build | n/a |

## Deploy

- Provider: none (research repo). Zenodo record is the archive; public repo github.com/zaidwhy/augur with CI (`.github/workflows/ci.yml`).
- Rollback: n/a

## Layout

```
run_probes.ps1        the 14-probe battery
probes-*.md           committed transcripts (the evidence; never regenerate over them)
FINDING.md            claim, table, caveats, correction
AUDIT-RERUN-...md     claim-by-claim comparison of the two runs
tests/                transcript, re-run and runner-guard tests
```

## Definition of done (for any change here)

- `python -m pytest -q` green with 9 passed.
- Every number in README or FINDING traces to a `probes-*.md` transcript or an audit file; nulls and withdrawals stay stated.
- Docs updated if the finding, version or DOI changes (README, FINDING, CITATION.cff, .zenodo.json).
- Committed with a descriptive message; `git fetch origin` then push; `git status -sb` clean.
- No U+2014, no attribution, no secrets, no invented numbers.

## Gotchas

- The GGUF has no chat template; Ollama runs it as a completion model unless the Modelfile sets TEMPLATE. Use the `-chat` tags.
- Output at temperature 0 is not bit-identical across sessions; claims rest on years and names, not wording.
- Weights live outside the repo (`*.gguf` is gitignored).

## Do not

- Do not overwrite or edit a committed `probes-*.md`; add a new dated file.
- Do not reinstate the withdrawn elicitation-framing claim without a saved, anchored probe pair.
