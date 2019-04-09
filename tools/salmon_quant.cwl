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

cwlVersion: v1.0
class: CommandLineTool
baseCommand: salmon

requirements:
  DockerRequirement:
    dockerPull: combinelab/salmon:0.12.0
  InlineJavascriptRequirement: {}

arguments:
  - position: -1
    valueFrom: "quant"
  - position: 0
    valueFrom: "--validateMappings"
  - position: 4
    valueFrom: "A"
    prefix: "-l"
inputs:
  index_directory:
    type: Directory
    inputBinding:
      position: 1
      prefix: "-i"
  output:
    type: string
    inputBinding:
      position: 2
      prefix: "-o"
  threads:
    type: int
    inputBinding:
      position: 3
      prefix: "-p"
  first_end_fastq:
    type: File[]?
    inputBinding:
      position: 5
      prefix: "-1"
  second_end_fastq:
    type: File[]?
    inputBinding:
      position: 6
      prefix: "-2"
  single_fastq:
    type: File[]?
    inputBinding:
      position: 5
      prefix: "-r"

outputs:
  salmon_out:
    type: Directory
    outputBinding:
      glob: $(inputs.output)
