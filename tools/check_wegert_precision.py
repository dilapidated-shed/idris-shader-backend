#!/usr/bin/env python3
"""Measure Wegert/holomorphic F16 and F32 output against a binary64 oracle.

This is a hosted arithmetic acceptance, not a physical-GPU receipt.  The F16
model rounds each named arithmetic stage to IEEE binary16.  GLSL ES mediump is
only a portable precision class, so device acceptance remains separate.
"""

from __future__ import annotations

import math
import shutil
import struct
import subprocess
import sys
import tempfile
from dataclasses import dataclass
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BACKEND = ROOT / "build" / "exec" / "idris2-glsles"
SOURCE = "src/Example/SharedFactorPortrait.idr"
DISPLAY_LSB_BUDGET = 1

STAGES = (
    "inputs",
    "rational_factors",
    "rational_sum",
    "holomorphic_q",
    "compose_measure",
    "color_bands",
    "hcl_to_linear",
    "srgb_transfer",
)


@dataclass(frozen=True)
class Case:
    name: str
    regions: tuple[str, ...]
    point: tuple[float, float]
    zeros: tuple[tuple[float, float], ...] = ()
    poles: tuple[tuple[float, float], ...] = ()
    # Ascending polynomial coefficients: q(z) = c0 + c1 z + ...
    q_coefficients: tuple[tuple[float, float], ...] = ()


CASES = (
    Case("ordinary", ("baseline",), (0.3, 0.4), zeros=((0.0, 0.0),)),
    Case(
        "near_zero",
        ("zero",),
        (2.0 ** -14, 0.0),
        zeros=((0.0, 0.0),),
    ),
    Case(
        "near_pole",
        ("pole",),
        (2.0 ** -14, 0.0),
        poles=((0.0, 0.0),),
    ),
    Case(
        "near_cancelling_divisor",
        ("cancellation",),
        (0.75, -0.375),
        zeros=((0.25, 0.125),),
        poles=((0.2501220703125, 0.1248779296875),),
    ),
    Case(
        "phase_wrap_above",
        ("phase_wrap",),
        (-1.0, 2.0 ** -11),
        zeros=((0.0, 0.0),),
    ),
    Case(
        "phase_wrap_below",
        ("phase_wrap",),
        (-1.0, -(2.0 ** -11)),
        zeros=((0.0, 0.0),),
    ),
    Case(
        "rational_dynamic_range",
        ("dynamic_range",),
        (0.0, 0.0),
        zeros=((2.0 ** -10, 0.0), (2.0 ** 10, 0.0)),
        poles=((1.0, 0.0),),
    ),
    Case(
        "holomorphic_cancellation",
        ("holomorphic", "cancellation"),
        (0.75, -0.5),
        zeros=((0.0, 0.0),),
        q_coefficients=((1.0, -0.5), (-2.0, 1.0), (1.0, -0.5)),
    ),
    Case(
        "holomorphic_dynamic_range",
        ("holomorphic", "dynamic_range"),
        (8.0, -4.0),
        zeros=((0.0, 0.0),),
        q_coefficients=((2.0 ** -8, 0.0), (0.5, -0.25), (4.0, 2.0)),
    ),
)


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def quantize(value: float, width: str) -> float:
    value = float(value)
    if width == "f64":
        return value
    format_code = "f" if width == "f32" else "e"
    try:
        return struct.unpack(format_code, struct.pack(format_code, value))[0]
    except OverflowError:
        return math.copysign(math.inf, value)


