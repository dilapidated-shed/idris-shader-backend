# DwarfStar source map

This is the codebase equivalent of a chapter map. It is selective and
problem-driven, not an attempt to summarize every file in DwarfStar.

Pinned first-reading commit:
`0aaea5a238fb41a35106a551e73c8409dfb751ac`

## Start here

### `README.md`

Project scope, supported hardware, model coverage, provenance, and the explicit
acknowledgement of llama.cpp/GGML.

Read this first so performance tricks are not mistaken for general-purpose API
or compiler design.

## Rotation / RoPE

### `ds4_deepseek41_cuda.cuh`

DeepSeek V4.1 CUDA path.

Current points of interest:

- one warp lane owns one adjacent coordinate pair in the RoPE tail;
- explicit `re*c-im*s`, `re*s+im*c` update;
- deliberate binary64-backed `sin`/`cos` range reduction for long absolute
  positions before converting back to float;
- useful evidence that coefficient generation and pair application have
  distinct numerical concerns.

### `metal/dsv41.metal`

Metal version of the same V4.1 operation.

Current points of interest:

- one SIMD lane per pair;
- `precise::cos` and `precise::sin`;
- useful comparison against the CUDA realization of the same model operation.

### `ds4_qwen4_cuda.cuh`

Qwen CUDA work.

Current points of interest:

- `apply_rope` uses split-half pairing rather than adjacent pairing;
- surrounding normalization and storage make the complete dataflow more
  important than the four scalar rotation operations alone;
- a vision path uses `sincosf`, demonstrating that DwarfStar itself does not
  enforce one universal trigonometric strategy.

### `metal/dsv4_rope.metal`

Metal RoPE helpers and model-specific application.

Read for pair mapping, model-specified rotary dimensions, coefficient handling,
and how the rotation helper sits inside larger kernels.

## Fusion boundaries

### `metal/norm.metal`

Contains a decode-only fused path combining Q/KV RMS normalization, a KV RoPE
tail, and final storage work that had previously been separate dispatches.

Useful when asking:

- what state is reused across stages;
- what synchronization remains;
- which arithmetic/rounding order was deliberately kept unchanged.

### `metal/dsv4_kv.metal`

Contains the opposite lesson: a path where the normal RoPE kernel was kept
separate because small trigonometric code-generation changes could alter later
sampled tokens.

This is particularly useful evidence against treating "fewer dispatches" as an
unconditional optimization rule.

## ROCm comparison

### `rocm/ds4_rocm_norm_rope.cuh`

ROCm normalization/RoPE code.

Use this when comparing whether Metal/CUDA observations are architectural or
merely one backend's implementation choice.

## Model-level context

### `docs/QWEN38_FLASH_NEXT.md`

Useful context for how the lower-level kernels fit into a complete model path,
including vision and positional encoding.

## Reading questions

For each relevant file, record:

1. What mathematical/model operation is being implemented?
2. What layout is required by the model and what layout is chosen by the target?
3. What is one thread/lane responsible for?
4. What values are shared or reused?
5. What precision is used for storage, products, reductions, phase, and
   transcendental evaluation?
6. What stages are fused?
7. What stages are intentionally kept separate?
8. What tests or end-to-end evidence justified the implementation?
9. Which observation could transfer to PowerVR/Mali/shader work, and which is
   specific to LLM inference?
