# Books about GPU programming

Observed and checked: 2026-09-23.

This directory keeps free-to-read, freely licensed, and commercial books in one
catalog. The distinction is legal rather than editorial:

- **mirror** only when an explicit license or public-domain status permits
  redistribution;
- **link-only** when a book is commercial, all-rights-reserved, merely free to
  read online, or merely offered as a free download;
- treat source-code companions, sample chapters, bibliographies, and author
  notes independently from the book itself: mirror them only when their own
  license permits it.

A Git commit preserves our dated notes about what was publicly available. The
archive links in [archive-targets.tsv](archive-targets.tsv) are lookups or
capture-request entry points; they are not assertions that every external
archive successfully captured the page.

## Summary evidence levels

Chapter notes distinguish what was actually available:

- **live full text** — the chapter/book text is legitimately hosted by the
  publisher or author; write an original chapter summary from that text;
- **indexed live PDF** — the publisher/editor provides a legitimate PDF, but
  the current reader cannot ingest the whole file at once; mark chapters
  `indexed-text` when substantial chapter text was recovered and
  `TOC-guided` otherwise;
- **publisher metadata** — only a TOC/abstract/sample is public; write a
  `chapter-map.md` and label it metadata-based rather than pretending the
  chapter was read.

All notes are read through [problem-lens.md](problem-lens.md): structured
control flow, bounded loops, reductions, RoPE/Givens-style pair rotations,
fusion versus reordering, layout versus semantics, numerical width, and
physical-target evidence.

## Live-hosted books

These have chapter-level coverage now:

| Book | Hosting | Notes |
| --- | --- | --- |
| [GPU Gems](GPU%20Gems/chapter-summaries.md) | complete NVIDIA HTML | all 42 chapters |
| [GPU Gems 2](GPU%20Gems%202/chapter-summaries.md) | complete NVIDIA HTML | all 48 chapters |
| [GPU Gems 3](GPU%20Gems%203/chapter-summaries.md) | complete NVIDIA HTML | all 41 chapters |
| [The CUDA Handbook v2.0](The%20CUDA%20Handbook/chapter-summaries.md) | author-hosted living HTML | all 16 chapters |
| [Direct3D ShaderX: Vertex and Pixel Shader Tips and Tricks](ShaderX%20and%20GPU%20Pro/Direct3D%20ShaderX%20-%20Vertex%20and%20Pixel%20Shader%20Tips%20and%20Tricks/chapter-map.md) | legitimate free PDF | complete chapter map; indexed/TOC evidence marked |
| [ShaderX2: Introductions and Tutorials with DirectX 9](ShaderX%20and%20GPU%20Pro/ShaderX2%20-%20Introductions%20and%20Tutorials%20with%20DirectX%209/chapter-summaries.md) | legitimate free PDF | all 8 chapters summarized from readable text |
| [ShaderX2: Shader Programming Tips and Tricks with DirectX 9](ShaderX%20and%20GPU%20Pro/ShaderX2%20-%20Shader%20Programming%20Tips%20and%20Tricks%20with%20DirectX%209/chapter-map.md) | legitimate free PDF | complete chapter map; indexed/TOC evidence marked |

## Commercial / metadata-based chapter maps

| Book | Rights status used here | Notes |
| --- | --- | --- |
| [Programming Massively Parallel Processors, 5e](Programming%20Massively%20Parallel%20Processors/chapter-map.md) | commercial | all 25 publisher-listed chapters mapped |
| [Numerical Computations with GPUs](Numerical%20Computations%20with%20GPUs/chapter-map.md) | commercial | all 18 chapters mapped |
| [OpenGL Shading Language, 3e](OpenGL%20Shading%20Language/chapter-map.md) | commercial | all 20 chapters mapped |
| [Graphics Shaders: Theory and Practice, 2e](Graphics%20Shaders%20-%20Theory%20and%20Practice/chapter-map.md) | commercial | all 16 chapters mapped |
| [General-Purpose Graphics Processor Architectures](General-Purpose%20Graphics%20Processor%20Architectures/chapter-map.md) | commercial | all 5 chapters mapped |
| [ShaderX / GPU Pro](ShaderX%20and%20GPU%20Pro/README.md) | commercial/copyrighted series; some early volumes free to read/download | series provenance and live-volume notes |

## Reading path for the current backend problems

1. *GPU Gems 2* **34** (flow-control idioms), **36** (reductions), **44**
   (linear systems), **48** (FFT).
2. *The CUDA Handbook* **7–8** (execution/SIMT), **12–13**
   (reduction/scan), **14–15** (pairwise/batched numerical structure).
3. *GPU Gems 3* **32**, **39–41** (reduction/scan, coefficient recurrence,
   variable-output computation).
4. *Numerical Computations with GPUs* **4**, **16–18** (QR/Givens, FFT,
   localized N-body).
5. *PMPP* **10–11**, **15–18**, **23** (collectives, sparse/irregular work,
   deep learning, matrix multiplication).
6. ShaderX/ShaderX2 compiler, matrix, lookup-table, bounded-iteration and
   shader-abstraction chapters.
7. *GPU Gems* **32**, **37–38**, **42** (interfaces, GPGPU toolkit, iterative
   solvers/simulation, Jacobian-based deformers).

## Mirroring rule

"Free on the web" is not enough. NVIDIA hosts the *GPU Gems* books online but
their copyright pages reserve reproduction rights. The early *ShaderX* PDFs are
legitimate free downloads by arrangement with the editor/publisher, but that
does not by itself grant redistribution rights.

If a later check finds an explicit book-level redistribution license, add the
licensed files under that book's directory together with the exact license,
source URL, retrieval date, authors/editors, and any attribution requirements.
