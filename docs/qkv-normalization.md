# QKV normalization

This note records the main meanings of "QKV normalization" around transformer
attention. It is descriptive: the operations below are not interchangeable, and
this file does not choose one for this backend.

## Baseline attention

For one attention head of width `d`:

```text
q = x Wq
k = x Wk
v = x Wv

score(i,j) = dot(q_i, k_j) / sqrt(d)
a_i        = softmax(score(i,:))
out_i      = sum_j a_i,j v_j
```

There are several different places where a normalization can be inserted. They
have different semantics.

## Distinguish the operations

### Normalize the block input

A pre-normalized transformer usually computes something like

```text
h = Norm(x)
q = h Wq
k = h Wk
v = h Wv
```

This affects all three projections, but it is not the same operation as
normalizing `q`, `k`, or `v` after projection.

### Normalize Q and K after projection

This is the usual meaning of **QK normalization**. The normalization is normally
performed independently for each head along the head-dimension axis.

The 2020 QKNorm paper uses L2-normalized queries and keys:

```text
q_hat = q / ||q||_2
k_hat = k / ||k||_2

score(i,j) = alpha * dot(q_hat_i, k_hat_j)
```

where `alpha` is learned rather than using the ordinary `1 / sqrt(d)`
factor. Because both vectors have unit Euclidean norm,

```text
dot(q_hat, k_hat) = cos(angle(q, k))
```

before the learned scale is applied.

The direct effect is on attention-logit geometry and therefore on the softmax
weights. It does not directly normalize the magnitude of the values being
mixed.

### RMS-normalize Q and K

For a head vector `x` of width `d`, the scalar part of RMS normalization is

```text
rms(x) = sqrt((1/d) * sum_i x_i^2 + epsilon)
x_hat  = x / rms(x)
```

Ignoring `epsilon`,

```text
||x_hat||_2 ~= sqrt(d)
```

rather than 1. Therefore RMS-normalized QK attention is not numerically the
same as unit-L2 QK normalization.

A learned per-coordinate gain is often included:

```text
RMSNorm(x) = gamma * x / rms(x)
```

with elementwise multiplication by `gamma`. That learned anisotropic gain is
semantically important; it can change directions as well as magnitudes.

### Layer-normalize Q and K

Layer normalization also subtracts the component mean before scaling:

```text
mu       = mean(x)
variance = mean((x - mu)^2)
y        = gamma * (x - mu) / sqrt(variance + epsilon) + beta
```

That is a different geometry from either L2 normalization or RMS normalization.
In particular, mean subtraction matters when considering interaction with
rotations such as RoPE.

### Normalize V

Normalizing values is a separate operation:

```text
v_hat = Norm(v)
out_i = sum_j a_i,j v_hat_j
```

It changes the vectors being averaged after the attention weights have already
been chosen. It does not serve the same role as QK normalization.

"QKV normalization" should therefore be read carefully. It may mean:

1. a normalization before a fused QKV projection;
2. separate post-projection normalization of Q and K only;
3. separate post-projection normalization of Q, K, and V;
4. one normalization over a concatenated QKV tensor.

These are not equivalent. A concatenated normalization also couples statistics
between streams that are independent under separate normalizations.

## Which axis is normalized?

For attention, the usual QK normalization axis is the per-head feature axis:

```text
[batch, token, head, head_dimension]
                     ^^^^^^^^^^^^^^
```

Normalizing across tokens, across heads, or across a fused QKV dimension is a
different operation.

For grouped-query attention or multi-query attention, each physical query/key
head or key/value head still has a definite feature vector. The normalization
domain must be specified explicitly rather than inferred from the storage
layout.

## Scaling and softmax temperature

Standard scaled dot-product attention uses

```text
dot(q, k) / sqrt(d)
```

to control the typical logit scale.

After unit-L2 QK normalization, `dot(q_hat, k_hat)` lies in `[-1, 1]` in
exact arithmetic. A separate scalar scale then acts like an inverse softmax
temperature.

With RMSNorm, learned gains, clipping, or other variants, there is no general
unit-norm bound. The logit scale must be analyzed from the exact normalization
definition.

## Epsilon is part of the semantics

A practical normalizer is usually closer to

```text
x / sqrt(sum(x*x) + epsilon)
```

or

```text
x / sqrt(mean(x*x) + epsilon)
```

than to a symbolic exact norm. The placement and magnitude of `epsilon`
matter most for small vectors. They also affect whether algebraic
transformations that are true for exact normalization remain bitwise true.

## GPU/shader work

A per-head norm requires a reduction:

1. square each component;
2. reduce the sum or mean;
3. add `epsilon`;
4. compute `sqrt` or `rsqrt`;
5. scale the components;
6. optionally apply learned gain/bias.

Important implementation details include:

- the accumulation width of the reduction;
- the exact reduction tree;
- whether FMA contraction is permitted;
- the precision of `rsqrt`;
- where learned gain is applied;
- whether the tensor is materialized between projection, normalization, RoPE,
  and attention;
- whether a fused implementation preserves the reference order of operations.

A direct shader backend should distinguish semantic equivalence from merely
producing visually or statistically similar output.

## Minimal acceptance cases

Useful small fixtures include:

- a unit basis vector;
- a constant vector;
- a vector with mixed signs;
- a nearly zero vector that exercises `epsilon`;
- two proportional Q/K vectors;
- two orthogonal Q/K vectors;
- Q/K vectors whose magnitudes differ by several powers of two;
- grouped-query layouts where the storage stride differs from the head width.

For each case, record both the normalized vectors and the resulting attention
logits. Testing only the final softmax can hide scale or reduction errors.

## References

- Vaswani et al., *Attention Is All You Need*:
  https://arxiv.org/abs/1706.03762
- Henry, Dachapally, Pawar, Chen, *Query-Key Normalization for Transformers*,
  Findings of EMNLP 2020:
  https://aclanthology.org/2020.findings-emnlp.379/
- NVIDIA Transformer Engine documents multiple QK-normalization forms and
  explicit before/after-RoPE ordering:
  https://docs.nvidia.com/deeplearning/transformer-engine-releases/release-2.13/user-guide/api/pytorch.html
