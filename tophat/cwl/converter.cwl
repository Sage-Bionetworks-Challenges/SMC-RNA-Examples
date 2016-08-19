#!/usr/bin/env cwl-runner
#
# Authors: Thomas Yu, Ryan Spangler, Kyle Ellrott

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [convert_tophat_to_bedpe.py]
stdout: $(inputs.output_filename)

doc: "Convert tophat output to bedpe format"

hints:
  DockerRequirement:
    dockerPull: dreamchallenge/tophat

requirements:
  - class: InlineJavascriptRequirement

inputs:

  input:
    type: File
    inputBinding:
      position: 1

  output_filename:
    type: string

outputs:

  fusionout:
    type: File
    outputBinding:
      glob: $(inputs.output_filename)