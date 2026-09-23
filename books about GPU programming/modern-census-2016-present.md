# Modern GPU-programming book census, 2016-present

Observed and re-audited: 2026-09-23.

This is the completeness side of the repository's GPU-book collection. It is an
index, not a reading assignment and not a ranking.

The census has two files:

- this file: conventional publishers, major series, and broadly distributed
  books;
- [independent / long-tail books](modern-census-independent-long-tail.md):
  self-published, author-published, Leanpub, and other easily missed books.

The search procedure and remaining blind spots are recorded in
[the 2026-09-23 audit](modern-census-audit-2026-09-23.md).

## Coverage rule

For **2016 through the present**, missing qualifying English-language books are
catalog bugs. 2016 is a pragmatic project boundary, not a claim that every GPU
architecture changed discontinuously in that year.

A work qualifies when its central subject is one or more of:

- general-purpose GPU programming;
- CUDA, HIP/ROCm, OpenCL, SYCL/DPC++, OpenACC, or OpenMP GPU offload;
- Vulkan/SPIR-V, Metal, Direct3D/HLSL, OpenGL/GLSL, WebGL, WebGPU/WGSL, wgpu,
  or another GPU-facing programming interface;
- GPU architecture written to inform programmers;
- GPU ray tracing or rendering collections substantially concerned with
  programming contemporary GPUs.

Graphics-API books count. Programming shaders, resources, synchronization,
memory, command submission, and compute pipelines is GPU programming even when
the result is an image.

Application books count only when they actually teach GPU programming rather
than merely call a framework that happens to use a GPU.

Commercial books are link-only unless their own license explicitly permits
redistribution. Open-access status does not by itself establish a repository-
compatible redistribution license.

## Census

