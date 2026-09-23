# GPU Gems 2 — chapter-by-chapter notes

Matt Pharr, editor; NVIDIA/Addison-Wesley, 2005.

Source: NVIDIA's complete live HTML edition:

https://developer.nvidia.com/gpugems/gpugems2/copyright

These are original summaries written from the hosted chapter text, not copied
abstracts. The second paragraph under each chapter reads the chapter through
[the current repository problem lens](../problem-lens.md).

## Part I — Geometric Complexity

### 1. Toward Photorealism in Virtual Botany

https://developer.nvidia.com/gpugems/gpugems2/part-i-geometric-complexity/chapter-1-toward-photorealism-virtual-botany

**Summary.** The chapter builds a convincing outdoor scene by treating
vegetation as a hierarchy of representations rather than insisting on one
geometric description at every distance. It combines deterministic placement,
billboards and batched grass, texture atlases, level of detail, wind and
lighting approximations, and transition techniques that keep representation
changes visually quiet.

**For this repository.** The useful lesson is representation staging: the
semantic object may be "vegetation," while the target realization changes with
scale. That supports keeping semantic structure above the shader target rather
than letting one convenient representation become the ontology.

### 2. Terrain Rendering Using GPU-Based Geometry Clipmaps

https://developer.nvidia.com/gpugems/gpugems2/part-i-geometric-complexity/chapter-2-terrain-rendering-using-gpu-based-geometry

**Summary.** Geometry clipmaps represent terrain by nested regular grids centered
around the viewer. As the camera moves, small portions of those grids are
updated rather than rebuilding an irregular adaptive mesh. Regularity makes
storage, compression, interpolation, and GPU processing simpler while still
giving smooth level-of-detail transitions.

**For this repository.** This is a good example of deliberately choosing a
regular bounded representation because it maps well to the GPU. That is
different from flattening an already useful structure accidentally. Fixed
shader arrays and bounded loops should be judged in this same spirit.

### 3. Inside Geometry Instancing

https://developer.nvidia.com/gpugems/gpugems2/part-i-geometric-complexity/chapter-3-inside-geometry-instancing

**Summary.** Instancing attacks the cost of drawing many similar small objects.
The expensive part is often not the vertex arithmetic but repeated API calls,
state changes, and duplicated per-object data. The chapter separates shared
geometry from per-instance attributes such as transform, color, and orientation
so many objects can be processed with less submission overhead.

**For this repository.** This is a reminder that repeated mathematical structure
can be valuable structure. A compiler should not duplicate identical code/data
merely because an early lowering made each instance look independent.

### 4. Segment Buffering

https://developer.nvidia.com/gpugems/gpugems2/part-i-geometric-complexity/chapter-4-segment-buffering

**Summary.** Segment buffering reduces rendering overhead by joining nearby,
similarly rendered static objects into larger batches while retaining enough
spatial organization to avoid turning the whole scene into one unmanageable
object. It trades some fine-grained independence for fewer state changes and
draw submissions.

**For this repository.** The relevant compiler question is where aggregation
belongs. Combining many small operations may be excellent at the target level,
but it should happen from preserved information rather than because semantic
boundaries vanished too early.

### 5. Optimizing Resource Management with Multistreaming

https://developer.nvidia.com/gpugems/gpugems2/part-i-geometric-complexity/chapter-5-optimizing-resource-management-multistreaming

**Summary.** Instead of storing every vertex attribute in one inseparable
record, multistreaming divides geometry, texture coordinates, animation data,
and other attributes into streams. A pass binds only the streams it needs,
reducing transfers and working-set pressure.

**For this repository.** This is directly relevant to layout decisions around
Q/K/V, rotation coefficients, fixed arrays, and target-specific packing.
Storage layout is a late representation choice; it should not silently redefine
the higher-level object.

### 6. Hardware Occlusion Queries Made Useful

https://developer.nvidia.com/gpugems/gpugems2/part-i-geometric-complexity/chapter-6-hardware-occlusion-queries-made-useful

