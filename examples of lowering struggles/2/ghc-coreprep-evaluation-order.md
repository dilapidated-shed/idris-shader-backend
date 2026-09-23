# GHC CorePrep: evaluation order is a lowering invariant

Primary source:

- GHC `GHC.CoreToStg.Prep`:
  https://downloads.haskell.org/~ghc/9.14.2-rc1/docs/libraries/ghc-9.14.1.20260728/src/GHC.CoreToStg.Prep.html

## The relevant warning

The source note says it is "quite essential" that CorePrep **does not rearrange
the order in which evaluations happen**.  It contrasts CorePrep with FloatOut
and explains that CorePrep lowers `seq#` into a `Case`.

That is unusually direct evidence for the research question: once a lowering
step gives a construct a more operational representation, ordinary-looking
floating/code-motion can cease to be semantics-neutral.

CorePrep also distinguishes strict and lazy arguments during ANF-style
preparation.  In the source commentary, a strict argument can be case-bound,
while a non-trivial lazy argument is let-bound.  So the shape of the binding is
carrying evaluation information.

## Structural lesson

A flat "these are all just temporaries" IR would lose a distinction GHC needs:

```text
lazy binding     let x = E in ...
strict demand    case E of x -> ...
```

Those are not interchangeable administrative forms in a lazy compiler.

The important point for our shader work is not Haskell-specific laziness.  It is
the more general invariant:

> A lowering pass must not erase the boundary that says whether a computation
> is demanded on this control-flow path.

If a later representation makes a guarded computation look like an ordinary
movable temporary, generic code motion can silently change evaluation.

## Follow-up

Search older GHC commentary, commits, tickets, and papers for cases where this
invariant was learned through an actual miscompile, space leak, strictness bug,
or failed transformation.  The current source documents the mature rule; the
historical failure would be even more valuable.
