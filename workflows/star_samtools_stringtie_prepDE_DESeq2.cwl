# A collection of RNA-Seq data analysis tools wrapped in CWL scripts
# Copyright (C) 2019 Alessandro Pio Greco, Patrick Hedley-Miller, Filipe Jesus, Zeyu Yang
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
requirements:
  ScatterFeatureRequirement: {}
  MultipleInputFeatureRequirement: {}
  StepInputExpressionRequirement: {}
  InlineJavascriptRequirement: {}

inputs:
  threads: int
  genomeDir: Directory
  annotation: File
  subject_name1: string
  subject_name2: string
  subject_name3: string
  subject_name4: string
  fastq1: File[]
  fastq2: File[]
  fastq3: File[]
  fastq4: File[]
  prepDE_script: File
  DESeq2_script: File
  metadata: File

outputs:
  star_readmap_out:
    type: Directory
    outputSource: star_folder/out
  samtools_out:
    type: Directory
    outputSource: samtools_folder/out
  stringtie_out:
    type: Directory
    outputSource: stringtie_folder/out
  prepDE_out:
    type: Directory
    outputSource: prepDE_folder/out
  DESeq2_out:
    type: Directory
    outputSource: DESeq2_folder/out
steps:
# STAR
  star_readmap_1:
    run: ../tools/STAR_readmap.cwl
    in:
      threads: threads
      genomeDir: genomeDir
      readFilesIn: fastq1
      outFileNamePrefix: subject_name1
    out: [sam_output, star_read_out]

  star_readmap_2:
    run: ../tools/STAR_readmap.cwl
    in:
      threads: threads
      genomeDir: genomeDir
      readFilesIn: fastq2
      outFileNamePrefix: subject_name2
    out: [sam_output, star_read_out]
  star_readmap_3:
    run: ../tools/STAR_readmap.cwl
    in:
      threads: threads
      genomeDir: genomeDir
      readFilesIn: fastq3
      outFileNamePrefix: subject_name3
    out: [sam_output, star_read_out]
  star_readmap_4:
    run: ../tools/STAR_readmap.cwl
    in:
      threads: threads
      genomeDir: genomeDir
      readFilesIn: fastq4
      outFileNamePrefix: subject_name4
    out: [sam_output, star_read_out]

  star_folder:
    run: ../tools/folder.cwl
    in:
      item:
      - star_readmap_1/star_read_out
      - star_readmap_2/star_read_out
      - star_readmap_3/star_read_out
      - star_readmap_4/star_read_out
      name:
        valueFrom: "star"
    out: [out]


# Samtools
  samtools_1:
    run: ../tools/samtools.cwl
    in:
      samfile: star_readmap_1/sam_output
      threads: threads
      outfilename:
        source: [subject_name1]
        valueFrom: $(self + ".bam")
    out: [samtools_out]

  samtools_2:
    run: ../tools/samtools.cwl
    in:
      samfile: star_readmap_2/sam_output
      threads: threads
      outfilename:
        source: [subject_name2]
        valueFrom: $(self + ".bam")
    out: [samtools_out]

  samtools_3:
    run: ../tools/samtools.cwl
    in:
      samfile: star_readmap_3/sam_output
      threads: threads
      outfilename:
        source: [subject_name3]
        valueFrom: $(self + ".bam")
    out: [samtools_out]

  samtools_4:
    run: ../tools/samtools.cwl
    in:
      samfile: star_readmap_4/sam_output
      threads: threads
      outfilename:
        source: [subject_name4]
        valueFrom: $(self + ".bam")
    out: [samtools_out]

  samtools_folder:
    run: ../tools/folder.cwl
    in:
      item:
      - samtools_1/samtools_out
      - samtools_2/samtools_out
      - samtools_3/samtools_out
      - samtools_4/samtools_out
      name:
        valueFrom: "samtools"
    out: [out]

#Stringtie
  stringtie_1:
    run: ../tools/stringtie.cwl
    in:
      bam: samtools_1/samtools_out
      threads: threads
      gtf: annotation
      output:
        source: [subject_name1]
        valueFrom: $(self)
    out: [stringtie_out]

  stringtie_2:
    run: ../tools/stringtie.cwl
    in:
      bam: samtools_2/samtools_out
      threads: threads
      gtf: annotation
      output:
        source: [subject_name2]
        valueFrom: $(self)
    out: [stringtie_out]

  stringtie_3:
    run: ../tools/stringtie.cwl
    in:
      bam: samtools_3/samtools_out
      threads: threads
      gtf: annotation
      output:
        source: [subject_name3]
        valueFrom: $(self)
    out: [stringtie_out]

  stringtie_4:
    run: ../tools/stringtie.cwl
    in:
      bam: samtools_4/samtools_out
      threads: threads
      gtf: annotation
      output:
        source: [subject_name4]
        valueFrom: $(self)
    out: [stringtie_out]

  stringtie_folder:
    run: ../tools/folder.cwl
    in:
      item:
      - stringtie_1/stringtie_out
      - stringtie_2/stringtie_out
      - stringtie_3/stringtie_out
      - stringtie_4/stringtie_out
      name:
        valueFrom: "stringtie"
    out: [out]

  prepDE:
    run: ../tools/prepDE.cwl
    in:
     input_script: prepDE_script
     stringtie_out: stringtie_folder/out
    out: [gene_count_output, transcript_count_output]

  prepDE_folder:
    run: ../tools/folder.cwl
    in:
      item:
      - prepDE/gene_count_output
      - prepDE/transcript_count_output
      name:
        valueFrom: "prepDE"
    out: [out]

  DESeq2:
    run: ../tools/DESeq2.cwl
    in:
      input_script: DESeq2_script
      count_matrix: prepDE/gene_count_output
      metadata: metadata
    out: [DESeq2_out]

  DESeq2_folder:
    run: ../tools/folder.cwl
    in:
      item: DESeq2/DESeq2_out
      name:
        valueFrom: "DESeq2"
    out: [out]
