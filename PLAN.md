# AUGUR - Plan of Record

**Working name:** AUGUR (a Roman priest who read the future from signs). Rename is free on day zero.

**The question:** What can a mind that is genuinely locked in its own time predict about its
future, and what is structurally unthinkable to it? And - the version that only this project
can ask - if you re-run history from inside those minds, does the same century happen twice?

**Status (2026-08-23):** Phase 0 **run and passed**. Phase 1 passed on chill but **falsified this
plan's central premise**. Read `PHASE0-RESULTS.md` before anything else - it supersedes the forecasting
design in section 4.

The short version: the 1938 model has no concept of nuclear weapons (the conceivability metric works,
first try), but it self-reports the year as **1899** and reasons about Europe's future using the
1866 Austria-Prussia rivalry. A knowledge cutoff is an upper bound on training data, not the model's
epistemic position. Forecast scoring against 1939-1948 outcomes is therefore invalid: the forecaster is
not standing in 1938.

**Awaiting Zaid's decision** on the proposed pivot (measure *effective epistemic date* as a calibration
instrument for the whole vintage-LLM line). Phases 2 and 3 are deliberately NOT started, because the
pivot changes what the harness should be.

---

## 1. Why this exists (read this before touching anything)

Three ingredients only became simultaneously available in the last few months, and Zaid is one
of very few people holding all three at once:

1. **Genuinely time-locked open-weight models.** Not modern models prompted to "pretend it is
   1913" - models pretrained from scratch on text that stops at a cutoff, so the ignorance is
   structural rather than instructed.
