# MLIR

MLIR's Structured Control Flow dialect is a useful modern answer, but the historical discussion is more useful than the final API.

## The current answer

`scf.if` contains regions for the then/else computations. Values leave those regions explicitly through `scf.yield`.

Likewise `scf.for` has:

- an induction variable;
- loop-carried values;
- a body region;
- and explicit yielded values for the next iteration/final result.

Current documentation:

- https://mlir.llvm.org/docs/Dialects/SCFDialect/

This is very close to the shape we have independently been moving toward.

## It was not obvious that regions were the answer

A 2020 RFC about renaming the old LoopOps dialect to SCF makes clear that the dialect had evolved from "loops" into a general place for structured control flow.

Source:

- https://discourse.llvm.org/t/rfc-rename-loopops-dialect-to-scf-structured-control-flow/872

The discussion is worth keeping because the participants are still deciding what conceptual category these operations belong to.

## Better: MLIR developers explicitly argued against the obvious answer

A companion discussion titled "Structured Control Flow is Not Necessarily Regions" lays out drawbacks of nesting control flow in regions:

- generic SSA analyses often expect flat CFGs;
- values entering/leaving regions need custom reasoning;
- some transformations become hard-coded to particular operations;
- textbook loop transformations like nested structure;
- textbook SSA transformations like unnested CFGs.

Source:

- https://discourse.llvm.org/t/structured-control-flow-is-not-necessarily-regions/880

This is exactly the kind of struggle we want.

The choice is not:

> structured regions are obviously correct.

It is:

> which representation keeps the structure needed by one family of transformations without making another family impossible?

## Why this matters to Idriç

MLIR suggests a strong candidate representation:

```text
If condition
  then region -> yield T
  else region -> yield T
```

But MLIR's own debate warns us not to make region nesting an unquestioned dogma.

For Idriç we should ask:

- do typed blocks give enough structure without requiring a heavyweight region system?
- can ordinary SSA/control-flow analyses still see through them?
- can the same representation serve ARM, DEX, x86, WebAssembly, and shaders?
- can a target lower to flat CFG without losing the original semantic boundary too early?

MLIR is therefore both a positive example and a warning against assuming the polished current design had no tradeoffs.
