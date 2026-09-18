# PowerVR phone acceptance

PR #16's software acceptance is the six-probe GLES3/EGL harness under Mesa. The architecture-specific gate is the same six committed shader blobs compiled and executed by the real PowerVR phone driver.

## Device boundary

The phone and tablet are runtime targets, not build hosts. Neither device should clone this repository, install a compiler, run `make`, or build the C harness.

GitHub-hosted Ubuntu cross-compiles two Cat Food packages from the exact PR commit:

- `phone` / `armeabi-v7a`;
- `tablet` / `arm64-v8a`.

Each archive contains:

- a prebuilt Android `powervr-primitives` runner;
- the six exact committed GLSL fragments;
- their Git blob identities and SHA-256 payload manifest;
- the runtime-only `powervr-accept` command.

Cat Food downloads and verifies the target package. The device then does only the work that must occur on the device: verify the installed payload, execute EGL/GLES through the vendor driver, read the framebuffer results, and write the receipt.

The tablet package is a delivery follower for the same shader corpus. Physical tablet execution can satisfy only the tablet ARM/Mali-G57 gate; it cannot close the PowerVR-phone hardware gate.

## Run on the PowerVR phone

After Cat Food has installed the published `phone` package, run:

```sh
powervr-accept
```

There is no device-side build step. The command resolves its installed package, checks the packaged payload hashes, requires the package ABI to match the device ABI, and runs the prebuilt native harness against the packaged shader blobs.

The default receipt is:

```text
$HOME/opt/receipts/powervr-phone-acceptance.txt
```

A successful receipt ends with:

```text
acceptance.generated_blobs: PASS
acceptance.renderer: PASS
acceptance.compile_link: 6/6 PASS
acceptance.framebuffers: 6/6 PASS
acceptance: PASS
```

The receipt records the exact source commit carried by the package, package target and ABI, package-payload verification, non-unique device description, Android version/API/ABI, runner exit status, EGL/GLES/GLSL identity, `GL_VENDOR`, `GL_RENDERER`, all six shader compile/link verdicts, all six framebuffer readback verdicts, and the 4096-draw timing block.

The framebuffer lines are `glReadPixels` acceptance results, not screenshots. The timing numbers include driver submission and GPU completion exactly as the native harness reports them; they are characterization evidence, not USC cycle counts, and there is no performance threshold.

## Evidence separation

Shader generation and physical execution remain separate evidence stages:

1. exact-head GitHub CI regenerates the tracked PowerVR shader fragments, rejects any difference, and proves that the software harness works under Mesa;
2. the Ubuntu Android packaging job binds the two prebuilt runner packages and the six shader blobs to that exact commit;
3. Cat Food proves download/package identity and installation for the selected Android target;
4. only the unchanged receipt from the real PowerVR phone proves physical vendor-driver execution.

Mesa/llvmpipe, SwiftShader, `glslangValidator`, package installation, tablet execution, or a screenshot cannot be promoted into PowerVR phone evidence.

The hardware gate closes only when one unchanged receipt from the real phone contains:

- the current PR HEAD commit;
- `package.payload: sha256 manifest PASS` and `runner.exit: 0`;
- non-empty EGL, GLES, GLSL, `GL_VENDOR`, and `GL_RENDERER` identity;
- `GL_VENDOR` or `GL_RENDERER` naming PowerVR or Imagination;
- six numbered `shader_compile_link: PASS` lines;
- the six numbered framebuffer `PASS` lines for pixel selection, 32x32 fill, dot4, dot32, subtract8/norm, and rotation-to-e1;
- all three 4096-draw timing lines;
- the final five-line acceptance block above.

The existing ADB-host script remains a developer alternative for a machine that already has an Android NDK. It is not the normal Cat Food path and is not a reason to put build tools on the phone or tablet.
