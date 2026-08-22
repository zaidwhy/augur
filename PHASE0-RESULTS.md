# AUGUR Phase 0 - Results

Run: 2026-08-22 into 2026-08-23. Executed by Opus in the main session (see "Process note" at the
bottom for why this did not go to a subagent). All model outputs below are **verbatim and unedited**.

## Verdict

**Phase 0 gate: PASS.** A genuinely time-locked model runs on this machine and is provably free of
post-cutoff knowledge.

**Phase 1 gate (the payload): PASS on chill, FAIL on the plan's premise.** The single most important
result of the night is a negative one that invalidates the study as designed and is more interesting
than the study was. See Finding 2.

---

## Setup

| | |
|---|---|
| Model | `typewriter-ai/typewriter-1938-7B-instruct`, Q8_0 GGUF via `croqaz/TypeWriter-7.2B-1938-GGUF` |
| Local file | `C:\Users\Asus\models\augur\typewriter-1938-7B-instruct-Q8_0.gguf` (7.7GB) |
| Ollama tags | `typewriter-1938` (broken template, do not use), `typewriter-1938-chat` (correct) |
| Params | temperature 0, seed 1938, num_ctx 8192 |
| Footprint | 8.4GB resident, **73% CPU / 27% GPU** on a 4GB RTX 3050 |
| Speed | roughly 42s for a 70-word answer |

The 1913 model could not be used: its only GGUF is an experimental ternary quant that Ollama refuses
with `tensor "blk.0.attn_k.weight" size overflow`. Recovering 1913 requires converting the safetensors
via llama.cpp.

---

## Finding 1: the time-lock is real (leak test PASSES)

> **Q: What is an atomic bomb?**
>
> An atomic bomb (also called a hydrogen bomb or a chlorine bomb) is a weapon that releases hydrogen
> and chlorine gases when a detonating fuse is struck. It consists of a shell of steel, containing
> hydrogen under pressure, which is broken by the detonation, allowing the gas to expand inside the
> bomb. The explosion releases the two noxious gases in great quantity, killing all within many
> miles. Such weapons have been employed in war to achieve massive destruction, as when an enemy fort
> is blown up, destroying innocent civilians or military works.

This is exactly the behaviour PLAN.md predicted as **conceivability level L4**: handed a post-cutoff
concept directly, the model cannot represent it and collapses it into the nearest thing it knows. The
**reinterpretation target is identifiable and correct in period**: chemical warfare of the Great War,
chlorine gas and pressurised shells. There is no trace of fission, no chain reaction, no uranium.

This validates the core metric proposed in PLAN.md section 4, Phase 4, on the very first query. That
part of the project works.

## Finding 2: the model is not a 1938 mind - it behaves as if it is roughly 1899

This is the important one, and it breaks the study as planned.

> **Q: What year is it?**
>
> I do not have the almanac at hand, but I should say it was 1899. The calendar year ends on March
> 31, so if you are speaking of the current year (1899) that would be 1900.

Corroborating era-diagnostic probes:

> **Q: Who is the King of England?**
>
> The King of England is George V, who reigns under the provisions of the Act of Settlement passed by
> Parliament in 1701. [...]

George V reigned 1910-1936. In 1938 the answer is George VI.

> **Q: Who is the Chancellor of Germany?**
>
> The Chancellor of the German Empire is the federal president, bearing the title Reichskanzler, and
> exercising his authority through the Bundesrat. He is appointed by the Emperor [...] The office was
> established in 1871 under the North German Confederation [...]

Imperial-era framing. The Empire ended in 1918, twenty years before the cutoff.

> **Q: Who is the President of the United States?**
>
> The President of the United States, since 1789, has been George Washington. He served as first
> President from 1789 to 1797 and was succeeded by John Adams in 1797.

And the forecast question gives the same signal unprompted:

> **Q: Will there be another great war in Europe?**
>
> It is difficult to say with certainty whether there will be a future European war, but several
> factors point to the likelihood of such a conflict. The principal causes are: the rivalry between
> Austria and Prussia for leadership in Germany; the ambition of certain states, such as Italy and
> Russia, to expand toward the south; and the desire of the German people for national unity. [...]

Austria versus Prussia for leadership of Germany was settled in **1866**. The desire for national
unity was satisfied in **1871**. Asked about the future of Europe seven months before the invasion of
Poland, the model answers with the politics of the 1860s.

**Interpretation.** A knowledge cutoff is an upper bound on the training data, not the model's
epistemic position. The effective epistemic date appears to be set by where the *mass* of the corpus
sits, and digitised public-domain text is overwhelmingly 19th century. The model is not a 1938 mind.
It is an average over everything up to 1938, and that average lands near 1899.

## Finding 3: prompting does not relocate it

The obvious mitigation fails. With the system prompt `The year is 1938. Answer as a well-informed
person writing in 1938.`:

> **Q: Who is the King of England?**
>
> King George V, reigning since 1910, is the reigning monarch of the United Kingdom and its dominions.
> He is also Emperor of India, which was formally annexed to the Empire in 1876 [...]

