# GHC join points: preserve control-flow meaning in a functional IR

Primary sources:

- Luke Maurer, Paul Downen, Zena Ariola, Simon Peyton Jones,
  *Compiling without continuations* (PLDI 2017):
  https://www.microsoft.com/en-us/research/publication/compiling-without-continuations/
- GHC Core source, join-point invariants:
  https://downloads.haskell.org/ghc/9.14.0.20250908/docs/libraries/ghc-9.14.0.20250908-eb93/src/GHC.Core.html
- Simon Peyton Jones, *Join points in practice* (Haskell Symposium 2025):
  https://simon.peytonjones.org/join-points-hs/

## The representation problem

A control-flow join can be encoded as an ordinary local function:

```text
let j x = ...
in
case c of
  A -> j a
  B -> j b
```

But operationally this may not be "a function" at all.  It is a label to which
multiple control-flow paths jump.

If an optimizer forgets that distinction, it can allocate closures, transform
calls in ways inappropriate for jumps, or lose opportunities that depend on
tail position.

The 2017 work added join points to GHC Core precisely so this structure could
survive direct-style optimization.

## GHC's compromise is instructive

GHC did not require a completely separate AST constructor for every join.
Instead a binder is explicitly marked as a join point, with a join arity, and
Core Lint checks invariants such as:

- every occurrence is a tail call;
- every call supplies the join arity;
- the RHS begins with enough lambdas.

Later optimizer code treats join points specially where a generic
function rewrite would violate those invariants.

So this is a useful middle ground between:

1. preserving all high-level syntax forever; and
2. erasing the distinction and hoping to rediscover it later.

The IR can share most of its syntax while attaching a **checked semantic role**
to a node.

## Eight years of evidence

In his 2025 retrospective, Peyton Jones says join points became increasingly
entwined with GHC's Simplifier, Occurrence Analyser, and dedicated transforms
such as Exitification.

That matters for IR design: once a structural distinction proves useful, it
often stops being a local optimization trick and becomes part of the contract
between many passes.

## General lesson

When two source constructs can be represented using the same generic lambda,
call, block, or value node, ask whether later passes still need to know which
role the construct played.

If yes, retaining one checked bit of structure can be much cheaper than
reconstructing intent repeatedly.
