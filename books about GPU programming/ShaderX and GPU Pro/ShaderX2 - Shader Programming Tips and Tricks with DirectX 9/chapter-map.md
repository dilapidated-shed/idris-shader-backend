# ShaderX2: Shader Programming Tips and Tricks with DirectX 9 — chapter map

Wolfgang F. Engel, editor. Wordware Publishing, 2004.

Legitimate free-download source:

https://www.realtimerendering.com/resources/shaderx/ShaderX2_Shader_Programming_Tips_and_Tricks_with_DirectX_9.pdf

The volume is freely downloadable by arrangement with the editor/publisher, but
its copyright remains restrictive. This repository links to the PDF rather than
mirroring it.

## Evidence level

The hosted PDF is too large for the current reader to ingest end-to-end in one
pass. The complete table of contents and some chapter text are publicly indexed.
Accordingly:

- **indexed-text** means substantial chapter text/abstract material was actually
  recovered;
- **TOC-guided** means the note is a conservative map from the title and public
  contents, not a claim that the full chapter was read.

The high-value entries below should be upgraded to full-text summaries as
individual chapter text is recovered.

## I. Geometry

### Using Vertex Shaders for Geometry Compression — TOC-guided

Trades vertex-storage/bus bandwidth for shader arithmetic by storing a more
compact geometric representation and reconstructing the needed attributes on
the GPU.

**Current-work connection:** exactly the distinction between semantics and
layout. Compression/packing can be a target choice without becoming the meaning
of the vector or geometric object.

### Using Lookup Tables in Vertex Shaders — indexed-text

Shows how tables can replace repeated or expensive computation in vertex
programs, including indexed/relative access and interpolation of precomputed
quantities.

**Current-work connection:** relevant to RoPE/Givens coefficient generation.
A sine/cosine table, recurrence, or on-the-fly transcendental is a target
realization of the same rotation coefficients. Preserve that separation so
precision and reuse can be chosen deliberately.

### Terrain Geomorphing in the Vertex Shader — TOC-guided

Moves level-of-detail transition work into vertex processing so neighboring
terrain resolutions can blend without obvious popping.

### 3D Planets on the GPU — TOC-guided

Builds large planetary geometry/appearance from compact procedural and
level-of-detail representations rather than one exhaustive mesh.

### Cloth Animation with Pixel and Vertex Shader — TOC-guided

Uses GPU stages to update and render a deformable surface, turning cloth state
into a repeated numerical update followed by geometric reconstruction.

**Current-work connection:** iterative state is the semantic object; whether an
old target stores it in textures and iterates via passes is a lowering choice.

### Collision Shaders — TOC-guided

Moves selected collision/distance-style computations into shader execution to
exploit parallel evaluation.

### Displacement Mapping — TOC-guided

Uses texture- or function-driven displacement to create geometric detail while
controlling how much geometry must actually be stored.

## II. Rendering

### Rendering Objects as Thick Volumes — TOC-guided

Represents geometry with an apparent thickness/volume rather than a single
infinitesimal surface, using shader evaluation to recover the final appearance.

### Screen-Aligned Particles with Minimal VertexBuffer Locking — TOC-guided

Organizes billboard particles to minimize CPU/GPU synchronization and repeated
buffer updates.

**Current-work connection:** performance can be dominated by synchronization
and data movement rather than arithmetic count; benchmark the emitted/runtime
path.

### Hemisphere Lighting with Radiosity Maps — TOC-guided

Combines hemispherical lighting with precomputed radiosity-like information to
approximate richer indirect illumination at interactive rates.

### Galaxy Textures — TOC-guided

Builds galaxy-like structure procedurally/from layered texture operations.

### Turbulent Sun — TOC-guided

Uses procedural/noise-driven shader effects to create an animated turbulent
solar surface.

### Fragment-Level Phong Illumination — TOC-guided

Evaluates the Phong lighting relation per fragment instead of relying on
vertex-level interpolation of the final lighting result.

### Specular Bump Mapping on Pre-ps_1_4 Hardware — TOC-guided

Reformulates specular bump mapping around the restrictions of an older pixel
shader target.

**Current-work connection:** useful historical evidence that target workarounds
change. They should not become permanent source-language structure.

### Voxel Rendering with PS_3_0 — TOC-guided

Uses newer pixel-shader flow-control/sampling capability to traverse or sample a
voxel representation in the fragment stage.

