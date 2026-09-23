# GPU Gems — book summary

NVIDIA/Addison-Wesley, 2004. Edited by Randima Fernando.

This is useful here less as an old graphics-effects cookbook than as a record of
what programmers did when the GPU was becoming programmable but was not yet a
general compute device. A surprising amount of the book is really about
**recovering useful mathematical/program structure from a hostile target
model**: image filters become fragment passes, general computation becomes
textures plus render targets, shader fragments need explicit interfaces, and
iterative numerical work has to be expressed in the mechanisms the hardware
happened to expose.

For the problems in this repository, I would especially keep Chapters 32, 37,
38, and 42 close at hand. Shader interfaces support the idea that composition
and types should survive until late; the GPGPU toolkit and fluid chapters show
how loops, reductions, stencils, and state were encoded before modern compute;
and the deformer chapter's Jacobian treatment is a nice example of preserving a
mathematical derivative object instead of throwing structure away and
reconstructing it numerically afterward.

The old API details are not instructions for a modern backend. Their value is
almost the opposite: they make it obvious which ugly representations were
forced by the target and therefore should **not** be mistaken for semantics.

See [all 42 chapter summaries](chapter-summaries.md).

## Thanks

Thanks to **Randima Fernando** for editing the volume, and to the many chapter
authors who wrote down techniques that would otherwise have disappeared into
demos, driver folklore, and old production code. The fact that NVIDIA still
hosts the complete book makes that historical record unusually useful.
