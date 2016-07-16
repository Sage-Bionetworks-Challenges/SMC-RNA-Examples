#!/usr/bin/env cwl-runner

cwlVersion: "draft-3"

class: CommandLineTool

description: "command line: grep"

requirements:
  - class: InlineJavascriptRequirement

inputs:
  
  - id: input
    type: File
    inputBinding:
      position: 3

  - id: v
    type: ["null",boolean]
    inputBinding:
      prefix: -v
      position: 1

  - id: pattern
    type: string
    inputBinding:
      position: 2

  - id: output_filename_prefix
    type: string

outputs:
  - id: output
    type: File
    outputBinding:
      glob: $(inputs.output_filename_prefix + 'filtered_fusion.bedpe')

stdout: $(inputs.output_filename_prefix + '_filtered_fusion.bedpe')

baseCommand: [grep]

