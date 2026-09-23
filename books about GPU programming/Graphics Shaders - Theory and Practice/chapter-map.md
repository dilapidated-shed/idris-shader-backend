# Graphics Shaders: Theory and Practice, 2nd ed. — chapter map

Mike Bailey and Steve Cunningham. CRC Press, 2012.

Publisher/author information:

https://www.routledge.com/Graphics-Shaders-Theory-and-Practice-Second-Edition/Bailey-Cunningham/p/book/9781568814346

https://web.engr.oregonstate.edu/~mjb/cgeducation/ShadersBookSecond/

## Evidence level

Commercial book. Public publisher/author pages expose a detailed contents list
and example material, but this repository has not established a redistribution
license for the book. These are **metadata-based orientation notes**.

## 1. The Fixed-Function Graphics Pipeline

Explains the traditional graphics pipeline, state and coordinate processing so
the programmable replacements have a precise reference point.

**Current-work connection:** an abstraction can remain meaningful even after its
implementation changes; do not mistake one target pipeline for source semantics.

## 2. OpenGL Shader Evolution

Tracks the transition from older OpenGL shader capabilities toward newer GLSL,
including OpenGL ES.

**Current-work connection:** target features evolve rapidly; source/IR should
not freeze one generation's restrictions into the language.

## 3. Fundamental Shader Concepts

Introduces vertex, fragment, tessellation and geometry stages plus the data that
moves among applications and shader stages.

**Current-work connection:** stage/interface structure should survive lowering
explicitly.

## 4. Using glman

Uses the authors' interactive shader environment to edit scenes, parameters and
shader source independently of a larger application.

**Current-work connection:** small reproducible shader fixtures are useful
acceptance artifacts; they do not substitute for physical-target evidence.

## 5. The GLSL Shader Language

Covers GLSL types, vectors/matrices, functions, operators, swizzles and language
details.

**Current-work connection:** vectors/matrices are semantic target objects; do
not automatically scalarize them before the target compiler can exploit them.

## 6. Lighting

Develops common lighting models and the coordinate/vector quantities they use.

## 7. Vertex Shaders

Covers vertex-stage inputs/outputs, geometric modification and normal handling.

**Current-work connection:** the treatment of normals/derived geometry is a
useful comparison with the Jacobian-based deformer material in *GPU Gems*.

## 8. Fragment Shaders and Surface Appearance

Covers fragment inputs/outputs, coordinate systems, discard, analytic normals
and data-driven coloring.

**Current-work connection:** discard/control flow is a real execution effect,
not just a value-level select.

## 9. Surface Textures in the Fragment Shader

Covers texture coordinates, samplers and render-to-texture/multipass use.

**Current-work connection:** texture storage is a target representation of
fields/arrays/intermediates, not their semantic identity.

## 10. Noise

Covers value/gradient noise, interpolation, FBM/turbulence and procedural
materials.

## 11. Image Manipulation with Shaders

Covers color conversion, filtering, blur, edge detection, warping, blending and
image transitions.

**Current-work connection:** neighborhood/filter/reduction structure should
remain visible enough for target-specific filtering or separable passes.

## 12. Geometry Shader Concepts and Examples

Covers geometry-stage input/output layouts, adjacency, normals, subdivision and
silhouette generation.

## 13. Tessellation Shaders

Introduces tessellation control/evaluation and adaptive surface subdivision.

**Current-work connection:** adaptive refinement belongs above one target's
tessellation-stage mechanism.

## 14. The GLSL API

Covers compile/link/activate and uniform/attribute exchange with the host.

**Current-work connection:** again separates emitted shader, successful link,
host binding and actual execution.

## 15. Using Shaders for Scientific Visualization

Applies shaders to scalar/vector fields, point clouds, volume rendering,
transfer functions, terrain and flow visualization.

**Current-work connection:** the strongest chapter for treating shaders as
numerical/scientific programs rather than only appearance code.

## 16. Serious Fun

Collects optical/procedural effects including diffraction, atmosphere, noise,
morphing and algorithmic art.

## Highest-value chapters for current work

- **5** — retain vector/matrix semantics into GLSL lowering.
- **8** — actual fragment control effects versus value selection.
- **9/11** — textures and image operators as target representations.
- **13** — structured adaptive refinement.
- **14** — compile/link/bind/run evidence boundaries.
- **15** — scientific/numerical shader applications.
