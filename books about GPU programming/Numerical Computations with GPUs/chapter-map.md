# Numerical Computations with GPUs — chapter map

Edited by Volodymyr Kindratenko. Springer, 2014.

Official contents:

https://link.springer.com/book/10.1007/978-3-319-06548-9

## Evidence level

This is a commercial book. Springer publicly exposes the complete table of
contents and some metadata/abstract material, not the whole text. Therefore the
entries below are **metadata-based orientation notes**, not claims that the
chapters were read in full.

The point of keeping this map is to know exactly which chapters deserve later
legal access/read-through and how they intersect
[the current repository problems](../problem-lens.md).

## Linear Algebra

### 1. Accelerating Numerical Dense Linear Algebra Calculations with GPUs

Covers the mapping and optimization of standard dense linear-algebra building
blocks on GPUs, with emphasis on high-throughput matrix operations.

**Current-work connection:** use this to ask which matrix/vector operations
should remain explicit in IR long enough for tiling, packing and specialized
target lowering.

### 2. A Guide for Implementing Tridiagonal Solvers on GPUs

Addresses parallel formulations of tridiagonal linear systems, where the
dependency structure makes naïve row-by-row elimination a poor GPU mapping.

**Current-work connection:** an algorithm's dependency graph is semantic
structure. Do not flatten it before deciding which parallel solver family the
target should use.

### 3. Batch Matrix Exponentiation

Treats many matrix exponentials as a batched workload so independent small
problems can fill the GPU.

**Current-work connection:** relevant to batched small transforms: coefficient
generation and repeated application can be scheduled differently when batch
structure survives.

### 4. Efficient Batch LU and QR Decomposition on GPU

Maps many small LU/QR factorizations onto GPU execution, balancing per-problem
parallelism with the opportunity to process many independent factorizations.

**Current-work connection:** QR is particularly relevant to Givens/orthogonal
transform research. Keep factorization and plane-rotation structure recognizable
rather than expanding it prematurely into scalar statements.

### 5. A Flexible CUDA LU-Based Solver for Small, Batched Linear Systems

Builds a solver around batched LU for collections of small systems, emphasizing
flexibility across problem sizes.

### 6. Sparse Matrix-Vector Product

Covers GPU sparse matrix-vector multiplication, where storage format and memory
access often matter more than raw arithmetic.

**Current-work connection:** an ideal semantics-versus-layout case. Sparse
matrix structure is not identical to CSR/ELL/etc.; keep the operator above the
target encoding.

## Differential Equations

### 7. Solving Ordinary Differential Equations on GPUs

Surveys/implements ODE integration on GPU architectures, turning repeated
state updates into parallel numerical work.

**Current-work connection:** time stepping is a bounded/repeated computation
with an error/stability contract, not merely a generated loop body.

### 8. GPU-Based Parallel Integration of Large Numbers of Independent ODE Systems

Uses problem-level parallelism across many independent ODE systems rather than
trying to extract all parallelism from one system.

**Current-work connection:** preserve the distinction between within-problem
structure and batch-level parallelism.

### 9. Finite and Spectral Element Methods on Unstructured Grids for Flow and Wave Propagation Problems

Maps element-based PDE methods on irregular meshes to GPU execution.

**Current-work connection:** basis/element/connectivity structure should survive
above target memory layout and gather scheduling.

### 10. A GPU Implementation for Solving the Convection Diffusion Equation Using the Local Modified SOR Method

Implements an iterative relaxation scheme for a convection-diffusion PDE.

**Current-work connection:** the iteration/stencil/dependency structure matters
for both correctness and scheduling; it should not become a manually duplicated
sequence.

### 11. Finite-Difference in Time-Domain Scalable Implementations on CUDA and OpenCL

Studies scalable finite-difference time-domain updates across CUDA/OpenCL
targets.

**Current-work connection:** especially useful as a multi-backend comparison:
the numerical stencil is common while memory tiling and synchronization differ.

## Random Numbers and Monte Carlo Methods

### 12. Pseudorandom Numbers Generation for Monte Carlo Simulations on GPUs: OpenCL Approach

Covers GPU pseudorandom generation for Monte Carlo workloads in OpenCL.

### 13. Monte Carlo Automatic Integration with Dynamic Parallelism in CUDA

Uses CUDA dynamic parallelism to organize adaptive/automatic Monte Carlo
integration.

**Current-work connection:** data-dependent spawning is a target realization of
adaptive computation; the mathematical stopping/error criteria should stay
above it.

### 14. GPU: Accelerated Computation Routines for Quantum Trajectories Method

Maps the repeated stochastic numerical work of quantum-trajectory simulation to
the GPU.

### 15. Monte Carlo Simulation of Dynamic Systems on GPUs

Uses many independent stochastic trajectories to exploit GPU throughput for
dynamic-system simulation.

## Fast Fourier Transform and Localized n-Body Problems

### 16. Fast Fourier Transform (FFT) on GPUs

Covers FFT implementation and optimization on GPU hardware.

**Current-work connection:** directly relevant to the rotation work. FFT
butterflies preserve a repeated paired complex-linear operation with reusable
twiddle coefficients; compare that structure with RoPE/Givens before expanding
either into scalar multiplies/adds.

### 17. A Highly Efficient FFT Using Shared-Memory Multiplexing

Optimizes FFT execution by restructuring use of shared memory and data movement.

**Current-work connection:** shows why operation structure and target memory
schedule should remain separable.

### 18. Increasing Parallelism and Reducing Thread Contentions in Mapping Localized N-Body Simulations to GPUs

Reorganizes localized N-body workloads to expose more parallelism and reduce
threads contending for shared resources.

**Current-work connection:** pairwise structure, neighborhood locality and
contention are all information a flat scalar IR tends to obscure.

## Highest-value chapters for current work

- **4** — QR/Givens and batched orthogonal transformations.
- **6** — sparse operator semantics versus storage format.
- **7–11** — bounded iteration, stencils and multi-backend numerical kernels.
- **16–17** — FFT butterflies/twiddle coefficients versus RoPE/Givens.
- **18** — pairwise work, locality and contention.
