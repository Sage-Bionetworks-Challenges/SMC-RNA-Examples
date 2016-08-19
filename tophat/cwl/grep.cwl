#!/usr/bin/env cwl-runner
#
# Authors: Thomas Yu, Ryan Spangler, Kyle Ellrott

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [grep]
stdout: $(inputs.output_filename_prefix + '_filtered_fusion.bedpe')

doc: "command line: grep"

requirements:
  - class: InlineJavascriptRequirement

inputs:
  
  input:
    type: File
    inputBinding:
      position: 3

  v:
    type: boolean?
    inputBinding:
      prefix: -v
      position: 1

  pattern:
    type: string
    inputBinding:
      position: 2

  - id: output_filename_prefix
    type: string

outputs:

  output:
    type: File
    outputBinding:
      glob: $(inputs.output_filename_prefix + 'filtered_fusion.bedpe')