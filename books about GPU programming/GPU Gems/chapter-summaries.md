# GPU Gems — chapter-by-chapter notes

NVIDIA/Addison-Wesley, 2004.

NVIDIA hosts the complete book online:

https://developer.nvidia.com/gpugems/gpugems/foreword

Copyright on the hosted edition remains all-rights-reserved, so this repository
links to the text and records original summaries rather than mirroring it.

These summaries use NVIDIA's live chapter/part text and are read against
[the current repository problem lens](../problem-lens.md).

## Part I — Natural Effects

Official part page:

https://developer.nvidia.com/gpugems/gpugems/part-i-natural-effects

### 1. Effective Water Simulation from Physical Models

Builds an animated water surface from physically motivated wave models and then
adds lighting/reflection techniques that make the approximation useful in real
time.

**Current-work connection:** the wave model is the semantic object; mesh,
texture and shader realizations are target choices. Preserve that factorization
rather than collapsing it into one generated expression.

### 2. Rendering Water Caustics

Extends water simulation into the changing light patterns produced when a
moving surface refracts/focuses light onto objects below it.

**Current-work connection:** this is a staged numerical pipeline with shared
surface state. Reusing intermediate quantities is structurally meaningful.

### 3. Skin in the "Dawn" Demo

Explains the shading choices used to make the Dawn character's skin convincing,
including the approximations and content decisions needed for then-current
hardware.

**Current-work connection:** a good reminder that a visually useful material
model is not identical to one hardware encoding of it.

### 4. Animation in the "Dawn" Demo

Describes the blend-shape/facial and character-animation path behind Dawn and
the trade-offs needed to make artist-controlled deformation real time.

**Current-work connection:** weighted combinations of shapes are structured
linear operations. A compiler should not lose the distinction between the
deformation model and its packed target representation.

### 5. Implementing Improved Perlin Noise

Ken Perlin presents the improved noise construction and an efficient
programmable-GPU implementation that fixes artifacts of the earlier noise
formulation.

**Current-work connection:** this is a useful primitive-oracle case. A shader
implementation should be tested against the mathematical construction and its
continuity/invariance properties, not merely by visual plausibility.

### 6. Fire in the "Vulcan" Demo

Constructs convincing fire from a practical particle/rendering approximation
rather than a full fluid simulation, with attention to the cost of rendering
large particle populations.

**Current-work connection:** explicit approximation boundaries matter. The
backend should not introduce such approximations accidentally through lowering.

### 7. Rendering Countless Blades of Waving Grass

Organizes and animates large grass fields so the GPU handles huge numbers of
similar elements without overwhelming CPU submission/content costs.

**Current-work connection:** instancing/repetition is structure worth retaining;
manual duplication is not the same thing as a bounded repeated computation.

### 8. Simulating Diffraction

Simplifies a physically based diffraction-lighting model so microscopic groove
patterns can produce real-time interference colors.

**Current-work connection:** another example where mathematical structure is
kept while the target uses an approximation with a declared domain/error.

## Part II — Lighting and Shadows

Official part page:

https://developer.nvidia.com/gpugems/gpugems/part-ii-lighting-and-shadows

### 9. Efficient Shadow Volume Rendering

Makes stencil shadow volumes robust and practical, especially around geometric
corner cases and the geometry/fill-rate costs that make naïve implementations
slow.

**Current-work connection:** correctness comes from geometric/counting
invariants. A lower-level instruction sequence is acceptable only if those
invariants remain true.

### 10. Cinematic Lighting

Adapts a flexible production-style "uberlight" into a real-time shader so
artists retain control over a richer lighting model rather than being limited
to one fixed function.

**Current-work connection:** preserving named parameters and compositional
lighting structure resembles the backend's typed interface goal.

### 11. Shadow Map Antialiasing

Uses percentage-closer filtering to reduce aliasing in shadow maps by filtering
visibility comparisons rather than simply filtering stored depths as colors.

**Current-work connection:** the operation is a structured neighborhood
sampling/reduction, not just an arbitrary list of texture reads.

### 12. Omnidirectional Shadow Mapping

Extends shadow mapping to point lights by representing visibility in all
directions and discusses implementation alternatives for differing hardware.

**Current-work connection:** the semantic requirement is omnidirectional
visibility; cube-map/pass layout is target-specific.

### 13. Generating Soft Shadows Using Occlusion Interval Maps

Precomputes/encodes occlusion information so moving lights along known paths can
produce plausible area-light soft shadows efficiently.

**Current-work connection:** precomputation can move expensive work out of an
inner shader only if the precomputed object's semantics remain explicit.

### 14. Perspective Shadow Maps: Care and Feeding

Transforms the shadow-map parameterization to devote more sampling density to
regions that occupy more screen space, reducing perspective aliasing.

