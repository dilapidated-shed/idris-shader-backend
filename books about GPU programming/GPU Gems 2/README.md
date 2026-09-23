# GPU Gems 2

Matt Pharr, editor; Randima Fernando, series editor. NVIDIA/Addison-Wesley,
2005.

## Rights status

NVIDIA makes the whole book readable online, but the copyright page says the
book is © 2005 NVIDIA Corporation and all rights are reserved. We therefore do
**not** mirror the book text here.

Live book/copyright page:

https://developer.nvidia.com/gpugems/gpugems2/copyright

## Chapters most useful here

These are live NVIDIA chapter pages. The descriptions below are our summaries.

- Chapter 31, *Mapping Computational Concepts to GPUs*  
  https://developer.nvidia.com/gpugems/gpugems2/part-iv-general-purpose-computation-gpus-primer/chapter-31-mapping-computational  
  Maps ordinary computation onto the graphics-era stream/fragment model:
  arithmetic intensity, gather/scatter, textures, render-to-texture, and
  fragment processors.

- Chapter 32, *Taking the Plunge into GPU Computing*  
  https://developer.nvidia.com/gpugems/gpugems2/part-iv-general-purpose-computation-gpus-primer/chapter-32-taking-plunge-gpu  
  Practical entry into GPGPU under the older graphics-pipeline programming
  model.

- Chapter 33, *Implementing Efficient Parallel Data Structures on GPUs*  
  https://developer.nvidia.com/gpugems/gpugems2/part-iv-general-purpose-computation-gpus-primer/chapter-33-implementing-efficient  
  Data layout and parallel structures under GPU memory/access constraints.

- Chapter 34, *GPU Flow-Control Idioms*  
  https://developer.nvidia.com/gpugems/gpugems2/part-iv-general-purpose-computation-gpus-primer/chapter-34-gpu-flow-control-idioms  
  Especially relevant to the backend's control-flow/lowering work: how
  branching and looping interact with GPU execution.

- Chapter 35, *GPU Program Optimization*  
  https://developer.nvidia.com/gpugems/gpugems2/part-iv-general-purpose-computation-gpus-primer/chapter-35-gpu-program-optimization  
  Organizing computation and data movement so the GPU does useful work rather
  than paying avoidable transfer or pipeline costs.

- Chapter 36, *Stream Reduction Operations for GPGPU Applications*  
  https://developer.nvidia.com/gpugems/gpugems2/part-iv-general-purpose-computation-gpus-primer/chapter-36-stream-reduction  
  Reduction as a multi-pass data-parallel primitive.

- Chapter 44, *A GPU Framework for Solving Systems of Linear Equations*  
  https://developer.nvidia.com/gpugems/gpugems2/part-vi-simulation-and-numerical-algorithms/chapter-44-gpu-framework-solving  
  The most directly numerical chapter in this group: GPU representations of
  vectors/matrices, matrix-vector operations, and iterative linear solving
  through fragment-program passes.

## Bibliographies and acknowledgments

The public NVIDIA chapter pages expose their own reference sections, and the
book's public front matter includes contributor/acknowledgment information.
Those pages are linked rather than copied. A bibliography being publicly
visible is not, by itself, a redistribution license for the publisher's
formatted bibliography.

For durable credit work, prefer extracting the underlying bibliographic facts
into our own attribution records rather than copying the publisher's page
wholesale.
