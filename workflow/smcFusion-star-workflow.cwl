#!/usr/bin/env cwl-runner
#
# Authors: Thomas Yu, Ryan Spangler, Kyle Ellrott

class: Workflow
cwlVersion: v1.0

doc: "STAR workflow: untar, STAR align, STAR fusion detection, convert to bedpe format"

hints:
  - class: synData
    input: index
    entity: syn5987269

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
    outputSource: converttobedpe/fusionout

steps:

  tar:
    run: ../general_tools/tar.cwl
    in:
      input: index
    out: [output]

  star:
    run: ../star/cwl/STAR.cwl
    in:
      twopassMode: { default: Basic }
      outReadsUnmapped: { default: None }
      chimSegmentMin: { default: 12 }
      chimJunctionOverhangMin: { default: 12 }
      alignSJDBoverhangMin: { default: 10 }
      alignMatesGapMax: { default: 200000 }
      alignIntronMax: { default: 200000 }
      chimSegmentReadGapMax: { default: parameter }
      chim2: { default: 3 }
      alignSJstitchMismatchNmax: { default: 5 }
      align2: { default: -1 }
      align3: { default: 5 }
      align4: { default: 5 }
      runThreadN: { default: 5 }
      limitBAMsortRAM: { default : "31532137230" }
      outSAMtype: { default: BAM }
      outSAMsecond: { default: SortedByCoordinate }
      readFilesCommand: { default: zcat }
      index: tar/output
      fastq1: TUMOR_FASTQ_1
      fastq2: TUMOR_FASTQ_2
    out: [output]

  starfusion:
    run: ../star/cwl/STAR-fusion.cwl
    in:
      index: tar/output
      J: star/output
      output_dir: { default: starOut }
      threads: { default: 5 }
    out: [output]

  converttobedpe:
    run: ../star/cwl/converter.cwl
    in:
      input: starfusion/output
      output: { default: "output.bedpe" }
    out: [fusionout]