import subprocess
import filecmp

def test_workflow1_docker():
    """test_workflow1_docker"""
    subprocess.run(["cwl-runner",
                    "--outdir=./test_workflow1",
                    "./workflows/star_samtools_stringtie_prepDE_DESeq2.cwl",
                    "./workflows/star_samtools_stringtie_prepDE_DESeq2.yml"])

    assert filecmp.cmp("./test_workflow1/DESeq2/untreated-treated_DGE_res.csv",
                        "./tests/DGE_res.star_prepde.csv")


if __name__ == "__main__":
    test_workflow1_docker()
