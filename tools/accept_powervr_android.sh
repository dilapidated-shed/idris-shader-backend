#!/system/bin/sh
set -eu

GETPROP=${GETPROP:-/system/bin/getprop}
TOYBOX=${TOYBOX:-/system/bin/toybox}
READLINK=${READLINK:-/system/bin/readlink}

fail() {
  echo "Android GLES packaged acceptance: $*" >&2
  exit 1
}

[ -x "$GETPROP" ] || fail "Android getprop not found; this package must run on Android"

if [ -x "$READLINK" ]; then
  SELF=$($READLINK -f "$0")
else
  SELF=$0
fi
ROOT=$(CDPATH= cd -- "$(dirname -- "$SELF")/.." && pwd)
cd "$ROOT"

RUNNER="$ROOT/libexec/powervr-primitives"
MANIFEST="$ROOT/share/powervr/manifest.sha256"
SOURCE_FILE="$ROOT/share/powervr/source-commit"
TARGET_FILE="$ROOT/share/powervr/package-target"
ABI_FILE="$ROOT/share/powervr/package-abi"
BLOBS_FILE="$ROOT/share/powervr/shader-blobs.txt"

for required in "$RUNNER" "$MANIFEST" "$SOURCE_FILE" "$TARGET_FILE" "$ABI_FILE" "$BLOBS_FILE"; do
  [ -f "$required" ] || fail "package is missing $required"
done
[ -x "$RUNNER" ] || fail "packaged runner is not executable"

sha256_check() {
  if [ -x "$TOYBOX" ]; then
    "$TOYBOX" sha256sum -c "$1"
  else
    sha256sum -c "$1"
  fi
}

grep_q() {
  if [ -x "$TOYBOX" ]; then
    "$TOYBOX" grep "$@"
  else
    grep "$@"
  fi
}

grep_count() {
  if [ -x "$TOYBOX" ]; then
    "$TOYBOX" grep -Ec "$1" "$2" || :
  else
    grep -Ec "$1" "$2" || :
  fi
}

sha256_check "$MANIFEST" >/dev/null || fail "package payload hash check failed"

SOURCE_COMMIT=$(cat "$SOURCE_FILE")
PACKAGE_TARGET=$(cat "$TARGET_FILE")
PACKAGE_ABI=$(cat "$ABI_FILE")
DEVICE_ABI=$($GETPROP ro.product.cpu.abi)
DEVICE_ABILIST=$($GETPROP ro.product.cpu.abilist)
DEVICE_SDK=$($GETPROP ro.build.version.sdk)

case "$PACKAGE_TARGET:$PACKAGE_ABI" in
  phone:armeabi-v7a|tablet:arm64-v8a) ;;
  *) fail "invalid packaged target/ABI: $PACKAGE_TARGET / $PACKAGE_ABI" ;;
esac
[ "$DEVICE_ABI" = "$PACKAGE_ABI" ] || \
  fail "package ABI $PACKAGE_ABI does not match device ABI $DEVICE_ABI"
case "$DEVICE_SDK" in
  ''|*[!0-9]*) fail "device reported an invalid Android API: $DEVICE_SDK" ;;
esac

EVIDENCE=${POWERVR_EVIDENCE:-"${CATFOOD_ROOT:-$HOME/opt}/receipts/powervr-${PACKAGE_TARGET}-acceptance.txt"}
mkdir -p "$(dirname -- "$EVIDENCE")"
TMPBASE=${TMPDIR:-$ROOT}
RUN_TMP="$TMPBASE/powervr-run.$$.txt"
RECEIPT_TMP="$TMPBASE/powervr-receipt.$$.txt"
cleanup() {
  rm -f "$RUN_TMP" "$RECEIPT_TMP"
}
trap cleanup EXIT HUP INT TERM

if "$RUNNER" >"$RUN_TMP" 2>&1; then
  STATUS=0
else
  STATUS=$?
fi

