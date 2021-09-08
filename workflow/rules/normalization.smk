# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jashmore@ed.ac.uk
# License: MIT

rule librarySizeFactors:
    input:
        rds = "results/quality-control/filterCellsByQC.rds"
    output:
        rds = "results/normalization/librarySizeFactors.rds"
    log:
        out = "results/normalization/librarySizeFactors.out",
        err = "results/normalization/librarySizeFactors.err"
    message:
        "[Normalization] Compute library size factors"
    threads:
        4
    script:
        "../scripts/normalization/librarySizeFactors.R"

rule calculateSumFactors:
    input:
        rds = "results/quality-control/filterCellsByQC.rds"
    output:
        rds = "results/normalization/calculateSumFactors.rds"
    log:
        out = "results/normalization/calculateSumFactors.out",
        err = "results/normalization/calculateSumFactors.err"
    message:
        "[Normalization] Normalization by deconvolution"
    threads:
        4
    script:
        "../scripts/normalization/calculateSumFactors.R"

rule compareSizeFactors:
    input:
        rds = ["results/normalization/librarySizeFactors.rds", "results/normalization/calculateSumFactors.rds"]
    output:
        pdf = "results/normalization/compareSizeFactors.pdf"
    log:
        out = "results/normalization/compareSizeFactors.out",
        err = "results/normalization/compareSizeFactors.err"
    message:
        "[Normalization] Compare size factors"
    script:
        "../scripts/normalization/compareSizeFactors.R"

rule logNormCounts:
    input:
        rds = ["results/quality-control/filterCellsByQC.rds", "results/normalization/calculateSumFactors.rds"]
    output:
        rds = "results/normalization/logNormCounts.rds"
    params:
        downsample = config["logNormCounts"]["downsample"]
    log:
        out = "results/normalization/logNormCounts.out",
        err = "results/normalization/logNormCounts.err"
    message:
        "[Normalization] Compute log-normalized expression values (downsample = {params.downsample})"
    threads:
        4
    script:
        "../scripts/normalization/logNormCounts.R"

rule normalization_calculatePCA:
    input:
        rds = "results/normalization/logNormCounts.rds"
    output:
        rds = "results/normalization/calculatePCA.rds"
    log:
        out = "results/normalization/calculatePCA.out",
        err = "results/normalization/calculatePCA.err"
    message:
        "[Normalization] Perform PCA on expression data"
    script:
        "../scripts/normalization/calculatePCA.R"

rule normalization_calculateTSNE:
    input:
        rds = "results/normalization/calculatePCA.rds"
    output:
        rds = "results/normalization/calculateTSNE.rds"
    log:
        out = "results/normalization/calculateTSNE.out",
        err = "results/normalization/calculateTSNE.err"
    message:
        "[Normalization] Perform TSNE on expression data"
    script:
        "../scripts/normalization/calculateTSNE.R"

rule normalization_calculateUMAP:
    input:
        rds = "results/normalization/calculatePCA.rds"
    output:
        rds = "results/normalization/calculateUMAP.rds"
    log:
        out = "results/normalization/calculateUMAP.out",
        err = "results/normalization/calculateUMAP.err"
    message:
        "[Normalization] Perform UMAP on expression data"
    script:
        "../scripts/normalization/calculateUMAP.R"

rule normalization_plotPCA:
    input:
        rds = ["results/normalization/calculatePCA.rds", "results/quality-control/perCellQCMetrics.rds"]
    output:
        pdf = "results/normalization/plotPCA.{metric}.pdf"
    log:
        out = "results/normalization/plotPCA.{metric}.out",
        err = "results/normalization/plotPCA.{metric}.err"
    message:
        "[Normalization] Plot PCA coloured by QC metric: {wildcards.metric}"
    script:
        "../scripts/normalization/plotPCA.R"

rule normalization_plotTSNE:
    input:
        rds = ["results/normalization/calculateTSNE.rds", "results/quality-control/perCellQCMetrics.rds"]
    output:
        pdf = "results/normalization/plotTSNE.{metric}.pdf"
    params:
        var = "{metric}"
    log:
        out = "results/normalization/plotTSNE.{metric}.out",
        err = "results/normalization/plotTSNE.{metric}.err"
    message:
        "[Normalization] Plot TSNE coloured by QC metric: {wildcards.metric}"
    script:
        "../scripts/normalization/plotTSNE.R"

rule normalization_plotUMAP:
    input:
        rds = ["results/normalization/calculateUMAP.rds", "results/quality-control/perCellQCMetrics.rds"]
    output:
        pdf = "results/normalization/plotUMAP.{metric}.pdf"
    params:
        var = "{metric}"
    log:
        out = "results/normalization/plotUMAP.{metric}.out",
        err = "results/normalization/plotUMAP.{metric}.err"
    message:
        "[Normalization] Plot UMAP coloured by QC metric: {wildcards.metric}"
    script:
        "../scripts/normalization/plotUMAP.R"