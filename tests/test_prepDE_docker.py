import subprocess
import filecmp

def test_prepDE_docker():
    """
    test prepDE.cwl with docker requirements
    """
    subprocess.run(["cwl-runner",
                    "--outdir=./test_prepDE_docker",
                    "./tools/prepDE.cwl",
                    "./tools/prepDE.yml"])

    assert filecmp.cmp("./test_prepDE_docker/gene_count_matrix.csv",
                        "./tests/gene_count_matrix.star_prepde.csv")

if __name__ == "__main__":
    test_prepDE_docker()
