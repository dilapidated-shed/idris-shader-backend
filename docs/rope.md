# Rotary Position Embedding (RoPE)

Rotary Position Embedding encodes token position by rotating query and key
coordinates before the attention dot product. This note describes the
mathematics and the implementation surface without choosing whether this
backend should implement it.

Related Idriç O/SO, complex/projective, Givens/Householder, polar-complex,
DFT/FFT, and target-lowering work is indexed at:
https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/examples/unified-higher-mathematics/ROTATION-COMPLEX-PROJECTIVE-CROSS-REFERENCES.md

## One two-dimensional pair

For a pair `(x0, x1)` and angle `phi`:

```text
R(phi) = [ cos(phi)  -sin(phi) ]
         [ sin(phi)   cos(phi) ]

R(phi) [x0] = [ x0 cos(phi) - x1 sin(phi) ]
       [x1]   [ x0 sin(phi) + x1 cos(phi) ]
```

A RoPE head is divided into two-dimensional coordinate pairs. Pair `r` gets a
frequency `theta_r`; at token position `m` the pair is rotated by
`m * theta_r`.

A common schedule is

```text
theta_r = base^(-2r/d)
```

for head width `d`, often with `base = 10000`. Exact frequency schedules are
model semantics and must match the model or checkpoint being executed.

## Queries and keys

Let `R_m` be the block-diagonal rotation for position `m`. RoPE applies

```text
q_m' = R_m q_m
k_n' = R_n k_n
```

before the attention dot product.

Because every 2D block is an orthogonal rotation,

```text
R_m^T R_n = R_(n-m)
```

so

```text
dot(R_m q, R_n k)
  = q^T R_m^T R_n k
  = q^T R_(n-m) k
```

The two vectors carry absolute-position rotations, while their dot product
depends on the relative offset `n - m`.

## What RoPE does not normally rotate

The standard RoPE construction rotates Q and K. Values are ordinarily left
unrotated:

```text
attention = softmax(q_rope k_rope^T * scale) v
```

Rotating V would be an additional model operation, not an implementation detail
of ordinary RoPE.

## Coordinate-pair conventions

Two implementations can both say "RoPE" and still disagree bit-for-bit because
they pair coordinates differently.

Common layouts include:

- adjacent pairs: `(0,1), (2,3), ...`;
- split-half layouts in which the first half is paired with the second half.

The checkpoint, projection layout, and `rotate_half` convention must agree.
Changing the pairing convention changes the model.

Some models rotate only a prefix of each head. The remaining coordinates are
the identity part of the block-diagonal transform. The rotary dimension must
therefore be an explicit quantity.

## Sine and cosine tables

The implementation needs

```text
cos(m * theta_r)
sin(m * theta_r)
```

for each used position and rotary pair.

Possible implementations include:

- precomputed tables;
- tables generated when the sequence length is known;
- on-the-fly evaluation;
- recurrence from one position to the next.

These choices can be mathematically equivalent but need not be bitwise
identical. The phase calculation, argument reduction, `sin`/`cos`
implementation, storage width, and application width can all change rounding.

For long contexts, phase precision matters separately from the precision used
for the Q/K values themselves. Computing `m * theta_r` inaccurately can
produce a positional error even if the subsequent pair rotation is accurate.

## Orthogonality

In exact arithmetic,

```text
||R_m x||_2 = ||x||_2
```

and

```text
dot(R_m x, R_m y) = dot(x, y)
```

for a common position `m`.

Floating-point code only approximates these identities. They are useful
invariants for testing a shader implementation.

## Autoregressive key caches

In autoregressive inference, a cached key must have a precise convention.
A common convention stores the key after applying the position-dependent
rotation. Then a previously cached key need not be rotated again when a later
query arrives.

Cache compatibility therefore depends on at least:

- the rotary dimension;
- the frequency schedule/base;
- the position index convention;
- any context-scaling modification;
- the coordinate-pair layout;
- the numeric representation used for the cached key.

Changing one of these while reusing an old cache changes the represented key.

## GPU/shader lowering

At the arithmetic level, each rotary pair is small:

```text
rot0 = x0 * c - x1 * s
rot1 = x0 * s + x1 * c
```

This maps naturally to pair-wise vector operations, but several implementation
questions remain observable:

- are Q/K projected before the sin/cos load?
- is the rotation fused with normalization?
- are sin/cos values shared across lanes or redundantly loaded?
- are Q/K values materialized between stages?
- are multiply-adds contracted?
- what precision is used for phase, sin/cos, and rotated Q/K?
- what happens when only part of the head is rotary?

Fusion is an implementation transformation. It should be checked against a
small unfused reference rather than assumed to preserve the model.

## Small deterministic fixtures

A useful RoPE test suite does not need a whole transformer.

For one 2D pair, test:

- angle 0;
- angle pi/2;
- angle pi;
- positive and negative positions if the representation permits them;
- a zero vector;
- basis vectors `(1,0)` and `(0,1)`;
- a general vector such as `(3,4)`.

For several pairs, use different frequencies and verify independently that each
pair received the correct angle.

For two positions `m` and `n`, check the relative-position identity

```text
dot(R_m q, R_n k) ~= dot(q, R_(n-m) k)
```

within a tolerance appropriate to the chosen numeric width.

## References

- Su, Lu, Pan, Murtadha, Wen, Liu, *RoFormer: Enhanced Transformer with Rotary
  Position Embedding*:
  https://arxiv.org/abs/2104.09864
- Reference implementation associated with RoFormer:
  https://github.com/ZhuiyiTechnology/roformer
