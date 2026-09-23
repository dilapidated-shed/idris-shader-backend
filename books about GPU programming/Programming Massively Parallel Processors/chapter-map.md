# Programming Massively Parallel Processors, 5th ed. — chapter map

Wen-mei W. Hwu, David B. Kirk, Izzat El Hajj. Morgan Kaufmann/Elsevier, 2026.

Official publisher contents:

https://shop.elsevier.com/books/programming-massively-parallel-processors/hwu/978-0-443-43900-1

## Evidence level

Commercial book. The publisher exposes a complete table of contents and edition
description, not a public full-text edition. These are **metadata-based
orientation notes**, not full-chapter summaries.

## 1. Introduction

Frames massively parallel programming as a way to reformulate computation for
throughput hardware.

## Part I — Fundamental Concepts

### 2. Heterogeneous Data Parallel Computing

Introduces CPU/GPU cooperation and the data-parallel programming model.

**Current-work connection:** keep device/host partitioning downstream of the
mathematical operation.

### 3. Multidimensional Grids and Data

Maps multidimensional problem domains onto thread/grid indexing.

**Current-work connection:** logical tensor/field dimensions should not be
confused with one physical lane/storage layout.

### 4. Compute Architecture and Scheduling

Explains GPU execution resources and how thread blocks/warps are scheduled.

**Current-work connection:** source branches/loops are not warp scheduling;
preserve the former so target scheduling remains a choice.

### 5. Memory Architecture and Data Locality

Covers global/cache/shared/register memory behavior and data reuse.

**Current-work connection:** especially relevant to RoPE coefficient reuse,
Q/K reductions and fixed-array layout.

### 6. Performance Considerations

Collects practical bottleneck analysis and optimization reasoning.

**Current-work connection:** benchmark emitted physical targets; do not infer a
win merely because the generated source is shorter.

## Part II — Parallel Patterns

### 7. Convolution

Develops tiled/neighborhood convolution as a recurring data-parallel pattern.

**Current-work connection:** preserve kernel/neighborhood structure long enough
to exploit target filtering/tiling.

### 8. Stencil

Covers repeated local-neighborhood updates over grids.

**Current-work connection:** a stencil plus time iteration is explicit
bounded/repeated structure, not a manually duplicated expression.

### 9. Parallel Histogram

Deals with contention and privatization/aggregation when many threads update a
small set of bins.

### 10. Reduction

Develops tree-style collective reduction.

**Current-work connection:** directly relevant to Q/K sum-of-squares. Keep the
reduction object, accumulation width and error contract visible.

### 11. Prefix Sum (Scan)

Develops scan as a reusable collective operation.

**Current-work connection:** useful for compaction, radix operations and other
variable-output algorithms; should be a recognizable operator.

### 12. Merge

Parallelizes merging of sorted sequences through partitioning/search structure.

## Part III — Advanced Patterns and Applications

### 13. Sorting

Builds scalable GPU sorting from structured parallel primitives.

### 14. Filtering

New fifth-edition chapter on filtering/data selection.

**Current-work connection:** filtering/compaction is semantic work avoidance,
not merely a target predicate.

### 15. Sparse Matrix Computation

Covers sparse numerical operators and their representation/performance issues.

**Current-work connection:** keep sparse matrix semantics above CSR/ELL/etc.
storage choices.

### 16. Wavefront Algorithms

New chapter on computations whose ready set advances through a dependency
frontier.

**Current-work connection:** dependency structure is exactly the kind of
information premature lowering can destroy.

### 17. Graph Traversal

Maps irregular graph-frontier expansion to massively parallel execution.

### 18. Deep Learning

Uses neural-network workloads as a case study in dense/reduction-heavy GPU
computation.

**Current-work connection:** attention-side normalization and reductions belong
to this numerical-operator layer, not merely to one fused kernel spelling.

### 19. Multi-GPU API

Covers modern multi-GPU programming facilities and communication.

### 20. Electrostatic Potential Map

Uses a scientific all-pairs/field computation as an optimization case study.

**Current-work connection:** compare with N-body/pair-rotation workloads:
repeated pairwise structure can guide tiling/reuse.

### 21. Parallel Programming and Computational Thinking

Steps back from syntax to the process of recognizing parallel structure and
reformulating algorithms.

**Current-work connection:** strongly aligned with keeping semantic structure
until enough target information exists to choose a good realization.

## Part IV — Advanced Practices

### 22. Programming a Heterogeneous Computing Cluster

Extends GPU computation across node/device boundaries.

### 23. Advanced Optimizations for Matrix Multiplication

New chapter on deeper matrix-multiplication transformations and hardware-aware
optimization.

**Current-work connection:** perhaps the clearest modern example of why a
matrix product should not become anonymous scalar multiply-adds too early.

### 24. Advanced Practices and Future Evolution

Covers newer CUDA mechanisms and the continuing evolution of massively parallel
hardware/software.

### 25. Conclusion and Outlook

Synthesizes the programming model and future direction.

## Highest-value chapters for current work

- **4–6** — execution/scheduling, memory and measurement.
- **10–11** — reduction and scan as first-class collective operators.
- **15–17** — sparse/irregular/dependency structure.
- **18** — attention/deep-learning numerical kernels.
- **20** — repeated pairwise scientific computation.
- **23** — structured matrix optimization retained until target lowering.
