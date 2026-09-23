# HEIR / MLIR: structured `if` to eager `select`

Primary source:

- HEIR issue #777, *Data-oblivious Programming and its Transformations*:
  https://github.com/google/heir/issues/777

Relevant MLIR definition:

- `scf.if` conditionally executes regions:
  https://github.com/llvm/llvm-project/blob/main/mlir/include/mlir/Dialect/SCF/IR/SCFOps.td

## The transformation

The documented transformation changes a branch-local computation of the form

```text
scf.if %cond {
    %a = compute(...)
    yield %a
} else {
    yield %b
}
```

into roughly

```text
%a = compute(...)
%r = arith.select %cond, %a, %b
```

The control-flow structure has disappeared.  `%a` is now computed before the
selection.

HEIR therefore restricts the transformation to operations that are pure and
speculatable.  It explicitly says it cannot apply the transformation when a
side effect occurs in only one region.

## Why this belongs

This is the non-lazy version of the same structural issue.

The original region says:

> evaluate this operation only if this branch is entered.

A value-level select says:

> both candidate values already exist; choose one.

The transformation is legal only after proving that erasing the evaluation
boundary is harmless.

## Structural lesson

`if` and `select` are not merely two syntaxes for the same thing.

A select can represent the **choice of values** without representing the
**conditional production of those values**.

That distinction is directly relevant to eager `RSelect`-style shader IR.
Once both alternatives are ordinary upstream SSA values, the IR itself no
longer says that one producer belongs exclusively to one branch.

## Follow-up

Look for:

- MLIR bugs where an if/select conversion crossed the speculatability boundary;
- GPU lowering passes that deliberately convert branch control flow into selects;
- operations that are mathematically pure but still unsafe to speculate because
  of traps, poison/undefined behavior, invalid memory access, or cost explosion.
