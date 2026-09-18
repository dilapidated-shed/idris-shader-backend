# Agent instructions

Apply the shared evidence, device, and human-facing terminal guardrails in
`isomorphisms/ai-ci/AGENTS.md`.

Before changing Android/GPU acceptance, inspect the active target branch,
packaged runner, current physical receipts, and Cat Food's device notes. Do not
derive hardware identity from a package or command name.

## Physical Android GPU targets

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
- Do not introduce ADB as a prerequisite for tablet runtime acceptance when the
  packaged executable can run directly under Termux; Cat Food records ADB setup
  as explicitly deferred on the tablet.
- Human-facing device commands that ask for pasted output must use the shared
  ANSI color convention while keeping machine-readable receipt fields plain.
