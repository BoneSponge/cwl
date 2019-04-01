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
class: CommandLineTool
requirements:
  DockerRequirement:
    dockerPull: biowardrobe2/scidap-deseq:v0.0.5
  InlineJavascriptRequirement: {}

baseCommand: Rscript
inputs:
  input_script:
    type: File
    inputBinding:
      position: 1
  count_matrix:
    type: File
    inputBinding:
      position: 2
      prefix: --count_matrix
  metadata:
    type: File
    inputBinding:
      position: 3
      prefix: --metadata
  threads:
    type: int?
    inputBinding:
      position: 4
      prefix: --threads
outputs:
  DESeq2_out:
    type: File[]
    outputBinding:
      glob: "*.csv"
  de_res:
    type: File[]
    outputBinding:
      glob: "*DGE_res.csv"
