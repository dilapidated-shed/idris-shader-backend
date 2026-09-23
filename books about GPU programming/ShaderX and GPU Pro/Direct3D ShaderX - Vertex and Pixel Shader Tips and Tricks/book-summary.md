# Direct3D ShaderX: Vertex and Pixel Shader Tips and Tricks — book summary

Edited by Wolfgang F. Engel. Wordware Publishing, 2002.

The value of this volume now is not that we should imitate DirectX 8-era shader
code. It is that the restrictions are so severe that the authors are forced to
show exactly which computational structure they are trying to preserve while
they invent a workaround.

The chapters on software vertex-shader optimization, shader flow-control tricks,
returning intermediate results through render targets, image processing,
non-integer powers, iterative particle work, and engine integration are useful
for the current backend questions. They demonstrate both sides of the lesson:
sometimes arithmetic reformulation is clever and legitimate; other times the
target simply lacks the right primitive. Those are reasons to keep the
higher-level operator visible—not reasons to define the operator by the hack.

The volume is especially good historical evidence for “target limitation versus
semantic necessity.”

See the [complete evidence-labeled chapter map](chapter-map.md).

## Thanks

Thanks to **Wolfgang F. Engel** for editing the volume and to all of its chapter
authors for recording techniques from an era when much of this knowledge could
easily have remained trapped in proprietary engines and demos.
