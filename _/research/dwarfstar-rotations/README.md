# DwarfStar rotation-kernel notes

Status: early research. No production lowering change is proposed here.

This is separate from the structured-control-flow / `select` investigation. The useful question here is narrower:

> What can DwarfStar teach us about target-level scheduling of large numbers of small rotations once the mathematical operation and representation boundary are already known?

DwarfStar is not a shader compiler, so it is evidence about GPU implementation patterns rather than a model for this backend's architecture. It is also **not evidence for choosing Cartesian complex representation**.

The canonical cross-repository map is:
https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/examples/unified-higher-mathematics/ROTATION-COMPLEX-PROJECTIVE-CROSS-REFERENCES.md

That index connects this note to the Idriç O/SO and Complex/CP^n work, the ARM polar-complex experiment, the x86 complex/projective leader, the shader Givens/Householder fixtures, RoPE, and DFT/FFT twiddle multiplication.

## Position relative to the complex/type-theoretic work

The type-theoretic boundary comes first:

```text
Complex / C^n / CP^n / O(n) / SO(n)
        |
        | preserve mathematical structure
        v
representation / lowering decision
        |
        +--> polar complex: (magnitude, phase)
        |
        +--> explicit coordinate-pair rotation
                  |
                  +--> GPU lane/layout/fusion decisions
                        ^
                        |
                 DwarfStar evidence lives here
```

For the holomorphic work, the polar complex experiment is especially important because multiplication by a unit complex number can become phase addition rather than a four-product Cartesian rotation. The same observation applies to DFT/FFT twiddle multiplication when values can remain in a suitable polar representation.

DwarfStar becomes relevant only where the chosen representation or surrounding algorithm already exposes explicit coordinate pairs. Its RoPE kernels then provide useful evidence about lane ownership, pair layout, coefficient generation, precision, and fusion boundaries.

This note should therefore remain a target-implementation research branch, not a source of semantic architecture for Complex.

## Why it is relevant

The shader repository already contains two materially different rotation families:

- `Example.GivensFragmentMocks`: a genuine 2D Givens rotation. It computes `c=a/r`, `s=b/r`, then applies
  `(a,b) -> (c*a+s*b, -s*a+c*b)`.
- `Example.RotateDifference8ToE1`: an 8D orientation-preserving map built as two reflections (Householder plus a fixed e2 flip).

DwarfStar's RoPE kernels are closer to the first family: many independent 2D rotations over coordinate pairs. They are not a direct implementation of the 8D Householder construction.

## DwarfStar specimens

The observations below refer to DwarfStar commit
`0aaea5a238fb41a35106a551e73c8409dfb751ac`.

### 1. DeepSeek V4.1: one SIMD lane per adjacent pair

CUDA:
https://github.com/antirez/ds4/blob/0aaea5a238fb41a35106a551e73c8409dfb751ac/ds4_deepseek41_cuda.cuh

Metal:
https://github.com/antirez/ds4/blob/0aaea5a238fb41a35106a551e73c8409dfb751ac/metal/dsv41.metal

The core shape is exactly a planar rotation:

```text
re' = re*c - im*s
im' = re*s + im*c
```

The DeepSeek V4.1 kernel assigns one lane to one pair. Thirty-two lanes cover the final 64 coordinates. The data layout is therefore part of the implementation: the rotated coordinates are physically adjacent pairs.

That is a stronger lesson than "GPUs are good at rotations": if the semantic operation is a bank of independent plane rotations, preserving that fact into lowering lets a backend choose a pair layout and lane mapping directly instead of discovering it again from a general matrix expression.

### 2. The same semantic rotation gets different numeric treatment

The Metal V4.1 path uses `precise::cos` and `precise::sin`.

The CUDA V4.1 path deliberately converts the angle to binary64 for `cos` / `sin` range reduction, then converts the result back to float. Its comment says this avoids fast-math range reduction problems at long absolute positions.

So "fuse sin and cos" is not automatically the right abstraction. DwarfStar sometimes values reproducible argument reduction more than the cheapest transcendental path.

That matters for this repository because rotations are norm-preserving algebraically but can stop looking norm-preserving once coefficient generation and rounding are included.

### 3. Qwen: split-half pair layout

CUDA:
https://github.com/antirez/ds4/blob/0aaea5a238fb41a35106a551e73c8409dfb751ac/ds4_qwen4_cuda.cuh

`apply_rope` pairs

```text
row[i]
row[i + nrot/2]
```

rather than adjacent coordinates. Again one lane owns one pair, but the representation is different.

This is useful evidence against baking a particular physical pairing into the semantic notion of "rotation". A compiler-level rotation operation should identify the two coordinates being rotated; the target lowering should choose or respect the physical layout.

The same file also contains a vision path using CUDA `sincosf`, so DwarfStar itself does not impose one global trig strategy.

### 4. Fusion is useful, but DwarfStar also documents when not to fuse

Qwen's `attn_prep` does roughly

```text
load
  -> norm
  -> place normalized row in shared storage
  -> apply pair rotations
  -> store/convert
```

inside one kernel.

