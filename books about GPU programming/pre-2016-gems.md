# Pre-2016 GPU-programming gems

Observed and checked: 2026-09-23.

This file deliberately does **not** try to enumerate every GPU book published
before 2016. The modern census starts at 2016. Earlier material is kept when it
still teaches an idea, technique, historical transition, or programming model
that is worth carrying forward.

That means age alone is not a reason to include a book, and obsolescence in an
API does not automatically disqualify a chapter whose underlying idea survives.

## Strong survivors

| Year | Book / series | Why it still earns space |
| --- | --- | --- |
| 2004 | *GPU Gems* | Early programmable-GPU techniques; useful for seeing problems decomposed into vertex/fragment work before general GPU compute became ordinary. |
| 2005 | *GPU Gems 2* | Especially strong on mapping general computation to fragments, flow-control idioms, reduction, optimization, and numerical algorithms. This repository already has chapter-level notes. |
| 2007 | *GPU Gems 3* | Transitional volume spanning mature programmable shaders and the arrival of CUDA/GPGPU. |
| 2008 | *ShaderX 6* | Part of the long ShaderX/GPU Pro lineage; retain selected chapters rather than treating old API details as current guidance. |
| 2009 | *OpenGL Shading Language*, 3e | Historically important GLSL reference and useful background for shader language structure; API/version details are dated. |
| 2010 | *CUDA by Example: An Introduction to General-Purpose GPU Programming* — Jason Sanders, Edward Kandrot | Compact early CUDA exposition whose examples still expose the basic host/device, kernel, thread-block, memory, and concurrency model clearly. |
| 2010 | *Programming Massively Parallel Processors*, 1e — David B. Kirk, Wen-mei W. Hwu | Beginning of the PMPP line; retain for conceptual and historical comparison with the modern editions. |
| 2010–2012 | *GPU Computing Gems: Emerald Edition* and *Jade Edition* | Edited collections of GPGPU techniques from the early CUDA/OpenCL era; mine chapter-by-chapter for algorithms that survived later hardware. |
| 2011 | *OpenCL Programming Guide* — Aaftab Munshi et al. | Canonical early OpenCL programming-model exposition; useful for portable heterogeneous-compute concepts even where API details have aged. |
| 2011+ | *Heterogeneous Computing with OpenCL* — Benedict Gaster et al. | Good conceptual bridge from GPU-specific computing to heterogeneous devices; later pre-2016 editions can be compared for what changed. |
| 2012 | *CUDA Programming: A Developer's Guide to Parallel Computing with GPUs* — Shane Cook | Substantial CUDA implementation text with practical attention to memory, algorithms, and optimization. |
| 2012 | *Programming Massively Parallel Processors*, 2e — David B. Kirk, Wen-mei W. Hwu | Mature pre-Pascal CUDA-era presentation; useful mainly where concepts survive into later editions. |
| 2013 | *The CUDA Handbook: A Comprehensive Guide to GPU Programming* — Nicholas Wilt | Detailed CUDA reference; this repository already records the book and the separately licensed companion code. |
| 2013 | *CUDA Fortran for Scientists and Engineers*, 1e — Gregory Ruetsch, Massimiliano Fatica | Useful historical baseline for the 2024 second edition and for scientific-programming idioms. |
| pre-2016 | *Graphics Shaders: Theory and Practice*, 2e — Mike Bailey, Steve Cunningham | Shader concepts, transformations, lighting, procedural work, and graphics-pipeline thinking that remain useful beyond the exact OpenGL version. |
| 2002–2015 | *ShaderX* and *GPU Pro* series through *GPU Pro 6* | Do not preserve indiscriminately. Mine the series for techniques, algorithmic explanations, and constraints that still illuminate current GPU programming. |

## Selection test

A pre-2016 work belongs here when at least one of these is true:

- it explains an algorithm or decomposition still recognizable on current
  hardware;
- it makes a GPU execution or memory constraint unusually explicit;
- it documents an important transition in the programming model;
- later books repeatedly inherit the idea but explain it less clearly;
- it contains numerical, shader, or parallel-programming techniques directly
  useful to work in this repository.

A book does **not** qualify merely because it was once popular, has "CUDA" or
"OpenGL" in the title, or is available free of charge.

## What to extract from old books

The useful unit is often a chapter rather than a whole book. For each survivor,
prefer notes that separate:

1. the enduring computational idea;
2. the old hardware/API assumption used to express it;
3. the current equivalent, when there is one;
4. anything that is now actively wrong on current execution models.

This is particularly important for assumptions about implicit warp behavior,
texture/fragment passes used as general computation, fixed-function pipeline
stages, synchronization, memory coalescing rules, and historical limits on
branching or scatter writes.

## Existing detailed notes

See the sibling directories for:

- [GPU Gems — all 42 chapters](GPU%20Gems/chapter-summaries.md)
- [GPU Gems 2 — all 48 chapters](GPU%20Gems%202/chapter-summaries.md)
- [GPU Gems 3 — all 41 chapters](GPU%20Gems%203/chapter-summaries.md)
- [The CUDA Handbook — all 16 live v2.0 chapters](The%20CUDA%20Handbook/chapter-summaries.md)
- [OpenGL Shading Language](OpenGL%20Shading%20Language/README.md)
- [Graphics Shaders: Theory and Practice](Graphics%20Shaders%20-%20Theory%20and%20Practice/README.md)
- [ShaderX / GPU Pro](ShaderX%20and%20GPU%20Pro/README.md)

The modern PMPP editions are tracked in
[Programming Massively Parallel Processors](Programming%20Massively%20Parallel%20Processors/README.md)
and in the modern census.
