#!/usr/bin/env cwl-runner

cwlVersion: "draft-3"

class: CommandLineTool

description: "Convert tophat output to bedpe format"

requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: dreamchallenge/tophat

inputs:

  - id: input
    type: File
    inputBinding:
      position: 1

  - id: output_filename
    type: string

outputs:
  - id: fusionout
    type: File
    outputBinding:
      glob: $(inputs.output_filename)

stdout: $(inputs.output_filename)

baseCommand: [convert_tophat_to_bedpe.py]
