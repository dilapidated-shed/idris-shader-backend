# comp.compilers

The old `comp.compilers` archive is probably one of the richest places to mine for this project because people often wrote while they were actively stuck.

Archive:

- https://compilers.iecc.com/

The messages are public to read, but that does **not** automatically make the individual posts public domain. Keep links and analysis unless licensing is clear.

## Rearranging code invalidates analysis

A 1994 thread starts from a logic-language compiler whose source/IR is annotated with liveness, binding, and scope information. The author discovers that code reorganization invalidates the annotations and asks how compiler writers normally survive this.

Sources:

- https://www.compilers.iecc.com/comparch/article/94-06-080
- https://www.compilers.iecc.com/comparch/article/94-06-082

The responses describe several strategies:

- throw away and recompute derived analyses after transformations;
- keep only a small amount of invariant structure in the IR;
- incrementally maintain selected relations such as use-def chains;
- accept that some transformations simply do not preserve enough information for precise incremental updates.

This is the same broad question we are asking:

> what belongs in the program representation itself, and what is merely analysis that may be invalidated?

## Language-independent IR: what must not be lowered away?

A 1997 discussion about a language-independent IR warns that some constructs become "inscrutable" if translated too early, explicitly mentioning constant-case switches and structures.

Source:

- https://compilers.iecc.com/comparch/article/97-05-139

That is nearly our research thesis in old-fashioned terms.

The author is effectively saying:

> a lower-level form may be general, but if it destroys a recognizable operation you may later be unable to recover or optimize that operation well.

## AST versus CFG was already an argument in 1990

A 1990 discussion argues over whether high-level AST structure helps optimization or seduces implementors into writing special cases for every source loop form.

Source:

- https://compilers.iecc.com/comparch/article/90-08-025

One side values preserved high-level structure. The other values normalizing everything into a graph where all loops and branches look alike.

This is almost exactly the MLIR regions-versus-CFG argument thirty years earlier.

## C as an intermediate representation: "learned this the hard way"

A particularly good 1990 message from a Modula-3 backend implementor describes using C as an intermediate language.

The problems include:

- exception handling;
- garbage-collector root visibility;
- nested procedures;
- aliasing information;
- C optimizers legally rearranging things in ways the source language runtime cannot tolerate;
- and source-language concepts whose clean mapping to C simply does not exist.

Source:

- https://www.compilers.iecc.com/comparch/article/90-08-046

This is an excellent example of **targeting a representation that is too semantically weak** and then fighting the next compiler.

## DAG code generation: lowering loses global opportunity

A 2005 post describes converting a large redundant expression into a DAG, then splitting the DAG into trees to use a known optimal tree-code-generation algorithm.

The author immediately notices what the split loses:

- FPU stack occupancy across subtree boundaries;
- opportunities to keep shared results live;
- scheduling choices among same-level DAG nodes;
- and peephole combinations that interact with register/stack allocation.

Source:

- https://compilers.iecc.com/comparch/article/05-04-028

This is a perfect example of an algorithm being optimal **for the lowered representation** while the representation itself has already thrown away opportunities.

## Why this archive matters

Do not search it only for words like `lazy` or `if-conversion`.

Browse by failure stories:

- "I am writing a compiler...";
- "the problem I've run into...";
- "generated code...";
- "code is much larger...";
- "optimization invalidates...";
- "we used to...";
- "this seemed simple...";
- "I learned this the hard way...";
- "how do compiler writers usually handle...?"

The vocabulary will differ by decade and project. The phenomenon is the stable part.
