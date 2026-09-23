# OpenGL Shading Language, 3rd ed. — book summary

Randi J. Rost and contributors.

For this repository, this is fundamentally a **target-contract book**. It helps
answer what generated GLSL means: types, vectors and matrices, built-ins,
control flow, stage interfaces, interpolation, texture access, linking, host
binding, and the rest of the programmable pipeline.

That makes it important, but in a deliberately limited way. GLSL should tell us
what a correct target program may say; it should not dictate what Idriç source
or the backend's semantic IR must look like. A source conditional is not a GLSL
ternary, a mathematical vector is not merely a GLSL storage layout, and a
two-coordinate rotation should not have to disappear into four scalar
operations merely because GLSL can express it that way.

The chapters on the programmable pipeline, built-ins, API/linking, procedural
textures, antialiasing, and imaging are especially useful for maintaining the
boundary between semantic operation, emitted shader, successful link, and
actual renderer execution.

See the [20-chapter publisher-metadata map](chapter-map.md).

## Thanks

Thanks to **Randi J. Rost** and the book's contributors for documenting GLSL as
a language and execution environment rather than just presenting disconnected
shader recipes.
