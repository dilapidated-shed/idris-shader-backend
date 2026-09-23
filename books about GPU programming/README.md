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

## Coverage policy

The collection now has two different jobs:

- [**2016-present modern census**](modern-census-2016-present.md): try to
  enumerate every qualifying English-language book. A missing qualifying title
  is a catalog bug, not an editorial choice.
- [**pre-2016 gems**](pre-2016-gems.md): no completeness claim. Keep older
  books and chapters only when their algorithms, explanations, constraints, or
  historical transitions are still worth carrying forward.

The year 2016 is a pragmatic completeness boundary. It catches the beginning of
the Vulkan/explicit-API period and keeps the census tractable; it is not a claim
that every GPU architecture changed discontinuously in that year.

## Reading path

For the current backend work, a useful order is:

1. *GPU Gems 2*, chapters 31–36, for the old but unusually explicit
   fragment-pipeline model of general computation.
2. *GPU Gems 2*, chapter 44, for matrix/vector representation and linear
   solvers expressed through fragment passes.
3. *Numerical Computations with GPUs* for numerical linear algebra and batched
   numerical kernels.
4. *Programming Massively Parallel Processors*, 5th ed., for modern CUDA
   execution, memory hierarchy, tiling, reductions, scans, sparse work, and
   multi-GPU material.
5. *The CUDA Handbook* for a second CUDA-oriented implementation reference and
   its openly licensed code companion.
6. Selected *ShaderX* / *GPU Pro* material for shader-era implementation
   patterns and historical constraints.

## Catalog

| Book / series | Rights status used here | What is kept here |
| --- | --- | --- |
| [GPU Gems 2](GPU%20Gems%202/README.md) | free to read online; book is all-rights-reserved | chapter links and our notes |
| [Programming Massively Parallel Processors](Programming%20Massively%20Parallel%20Processors/README.md) | commercial | publisher metadata, public TOC notes |
| [Numerical Computations with GPUs](Numerical%20Computations%20with%20GPUs/README.md) | commercial | Springer metadata and topic notes |
| [The CUDA Handbook](The%20CUDA%20Handbook/README.md) | commercial book; companion code separately BSD-licensed by the author | book links plus companion-code provenance |
| [OpenGL Shading Language](OpenGL%20Shading%20Language/README.md) | commercial | public TOC/sample links and target-language notes |
| [Graphics Shaders: Theory and Practice](Graphics%20Shaders%20-%20Theory%20and%20Practice/README.md) | commercial | public TOC and example-code links |
| [ShaderX / GPU Pro](ShaderX%20and%20GPU%20Pro/README.md) | commercial/copyrighted books; some volumes are free downloads | legal distinction, live links, selected relevance |
| [General-Purpose Graphics Processor Architectures](General-Purpose%20Graphics%20Processor%20Architectures/README.md) | commercial | Springer/author links and architecture notes |

## Mirroring rule

"Free on the web" is not enough. For example, NVIDIA hosts the complete
*GPU Gems 2* online, but its copyright page still reserves reproduction rights.
Likewise, some early *ShaderX* volumes are offered as free downloads by
arrangement with the editor and publisher, but that does not by itself grant us
a redistribution license.

If a later check finds an explicit book-level redistribution license, add the
licensed files under that book's directory together with the exact license,
source URL, retrieval date, authors/editors, and any attribution requirements.
