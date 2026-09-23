# WebAssembly

WebAssembly is useful because its structured control flow was **deliberately controversial**.

Compiler writers explicitly argued that arbitrary CFGs and gotos would make their lives easier. The WebAssembly design nevertheless kept structured control flow for the MVP.

## "Please support arbitrary labels and gotos"

A long design issue argues from the compiler producer's point of view:

- optimizing compilers already work with CFGs;
- forcing producers to reconstruct loops/blocks after optimization adds complexity;
- structured control flow can feel like an artificial restriction.

The replies defend structure for different reasons:

- engines can exploit reducibility and structural invariants;
- validation is easier;
- JavaScript/polyfill implementations benefit;
- producer-side handling of irreducibility makes performance more predictable;
- structured input can simplify downstream compiler assumptions.

Source:

- https://github.com/WebAssembly/design/issues/796

This is exactly the sort of argument we need to study. One representation is convenient for the producer, another preserves invariants useful to the consumer.

## Branch or break?

An earlier design discussion about whether `br` should be understood as a branch or a labeled break exposes the same tension.

The instruction looks low-level, but its legal targets are defined structurally by enclosing constructs.

Source:

- https://github.com/WebAssembly/design/issues/445

The argument is partly naming, but underneath it is a representation question:

> is control flow fundamentally an arbitrary edge in a graph, or an operation constrained by a structured nesting relation?

## Why this is relevant to the shader failure

WebAssembly distinguishes:

- structured `if`, whose alternatives are control-flow regions;
- value selection, which is a separate operation.

That means the format does not require a producer to represent:

```text
if c then compute A else compute B
```

as:

```text
compute A
compute B
select c A B
```

The two concepts remain separate.

## The important negative lesson

WebAssembly also warns us not to fetishize structure.

The issue #796 critics are correct about something important: structured output can force a compiler to reconstruct nesting after optimizations have naturally produced a graph.

So for Idriç the goal should not be "everything must always stay nested."

The better question is:

> at which compiler seam is structure still semantically important, and when is it safe to lower that structure into a general CFG?

The shader failure happened because we answered that question too early.