**Summary.** A naïve occlusion-query loop can lose its benefit by adding extra
draws and forcing the CPU to wait for query results. The chapter uses spatial
hierarchy, front-to-back traversal, temporal coherence, and asynchronous use of
previous information to turn queries into a latency-tolerant visibility system.

**For this repository.** The larger lesson is that introducing an apparently
cheap predicate can be disastrous if it also introduces synchronization or
eager work. Measure the whole execution schedule rather than counting source
operations.

### 7. Adaptive Tessellation of Subdivision Surfaces with Displacement Mapping

https://developer.nvidia.com/gpugems/gpugems2/part-i-geometric-complexity/chapter-7-adaptive-tessellation-subdivision-surfaces

**Summary.** The chapter moves repeated subdivision and displacement work onto
the GPU. Intermediate surface data are encoded in textures, fragment programs
perform subdivision and flatness-related work, and multiple passes refine the
surface until the final geometry can be rendered.

**For this repository.** The interesting feature is the explicit iterative
structure. On old hardware it is expressed as passes; on a newer target it may
be a loop or another primitive. The iteration itself is semantic enough to keep
visible until target lowering.

### 8. Per-Pixel Displacement Mapping with Distance Functions

https://developer.nvidia.com/gpugems/gpugems2/part-i-geometric-complexity/chapter-8-pixel-displacement-mapping-distance-functions

**Summary.** Rather than tessellating every fine surface feature into geometry,
the chapter stores a three-dimensional distance field and searches along the
view ray in the pixel shader. Distance values permit large safe steps through
empty space and progressively smaller steps near the displaced surface.

**For this repository.** This is a bounded-search example where the search
structure, step rule, and termination condition matter more than an unrolled
list of samples. It is a useful comparison for the bounded root-search and
bounded-loop IR work.

## Part II — Shading, Lighting, and Shadows

### 9. Deferred Shading in S.T.A.L.K.E.R.

https://developer.nvidia.com/gpugems/gpugems2/part-ii-shading-lighting-and-shadows/chapter-9-deferred-shading-stalker

**Summary.** Deferred shading first renders geometric/material information into
screen-space buffers and then performs lighting as a later image-space
operation. This makes the cost of many dynamic lights less dependent on
re-rendering all object materials for every light.

**For this repository.** It is an example of factoring a computation at a
semantic boundary that exposes reuse. The compiler analogue is preserving a
shared subcomputation or stage instead of duplicating it during lowering.

### 10. Real-Time Computation of Dynamic Irradiance Environment Maps

https://developer.nvidia.com/gpugems/gpugems2/part-ii-shading-lighting-and-shadows/chapter-10-real-time-computation-dynamic

**Summary.** The chapter computes an irradiance representation of incoming
environment lighting on the GPU so that diffuse shading can later use a much
cheaper lookup. Expensive directional integration is reorganized into a
representation appropriate for repeated evaluation.

**For this repository.** It is another storage-versus-computation example.
Precomputation/fusion is useful only when the represented quantity and its
precision are explicit.

### 11. Approximate Bidirectional Texture Functions

https://developer.nvidia.com/gpugems/gpugems2/part-ii-shading-lighting-and-shadows/chapter-11-approximate-bidirectional-texture

**Summary.** Full bidirectional texture functions are very high-dimensional.
The chapter approximates their view- and light-dependent appearance from a much
smaller representation, combining conventional shading with texture/volume
data that reproduces fine material structure and self-shadowing cues.

**For this repository.** The relevance is controlled approximation: if a backend
changes representation for performance, the approximation boundary should be a
declared semantic choice with an oracle, not an accidental consequence of
lowering.

### 12. Tile-Based Texture Mapping

https://developer.nvidia.com/gpugems/gpugems2/part-ii-shading-lighting-and-shadows/chapter-12-tile-based-texture-mapping

**Summary.** Large or repeating surfaces are reconstructed from smaller texture
tiles in the fragment stage. The shader manages tile selection and filtering so
the underlying geometry and ordinary texture coordinates need not be rewritten
for every large texture.