**Current-work connection:** traversal is a bounded/structured computation.
Keeping the traversal visible allows different targets to choose looping,
unrolling, subgroup work, or specialized texture access.

### Simulating Blending Operations on Floating-Point Render Targets — TOC-guided

Implements blend-like operations explicitly in shaders where fixed-function
hardware support for floating-point targets is missing or limited.

### Rendering Volumes in a Vertex & Pixel Program by Ray Tracing — TOC-guided

Casts/sample rays through a volume using programmable vertex/pixel work rather
than a conventional triangle-surface renderer.

**Current-work connection:** sample count, termination and integration are
bounded-loop/reduction structures worth representing directly.

### Normal Map Compression — TOC-guided

Encodes surface-normal data more compactly and reconstructs the normal in the
shader, trading bandwidth/storage against ALU and reconstruction error.

### Drops of Water and Texture Sprites — TOC-guided

Combines sprite/texture representations with shader distortion and lighting to
render many small water-drop effects cheaply.

### Advanced Water Effects — TOC-guided

Layers geometric motion, normals, reflection/refraction and view-dependent
terms into a richer water renderer.

### Efficient Evaluation of Irradiance Environment Maps — TOC-guided

Rearranges diffuse environment-light integration into a compact representation
that is cheap to evaluate repeatedly.

### Practical Precomputed Radiance Transfer — TOC-guided

Moves expensive light-transport work into precomputed coefficients so runtime
rendering becomes evaluation of a smaller basis/transfer representation.

### Advanced Sky Dome Rendering — TOC-guided

Combines view/atmospheric parameters and shader evaluation to render a dynamic
sky representation.

### Deferred Shading with Multiple Render Targets — TOC-guided

Stores geometry/material attributes first and performs lighting later from
screen-space buffers, exposing reuse across many lights.

**Current-work connection:** a good example of intentional stage factoring:
preserve the reusable intermediate object, then choose whether later passes can
be fused without changing semantics.

### Meshuggah's Effects Explained — TOC-guided

Breaks down a set of production effects from the Meshuggah demo into their
shader/rendering components.

### Layered Car Paint Shader — TOC-guided

Models car paint as multiple optical layers rather than one flat reflectance
function, combining base color and view-dependent reflective terms.

### Motion Blur Using Geometry and Shading Distortion — TOC-guided

Approximates motion integration by combining geometric and image/shader
distortion rather than fully sampling continuous exposure.

### Simulation of Iridescence and Translucency on Thin Surfaces — TOC-guided

Approximates wavelength/view/thickness-dependent appearance of thin materials.

### Floating-Point Cube Maps — TOC-guided

Uses higher-dynamic-range cube-map storage for directional data where ordinary
fixed-point formats lose useful range/precision.

**Current-work connection:** another reason to name storage width separately
from computation/accumulation width.

### Stereoscopic Rendering in Hardware Using Shaders — TOC-guided

Uses programmable transforms and rendering passes to construct left/right eye
views and stereo presentation.

### Hatching, Stroke Styles, and Pointillism — TOC-guided

Implements non-photorealistic mark-making styles through screen/object-space
shader patterns.

### Layered Fog — TOC-guided

Extends uniform fog to spatial layers with distinct density/height behavior.

### Dense Matrix Algebra on the GPU — indexed-text

Treats dense matrices as GPU-resident numerical objects and maps basic matrix
algebra onto the programmable graphics pipeline, using texture/render-target
representations and parallel element/row/column work.

**Current-work connection:** this is one of the most important chapters for the
backend. A matrix product, dot product, norm, reduction, triangular/orthogonal
update, or plane rotation has structure beyond its scalar multiply-adds.
Preserving that structure gives a later target a chance to choose packing,
reduction trees, coefficient reuse, tiling, or specialized operations instead
of trying to rediscover the algorithm from flattened code.

It also belongs next to the current Givens/RoPE question: a two-coordinate
rotation can be viewed as a tiny structured matrix operation whose pairing and
coefficient reuse may matter to target code generation.

## III. Software and Programming

### Software Vertex Shader Processing — TOC-guided

Examines a software implementation of the vertex-shader execution model and the
trade-offs involved when shader semantics are implemented on the CPU.

### x86 Shaders — ps_2_0 Shaders in Software — TOC-guided

Implements/emulates a pixel-shader model on x86, making the translation from
shader semantics to a very different execution target explicit.

**Current-work connection:** a useful compiler comparison: one source model can
have several backends, and target-specific register/SIMD decisions belong after
the common semantics.

