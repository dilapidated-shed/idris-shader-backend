# Strict Core: make the lost distinction explicit in the IR

Primary source:

- Max Bolingbroke and Simon Peyton Jones, *Types are calling conventions*,
  Haskell Symposium 2009:
  https://www.microsoft.com/en-us/research/wp-content/uploads/2016/08/tacc-hs09.pdf

## Why this is a particularly strong case

The paper proposes a new intermediate language, Strict Core, whose type system
makes distinctions explicit that earlier GHC Core did not capture adequately.
The abstract states this directly: laziness is explicit.

The paper gives a concrete fragility example.  A wrapper can establish the
invariant that an argument has already been evaluated by using a strict
`case`.  But an ordinary GHC optimization can rewrite that case away when the
body is strict, destroying the invariant.  The authors say this could lead to
wrong behavior or even a segmentation fault.  Their conclusion is that the
invariant is too fragile to leave implicit.

That is almost exactly the pattern we are looking for:

```text
important operational distinction
        ↓
represented only by a particular term shape / side knowledge
        ↓
normal optimizer rewrites that shape
        ↓
invariant disappears
```

## Explicit delay and sharing

Strict Core itself is call-by-value.  If evaluation must be delayed, the program
must contain an explicit thunk and later force it.

The paper then makes a second distinction that matters for this project:
representing a thunk as an ordinary nullary function would model call-by-name
but would lose sharing.  Their operational semantics therefore treats thunks
specially so the body is evaluated at most once.

So there are at least two pieces of structure that a too-generic IR can erase:

1. **delay** — this computation must not happen yet;
2. **sharing** — when it does happen, multiple uses refer to the same evaluation.

## Structural lesson

This is stronger than "be careful with an optimization."  It is an IR-design
response:

> if a distinction is semantically or operationally load-bearing, encode it in
> the representation strongly enough that an unrelated rewrite cannot silently
> erase it.

For the shader problem, a structured conditional node may play the same role:
"this computation exists only on this branch" should not survive merely as a
convention attached to eager SSA values.

## Follow-up

Trace whether Strict Core itself entered GHC, which ideas were instead absorbed
into later Core/STG machinery, and find later papers or implementation notes
where explicit evaluatedness/thunk information solved concrete optimizer
problems.
