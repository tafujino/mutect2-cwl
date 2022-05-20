#!/usr/bin/env cwl-runner

class: CommandLineTool
id: mutect2
label: mutect2
cwlVersion: v1.1

$namespaces:
  edam: http://edamontology.org/

hints:
  - class: DockerRequirement
    dockerPull: broadinstitute/gatk:4.2.6.1

baseCommand: [ gatk ]

inputs:
  reference:
    type: File
    format: edam:format_1929
    secondaryFiles:
      - .fai
      - ^.dict
    inputBinding:
      prefix: -R
      position: 3
  java_options:
    type: string?
    inputBinding:
      position: 1
      prefix: --java-options
  tumor_cram:
    type: File
    format: edam:format_3462
    secondaryFiles:
      - .crai
    inputBinding:
      prefix: -I
      position: 4
  normal_cram:
    type: File?
    format: edam:format_3462
    secondaryFiles:
      - .crai
    inputBinding:
      prefix: -I
      position: 5
  normal_name:
    type: string?
    inputBinding:
      prefix: --normal-sample
      position: 6
  germline_resource:
    type: File
    format: edam:format_3016
    secondaryFiles:
      - .tbi
    inputBinding:
      prefix: --germline-resource
      position: 7
  interval_list:
    type: File?
    inputBinding:
      prefix: --intervals
      position: 8
  panel_of_normals:
    type: File
    format: edam:format_3016
    inputBinding:
      prefix: --panel-of-normals
      position: 9
  extra_args:
    type: string
    inputBinding:
      shellQuote: false
  outprefix:
    type: string

outputs:
  vcf:
    type: File
    format: edam:format_3016
    outputBinding:
      glob: $(inputs.outprefix).somatic.vcf.gz
  f1r2:
    type: File
    outputBinding:
      glob: $(inputs.outprefix).somatic.f1r2.tar.gz

arguments:
  - position: 2
    valueFrom: Mutect2
  - position: 10
    prefix: --f1r2-tar-gz
    valueFrom: $(inputs.outprefix).somatic.f1r2.tar.gz
  - position: 11
    prefix: -O
    valueFrom: $(inputs.outprefix).somatic.vcf.gz