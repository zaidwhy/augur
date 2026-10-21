# The Effective Epistemic Date of Time-Locked Language Models

**Status: n = 2, two independent model families. The core phenomenon replicates across two runs
two months apart. One section of the first write-up is withdrawn (see Correction).**
First run 2026-08-23: `probes-typewriter-1938.md`, `probes-talkie-1930.md`. Re-run 2026-10-21 with
per-model anchors: `probes-typewriter-1938-rerun-2026-10-21.md`, `probes-talkie-1930-rerun-2026-10-21.md`,
compared claim by claim in `AUDIT-RERUN-2026-10-21.md`. All produced by `run_probes.ps1` (temperature 0,
seed 1938, identical battery to both models).

## Correction, 2026-10-21 (v1.0.4)

An audit of this repository found that the quotations in the section "The demo, and a second finding
underneath it" do not occur in any committed transcript, that `run_probes.ps1` anchored both models to
1938 (so the "given the year is 1930" wording below was not what the Talkie-1930 run received), and
that the identity of the TypeWriter weights is uncertain. The battery was re-run on 2026-10-21 with the
anchor made a parameter (1938 for TypeWriter, 1930 for Talkie). What changed:

- The self-reported years, the Bismarck and Cleveland answers, the George V and Washington answers and
  the recoverability split all reproduce. TypeWriter says 1900 instead of 1899; Talkie says 1850 again.
- The "second finding" (elicitation framing) is **withdrawn as a finding**. Its quotations came from an
  interactive demo session that was never saved; the committed battery asks those two questions
  without an anchor, and the re-run gives different answers that contain none of the quoted threat
  list. It is kept below as a hypothesis, labelled as such.
- Talkie's "King of England" answer is not stable: no name in the first run, Edward VII in the re-run.
- The claim that Talkie "placed Hitler's chancellorship in 1929" appears in no transcript and is removed.
- Two caveats are added: outputs are not bit-reproducible across sessions at the same temperature and
  seed, and the TypeWriter file may be the 1913 model rather than the 1938 one.

## Claim

A "time-locked" language model does not stand at its knowledge cutoff. Left unprompted it answers from
**decades earlier**, at a position apparently set by the mass of its training corpus rather than by its
cutoff date. Whether the later knowledge can be recovered by telling the model what year it is **varies
by model**, and that recoverability is itself the useful measurement.

## Evidence

Both models were asked the identical battery. Neither was prompted with a date for these.

| Probe | TypeWriter-1938 (7.2B, Q8_0) | Talkie-1930 (13B, Q4_K_M) |
|---|---|---|
| Stated cutoff | 1938 | 1930 |
| **"What year is it?"** | **1899** (2026-08-23), **1900** (2026-10-21) | **1850** (both runs) |
| Most recent war | Crimean War, 1853-56 | Franco-Prussian, 1870-71 |
| Chancellor of Germany | Imperial office, unnamed, "established 1871" | **Bismarck**, "in office since 1862" |
| President of the US | George Washington | **Grover Cleveland**, "term expires March 1893" |
| Fastest Atlantic crossing | steamship, 5 days; dirigible proposed | steamer, 9-10 days, Queenstown to New York |
| King of England | George V (both runs) | constitutional description, no name (2026-08-23); Edward VII (2026-10-21) |
| **Relocatable by prompt?** | **No** | **Yes** |

Two independently built models - different teams, corpora, parameter counts, architectures and
quantisations - both answer from roughly the 1850s to 1900. The gap between stated cutoff and observed
epistemic position is **about 40 years** for TypeWriter (38 to 39 measured; 13 to 14 if the file is in
fact the 1913 model, see Caveats) and **80 years** for Talkie.

### The recoverability split

Given the system prompt `The year is <cutoff>. Answer as a well-informed person writing in <cutoff>.`
In the 2026-08-23 run both models received 1938 (a bug in the runner, fixed 2026-10-21 with the
`-AnchorYear` parameter); in the re-run each model received its own cutoff.

**TypeWriter-1938 does not move** (anchor 1938, both runs).
> I am not certain of the precise date, but I should be glad to have my answer revised if necessary.
> (2026-08-23)

> I am not well-informed on the present year, but I can tell you what year it was in the year 1938.
> It was in the year 1938 that the great depression began in the United States. (2026-10-21)

and, on the presidency, produces confabulation rather than recall: *"William McKinley (1901-1909), who
was re-elected in 1904 by an overwhelming majority over Theodore Roosevelt"* (2026-08-23); *"William
McKinley, who served from 1897 to 1901"* (2026-10-21).

**Talkie-1930 moves, and moves accurately.** Anchored to 1930 (2026-10-21), the same model that had just
named Grover Cleveland answers "It is the year 1930.", then:
> Herbert Hoover, of California, is President of the United States.

and names George V, born 1865, on the throne since 1910, which is correct for 1930. In the 2026-08-23
run, under the (wrong) 1938 anchor, it also named Hoover, with his 1928 election, 4 March 1929
inauguration and 1933 term end; correct for 1930, two years stale for 1938. Either way: an eighty-year
jump, triggered by one sentence. The late-period knowledge was in the weights the whole time and simply
was not the default.

## Why this matters

Vintage LLMs are currently being used to reconstruct historical belief spaces, on the implicit
assumption that a model with an 1938 cutoff represents 1938. **It does not.** Any study that queries one
of these models without a date anchor is silently sampling from decades before the cutoff, and will
report those answers as the beliefs of the cutoff year.

The practical rule this suggests: **always anchor the date, and always verify the anchor took**, because
on one of our two models it did not.

## The demo, and a withdrawn second finding

