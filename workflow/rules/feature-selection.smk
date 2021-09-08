# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jashmore@ed.ac.uk
# License: MIT

rule modelGeneVar:
    input:
        rds = "results/normalization/logNormCounts.rds"
    output:
        rds = "results/feature-selection/modelGeneVar.rds"
    log:
        out = "results/feature-selection/modelGeneVar.out",
        err = "results/feature-selection/modelGeneVar.err"
    message:
        "[Feature selection] Model the per-gene variance"
    script:
        "../scripts/feature-selection/modelGeneVar.R"

rule modelGeneCV2:
    input:
        rds = "results/normalization/logNormCounts.rds"
    output:
        rds = "results/feature-selection/modelGeneCV2.rds"
    log:
        out = "results/feature-selection/modelGeneCV2.out",
        err = "results/feature-selection/modelGeneCV2.err"
    message:
        "[Feature selection] Model the per-gene CV2"
    script:
        "../scripts/feature-selection/modelGeneCV2.R"

rule modelGeneVarByPoisson:
    input:
        rds = "results/normalization/logNormCounts.rds"
    output:
        rds = "results/feature-selection/modelGeneVarByPoisson.rds"
    log:
        out = "results/feature-selection/modelGeneVarByPoisson.out",
        err = "results/feature-selection/modelGeneVarByPoisson.err"
    message:
        "[Feature selection] Model the per-gene variance with Poisson noise"
    script:
        "../scripts/feature-selection/modelGeneVarByPoisson.R"

rule getTopHVGs:
    input:
        rds = "results/feature-selection/{model}.rds"
    output:
        rds = "results/feature-selection/{model}.getTopHVGs.rds"
    params:
        FDR = config["getTopHVGs"]["fdr.threshold"]
    log:
        out = "results/feature-selection/{model}.getTopHVGs.out",
        err = "results/feature-selection/{model}.getTopHVGs.err"
    message:
        "[Feature selection] Identify HVGs using {wildcards.model} (fdr.threshold = {params.FDR})"
    script:
        "../scripts/feature-selection/getTopHVGs.R"

rule plotGeneVar:
    input:
        rds = ["results/feature-selection/modelGeneVar.rds", "results/feature-selection/modelGeneVar.getTopHVGs.rds"]
    output:
        pdf = "results/feature-selection/plotGeneVar.pdf"
    params:
        n = 10
    log:
        out = "results/feature-selection/plotGeneVar.out",
        err = "results/feature-selection/plotGeneVar.err"
    message:
        "[Feature selection] Plot the per-gene variance"
    script:
        "../scripts/feature-selection/plotGeneVar.R"

rule plotGeneCV2:
    input:
        rds = ["results/feature-selection/modelGeneCV2.rds", "results/feature-selection/modelGeneCV2.getTopHVGs.rds"]
    output:
        pdf = "results/feature-selection/plotGeneCV2.pdf"
    params:
        n = 10
    log:
        out = "results/feature-selection/plotGeneCV2.out",
        err = "results/feature-selection/plotGeneCV2.err"
    message:
        "[Feature selection] Plot the per-gene CV2"
    script:
        "../scripts/feature-selection/plotGeneCV2.R"

rule plotGeneVarByPoisson:
    input:
        rds = ["results/feature-selection/modelGeneVarByPoisson.rds", "results/feature-selection/modelGeneVarByPoisson.getTopHVGs.rds"]
    output:
        pdf = "results/feature-selection/plotGeneVarByPoisson.pdf"
    params:
        n = 10
    log:
        out = "results/feature-selection/plotGeneVarByPoisson.out",
        err = "results/feature-selection/plotGeneVarByPoisson.err"
    message:
        "[Feature selection] Plot the per-gene variance with Poisson noise"
    script:
        "../scripts/feature-selection/plotGeneVarByPoisson.R"

rule FeatureSelection_aggregateReference:
    input:
        rds = "results/normalization/logNormCounts.rds"
    output:
        rds = "results/feature-selection/aggregateReference.rds"
    log:
        out = "results/feature-selection/aggregateReference.out",
        err = "results/feature-selection/aggregateReference.err"
    message:
        "[Feature selection] Aggregate reference samples"
    script:
        "../scripts/feature-selection/aggregateReference.R"

rule FeatureSelection_plotHeatmap:
    input:
        rds = ["results/feature-selection/aggregateReference.rds", "results/feature-selection/{model}.HVGs.rds"]
    output:
        pdf = "results/feature-selection/plotHeatmap.{model}.HVGs.pdf"
    log:
        out = "results/feature-selection/plotHeatmap.{model}.HVGs.out",
        err = "results/feature-selection/plotHeatmap.{model}.HVGs.err"
    message:
        "[Feature selection] Plot HVGs using {wildcards.model}"
    script:
        "../scripts/feature-selection/plotHeatmap.R"

