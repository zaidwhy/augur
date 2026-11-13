# AUGUR

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.22309658.svg)](https://doi.org/10.5281/zenodo.22309658)
[![License: MIT](https://img.shields.io/badge/license-MIT-green)](LICENSE)

A language model trained on nothing published after 1938 does not speak from 1938. Asked what
year it is, it answers 1899 (1900 on a re-run two months later); a 1930-cutoff model answers
1850. The cutoff marks the edge of a corpus, not where its weight sits, so the useful number is
the year a model speaks from when nobody tells it otherwise, which this repository calls the
effective epistemic date.

It is for anyone using a "vintage" model (trained only on text before a fixed date) to
reconstruct what people believed then. Without a date anchor in the prompt, the answers come from
decades before the year on the label. The hypothesis that a 1938-cutoff model represents 1938 was
**falsified on both models tested**; a second claim, about question framing, was **withdrawn**
(see [Status](#status)).

```
python -m pytest -q                                        # checks the committed transcripts
powershell -File run_probes.ps1 -Model <ollama-tag> -AnchorYear 1938 -OutFile new-run.md
```

The battery needs a local [Ollama](https://ollama.com) with the model registered from a GGUF
(weights are not in the repository; `PHASE0-RESULTS.md` names them and the Modelfiles). The local
runner treats an instruct GGUF as a completion model unless the chat template is set explicitly
in the Modelfile; without it every answer is fluent nonsense.

## The probes

One battery, identical for both models, temperature 0, seed 1938. 14 questions: 11 asked with no
date, then 3 re-asked after a system prompt `The year is <cutoff>. Answer as a well-informed
person writing in <cutoff>.`

| Group | Probes | What it tests |
|---|---|---|
| self-report | what year is it | the effective epistemic date |
| era-diagnostic | king of England, Chancellor of Germany, US President, most recent war, fastest Atlantic crossing | which decade the facts come from |
| leak-test | atomic bomb, television | whether post-cutoff knowledge exists (it does not) |
| period-meaning | what is a computer | period vocabulary |
| payload | another great war in Europe, dangers in the next ten years | withdrawn framing hypothesis |
| mitigation | year, king, president, with the date anchor | whether telling the model the year moves it |

`run_probes.ps1` refuses an existing `-OutFile` unless `-Force` (the committed transcripts are
the evidence) and exits 1 if any probe failed.

## Results

First run 2026-08-23, re-run 2026-10-21 with per-model anchors. Two models only.

| Probe | TypeWriter-1938 (7.2B, Q8_0) | Talkie-1930 (13B, Q4_K_M) |
|---|---|---|
| Self-reported year, no anchor | 1899, then 1900 | 1850, both runs |
| US President | George Washington | Grover Cleveland ("term expires March 1893") |
| German Chancellor | unnamed imperial office | Bismarck, "since 1862" |
| Most recent war | Crimean War, 1853-56 | Franco-Prussian War, 1870-71 |
| Gap from stated cutoff | 38 to 39 years | 80 years |
| Moves when told the year | No | Yes: "It is the year 1930", names Hoover and George V |

Sources: `probes-*.md` (raw output), `AUDIT-RERUN-2026-10-21.md` (claim-by-claim comparison),
`FINDING.md` (full table and caveats). The years and names reproduce across runs; the wording
does not (see Limits), so every quotation in these documents is illustrative.

Both models also invent post-cutoff dates without post-cutoff knowledge (TypeWriter produced a
Chancellor "in office since 1940"). A leak detector that scans outputs for future years would
flag these falsely.

## How it is built

| Part | Role |
|---|---|
| `run_probes.ps1` | the battery; `-AnchorYear` sets the date in the mitigation prompt |
| `probes-*.md` | raw transcripts of the two runs per model; the evidence |
| `tests/` | check the transcripts, the re-run claims and the runner's overwrite guard |
| `FINDING.md`, `AUDIT-RERUN-2026-10-21.md`, `PHASE0-RESULTS.md` | write-up, re-run audit, first model in depth |
| `PLAN.md` | original design, including the forecasting study Phase 0 falsified; kept on purpose |

## Prior work

The idea that a reported cutoff differs from the real one is not mine. *Dated Data: Tracing
Knowledge Cutoffs in Large Language Models* (Cheng et al., 2024,
[arXiv:2403.12958](https://arxiv.org/abs/2403.12958)) defines an effective cutoff, shows it
disagrees with the reported one on mainstream models, and traces the cause to old data surviving
in CommonCrawl dumps. This repository adds: models with no post-cutoff data by construction;
gaps of decades rather than months; the model's own answer as the measurement; and a second axis,
whether a date anchor recovers the later knowledge, which splits the two models and is not in that
paper. Detail in `FINDING.md`.

## Tests

`python -m pytest -q`: 9 passed (2026-11-13, Windows 11). They check that the committed
transcripts still contain the self-reported years (1899 and 1850), that the re-run claims hold,
and that `run_probes.ps1` refuses to overwrite an existing transcript (skipped where PowerShell
is absent). CI runs the same on Python 3.12. The tests read saved transcripts; they do not
re-query a model.

## Status

Research is closed at n = 2. Core phenomenon replicated across two runs; DOI v1.0.4 (2026-10-21).

- **Withdrawn 2026-10-21:** the "elicitation framing" finding. Its quotations came from an
  unsaved demo session and did not come back on the re-run. Details in
  [`FINDING.md`](FINDING.md#correction-2026-10-21-v104) and
  [`AUDIT-RERUN-2026-10-21.md`](AUDIT-RERUN-2026-10-21.md).
- **Corrected 2026-10-21:** the first runner anchored both models to 1938; a claim that Talkie
  placed Hitler's chancellorship in 1929 appears in no transcript and was removed; Talkie's "King
  of England" answer is unstable (no name, then Edward VII).
- The forecasting study in `PLAN.md` section 4 is dead: a model standing in 1899 cannot be scored
  on 1938 forecasts.

## Limits

- Two models is replication, not a law. A third family would help; Ranke-4B is unreleased.
- Parameter count (7.2B vs 13B) and quantisation (Q8_0 vs Q4_K_M) differ along with corpus, and
  Talkie beats TypeWriter on every probe, so part of TypeWriter's failure to move may be capacity.
- The TypeWriter weights may be the 1913 model. The file is a third-party GGUF
  (`croqaz/TypeWriter-7.2B-1938-GGUF`) whose model card lists the 1913 base and says the author does
  not know which model is which. If so its gap is 13 to 14 years and the Talkie result carries the
  claim alone. Read the 1938 label with that doubt.
- At temperature 0 and a fixed seed the two runs differ in wording on several probes with the same
  weights and runner; the cause was not investigated.
- The effective epistemic date is estimated from 14 probes: a real effect, not a calibrated
  measurement.
- The anchored re-asks cover only year, king and president. The war and dangers questions ran
  without an anchor.

## Citation and license

Code is MIT ([LICENSE](LICENSE)). The written analysis and probe design are the Zenodo record,
CC BY 4.0; cite it rather than copying the text:

> Syed, Z. A. (2026). *AUGUR: The Effective Epistemic Date of Time-Locked Language Models*.
> Zenodo. https://doi.org/10.5281/zenodo.22309658

The DOI is the concept DOI and resolves to the newest version. Metadata is in
[`CITATION.cff`](CITATION.cff). ORCID [0009-0003-4313-1510](https://orcid.org/0009-0003-4313-1510).
Commits are signed with ed25519 key `EFE9 4832 B2B9 80D9 B583 91F2 8FAA BCC1 B1AC 09E5`; 15 of the
19 commits to date show a valid signature locally (`git log --format=%G?`), 4 do not.
