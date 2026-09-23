# The CUDA Handbook v2.0 — chapter-by-chapter notes

Nicholas Wilt.

The author hosts the living second-edition text as HTML:

https://www.cudahandbook.com/book/

This changes the status of this entry: the printed/e-book edition is commercial,
but the chapter text is genuinely live-hosted by the author. We still do not
mirror it here; these are original summaries and links.

The summaries below are read against
[the current repository problem lens](../problem-lens.md).

## Part I

### 1. Background

https://www.cudahandbook.com/book/ch1

Traces the architectural shift from CPU-centric graphics/computation toward
throughput-oriented GPUs and explains why massively parallel work fits GPUs
well: more die area is devoted to execution than latency-hiding cache/control,
and performance growth increasingly comes from parallelism rather than clock
speed.

**Current-work connection:** the persistent lesson is not “write CUDA.” It is
that a compiler should preserve parallel structure. Flattening a reduction,
pairwise transform, bounded traversal, or repeated map into a generic scalar
sequence hides exactly the information a throughput target needs.

### 2. Hardware Architecture

https://www.cudahandbook.com/book/ch2

Moves from the abstract CPU/GPU picture to concrete systems: discrete versus
integrated GPUs, multi-GPU machines, address spaces, command submission,
synchronization, streaming multiprocessors, copy engines, PCIe/NVLink and
cluster-scale interconnects.

**Current-work connection:** target architecture is a late constraint. One
semantic shader/numerical operation may need different data movement and
execution choices on the PowerVR phone, Mali tablet, CUDA follower, or future
integrated target.

### 3. Software Architecture

https://www.cudahandbook.com/book/ch3

Explains CUDA's software stack from devices/contexts through modules, kernels,
memory, streams, graphs, host memory, arrays/textures, external-memory
interop, libraries, and the distinction between runtime and driver APIs.

**Current-work connection:** a useful model for keeping layers honest:
source-language semantics, compiler IR, target module, host/runtime interface
and executed kernel are distinct artifacts. Success at one layer is not proof
of the next.

### 4. Software Environment

https://www.cudahandbook.com/book/ch4

Surveys the compiler/assembler/object inspection, debugging, sanitizing,
profiling and system-management tools used to understand what CUDA programs
actually become and how they execute.

**Current-work connection:** directly supports the repo's evidence rule:
inspect emitted target code and profile the real execution instead of trusting
a source-level optimization story.

## Part II

### 5. Memory

https://www.cudahandbook.com/book/ch5

Separates host, global, constant, local, texture, shared and managed memory by
their hardware behavior and intended access patterns, then covers copying and
asynchronous movement. The point is not one universal “GPU memory,” but several
spaces/caches with different semantics and costs.

**Current-work connection:** layout is a target choice. Q/K/V, fixed arrays,
rotation coefficients and intermediate reductions should not inherit one memory
representation merely because one backend prefers it.

### 6. Streams, Events, and Graphs

https://www.cudahandbook.com/book/ch6

Covers coarse-grained concurrency: CPU/GPU overlap, asynchronous copies,
concurrent kernels, events for synchronization/timing, multi-GPU coordination,
and graphs that package repeated launch/dependency structures.

**Current-work connection:** dependencies and stage boundaries are structure.
A compiler or host layer should not erase them into an opaque sequence and then
try to reconstruct safe scheduling later.

### 7. Kernel Execution

https://www.cudahandbook.com/book/ch7

Explains grids, blocks, warps, occupancy, asynchronous launch, dynamic
parallelism, independent thread scheduling, cooperative launches/groups, green
contexts and thread-block clusters. Crucially, ordinary launches do not promise
a useful global execution order or simultaneous residency.

**Current-work connection:** source control flow is not warp execution policy.
Preserve the source branch/loop first; divergence, masking, scheduling and
residency are target properties to reason about afterward.

### 8. Streaming Multiprocessors

https://www.cudahandbook.com/book/ch8

Looks inside the unit that executes kernels: registers, caches/shared memory,
warp scheduling, integer/floating-point units, special-function units,
instruction behavior and generation-to-generation changes. The living edition
also discusses warp-reduction instructions and cases where a cheaper arithmetic
instruction fails to speed a memory-bound kernel.

**Current-work connection:** particularly relevant to RoPE/Givens and
normalization. A fused instruction or packed pair operation is valuable only
when the target is limited by that work. Keep the rotation/reduction semantic
node, then measure whether a PowerVR/Mali/CUDA lowering benefits from a special
implementation.

### 9. Scaling and Data Movement

https://www.cudahandbook.com/book/ch9

