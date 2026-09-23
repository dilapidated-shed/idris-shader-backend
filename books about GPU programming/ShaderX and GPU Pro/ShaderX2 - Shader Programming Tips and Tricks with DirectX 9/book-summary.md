# ShaderX2: Shader Programming Tips and Tricks with DirectX 9 — book summary

Edited by Wolfgang F. Engel. Wordware Publishing, 2004.

This is a big grab-bag, but several chapters line up unusually well with the
current work: lookup tables, dense matrix algebra, voxel/volume traversal,
Mandelbrot iteration, shader abstraction, a vertex-shader compiler, and a
shader disassembler.

The useful thread is that these chapters keep rediscovering **structure above
the final instruction stream**. Dense matrix algebra is not merely a sequence
of scalar operations; a lookup table is one implementation of coefficient
generation; Mandelbrot is a bounded/data-dependent iteration; a compiler needs
an abstraction above target instructions; a disassembler is useful precisely
because the emitted target can differ substantially from what the source
suggested.

That makes the volume worth mining selectively for Givens/RoPE, bounded-loop,
and lowering questions even though most of its DirectX-specific details are
obsolete.

See the [complete evidence-labeled chapter map](chapter-map.md).

## Thanks

Thanks to **Wolfgang F. Engel** and the many contributing authors for preserving
a wide range of practical shader/compiler/numerical techniques in one place.