class Arithmetic:
    def __init__(self, width: str) -> None:
        self.width = width

    def q(self, value: float) -> float:
        return quantize(value, self.width)

    def add(self, left: float, right: float) -> float:
        return self.q(self.q(left) + self.q(right))

    def sub(self, left: float, right: float) -> float:
        return self.q(self.q(left) - self.q(right))

    def mul(self, left: float, right: float) -> float:
        return self.q(self.q(left) * self.q(right))

    def div(self, left: float, right: float) -> float:
        return self.q(self.q(left) / self.q(right))

    def maximum(self, left: float, right: float) -> float:
        return self.q(max(self.q(left), self.q(right)))

    def floor(self, value: float) -> float:
        return self.q(math.floor(self.q(value)))

    def log(self, value: float) -> float:
        return self.q(math.log(self.q(value)))

    def atan2(self, y_value: float, x_value: float) -> float:
        return self.q(math.atan2(self.q(y_value), self.q(x_value)))

    def hypot(self, x_value: float, y_value: float) -> float:
        return self.q(math.hypot(self.q(x_value), self.q(y_value)))

    def sin(self, value: float) -> float:
        return self.q(math.sin(self.q(value)))

    def cos(self, value: float) -> float:
        return self.q(math.cos(self.q(value)))

    def power(self, base: float, exponent: float) -> float:
        return self.q(math.pow(self.q(base), self.q(exponent)))

    def clamp01(self, value: float) -> float:
        return self.q(min(max(self.q(value), self.q(0.0)), self.q(1.0)))

    def positive_fract(self, value: float) -> float:
        return self.sub(value, self.floor(value))

    def complex_add(
        self,
        left: tuple[float, float],
        right: tuple[float, float],
    ) -> tuple[float, float]:
        return self.add(left[0], right[0]), self.add(left[1], right[1])

    def complex_mul(
        self,
        left: tuple[float, float],
        right: tuple[float, float],
    ) -> tuple[float, float]:
        left_real = self.q(left[0])
        left_imag = self.q(left[1])
        right_real = self.q(right[0])
        right_imag = self.q(right[1])
        return (
            self.sub(
                self.mul(left_real, right_real),
                self.mul(left_imag, right_imag),
            ),
            self.add(
                self.mul(left_real, right_imag),
                self.mul(left_imag, right_real),
            ),
        )


def cast_complex(value: tuple[float, float], width: str) -> tuple[float, float]:
    return quantize(value[0], width), quantize(value[1], width)


def factor_measure(
    point: tuple[float, float],
    factor: tuple[float, float],
    width: str,
) -> tuple[float, float]:
    arithmetic = Arithmetic(width)
    delta_real = arithmetic.sub(point[0], factor[0])
    delta_imag = arithmetic.sub(point[1], factor[1])
    phase = arithmetic.atan2(delta_imag, delta_real)
    magnitude = arithmetic.hypot(delta_real, delta_imag)
    log_modulus = arithmetic.log(arithmetic.maximum(magnitude, 1.0e-12))
    return phase, log_modulus


def all_widths(width: str) -> dict[str, str]:
    return {stage: width for stage in STAGES}


def prefix_f16_widths(last_f16_stage: str) -> dict[str, str]:
    widths = all_widths("f32")
    for stage in STAGES:
        widths[stage] = "f16"
        if stage == last_f16_stage:
            break
    return widths


def single_f16_widths(f16_stage: str) -> dict[str, str]:
    widths = all_widths("f32")
    widths[f16_stage] = "f16"
    return widths


def mixed_widths() -> dict[str, str]:
    widths = all_widths("f16")
    # Current measured candidate: retain width only where large phase/log values
    # are composed and reduced modulo the visible colour bands.
    widths["compose_measure"] = "f32"
    widths["color_bands"] = "f32"
    return widths


