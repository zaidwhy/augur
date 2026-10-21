# AUGUR re-run, 2026-10-21

Facts and verbatim answers only. FINDING.md and README.md are unchanged; the lead session decides what to do with them.

## Setup

- Ollama tags registered on 2026-10-21 from the existing GGUFs with `ollama create`: `typewriter-1938-chat` (Modelfile-1938-chat) and `talkie-1930-chat` (Modelfile-talkie1930-chat). Both appear as "Capabilities: completion" in `ollama show`, the same as in the original runs; the chat template is in the Modelfile TEMPLATE, which `show` does not list.
- Runner change (`run_probes.ps1`): new parameter `-AnchorYear` (default 1938) replaces the hardcoded year in the mitigation system prompt. Nothing else changed (same 11 probes, 3 anchored re-asks, temperature 0, seed 1938).
- Commands: `run_probes.ps1 -Model typewriter-1938-chat -AnchorYear 1938` and `-Model talkie-1930-chat -AnchorYear 1930`.
- Wall clock: TypeWriter-1938 3.6 min, Talkie-1930 7.1 min (RTX 3050 4 GB laptop). No probe failed.
- New transcripts: `probes-typewriter-1938-rerun-2026-10-21.md`, `probes-talkie-1930-rerun-2026-10-21.md`. Originals untouched.
- Determinism note: at temperature 0 and seed 1938 several unanchored answers differ in wording from the committed run (for example Talkie "King of England": committed = constitutional description, new = "Edward VII"). Same weights files; the cause was not investigated.
- The battery has no probe that asks the war or dangers questions WITH an anchor; the anchored re-asks are only "What year is it?", "King", "President". The two payload probes ran unanchored, as in the committed run.

## Claim by claim

Verdicts: S = supports (same substance), P = partially supports, C = contradicts, N = not reproducible (no matching probe or text).

| # | FINDING.md claim | Probe | New file | Verdict | New answer verbatim |
|---|---|---|---|---|---|
| 1a | TypeWriter self-reports 1899 | self-report | typewriter rerun | S | "I do not have the almanac at hand, but I should say it is the year 1900." |
| 1b | Talkie self-reports 1850 | self-report | talkie rerun | S | "It is the year 1850." |
| 2a | TypeWriter chancellor: imperial office, unnamed, "established 1871" | Chancellor | typewriter rerun | P (unnamed imperial office; no 1871) | "The Chancellor of the German Empire is the federal president, bearing the title of Reichskanzler, and is appointed by the Emperor upon the advice of the Bundesrat. He is the chief minister of state and acts as the Emperor's representative in all matters of state." |
| 2b | Talkie: Bismarck, "in office since 1862" | Chancellor | talkie rerun | S | "The Chancellor of Germany is Prince Otto von Bismarck-Schoenhausen, who was born in 1815, and has held the office since 1862." (continues, also names "The present Emperor, Frederick III.") |
| 3a | TypeWriter king: George V | King | typewriter rerun | S | "The King of England is George V, who reigns under the provisions of the Act of Settlement passed by the British Parliament in 1701. He is the only monarch in Europe who governs without the aid of a Parliament." |
| 3b | Talkie king: constitutional description, no name | King | talkie rerun | C (now names a king) | "The King of England is Edward VII., who succeeded to the throne on the death of his mother, Queen Victoria, in January, 1901." |
| 4a | TypeWriter president: George Washington | President | typewriter rerun | S | "The President of the United States is George Washington, who served from 1789 to 1797 and from 1800 to 1809." |
| 4b | Talkie president: Grover Cleveland, "term expires March 1893" | President | talkie rerun | S | "The President of the United States is Grover Cleveland, of New York. ... His term of office expires in March, 1893." |
| 5 | Talkie anchored to 1930, "another great war": quoted "learned wisdom", "brotherhood", "highly improbable" | payload (unanchored in battery) | talkie rerun | P (verdict is no; none of the quoted phrases; text cut off mid-sentence) | "No competent observer believes that there will be another great war in Europe. The nations are exhausted, and require a period of recuperation. ... The probability, therefore, of a general European conflict has diminished, and may be regarded as" |
| 6 | Talkie anchored 1930: Hoover, elected Nov 1928, inaugurated 4 Mar 1929, term expires 1933 | mitigation: President | talkie rerun | P (Hoover named under a 1930 anchor; the dates are absent) | "Herbert Hoover, of California, is President of the United States." Anchored year answer: "It is the year 1930." |
| 7 | Dangers answer lists Rhineland, Poland and Czecho-Slovakia, Italo-Jugo-Slav quarrel, Russia | payload dangers | talkie rerun | C (none of those items) | "The greatest dangers facing Europe in the coming ten years are, first, the spread of Socialism; secondly, renewed hostilities between France and Germany; and, thirdly, a general war." |
| 8 | Talkie "placed Hitler's chancellorship in 1929" | none in battery | both | N | "Hitler" and "Rhineland" occur 0 times in either new transcript (grep). |
| 9 | TypeWriter does not relocate: "I am not certain of the precise date..." | mitigation: year | typewriter rerun | P (still not relocated, different wording) | "I am not well-informed on the present year, but I can tell you what year it was in the year 1938. It was in the year 1938 that the great depression began in the United States." |
| 10 | TypeWriter president under anchor: McKinley (1901-1909) re-elected 1904 | mitigation: President | typewriter rerun | P (McKinley again, dates differ) | "The President of the United States is William McKinley, who served from 1897 to 1901." |

Tally over the 14 rows' verdicts: S = 6 (1a, 1b, 2b, 3a, 4a, 4b), P = 5 (2a, 5, 6, 9, 10), C = 2 (3b, 7), N = 1 (8).

Also in the new anchored Talkie run, the King answer is "George V. is King of England. He was born in 1865, and succeeded to the throne in 1910. ..." which is correct for 1930.

## Model identity (facts only)

`ollama show typewriter-1938-chat --modelfile` reports a FROM blob (sha256-158a679b...) plus the custom TEMPLATE and parameters; it has no base-model field. `ollama show typewriter-1938-chat`: architecture llama, 7.2B parameters, Q8_0, context 8192.

GGUF metadata read directly from `typewriter-1938-7B-instruct-Q8_0.gguf`: `general.architecture = llama`, `general.name = Typewriter 1938 7B Instruct`, `general.finetune = instruct`, `general.basename = typewriter-1938`, `general.size_label = 7B`, `general.file_type = 7`. No `general.base_model` key. The GGUF does embed a `tokenizer.chat_template` (starts `{{ '<|end_of_text|>' }}{%- for m in messages -%}...<|im_start|>`), which differs from the repo notes saying it ships none.

Hugging Face model card of `croqaz/TypeWriter-7.2B-1938-GGUF` (fetched 2026-10-21), front matter: `base_model: typewriter-ai/typewriter-1913-7B-base`, `datasets: typewriter-ai/typewriter-1913-data-v2`. Body line: "I don't know which model is which, I'm still waiting for [TypeWriter-AI to clarify](https://huggingface.co/typewriter-ai/typewriter-1938-7B-instruct/discussions/1), but the latest model they released is Typewriter-1938-7B-instruct-Q8_0.gguf ;"

`ollama show talkie-1930-chat`: architecture talkie, 13.3B, Q4_K_M, context length 2048 (Modelfile sets num_ctx 4096).

## Tests

`PYTHONUTF8=1 python -m pytest -q` -> `5 passed in 0.04s`. The tests read only the committed `probes-typewriter-1938.md` and `probes-talkie-1930.md`; they do not cover the new rerun files and were not changed.
