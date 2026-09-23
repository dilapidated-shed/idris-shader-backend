# General-Purpose Graphics Processor Architectures — chapter map

Tor M. Aamodt, Wilson Wai Lun Fung, Timothy G. Rogers.

Author/publication page:

https://engineering.purdue.edu/tgrogers/publication/aamodt-book-2018/

Springer page:

https://link.springer.com/book/10.1007/978-3-031-01759-9

## Evidence level

Commercial book. The authors/publisher expose the chapter outline and a detailed
table of contents, but this repository has not established a legal public
full-text edition. These are therefore **metadata-based orientation notes**.

## 1. Introduction

Introduces GPU hardware, the landscape of accelerators and the historical
development that led graphics processors toward general computation.

**Current-work connection:** useful background for separating durable semantic
objects from transient target architectures.

## 2. Programming Model

Describes the GPU execution model and instruction-set view, including NVIDIA and
AMD families.

**Current-work connection:** the source/backend should not confuse a language
construct with one ISA's realization. This is the architectural layer where
that mapping becomes concrete.

## 3. The SIMT Core: Instruction and Register Data Flow

Covers SIMT execution masking, warp scheduling, divergence, operand collection,
instruction replay, scalar/uniform execution and register-file research.

**Current-work connection:** this is probably the single most relevant chapter
to the `RSelect` problem. Source branching, predication/execution masks and
divergence management are different layers. Preserve the branch first; let the
target decide whether to mask, split, compact or otherwise schedule divergent
paths.

Its discussion of detecting uniform/affine variables is also relevant to
rotation coefficients and bounded loops: values shared across many lanes should
remain recognizable enough to avoid redundant work.

## 4. Memory System

Covers scratchpad/shared memory, data/texture caches, on-chip networks, memory
partitions, L2, atomics, memory scheduling and research on caching/bypassing/data
placement.

**Current-work connection:** exactly why vector/array/operator semantics should
not be hardwired to one storage space. The backend should retain enough
structure for PowerVR, Mali, CUDA-like and other targets to make different
placement choices.

## 5. Crosscutting Research on GPU Computing Architectures

Surveys scheduling, alternative expressions of parallelism, transactional
memory, synchronization and heterogeneous systems.

**Current-work connection:** a useful reminder that hardware changes the set of
profitable execution strategies. IR should preserve choices rather than encode
today's scheduling mechanism as semantics.

## Highest-value sections for current work

- **3.1 SIMT execution masking** — predication versus real control flow.
- **3.4 branch-divergence research** — alternative target realizations of a
  preserved branch.
- **3.5 scalarization/uniform variables** — avoid redundant per-lane work;
  relevant to coefficient generation.
- **4 memory system** — target data placement below semantic structure.
