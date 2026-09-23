# ShaderX2: Introductions and Tutorials with DirectX 9 — book summary

Edited by Wolfgang F. Engel. Wordware Publishing, 2004.

This small introductory volume is useful because it catches programmable
shaders right when high-level languages and Shader Model 3 flow control are
becoming normal. The first two chapters explicitly separate a high-level shader
from register scheduling/instruction selection and then present predication,
static flow control, and dynamic flow control as **different target
mechanisms**.

That is exactly the distinction needed for the current `RSelect` work. A
source `if` should survive long enough for the target to choose whether it
becomes a branch, predicate, specialization, or something else. The later
lighting/shadow chapters are also useful because they make invariants and
failure cases explicit instead of judging correctness only by appearance.

See [all 8 chapter summaries](chapter-summaries.md).

## Thanks

Thanks to **Wolfgang F. Engel** and the individual chapter authors. In
particular, the introductory/compiler-facing material is still useful because
it explains *why* the shader abstraction exists instead of merely teaching the
syntax of one old DirectX release.