**For this repository.** This is a clean example of a target-side indirection
scheme. The tile encoding is an implementation representation, not the meaning
of the logical texture.

### 13. Implementing the mental images Phenomena Renderer on the GPU

https://developer.nvidia.com/gpugems/gpugems2/part-ii-shading-lighting-and-shadows/chapter-13-implementing-mental-images

**Summary.** mental ray builds rendering effects out of modular shaders and
graphs, whereas a GPU of the period expects a monolithic fragment program. The
chapter preserves a graph of typed interfaces and connected shader components,
then specializes/composes the required pieces into one GPU program at runtime.
Constants are exposed to the compiler so dead or fixed work can be removed.

**For this repository.** This is almost a compiler-design case study. It argues
for retaining graph/module/interface structure until the target program is
formed instead of asking authors to write the already-lowered monolith. The
same principle applies to conditionals, bounded loops, reductions, and
pair-rotations: preserve the useful object, then specialize it.

### 14. Dynamic Ambient Occlusion and Indirect Lighting

https://developer.nvidia.com/gpugems/gpugems2/part-ii-shading-lighting-and-shadows/chapter-14-dynamic-ambient-occlusion-and

**Summary.** The chapter approximates diffuse occlusion and indirect lighting
with a collection of surface elements and GPU-friendly transfer computations.
It seeks a dynamic approximation that avoids an explicit expensive visibility
test between every pair of surface points.

**For this repository.** The interesting part is algorithm reformulation:
replace an impractical all-pairs structure with a bounded approximation while
keeping the intended physical quantity explicit enough to test.

### 15. Blueprint Rendering and "Sketchy Drawings"

https://developer.nvidia.com/gpugems/gpugems2/part-ii-shading-lighting-and-shadows/chapter-15-blueprint-rendering-and-sketchy

**Summary.** This is a non-photorealistic, multipass rendering pipeline. It
extracts visible and hidden line information and combines it with image-space
textures/noise so ordinary geometry can be rendered as technical drawings or
rough sketches.

**For this repository.** It is mostly a rendering example, but it reinforces
that passes have different meanings. Collapsing them is safe only when the
observable result and dependencies are preserved.

### 16. Accurate Atmospheric Scattering

https://developer.nvidia.com/gpugems/gpugems2/part-ii-shading-lighting-and-shadows/chapter-16-accurate-atmospheric-scattering

**Summary.** The chapter implements a physically motivated atmospheric
scattering model using altitude-dependent density and numerical sampling along
view/light paths. The practical problem is choosing enough samples and
precision for a convincing result without making every pixel too expensive.

**For this repository.** This is relevant to bounded numerical integration:
sample count, loop structure, exponential/transcendental precision, and error
should remain explicit instead of being hidden in duplicated shader text.

### 17. Efficient Soft-Edged Shadows Using Pixel Shader Branching

https://developer.nvidia.com/gpugems/gpugems2/part-ii-shading-lighting-and-shadows/chapter-17-efficient-soft-edged-shadows-using

**Summary.** The chapter avoids paying for an expensive soft-shadow filter
everywhere. It performs cheaper tests first and uses shader branching so
additional shadow samples are taken mainly in the uncertain penumbra region.

**For this repository.** This is directly relevant to `RSelect`: the value of
the algorithm comes from *not executing* expensive work on one path. Lowering
the source branch to "compute both, select later" destroys the algorithm even
if the final value is mathematically correct. A target may choose predication
for a tiny branch, but that choice must happen after branch structure survives.

### 18. Using Vertex Texture Displacement for Realistic Water Rendering

https://developer.nvidia.com/gpugems/gpugems2/part-ii-shading-lighting-and-shadows/chapter-18-using-vertex-texture-displacement

**Summary.** Water motion is split by scale: lower-frequency displacement moves
geometry while higher-frequency normal/detail information is handled in
textures. The chapter also uses available shader-model control flow to avoid
unnecessary vertex work.

**For this repository.** The multi-scale factorization is the useful point.
Different representations of the same phenomenon can coexist without erasing
the semantic relation between them.

