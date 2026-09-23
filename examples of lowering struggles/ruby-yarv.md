# Ruby / YARV

Ruby is useful precisely because none of this depends on dependent types or even static typing.

VM designers still have to decide which program structure survives into generated instruction sequences.

## YARV began as a representation experiment

Koichi Sasada's early YARV material describes moving Ruby from direct AST interpretation to a bytecode/wordcode VM.

The design work explicitly includes:

- instruction-set design;
- compilation from Ruby AST to instructions;
- control-flow instructions;
- stack caching;
- superinstructions;
- special instructions;
- JIT/AOT generation.

Source:

- https://www.atdot.net/yarv/RubyConf2004_YARV_pub.pdf

Already this is a generator writing a program for another machine, and the shape of that generated program matters.

## Stack bytecode versus register-transfer instructions

A 2016 MRI proposal is much closer to the kind of struggle we want.

Vladimir Makarov proposed changing YARV from stack-oriented instructions toward register-transfer-style instructions because the stack form generated extra moves and memory traffic.

He also proposed combining frequent instruction sequences, specifically mentioning compare+branch combinations.

Sources:

- https://bugs.ruby-lang.org/issues/12589
- https://public-inbox.org/ruby-core/c6860328-1169-010a-992d-4dfc695a0729@atdot.net/

The discussion contains real tradeoffs rather than a polished answer:

- RTL can reduce dispatch and memory traffic;
- RTL instructions have a larger footprint;
- Ruby calls still naturally impose stack-like argument ordering;
- dynamic method redefinition prevents obvious static combinations;
- some workloads may actually fit the stack representation better;
- JIT work and VM representation changes may need to be separated.

## Why this belongs in the same notebook

This is not our exact `RSelect` bug, but it is the same class of generator problem:

```text
source semantics
    ↓
chosen intermediate / virtual instruction set
    ↓
generated execution stream
```

If the middle representation makes a common source pattern awkward, the generator emits avoidable work.

Ruby reminds us that the research question is broader than laziness:

> which structure should the generator preserve so that the next machine sees the computation in a useful form?

## Follow-up

Search ruby-core history for concrete cases involving:

- branch fusion;
- peephole optimization;
- superinstructions that were removed or rejected;
- stack caching bugs;
- JIT/AOT C generation producing poor compiler input;
- and bytecode changes that improved one workload while damaging another.
