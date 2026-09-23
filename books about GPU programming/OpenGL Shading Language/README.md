# OpenGL Shading Language

Randi J. Rost and contributors, *OpenGL Shading Language*, third edition.

Live publisher page:

https://www.informit.com/store/opengl-shading-language-9780321637635

## Rights status

Commercial book. Do not mirror the book.

The publisher page exposes a detailed table of contents and public sample
material, including sample pages for part of the book. Link to publisher-hosted
samples rather than copying them unless a sample carries an explicit
redistribution license.

## Why it belongs here

This is primarily a target-language and graphics-pipeline reference rather than
a numerical-computing book. It matters to this repository because GLSL ES is an
emission target: types, built-ins, stage interfaces, interpolation, fragment
semantics, and the distinction between language semantics and host API behavior
all affect what a correct backend may emit.

The useful comparison is between:

1. source-language mathematical/control-flow structure;
2. the backend's typed shader representation;
3. GLSL/GLSL ES target semantics;
4. what the physical GPU actually executes.

A target-language reference helps keep those layers distinct.

## Chapter map

[Metadata-based map of all 20 chapters](chapter-map.md)

These notes are explicitly based on public publisher/author metadata where the
full commercial chapter text is not publicly hosted.

## Book-level summary

[Our short problem-driven summary and thanks](book-summary.md)

