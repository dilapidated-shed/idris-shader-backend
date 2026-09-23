# LLVM

LLVM is valuable because its history contains repeated arguments over **when control flow may be turned into data flow**.

## Early if-conversion discussions

An old llvm-dev thread asks for an IR transform that converts branches into serial code with `select` instructions. The replies disagree about where such a transform belongs:

- simple cases in `SimplifyCFG`;
- general if-conversion using control dependence;
- SIMD-oriented conversion into masks;
- or target-specific conversion much later, when machine costs are known.

Source:

- https://groups.google.com/g/llvm-dev/c/FlDGnqSGbR8

This is already close to our problem. Flattening control flow can make some transformations easier, but it also changes which computations become unconditional.

## Predication before code generation

A 2007 developer wanted to target a machine with no branch instructions. The proposed algorithm was roughly:

1. compute the condition under which each instruction is reached;
2. merge blocks;
3. replace phi nodes with selects;
4. predicate memory operations.

The discussion immediately became a fight about compiler phase boundaries. LLVM IR did not naturally represent predicated loads/stores; doing it later meant dealing with machine scheduling and target-specific instructions.

Source:

- https://discourse.llvm.org/t/predication-before-codegen/9287

The interesting artifact is the uncertainty: the author has the right semantic idea but cannot find an IR level where it fits cleanly.

## 2013: speculative execution and a bootstrap miscompile

A speculative-execution change in `SimplifyCFG` was reverted after causing a late stage2 bootstrap miscompile.

Source:

- https://lists.llvm.org/pipermail/llvm-commits/Week-of-Mon-20130121/162952.html

That is more useful than the modern implementation by itself. The compiler had a transform which looked locally valid, moved branch-local work, and then failed in a way serious enough to break the compiler bootstrapping itself.

## 2015: if-convert, then maybe undo it later

An RFC about `SimplifyCFG` heuristics explicitly discusses turning branches into selects because flatter basic blocks help later optimization, while another later phase can turn expensive selects back into branches.

Source:

- https://lists.llvm.org/pipermail/llvm-commits/Week-of-Mon-20150209/257984.html

This is a warning sign for us: once a representation starts bouncing back and forth between "branch" and "select", the legality and profitability rules have to be extremely explicit.

## 2017: "select is tricky"

A poison-semantics discussion enumerates several transformations LLVM wanted simultaneously:

- control flow -> select;
- select -> control flow;
- select -> arithmetic;
- select removal;
- hoisting selects through operations;
- freely moving selects.

The difficulty is that each desired transformation puts different demands on the semantics of poison and speculative evaluation.

Sources:

- https://lists.llvm.org/pipermail/llvm-dev/2017-May/113282.html
- https://lists.llvm.org/pipermail/llvm-dev/2017-May/113289.html

This is an especially strong example for Idriç. Once "choose a branch" has become "choose one of two values", the semantics of those values matter enormously: may either be poison, trap, load invalid memory, diverge, or have effects?

## 2018: "a horribly inconsistent mess"

LLVM developers eventually described `SimplifyCFG` block speculation as a horribly inconsistent mess. Different helper functions had different speculation rules, thresholds, and treatment of floating-point comparisons. Tiny changes to graph shape changed which helper fired and therefore which code shape came out.

Sources:

- https://lists.llvm.org/pipermail/llvm-dev/2018-November/127769.html
- https://lists.llvm.org/pipermail/llvm-dev/2018-November/127777.html

The important lesson is not merely "LLVM is complicated." It is that once multiple passes are allowed to erase and reconstruct control structure opportunistically, the compiler can become hard even for its own authors to reason about.

## What LLVM suggests for Idriç

A safer direction is:

```text
structured conditional
        |
        |  explicit later transformation
        v
if-conversion / speculation
        |
        +-- legality proof
        +-- target cost model
        +-- regression tests
```

rather than making speculation a by-product of the basic IR representation.