### 19. Generic Refraction Simulation

https://developer.nvidia.com/gpugems/gpugems2/part-ii-shading-lighting-and-shadows/chapter-19-generic-refraction-simulation

**Summary.** Refraction is approximated in screen space by reusing the rendered
background as a texture, perturbing lookup coordinates according to the
refractive surface, and masking cases where the approximation would sample the
wrong object.

**For this repository.** This is target-specific approximation and should be
read as such: useful, cheap, and intentionally not identical to general ray
tracing.

## Part III — High-Quality Rendering

### 20. Fast Third-Order Texture Filtering

https://developer.nvidia.com/gpugems/gpugems2/part-iii-high-quality-rendering/chapter-20-fast-third-order-texture-filtering

**Summary.** Cubic B-spline reconstruction appears to require many samples, but
the chapter algebraically groups terms so hardware linear filtering performs
part of the weighted combination. In three dimensions a 64-term tricubic
reconstruction is reduced to eight trilinear fetches. The same construction is
extended to first/second derivatives and mipmapped data.

**For this repository.** This is an excellent example of preserving algebraic
structure long enough to exploit a target primitive. A compiler that flattened
the convolution into unrelated scalar loads/multiplies might make the eight-
fetch formulation much harder to recover. It is analogous to retaining a
two-coordinate rotation or reduction tree rather than hoping a later pass
rediscovers it.

### 21. High-Quality Antialiased Rasterization

https://developer.nvidia.com/gpugems/gpugems2/part-iii-high-quality-rendering/chapter-21-high-quality-antialiased-rasterization

**Summary.** The chapter performs high-quality antialiasing with tiled
supersampling and wider reconstruction filters than the normal framebuffer path
allows. Tiling controls memory use; padding/overlap ensures that filtering near
tile boundaries remains correct.

**For this repository.** Boundary handling is the interesting structural issue:
an optimization that partitions work must retain enough neighborhood
information to make each partition semantically equivalent.

### 22. Fast Prefiltered Lines

https://developer.nvidia.com/gpugems/gpugems2/part-iii-high-quality-rendering/chapter-22-fast-prefiltered-lines

**Summary.** High-quality line rendering is converted into a fixed-cost lookup
problem by precomputing how a chosen symmetric filter responds to line
coverage. Runtime shaders then evaluate the geometric distance and fetch the
appropriate filtered value.

**For this repository.** Another precomputation case: the lookup table is a
target realization of a mathematical function. Keep the function/accuracy
contract separate from the table representation.

### 23. Hair Animation and Rendering in the Nalu Demo

https://developer.nvidia.com/gpugems/gpugems2/part-iii-high-quality-rendering/chapter-23-hair-animation-and-rendering-nalu-demo

**Summary.** The Nalu hair system simulates a relatively small set of control
hairs and derives many visible strands from them, then adds specialized
lighting and self-shadowing. It avoids paying full dynamic simulation cost for
every rendered strand.

**For this repository.** It demonstrates hierarchy and generated structure:
preserve the relation between control state and derived instances rather than
materializing every instance as independent source work.

### 24. Using Lookup Tables to Accelerate Color Transformations

https://developer.nvidia.com/gpugems/gpugems2/part-iii-high-quality-rendering/chapter-24-using-lookup-tables-accelerate-color

**Summary.** A chain of expensive color operations is sampled into a 3D lookup
table. Runtime rendering turns the composite transform into one volume-texture
lookup plus interpolation, making execution cost largely independent of the
number of original color operators.

**For this repository.** This is safe fusion only because the composite
function is deliberately precomputed. For QK normalization plus RoPE, the
analogous fusion is valid only after proving the operations and ordering being
fused have the required algebraic relation.

### 25. GPU Image Processing in Apple's Motion

https://developer.nvidia.com/gpugems/gpugems2/part-iii-high-quality-rendering/chapter-25-gpu-image-processing-apples-motion

**Summary.** Motion maps image-processing operators onto fragment programs and
multipass rendering. The chapter is unusually candid about what maps cleanly
(image-in/image-out local operations) and what does not (global statistics,
scatter, sequential neighborhood dependencies), as well as precision,
instruction limits, multipass decomposition, debugging, and CPU reference
implementations.