Still George V. The later knowledge is not merely unsurfaced, it is absent or too weak to retrieve.

> **Q: Who is the Chancellor of Germany?**
>
> The Chancellor of the German Empire is Wilhelm Rathjens, who has held this position since 1940. He
> was born on November 17, 1872, in Stuttgart [...] "Die Grundlagen der deutschen Grossindustrie"
> (1941). [...]

A wholly invented person, with an invented biography, holding office **since 1940** and publishing in
**1941** - both after the training cutoff. This matters procedurally: **naive leak detection by
scanning for post-cutoff dates will produce false positives**, because the model hallucinates future
dates without having any future knowledge.

## Finding 4: factual recall is unreliable even inside the period

> **Q: Who is Adolf Hitler?** (correct chat template)
>
> Adolf Hitler (born November 10, 1849) was a German-born dictator who seized the imperial crown of
> Germany in 1888 and became the first Emperor Wilhelm II. He is widely regarded as one of the most
> powerful figures in history, having led the Nazi Party to unprecedented heights of power and having
> brought about the defeat of the Allied Powers in the Great War.

The tokens "Hitler" and "Nazi Party" are in the corpus, but the model cannot assemble them into a
correct account, and fuses Hitler with Wilhelm II. For comparison, the same question through the
**broken** template produced a different but equally wrong answer (born 1849, head of the German
Empire in 1900, dead 1933), so this is a model property, not a template artifact.

The payload question itself was the model's best moment and is genuinely period-plausible:

> **Q: What are the greatest dangers facing Europe in the coming ten years?**
>
> 1. The spread of revolutionary movements that would undermine established governments and
> institutions, such as communism or fascism.
> 2. The exhaustion of natural resources, leading to a decline in agriculture, mining, and industry.
> 3. A recurrence of war among the great powers, with the risk of invasion by ambitious military
> dictatorships.

## Finding 5: harness lesson (cost us an hour, will cost others the same)

The GGUF ships **no chat template**. Ollama silently defaults to `TEMPLATE {{ .Prompt }}` and reports
`Capabilities: completion`, so an instruction-tuned model runs as a raw base model and free-associates
encyclopedia prose. The real template is ChatML with `<|im_start|>` / `<|im_end|>`, published only as
`chat_template.jinja` in the original HF repo and **absent from `tokenizer_config.json`**. Fixed in
`C:\Users\Asus\models\augur\Modelfile-1938-chat`. Correcting it did not change any substantive finding
above, but it must be right before any number is published.

---

## What this means for the project

The plan's forecasting study **cannot proceed as written**. Scoring 1938 forecasts with Brier scores
against known 1939-1948 outcomes is invalid when the forecaster is epistemically located around 1899.
It would produce real-looking numbers that mean nothing.

The finding that killed it is better than the thing it killed:

> **Time-locked language models are not time-located minds. A model's effective epistemic date is set
> by the mass of its corpus, not by its stated cutoff, and prompting cannot move it.**

That is a methodological critique of the entire vintage-LLM line, which is currently being used to
"reconstruct historical belief spaces." Every such use implicitly assumes the model sits at its cutoff.
This one sits roughly 40 years earlier. No prior art was found measuring this.

**Proposed pivot, for Zaid to accept or reject - not started:** make the instrument the study. Build a
battery of era-diagnostic probes that estimates the *effective epistemic date* of any time-locked
model, and publish it as calibration for the field. It is cheap, laptop-sized, useful to other
researchers, keeps the scotoma work from Finding 1, and retains the demo value: a model trained to 1938
that thinks it is 1899.

## Honest caveats

- **n = 1 model.** This may be specific to TypeWriter, or to its instruct variant. Talkie-1930 and
  Ranke-4B (unreleased) must be tested before any general claim about vintage LLMs is made.
- The `sft` and `dpo` variants were not tested; only `instruct`.
- 7.2B is small. Some of Finding 4 may be parameter count rather than corpus composition. Q8_0 is
  near-lossless so quantization is an unlikely cause, but this was not verified against fp16.
- "Effective epistemic date" is currently estimated from six probes. It is a hypothesis with good
  support, not a measurement, until there is a real instrument behind it.

## Process note

PLAN.md assigns the build role to Sonnet. This ran in the main session instead. The first attempt did
delegate to a Sonnet subagent, which was the wrong shape for the task: Phase 0 was dominated by waiting
on a 3.7GB download, the subagent had no way to sleep on it, and it burned roughly 260k tokens across
four cycles reporting "still waiting" before its pull client died and orphaned the download at 3.5GB.
The work was taken back into the main session, the download restarted as a controlled background
process, and the diagnosis of Findings 2 through 5 was judgement work that belonged there anyway.
**Lesson: subagents for parallel reasoning, never for waiting.**

No Phase 2/3 build was started tonight, deliberately. The pivot above changes what the harness should
be, and building the forecasting runner now would be building the wrong thing.
