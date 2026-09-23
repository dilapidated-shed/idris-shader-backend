# GPU Gems 3 — chapter-by-chapter notes

NVIDIA/Addison-Wesley, 2007.

NVIDIA hosts the complete book online:

https://developer.nvidia.com/gpugems/gpugems3/foreword

These are original summaries from NVIDIA's hosted chapter/part text, with a
second layer aimed at the technical questions in
[the current repository problem lens](../problem-lens.md).

## Part I — Geometry

Official part page:

https://developer.nvidia.com/gpugems/gpugems3/part-i-geometry

### 1. Generating Complex Procedural Terrains Using the GPU

Uses newer GPU geometry capabilities to generate detailed terrain
procedurally, while adding controls that keep procedural generation usable in a
designed world rather than producing unconstrained noise.

**Current-work connection:** generation rules and their parameters are useful
semantic structure; generated triangles are a target/output representation.

### 2. Animated Crowd Rendering

Uses GPU-side animation and newer stream/buffer features to render a very large
crowd while keeping CPU submission and per-character overhead bounded.

**Current-work connection:** repeated instances with shared animation structure
should remain a repeated computation, not become thousands of unrelated copies.

### 3. DirectX 10 Blend Shapes: Breaking the Limits

Revisits blend-shape facial animation using newer hardware so more shapes and
richer combinations can be evaluated without the tight limits of earlier
shader models.

**Current-work connection:** weighted vector combinations are structured linear
operations; preserving that shape can expose packing/reuse opportunities.

### 4. Next-Generation SpeedTree Rendering

Improves nearby tree geometry, shading and shadows so vegetation keeps detail
without overwhelming the renderer.

### 5. Generic Adaptive Mesh Refinement

Presents a GPU-accelerated adaptive-refinement method intended to work over many
surface types rather than one hand-coded terrain/mesh case.

**Current-work connection:** refinement is a structured, data-dependent
iteration. A semantic refinement/iteration object gives different targets room
to choose loops, queues, stream output or other realizations.

### 6. GPU-Generated Procedural Wind Animations for Trees

Generates layered tree motion procedurally on the GPU so large vegetation sets
can react to wind without storing a unique animation for every branch/leaf.

### 7. Point-Based Visualization of Metaballs on a GPU

Renders implicit metaball fields through a point-based GPU method rather than
requiring the usual CPU-generated polygonization path.

**Current-work connection:** an implicit field and its chosen visualization
method are distinct representations; the field semantics should survive above
the rendering choice.

## Part II — Light and Shadows

Official part page:

https://developer.nvidia.com/gpugems/gpugems3/part-ii-light-and-shadows

### 8. Summed-Area Variance Shadow Maps

Combines variance shadow maps with summed-area tables so large, per-pixel
variable filter regions can be evaluated efficiently for soft shadows.

**Current-work connection:** summed-area construction is a scan/reduction-style
operator. Preserve that structure rather than flattening the arithmetic before
a target can choose an efficient parallel form.

### 9. Interactive Cinematic Relighting with Global Illumination

Uses GPU computation and assumptions such as a fixed camera to let artists
iterate on expensive global-illumination lighting much faster than rerunning a
full CPU render.

**Current-work connection:** specialization from known invariants is a target
optimization; fixed parameters should remain explicit enough to justify the
specialization.

### 10. Parallel-Split Shadow Maps on Programmable GPUs

Splits the view frustum into regions and allocates shadow-map resolution more
appropriately to each region, reducing sampling waste/aliasing.

**Current-work connection:** partitioning/layout is a representation strategy
above one visibility function, not a change to the underlying semantics.

### 11. Efficient and Robust Shadow Volumes Using Hierarchical Occlusion Culling and Geometry Shaders

Combines geometry-shader generation with hierarchical culling to make stencil
shadow volumes more robust and reduce work, including difficult/nonclosed
geometry cases.

**Current-work connection:** like the `RSelect` problem, the value of culling
comes from not generating/executing irrelevant work. Preserve the conditional
structure until the target can exploit it.

### 12. High-Quality Ambient Occlusion

Improves earlier real-time ambient-occlusion approximations to reduce artifacts
while retaining enough efficiency for dynamic scenes.

### 13. Volumetric Light Scattering as a Post-Process

Approximates atmospheric/light-shaft scattering in image space after rendering,
including occlusion by opaque scene geometry.

**Current-work connection:** explicit post-process factoring is a deliberate
stage boundary. Fusion can be considered later without confusing stages.

## Part III — Rendering

Official part page:

https://developer.nvidia.com/gpugems/gpugems3/part-iii-rendering

### 14. Advanced Techniques for Realistic Real-Time Skin Rendering

Combines physically based reflectance, translucent shadow maps and a
texture-space diffusion approximation of subsurface scattering for realistic
skin at interactive rates.

