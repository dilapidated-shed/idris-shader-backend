# GPU book census audit — 2026-09-23

This records how the 2016-present bibliography was stress-tested for omissions.
It is an audit trail, not a reading list.

## Search strategy

The sweep deliberately used overlapping searches rather than relying on a
single "GPU books" query.

### By year

Separate searches covered:

- 2016–2017
- 2018–2019
- 2020–2021
- 2022–2023
- 2024–2026

Additional CUDA-specific year sweeps were run across the quiet years where a
generic search could easily miss a revised edition.

### By programming family

Dedicated searches covered:

- CUDA and CUDA Fortran
- OpenCL
- SYCL / DPC++ / oneAPI
- HIP / ROCm
- OpenACC and OpenMP GPU offload
- Vulkan / SPIR-V
- Metal / Metal Shading Language
- Direct3D 12 / HLSL
- OpenGL / GLSL
- WebGL
- WebGPU / WGSL
- wgpu and wgpu-py
- GPU architecture
- GPU ray tracing: DXR, Vulkan ray tracing, OptiX, and CUDA

### By publisher / catalog

Publisher and catalog sweeps included:

- Elsevier / Morgan Kaufmann
- Pearson / Addison-Wesley / InformIT
- Springer / Apress
- Routledge / CRC / A K Peters
- Cambridge University Press
- MIT Press
- Packt
- Manning, including MEAP/forthcoming books
- Kodeco / Ray Wenderlich
- Leanpub
- Google Books-style bibliographic records
- ISBN/retailer/library records for independently published books

The [Real-Time Rendering graphics-books index](https://www.realtimerendering.com/books.html)
was used as an independent cross-check for graphics-API books.

### Author-index sweeps

Publisher searches were insufficient for the independent tail. Dedicated author
sweeps were therefore done for:

- Jack Xu / UniCAD / Dr. Xu's Books
- Benjamin Kenwright and the WebGPU Gems index

Those searches found enough material that the independent tail is maintained in
[modern-census-independent-long-tail.md](modern-census-independent-long-tail.md)
instead of pretending mainstream publisher catalogs are exhaustive.

## What the second pass caught

The first census was definitely incomplete. The gap sweep recovered, among
other things:

- *CUDA Programming*, 2e (2017)
- *The CUDA Handbook*, 2e (2020)
- *Hands-On GPU programming with CUDA C and Python 3*, 2e (2021)
- *Learning Vulkan* (2016)
- all three verified editions of Kenwright's *Introduction to Computer Graphics
  and the Vulkan API*
- the *Metal by Tutorials* edition line, 2018–2025
- Direct3D 12 books that had incorrectly been treated as merely "adjacent"
- modern OpenGL/GLSL and WebGL books that had likewise been under-counted
- Jack Xu's 2021–2023 WebGPU/wgpu books
- a large independent WebGPU/WGSL corpus
- completed 2026 Leanpub CUDA/Vulkan books

It also caught a date/status error: *The Book of WebGPU* was released as an
ebook on **2026-09-22**, so on this audit date it is published, not forthcoming.

## Negative searches that are useful evidence

Repeated targeted searches did **not** reveal a comparable post-2016 flood of
new OpenCL-only, SYCL/DPC++-only, or HIP/ROCm-only books.

The presently identified core remains:

- OpenCL: mostly older pre-2016 books plus mixed heterogeneous-computing books;
- SYCL/DPC++: the two *Data Parallel C++* editions dominate the book-length
  post-2016 corpus found in this sweep;
- HIP/ROCm: *Accelerated Computing with HIP* (and its second edition) plus the
  living ROCm programming guide.

This is not proof that no other title exists. It records that multiple dedicated
searches converged on the same sparse result rather than silently leaving the
family unsearched.

## Inclusion discipline

The census counts a publication when its central subject is programming a GPU
or a GPU-facing programming interface.

That means Vulkan, Metal, Direct3D/HLSL, OpenGL/GLSL, WebGL and WebGPU/WGSL are
not relegated to "adjacent" simply because their output is graphical. Shader,
resource, synchronization, memory and compute programming are GPU programming.

By contrast, these remain adjacent rather than automatically counted:

- broad rendering theory books;
- general computer-graphics textbooks with only incidental API code;
- deep-learning books that invoke GPU-enabled frameworks but do not teach GPU
  programming;
- general parallel-programming books with only one accelerator chapter.

## Remaining blind spots

The claim is explicitly **English-language, 2016-present**. Non-English
publishing is not covered by this audit.

The hardest remaining English-language blind spots are:

1. tiny self-published catalogs that are poorly indexed;
2. withdrawn editions whose publisher page disappeared;
3. books sold only through region-specific storefronts;
4. title changes between ebook and print editions;
5. independent books with no ISBN and unstable sales pages.

For that reason the repository says "try to enumerate every qualifying book"
rather than pretending an open-world bibliography can be proved complete.
