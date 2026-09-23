# Numerical Computations with GPUs — book summary

Edited by Volodymyr Kindratenko. Springer, 2014.

This is the book in the collection that most directly overlaps the mathematics
rather than the graphics API. Its chapter list is basically a catalog of
numerical structures that a GPU compiler should avoid destroying too early:
dense and sparse linear algebra, tridiagonal systems, batched LU/QR, small
linear solves, ODE/PDE time stepping, FFTs, Monte Carlo work, and localized
N-body computation.

For the current problems, the QR and FFT chapters are the obvious places to
mine. QR is where Givens/orthogonal-transform structure can matter directly;
FFT butterflies are another repeated paired linear operation with reusable
coefficients. Sparse matrix-vector work is useful for the separate question of
**semantic operator versus storage representation**, and the differential
equation chapters are good examples of bounded/repeated numerical state whose
error and stability contracts matter independently of the loop syntax used to
execute it.

The full commercial chapters are not publicly hosted, so the current repository
notes deliberately stop at a metadata-based map rather than inventing detailed
summaries.

See the [18-chapter map](chapter-map.md).

## Thanks

Thanks to **Volodymyr Kindratenko** for editing a volume centered on actual
numerical methods, and to the chapter authors for writing down the mathematical
background as well as GPU implementation concerns.