### SoftD3D: Software-only Direct3D — TOC-guided

Describes a software implementation path for parts of the Direct3D rendering
pipeline, useful for understanding the contracts normally hidden behind GPU
hardware.

### Named Constants in Shader Development — TOC-guided

Preserves meaningful names for shader constants instead of treating parameters
only as anonymous physical registers.

**Current-work connection:** directly aligned with retaining semantic names and
typed interfaces through lowering rather than making register/layout choices
the programmer's model.

## IV. Image Space

### Advanced Image Processing with DirectX 9 Pixel Shaders — TOC-guided

Develops image operators as shader passes, including neighborhood/filter-style
computations enabled by programmable texture sampling.

### Night Vision — TOC-guided

Composes post-processing operations to mimic intensified low-light/night-vision
appearance.

### Non-Photorealistic Post-processing Filters in MotoGP 2 — TOC-guided

Applies stylization after scene rendering through image-space filters.

### Image Effects with DirectX 9 Pixel Shaders — TOC-guided

Collects general image-space effects implemented as reusable pixel-shader
operators.

### Mosaic Effect Using Character Glyphs — TOC-guided

Maps image blocks to glyph-like tiles according to local image properties.

### Mandelbrot Set Rendering — TOC-guided

Runs the escape-time recurrence independently per pixel to visualize the
Mandelbrot set.

**Current-work connection:** a clean bounded-iteration/divergence fixture.
The recurrence and stopping condition should remain explicit; a target can
choose fixed iterations, early exit, masks, or unrolling based on hardware.

### Real-Time Depth of Field Simulation — TOC-guided

Approximates lens blur in image space from scene depth and filtering rather than
performing full optical integration.

## V. Shadows

### Soft Shadows — TOC-guided

Uses filtered/multi-sample visibility to approximate area-light penumbrae.

### Robust Object ID Shadows — TOC-guided

Uses object identification/depth-like buffers to improve robustness of a
shadowing method in difficult overlap cases.

### Reverse Extruded Shadow Volumes — TOC-guided

Reformulates shadow-volume geometry/counting around a reverse extrusion scheme.

## VI. Engine and Tools

### Shader Abstraction — TOC-guided

Introduces an engine-side abstraction layer so effects can be expressed without
binding every use site directly to one shader model or assembly layout.

**Current-work connection:** one of the clearest conceptual matches to the
current work. The backend should preserve a stable semantic structure while GLSL
ES, PowerVR-specific code, Vulkan/Metal/WebGPU followers, or software oracles
choose distinct target realizations.

### Post-Process Fun with Effects Buffers — TOC-guided

Treats rendered images/depth/auxiliary buffers as reusable inputs to subsequent
effect passes.

### Shaders under Control (Codecreatures Engine) — TOC-guided

Describes production management of shaders, parameters, rendering states and
effect selection inside a game engine.

### Shader Integration in Gamebryo — TOC-guided

Shows how programmable effects fit into a larger reusable rendering engine and
asset/material system.

### Vertex Shader Compiler — TOC-guided

Discusses compiling a higher-level or structured vertex-shader description into
the instruction/resource constraints of a concrete shader target.

**Current-work connection:** directly relevant to the lowering-struggles
research: ask what information the compiler keeps long enough to schedule,
allocate and specialize well, and what becomes unrecoverable after an early
flattening.

### Shader Disassembler — TOC-guided

Works in the reverse direction, decoding low-level shader instructions into a
human-inspectable representation for debugging/analysis.

**Current-work connection:** useful for acceptance. Inspecting emitted GLSL or
machine-level shader form can reveal what a supposedly benign high-level
transformation actually caused the target compiler to execute.

## Highest-value chapters for current backend questions

1. **Dense Matrix Algebra on the GPU** — matrix/reduction/plane-transform
   structure and numerical representation.
2. **Using Lookup Tables in Vertex Shaders** — coefficient generation,
   precomputation and reuse.
3. **Mandelbrot Set Rendering** — bounded loops and divergent early exit.
4. **Shader Abstraction** — semantic layer versus target representations.
5. **Vertex Shader Compiler** — structure preservation through lowering.
6. **Shader Disassembler** — inspect the generated target instead of trusting
   source-level intuition.
7. **Voxel/volume/ray-tracing chapters** — bounded traversal and early exit.
8. **Named Constants** — retaining semantic interfaces through compilation.