**Current-work connection:** layout/parameterization transformations are
valuable target optimizations, but they should remain distinct from the
underlying visibility function.

### 15. Managing Visibility for Per-Pixel Lighting

Uses visibility/culling to reduce both CPU submission and GPU lighting work,
especially the number of batches sent for per-pixel lights.

**Current-work connection:** avoiding execution is the algorithm. An eager
lowering that computes a "culled" branch anyway would erase the performance
meaning just as with the current `RSelect` problem.

## Part III — Materials

Official part page:

https://developer.nvidia.com/gpugems/gpugems/part-iii-materials

### 16. Real-Time Approximations to Subsurface Scattering

Presents several real-time approximations for translucent materials such as skin
and marble, replacing expensive full light transport with GPU-friendly
representations.

**Current-work connection:** approximation choice belongs at a named semantic
boundary with an oracle, not as an undocumented target rewrite.

### 17. Ambient Occlusion

Combines preprocessed occlusion information about an object/environment with a
cheap real-time shader to improve low-frequency shadowing.

**Current-work connection:** clearly separates expensive preparation from
repeated application—similar to separating rotation-coefficient generation from
the application of many rotations.

### 18. Spatial BRDFs

Stores multiple spatially varying reflectance functions in textures and
evaluates them under local/environmental lighting.

**Current-work connection:** texture layout is an implementation of a BRDF
field, not the BRDF's mathematical identity.

### 19. Image-Based Lighting

Uses images/environment representations as illumination data, including local
environment maps and the reflectance/shadow/diffuse terms needed to make them
coherent with ordinary shading.

**Current-work connection:** illustrates composition of semantically distinct
terms that a later target may fuse but should not reorder indiscriminately.

### 20. Texture Bombing

Reduces obvious texture repetition by combining many small texture elements
procedurally and develops related cellular/Voronoi-style shader constructions.

**Current-work connection:** procedural placement and neighborhood/cell
structure are useful algorithmic objects; flattening them early loses possible
target implementations.

## Part IV — Image Processing

Official part page:

https://developer.nvidia.com/gpugems/gpugems/part-iv-image-processing

### 21. Real-Time Glow

Builds glow/bloom from image-space extraction, filtering and recombination so a
small post-process pipeline changes the visual character of a rendered scene.

**Current-work connection:** passes have semantic roles and shared intermediate
images; fusion should preserve those roles.

### 22. Color Controls

Implements artistic/technical color transformations, including movement between
color spaces and real-time tuning of rendered/video imagery.

**Current-work connection:** transformations may compose algebraically, but
color-space order matters; "fusable" does not automatically mean reorderable.

### 23. Depth of Field: A Survey of Techniques

Surveys GPU approximations to camera depth of field and the filtering rules that
produce plausible focus/blur from rendered depth.

**Current-work connection:** a useful catalog of approximation/error boundaries
rather than one universal lowering.

### 24. High-Quality Filtering

Develops filter kernels and analytic reconstruction/antialiasing methods for 2D
and 3D data, exploiting hardware interpolation/filtering where appropriate.

**Current-work connection:** this is another strong structure-preservation
example. Separable kernels, weights and neighborhood reductions should stay
visible long enough to map onto target filtering primitives.

### 25. Fast Filter-Width Estimates with Texture Maps

Uses texture operations to estimate local partial derivatives/filter widths on
hardware that does not directly expose the required derivative operation.

**Current-work connection:** a target workaround can implement a higher-level
quantity without redefining that quantity. Keep derivative/filter-width
semantics above the workaround.

### 26. The OpenEXR Image File Format

Explains OpenEXR's high-dynamic-range representation and how GPU acceleration
can make HDR image acquisition, compositing and playback interactive.

**Current-work connection:** storage precision/range is separate from arithmetic
precision—exactly the distinction needed for F16/F32 accumulation/transcendentals.

### 27. A Framework for Image Processing

Organizes reusable image operations so GPU and CPU stages can be mixed behind a
common framework rather than hand-wiring every effect.

**Current-work connection:** a strong architectural analogue for maintaining
semantic operators above multiple backends.

## Part V — Performance and Practicalities

Official part page:

https://developer.nvidia.com/gpugems/gpugems/part-v-performance-and-practicalities

### 28. Graphics Pipeline Performance

Teaches bottleneck diagnosis across the graphics pipeline and proposes remedies
only after identifying which stage is actually limiting throughput.

**Current-work connection:** inspect emitted/runtime evidence. Source-level
instruction counting is not a substitute for physical PowerVR/Mali measurement.

### 29. Efficient Occlusion Culling

Explains why synchronous use of occlusion queries can destroy performance and
shows how to use asynchronous results without stalling the CPU/GPU pipeline.

