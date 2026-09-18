# Agent instructions

Apply the shared evidence and acceptance guardrails in
`isomorphisms/ai-ci/AGENTS.md`. The rules below are specific to this compiler
backend. Read [`README.md`](README.md) before changing its supported subset or
acceptance boundary.

## Backend claims require backend output

Do not count a reference evaluator, CPU implementation, handwritten GLSL, mock,
fixture, or lookalike renderer as acceptance of this backend.

A compiler-path claim must start from ordinary checked source, pass through the
registered backend at the exact revision under review, and identify the emitted
shader. If rendering is claimed, the running renderer must actually select and
draw with that emitted shader. Successful emission or GLSL validation alone is
not live rendering evidence.

A fallback may be useful for comparison, but label it as a fallback; it cannot
make the named backend pass.

## Preserve the intentional refusal boundary

Do not make a failing example pass by silently translating recursion, closures,
heap-shaped data, unsupported effects, bad interfaces, mismatched widths, or
other rejected constructs into weaker semantics.

Do not remove or dilute negative fixtures merely to obtain green. Change an
accepted/rejected boundary only for an explicit semantic decision, then update
both positive and targeted negative evidence.

## Keep backend evidence levels distinct

A mathematical oracle agreeing, backend emission, shader syntax/link
validation, a live renderer selecting the shader, and execution on a named
physical GPU are separate claims. Evidence for one does not imply the next.
SwiftShader or another emulator renderer is not physical-GPU evidence.

Record the exact backend head and compiler/API revision that produced accepted
output. When a downstream app consumes generated shaders, retain enough
provenance to show which backend generated the asset and whether the app
actually selected it.

## Physical Android GPU targets

Before changing Android/GPU acceptance, inspect current `main` (or the active
integration branch), the packaged runner, current physical receipts, and Cat
Food's device notes. The historical `target/powervr-ge8322-gles` branch is not
the canonical integration base and must not be merged wholesale. Do not derive
hardware identity from a package or command name.

- The ARMv7 phone PowerVR gate is specifically a PowerVR/Imagination hardware
  gate. Its renderer identity must remain PowerVR/Imagination.
- The physical AArch64 tablet `TAB_P10` is an ARM Mali-G57 target. A successful
  tablet EGL/GLES acceptance must identify `GL_VENDOR: ARM` and
  `GL_RENDERER: Mali-G57`; do not require PowerVR/Imagination on that target.
- Keep target selection, ABI checks, package integrity, renderer identity,
  shader compile/link, framebuffer/readback, and timing as separate assertions.
  A package name such as `powervr-*` is historical/source lineage, not evidence
  of the physical tablet GPU vendor.
- Do not promote emulator, Mesa/llvmpipe, or another device's receipt to
  physical acceptance.
- The phone and tablet are runtime consumers, not build hosts. Build and package
  Android runners off-device; do not require compilers or repository builds on
  either physical Android target.
- Do not introduce ADB as a prerequisite for tablet runtime acceptance when the
  packaged executable can run directly under Termux; Cat Food records ADB setup
  as explicitly deferred on the tablet.
- Human-facing device commands that ask for pasted output must use the shared
  ANSI color convention while keeping machine-readable receipt fields plain.