rule FeatureSelection_calculatePCA:
    input:
        rds = ["results/normalization/logNormCounts.rds", "results/feature-selection/{model}.HVGs.rds"]
    output:
        rds = "results/feature-selection/calculatePCA.{model}.HVGs.rds"
    log:
        out = "results/feature-selection/calculatePCA.{model}.HVGs.out",
        err = "results/feature-selection/calculatePCA.{model}.HVGs.err"
    message:
        "[Feature selection] Perform PCA on expression data ({wildcards.model})"
    script:
        "../scripts/feature-selection/calculatePCA.R"

rule FeatureSelection_calculateTSNE:
    input:
        rds = "results/feature-selection/calculatePCA.{model}.HVGs.rds"
    output:
        rds = "results/feature-selection/calculateTSNE.{model}.HVGs.rds"
    log:
        out = "results/feature-selection/calculateTSNE.{model}.HVGs.out",
        err = "results/feature-selection/calculateTSNE.{model}.HVGs.err"
    message:
        "[Feature selection] Perform TSNE on PCA matrix ({wildcards.model})"
    script:
        "../scripts/feature-selection/calculateTSNE.R"

rule FeatureSelection_calculateUMAP:
    input:
        rds = "results/feature-selection/calculatePCA.{model}.HVGs.rds"
    output:
        rds = "results/feature-selection/calculateUMAP.{model}.HVGs.rds"
    log:
        out = "results/feature-selection/calculateUMAP.{model}.HVGs.out",
        err = "results/feature-selection/calculateUMAP.{model}.HVGs.err"
    message:
        "[Feature selection] Perform UMAP on PCA matrix ({wildcards.model})"
    threads:
        1
    script:
        "../scripts/feature-selection/calculateUMAP.R"

rule FeatureSelection_plotPCA:
    input:
        rds = ["results/quality-control/perCellQCMetrics.rds", "results/feature-selection/calculatePCA.{model}.HVGs.rds"]
    output:
        pdf = "results/feature-selection/plotPCA.{model}.HVGs.{metric}.pdf"
    log:
        out = "results/feature-selection/plotPCA.{model}.HVGs.{metric}.out",
        err = "results/feature-selection/plotPCA.{model}.HVGs.{metric}.err"
    message:
        "[Feature selection] Plot PCA coloured by QC metric: {wildcards.metric}"
    script:
        "../scripts/feature-selection/plotPCA.R"

rule FeatureSelection_plotTSNE:
    input:
        rds = ["results/quality-control/perCellQCMetrics.rds", "results/feature-selection/calculateTSNE.{model}.HVGs.rds"]
    output:
        pdf = "results/feature-selection/plotTSNE.{model}.HVGs.{metric}.pdf"
    params:
        var = "{metric}"
    log:
        out = "results/feature-selection/plotTSNE.{model}.HVGs.{metric}.out",
        err = "results/feature-selection/plotTSNE.{model}.HVGs.{metric}.err"
    message:
        "[Feature selection] Plot TSNE coloured by QC metric: {wildcards.metric}"
    script:
        "../scripts/feature-selection/plotTSNE.R"

rule FeatureSelection_plotUMAP:
    input:
        rds = ["results/quality-control/perCellQCMetrics.rds", "results/feature-selection/calculateUMAP.{model}.HVGs.rds"]
    output:
        pdf = "results/feature-selection/plotUMAP.{model}.HVGs.{metric}.pdf"
    params:
        var = "{metric}"
    log:
        out = "results/feature-selection/plotUMAP.{model}.HVGs.{metric}.out",
        err = "results/feature-selection/plotUMAP.{model}.HVGs.{metric}.err"
    message:
        "[Feature selection] Plot UMAP coloured by QC metric: {wildcards.metric}"
    script:
        "../scripts/feature-selection/plotUMAP.R"

rule rowSubset:
    input:
        rds = ["results/normalization/logNormCounts.rds", "results/feature-selection/modelGeneVarByPoisson.getTopHVGs.rds"]
    output:
        rds = "results/feature-selection/rowSubset.rds"
    log:
        out = "results/feature-selection/rowSubset.out",
        err = "results/feature-selection/rowSubset.err"
    message:
        "[Feature selection] Set the row subset for HVGs"
    script:
        "../scripts/feature-selection/rowSubset.R"