**Current-work connection:** a multi-stage mathematical model should keep its
operators identifiable so approximation and precision can be tested separately.

### 15. Playable Universal Capture

Compresses captured facial appearance/animation data with principal-component
analysis so film-style capture can be reproduced in a real-time game.

**Current-work connection:** PCA/basis coefficients are explicit linear
structure that should remain available to a numerical backend instead of being
expanded prematurely into scalar expressions.

### 16. Vegetation Procedural Animation and Shading in Crysis

Describes procedural animation and shading used to make densely populated Crysis
vegetation dynamic without individually animating every object.

### 17. Robust Multiple Specular Reflections and Refractions

Brings multiple-bounce reflection/refraction effects associated with ray
tracing into a real-time GPU formulation.

**Current-work connection:** traversal/bounce count is bounded iteration with
data-dependent continuation; preserve the iteration object before choosing
unroll/branch/mask strategy.

### 18. Relaxed Cone Stepping for Relief Mapping

Improves relief mapping by using a precomputed cone-like bound to take larger
safe steps through height data while avoiding artifacts of earlier stepping
methods.

**Current-work connection:** very close to the bounded-search issue. The search
rule and termination condition are semantic structure; a flat list of samples
throws away the reason the algorithm is fast.

### 19. Deferred Shading in Tabula Rasa

A production account of running a deferred renderer: advanced lights, readable
depth/normal buffers, optimizations and the practical problems that appear once
the technique becomes a complete engine rather than a small demo.

**Current-work connection:** intermediates are intentionally materialized
because later work reuses them. Fusion should be evaluated against that reuse,
not assumed desirable.

### 20. GPU-Based Importance Sampling

Implements importance sampling for realistic BRDF evaluation with minimal
precomputation so dynamic lighting can remain practical.

**Current-work connection:** distribution/sampling structure and random-number
quality are algorithmic objects; don't bury them in target-specific indexing.

## Part IV — Image Effects

Official part page:

https://developer.nvidia.com/gpugems/gpugems3/part-iv-image-effects

### 21. True Impostors

Uses an image/volume-like representation that can reproduce a complex object's
view-dependent depth/appearance more faithfully than a simple billboard.

**Current-work connection:** another example of representation substitution
that should be named explicitly rather than treated as the object itself.

### 22. Baking Normal Maps on the GPU

Moves the expensive projection/comparison work of generating normal maps from
high-resolution geometry onto the GPU.

**Current-work connection:** a preprocessing kernel can share the same semantic
math as a runtime shader while having a completely different schedule/layout.

### 23. High-Speed, Off-Screen Particles

Renders/updates large particle populations partly at reduced/off-screen
resolution to cut fill cost while retaining plausible final appearance.

**Current-work connection:** a deliberate approximation/sampling-rate change,
not a general license to lower all computations at reduced precision/resolution.

### 24. The Importance of Being Linear

Explains why lighting/filtering/compositing should generally operate in a
linear-light space and what goes wrong when gamma-encoded values are treated as
linear numbers.

**Current-work connection:** highly relevant to "representation is not
semantics." Two byte/float encodings of the same physical quantity are not
interchangeable under arithmetic. Conversion boundaries must remain explicit.

### 25. Rendering Vector Art on the GPU

Evaluates scalable vector-style shapes/coverage on the GPU rather than
rasterizing one fixed-resolution image in advance.

**Current-work connection:** preserving geometric/path structure enables target
evaluation at the eventual display resolution.

### 26. Object Detection by Color: Using the GPU for Real-Time Video Image Processing

Maps a color-based detection pipeline over video frames to GPU image operations
for real-time throughput.

**Current-work connection:** thresholding, classification and reductions should
remain identifiable pipeline stages; branch/mask lowering is target-specific.

### 27. Motion Blur as a Post-Processing Effect

Uses depth/velocity information to approximate temporal integration after the
main render rather than rendering many full time samples.

### 28. Practical Post-Process Depth of Field

Builds a production-oriented depth-of-field approximation from scene depth and
image-space filtering, with attention to the artifacts of naïve blur.

## Part V — Physics Simulation

Official part page:

https://developer.nvidia.com/gpugems/gpugems3/part-v-physics-simulation

### 29. Real-Time Rigid Body Simulation on GPUs

Represents rigid bodies through particle sets so one GPU-friendly interaction
framework can trade some exactness for speed and also extend toward nonrigid
systems.

**Current-work connection:** this is an explicit change of model/representation
with a stated accuracy trade, unlike an accidental compiler weakening.

### 30. Real-Time Simulation and Rendering of 3D Fluids

Covers the complete GPU path from volumetric fluid update through integration
with ordinary rasterized scene rendering, including boundaries, memory and
performance.