**For this repository.** This is one of the most important chapters in the
book. Its hardware generation lived close to the exact `RSelect` trap: some
conditionals were effectively "compute alternatives, then select." That is a
*target limitation*, not a reason to erase source control flow. The chapter
also supports keeping an independent reference path and naming precision/pass
boundaries explicitly.

### 26. Implementing Improved Perlin Noise

https://developer.nvidia.com/gpugems/gpugems2/part-iii-high-quality-rendering/chapter-26-implementing-improved-perlin-noise

**Summary.** The chapter implements the improved Perlin-noise construction as a
shader, balancing permutation/gradient lookup data against arithmetic and
preserving the smooth interpolation properties of the CPU reference. It
extends naturally to higher dimensions.

**For this repository.** It is relevant to deterministic primitive
implementation: a procedural function should have a small oracle and explicit
precision/lookup semantics rather than being accepted because the picture
"looks noisy enough."

### 27. Advanced High-Quality Filtering

https://developer.nvidia.com/gpugems/gpugems2/part-iii-high-quality-rendering/chapter-27-advanced-high-quality-filtering

**Summary.** The chapter develops practical higher-quality image resampling and
filtering on the GPU, including the coordinate conventions and separable/filter
structure needed for resizing, warping, sharpening, and related operations.

**For this repository.** Filters are structured sums with reuse and separability.
That structure can guide reductions and target-specific packing; flattening it
too early loses optimization choices.

### 28. Mipmap-Level Measurement

https://developer.nvidia.com/gpugems/gpugems2/part-iii-high-quality-rendering/chapter-28-mipmap-level-measurement

**Summary.** Instead of guessing which texture levels are actually used, this
chapter instruments rendering so the application can measure visible mipmap
requirements and feed that information back into resource management.

**For this repository.** The connection is methodological: use receipts from the
emitted/running target. A source-level belief about what the driver "must" do is
not evidence.

## Part IV — General-Purpose Computation on GPUs: A Primer

### 29. Streaming Architectures and Technology Trends

https://developer.nvidia.com/gpugems/gpugems2/part-iv-general-purpose-computation-gpus-primer/chapter-29-streaming-architectures

**Summary.** This chapter explains why streaming/data-parallel architectures
can devote more silicon and bandwidth to arithmetic than general-purpose CPU
designs. It frames kernels over streams, high arithmetic intensity, locality,
and communication cost as the central model for understanding GPU advantage.

**For this repository.** The lasting point is not the 2005 hardware details.
It is that a compiler benefits from retaining stream/data-parallel structure.
That argues against lowering mathematically meaningful operations immediately
into an undifferentiated scalar instruction list.

### 30. The GeForce 6 Series GPU Architecture

https://developer.nvidia.com/gpugems/gpugems2/part-iv-general-purpose-computation-gpus-primer/chapter-30-geforce-6-series-gpu

**Summary.** A concrete tour of the GeForce 6 pipeline: host interface,
programmable vertex/fragment stages, rasterization, memory, floating-point
features, and the execution constraints that shaped then-current shader code.

**For this repository.** Treat it as a historical target case, not a universal
GPU ontology. It is useful precisely because it shows how much target details
change while higher-level mathematical structures remain recognizable.

### 31. Mapping Computational Concepts to GPUs

https://developer.nvidia.com/gpugems/gpugems2/part-iv-general-purpose-computation-gpus-primer/chapter-31-mapping-computational

**Summary.** Ordinary arrays and kernels are mapped onto the graphics pipeline:
textures become read-only arrays/streams, render targets hold outputs,
fragment programs are kernels, texture lookups implement gather, and repeated
passes implement iterative computations.

**For this repository.** The chapter is a translation dictionary. It supports
having an explicit source/semantic layer and a separate target mapping. A
texture is not intrinsically an array, and an array is not intrinsically a
texture.

### 32. Taking the Plunge into GPU Computing

