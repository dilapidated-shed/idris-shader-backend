# Reusable IR design lessons

This is intentionally language-family-neutral.  It is meant to remain useful
when designing or revising compiler pipelines rather than only while fixing the
current shader lowering.

## 1. Preserve decisions, not necessarily syntax

The source AST does not have to survive forever.

What must survive is every distinction that later transformations still need:

- guarded versus unconditional computation;
- delayed versus already demanded;
- shared versus recomputable;
- ordinary call versus control-flow join;
- pure versus safe-to-speculate;
- one-shot versus multiply-entered;
- value selection versus conditional value production.

A compact annotation or distinct checked node can be enough.

## 2. "Pure" is weaker than "safe to move"

An operation can lack observable side effects and still be unsafe or undesirable
to execute on an additional path.

Possible reasons include:

- divergence;
- traps or undefined behavior;
- invalid memory;
- allocation;
- retention / space leaks;
- expensive computation;
- changed sharing.

Therefore a compiler should avoid using one overloaded `pure` bit as the
answer to every motion question.

## 3. Value choice and computation choice are different

```text
branch:
    choose which computation runs
```

and

```text
select:
    choose between values that already exist
```

are different representations.

Lowering the first to the second is a real optimization/legality step, not
administrative normalization.

## 4. Sharing is an operational property worth representing

For lazy or partially lazy languages, two extensionally equal programs can have
wildly different memory behavior depending on whether a computation is shared.

An optimizer may need explicit vocabulary for:

- thunk;
- force;
- memoizing thunk;
- non-memoizing delay / recomputation;
- one-shot closure.

Do not assume ordinary lambda/application syntax carries enough information
after several optimization passes.

## 5. Checked invariants scale better than folklore

GHC's join points are a good model: identify the role, attach explicit metadata,
and have the verifier/linter check the invariants.

If a transformation relies on a sentence beginning "at this point this node
will always mean...", that sentence is a candidate verifier rule.

## 6. Lower irreversibly only when the next layer can carry the obligation

Destroying structure is reasonable when the target IR has another explicit
representation for the same constraint:

- branch -> predicates;
- laziness -> explicit thunk/force;
- join -> join-point marker / label;
- structured region -> CFG plus verified dominance/control dependence.

Destroying structure without replacing it converts a local invariant into a
global reconstruction problem.

## 7. Treat irreversible lowering as an architectural boundary

Before an irreversible lowering, retain rich intent.

After it, require evidence that:

- the target representation can express every remaining semantic obligation;
- verification exists for those obligations;
- optimizations know which invariants they must preserve.

This boundary should be deliberate and documented rather than emerging
accidentally from whichever pass happened to be easiest to implement first.