**Current-work connection:** control dependency and synchronization cost are
part of the execution schedule; a nominally cheap predicate can be expensive.

### 30. The Design of FX Composer

Describes the architecture of a shader-authoring IDE that connects source,
parameters, render state and live visual output.

**Current-work connection:** reinforces maintaining provenance from source
through generated artifact to observed execution.

### 31. Using FX Composer

Shows the practical workflow of authoring, binding and testing shader effects in
FX Composer.

### 32. An Introduction to Shader Interfaces

Represents shader fragments as objects with well-defined interfaces that can be
composed automatically at runtime.

**Current-work connection:** one of the strongest chapters for the current
compiler. It argues for preserving typed compositional boundaries and only then
assembling a target program—exactly the opposite of prematurely flattening
conditionals, loops, or mathematical operators.

### 33. Converting Production RenderMan Shaders to Real-Time

Takes CPU/offline-oriented shading programs and rethinks them for GPU execution
rather than transliterating them mechanically.

**Current-work connection:** source semantics and target schedule must be
separate. Backend design should preserve meaning while allowing substantial
target-specific restructuring.

### 34. Integrating Hardware Shading into Cinema 4D

Adds GPU shading to an established CPU-based content/rendering system while
trying to preserve the existing workflow and visual semantics.

**Current-work connection:** useful evidence for multi-backend equivalence and
for treating the CPU/oracle path as a reference rather than a substitute.

### 35. Leveraging High-Quality Software Rendering Effects in Real-Time Applications

Combines mature software-rendering capabilities with GPU acceleration instead
of forcing all effects into the GPU merely because it is available.

**Current-work connection:** a stage should move only when the target execution
actually benefits and semantic/evidence boundaries remain clear.

### 36. Integrating Shaders into Applications

Uses effect files, semantics, annotations and inheritance-like organization to
connect shader code to application-side parameters and state.

**Current-work connection:** semantic names/interfaces are valuable information
that should survive compilation rather than becoming anonymous target slots too
early.

## Part VI — Beyond Triangles

Official part page:

https://developer.nvidia.com/gpugems/gpugems/part-vi-beyond-triangles

### 37. A Toolkit for Computation on GPUs

Builds a vocabulary of general GPU-computing primitives—arrays/streams,
mapping, searching/sorting and related operations—using the graphics pipeline
as the available compute substrate.

**Current-work connection:** historically important because it distinguishes
*computational objects* from the graphics mechanisms used to realize them.
That is the right direction for the current backend: preserve the operation,
then map it to GLSL/PowerVR/Mali/compute followers.

### 38. Fast Fluid Dynamics Simulation on the GPU

Maps a physically based fluid solver onto GPU passes so the complete simulation
state stays on the device and repeated numerical steps run in parallel.

**Current-work connection:** the solver contains explicit stencil operations,
iterations and boundary handling. Those structures are better IR candidates
than a flattened list of scalar shader statements.

### 39. Volume Rendering Techniques

Surveys GPU volume-rendering algorithms: representations, sampling/compositing,
transfer functions and the practical trade-offs needed to render volumetric
data interactively.

**Current-work connection:** ray/sample accumulation is a bounded
iteration/reduction; target-specific texture layout should remain downstream of
that semantic structure.

### 40. Applying Real-Time Shading to 3D Ultrasound Visualization

Applies volume-rendering/shading methods to real ultrasound data, emphasizing
practical medical-data constraints rather than synthetic graphics alone.

**Current-work connection:** useful reminder that numerical/visual acceptance
may require domain-specific invariants, not just a pretty framebuffer.

### 41. Real-Time Stereograms

Generates dynamic single-image random-dot stereograms on the GPU, using the
displayed depth relation to place/match patterns that the visual system
interprets stereoscopically.

### 42. Deformers

Unifies several geometric deformation operations and derives transformed vertex
normals from the deformation Jacobian instead of finite-difference estimates.

**Current-work connection:** especially relevant to the user's existing
Jacobian/Givens interests. This is a concrete case where retaining a
mathematical derivative/Jacobian structure yields a cleaner, more accurate
target computation than destroying it and reconstructing derivatives
numerically afterward.

## Highest-value chapters for current backend questions

- **15** — work avoidance/visibility, analogous to preserving real branches.
- **24–25** — filters/derivatives as semantic operators above target tricks.
- **28–29** — physical pipeline evidence and synchronization.
- **32–36** — shader interfaces, composition and multi-backend integration.
- **37** — explicit GPGPU primitives above graphics-pipeline representation.
- **38–39** — bounded iteration, stencil/sampling and reductions.
- **42** — Jacobians preserved as mathematical structure instead of recovered
  after lowering.
