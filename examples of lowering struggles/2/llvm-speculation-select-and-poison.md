# LLVM: speculation, select, poison, and erased branch boundaries

Primary sources:

- LLVM Language Reference:
  https://llvm.org/docs/LangRef.html
- LLVM Undefined Behavior manual:
  https://llvm.org/docs/UndefinedBehavior.html
- LLVM ValueTracking, `isSafeToSpeculativelyExecute`:
  https://llvm.org/doxygen/ValueTracking_8h.html
- LLVM speculative-execution pass:
  https://llvm.org/doxygen/SpeculativeExecution_8cpp_source.html

## Important precision: `select` does not evaluate expressions

LLVM IR is already SSA.  A `select` chooses between two **values**.  It does
not itself contain two delayed expression trees.

Therefore the dangerous transformation is not literally that `select`
"evaluates both arms."  The danger is that converting branch control flow into
a select may require moving the instructions that *produce* those values out of
their original conditional blocks.

That is speculation.

## LLVM makes speculation a first-class legality question

LLVM has an explicit query,
`isSafeToSpeculativelyExecute`, whose contract asks whether an instruction can
be moved to execute even on paths where it previously did not execute.

The implementation must consider effects and undefined behavior; the API
documentation also notes subtleties around memory reads and control dependence.

The speculative-execution optimization separately limits how much work it will
hoist because legal speculation can still be unprofitable.

That distinction is worth preserving:

```text
legal to execute unconditionally
        !=
profitable to execute unconditionally
```

## Poison exists partly to make speculation possible

LLVM's language reference explains that many erroneous operations produce
`poison` rather than triggering immediate undefined behavior.  This lets some
operations be performed speculatively without immediately making the whole
program undefined.

`select` is special in poison propagation: poison on the unselected value does
not by itself poison the result.

This is a sophisticated repair mechanism for a low-level SSA world in which
computations are frequently moved outside their original control-flow context.

## What the higher-level compiler should notice

Once a compiler has lowered

```text
if c then E1 else E2
```

to something based on eager SSA producers plus `select`, it has acquired an
obligation to classify whether producers of `E1` and `E2` may execute
unconditionally.

LLVM has years of machinery devoted to answering that question.

A higher-level IR can avoid inheriting that whole burden too early by retaining
structured conditional production until it actually has enough information to
prove speculation safe.

## Three separate questions

For every proposed branch-to-select lowering:

1. **semantic legality** — can the operation execute on the other path?
2. **definedness** — can doing so expose traps, poison, invalid memory, etc.?
3. **cost** — even if safe, are we now doing expensive work unnecessarily?

A compiler bug can come from confusing any two of these.