{
  echo "idris-shader-backend Android GLES acceptance"
  echo "command: powervr-accept"
  echo "execution: prebuilt Cat Food Android package"
  echo "utc: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  echo "commit: $SOURCE_COMMIT"
  echo "package.target: $PACKAGE_TARGET"
  echo "package.abi: $PACKAGE_ABI"
  echo "package.payload: sha256 manifest PASS"
  echo "source.generated: packaged shader blobs bound to commit"
  echo "source.regeneration: exact-head GitHub CI evidence required separately"
  echo "device.manufacturer: $($GETPROP ro.product.manufacturer)"
  echo "device.model: $($GETPROP ro.product.model)"
  echo "device.android: $($GETPROP ro.build.version.release)"
  echo "device.sdk: $DEVICE_SDK"
  echo "device.abi: $DEVICE_ABI"
  echo "device.abilist: $DEVICE_ABILIST"
  echo "runner.exit: $STATUS"
  cat "$BLOBS_FILE"
  echo
  cat "$RUN_TMP"
} >"$RECEIPT_TMP"

cp "$RECEIPT_TMP" "$EVIDENCE"

if [ "$STATUS" -ne 0 ]; then
  cat "$EVIDENCE"
  fail "runner failed with status $STATUS; evidence saved to $EVIDENCE"
fi

for identity in '^EGL [0-9]+\.[0-9]+$' '^GL_VENDOR: .+' '^GL_RENDERER: .+' \
                '^GL_VERSION: .+' '^GLSL: .+'; do
  grep_q -Eq "$identity" "$RECEIPT_TMP" >/dev/null || {
    cat "$EVIDENCE"
    fail "incomplete EGL/GLES identity; evidence saved to $EVIDENCE"
  }
done

case "$PACKAGE_TARGET" in
  phone)
    grep_q -Eiq '^GL_(VENDOR|RENDERER):.*(PowerVR|Imagination)' "$RECEIPT_TMP" >/dev/null || {
      cat "$EVIDENCE"
      fail "phone GL_VENDOR/GL_RENDERER does not identify PowerVR/Imagination; evidence saved to $EVIDENCE"
    }
    ;;
  tablet)
    grep_q -Eq '^GL_VENDOR: ARM$' "$RECEIPT_TMP" >/dev/null || {
      cat "$EVIDENCE"
      fail "tablet GL_VENDOR does not identify ARM; evidence saved to $EVIDENCE"
    }
    grep_q -Eq '^GL_RENDERER: Mali-G57([[:space:]].*)?$' "$RECEIPT_TMP" >/dev/null || {
      cat "$EVIDENCE"
      fail "tablet GL_RENDERER does not identify Mali-G57; evidence saved to $EVIDENCE"
    }
    ;;
esac

COMPILE_LINK_COUNT=$(grep_count '^[1-6] shader_compile_link: PASS' "$RECEIPT_TMP")
[ "$COMPILE_LINK_COUNT" -eq 6 ] || {
  cat "$EVIDENCE"
  fail "expected six shader compile/link PASS lines, found $COMPILE_LINK_COUNT; evidence saved to $EVIDENCE"
}

FRAMEBUFFER_PATTERN='^(1 set_pixel_3_to_rgb_52_39_182|2 set_block_32x32_to_rgb_52_39_182|3 dot_vector4_covector4|4 dot_vector32_covector32|5 subtract_vector8_norm|6 rotate_difference8_to_e1): PASS( \(|$)'
PASS_COUNT=$(grep_count "$FRAMEBUFFER_PATTERN" "$RECEIPT_TMP")
[ "$PASS_COUNT" -eq 6 ] || {
  cat "$EVIDENCE"
  fail "expected six framebuffer PASS lines, found $PASS_COUNT; evidence saved to $EVIDENCE"
}

TIMING_COUNT=$(grep_count '^  (4x1 pixel-selection draw:|32x32 block-fill draw:|block/pixel ratio:)' "$RECEIPT_TMP")
[ "$TIMING_COUNT" -eq 3 ] || {
  cat "$EVIDENCE"
  fail "expected the complete three-line timing block, found $TIMING_COUNT lines; evidence saved to $EVIDENCE"
}

printf '\nacceptance.generated_blobs: PASS\nacceptance.renderer: PASS\nacceptance.compile_link: 6/6 PASS\nacceptance.framebuffers: 6/6 PASS\nacceptance: PASS\n' >>"$EVIDENCE"
cat "$EVIDENCE"
printf '\nAndroid GLES packaged acceptance: PASS\nevidence: %s\n' "$EVIDENCE"
