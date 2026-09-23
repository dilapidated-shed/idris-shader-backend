# Programming Massively Parallel Processors, 5th ed. — book summary

Wen-mei W. Hwu, David B. Kirk, and Izzat El Hajj. Morgan Kaufmann/Elsevier,
2026.

This is the modern control specimen in the collection. Where the old *GPU Gems*
books show programmers fighting a graphics pipeline, this book names the
parallel patterns directly: convolution, stencil, histogram, reduction, scan,
merge, sparse work, wavefront algorithms, graphs, deep-learning kernels, and
matrix multiplication.

For this repository, that vocabulary matters more than CUDA syntax. Q/K
normalization contains a reduction; analytic-continuation work contains bounded
iteration; sparse and graph examples show why representation and storage layout
must stay below semantics; advanced matrix multiplication shows how much
optimization becomes possible when the compiler still knows it is looking at a
matrix operation rather than thousands of scalar multiply-adds.

I would **not** use the book as a reason to make the source language look like
CUDA. I would use it as evidence that preserving recognizable parallel
operators gives a target backend more choices—tiling, lane cooperation,
specialized memory, fusion, or distribution—than a prematurely flattened IR.

See the [25-chapter publisher-metadata map](chapter-map.md).

## Thanks

Thanks to **Wen-mei Hwu**, **David Kirk**, and **Izzat El Hajj** for maintaining
this line of books across several generations of GPU hardware instead of
freezing the exposition around one CUDA generation.
