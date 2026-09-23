# The CUDA Handbook v2.0 — book summary

Nicholas Wilt.

This is unusually valuable because the author-hosted living edition connects
hardware, emitted instructions, memory, scheduling, profiling, and actual
algorithms in one place. It does not stop at “CUDA works like this”; it often
shows why an optimization succeeds or fails on a real bottleneck.

For this repository, Chapters 12–15 are the center of gravity. Reduction is
directly the Q/K-normalization problem. Scan is a reusable structured primitive.
N-body compares several realizations of the same pairwise computation without
pretending one layout is the semantics. Normalized correlation is particularly
good: it moves through textures, shared/constant memory, DP4A, tensor cores,
FFT, and summed-area tables while preserving one mathematical quantity. The
chapter even gives the kind of warning we need for Givens/RoPE work: a cheaper
instruction can produce **no speedup at all** when the kernel is actually
limited somewhere else.

So I would use this book as an implementation and measurement companion to the
more semantic/compiler-oriented notes: preserve the operator, lower it several
ways, and measure the actual target.

See [all 16 live-chapter summaries](chapter-summaries.md).

## Thanks

Thanks to **Nicholas Wilt** not only for writing the book but for maintaining a
public living v2.0 edition and separately publishing the companion code under a
permissive license. That makes the material much more useful for this kind of
long-running technical notebook.
