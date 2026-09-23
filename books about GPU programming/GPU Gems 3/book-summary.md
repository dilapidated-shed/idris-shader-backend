# GPU Gems 3 — book summary

NVIDIA/Addison-Wesley, 2007. Edited by Hubert Nguyen.

This volume sits at a useful transition point: the old “make the graphics
pipeline compute” world is still present, but CUDA and more general GPU
execution have arrived. That makes it a good comparison book for deciding which
structures survived the transition and which were merely artifacts of older
hardware.

For the current work, the strongest chapters are the ones on N-body,
collision-detection pipelines, scan, Gaussian coefficient recurrence, and
variable-length GPU output. Chapter 39 treats scan as a real primitive rather
than an incidental loop. Chapter 40 is directly suggestive for RoPE/Givens
coefficient generation: a table, a transcendental evaluation, and a recurrence
can all represent the same coefficient sequence, with different precision and
reuse properties. Chapter 41 is a reminder not to design semantics around one
target's inability to express variable output.

I would use this book as the bridge between *GPU Gems 2*'s explicit old
constraints and modern compute texts: it shows which algorithmic structures
remain meaningful even as the execution substrate changes.

See [all 41 chapter summaries](chapter-summaries.md).

## Thanks

Thanks to **Hubert Nguyen** for editing the volume and to the chapter authors
for documenting the transition from graphics-only programmability toward
general GPU computation in enough technical detail to still be useful now.
