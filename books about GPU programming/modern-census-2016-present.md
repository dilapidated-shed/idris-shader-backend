# Modern GPU-programming book census, 2016-present

Observed and checked: 2026-09-23.

This is the completeness side of the repository's GPU-book collection.

## Coverage rule

For **2016 through the present**, missing qualifying books are bugs in this
catalog. 2016 is a pragmatic project boundary: it catches the Vulkan/explicit
API transition and keeps the modern census finite. It is not a claim that all
GPU hardware changed at once in 2016.

A work qualifies for the main census when it is an English-language,
book-length publication whose central subject is one or more of:

- programming GPUs for general-purpose computation;
- CUDA, HIP/ROCm, OpenCL, SYCL/DPC++, OpenACC, or OpenMP GPU offload;
- Metal, Vulkan, WebGPU, GLSL/HLSL, shaders, or another GPU-facing graphics
  programming interface;
- GPU architecture specifically written to inform programmers;
- ray-tracing/rendering collections whose material is substantially about
  programming contemporary GPUs.

Application books are included when they actually teach GPU programming rather
than merely call a framework that happens to use a GPU.

The main table is a census, **not a ranking**. Commercial books are link-only
unless their own license explicitly permits redistribution. Open-access status
is recorded separately and does not automatically imply a redistribution
license compatible with this repository.

## Census

