# GHC full laziness: changing sharing changes execution

Primary sources:

- GHC User's Guide, optimisation options:
  https://ghc.gitlab.haskell.org/ghc/doc/users_guide/using-optimisation.html
- GHC worker/wrapper source, Note [Protecting the last value argument]:
  https://ghc.gitlab.haskell.org/ghc/doc/libraries/ghc-9.15-inplace/src/GHC.Core.Opt.WorkWrap.Utils.html
- W. D. Partain, A. Santos, Simon Peyton Jones,
  *Let-floating: moving bindings to give faster programs* (ICFP 1996):
  https://www.microsoft.com/en-us/research/publication/let-floating-moving-bindings-to-give-faster-programs/

## This is not merely evaluation order

A lazy compiler must also preserve the intended **amount of sharing**.

GHC's full-laziness transformation moves bindings outward so that an expression
may be computed fewer times.  That sounds monotonically better, but the User's
Guide explicitly warns that the additional sharing can increase memory
residency.

The inverse transformation, float-in, may move a binding into a branch so that
it is never allocated or evaluated when that branch is not taken.

Thus placement of a lazy binding carries at least two operational facts:

1. on which paths the computation can happen;
2. which dynamic uses share one computation.

Flattening those facts into an undifferentiated temporary graph loses useful
structure even if denotational semantics remain unchanged.

## Function versus thunk is load-bearing

GHC's worker/wrapper pass contains a striking defensive rule:
it may retain a dummy final argument rather than removing every argument and
turning a function into a thunk.

The source note explains why.  A programmer can deliberately write a nullary
call-like boundary so that an expensive expression is recomputed instead of
shared.  Removing the last argument can turn that function closure into one
shared thunk and create a space leak.

In schematic form:

```text
y () = expensive x

use (y ()) + use_again (y ())
```

may intentionally evaluate `expensive x` twice, allowing the first result to
die before the second is produced.

If lowering/optimisation silently turns it into

```text
y = thunk (expensive x)

use y + use_again y
```

then both consumers share one retained result.  Same extensional answer;
potentially very different residency.

## Why it matters for future IRs

"Lazy" is not one bit.

A useful IR may need to distinguish:

- delayed;
- already evaluated;
- recomputable;
- shared thunk;
- one-shot computation;
- branch-local computation.

Those properties affect valid transformations and performance semantics.

A generic optimizer that merely sees "a pure expression" does not have enough
information to decide whether increasing sharing is desirable.

## Design question to keep

When introducing an IR node or normalization rule, ask:

> Did this transformation accidentally decide how many dynamic evaluations
> share the same result?

That is a separate question from both type preservation and ordinary
side-effect preservation.
