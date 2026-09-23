# QKV normalization and RoPE

QK normalization and RoPE often sit next to one another in an attention
pipeline, so their ordering is easy to treat as a mere implementation choice.
That is only true for particular normalization definitions.

This note records the algebraic cases.

## Reference pipeline

A generic post-projection pipeline can be written as either

```text
q -> Normalize -> RoPE -> attention
k -> Normalize -> RoPE -> attention
```

or

```text
q -> RoPE -> Normalize -> attention
k -> RoPE -> Normalize -> attention
```

Whether those two pipelines are equivalent depends on `Normalize`.

Values are normally not rotated by RoPE, so V normalization is an independent
question.

## L2 normalization commutes with RoPE

Let

```text
N(x) = x / ||x||_2
```

and let `R` be the full RoPE transform, including identity blocks for any
non-rotary coordinates.

Because `R` is orthogonal,

```text
||R x||_2 = ||x||_2
```

and therefore

```text
N(R x)
  = R x / ||R x||_2
  = R x / ||x||_2
  = R N(x)
```

in exact arithmetic.

The same statement holds for a scalar epsilon rule whose denominator depends
only on `||x||_2`.

Floating-point implementations can still differ because the two orders use
different instruction sequences and may round reductions or rotations
differently.

## Scalar RMS normalization also commutes

Ignoring learned elementwise gains,

```text
RMS(x) = x / sqrt(mean(x^2) + epsilon)
```

has a denominator that depends only on the Euclidean norm. An orthogonal
rotation preserves that norm, so the scalar normalization commutes with RoPE in
exact arithmetic.

## Learned elementwise gains generally do not commute

Suppose RMSNorm includes an elementwise learned gain `gamma`:

```text
N_gamma(x) = diag(gamma) x / rms(x)
```

Then

```text
R diag(gamma)
```

is generally not equal to

```text
diag(gamma) R
```

so

```text
R N_gamma(x) != N_gamma(R x)
```

in general.

For one rotary 2D pair, an elementwise gain commutes with every rotation only
when the two gains in that pair are equal. A single scalar gain per whole head
also commutes.

This makes the placement of learned Q/K RMSNorm relative to RoPE part of the
model definition, not merely a kernel scheduling decision.

## LayerNorm generally does not commute

LayerNorm subtracts the feature mean. Pair-wise rotations preserve Euclidean
length but do not preserve the arithmetic mean of the coordinates.

Therefore even LayerNorm without learned affine parameters generally satisfies

```text
LayerNorm(R x) != R LayerNorm(x)
```

The ordering must be preserved exactly.

## Partial RoPE

Partial RoPE can be represented as an orthogonal block matrix:

```text
R = block_diag(rotations..., identity...)
```

so norm preservation still holds for the entire head. Pure L2 normalization and
scalar RMS normalization therefore still commute with partial RoPE in exact
arithmetic.

Per-coordinate gains remain subject to the same pairwise condition: gains on
the two coordinates of each rotated pair must match for the gain matrix to
commute with the rotation.

## QK logits

For pure unit-L2 QK normalization:

```text
q_hat = q / ||q||
k_hat = k / ||k||
```

and RoPE:

```text
q' = R_m q_hat
k' = R_n k_hat
```

the logit before any external scale is

```text
dot(q', k')
  = q_hat^T R_(n-m) k_hat
```

so the query/key magnitude is removed while the relative-position rotation
remains.

A learned scalar logit scale can then control softmax temperature independently
of the original Q/K magnitudes.

## V normalization is orthogonal to the ordering question

Ordinary RoPE acts on Q and K, not V. If values are normalized,

```text
v' = Nv(v)
out = attention_weights * v'
```

that changes the content vectors being mixed. There is no RoPE/normalization
commutation question for V unless a model explicitly introduces a value-side
rotation.

## Fusion boundary

A fused kernel may combine

```text
projection -> QK normalization -> RoPE -> attention
```

without materializing the intermediate tensors.

That fusion is semantically safe only if it preserves the chosen model's:

- normalization axis;
- epsilon;
- learned gain/bias placement;
- RoPE coordinate pairing;
- rotary dimension;
- frequency schedule;
- exact normalization/RoPE order when the operations do not commute;
- attention-logit scale.

The fact that two stages can be fused does not imply that they can be reordered.

## Precision questions for a shader backend

The normalization and RoPE stages stress different numerical operations:

Normalization:

- sum-of-squares reduction;
- accumulation precision;
- `rsqrt` or `sqrt`;
- small-vector behavior around `epsilon`.

RoPE:

- position/frequency multiplication;
- trigonometric argument reduction;
- `sin`/`cos` precision;
- pair-wise multiply/add rounding.

A mixed-precision implementation should name these widths separately. For
example, "Q/K stored as F16" does not by itself determine the reduction width or
the width used to generate the rotary phase.

## Tests that expose wrong reordering

### Expected commuting case

For pure L2 normalization:

```text
a = RoPE(L2Norm(x))
b = L2Norm(RoPE(x))
```

should agree within the numeric tolerance of the implementation.

### Expected non-commuting case

Choose a learned gain with unequal values in one rotary pair:

```text
gamma = (1, 2)
```

and a nontrivial rotation. Then compare

```text
RoPE(gamma * RMSScalar(x))
gamma * RMSScalar(RoPE(x))
```

They should generally differ. A test that accidentally makes them equal can
hide an illegal reordering.

### LayerNorm case

Use a vector whose component mean is nonzero and a nontrivial rotary angle.
Compare LayerNorm before and after rotation and preserve the model-specified
order.

## References

- Henry et al., *Query-Key Normalization for Transformers*:
  https://aclanthology.org/2020.findings-emnlp.379/
- Su et al., *RoFormer: Enhanced Transformer with Rotary Position Embedding*:
  https://arxiv.org/abs/2104.09864
- NVIDIA Transformer Engine exposes QK normalization type and explicit
  normalization-before/after-RoPE ordering as separate configuration:
  https://docs.nvidia.com/deeplearning/transformer-engine-releases/release-2.13/user-guide/api/pytorch.html