def evaluate(case: Case, widths: dict[str, str]) -> dict[str, object]:
    input_width = widths["inputs"]
    point = cast_complex(case.point, input_width)
    zeros = tuple(cast_complex(value, input_width) for value in case.zeros)
    poles = tuple(cast_complex(value, input_width) for value in case.poles)
    q_coefficients = tuple(
        cast_complex(value, input_width) for value in case.q_coefficients
    )

    factor_width = widths["rational_factors"]
    factor_point = cast_complex(point, factor_width)
    zero_measures = tuple(
        factor_measure(factor_point, cast_complex(value, factor_width), factor_width)
        for value in zeros
    )
    pole_measures = tuple(
        factor_measure(factor_point, cast_complex(value, factor_width), factor_width)
        for value in poles
    )

    sum_arithmetic = Arithmetic(widths["rational_sum"])
    zero_sum = (sum_arithmetic.q(0.0), sum_arithmetic.q(0.0))
    for phase, log_modulus in zero_measures:
        zero_sum = (
            sum_arithmetic.add(zero_sum[0], phase),
            sum_arithmetic.add(zero_sum[1], log_modulus),
        )
    pole_sum = (sum_arithmetic.q(0.0), sum_arithmetic.q(0.0))
    for phase, log_modulus in pole_measures:
        pole_sum = (
            sum_arithmetic.add(pole_sum[0], phase),
            sum_arithmetic.add(pole_sum[1], log_modulus),
        )
    rational_measure = (
        sum_arithmetic.sub(zero_sum[0], pole_sum[0]),
        sum_arithmetic.sub(zero_sum[1], pole_sum[1]),
    )

    q_arithmetic = Arithmetic(widths["holomorphic_q"])
    q_point = cast_complex(point, widths["holomorphic_q"])
    q_value = (q_arithmetic.q(0.0), q_arithmetic.q(0.0))
    for coefficient in reversed(q_coefficients):
        q_value = q_arithmetic.complex_add(
            q_arithmetic.complex_mul(q_value, q_point),
            cast_complex(coefficient, widths["holomorphic_q"]),
        )

    compose_arithmetic = Arithmetic(widths["compose_measure"])
    phase = compose_arithmetic.add(rational_measure[0], q_value[1])
    log_modulus = compose_arithmetic.add(rational_measure[1], q_value[0])

    band_arithmetic = Arithmetic(widths["color_bands"])
    tau = band_arithmetic.q(6.28318530717958647692)
    log_10 = band_arithmetic.q(2.30258509299404568402)
    hue_degrees = band_arithmetic.mul(
        360.0,
        band_arithmetic.positive_fract(band_arithmetic.div(phase, tau)),
    )
    log_modulus_band = band_arithmetic.positive_fract(
        band_arithmetic.div(log_modulus, log_10)
    )
    lightness = band_arithmetic.add(
        band_arithmetic.add(
            66.0,
            band_arithmetic.mul(4.0, log_modulus_band),
        ),
        band_arithmetic.mul(
            3.0,
            band_arithmetic.positive_fract(
                band_arithmetic.div(hue_degrees, 100.0)
            ),
        ),
    )
    chroma = band_arithmetic.q(45.0)

    linear_arithmetic = Arithmetic(widths["hcl_to_linear"])
    hue = linear_arithmetic.q(hue_degrees)
    linear_chroma = linear_arithmetic.q(chroma)
    linear_lightness = linear_arithmetic.q(lightness)
    hue_radians = linear_arithmetic.div(
        linear_arithmetic.mul(hue, math.pi),
        180.0,
    )
    u_star = linear_arithmetic.mul(
        linear_chroma,
        linear_arithmetic.cos(hue_radians),
    )
    v_star = linear_arithmetic.mul(
        linear_chroma,
        linear_arithmetic.sin(hue_radians),
    )
    white_u_prime = linear_arithmetic.q(0.19783982482140777)
    white_v_prime = linear_arithmetic.q(0.46833630293240974)
    if linear_lightness > linear_arithmetic.q(8.0):
        cie_y = linear_arithmetic.power(
            linear_arithmetic.div(
                linear_arithmetic.add(linear_lightness, 16.0),
                116.0,
            ),
            3.0,
        )
    else:
        cie_y = linear_arithmetic.div(linear_lightness, 903.2962962962963)
    u_prime = linear_arithmetic.add(
        linear_arithmetic.div(
            u_star,
            linear_arithmetic.mul(13.0, linear_lightness),
        ),
        white_u_prime,
    )
    v_prime = linear_arithmetic.add(
        linear_arithmetic.div(
            v_star,
            linear_arithmetic.mul(13.0, linear_lightness),
        ),
        white_v_prime,
    )
    cie_x = linear_arithmetic.div(
        linear_arithmetic.mul(
            linear_arithmetic.mul(9.0, cie_y),
            u_prime,
        ),
        linear_arithmetic.mul(4.0, v_prime),
    )
    cie_z = linear_arithmetic.div(
        linear_arithmetic.mul(
            cie_y,
            linear_arithmetic.sub(
                linear_arithmetic.sub(
                    12.0,
                    linear_arithmetic.mul(3.0, u_prime),
                ),
                linear_arithmetic.mul(20.0, v_prime),
            ),
        ),
        linear_arithmetic.mul(4.0, v_prime),
    )
    linear_red = linear_arithmetic.sub(
        linear_arithmetic.sub(
            linear_arithmetic.mul(3.2404542, cie_x),
            linear_arithmetic.mul(1.5371385, cie_y),
        ),
        linear_arithmetic.mul(0.4985314, cie_z),
    )
    linear_green = linear_arithmetic.add(
        linear_arithmetic.add(
            linear_arithmetic.mul(-0.9692660, cie_x),
            linear_arithmetic.mul(1.8760108, cie_y),
        ),
        linear_arithmetic.mul(0.0415560, cie_z),
    )
    linear_blue = linear_arithmetic.add(
        linear_arithmetic.add(
            linear_arithmetic.mul(0.0556434, cie_x),
            linear_arithmetic.mul(-0.2040259, cie_y),
        ),
        linear_arithmetic.mul(1.0572252, cie_z),
    )

    transfer_arithmetic = Arithmetic(widths["srgb_transfer"])

    def srgb_component(linear_value: float) -> float:
        value = transfer_arithmetic.maximum(linear_value, 0.0)
        if value <= transfer_arithmetic.q(0.0031308):
            return transfer_arithmetic.clamp01(
                transfer_arithmetic.mul(12.92, value)
            )
        return transfer_arithmetic.clamp01(
            transfer_arithmetic.sub(
                transfer_arithmetic.mul(
                    1.055,
                    transfer_arithmetic.power(
                        value,
                        transfer_arithmetic.div(1.0, 2.4),
                    ),
                ),
                0.055,
            )
        )

    rgb = tuple(
        srgb_component(value)
        for value in (linear_red, linear_green, linear_blue)
    )
    require(
        all(math.isfinite(value) for value in rgb),
        f"{case.name}: non-finite output for widths {widths}",
    )
    rgb8 = tuple(
        int(math.floor(min(max(value, 0.0), 1.0) * 255.0 + 0.5))
        for value in rgb
    )
    return {
        "rational_measure": rational_measure,
        "q": q_value,
        "composed_measure": (phase, log_modulus),
        "hcl": (hue_degrees, chroma, lightness),
        "linear_rgb": (linear_red, linear_green, linear_blue),
        "rgb": rgb,
        "rgb8": rgb8,
    }