https://developer.nvidia.com/gpugems/gpugems2/part-iv-general-purpose-computation-gpus-primer/chapter-32-taking-plunge-gpu

**Summary.** The chapter is a practical guide to deciding whether a computation
belongs on a GPU and then reformulating it around parallelism, bandwidth,
locality, arithmetic intensity, and available memory-access patterns. It warns
against merely transliterating a CPU algorithm.

**For this repository.** This supports a semantic IR plus target-specific
lowering: preserve the mathematical computation, then choose a GPU-shaped
realization rather than baking one target's storage/schedule into the source
language.

### 33. Implementing Efficient Parallel Data Structures on GPUs

https://developer.nvidia.com/gpugems/gpugems2/part-iv-general-purpose-computation-gpus-primer/chapter-33-implementing-efficient

**Summary.** The chapter shows how dense, sparse, hierarchical, and irregular
structures were encoded with textures, indices, fixed levels of indirection,
blocking, repeated passes, conditional activity, and occasional CPU assistance
for dynamic allocation. Sparse traversal is often made regular by grouping
items with similar access patterns.

**For this repository.** This is exactly the distinction between semantic data
structure and target representation. The backend's refusal of general
heap-shaped data should not be "fixed" by pretending every list is a texture
index graph. But a *known bounded structure* may legitimately lower to such an
encoding on a target that benefits from it.

### 34. GPU Flow-Control Idioms

https://developer.nvidia.com/gpugems/gpugems2/part-iv-general-purpose-computation-gpus-primer/chapter-34-gpu-flow-control-idioms

**Summary.** The chapter separates several different ways of realizing
decisions and iteration: true SIMD branching, predication, moving a decision to
an earlier stage, static branch resolution into different programs/domains,
precomputation, depth/stencil-based masking, and multipass iteration. On
predicated hardware, both sides of a branch execute and only writes are
conditioned.

**For this repository.** This should be attached directly to the structured-
control-flow work. A source `if` and a predicated target implementation are
not the same IR object. Preserve the branch; later choose predication only when
the target and branch cost make it appropriate. The same chapter also argues
for keeping iteration explicit rather than encoding one historical realization
as the loop's meaning.

### 35. GPU Program Optimization

https://developer.nvidia.com/gpugems/gpugems2/part-iv-general-purpose-computation-gpus-primer/chapter-35-gpu-program-optimization

**Summary.** The chapter covers vectorization/packing, moving work to a lower
execution frequency, precomputation, lookup tables, avoiding expensive
inner-loop branching, swizzles, bandwidth/computation balance, and—most
importantly—profiling each proposed optimization. It repeatedly warns that a
source change that seems obviously faster can lose after driver compilation.

**For this repository.** Pair rotations and small reductions may benefit from
packing, but that should be demonstrated on emitted physical targets. The
chapter's "move work to the right frequency" idea also suggests keeping
coefficient generation separate from applying many rotations: one may be
uniform/reused while the other is per-element.

### 36. Stream Reduction Operations for GPGPU Applications

https://developer.nvidia.com/gpugems/gpugems2/part-iv-general-purpose-computation-gpus-primer/chapter-36-stream-reduction

**Summary.** Reductions are awkward on the old fragment model because many
inputs must become fewer outputs and fragments cannot simply scatter arbitrary
results. The chapter develops parallel reduction/compaction-style operations as
structured sequences of passes rather than a serial accumulator.

**For this repository.** Q/K normalization has a real reduction object inside
it. Retaining "sum squares over this head" gives the target a chance to choose a
tree, subgroup operation, shared-memory scheme, fragment-pass scheme, or other
implementation while preserving accumulation-width/error policy. Flattening it
into arbitrary adds loses both scheduling and numerical intent.

## Part V — Image-Oriented Computing

### 37. Octree Textures on the GPU

https://developer.nvidia.com/gpugems/gpugems2/part-v-image-oriented-computing/chapter-37-octree-textures-gpu

