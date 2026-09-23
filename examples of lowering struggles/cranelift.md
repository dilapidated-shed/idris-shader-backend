# Cranelift

Cranelift is useful because it is deliberately simpler than LLVM in many places, yet it still runs into the same representation problems.

## Extended basic blocks became baggage

An issue from 2020 notes that the SSA builder still contained redundant machinery needed only for Cranelift's older "extended basic block" representation, even after the compiler had moved toward ordinary basic blocks.

Source:

- https://github.com/bytecodealliance/wasmtime/issues/1259

Later documentation cleanup explicitly removed remaining EBB references after the migration was complete:

- https://github.com/bytecodealliance/wasmtime/pull/6235

This is a small but useful example: an IR choice spreads support machinery through the compiler, and removing the representation later requires cleaning up assumptions far beyond the original data type.

## Block parameters instead of phi nodes

Current Cranelift IR uses typed block parameters. A branch passes values to the destination block, much like calling a continuation.

Current documentation:

- https://github.com/bytecodealliance/wasmtime/blob/main/cranelift/docs/ir.md

For our purposes, this is interesting because the value join remains attached to **control-flow edges**, not represented as two unconditional computations followed by a select.

## A very close hit: "computation ... forced before the branch"

A discussion about block parameters and critical edges contains an aside worth preserving. The developers consider splitting critical edges before the egraph optimization so that computation used only on some branches is not forced before the branch.

Source:

- https://github.com/bytecodealliance/wasmtime/issues/7639

That is almost our shader problem in one sentence.

The issue is nominally about block parameters and edge splitting, but the concern is structural:

> where can an instruction physically live so that it executes only on the path that needs it?

## Branch/select representation gets simplified too

A 2022 PR removed several specialized branch/select instructions in favor of simpler `brz`/`brnz` plus `select`, with reviewers explicitly checking whether comparison results would accidentally be materialized or duplicated.

Source:

- https://github.com/bytecodealliance/wasmtime/pull/5097

This is another good example of the tradeoff:

- a simpler IR vocabulary is attractive;
- but the lowering must still recover efficient machine patterns.

## Why Cranelift matters to Idriç

Cranelift suggests another plausible shared representation:

```text
branch c then_block(args...) else_block(args...)

then_block(...):
    ...
    jump join(result)

else_block(...):
    ...
    jump join(result)

join(x):
    ...
```

That is less nested than MLIR SCF but still structurally prevents branch-local instructions from being placed before the branch unless an optimization deliberately moves them.

This is a useful alternative to compare with typed nested `Block ty`.
