# General-Purpose Graphics Processor Architectures — book summary

Tor M. Aamodt, Wilson Wai Lun Fung, and Timothy G. Rogers.

This is the architecture book I would put directly beside the current
structured-control-flow work. Its most relevant material is not generic GPU
history; it is the discussion of SIMT execution masking, divergence, warp
scheduling, scalar/uniform execution, register flow, and memory-system
behavior.

For the `RSelect` problem, the key point is simple: a source branch, a
predicated/masked execution path, and a particular divergence-management scheme
are **different layers**. The architecture chapter gives several ways hardware
can deal with divergence, which is a strong reason not to hard-code one of those
ways into the semantic IR. Its discussion of uniform/affine values is also
useful for RoPE/Givens coefficient generation: if coefficients are shared
across lanes or iterations, the representation should leave that fact visible
long enough for a target to exploit it.

I would read this book for explanations of why GPU programming idioms exist,
not as a recipe for making source code imitate the machine.

See the [5-chapter metadata-based map](chapter-map.md).

## Thanks

Thanks to **Tor Aamodt**, **Wilson Wai Lun Fung**, and **Timothy Rogers** for
collecting architecture material that otherwise tends to be scattered across
papers, vendor documents, and simulator implementations.
