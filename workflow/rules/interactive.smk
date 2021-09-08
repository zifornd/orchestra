# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jashmore@ed.ac.uk
# License: MIT

rule iSEE:
    input:
        rds = "SingleCellExperiment.rds"
    output:
        ""
    script:
        "../scripts/interactive/iSEE.R"