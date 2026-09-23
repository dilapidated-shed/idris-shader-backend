# Lowering struggles — thread 2

This directory is deliberately isolated from the parallel research thread.

Research question:

> When has lowering into an intermediate representation destroyed evaluation
> structure that the source program depended on?

"Evaluation structure" includes:

- whether a computation happens at all;
- which branch guards it;
- strict versus delayed evaluation;
- sharing versus duplicated evaluation;
- sequencing and demand boundaries;
- whether work remains beneath a conditional or is hoisted/speculated above it.

The pattern of interest is:

```text
source: conditional / delayed / shared computation
                    ↓
              IR lowering
                    ↓
structural distinction disappears or becomes implicit
                    ↓
extra evaluation / lost sharing / unsafe speculation / fragile invariant
```

## Initial cases

| Case | Why it belongs | Status |
| --- | --- | --- |
| GHC CorePrep | GHC explicitly forbids this lowering phase from rearranging evaluation order; floating across the wrong boundary would change when work happens. | strong primary-source evidence |
| Strict Core | Bolingbroke/Peyton Jones redesign the IR so laziness and evaluatedness distinctions are explicit rather than fragile side information. | strong primary-source evidence |
| HEIR / MLIR if → select | Turning structured conditional regions into a value-level select hoists branch-local computation; the pass therefore requires pure, speculatable operations. | direct structural analogue |
| LLVM machine if-conversion | Branches become predicated instructions; LLVM has explicit predicability, predicate-clobber and duplication checks. | analogue / controlled lowering, not yet evidence of a historical failure |

The goal is not to collect only "lazy language bugs."  The more general question is
what compiler authors discovered had to remain represented in an IR so that later
passes could not accidentally erase conditionality, delay, sharing, or sequencing.

Each case gets its own file so later threads can merge without editing the same note.