Covers multi-GPU scaling, peer access, unified virtual addressing,
inter-GPU synchronization, GPUDirect, collective communication and the
transition from one-device algorithms to cluster-scale data movement.

**Current-work connection:** a mathematically local kernel and its distribution
strategy should be separate layers. Do not bake multi-device topology into the
operator itself.

### 10. Texturing

https://www.cudahandbook.com/book/ch10

Treats textures as a specialized read path with 1D/2D/3D/layered/mipmapped/cube
representations, normalized or unnormalized coordinates, gather operations and
performance-sensitive block sizing.

**Current-work connection:** very close to the old GPGPU literature's central
lesson: textures can efficiently *represent* arrays/fields for one target, but
the semantic object is not intrinsically a texture.

## Part III

### 11. Streaming Workloads

https://www.cudahandbook.com/book/ch11

Uses SAXPY to analyze nearly independent, low-arithmetic-intensity kernels.
Because they are often bandwidth-bound, optimization focuses as much on
movement, overlap and computational density as on the handful of arithmetic
instructions.

**Current-work connection:** a warning against optimizing the wrong layer.
Expanding or fusing arithmetic in a bandwidth-bound shader may do nothing; keep
enough structure to measure the actual limiter.

### 12. Reduction

https://www.cudahandbook.com/book/ch12

Treats reduction explicitly as a class of algorithms: O(N) inputs, O(1)
result, associative binary operator, with warp-, block- and grid-level trees,
bank-conflict/layout choices, atomics/two-stage completion, arbitrary data
types and predicate reductions.

**Current-work connection:** this is directly the Q/K normalization problem.
`sum(x*x)` should remain a reduction object long enough to choose its tree,
lane grouping, accumulation width and synchronization strategy. “Associative”
over real numbers does not make every floating-point reduction tree numerically
identical, so the precision/error contract also belongs with the operation.

### 13. Scan

https://www.cudahandbook.com/book/ch13

Develops prefix scan as a reusable primitive, connects it to hardware/circuit
structures, then follows CUDA implementations through modern single-pass
decoupled look-back. Applications include radix sort, compaction, sparse
matrix-vector multiplication and summed-area tables.

**Current-work connection:** another strong case for structured IR. A scan is
not merely a particular nest of additions. Keeping it explicit exposes
parallelism and lets several later algorithms reuse the same lowering.

### 14. N-Body

https://www.cudahandbook.com/book/ch14

Uses N-body interactions to compare naïve, shared-memory tiled,
constant-memory, warp-shuffle, multi-GPU and optimized-CPU realizations of the
same all-pairs mathematical workload. Different targets/problem sizes favor
different schedules and storage strategies.

**Current-work connection:** exactly the architecture the backend should aim
for: preserve the all-pairs computation; choose tiling, memory space, lane
exchange and device distribution later. This also resembles banks of pairwise
rotations: the repeated pair relation may matter more than the expanded scalar
form.

### 15. Image Processing: Normalized Correlation

https://www.cudahandbook.com/book/ch15

Optimizes normalized cross-correlation through a sequence of representations:
texture reads, constant/shared memory, instruction-level parallelism and DP4A,
tensor cores, FFT reformulation and summed-area tables for the denominator.
The chapter explicitly shows that a cheaper instruction can produce no speedup
until another bottleneck is removed.

**Current-work connection:** perhaps the best single practical analogue to the
current backend research. It preserves one mathematical quantity while trying
several target realizations, and it measures each. It also combines dot
products, reductions, summed-area scans and FFT structure—all operators worth
keeping recognizable.

### 16. Histograms and Radix Sort

https://www.cudahandbook.com/book/ch16

Develops histogram construction under heavy write contention and connects
histograms/counting to sorting. Efficient forms depend on privatization,
aggregation, synchronization, scan and radix-sort stages rather than one naïve
global atomic update per input.

**Current-work connection:** reinforces both stage structure and
variable-output/compaction concerns. Histogram, scan and scatter-like placement
should not become anonymous memory side effects too early in lowering.

## Highest-value chapters for the current backend questions

1. **12 Reduction** — direct Q/K normalization relevance.
2. **13 Scan** — first-class collective structure and compaction.
3. **15 Normalized Correlation** — one mathematical operator, many measured
   target realizations; reduction + FFT + summed-area structure.
4. **8 Streaming Multiprocessors** — lane/instruction/precision questions for
   pair rotations and reductions.
5. **7 Kernel Execution** — semantic branch/loop versus target divergence and
   scheduling.
6. **14 N-Body** — retain repeated pairwise structure until tiling/lane layout.
7. **5/10 Memory and Texturing** — representation/layout below semantics.
8. **4 Software Environment** — inspect/profile emitted target instead of
   inferring it from source.