def max_lsb_delta(
    actual: tuple[int, int, int],
    expected: tuple[int, int, int],
) -> int:
    return max(abs(left - right) for left, right in zip(actual, expected))


def first_material_prefix_stage(
    case: Case,
    reference_rgb8: tuple[int, int, int],
) -> str | None:
    for stage in STAGES:
        result = evaluate(case, prefix_f16_widths(stage))
        if max_lsb_delta(result["rgb8"], reference_rgb8) > DISPLAY_LSB_BUDGET:
            return stage
    return None


def material_single_stages(
    case: Case,
    reference_rgb8: tuple[int, int, int],
) -> tuple[str, ...]:
    material = []
    for stage in STAGES:
        result = evaluate(case, single_f16_widths(stage))
        if max_lsb_delta(result["rgb8"], reference_rgb8) > DISPLAY_LSB_BUDGET:
            material.append(stage)
    return tuple(material)


def compile_shader(
    output_dir: Path,
    name: str,
    width: str,
    ir_path: Path,
) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [
            str(BACKEND),
            "--cg",
            "glsles",
            "--source-dir",
            "src",
            "--output-dir",
            str(output_dir),
            "--directive",
            f"float-width={width}",
            "--directive",
            f"dump-ir={ir_path}",
            SOURCE,
            "-o",
            name,
        ],
        cwd=ROOT,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
    )


def validate_fragment(path: Path) -> None:
    validator = shutil.which("glslangValidator")
    if validator is None:
        return
    result = subprocess.run(
        [validator, "-S", "frag", str(path)],
        cwd=ROOT,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
    )
    require(
        result.returncode == 0,
        "GLSL validator rejected " + str(path) + ":\n" + result.stdout,
    )


