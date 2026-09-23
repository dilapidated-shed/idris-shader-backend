#!/bin/sh
set -eu

repo=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
tmp=$(mktemp -d)
cleanup() {
  rm -rf "$tmp"
}
trap cleanup EXIT HUP INT TERM

cat > "$tmp/getprop" <<'EOF_GETPROP'
#!/bin/sh
case "$1" in
  ro.product.cpu.abi) printf '%s\n' "$FAKE_DEVICE_ABI" ;;
  ro.product.cpu.abilist) printf '%s\n' "$FAKE_DEVICE_ABI" ;;
  ro.build.version.sdk) printf '%s\n' 35 ;;
  ro.build.version.release) printf '%s\n' 15 ;;
  ro.product.manufacturer) printf '%s\n' Test ;;
  ro.product.model) printf '%s\n' TestDevice ;;
  *) printf '\n' ;;
esac
EOF_GETPROP
chmod +x "$tmp/getprop"

stage_case() {
  target=$1
  root="$tmp/$target"
  rm -rf "$root"
  mkdir -p "$root/bin" "$root/libexec" "$root/share/powervr"

  cp "$repo/tools/accept_powervr_android.sh" "$root/bin/powervr-accept"
  chmod +x "$root/bin/powervr-accept"

  cat > "$root/libexec/powervr-primitives" <<'EOF_RUNNER'
#!/bin/sh
cat <<EOF_OUTPUT
EGL 1.5
GL_VENDOR: $FAKE_GL_VENDOR
GL_RENDERER: $FAKE_GL_RENDERER
GL_VERSION: OpenGL ES 3.2 test
GLSL: OpenGL ES GLSL ES 3.20
1 shader_compile_link: PASS (generated/one.frag)
2 shader_compile_link: PASS (generated/two.frag)
3 shader_compile_link: PASS (generated/three.frag)
4 shader_compile_link: PASS (generated/four.frag)
5 shader_compile_link: PASS (generated/five.frag)
6 shader_compile_link: PASS (generated/six.frag)
1 set_pixel_3_to_rgb_52_39_182: PASS
2 set_block_32x32_to_rgb_52_39_182: PASS
3 dot_vector4_covector4: PASS (0.4578)
4 dot_vector32_covector32: PASS (0.4731445)
5 subtract_vector8_norm: PASS (0.7031358)
6 rotate_difference8_to_e1: PASS
4096-draw wall-time probe:
  4x1 pixel-selection draw: 5.000 us/draw
  32x32 block-fill draw:    3.000 us/draw
  block/pixel ratio:         0.600x
EOF_OUTPUT
EOF_RUNNER
  chmod +x "$root/libexec/powervr-primitives"

  printf '%s\n' 0123456789abcdef > "$root/share/powervr/source-commit"
  printf '%s\n' "$target" > "$root/share/powervr/package-target"
  case "$target" in
    phone) printf '%s\n' armeabi-v7a > "$root/share/powervr/package-abi" ;;
    tablet) printf '%s\n' arm64-v8a > "$root/share/powervr/package-abi" ;;
    *) exit 2 ;;
  esac
  printf '%s\n' 'shader.blob: test generated/test.frag' > "$root/share/powervr/shader-blobs.txt"

  (
    cd "$root"
    sha256sum       bin/powervr-accept       libexec/powervr-primitives       share/powervr/source-commit       share/powervr/package-target       share/powervr/package-abi       share/powervr/shader-blobs.txt       > share/powervr/manifest.sha256
  )
}

run_case() {
  target=$1
  vendor=$2
  renderer=$3
  root="$tmp/$target"
  case "$target" in
    phone) abi=armeabi-v7a ;;
    tablet) abi=arm64-v8a ;;
  esac
  FAKE_DEVICE_ABI="$abi"   FAKE_GL_VENDOR="$vendor"   FAKE_GL_RENDERER="$renderer"   GETPROP="$tmp/getprop"   TOYBOX="$tmp/no-toybox"   READLINK="$(command -v readlink)"   POWERVR_EVIDENCE="$tmp/$target-evidence.txt"     sh "$root/bin/powervr-accept"
}

stage_case phone
stage_case tablet

run_case tablet ARM Mali-G57 >"$tmp/tablet-mali.log" 2>&1 || {
  cat "$tmp/tablet-mali.log" >&2
  printf '%s\n' 'tablet Mali-G57 should pass' >&2
  exit 1
}

if run_case tablet Imagination 'PowerVR Rogue GE8322' >"$tmp/tablet-powervr.log" 2>&1; then
  cat "$tmp/tablet-powervr.log" >&2
  printf '%s\n' 'tablet PowerVR identity should fail the Mali-G57 gate' >&2
  exit 1
fi

run_case phone Imagination 'PowerVR Rogue GE8322' >"$tmp/phone-powervr.log" 2>&1 || {
  cat "$tmp/phone-powervr.log" >&2
  printf '%s\n' 'phone PowerVR identity should pass' >&2
  exit 1
}

if run_case phone ARM Mali-G57 >"$tmp/phone-mali.log" 2>&1; then
  cat "$tmp/phone-mali.log" >&2
  printf '%s\n' 'phone Mali-G57 identity should fail the PowerVR gate' >&2
  exit 1
fi

printf '%s\n' 'Android GLES renderer target gates: PASS'
