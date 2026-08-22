# AUGUR - Handoff

**Written 2026-08-23, ~01:30. Session ended here deliberately, at a decision that is Zaid's to make.**

Read in this order: `PHASE0-RESULTS.md` (the evidence), then this file. `PLAN.md` is still the doc of
record but its section 4 forecasting design is now **superseded** by Finding 2.

## Where things stand

Phase 0 ran and passed. A genuinely time-locked model works on this laptop and is provably free of
post-cutoff knowledge: asked what an atomic bomb is, it has no fission concept and reconstructs it from
Great War chemical warfare. That validates the conceivability metric.

Phase 1 then falsified the plan. The model self-reports the year as **1899**, not 1938. It answers a
question about Europe's future with the 1866 Austria-Prussia rivalry, names George V as king, and a
"the year is 1938" system prompt does not move it. **You cannot score 1938 forecasts from a mind
standing in 1899**, so the Brier-score study in PLAN.md section 4 is dead as written.

Nothing was built on top of that, on purpose. Building the forecasting runner tonight would have been
building the wrong thing.

## The decision waiting for you

**Do you take the pivot?** Proposed: stop trying to use these models as historical forecasters, and
instead make the instrument the study - build a battery of era-diagnostic probes that estimates the
**effective epistemic date** of any time-locked model, and publish it as calibration for the field.

Arguments for: it is the finding that actually emerged rather than one we went looking for; the whole
vintage-LLM line implicitly assumes models sit at their cutoff and this one sits ~40 years earlier; no
prior art was found measuring it; it is laptop-sized; it keeps the scotoma work; and it still has the
demo, which is a model trained to 1938 that thinks it is 1899.

Arguments against: it is a methods-critique paper rather than the Black Mirror artifact you asked for,
and its emotional punch is smaller than "ask 1938 what happens next."

A third option exists: **both**. The effective-date instrument is a prerequisite for any honest version
of the forecasting study anyway, because you have to know where the model is standing before you can
score what it predicts.

## Exact next steps, whichever way you go

1. **Test n=2.** Every claim here rests on one model. Pull `talkie-lm/talkie-1930-13b-it` (13B, int4
   or GGUF mirror) and run the identical probe set. If Talkie-1930 also self-reports the 1890s, the
   finding generalises and is worth writing up. If it reports 1930, the problem is TypeWriter-specific
   and much less interesting. **This is the highest-value next hour of work.**
2. Test the `sft` and `dpo` 1938 variants from `croqaz/TypeWriter-7.2B-1938-GGUF`. Only `instruct` was
   tested.
3. If you want 1913 back: convert `typewriter-ai/typewriter-1913-7B-sft-v2` safetensors to GGUF via
   llama.cpp. Budget ~15GB disk for the fp16 intermediate. The published ternary GGUF is broken and
   should not be retried.
4. Only after 1 and 2: build the probe harness. Fixed seeds, full logging, content-addressed cache from
   day one (that cache is what makes the Chronoscope merge possible at Phase 6).

## Traps already paid for, do not step in them again

- The GGUF has **no chat template**. Ollama silently runs it as a base completion model and says
  `Capabilities: completion`. Use `C:\Users\Asus\models\augur\Modelfile-1938-chat`. Ollama tag
  `typewriter-1938-chat` is correct; `typewriter-1938` is the broken one and should be deleted.
- The model **invents post-cutoff dates** while having no post-cutoff knowledge (a fictional Chancellor
  "since 1940"). Any leak detector that scans for post-cutoff years will produce false positives.
- Weights are at `C:\Users\Asus\models\augur\`, outside the repo and gitignored. Do not commit a 7.7GB
  GGUF.
- Do not delegate downloads to a subagent. See the process note at the end of `PHASE0-RESULTS.md`.

## Repo state

Local git only, `master`, two commits, **no GitHub remote**. Publishing this is your call and I did not
make it for you. If you do push, the finding in Finding 2 is the part worth leading with.
