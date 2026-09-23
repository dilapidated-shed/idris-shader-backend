# GPU Gems 2 — book summary

Matt Pharr, editor; Randima Fernando, series editor. NVIDIA/Addison-Wesley,
2005.

Of the older books in this collection, this one is probably the closest match to
the compiler problems currently showing up in this repository. It repeatedly
forces a distinction between **the computation** and **the particular GPU
mechanism used to realize it**.

Chapter 34 is especially important for the `RSelect` problem: real branching,
predication, static specialization, masking, and multipass execution are
different implementation choices. Turning a source branch into “evaluate both
sides and select a value” too early destroys that choice. Chapter 36 says
something similar for reductions: a reduction is a structured collective
operation, not merely a pile of additions. Chapter 44 preserves matrix/vector
and solver structure, while Chapter 48 preserves FFT butterfly/twiddle
structure—both good precedents for not exploding Givens/RoPE-style pair
operations into unrelated scalar arithmetic before target lowering.

The parts that are dated are useful precisely because they expose target
constraints so clearly. I would mine this book for **structures worth
preserving**, not copy its fragment-pipeline encodings.

See [all 48 chapter summaries](chapter-summaries.md).

## Thanks

Thanks to **Matt Pharr**, **Randima Fernando**, and all of the chapter authors.
A lot of the material is old enough that a less carefully assembled book would
have become useless historical trivia; instead, many of the chapters still make
the underlying computational problem clearer than newer API-centered material.
