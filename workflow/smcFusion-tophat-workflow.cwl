#!/usr/bin/env cwl-runner
#
# Authors: Thomas Yu, Ryan Spangler, Kyle Ellrott

class: Workflow

cwlVersion: "draft-3"

description:
  creates custom genome from reference genome and two phased VCF files SNPs and Indels

hints:
  - class: synData
    input: index
    entity: syn5909383

inputs: 

  - id: index
    type: File

  - id: TUMOR_FASTQ_1
    type: File

  - id: TUMOR_FASTQ_2
    type: File
    
outputs:

  - id: OUTPUT
    type: File
    source: "#filterbedpe/output"

steps:

  - id: tar
    run: ../tophat/cwl/tar.cwl
    inputs:
    - {id: index, source: "#index"}  
    outputs:
    - {id: output}

  - id: tophat
    run: ../tophat/cwl/tophat.cwl
    inputs:
    - {id: p, default: 5}
    - {id: r, default: 0}
    - {id: fusion-search, default: true}
    - {id: keep-fasta-order, default: true}
    - {id: bowtie1, default: true}
    - {id: mate-std-dev, default: 80}
    - {id: o, default: tophat_out}
    - {id: max-intron-length, default: 100000}
    - {id: fusion-min-dist, default: 100000}
    - {id: fusion-anchor-length, default: 13}
    - {id: fusion-ignore-chromosomes, default: chrM}
    - {id: bowtie_index, source: "#tar/output"}
    - {id: fastq1, source: "#TUMOR_FASTQ_1"}
    - {id: fastq2, source: "#TUMOR_FASTQ_2"}
    outputs:
    - {id: tophatOut}

  - id: converttobedpe
    run: ../tophat/cwl/converter.cwl
    inputs:
    - {id: input, source: "#tophat/tophatOut"}
    - {id: output_filename: "output.bedpe"}
    outputs:
    - {id: fusionout}

  - id: filterbedpe
    run: ../tophat/cwl/grep.cwl
    inputs:
    - {id: input, source: "#converttobedpe/fusionout"}
    - {id: v, default: true}
    - {id: pattern, default: MT}
    - {id: output_filename_prefix, default: "output"}
    outputs:
    - {id: output}
