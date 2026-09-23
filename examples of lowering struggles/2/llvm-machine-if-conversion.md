# LLVM machine if-conversion: branch structure becomes predication

Primary source:

- LLVM `IfConversion.cpp`:
  https://github.com/llvm/llvm-project/blob/main/llvm/lib/CodeGen/IfConversion.cpp

## What the pass does

LLVM describes this pass as converting conditional branches into predicated
instructions.

The implementation does not treat that as a trivial graph rewrite.  Its
feasibility bookkeeping records, among other things:

- whether a block is predicable;
- whether instructions can clobber the would-be predicate;
- whether a block can safely be copied;
- how many instructions would be duplicated;
- extra costs of predicated execution;
- target-specific profitability.

It also rescans the candidate instruction ranges and rejects cases that cannot
be predicated.

## Why this is useful here

This is not yet evidence of an LLVM historical failure, so it should not be
oversold as one.

It is useful because LLVM's mature implementation makes explicit how much
semantic/target information is needed before control-flow structure can be
collapsed into predicated execution.

The source shape distinguishes:

```text
take true path  -> execute true-path instructions
take false path -> execute false-path instructions
```

After if-conversion, that distinction is represented by predicates on
instructions rather than by branch topology.

So the structure has not simply vanished; LLVM deliberately **re-encodes** the
guarding information.

## Structural lesson

This gives us a useful three-way distinction:

1. preserve structured control flow;
2. lower it to another representation that explicitly retains guards
   (predicated instructions);
3. flatten it into eager values and hope later passes can reconstruct intent.

The third is the dangerous design.

For the shader investigation, this is evidence that mature low-level compilers
normally require an explicit guard/predicate mechanism when they intentionally
erase branch topology.

## Follow-up

Find actual LLVM/target bugs caused by premature if-conversion, unsafe
speculation, or a target claiming an instruction was predicable when it was not.
Those would upgrade this from an analogue to a historical failure case.