**Current-work connection:** stencil updates, iterations, boundary conditions
and rendering are separate semantic stages. They should not collapse into an
opaque monolith in IR.

### 31. Fast N-Body Simulation with CUDA

Maps the all-pairs N-body interaction to CUDA using tiling/reuse so many threads
share loaded body data rather than repeatedly fetching the same values.

**Current-work connection:** a textbook case for retaining a structured
all-pairs/tiled computation long enough for target memory hierarchy to matter.

### 32. Broad-Phase Collision Detection with CUDA

Uses parallel spatial subdivision plus reduction, scan and radix-sort building
blocks to eliminate impossible collision pairs before expensive narrow-phase
tests.

**Current-work connection:** one chapter joins several current themes:
conditional work avoidance, reduction, prefix scan, data layout and staged
pipelines. Flattening those primitives destroys useful optimization boundaries.

### 33. LCP Algorithms for Collision Detection Using CUDA

Recasts convex distance/contact calculations into linear-complementarity
problems and implements the resulting parallel numerical algorithm in CUDA.

**Current-work connection:** keep the LCP/linear-algebra structure visible; the
fact that its eventual implementation is scalar arithmetic does not make that
structure irrelevant to the compiler.

### 34. Signed Distance Fields Using Single-Pass GPU Scan Conversion of Tetrahedra

Builds distance fields through a GPU-friendly tetrahedral scan-conversion
algorithm, turning preprocessing that was expensive on CPUs into a parallel
raster operation.

**Current-work connection:** excellent example of a semantic quantity (distance
field) realized through an unexpected target primitive without conflating the
two.

### 35. Fast Virus Signature Matching on the GPU

Uses the GPU as a massively parallel filter for many signature candidates,
showing that stream-style GPU execution can accelerate nongraphics pattern
matching.

**Current-work connection:** filtering/compaction stages are explicit
operators; variable match populations motivate keeping compaction structure
above target details.

## Part VI — GPU Computing

Official part page:

https://developer.nvidia.com/gpugems/gpugems3/part-vi-gpu-computing

### 36. AES Encryption and Decryption on the GPU

Maps integer-heavy AES block operations onto the then-new integer capabilities
of GPUs and studies the suitability of the architecture for cryptographic
streams.

**Current-work connection:** not every shader-relevant primitive is floating
point. Type/width semantics must survive target lowering.

### 37. Efficient Random Number Generation and Application Using CUDA

Implements parallel random-number generation, including Gaussian generation,
for Monte Carlo-style GPU applications.

**Current-work connection:** generator state, statistical guarantees and
numeric transformations are semantic constraints that must not be "optimized"
away because final images look similar.

### 38. Imaging Earth's Subsurface Using CUDA

Ports computationally expensive pieces of industrial seismic processing to CUDA
and considers GPU clusters for very large data sets.

**Current-work connection:** large numerical pipelines expose data-placement and
batching decisions that should stay downstream of the mathematical operators.

### 39. Parallel Prefix Sum (Scan) with CUDA

Develops an efficient parallel scan and shows how the primitive supports stream
compaction, radix sort and other algorithms.

**Current-work connection:** one of the strongest arguments in the three
volumes for first-class structured numerical operators. Scan should not be
represented initially as an arbitrary nest of adds. The same logic applies to
Q/K sum-of-squares reductions and other collective operations.

### 40. Incremental Computation of the Gaussian

Avoids repeated exponential evaluation or table lookups by generating Gaussian
coefficients incrementally through a recurrence related to forward
differencing.

**Current-work connection:** directly relevant to RoPE coefficient generation:
precomputed tables, transcendental evaluation and recurrence are alternate
implementations of a coefficient sequence, with different precision and reuse
properties. Keep coefficient generation distinct from coefficient application.

### 41. Using the Geometry Shader for Compact and Variable-Length GPU Feedback

Exploits geometry-shader variable-length output for general algorithms such as
histogram/corner-detection feedback that older vertex/fragment stages handled
poorly.

**Current-work connection:** a particularly useful warning against designing
the semantic IR around one target's inability to express dynamic output. Keep
compaction/variable-output semantics explicit; map them to geometry shaders,
compute primitives, or something else according to the target.

## Highest-value chapters for current backend questions

- **5, 17–18** — adaptive/bounded iteration and traversal.
- **8, 32, 39** — summed-area/reduction/scan structures.
- **24** — representation encoding versus arithmetic semantics.
- **31–33** — tiled all-pairs, staged filtering, and numerical linear algebra.
- **39** — scan as a first-class parallel primitive.
- **40** — recurrence/table/transcendental alternatives for coefficient
  generation, especially relevant to RoPE/Givens.
- **41** — dynamic/compact output preserved above changing target mechanisms.
