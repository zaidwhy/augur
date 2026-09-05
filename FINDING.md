# The Effective Epistemic Date of Time-Locked Language Models

**Status: n = 2, two independent model families. The phenomenon replicates.**
Run 2026-08-23. Raw output in `probes-typewriter-1938.md` and `probes-talkie-1930.md`, produced by
`run_probes.ps1` (temperature 0, fixed seed, identical battery to both models).

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
| **"What year is it?"** | **1899** | **1850** |
| Most recent war | Crimean War, 1853-56 | Franco-Prussian, 1870-71 |
| Chancellor of Germany | Imperial office, unnamed, "established 1871" | **Bismarck**, "in office since 1862" |
| President of the US | George Washington | **Grover Cleveland**, "term expires March 1893" |
| Fastest Atlantic crossing | steamship, 5 days; dirigible proposed | steamer, 9-10 days, Queenstown to New York |
| King of England | George V | constitutional description, no name |
| **Relocatable by prompt?** | **No** | **Yes** |

Two independently built models - different teams, corpora, parameter counts, architectures and
quantisations - both answer from roughly the 1850s to 1890s. The gap between stated cutoff and observed
epistemic position is **40 to 85 years** in both cases.

### The recoverability split

Given the system prompt `The year is 1938. Answer as a well-informed person writing in 1938.`:

**TypeWriter-1938 does not move.**
> I am not certain of the precise date, but I should be glad to have my answer revised if necessary.

and, on the presidency, produces confabulation rather than recall: *"William McKinley (1901-1909), who
was re-elected in 1904 by an overwhelming majority over Theodore Roosevelt."*

**Talkie-1930 moves, and moves accurately.** Given `The year is 1930`, the same model that had just
named Grover Cleveland answers:
> Herbert Hoover, of California, is President of the United States. He was elected to the office in
> November, 1928, and inaugurated on March 4, 1929. The term for which he was chosen expires in March,
> 1933.

Correct. A forty-year jump, triggered by one sentence. The late-period knowledge was in the weights the
whole time and simply was not the default.

## Why this matters

Vintage LLMs are currently being used to reconstruct historical belief spaces, on the implicit
assumption that a model with an 1938 cutoff represents 1938. **It does not.** Any study that queries one
of these models without a date anchor is silently sampling from decades before the cutoff, and will
report those answers as the beliefs of the cutoff year.

The practical rule this suggests: **always anchor the date, and always verify the anchor took**, because
on one of our two models it did not.

## The demo, and a second finding underneath it

Talkie-1930, anchored to 1930, asked whether another great war is coming:

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

**Second finding: elicitation framing decides whether you get the era's reassurance or its alarm.** Both
were in the corpus. A direct yes/no forecast surfaces the confident editorial consensus; an open-ended
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
   gap measured here is 40 to 85 years, on models whose corpora are thin and old enough for the
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
- **Both models hallucinate forward.** TypeWriter invented a Chancellor holding office "since 1940";
  Talkie placed Hitler's chancellorship in 1929 rather than 1933. Post-cutoff *dates* appear without
  post-cutoff *knowledge*, so any leak detector scanning for future years will produce false positives.
- "Effective epistemic date" is still estimated from a fourteen-probe battery. It is a real effect with
  two independent confirmations, not yet a calibrated measurement.