| Year | Book / edition | Authors / editors | Main family | Access / notes | Stable source |
| --- | --- | --- | --- | --- | --- |
| 2016 | *GPU Pro 7: Advanced Rendering Techniques* | ed. Wolfgang Engel | shaders / rendering / GPU compute | commercial edited collection | [Routledge](https://www.routledge.com/GPU-Pro-7-Advanced-Rendering-Techniques/Engel/p/book/9781498742535) |
| 2016 | *Vulkan Programming Guide: The Official Guide to Learning Vulkan*, 1e | Graham Sellers; John Kessenich | Vulkan / SPIR-V | commercial; official first-generation Vulkan book | [Pearson](https://www.pearson.com/en-us/subject-catalog/p/Sellers-Vulkan-Programming-Guide-The-Official-Guide-to-Learning-Vulkan/P200000009086) |
| 2016 | *Parallel Programming with OpenACC* | Rob Farber | OpenACC / heterogeneous GPU computing | commercial | [Elsevier](https://shop.elsevier.com/books/parallel-programming-with-openacc/farber/978-0-12-410397-9) |
| 2016 | *Raspberry Pi GPU Audio Video Programming* | Jan Newmarch | VideoCore / OpenGL ES / OpenVG / OpenMAX | commercial; platform-specific GPU programming | [Springer](https://link.springer.com/book/10.1007/978-1-4842-2472-4) |
| 2017 | *Programming Massively Parallel Processors: A Hands-on Approach*, 3e | David B. Kirk; Wen-mei W. Hwu | CUDA / architecture / parallel patterns | commercial; CUDA 7.5-era edition | [ScienceDirect](https://www.sciencedirect.com/book/monograph/9780128119860/programming-massively-parallel-processors) |
| 2017 | *Vulkan Cookbook* | Paweł Łapinski | Vulkan / SPIR-V / compute | commercial; 700 pp. | [Packt](https://www.packtpub.com/en-us/product/vulkan-cookbook-9781786468154) |
| 2017 | *Metal Programming Guide: Tutorial and Reference via Swift* | Janie Clayton | Apple Metal / shaders / compute | commercial; includes Metal compute pipeline | [InformIT](https://www.informit.com/store/metal-programming-guide-tutorial-and-reference-via-9780134668949) |
| 2017 | *GPU Zen: Advanced Rendering Techniques* | ed. Wolfgang Engel | shaders / rendering / GPU compute | commercial edited collection | [series index](https://www.realtimerendering.com/resources/shaderx/) |
| 2018 | *GPU Parallel Program Development Using CUDA* | Tolga Soyata | CUDA / architecture / optimization | commercial | [Routledge](https://www.routledge.com/GPU-Parallel-Program-Development-Using-CUDA/Soyata/p/book/9781498750752) |
| 2018 | *General-Purpose Graphics Processor Architectures* | Tor M. Aamodt; Wilson Wai Lun Fung; Timothy G. Rogers | GPU architecture | commercial; programmer-relevant architecture reference | [Springer](https://link.springer.com/book/10.1007/978-3-031-01759-9) |
| 2018 | *Hands-On GPU Programming with Python and CUDA* | Brian Tuomanen | CUDA / PyCUDA / Python | commercial | [companion repository](https://github.com/PacktPublishing/Hands-On-GPU-Programming-with-Python-and-CUDA) |
| 2018 | *OpenGL 4 Shading Language Cookbook*, 3e | David Wolff | GLSL / compute shaders | commercial; GLSL 4.6 / SPIR-V-era edition | [Packt](https://www.packtpub.com/en-us/product/opengl-4-shading-language-cookbook-9781789342253) |
| 2018 | *Hands-On GPU-Accelerated Computer Vision with OpenCV and CUDA* | Bhaumik Vaidya | CUDA / OpenCV / PyCUDA | commercial; applied book that teaches CUDA kernels and GPU architecture | [Packt](https://www.packtpub.com/en-us/product/hands-on-gpu-accelerated-computer-vision-with-opencv-and-cuda-9781789343687) |
| 2019 | *GPU PRO 360 Guide to GPGPU* | ed. Wolfgang Engel | GPGPU / rendering | commercial anthology | [Routledge](https://www.routledge.com/GPU-PRO-360-Guide-to-GPGPU/Engel/p/book/9781138484412) |
| 2019 | *GPU Zen 2: Advanced Rendering Techniques* | ed. Wolfgang Engel | shaders / rendering / GPU compute | commercial edited collection | [series index](https://www.realtimerendering.com/resources/shaderx/) |
| 2019 | *Practical Shader Development: Vertex and Fragment Shaders for Game Developers* | Kyle Halladay | shaders / GLSL-HLSL concepts | commercial | [Springer/Apress](https://link.springer.com/book/10.1007/978-1-4842-4457-9) |
| 2019 | *Hands-On GPU Computing with Python* | Avimanyu Bandyopadhyay | CUDA / PyCUDA / CuPy / Numba | commercial | [Packt](https://www.packtpub.com/en-us/product/hands-on-gpu-computing-with-python-9781789341072) |
| 2019 | *Learn CUDA Programming* | Jaegeun Han; Bharatkumar Sharma | CUDA 10.x / C++ / Python | commercial book; companion code MIT-licensed | [companion repository](https://github.com/PacktPublishing/Learn-CUDA-Programming) |
| 2019 | *Ray Tracing Gems: High-Quality and Real-Time Rendering with DXR and Other APIs* | eds. Eric Haines; Tomas Akenine-Möller | GPU ray tracing / DXR | open access; book license must be checked before mirroring | [Springer/Apress](https://link.springer.com/book/10.1007/978-1-4842-4427-2) |
| 2020/2021 | *Data Parallel C++: Mastering DPC++ for Programming of Heterogeneous Systems using C++ and SYCL*, 1e | James Reinders et al. | SYCL / DPC++ / heterogeneous accelerators | open access; eBook published 2020, copyright 2021 | [Springer/Apress](https://link.springer.com/book/10.1007/978-1-4842-5574-2) |
| 2021 | *3D Graphics Rendering Cookbook* | Sergey Kosarevsky; Viktor Latypov | Vulkan / modern OpenGL / shaders | commercial; substantial Vulkan implementation content | [Packt](https://www.packtpub.com/en-GB/product/3d-graphics-rendering-cookbook-9781838986193) |
| 2021 | *Ray Tracing Gems II: Next Generation Real-Time Rendering with DXR, Vulkan, and OptiX* | eds. Adam Marrs; Peter Shirley; Ingo Wald | GPU ray tracing / DXR / Vulkan / OptiX | open access; verify exact redistribution terms before mirroring | [Springer/Apress](https://link.springer.com/book/10.1007/978-1-4842-7185-8) |
| 2022 | *Programming Massively Parallel Processors: A Hands-on Approach*, 4e | Wen-mei W. Hwu; David B. Kirk; Izzat El Hajj | CUDA / architecture / parallel patterns | commercial; includes Ampere-era material | [Elsevier](https://shop.elsevier.com/books/programming-massively-parallel-processors/hwu/978-0-323-91231-0) |
| 2022 | *Programming in Parallel with CUDA: A Practical Guide* | Richard Ansorge | CUDA / scientific computing | commercial | [Cambridge](https://www.cambridge.org/core/books/programming-in-parallel-with-cuda/0C6179F318B8E24A1B8EB6F2B7EFA92D) |
| 2022 | *Accelerated Computing with HIP* | Yifan Sun; Trinayan Baruah; David R. Kaeli | HIP / ROCm / multi-GPU | author-published textbook; AMD highlights it as a HIP textbook | [AMD](https://www.amd.com/en/blogs/2023/accelerated-computing-with-hip--textbook.html) |
| 2023 | *Mastering Graphics Programming with Vulkan* | Marco Castorina; Gabriel Sassone | Vulkan / GPU-driven rendering / ray tracing | commercial | [Packt](https://www.packtpub.com/en-us/product/mastering-graphics-programming-with-vulkan-9781803244792) |
| 2023 | *Programming Your GPU with OpenMP: Performance Portability for GPUs* | Tom Deakin; Timothy G. Mattson | OpenMP GPU offload | commercial | [MIT Press](https://mitpress.mit.edu/9780262547536/programming-your-gpu-with-openmp/) |
| 2023 | *Data Parallel C++: Programming Accelerated Systems Using C++ and SYCL*, 2e | James Reinders et al. | SYCL 2020 / heterogeneous accelerators | open access | [Springer/Apress](https://link.springer.com/book/10.1007/978-1-4842-9691-2) |
| 2023 | *WebGPU by Examples* | Jack Xu | WebGPU / WGSL | independently published; browser-facing GPU programming | [author site](https://drxudotnet.com/) |
| 2023 | *WGPU by Examples* | Jack Xu | wgpu / WGSL / Rust | independently published; native and web GPU programming | [author site](https://drxudotnet.com/) |
| 2024 | *CUDA Fortran for Scientists and Engineers: Best Practices for Efficient CUDA Fortran Programming*, 2e | Gregory Ruetsch; Massimiliano Fatica | CUDA Fortran / Hopper / multi-GPU | commercial; companion code is Apache-2.0 | [Elsevier](https://shop.elsevier.com/books/cuda-fortran-for-scientists-and-engineers/ruetsch/978-0-443-21977-1) |
| 2024 | *The Modern Vulkan Cookbook* | Preetish Kakkar; Mauricio Maurer | Vulkan / shaders / synchronization / ray tracing | commercial | [Packt](https://www.packtpub.com/en-US/product/the-modern-vulkan-cookbook-9781803239989) |
| 2024 | *The WebGPU Sourcebook: High-Performance Graphics and Machine Learning in the Browser* | Matthew Scarpino | WebGPU / compute shaders / browser GPU | commercial | [Google Books metadata](https://books.google.com/books?id=jiQeEQAAQBAJ) |
| 2024 | *GPU Zen 3: Advanced Rendering Techniques* | ed. Wolfgang Engel et al. | GPU-driven rendering / shaders / differentiable graphics | commercial/independently published edited collection | [series index](https://www.realtimerendering.com/resources/shaderx/) |
| 2025 | *GPU Programming with C++ and CUDA* | Paulo Motta | CUDA / C++ / optimization | commercial; published 2025-08-29 | [Packt](https://www.packtpub.com/en-us/product/gpu-programming-with-c-and-cuda-9781805124542) |
| 2025 | *Accelerated Computing with HIP*, 2e | Yifan Sun; Sabila Al Jannat; Trinayan Baruah; David R. Kaeli | HIP / ROCm / CUDA portability | author-published; 300 pp. | [William & Mary](https://news.wm.edu/2026/01/21/books-published-by-william-mary-faculty-in-2025/) |
| 2025 | *Vulkan 3D Graphics Rendering Cookbook*, 2e | Sergey Kosarevsky; Alexey Medvedev; Viktor Latypov | Vulkan 1.3 / bindless / compute | commercial; published 2025-02-14 | [Packt](https://www.packtpub.com/en-us/product/vulkan-3d-graphics-rendering-cookbook-9781803236612) |
| 2025 | *Ray Tracing in CUDA and DXR: An Introduction* | Fabio Suriano | CUDA / DXR / ray tracing | commercial | [Springer/Apress](https://link.springer.com/book/10.1007/979-8-8688-1691-8) |
| 2026 | *Programming Massively Parallel Processors: A Hands-on Approach*, 5e | Wen-mei W. Hwu; David B. Kirk; Izzat El Hajj | CUDA / architecture / parallel patterns | commercial; current edition, released 2026 | [Elsevier](https://shop.elsevier.com/books/programming-massively-parallel-processors/hwu/978-0-443-43900-1) |
| 2026 | *GPU Zen 4: Advanced Rendering Techniques* | ed. Wolfgang Engel et al. | GPU rendering / ray tracing / neural GPU work | commercial/independently published edited collection | [series index](https://www.realtimerendering.com/resources/shaderx/) |
| 2026 | *GPU-Accelerated Computing with Python 3 and CUDA* | Niels Cautaerts; Hossein Ghorbanfekr | CUDA / Python / scientific computing | commercial | [Packt](https://www.packtpub.com/en-us/product/gpu-accelerated-computing-with-python-3-and-cuda-9781803245423) |

## Living book-style references

These are book-length references but do not fit neatly into a conventional
publication-year census.

| Work | Why it belongs here | Source |
| --- | --- | --- |
| *AMD ROCm Programming Guide* | Official book-style HIP/ROCm programming reference covering kernels, memory, optimization, patterns, and multi-GPU programming. | [AMD ROCm](https://rocm-handbook.amd.com/) |

Ordinary API specifications and vendor manuals are not counted as books merely
because they are long. They can still be linked from individual book notes.

## Adjacent books: tracked, not counted in the main census

These can be excellent GPU references, but their central subject is broader
than GPU programming. Keeping them visible prevents accidental rediscovery
without inflating the main count.

- *Real-Time Rendering*, 4e (2018).
- *Physically Based Rendering: From Theory to Implementation*, 3e (2016) and
  4e (2023).
- *Introduction to 3D Game Programming with DirectX 12* and its 2025 second
  edition.
- *Computer Graphics Programming in OpenGL with C++*, including the 2024 third
  edition.
- general parallel-programming books that contain CUDA/OpenCL/SYCL chapters but
  do not primarily teach GPU programming.
- deep-learning books that merely call CUDA-enabled frameworks without teaching
  kernel-level or GPU-programming concepts.

## Forthcoming, therefore not yet counted

As of 2026-09-23:

- Elliot Arledge, *CUDA for Deep Learning* (Manning), publisher publication date
  2026-10-27. It is already available in early-access form and plainly qualifies
  once formally published.
- Mahesh Venkitachalam, *The Book of WebGPU* (No Starch Press), scheduled for
  2027, likewise belongs in the census when published.

## Search gaps still worth attacking

A comprehensive catalog is a maintained assertion, not a one-time search.
Future sweeps should specifically look for:

1. independently published CUDA/HIP books with stable ISBNs;
2. non-Packt Vulkan/WebGPU books that general searches under-rank;
3. university-press GPU/HPC texts whose titles do not contain "GPU";
4. revised editions that replace, rather than merely reprint, an older entry;
5. books first published outside the US whose English edition is easy to miss.

When a new qualifying title is found, add it here even if it is mediocre. The
pre-2016 file is selective; this file is not.
