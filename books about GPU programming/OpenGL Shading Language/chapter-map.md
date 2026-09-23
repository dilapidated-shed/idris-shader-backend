# OpenGL Shading Language, 3rd ed. — chapter map

Randi J. Rost and contributors.

Publisher contents:

https://www.informit.com/store/opengl-shading-language-9780321637635

## Evidence level

Commercial book. The publisher exposes the complete chapter table of contents
and selected sample material, not a public full-text edition. These are
**metadata-based orientation notes**.

## 1. Review of OpenGL Basics

Reviews the state machine, framebuffer, geometry/image drawing, transforms,
textures and pipeline context within which GLSL programs execute.

**Current-work connection:** useful for keeping host API state distinct from
shader-language semantics.

## 2. Basics

Introduces programmable processors, the role of the shading language and the
overall shader/program system.

## 3. Language Definition

Defines GLSL syntax, data types, operators, control flow and function semantics.

**Current-work connection:** target-language control flow is the *destination*
of lowering, not evidence that source control flow should already have been
flattened.

## 4. The OpenGL Programmable Pipeline

Connects shader stages into the complete programmable graphics pipeline.

**Current-work connection:** stage interfaces and interpolation/storage classes
are semantic target contracts worth representing explicitly in the backend.

## 5. Built-in Functions

Catalogs the standard mathematical/geometric/common/texture built-ins exposed
by GLSL.

**Current-work connection:** when a semantic operation maps to a target built-in
(`sin`, `cos`, normalize, texture filtering), preserve enough structure to
select it rather than expanding it needlessly.

## 6. Simple Shading Example

Builds a complete small shader example to show how the language pieces interact.

## 7. OpenGL Shading Language API

Covers creation, compilation, linking, activation and application-side
parameter/interface handling.

**Current-work connection:** emission, validation/linking and runtime selection
are separate evidence stages in this repository.

## 8. Shader Development

Discusses practical authoring/debugging/performance workflow.

**Current-work connection:** inspect generated target and failures rather than
treating source generation as completion.

## 9. Emulating OpenGL Fixed Functionality

Shows how old fixed-function transformations/lighting can be reconstructed with
programmable shaders.

**Current-work connection:** a representation can emulate an older abstraction
without making that implementation the new definition of the abstraction.

## 10. Stored Texture Shaders

Uses sampled/stored texture data as the basis for richer surface effects.

## 11. Procedural Texture Shaders

Computes texture-like appearance procedurally instead of reading a precomputed
image.

**Current-work connection:** procedural functions are deterministic numerical
operators that can have independent oracles and precision policies.

## 12. Lighting

Implements lighting models in GLSL.

## 13. Shadows

Covers programmable shadow techniques and their interaction with the rendering
pipeline.

## 14. Surface Characteristics

Builds material/surface appearance from shader computations and sampled data.

## 15. Noise

Develops procedural noise functions/effects.

**Current-work connection:** useful primitive-testing case: mathematical/statistical
properties should be checked separately from visual resemblance.

## 16. Animation

Uses shader computation for animated geometry/appearance.

## 17. Antialiasing Procedural Textures

Controls sampling/filtering artifacts in procedurally generated patterns.

**Current-work connection:** derivative/filter-width structure may deserve to
remain explicit until target built-ins/hardware filtering are chosen.

## 18. Non-photorealistic Shaders

Implements stylized rendering rather than physically based appearance.

## 19. Shaders for Imaging

Uses GLSL as an image-processing language.

**Current-work connection:** reinforces the shader backend's numerical/image
processing role beyond ordinary material rendering.

## 20. Language Comparison

Compares GLSL with other contemporary shading-language models.

**Current-work connection:** useful antidote to treating GLSL's particular
surface syntax or execution constraints as the permanent Idriç semantic model.

## Highest-value chapters for current work

- **3–5** — exact target language/control-flow/built-in semantics.
- **4 and 7** — shader-stage interfaces and host/link/runtime boundaries.
- **17** — filtering/derivative structure.
- **19** — shaders as general image/numerical operators.
- **20** — one semantics can admit several target language formulations.
