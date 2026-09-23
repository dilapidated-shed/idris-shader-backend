# GPU Gems 2 Chapter 34: branch structure, predication, and `RSelect`

Source: Mark Harris and Ian Buck, “GPU Flow-Control Idioms,” *GPU Gems 2*
(2005).

https://developer.nvidia.com/gpugems/gpugems2/part-iv-general-purpose-computation-gpus-primer/chapter-34-gpu-flow-control-idioms

This is a historical chapter about GeForce FX / GeForce 6 era hardware, not a
description of every modern GPU. It is valuable here because it makes a
compiler distinction unusually concrete: a source branch, a predicated
implementation, and a value-selection operation are different things.

## Terms

### Branch / control flow

A branch says which block of computation runs.

Conceptually:

```
if condition
    run f
else
    run g
```

The important semantic fact is that the untaken arm is not part of the source
execution.

### Predication

Predication turns control flow into guarded instruction execution.

A schematic predicated lowering is closer to:

```
p = condition

under p:
    compute/write the f side

under not p:
    compute/write the g side
```

The predicate may be a scalar condition or a lane mask. Instructions may still
be issued for both paths while writes/effects for inactive lanes are suppressed.

Chapter 34 gives a particularly strong historical example: on older fragment
hardware using condition codes, both sides of an `if` were evaluated and the
condition controlled which results were written. That is one implementation of
predication. It is not the meaning of `if` itself.

### Select

A select chooses between values:

```
result = select condition value_if_true value_if_false
```

It does not by itself represent two alternative control-flow regions. LLVM,
for example, defines `select` as choosing one value without IR-level
branching.

A select is therefore a good target operation when both alternatives are
already legitimate values to have computed. It is not automatically a valid
replacement for an arbitrary source branch.

### If-conversion

If-conversion is the compiler transformation that deliberately changes a
branch into predicated or select-based code.

That transformation may be excellent. The important point is that it should be
an explicit later decision, with legality and cost information available, not
an accidental consequence of the basic IR representation.

### Speculation

Speculation means performing work before knowing that the source program
requires it. Converting a branch into straight-line computation of both arms
can therefore introduce speculation.

That is only safe when the untaken work is safe to perform. Side effects,
traps, invalid memory accesses, divergence/nontermination, poison-like values,
and simply doing a great deal of unnecessary work can all matter.

## Why this matters for `RSelect`

The problematic shape is not merely the name `RSelect`. The problem is using
a value-selection node as the representation of source control flow.

If lowering does this:

```
source if/case
    ↓
compute then arm
compute else arm
RSelect condition then_value else_value
```

then the compiler has already performed a form of if-conversion/speculation.
The distinction between “which arm runs?” and “which value wins?” has been
lost.

The safer architecture is:

```
source if/case
    ↓
structured branch in shader IR
    ↓
target-aware lowering
        ├─ real branch
        ├─ predication / masked execution
        ├─ value select
        └─ some other target-specific strategy
```

This leaves `RSelect` useful as a target-level operation for selecting between
values while preventing it from becoming the ontology of source branching.

## What Chapter 34 contributes to PR #40

Chapter 34 is direct historical evidence for the architectural distinction
behind PR #40, “Preserve structured shader control flow before target
lowering.”

The chapter treats predication, SIMD branching, moving a decision earlier in
the pipeline, static branch resolution, and other mechanisms as alternative
ways to realize control flow. That supports keeping control-flow intent in the
IR until a later target-aware transformation chooses among those mechanisms.

The lesson is not “never predicate.” It is:

> preserve the branch first; if-convert later when it is legal and useful.

## Cross-compiler relevance

This is not GPU-only. Any compiler can destroy useful intent by replacing
control structure with an eager value graph too early. The corresponding Idric
compiler note should be read together with this one.

## References

- Harris and Buck, GPU Gems 2, Chapter 34:
  https://developer.nvidia.com/gpugems/gpugems2/part-iv-general-purpose-computation-gpus-primer/chapter-34-gpu-flow-control-idioms
- LLVM Language Reference, `select`:
  https://llvm.org/docs/LangRef.html#select-instruction
