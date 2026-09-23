# ShaderX and GPU Pro

Wolfgang Engel, editor, and many contributing authors.

Series/resource index:

https://www.realtimerendering.com/resources/shaderx/

GPU Pro 1 publisher page:

https://www.routledge.com/GPU-Pro-Advanced-Rendering-Techniques-1st-Edition/Engel/p/book/9780429108426

GPU PRO 360 Guide to GPGPU:

https://www.routledge.com/GPU-PRO-360-Guide-to-GPGPU/Engel/p/book/9781138484412

## Rights status

These books are not mirrored here.

The Real-Time Rendering resource page records that the editor worked with the
publisher/authors to make the first ShaderX volumes legitimately available as
free downloads. That is legitimate access, but "free download" is not the same
thing as a redistribution license; the books' copyright notices remain
restrictive.

## Live early volumes

- [Direct3D ShaderX: Vertex and Pixel Shader Tips and Tricks — complete chapter map](Direct3D%20ShaderX%20-%20Vertex%20and%20Pixel%20Shader%20Tips%20and%20Tricks/chapter-map.md)
- [ShaderX2: Introductions and Tutorials with DirectX 9 — all 8 chapter summaries](ShaderX2%20-%20Introductions%20and%20Tutorials%20with%20DirectX%209/chapter-summaries.md)
- [ShaderX2: Shader Programming Tips and Tricks with DirectX 9 — complete chapter map](ShaderX2%20-%20Shader%20Programming%20Tips%20and%20Tricks%20with%20DirectX%209/chapter-map.md)

The two large PDFs that cannot currently be ingested end-to-end distinguish
`indexed-text` from `TOC-guided` notes so a title is never misrepresented as
a read chapter.

## Why the series belongs here

The series is a large historical record of practical GPU/shader techniques. For
this repository, the strongest material includes:

- shader flow-control and data-layout tricks from constrained hardware eras;
- compiler/abstraction/disassembly chapters;
- dense matrix algebra and lookup-table coefficient generation;
- bounded traversal and iterative shader work;
- GPGPU material predating/overlapping CUDA;
- filtering, image-space computation and reductions;
- ray traversal and spatial data structures;
- mobile/handheld constraints.

The *GPU PRO 360 Guide to GPGPU* remains a useful later GPGPU-focused
cross-section, but it is not treated as a freely hosted full text here.

## Source-code collections

There are public GitHub collections containing ShaderX/GPU Pro companion code.
Do not infer that an aggregator's top-level license relicenses every third-party
file it collected. Prefer the publisher/author source plus the individual
file/package license when deciding whether to vendor code.

## Book-level takes

- [Direct3D ShaderX: Vertex and Pixel Shader Tips and Tricks](Direct3D%20ShaderX%20-%20Vertex%20and%20Pixel%20Shader%20Tips%20and%20Tricks/book-summary.md)
- [ShaderX2: Introductions and Tutorials with DirectX 9](ShaderX2%20-%20Introductions%20and%20Tutorials%20with%20DirectX%209/book-summary.md)
- [ShaderX2: Shader Programming Tips and Tricks with DirectX 9](ShaderX2%20-%20Shader%20Programming%20Tips%20and%20Tricks%20with%20DirectX%209/book-summary.md)

These summaries are deliberately selective: they ask what each volume still has
to say about preserving control flow, bounded iteration, matrix/rotation
structure, target representations, compiler lowering, and actual GPU evidence.

## Thanks

Thanks to **Wolfgang F. Engel** for editing and sustaining the ShaderX/GPU Pro
line, to the many chapter authors for contributing concrete techniques, and to
the people who arranged legitimate public access to the early volumes. That
access is why these old target-specific books can still be mined instead of
reduced to second-hand citations.

