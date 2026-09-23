# Graphics Shaders: Theory and Practice, 2nd ed. — book summary

Mike Bailey and Steve Cunningham. CRC Press, 2012.

This book is useful here because it keeps shader programming connected to the
whole pipeline: vertex, fragment, geometry and tessellation stages, textures,
multipass rendering, host interfaces, and scientific visualization. That is a
better mental model for a compiler backend than treating a fragment shader as a
bag of floating-point expressions.

The strongest connections to the current work are the chapters on GLSL
vectors/matrices, fragment-stage control effects, render-to-texture,
image-processing filters, tessellation/adaptive geometry, and scientific
visualization. Those are all examples where the operation has recognizable
structure before it becomes target instructions. That is exactly the structure
we are trying not to lose with branches, bounded loops, reductions, and
pairwise rotations.

I would use this as a readable shader-side companion to the lower-level
architecture books: it helps keep the **meaning of the stage and data**
visible while the backend worries about how to emit it.

See the [16-chapter publisher/author-metadata map](chapter-map.md).

## Thanks

Thanks to **Mike Bailey** and **Steve Cunningham** for writing a shader text
that treats the programming model as something to understand, not just a list
of effects to copy.