**Summary.** Sparse three-dimensional data are represented as an octree encoded
in textures. Traversal repeatedly follows child indices until the desired node
or depth is reached; the chapter also handles filtering and applications such
as painting/simulation on sparse surfaces.

**For this repository.** The traversal is a useful bounded-loop example: fixed
maximum depth plus possible earlier completion. The semantic object is
hierarchical traversal; a target may realize it as a loop, unrolled levels, or
masked iterations.

### 38. High-Quality Global Illumination Rendering Using Rasterization

https://developer.nvidia.com/gpugems/gpugems2/part-v-image-oriented-computing/chapter-38-high-quality-global-illumination

**Summary.** Rather than reproduce a classic CPU ray tracer literally, the
chapter exploits rasterization as a massively parallel visibility/evaluation
engine for parts of a global-illumination calculation, including final-gather
style work.

**For this repository.** This is target lowering done correctly: preserve the
global-illumination quantity, then choose a target-native primitive that
computes it efficiently.

### 39. Global Illumination Using Progressive Refinement Radiosity

https://developer.nvidia.com/gpugems/gpugems2/part-v-image-oriented-computing/chapter-39-global-illumination-using-progressive

**Summary.** Progressive radiosity is reformulated around operations GPUs of the
time could perform efficiently. Energy transfer and visibility are organized
around texture-space gather-like computations rather than arbitrary scatter.

**For this repository.** A missing primitive can justify an alternate lowering,
but the alternative should still expose which mathematical operation it
implements. That is the same discipline needed when targeting GLSL versus
future compute-style backends.

### 40. Computer Vision on the GPU

https://developer.nvidia.com/gpugems/gpugems2/part-v-image-oriented-computing/chapter-40-computer-vision-gpu

**Summary.** Common vision operations are decomposed into image-sized streams,
neighborhood filters, pyramids, and repeated GPU passes. The chapter treats
vision as a pipeline of mathematical image operators rather than as a graphics
special case.

**For this repository.** This is useful evidence that a shader IR can represent
general numerical operators, but the operator structure—convolution, reduction,
pyramid, iteration—should remain identifiable.

### 41. Deferred Filtering: Rendering from Difficult Data Formats

https://developer.nvidia.com/gpugems/gpugems2/part-v-image-oriented-computing/chapter-41-deferred-filtering-rendering-difficult

**Summary.** Data layouts that are efficient for computation are not always
layouts the texture hardware can filter directly. The chapter first computes
from the awkward representation, then reconstructs the required subset into a
conventional texture representation so ordinary hardware filtering can be used.

**For this repository.** This is almost a manifesto for separating semantics
from representation. One consumer's optimal storage should not define the
object globally; convert at a boundary when a different target operation needs
a different layout.

### 42. Conservative Rasterization

https://developer.nvidia.com/gpugems/gpugems2/part-v-image-oriented-computing/chapter-42-conservative-rasterization

**Summary.** Standard sample-point rasterization can miss pixels whose cells
intersect a primitive. Conservative rasterization changes the coverage rule so
all potentially intersected cells are generated, which is important when
rasterization is being used as a computational primitive rather than merely to
make an image.

**For this repository.** It highlights specification versus convenient
approximation. When the shader backend is used for numerical work, "looks
right" coverage can be wrong even if visually indistinguishable.

## Part VI — Simulation and Numerical Algorithms

### 43. GPU Computing for Protein Structure Prediction

https://developer.nvidia.com/gpugems/gpugems2/part-vi-simulation-and-numerical-algorithms/chapter-43-gpu-computing-protein

**Summary.** The chapter accelerates iterative tightening of pairwise distance
bounds used in protein-structure prediction. A dense matrix of bounds is
updated repeatedly using triangle-inequality style relationships, exposing a
large amount of parallel relaxation work.

**For this repository.** This is a numerical fixed-point/relaxation example:
iteration count, update dependencies, data layout, and stopping policy are
first-class algorithm structure, not incidental generated code.

### 44. A GPU Framework for Solving Systems of Linear Equations

https://developer.nvidia.com/gpugems/gpugems2/part-vi-simulation-and-numerical-algorithms/chapter-44-gpu-framework-solving