| Year | Book / edition | Authors / editors | Main family | Notes / source |
| --- | --- | --- | --- | --- |
| 2016 | *OpenGL Programming Guide: The Official Guide to Learning OpenGL, Version 4.5 with SPIR-V*, 9e | John Kessenich; Graham Sellers; Dave Shreiner | OpenGL / GLSL / SPIR-V / compute shaders | 976 pp.; [InformIT](https://www.informit.com/store/opengl-programming-guide-the-official-guide-to-learning-9780134495491) |
| 2016 | *Vulkan Programming Guide: The Official Guide to Learning Vulkan*, 1e | Graham Sellers; John Kessenich | Vulkan / SPIR-V | [InformIT](https://www.informit.com/store/vulkan-programming-guide-the-official-guide-to-learning-9780134464541) |
| 2016 | *Learning Vulkan* | Parminder Singh | Vulkan / SPIR-V | 466 pp.; [Packt](https://www.packtpub.com/en-us/product/learning-vulkan-9781786460844) |
| 2016 | *Introduction to 3D Game Programming with DirectX 12*, 1e | Frank D. Luna | Direct3D 12 / HLSL | low-level D3D12 programming; [independent bibliography cross-check](https://www.realtimerendering.com/books.html) |
| 2016 | *GPU Pro 7: Advanced Rendering Techniques* | ed. Wolfgang Engel | shaders / rendering / GPU compute | commercial edited collection |
| 2016 | *Parallel Programming with OpenACC* | Rob Farber | OpenACC / heterogeneous GPU computing | [Elsevier](https://shop.elsevier.com/books/parallel-programming-with-openacc/farber/978-0-12-410397-9) |
| 2016 | *Raspberry Pi GPU Audio Video Programming* | Jan Newmarch | VideoCore / OpenGL ES / OpenVG / OpenMAX | platform-specific GPU programming; [Springer](https://link.springer.com/book/10.1007/978-1-4842-2472-4) |
| 2017 | *Programming Massively Parallel Processors: A Hands-on Approach*, 3e | David B. Kirk; Wen-mei W. Hwu | CUDA / architecture / parallel patterns | publisher records straddle 2016/2017; [ScienceDirect](https://www.sciencedirect.com/book/monograph/9780128119860/programming-massively-parallel-processors) |
| 2017 | *CUDA Programming: A Developer's Guide to Parallel Computing with GPUs*, 2e | Shane Cook | CUDA | fully revised second edition; [Elsevier](https://shop.elsevier.com/books/cuda-programming/cook/978-0-12-802879-7) |
| 2017 | *Vulkan Cookbook* | Paweł Łapinski | Vulkan / SPIR-V / compute | 700 pp.; [Packt](https://www.packtpub.com/en-us/product/vulkan-cookbook-9781786468154) |
| 2017 | *Metal Programming Guide: Tutorial and Reference via Swift* | Janie Clayton | Metal / shaders / compute | published 2017-12-26; 352 pp.; [InformIT](https://www.informit.com/store/metal-programming-guide-tutorial-and-reference-via-9780134668949) |
| 2017 | *WebGL Gems* | Greg Sidelnikov | WebGL / GLSL | 397 pp.; Learning Curve / independent publication |
| 2017 | *GPU Zen: Advanced Rendering Techniques* | ed. Wolfgang Engel | shaders / rendering / GPU compute | edited collection; [series index](https://www.realtimerendering.com/resources/shaderx/) |
| 2018 | *GPU Parallel Program Development Using CUDA* | Tolga Soyata | CUDA / architecture / optimization | [Routledge](https://www.routledge.com/GPU-Parallel-Program-Development-Using-CUDA/Soyata/p/book/9781498750752) |
| 2018 | *General-Purpose Graphics Processor Architectures* | Tor M. Aamodt; Wilson Wai Lun Fung; Timothy G. Rogers | GPU architecture | programmer-relevant architecture reference; [Springer](https://link.springer.com/book/10.1007/978-3-031-01759-9) |
| 2018 | *Hands-On GPU Programming with Python and CUDA* | Brian Tuomanen | CUDA / PyCUDA / Python | 310 pp.; [Packt](https://www.packtpub.com/en-us/product/hands-on-gpu-programming-with-python-and-cuda-9781788995221) |
| 2018 | *OpenGL 4 Shading Language Cookbook*, 3e | David Wolff | GLSL / compute shaders | [Packt](https://www.packtpub.com/en-us/product/opengl-4-shading-language-cookbook-9781789340662) |
| 2018 | *Hands-On GPU-Accelerated Computer Vision with OpenCV and CUDA* | Bhaumik Vaidya | CUDA / OpenCV / PyCUDA | applied book with direct CUDA programming |
| 2018 | *Metal by Tutorials*, 1e | Caroline Begbie; Marius Horga | Metal / shaders / compute | full release 2018-10-08; later editions below; [Kodeco](https://www.kodeco.com/books/metal-by-tutorials/v5.0) |
| 2018 | *Real-Time 3D Graphics with WebGL 2*, 2e | Farhad Ghayour; Diego Cantor | WebGL 2 / GLSL | 500 pp.; [Packt](https://www.packtpub.com/en-us/product/real-time-3d-graphics-with-webgl-2-9781788837873) |
| 2018–2019 | *GPU Pro 360 Guide* series: *Rendering*, *Shadows*, *Geometry Manipulation*, *GPGPU*, *Mobile Devices*, *3D Engine Design*, *Lighting*, *Image Space* | ed. Wolfgang Engel | GPU rendering / GPGPU | eight topical anthologies repackaging material from GPU Pro 1–7; e.g. [Rendering](https://www.routledge.com/GPU-Pro-360-Guide-to-Rendering/Engel/p/book/9780815365501), [GPGPU](https://www.routledge.com/GPU-PRO-360-Guide-to-GPGPU/Engel/p/book/9781138484399) |
| 2019 | *GPU Zen 2: Advanced Rendering Techniques* | ed. Wolfgang Engel | shaders / rendering / GPU compute | edited collection; [series index](https://www.realtimerendering.com/resources/shaderx/) |
| 2019 | *Practical Shader Development: Vertex and Fragment Shaders for Game Developers* | Kyle Halladay | shaders / GLSL-HLSL concepts | [Springer/Apress](https://link.springer.com/book/10.1007/978-1-4842-4457-9) |
| 2019 | *Hands-On GPU Computing with Python* | Avimanyu Bandyopadhyay | CUDA / PyCUDA / CuPy / Numba | [Packt](https://www.packtpub.com/en-us/product/hands-on-gpu-computing-with-python-9781789341072) |
| 2019 | *Learn CUDA Programming* | Jaegeun Han; Bharatkumar Sharma | CUDA 10.x / C++ / Python | commercial book; companion code MIT-licensed; [companion repository](https://github.com/PacktPublishing/Learn-CUDA-Programming) |
| 2019 | *Ray Tracing Gems* | eds. Eric Haines; Tomas Akenine-Möller | GPU ray tracing / DXR | open access; [Springer/Apress](https://link.springer.com/book/10.1007/978-1-4842-4427-2) |
| 2020 | *The CUDA Handbook: A Comprehensive Guide to GPU Programming*, 2e | Nicholas Wilt | CUDA / architecture / algorithms | 528 pp.; [InformIT](https://www.informit.com/store/cuda-handbook-a-comprehensive-guide-to-gpu-programming-9780134852874) |
| 2020 | *Metal by Tutorials*, 2e | Caroline Begbie; Marius Horga | Metal / shaders / compute | Kodeco release 2020-01-16 |
| 2020 | *Learn OpenGL — Graphics Programming* | Joey de Vries | OpenGL / GLSL | book form of the long-running tutorial; [book site](https://learnopengl.com/book/book_pdf.pdf) |
| 2020/2021 | *Data Parallel C++: Mastering DPC++ for Programming of Heterogeneous Systems using C++ and SYCL*, 1e | James Reinders et al. | SYCL / DPC++ / heterogeneous accelerators | eBook 2020, copyright 2021; [Springer/Apress](https://link.springer.com/book/10.1007/978-1-4842-5574-2) |
| 2021 | *Hands-On GPU programming with CUDA C and Python 3*, 2e | Brian Tuomanen | CUDA C / Python / PyCUDA | 341 pp.; ISBN 9781839214530; withdrawn from sale after publication |
| 2021 | *3D Graphics Rendering Cookbook* | Sergey Kosarevsky; Viktor Latypov | Vulkan / modern OpenGL / shaders | substantial Vulkan implementation content; [Packt](https://www.packtpub.com/en-gb/product/3d-graphics-rendering-cookbook-9781838986193) |
| 2021 | *Ray Tracing Gems II* | eds. Adam Marrs; Peter Shirley; Ingo Wald | GPU ray tracing / DXR / Vulkan / OptiX | open access; [Springer/Apress](https://link.springer.com/book/10.1007/978-1-4842-7185-8) |
| 2021 | *Practical WebGPU Graphics* | Jack Xu | WebGPU / WGSL / compute | UniCAD; 445 pp.; ISBN 9798725062625; [author index](https://drxudotnet.com/) |
| 2021 | *Developing Graphics Frameworks with Python and OpenGL* | Lee Stemkoski; Michael Pascale | OpenGL / GLSL / Python | GPU-facing framework construction; [independent bibliography cross-check](https://www.realtimerendering.com/books.html) |
| 2021 | *Computer Graphics Programming in OpenGL with Java*, 3e | V. Scott Gordon; John L. Clevenger | OpenGL / GLSL / Java | [independent bibliography cross-check](https://www.realtimerendering.com/books.html) |
| 2022 | *Programming Massively Parallel Processors: A Hands-on Approach*, 4e | Wen-mei W. Hwu; David B. Kirk; Izzat El Hajj | CUDA / architecture / parallel patterns | Ampere-era material; [Elsevier](https://shop.elsevier.com/books/programming-massively-parallel-processors/hwu/978-0-323-91231-0) |
| 2022 | *Programming in Parallel with CUDA: A Practical Guide* | Richard Ansorge | CUDA / scientific computing | [Cambridge](https://www.cambridge.org/core/books/programming-in-parallel-with-cuda/C43652A69033C25AD6933368CDBE084C) |
| 2022 | *Accelerated Computing with HIP* | Yifan Sun; Trinayan Baruah; David R. Kaeli | HIP / ROCm / multi-GPU | author-published textbook; [AMD](https://www.amd.com/en/blogs/2023/accelerated-computing-with-hip--textbook.html) |
| 2022 | *Metal by Tutorials*, 3e | Caroline Begbie; Marius Horga | Metal / shaders / compute | released 2022-04-06; ISBN 9781950325641 |
| 2022 | *Practical GPU Graphics with wgpu and Rust* | Jack Xu | wgpu / WGSL / Rust | ISBN 9798404949377; [author page](https://drxudotnet.com/) |
| 2022 | *Practical GPU Graphics with wgpu-py and Python* | Jack Xu | wgpu-py / WGSL / Python | ISBN 9798832139647; [author page](https://drxudotnet.com/) |
| 2022 | *Developing Graphics Frameworks with Java and OpenGL* | Lee Stemkoski; Michael Pascale | OpenGL / GLSL / Java | [independent bibliography cross-check](https://www.realtimerendering.com/books.html) |
| 2022 | *Computer Graphics Through OpenGL: From Theory to Experiments*, 4e | Sumanta Guha | OpenGL 4.x / GLSL / WebGL 2 | 676 pp.; published 2022-12-15 |
| 2023 | *Mastering Graphics Programming with Vulkan* | Marco Castorina; Gabriel Sassone | Vulkan / GPU-driven rendering / ray tracing | [Packt](https://www.packtpub.com/en-us/product/mastering-graphics-programming-with-vulkan-9781803244792) |
| 2023 | *Programming Your GPU with OpenMP: Performance Portability for GPUs* | Tom Deakin; Timothy G. Mattson | OpenMP GPU offload | [MIT Press](https://mitpress.mit.edu/9780262547536/programming-your-gpu-with-openmp/) |
| 2023 | *Data Parallel C++: Programming Accelerated Systems Using C++ and SYCL*, 2e | James Reinders et al. | SYCL 2020 / heterogeneous accelerators | open access; [Springer/Apress](https://link.springer.com/book/10.1007/978-1-4842-9691-2) |
| 2023 | *WebGPU by Examples* | Jack Xu | WebGPU / WGSL | ISBN 9798394130496; [author page](https://drxudotnet.com/Home/BookDetails?bookId=58) |
| 2023 | *WGPU by Examples* | Jack Xu | wgpu / WGSL / Rust | ISBN 9798864220252; [author page](https://drxudotnet.com/) |
| 2023 | *WebGPU and Compute Shaders for Real-Time Graphics* | Jack Xu | WebGPU / compute shaders | published 2023-08-23 |
| 2023 | *Metal by Tutorials*, 4e | Caroline Begbie; Marius Horga | Metal / shaders / compute / ray tracing | released 2023-12-13; [Kodeco](https://www.kodeco.com/books/metal-by-tutorials/v4.0) |
| 2024 | *CUDA Fortran for Scientists and Engineers*, 2e | Gregory Ruetsch; Massimiliano Fatica | CUDA Fortran / Hopper / multi-GPU | [Elsevier](https://shop.elsevier.com/books/cuda-fortran-for-scientists-and-engineers/ruetsch/978-0-443-21977-1) |
| 2024 | *The Modern Vulkan Cookbook* | Preetish Kakkar; Mauricio Maurer | Vulkan / shaders / synchronization / ray tracing | [Packt](https://www.packtpub.com/en-US/product/the-modern-vulkan-cookbook-9781803239989) |
| 2024/2025 | *The WebGPU Sourcebook: High-Performance Graphics and Machine Learning in the Browser* | Matthew Scarpino | WebGPU / WGSL / compute | released in 2024 catalogs; publisher copyright 2025; 384 pp.; [CRC/Routledge](https://www.routledge.com/The-WebGPU-Sourcebook-High-Performance-Graphics-and-Machine-Learning-in-the-Browser/Scarpino/p/book/9781032726670) |
| 2024 | *GPU Zen 3: Advanced Rendering Techniques* | ed. Wolfgang Engel et al. | GPU-driven rendering / shaders / differentiable graphics | November 2024; [series index](https://www.realtimerendering.com/books.html) |
| 2024 | *Computer Graphics Programming in OpenGL with C++*, 3e | V. Scott Gordon; John L. Clevenger | OpenGL / GLSL / compute shaders | February 2024; [independent bibliography cross-check](https://www.realtimerendering.com/books.html) |
| 2025 | *GPU Programming with C++ and CUDA* | Paulo Motta | CUDA / C++ / optimization | 270 pp.; published 2025-08-29; [Packt](https://www.packtpub.com/en-us/product/gpu-programming-with-c-and-cuda-9781805128823) |
| 2025 | *Accelerated Computing with HIP*, 2e | Yifan Sun; Sabila Al Jannat; Trinayan Baruah; David R. Kaeli | HIP / ROCm / CUDA portability | 300 pp.; [William & Mary](https://news.wm.edu/2026/01/21/books-published-by-william-mary-faculty-in-2025/) |
| 2025 | *Vulkan 3D Graphics Rendering Cookbook*, 2e | Sergey Kosarevsky; Alexey Medvedev; Viktor Latypov | Vulkan 1.3 / bindless / compute | 714 pp.; published 2025-02-14; [Packt](https://www.packtpub.com/en-us/product/vulkan-3d-graphics-rendering-cookbook-9781803236612) |
| 2025 | *Ray Tracing in CUDA and DXR: An Introduction* | Fabio Suriano | CUDA / DXR / ray tracing | [Springer/Apress](https://link.springer.com/book/10.1007/979-8-8688-1691-8) |
| 2025 | *Introduction to 3D Game Programming with DirectX 12*, 2e | Frank D. Luna | Direct3D 12 / HLSL / mesh shaders / DXR | 1,094 pp.; published 2025-08-29; [independent bibliography cross-check](https://www.realtimerendering.com/books.html) |
| 2025 | *Metal by Tutorials*, 5e | Marius Horga; Caroline Begbie | Metal 3 / compute / GPU-driven rendering / mesh shaders | released 2025-11-20/21; [Kodeco](https://www.kodeco.com/books/metal-by-tutorials/v5.0) |
| 2025 | *Programming with wgpu in Rust: The Complete Guide for Developers and Engineers* | William Smith | wgpu / WGSL / Rust | HiTeX Press; published 2025-08-20 |
| 2026 | *Programming Massively Parallel Processors: A Hands-on Approach*, 5e | Wen-mei W. Hwu; David B. Kirk; Izzat El Hajj | CUDA / architecture / parallel patterns | current edition; [Elsevier](https://shop.elsevier.com/books/programming-massively-parallel-processors/hwu/978-0-443-43900-1) |
| 2026 | *GPU Zen 4: Advanced Rendering Techniques* | ed. Wolfgang Engel et al. | GPU rendering / ray tracing / neural GPU work | published 2026-02-17; 367 pp.; ISBN 9798248315277 |
| 2026 | *GPU-Accelerated Computing with Python 3 and CUDA* | Niels Cautaerts; Hossein Ghorbanfekr | CUDA / Python / scientific computing | 534 pp.; published 2026-03-31; [Packt](https://www.packtpub.com/en-gb/product/gpu-accelerated-computing-with-python-3-and-cuda-9781803248103) |
| 2026 | *The Book of WebGPU* | Mahesh Venkitachalam | WebGPU / WGSL / compute | eBook published **2026-09-22**; 400 pp.; paperback follows 2026-10-20; [publisher/distributor record](https://www.penguin.com.au/books/the-book-of-webgpu-9781718504332) |

The [independent long-tail file](modern-census-independent-long-tail.md) adds
self-published and completed digital books that mainstream publisher searches
miss, including a dense 2024–2025 WebGPU/WGSL cluster and several 2026 CUDA and
Vulkan books.

## Living book-style references

These are book-length references but do not fit neatly into a conventional
publication-year census.

| Work | Why it belongs here | Source |
| --- | --- | --- |
| *AMD ROCm Programming Guide* | official book-style HIP/ROCm programming reference covering kernels, memory, optimization, patterns, and multi-GPU programming | [AMD ROCm](https://rocm-handbook.amd.com/) |
| *Raw DirectX 12* | long-form Direct3D 12 resource covering rasterization, compute and ray tracing | [project](https://alain.xyz/blog/raw-directx12) |

Ordinary API specifications and vendor manuals are not counted as books merely
because they are long. They can still be linked from individual book notes.

## Adjacent books: tracked, not counted

These can be excellent GPU references, but their central subject is broader
than programming a GPU or GPU-facing API.

- *Real-Time Rendering*, 4e (2018).
- *Physically Based Rendering: From Theory to Implementation*, 3e (2016) and
  4e (2023).
- general computer-graphics textbooks where API/shader programming is only a
  small fraction of the book.
- general parallel-programming books with only one CUDA/OpenCL/SYCL chapter.
- deep-learning books that merely call CUDA-enabled frameworks without teaching
  kernel-level or GPU-programming concepts.

## Forthcoming, therefore not yet counted

As of 2026-09-23:

- Elliot Arledge, *CUDA for Deep Learning* (Manning), scheduled 2026-10-27.
- SungHwan Yun, *Grokking Parallel Programming: With Examples in CUDA*
  (Manning), MEAP begun September 2026, estimated publication early 2027.
- Kuldeep Singh Kaswan et al., *Introduction to GPU Programming*
  (Chapman & Hall/CRC), copyright/publication cycle 2027.

## Coverage notes

Repeated dedicated searches found no obvious post-2016 OpenCL-only publishing
wave comparable to CUDA, Vulkan, or WebGPU. Likewise, the identified
SYCL/DPC++ and HIP/ROCm book corpora remain relatively small. That negative
result is recorded in the audit rather than silently assuming those families
were covered.

A new qualifying title should be added even if it is mediocre, obscure,
commercial, self-published, or irrelevant to current repository work. Notes on
the contents are a separate decision.