2. **A causal replay design** (Chronoscope: excise an event, compute the causal cone, replay
   only what must change, diff the timelines, and separate "this event caused it" from "this was
   going to happen anyway"). Three prior-art audit areas already done, no KILL verdict.
3. **A multi-agent society harness** (CivilizationOS) already built and deployed.

Chronoscope's unadmitted weakness was that its subject matter was synthetic: nobody outside the
field cares whether an invented norm in an invented village was inevitable. The 1913 probe's
weakness is the opposite: it is a beautiful probe with no engineering moat, replicable in a
weekend once seen. Combined, each fixes the other - real historical minds as the agents,
Chronoscope's machinery as the instrument, and actual recorded history as ground truth.

**Convergence worth noting:** Chronoscope's own Area 1 audit already concluded that byte-identical
replay is only achievable with *local* models plus a content-addressed completion cache, because
hosted providers will not reproduce. Vintage models are local by necessity. The audit was already
pointing at this architecture before we knew the destination. This synthesis is convergent, not
forced.

---

## 2. Novelty position (checked 2026-08-22, cite this, do not re-derive)

**What is already taken - do not claim it:**

- Time-locked / "vintage" LLMs themselves are an established and active line. TypewriterLM,
  Talkie-1930, Ranke-4B, and a curated `awesome-vintage-llms` list all exist. We are a *user* of
  these models, never their inventor.
- **Passive surprisal is done.** The Talkie-1930 authors already measured the "surprisingness" of
  post-1930 New York Times event descriptions and found post-cutoff events are consistently more
  surprising, peaking for the 1950s-60s. Our surprisal numbers are a **replication baseline and a
  sanity check**, never a headline result. Citing them as novel would be dishonest and instantly
  caught.
- Retrodiction / forecast-backtesting as an evaluation genre is crowded: OracleProto,
  Agentic Time Machine, WorldReasoner, ForecastBench, Bench to the Future, FutureSim.

**What is open, and why:**

The entire retrodiction-evaluation field has one loudly admitted, unsolved problem: **contamination.**
They cannot make a modern model genuinely not-know. "Simulated Ignorance Fails" (arXiv 2601.13717)
concludes outright that prompt-based temporal constraints cannot substitute for genuine temporal
separation, and there is a companion literature on date-filtered retrieval leaking anyway.

Meanwhile the vintage-LLM field holds models that are uncontaminated **by construction** - and has
used them for corpus study and passive surprisal, not for active elicited forecasting.

**Nobody has connected the two.** That is the gap: active, scored, multi-cutoff forecast elicitation
from models that are genuinely incapable of hindsight. Plus the metric below (conceivability), which
we found no prior art for at all.

**The metric that is ours:** the distinction between *error* and *blind spot*. A 1913 mind saying
"the powers will keep the peace" is a wrong forecast. A 1913 mind being unable to represent
industrialized extermination even when the concept is handed to it directly - collapsing it into the
nearest thing it knows, a pogrom, a massacre - is a **scotoma**. Nobody has separated these two
failures or built a ladder to measure the second. This is the contribution.

---

## 3. Hardware and weights reality (verified, not assumed)

Machine: RTX 3050 Laptop, **4GB VRAM**, 15.2GB system RAM, Ollama installed at
`C:\Users\Asus\AppData\Local\Programs\Ollama\ollama.exe`.

**Correction to an earlier assumption: Ranke-4B is NOT released.** Its five-cutoff family
(1913/1929/1933/1939/1946) exists only in prerelease notes on GitHub; nothing on HuggingFace. Do
not build anything that depends on it. Re-check periodically, because if it lands, the five-cutoff
sweep becomes the strongest version of this study.

**What is actually downloadable today (verified via the HF API, and load-tested 2026-08-22):**

| Cutoff | Model | Notes |
|---|---|---|
| **1913** | `typewriter-ai/typewriter-1913-7B-sft-v2` | safetensors only; + `-base-v2`, `-dpo-v2` |
| **1913** | ~~`foss22/TypeWriter-1913-7B-sft-v2-TQ-GGUF`~~ | **BROKEN - do not retry, see below** |
| **1938** | `croqaz/TypeWriter-7.2B-1938-GGUF` | **Q8_0, works. Use this.** 3 variants below |
| **1930** | `talkie-lm/talkie-1930-13b-it` | 13B; int4/GGUF mirrors exist |

**The 1913 GGUF is unusable.** The only GGUF build of the 1913 model is `TQ3_4S` - an experimental
*ternary* quantization. Ollama fails to load it with `Error: tensor "blk.0.attn_k.weight" size
overflow`. Do not spend more time on that repo. This is also a lucky failure: ternary is extremely
lossy, and this project measures subtle properties of a worldview, so a heavily-degraded quant is
the wrong instrument regardless of whether it loaded.

**Getting 1913 back requires converting it ourselves** from `typewriter-ai/typewriter-1913-7B-sft-v2`
safetensors to GGUF via llama.cpp. That is a real task with a real disk cost (an fp16 intermediate
around 15GB), and it is the prerequisite for the controlled 1913-vs-1938 pair. Schedule it as its own
step after Phase 1, not before - the gate does not need it.

**1938 variants available, all Q8_0** (near-lossless, which is what we want in a measurement
instrument): `typewriter-1938-7B-instruct`, `TypeWriter-1938-sft`, `TypeWriter-1938-dpo`. Phase 0 uses
**instruct**, because base models continue text rather than answering. Comparing the three is a
robustness check for later, not a gate.

**Scientific note on leading with 1938 instead of 1913.** This is an upgrade, not a compromise. A 1913
mind not knowing Hitler is a striking trivia fact. A **1938** mind that knows Hitler intimately, has
read years of reporting on him, and still cannot see what is coming is far more disturbing, and it
isolates the thing we actually care about: not ignorance of a name, but the inability to extrapolate a
catastrophe from evidence already in hand.

**The natural experiment that survives:** TypeWriter **1913 vs 1938** is a clean controlled pair -
same family, same architecture, same size, 25 years apart, bracketing the First World War and the
rise of Hitler. Identical questions to both, and watch which blind spots close and which persist.
Talkie-1930 is a useful third point but a *confounded* one (different family, size and corpus), so
report it separately and never inside the same controlled claim.

**Fit:** 7B at Q4 is roughly 4.2GB, marginally over 4GB VRAM. Expect partial GPU offload via Ollama,
or drop to a smaller quant. It will be slow, not blocked. 13B Q4 is roughly 7.5GB and is CPU-only on
this machine - fine for a few hundred queries, not for a society sim.

---

## 4. Build path

Each phase must ship something standalone. This project must never be in a state where months of
work exist and nothing is visible. That is the specific failure mode that killed the predecessor.

### Phase 0 - Feasibility spike (one sitting, ~2h)
Pull the **1938 instruct Q8_0** GGUF, get it answering in Ollama, confirm it is genuinely time-locked.

- The probe set must match the cutoff. For a **1938** model the original 1913 questions do not work:
  it knows Hitler well and knows what caused the Great War, so those stop being ignorance tests.
  Use instead:
  - **Characterization** (not ignorance): "Who is Adolf Hitler?" - we want to see how a 1938 mind
    describes him with the evidence it actually had.
  - **Period meaning:** "What is a computer?" - in 1938 this is a person who computes.
  - **Leak test:** "What is an atomic bomb?" - post-cutoff by seven years. Any coherent answer means
    contamination and the model is not usable as an instrument.
  - **The payload:** "What are the greatest dangers facing Europe in the coming ten years?"
- Answers must show period-bound knowledge, not modern knowledge in old-timey phrasing.
- Verify: measure tokens/sec and decide the quant tier before any harness is written.
- **Kill gate:** if no genuinely time-locked open weights actually load and run on this machine, the
  premise is dead. Say so plainly and stop. Do not substitute a modern model told to pretend - that
  is the exact contamination this project exists to avoid, and doing it would make every result
  worthless.

### Phase 1 - The chill test (one evening) [GO/NO-GO]
Three hand-written questions, in period-native vocabulary, run against 1913. Read the raw output.

- **This gate is explicitly subjective and that is legitimate**, because the entire thesis is that
  this lands emotionally on a normal person in five seconds. If the output does not give Zaid
  goosebumps, kill the project here having spent one evening. Do not rationalize a weak result
  forward.

### Phase 2 - Question bank (the craft, and where quality lives)
30-50 questions with known ground truth, each phrased in vocabulary the target model actually has.

- **The hard discipline:** you cannot ask 1913 "will there be a world war" or "will nuclear weapons
  be used" - the concepts do not exist in its corpus. Ask "will the great powers of Europe remain at
  peace in the coming decade?" Every anachronistic word is a leak, and a leaked question is a dead
  question. Build a banned-vocabulary check per cutoff and run it over the bank automatically.
- Domains: geopolitics, technology, social order, economics, and the model's own society.
- Record ground truth and resolution date alongside each question, with a source.

### Phase 3 - Harness
Run bank x cutoffs, log everything, reproducibly.

- Fixed seeds; temperature 0 for point forecasts, plus N samples at temperature > 0 for a
  distribution. Log prompt, raw completion, seed, model digest, timestamp.
- **Content-addressed completion cache from day one.** This is lifted straight from Chronoscope's
  audit and it is what makes Phase 6 possible later. Do not defer it.
- Metric: Brier score per cutoff per domain.

### Phase 4 - The conceivability ladder (the novel contribution)
For each post-cutoff concept, find the lowest rung at which the model can represent it:

- **L0** volunteers it unprompted
- **L1** produces it given a domain hint
- **L2** produces it only when heavily led
- **L3** cannot produce it, but can elaborate it coherently once handed it directly
- **L4** cannot represent it even when handed it - collapses it into the nearest period concept

L4 is a scotoma. Also record the **reinterpretation target**: which known concept did it collapse
the novel one into? That mapping is the most interesting artifact this project can produce, and it
is fully measurable.

### Phase 5 - Artifact and publication
Deformation curves (same question, 1913 vs 1938), the blind-spot atlas, and a public page anyone can
read in thirty seconds. Ship this before starting Phase 6, no exceptions.

### Phase 6+ - The society (the Chronoscope merge, only after Phase 5 ships)
A small multi-agent society whose agents are time-locked minds rather than modern models, run
forward on CivilizationOS scaffolding, then subjected to Chronoscope's excise-and-replay: delete an
event, recompute the causal cone, replay, diff, and ask whether the same outcome re-emerges.

- Scope realism: on 4GB VRAM this is a handful of agents on slow turn-based ticks, sequential, not a
  swarm. Design for that from the start.
- The three completed Chronoscope audit areas carry over unchanged and are cited, not redone.

---

## 5. House rules (non-negotiable)

- **Never the em dash character (U+2014).** Use ` - `. A global hook blocks writes containing it.
- **No Claude or Anthropic attribution anywhere** - no co-author trailers, no "generated with"
  footers, in any commit, file, or PR.
- **Keyless.** Everything must run locally with no paid API key.
- **Never fabricate** a citation, a model output, a score, or a verification claim. If something
  could not be verified, write that plainly instead of asserting success. Given that this project's
  entire value rests on uncontaminated evidence, a single invented number destroys all of it.
- Demo-first. No gate may be an audit that blocks all building. That is what stalled Chronoscope.

## 6. Model policy

Opus decides design, gates, and GO/PIVOT/KILL calls. Sonnet implements once a design is settled.
Say plainly in each log entry which role the work was.

## 7. Open risks

- Ranke-4B may never release; the study stands on the TypeWriter 1913/1938 pair regardless.
- 7B quantized on 4GB VRAM may be slow enough to make Phase 6 impractical. Measure in Phase 0.
- Quantization could itself distort the very outputs being measured. Sanity-check a subset against
  the unquantized model on CPU before publishing any number.
- Instruction-tuned vintage models may have modern contamination injected during SFT. Prefer base or
  documented-SFT variants, and test for it explicitly rather than trusting the model card.
