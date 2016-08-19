#!/usr/bin/env cwl-runner
#
# Authors: Thomas Yu, Ryan Spangler, Kyle Ellrott

class: Workflow
cwlVersion: v1.0

doc: "tophat workflow: untar, tophat alignment, converting to bedpe, filter out bedpe"

hints:
  - class: synData
    input: index
    entity: syn5909383

inputs: 

  index:
    type: File

  TUMOR_FASTQ_1:
    type: File

  TUMOR_FASTQ_2:
    type: File
    
outputs:

  OUTPUT:
    type: File
    outputSource: "#filterbedpe/output"

steps:

  tar:
    run: ../general_tools/tar.cwl
    in:
      input: index
    out: [output]

  tophat:
    run: ../tophat/cwl/tophat.cwl
    in:
      p: { default: 5 }
      r: { default: 0 }
      fusion-search: { default: true }
      keep-fasta-order: { default: true }
      bowtie1: { default: true }
      mate-std-dev: { default: 80 }
      o: { default: tophat_out }
      max-intron-length: { default: 100000 }
      fusion-min-dist: { default: 100000 }
      fusion-anchor-length: { default: 13 }
      fusion-ignore-chromosomes: { default: chrM }
      bowtie_index: tar/output
      fastq1: TUMOR_FASTQ_1
      fastq2: TUMOR_FASTQ_2
    out: [tophatOut_fusions]

  converttobedpe:
    run: ../tophat/cwl/converter.cwl
    in:
      input: tophat/tophatOut_fusions
      output_filename: { default: "output.bedpe" }
    out: [fusionout]

  filterbedpe:
    run: ../tophat/cwl/grep.cwl
    in:
      input: converttobedpe/fusionout
      v: { default: true }
      pattern: { default: MT }
      output_filename_prefix: { default: "output" }
    out: [output]