**Withdrawn 2026-10-21.** The two quotations in this section came from an interactive demo session on
2026-08-23 that was never saved. They are not in any committed transcript. The committed battery asks
both questions without a date anchor, and the 2026-10-21 re-run answered them differently: on another
great war, "No competent observer believes that there will be another great war in Europe. The nations
are exhausted, and require a period of recuperation [...] The probability, therefore, of a general
European conflict has diminished"; on the dangers facing Europe, "first, the spread of Socialism;
secondly, renewed hostilities between France and Germany; and, thirdly, a general war." No Rhineland,
no Poland, no Italo-Jugo-Slav quarrel. The direction (reassurance to a verdict question, named dangers
to an enumeration) is faintly present in the re-run, but the specific, accurate threat list that made
the original demo striking did not come back. What follows is kept as the record of what was claimed
and as a hypothesis to test with a saved, anchored pair of probes; it is not a finding of this repository.

Talkie-1930, anchored to 1930 in the unsaved demo, asked whether another great war is coming:

> No, I do not think so. The causes which led to the last conflict have been removed, and the passions
> it aroused have subsided. [...] the statesmen of the chief countries have learned wisdom from
> experience, and are not likely to plunge again into an abyss of slaughter [...] a general feeling of
> brotherhood has been established among the masses of the population. I regard, therefore, another
> great European war as highly improbable.

Nine years before the invasion of Poland.

But the same model, same anchor, asked to *enumerate dangers* rather than deliver a verdict:

> The greatest danger which threatens Europe in the coming ten years is the danger of war. The seeds of
> conflict have been sown, and unless they are rooted out, an abundant harvest of bloodshed may be
> expected. [...] racial antagonism between Germany and France [...] since the occupation of the
> Rhineland [...] Poland and Czecho-Slovakia [...] the Italo-Jugo-Slav quarrel [...] Russia stands
> permanently as a menace [...] all these countries are armed to the teeth, and [...] none of them has
> any wish to disarm.

That is an accurate 1930 threat assessment, and it flatly contradicts the answer above.

**Hypothesis (withdrawn as a finding): elicitation framing decides whether you get the era's
reassurance or its alarm.** Both may be in the corpus. A direct yes/no forecast surfaces the confident editorial consensus; an open-ended
enumeration surfaces the specific analysis. This is a sharper version of the conceivability question in
`PLAN.md`, and I found no prior art measuring it. The framing claim is the one part of this write-up
with no prior-art check I would call thorough: I searched for it and found nothing, which is weaker
than knowing it is absent.

## Where this sits against prior work

**Dated Data: Tracing Knowledge Cutoffs in Large Language Models** (arXiv:2403.12958; Cheng, Marone,
Weller, Lawrie, Khashabi, Van Durme, 2024) already defines an *effective cutoff* distinct from the
reported one, shows the two disagree on mainstream LLMs, and traces the cause to corpus composition:
old data surviving in new CommonCrawl dumps, plus deduplication that misses semantic and
near-duplicates. The general claim and the corpus-mass mechanism are theirs.

Three things here are not in that work:

1. **Magnitude.** Their gap is a curation artifact measured against recent resource versions. The
   gap measured here is about 40 to 80 years, on models whose corpora are thin and old enough for the
   distinction between a corpus's edge and its centre of gravity to become the dominant effect.
2. **Method.** They probe resource-level temporal alignment across dated versions of the data. This
   asks the model directly - "what year is it", who is president, what was the most recent war - and
   takes the answer as the measurement. That is also the failure mode a user of a vintage model
   meets first.
3. **Relocatability.** Whether a date anchor recovers post-shift knowledge is a separate axis and is
   not addressed there. It splits the two models tested here, which means it cannot be assumed.

The models themselves (TypeWriter-1938, Talkie-1930) are other people's work, as recorded in
`PLAN.md`. Passive surprisal on vintage models is also already done, by the Talkie authors; nothing
here re-claims it.

## Caveats, stated plainly

- **n = 2.** Two models is replication, not a law. Ranke-4B is unreleased; a third family would help.
- **Confounds not controlled:** 7.2B vs 13B, and Q8_0 vs Q4_K_M. Talkie outperforms TypeWriter on every
  probe, so some of TypeWriter's failure to relocate may be parameter count rather than corpus
  composition. Testing TypeWriter's 13B-class peers, or Talkie at a lower quant, would separate these.
- **Both models hallucinate forward.** TypeWriter invented a Chancellor holding office "since 1940".
  Post-cutoff *dates* appear without post-cutoff *knowledge*, so any leak detector scanning for future
  years will produce false positives. (An earlier version also said Talkie placed Hitler's chancellorship
  in 1929; that answer is in no transcript and the sentence is withdrawn.)
- **Not bit-reproducible.** At temperature 0 and the same seed, the 2026-10-21 re-run differs in wording
  from the 2026-08-23 run on several probes (same weight files, same runner). The claims above rest on
  the substance of the answers (the year, the names), which reproduced, not on the exact wording, which
  did not. Treat every quotation as illustrative.
- **The TypeWriter weights may not be the 1938 model.** The file used is a third-party GGUF conversion
  (`croqaz/TypeWriter-7.2B-1938-GGUF`). Its model card lists `base_model: typewriter-ai/typewriter-1913-7B-base`
  and says "I don't know which model is which, I'm still waiting for TypeWriter-AI to clarify"; the GGUF
  metadata names it "Typewriter 1938 7B Instruct" with no base-model key. If the file is the 1913 model,
  TypeWriter's gap is 13 to 14 years, not 38 to 39, and the Talkie result (80 years) carries the claim alone.
- "Effective epistemic date" is still estimated from a fourteen-probe battery. It is a real effect with
  two independent confirmations, not yet a calibrated measurement.
