# GCC / GIMPLE

GIMPLE is worth recording because it contains an unusually clean version of the architecture we are considering.

## C conditional expressions are expanded into control flow first

GCC's internals documentation describes lowering:

```c
a = b ? c : d;
```

into the conceptual form:

```c
if (b)
    temporary = c;
else
    temporary = d;

a = temporary;
```

Only later may GIMPLE's if-conversion machinery reintroduce a conditional expression when appropriate.

Source:

- https://gnu.huihoo.com/gcc/gcc-4.6.0/gccint/Conditional-Expressions.html

This ordering is exactly what our old shader path got backwards.

The semantic structure is preserved first:

```text
condition controls which computation happens
```

and only a later optimization may decide:

```text
both values may be computed and selected
```

## Why this is a strong precedent

The interesting thing is not that GCC has an `if`.

It is that GCC deliberately distinguishes:

1. the source construct;
2. a control-flow form suitable for general optimization;
3. later if-conversion for vectorization or target benefit.

That makes eager evaluation an **optimization decision**, not an accidental consequence of expression lowering.

## High and low GIMPLE

GIMPLE itself has had multiple structural levels. "High GIMPLE" can still contain container/control constructs; lower forms expose more explicit control-flow edges.

This reinforces a recurring theme in this notebook:

> "lower" is not automatically "better."

A lower form exposes machinery needed by some analyses while simultaneously erasing structure useful to others.

## Relation to our shader IR

Our desired direction resembles:

```text
Idriç if
   ↓
typed structured conditional
   ↓
backend/optimizer decision
   ├── preserve branch
   ├── turn into select
   ├── predicate
   └── target-specific transform
```

GIMPLE is therefore not merely another current IR to imitate. It is evidence that a major compiler intentionally places if-conversion **after** control-flow representation rather than building eager selection into the basic meaning of a conditional.

## Historical work still needed

The documentation tells us the answer, not the struggle.

Follow-up research should find the GCC mailing-list history around:

- introduction of GIMPLE/tree-SSA;
- the original if-conversion pass;
- speculation legality;
- vector conditional lowering;
- and cases where lowering from GENERIC/high GIMPLE to lower CFG form lost information needed later.
