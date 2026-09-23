# STG and GHC

STG deserves serious attention because it is built around the fact that **evaluation order is semantic information** in a lazy language.

The point is not that Idriç should copy STG. The point is that GHC developers have spent decades finding out which transformations accidentally move computation across a `case`, duplicate work, destroy one-shot structure, or change when something is forced.

## `case` is an evaluation boundary

A GHC developer discussion about STG `case` makes the basic semantic fact explicit: a `case` scrutinizes a value and therefore forces enough evaluation to inspect it.

Source:

- https://mail.haskell.org/pipermail/ghc-devs/2014-June/005229.html

That means moving code into or out of a `case` is not merely reshaping syntax.

## Strictness can justify earlier evaluation, but only after proof

A 2016 discussion about `until`, laziness, and performance explains why GHC may evaluate a value earlier when strictness analysis proves that doing so cannot change the result. It also gives a counterexample where a slightly different result structure means the same optimization would be invalid.

Source:

- https://mail.haskell.org/pipermail/ghc-devs/2016-March/011628.html

This is close to the discipline we want: eagerness is an optimization justified by analysis, not the default consequence of flattening control flow.

## A real retreat: case elimination was too aggressive

In 2013 GHC deliberately made case elimination less aggressive because an optimization could change which error was observed first. The compiler had reasoned that the case binder was used strictly, but that still did not justify erasing an explicit evaluation-order boundary.

Source:

- https://www.mail-archive.com/cvs-ghc@haskell.org/msg44778.html

This is exactly the sort of artifact this notebook is for: an apparently reasonable optimization was backed out because the source structure encoded operational meaning that the optimization had ignored.

## Join points: preserving "this is a jump" rather than "this is a function"

A 2013 thread on common-context transformation describes a recurring GHC problem: an optimization can turn a useful join point into something that looks like an ordinary function, losing the no-allocation/no-escape property that made it cheap.

Source:

- https://mail.haskell.org/pipermail/ghc-devs/2013-December/003481.html

The key thought is that a join point is **not just another function value**. Its control-flow role matters.

That is deeply analogous to our `RSelect` problem:

- an `if` branch is not merely a computation whose result happens to be selected later;
- a join point is not merely a function whose result happens to be used at a join.

## Float-out can destroy loop/join structure

A GHC ticket about loopification shows a join point being floated out and temporarily losing the representation that allowed it to compile as a direct jump.

Source:

- https://mail.haskell.org/pipermail/ghc-tickets/2018-March/063833.html

Again, the failure is representational: the program is still extensionally similar, but an optimization has destroyed the structural clue another compiler phase needs.

## Why STG matters to us

STG gives us a vocabulary that our shader IR lacked:

- delayed computation;
- forcing;
- one-shot control transfers;
- explicit case/evaluation boundaries;
- and the distinction between a value and the computation that may produce it.

We do not need to adopt lazy evaluation globally to learn from this.

The specific lesson is:

> if a construct is supposed to control whether a computation runs, represent the computation under that control construct rather than materializing its value first.
