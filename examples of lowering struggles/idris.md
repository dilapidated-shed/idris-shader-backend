# Idris

Idris is both a useful precedent and a useful negative example because our shader backend consumes Idris compiler forms directly.

## Idris 1 had many successive lowerings

A detailed walk through Idris 1 describes a pipeline roughly like:

```text
source AST
  -> TT
  -> TT_case
  -> IR_case
  -> IR_lift
  -> IR_defunc
  -> IR_ANF
  -> backend
```

Source:

- https://koerbitz.me/posts/A-Look-at-the-Idris-Internals-Part-I-Overview-and-Parsing.html

Every arrow is a possible place to lose information that a later backend might wish it still had.

## Case trees preserve pattern/control structure explicitly

Idris compiles pattern matching into case trees before much lower-level code generation. Idris 2 continues to expose case structure explicitly rather than defining source matching in terms of a select instruction.

A useful implementation-oriented summary:

- https://gist.github.com/thealmarty/ad574da780b902461117e905b3c078aa

## Delay and force are explicit compiler concepts

Idris 2's compiled-expression representation includes explicit delayed and forced computations as well as constructor/constant cases.

That is important for this investigation: the compiler family already knows how to represent "this is a computation that must not simply be treated as an eager value."

Current compiler source is the canonical reference; this notebook should keep local snapshots of the exact API definitions we depend on when the relevant Idriç compiler seam is chosen.

## Old case transformation could confuse another analysis

An older Idris discussion shows a source `case` being lifted into top-level pattern-matching definitions in a way that changed what the totality checker saw. The program's source-level structure was reasonable, but the transformed representation made the recursion relationship look different.

Source:

- https://groups.google.com/g/idris-lang/c/VLG98Z2mf_A

This is not the same bug as `RSelect`, but it is the same species: one compiler phase rewrites structure for its own purposes and another phase inherits a much worse problem.

## Idris 2 is already suggestive

The current Idris 2 compiler documentation describes backend forms where case expressions are still tree-shaped and backends translate them into the target's branching mechanism.

That suggests our shader flattening was downstream policy, not something the Idris compiler forced us to do.

## What to investigate next

The useful historical question is not merely "what does Idris 2 do today?"

Look for:

- Idris 1 backend code before and after IR changes;
- old talks explaining why Idris 2 rewrote parts of the compiler;
- code-generation bugs involving `case`, laziness, erasure, or ANF;
- and whether any backend historically flattened case branches and later had to recover them.

That may tell us whether the compiler API we want already existed in an earlier form.
