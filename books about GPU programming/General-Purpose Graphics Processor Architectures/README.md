# General-Purpose Graphics Processor Architectures

Tor M. Aamodt, Wilson Wai Lun Fung, and Timothy G. Rogers,
*General-Purpose Graphics Processor Architectures*, 2018.

Springer page:

https://link.springer.com/book/10.1007/978-3-031-01759-9

Tor Aamodt's publication list:

https://people.ece.ubc.ca/aamodt/publications/

## Rights status

Commercial book. No whole-book redistribution license was located during the
2026-09-23 check, so this is link-only.

## Why it belongs here

The public book metadata organizes the subject around the GPU programming
model, SIMT core, memory system, and cross-cutting architecture research.

That is directly useful when a compiler/backend question reaches below GLSL
syntax. Divergence, warp/SIMT scheduling, memory coalescing/cache behavior,
occupancy/resource pressure, and synchronization are architectural facts that
can make two semantically equivalent lowerings behave very differently.

This book therefore sits between language/compiler notes and CUDA programming
texts: it helps explain *why* particular GPU programming idioms exist rather
than treating them as arbitrary coding folklore.

## Chapter map

[Metadata-based map of all 5 chapters](chapter-map.md)

These notes are explicitly based on public publisher/author metadata where the
full commercial chapter text is not publicly hosted.

