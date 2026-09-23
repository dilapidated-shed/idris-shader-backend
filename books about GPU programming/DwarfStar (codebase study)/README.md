# DwarfStar — source-code study

DwarfStar is not a book. In this research library it is treated much like one:
a substantial, current body of GPU implementation work to read selectively,
summarize, and revisit when one of the shader/backend problems overlaps it.

Upstream: https://github.com/antirez/ds4

Pinned specimen used for the first notes:
`0aaea5a238fb41a35106a551e73c8409dfb751ac`

This entry is **research material, not architecture**. DwarfStar does not decide
how Idriç should represent Complex, O(n), SO(n), CP^n, or shader IR. It is useful
because the source contains concrete Metal, CUDA, and ROCm decisions about
layout, lane assignment, trigonometric precision, reductions, quantization,
fusion, and dispatch boundaries.

Read it with the same [problem lens](../problem-lens.md) used for the GPU books.

## Why keep it beside the books

The GPU books provide explanations, historical context, and reusable algorithms.
DwarfStar provides a complementary thing: a live codebase in which many of
those decisions have already been made under real performance and numerical
constraints.

For current shader work, interesting questions include:

- how pairwise rotations are assigned to lanes;
- when coefficients are computed, loaded, or reused;
- when multiple stages are fused into one kernel;
- when fusion is deliberately avoided;
- how Metal/CUDA/ROCm implementations differ for the same mathematical step;
- where precision and rounding choices are made;
- which data layouts are semantic requirements of a model and which are target
  implementation choices.

## Current relevance

The first useful overlap was DwarfStar's RoPE implementation. That led to notes
on adjacent versus split-half pair layouts, precise versus fast trigonometric
paths, and examples both for and against fusion.

That is enough to keep DwarfStar in the library. It does **not** imply that
DwarfStar is central to the holomorphic renderer, nor that its representation
choices should be copied.

For holomorphic/complex work, the canonical semantic cross-reference remains:

https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/examples/unified-higher-mathematics/ROTATION-COMPLEX-PROJECTIVE-CROSS-REFERENCES.md

## Reading files

See [source-map.md](source-map.md) for the current file-by-file reading map and
[rotation-and-fusion-notes.md](rotation-and-fusion-notes.md) for the first
problem-driven notes.

## Attribution and thanks

DwarfStar is by Salvatore Sanfilippo (antirez) with substantial contributions
and acknowledged influence from llama.cpp/GGML and their contributors. The
upstream repository should be consulted for its current license, contributor
history, acknowledgements, and rapidly changing implementation state.

Thanks to Salvatore Sanfilippo and the DwarfStar, llama.cpp, and GGML
contributors for making the implementation available to inspect.