**Summary.** The chapter builds GPU representations and operations for vectors
and dense, banded, and sparse matrices, then uses them to construct linear
solvers and related applications. The main work is not the scalar formula for
one multiply; it is mapping matrix/vector structure, repeated products, inner
products, and iteration onto the graphics pipeline.

**For this repository.** This is the most direct numerical-linear-algebra
reference. It should be read for which structures deserve semantic nodes:
matrix-vector product, dot/reduction, sparse traversal, and iterative solver
state. It also gives concrete historical layouts to compare against modern
PowerVR/Mali behavior without adopting those layouts as source semantics.

### 45. Options Pricing on the GPU

https://developer.nvidia.com/gpugems/gpugems2/part-vi-simulation-and-numerical-algorithms/chapter-45-options-pricing-gpu

**Summary.** The chapter contrasts option-pricing workloads that are nearly
embarrassingly parallel, such as large sets of Black-Scholes evaluations, with
lattice-style methods that contain staged dependencies. The GPU mapping differs
accordingly.

**For this repository.** Not every numerical workload should be forced into the
same kernel shape. Dependency structure is information worth preserving.

### 46. Improved GPU Sorting

https://developer.nvidia.com/gpugems/gpugems2/part-vi-simulation-and-numerical-algorithms/chapter-46-improved-gpu-sorting

**Summary.** GPU sorting is built from data-independent comparison networks,
especially bitonic-style stages, then improved by reducing unnecessary work and
using GPU-friendly data organization. The algorithm is naturally a schedule of
structured compare/exchange stages.

**For this repository.** This is another warning against flattening a schedule.
A network/stage representation can expose parallelism, pairing, and barriers
that disappear in a flat scalar instruction stream.

### 47. Flow Simulation with Complex Boundaries

https://developer.nvidia.com/gpugems/gpugems2/part-vi-simulation-and-numerical-algorithms/chapter-47-flow-simulation-complex

**Summary.** The chapter implements lattice-Boltzmann-style flow simulation on
the GPU and focuses on handling complex/moving boundaries efficiently. A
straight translation is not enough; boundary representation and memory access
must be redesigned around the machine.

**For this repository.** The lesson is to preserve the numerical update and
boundary semantics, then optimize representation/scheduling separately. It also
connects back to branches whose expensive boundary path should not contaminate
all interior cells.

### 48. Medical Image Reconstruction with the FFT

https://developer.nvidia.com/gpugems/gpugems2/part-vi-simulation-and-numerical-algorithms/chapter-48-medical-image-reconstruction

**Summary.** The chapter maps FFT-based medical reconstruction to the GPU,
organizing Cooley-Tukey butterfly stages, data rearrangement, twiddle-factor
application, and transfers so the pipeline stays busy. Performance comes from
respecting the FFT's staged pairwise structure rather than treating it as an
arbitrary nest of scalar complex operations.

**For this repository.** This is especially relevant to the rotation/Givens/RoPE
investigation. A complex twiddle multiply is another structured two-coordinate
linear operation with reusable coefficients. It is worth comparing how much
target opportunity survives when that operation remains recognizable versus
when it is immediately expanded into unrelated multiplies/adds. Phase and
trigonometric precision also echo the RoPE long-angle questions.

## Cross-chapter takeaways

For the current backend work, the chapters with the highest immediate value are:

- **13** — preserve compositional graph/interface structure until specialization;
- **17, 25, 34** — distinguish semantic branching from eager predication;
- **20** — algebraic structure can expose a radically cheaper target primitive;
- **33, 37, 41** — semantic data structure versus target encoding/layout;
- **35** — coefficient frequency, packing, and measurement on actual output;
- **36, 44** — reductions and numerical linear-algebra structure;
- **46, 48** — stage/pair structure that a flat lowering can obscure.

None of those chapters argues that the 2005 graphics pipeline should become the
backend's permanent IR. Taken together they argue almost the opposite: keep
useful mathematical/program structure visible, then exploit the actual target
late enough that the choice can still be changed.
