# Current problem lens for the GPU-programming books

Checked against repository state on 2026-09-23.

These notes are not generic book reports. Chapter summaries in this directory
are reread against the technical questions already present in this repository.

## 1. Preserve control flow until the target has enough information

The current `RSelect` failure is the canonical example. A source conditional
was flattened into two already-computed values plus a select, so expensive work
from both branches could be generated. A later pass then had to reconstruct
branch structure from dependencies.

The question for every old discussion of predication, branching, masks, or
branchless code is therefore:

> Is the source computation semantically branchy, and is predication merely one
> target realization, or did we erase the branch before the target could make
> that decision?

Old hardware that really evaluated both sides of a branch is evidence for
keeping these concepts distinct, not for representing every source conditional
as an eager select.

## 2. Preserve bounded iteration instead of spelling it out by hand

The analytic-continuation path exposed another representation failure: a fixed
maximum number of zeros/poles became many manually repeated guarded chunks.
The desired IR has an explicit bounded loop with a typed induction value,
active bound, loop-carried state, body, and result. A target may later unroll
that loop, but unrolling should be an optimization decision, not the semantic
representation.

Old GPU techniques involving multipass iteration, fixed-trip loops, early exit,
or uniform-vs-nonuniform traversal are read with this question in mind.

## 3. Reductions are structure, not just a pile of adds

Q/K normalization requires a sum-of-squares reduction before `sqrt`/`rsqrt`.
The exact reduction tree, accumulation width, epsilon placement, and later
scaling are observable numerically.

Reduction chapters therefore matter twice: for parallel scheduling and for
whether the backend should retain a reduction-shaped operation long enough to
choose a target-appropriate tree instead of flattening it prematurely.

## 4. Two-coordinate rotations may deserve to remain visible

RoPE and Givens-style transforms repeatedly apply

```text
x' = x c - y s
y' = x s + y c
```

The books are read for mathematical and compiler structure; the
[DwarfStar codebase study](DwarfStar%20(codebase%20study)/README.md) is read as
a live implementation specimen showing how explicit pair rotations are
scheduled once a representation has already been chosen.

DwarfStar does not decide whether a higher-level complex operation should ever
be expanded into this form. In particular, the holomorphic and polar-complex
work may avoid such an expansion altogether.

When an explicit coordinate-pair rotation really is present, keep distinct:

- coefficient generation;
- applying one plane rotation;
- a bank/sequence of rotations;
- an arbitrary orthogonal transform;
- target lane/layout/fusion choices.

A book chapter or codebase file about vector packing, FFT butterflies,
trigonometric approximation, or data layout can therefore be relevant even if
it never says "RoPE" or "Givens."

## 5. Fusion does not imply reordering

The QK-normalization/RoPE notes already distinguish commuting and
non-commuting cases. Pure L2 normalization and scalar RMS scaling commute with
an orthogonal RoPE transform in exact arithmetic; learned per-coordinate gains
generally do not, and LayerNorm generally does not.

When a chapter advocates fusing stages, the question is whether the fused
kernel preserves:

- normalization axis and epsilon;
- learned gain/bias placement;
- rotary pairing/dimension/frequency;
- model-specified operation order;
- accumulation, phase, sine/cosine, and application precision.

## 6. Representation and layout should follow semantics, not replace them

The backend intentionally rejects general heap-shaped data while admitting
fixed shader arrays and vectors. Old GPGPU literature often implements pointers,
lists, sparse matrices, queues, and grids by encoding them into textures.

Those encodings are valuable target techniques, but they should not silently
become the source-language meaning of the object. The useful question is which
abstract structure must remain visible so that PowerVR GLSL, Mali/Vulkan,
Metal, CUDA-like followers, or WebGPU can each choose an appropriate layout.

## 7. Numerical width is a per-operation question

"Stored as F16" does not determine the width of a reduction, phase calculation,
transcendental evaluation, intermediate product, or final accumulation.

For every numerical technique, note separately:

- storage width;
- product width;
- accumulation width;
- transcendental/argument-reduction width;
- conversion/rounding points;
- error invariant worth measuring.

Norm preservation for rotations, residuals for reductions, and agreement with
a higher-quality oracle are more useful than saying merely that an image looks
right.

## 8. Measure the emitted target, not the story about it

Several old GPU books correctly insist on profiling because source-level
transformations interact with drivers, memory behavior, and the actual
execution model in ways that are difficult to infer from source alone.

That aligns with this repository's evidence boundary:

- source mathematics;
- typed shader IR;
- emitted GLSL;
- shader validation/linking;
- renderer selection;
- physical PowerVR/Mali execution;

are separate claims.

A chapter's historical optimization rule is a hypothesis for a present target
until measurement proves it.
