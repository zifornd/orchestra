# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jashmore@ed.ac.uk
# License: MIT

rule regressBatches:
    input:
        rds = ["results/normalization/logNormCounts.rds", "results/cell-cycle/cyclone.rds"]
    output:
        rds = "results/data-integration/regressBatches.rds"
    log:
        out = "results/data-integration/regressBatches.out",
        err = "results/data-integration/regressBatches.err"
    message:
        "[Data integration] Regress out batch effects"
    script:
        "../scripts/data-integration/regressBatches.R"
