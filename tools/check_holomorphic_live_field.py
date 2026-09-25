#!/usr/bin/env python3
"""Compile the live Holomorphic background through structured shader IR."""

from __future__ import annotations

import shutil
import subprocess
import sys
import tempfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
BACKEND = ROOT / "build" / "exec" / "idris2-glsles"
VERTEX = ROOT / "fixtures" / "wegert-fullscreen.vert"
SOURCE = "src/Example/HolomorphicExplorerBackground.idr"


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def compile_shader(output_dir: Path, output_name: str, ir_path: Path) -> Path:
    result = subprocess.run(
        [
            str(BACKEND),
            "--cg",
            "glsles",
            "--source-dir",
            "src",
            "--output-dir",
            str(output_dir),
            "--directive",
            "float-width=f32",
            "--directive",
            f"dump-ir={ir_path}",
            SOURCE,
            "-o",
            output_name,
        ],
        cwd=ROOT,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
    )
    require(result.returncode == 0, "Holomorphic follower failed:\n" + result.stdout)
    shader_path = output_dir / f"{output_name}.frag"
    require(shader_path.is_file(), "backend did not write generated fragment")
    require(ir_path.is_file(), "backend did not write typed IR")
    return shader_path


def validate_glsl(shader_path: Path) -> None:
    validator = shutil.which("glslangValidator")
    if validator is None:
        return

    fragment = subprocess.run(
        [validator, "-S", "frag", str(shader_path)],
        cwd=ROOT,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
    )
    require(
        fragment.returncode == 0,
        "GLSL validator rejected Holomorphic follower:\n" + fragment.stdout,
    )

    linked = subprocess.run(
        [validator, "-l", str(VERTEX), str(shader_path)],
        cwd=ROOT,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
    )
    require(
        linked.returncode == 0,
        "fullscreen vertex and Holomorphic follower did not link:\n" + linked.stdout,
    )


def main() -> int:
    require(BACKEND.is_file(), "backend executable is missing; run make backend")
    require(VERTEX.is_file(), "fullscreen vertex fixture is missing")

    with tempfile.TemporaryDirectory(prefix="holomorphic-live-field-") as directory:
        output_dir = Path(directory)
        ir_path = output_dir / "holomorphic-explorer-background.ir"
        shader_path = compile_shader(
            output_dir, "holomorphic-explorer-background", ir_path
        )
        ir = ir_path.read_text()
        shader = shader_path.read_text()

        for declaration in [
            "in vec2 v_ndc;",
            "uniform vec2 u_resolution;",
            "uniform int u_zero_count;",
            "uniform int u_pole_count;",
            "uniform vec2 u_zero_positions[32];",
            "uniform vec2 u_pole_positions[32];",
            "uniform vec2 u_holomorphic_coefficients[5];",
            "uniform float u_remote_pole_time;",
            "uniform float u_zoom;",
        ]:
            require(declaration in shader, "interface lost " + declaration)

        require(
            ir.count("bounded-loop") == 4,
            "live field must preserve four bounded loops: zeros, poles, exterior poles, q",
        )
        require(
            shader.count("for (int ") == 4,
            "live field must emit four compact GLSL loops",
        )
        require(
            shader.count(" < 32 && ") == 2,
            "zero/pole loops lost their 32-element compile-time bound",
        )
        require(
            shader.count(" < 24 && ") == 1,
            "exterior-pole loop lost its 24-element compile-time bound",
        )
        require(
            shader.count(" < 5 && ") == 1,
            "holomorphic coefficient loop lost its five-element bound",
        )
        require(
            shader.count("u_zero_positions[int(") == 1,
            "zero factors must be read by exactly one bounded loop",
        )
        require(
            shader.count("u_pole_positions[int(") == 1,
            "pole factors must be read by exactly one bounded loop",
        )
        require(
            shader.count("u_holomorphic_coefficients[int(") == 1,
            "holomorphic coefficients must be read by one bounded loop",
        )
        require(" ? " not in shader, "source conditionals regressed to eager GLSL selects")
        require("precision highp float;" in shader, "F32 follower lost highp emission")

        for operation in ["atan(", "log(", "pow(", "sin(", "cos(", "fract(", "mix("]:
            require(operation in shader, "live field lost " + operation)

        validate_glsl(shader_path)

        export_dir = Path("/tmp/holomorphic-live-field-artifact")
        export_dir.mkdir(parents=True, exist_ok=True)
        shutil.copy2(shader_path, export_dir / shader_path.name)
        shutil.copy2(ir_path, export_dir / ir_path.name)

    print(
        "Holomorphic live field passed: structured zero/pole/exterior/q loops, "
        "F32 GLSL validated"
    )
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except AssertionError as error:
        print(f"Holomorphic live-field check failed: {error}", file=sys.stderr)
        raise SystemExit(1)