DwarfStar's Metal `norm.metal` also contains a decode-only fused path combining RMS normalization, the KV RoPE tail, and final storage work that had previously been three dispatches.

But `metal/dsv4_kv.metal` records the opposite decision for another path: the normal RoPE kernel was intentionally kept separate because tiny changes in trigonometric code generation could change later sampled tokens.

That is probably the most important general lesson here:

**fusion is an optimization boundary, not a semantic law.**

For this shader backend, any future rotation fusion should preserve a numeric contract and be promoted only with target evidence.

## Connection to the present shader code

### Givens

Current source:

```text
radius = sqrt(a*a + b*b)
c = a/radius
s = b/radius
x' = c*a + s*b
y' = -s*a + c*b
```

This is already structurally a pair rotation, although its coefficients come from the input vector rather than from an angle.

DwarfStar suggests that the compiler should be able to retain "these two outputs are one orthogonal pair transform" rather than immediately flattening the computation into unrelated multiplies and adds.

### 8D rotate-to-e1

The current 8D operation is not naturally a sequence of DwarfStar-style RoPE rotations. It uses a Householder reflection followed by a fixed reflection to recover determinant +1.

Do not rewrite it into a chain of Givens rotations merely because pair rotations map nicely to GPU lanes. That would be an algorithm change and needs an independent reason.

However, if later work *does* produce a chain of Givens rotations, DwarfStar becomes directly relevant to their representation and scheduling.

## Candidate compiler structure

Not a proposed patch yet; this is a research sketch. The important correction is that a plane-rotation node, if useful, belongs **below** the richer mathematical semantics rather than replacing them.

```text
Complex / SO(n) / other mathematical action
      |
      | preserve semantics
      v
typed semantic IR
      |
      +--> polar-complex lowering when appropriate
      |
      +--> explicit plane-rotation lowering
               |
               +--> adjacent pair
               +--> split pair
               +--> coefficients already supplied
               +--> angle -> sin/cos coefficients
               +--> target-specific fusion decision
```

A possible semantic node would describe the transform, not its storage:

```text
plane_rotation
    left_coordinate
    right_coordinate
    cosine
    sine
```

The immediate question is whether this deserves a first-class IR node or whether recognizing the four multiply/add pattern in a later structured pass is enough.

The structured-IR work currently happening elsewhere is relevant here: if lowering destroys the paired structure too early, the target backend has less information available when deciding how to schedule it.

## Concrete experiments

1. **Preserve a Givens pair through IR.**
   Dump the typed IR for the existing Givens fixture and determine exactly where the relation among the four multiply/add expressions disappears.

2. **Compare pair layouts.**
   Add tiny fixtures for adjacent and split-half storage without changing the mathematics. Measure generated GLSL and the physical PowerVR path.

3. **Coefficient-generation experiment.**
   Compare:
   - supplied `c,s`;
   - `c,s` derived by normalization as in current Givens;
   - `sin(theta), cos(theta)` from one shared angle.

   Check generated source and target receipts before adding any optimization.

4. **Fusion boundary experiment.**
   Compare a rotation as an isolated helper versus rotation fused with the immediately preceding/following arithmetic. Verify numerical output, not just compile success.

5. **Long-angle precision experiment.**
   DwarfStar's CUDA code explicitly worries about trigonometric argument reduction. Construct a shader fixture with large angles and measure the PowerVR driver's behavior rather than assuming GLSL's separate `sin` and `cos` are adequate.

6. **Norm invariant.**
   For every pair path, record
   `abs((x*x+y*y) - (x'*x'+y'*y'))`
   over a useful input sweep. This is a more informative acceptance signal than checking one pixel.

## Questions to answer before changing the backend

- Are repeated plane rotations actually on a hot path in the intended renderer, or are they currently just capability fixtures?
- Does preserving a rotation node give the PowerVR backend anything that GLSL's own optimizer would not recover?
- Which operations around a rotation are safe to fuse without changing the desired rounding behavior?
- Should coefficient generation and application be separate IR concepts?
- Is a first-class orthogonal-transform node too broad? A narrow two-coordinate operation may be easier to reason about and test.
- Can the same semantic node lower cleanly to PowerVR GLSL, Mali/Vulkan, Metal, CUDA-like followers, and WebGPU without smuggling a target layout into the source language?

## Initial conclusion

DwarfStar may be relevant, but only at a lower layer than the canonical Complex/O/SO/CP^n semantics.

It gives several real examples of an implementation carrying explicit 2D rotations down to lane assignment, storage layout, coefficient generation, rounding, and dispatch fusion. It also supplies a counterexample to indiscriminate fusion.

For the holomorphic path, first ask whether the complex operation can remain in a representation such as magnitude/phase and avoid expanding a unit-complex multiplication into coordinate arithmetic at all. Only when an explicit coordinate-pair rotation is actually the chosen lowering should DwarfStar guide scheduling or fusion.

So the next useful step is not to copy a DwarfStar kernel. It is to keep this note available as implementation evidence while the semantic and representation work determines whether the same problem ever reaches that form.