def check_generated_variants() -> None:
    require(BACKEND.is_file(), "backend executable is missing; run make backend")
    with tempfile.TemporaryDirectory(prefix="wegert-precision-") as directory:
        output_dir = Path(directory)
        for width, precision in (("f16", "mediump"), ("f32", "highp")):
            ir_path = output_dir / f"wegert-{width}.ir"
            result = compile_shader(output_dir, f"wegert-{width}", width, ir_path)
            require(
                result.returncode == 0,
                f"{width} Wegert shader failed:\n" + result.stdout,
            )
            fragment_path = output_dir / f"wegert-{width}.frag"
            require(fragment_path.is_file(), f"missing generated {fragment_path.name}")
            require(ir_path.is_file(), f"missing generated {ir_path.name}")
            source = fragment_path.read_text()
            ir = ir_path.read_text()
            semantic = width.upper()
            other = "F32" if semantic == "F16" else "F16"
            require(
                f"precision {precision} float;" in source,
                f"{width} Wegert shader did not select {precision}",
            )
            require(
                semantic in ir and other not in ir,
                f"{width} Wegert IR did not preserve semantic width",
            )
            validate_fragment(fragment_path)


def main() -> int:
    check_generated_variants()

    required_regions = {
        "zero",
        "pole",
        "cancellation",
        "phase_wrap",
        "dynamic_range",
        "holomorphic",
    }
    observed_regions = {region for case in CASES for region in case.regions}
    require(
        required_regions <= observed_regions,
        "precision corpus lost a required difficult region",
    )

    material_cases = []
    print(
        "case                          ref RGB8       F32 RGB8       "
        "F16 RGB8       mixed RGB8     first material prefix     isolated material"
    )
    for case in CASES:
        reference = evaluate(case, all_widths("f64"))
        f32 = evaluate(case, all_widths("f32"))
        f16 = evaluate(case, all_widths("f16"))
        mixed = evaluate(case, mixed_widths())

        reference_rgb8 = reference["rgb8"]
        f32_delta = max_lsb_delta(f32["rgb8"], reference_rgb8)
        f16_delta = max_lsb_delta(f16["rgb8"], reference_rgb8)
        mixed_delta = max_lsb_delta(mixed["rgb8"], reference_rgb8)
        require(
            f32_delta <= DISPLAY_LSB_BUDGET,
            f"{case.name}: F32 exceeded the {DISPLAY_LSB_BUDGET}-LSB display budget",
        )
        require(
            mixed_delta <= DISPLAY_LSB_BUDGET,
            f"{case.name}: mixed candidate exceeded the "
            f"{DISPLAY_LSB_BUDGET}-LSB display budget",
        )

        first_material = first_material_prefix_stage(case, reference_rgb8)
        isolated = material_single_stages(case, reference_rgb8)
        if f16_delta > DISPLAY_LSB_BUDGET:
            material_cases.append((case.name, f16_delta, first_material, isolated))

        print(
            f"{case.name:29} {str(reference_rgb8):14} {str(f32['rgb8']):14} "
            f"{str(f16['rgb8']):14} {str(mixed['rgb8']):14} "
            f"{str(first_material or '-'):25} {','.join(isolated) or '-'}"
        )

    require(
        material_cases,
        "corpus no longer contains a case that exposes a material F16 difference",
    )

    print(
        "\nmaterial F16 cases: "
        + "; ".join(
            f"{name}: {delta} LSB, first prefix={stage or '-'}, "
            f"isolated={','.join(isolated) or '-'}"
            for name, delta, stage, isolated in material_cases
        )
    )
    print(
        "mixed candidate: F16 except compose_measure + color_bands at F32; "
        f"all corpus outputs stay within {DISPLAY_LSB_BUDGET} framebuffer LSB of binary64"
    )
    print(
        "host Wegert precision acceptance passed; physical PowerVR/Mali mediump "
        "execution remains separate evidence"
    )
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except AssertionError as error:
        print(f"Wegert precision acceptance failed: {error}", file=sys.stderr)
        raise SystemExit(1)
