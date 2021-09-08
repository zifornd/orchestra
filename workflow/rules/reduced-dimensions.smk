# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jashmore@ed.ac.uk
# License: MIT

rule calculatePCA:
    input:
        rds = "results/feature-selection/rowSubset.rds"
    output:
        rds = "results/reduced-dimensions/calculatePCA.rds"
    log:
        out = "results/reduced-dimensions/calculatePCA.out",
        err = "results/reduced-dimensions/calculatePCA.err"
    message:
        "[Dimensionality reduction] Perform PCA on expression data"
    script:
        "../scripts/reduced-dimensions/calculatePCA.R"

rule findElbowPoint:
    input:
        rds = "results/reduced-dimensions/calculatePCA.rds"
    output:
        rds = "results/reduced-dimensions/findElbowPoint.rds"
    log:
        out = "results/reduced-dimensions/findElbowPoint.out",
        err = "results/reduced-dimensions/findElbowPoint.err"
    message:
        "[Dimensionality reduction] Find the elbow point"
    script:
        "../scripts/reduced-dimensions/findElbowPoint.R"

rule plotElbowPoint:
    input:
        rds = ["results/reduced-dimensions/calculatePCA.rds", "results/reduced-dimensions/findElbowPoint.rds"]
    output:
        pdf = "results/reduced-dimensions/plotElbowPoint.pdf"
    log:
        out = "results/reduced-dimensions/plotElbowPoint.out",
        err = "results/reduced-dimensions/plotElbowPoint.err"
    message:
        "[Dimensionality reduction] Plot the elbow point"
    script:
        "../scripts/reduced-dimensions/plotElbowPoint.R"

rule getDenoisedPCs:
    input:
        rds = ["results/feature-selection/rowSubset.rds", "results/feature-selection/modelGeneVarByPoisson.rds"]
    output:
        rds = "results/reduced-dimensions/getDenoisedPCs.rds"
    log:
        out = "results/reduced-dimensions/getDenoisedPCs.out",
        err = "results/reduced-dimensions/getDenoisedPCs.err"
    message:
        "[Dimensionality reduction] Denoise expression with PCA"
    script:
        "../scripts/reduced-dimensions/getDenoisedPCs.R"

rule plotDenoisedPCs:
    input:
        rds = ["results/reduced-dimensions/calculatePCA.rds", "results/reduced-dimensions/getDenoisedPCs.rds"]
    output:
        pdf = "results/reduced-dimensions/plotDenoisedPCs.pdf"
    log:
        out = "results/reduced-dimensions/plotDenoisedPCs.out",
        err = "results/reduced-dimensions/plotDenoisedPCs.err"
    message:
        "[Dimensionality reduction] Plot denoised PCs"
    script:
        "../scripts/reduced-dimensions/plotDenoisedPCs.R"

rule getClusteredPCs:
    input:
        rds = "results/reduced-dimensions/calculatePCA.rds"
    output:
        rds = "results/reduced-dimensions/getClusteredPCs.rds"
    log:
        out = "results/reduced-dimensions/getClusteredPCs.out",
        err = "results/reduced-dimensions/getClusteredPCs.err"
    message:
        "[Dimensionality reduction] Use clusters to choose the number of PCs"
    script:
        "../scripts/reduced-dimensions/getClusteredPCs.R"

rule plotClusteredPCs:
    input:
        rds = "results/reduced-dimensions/getClusteredPCs.rds"
    output:
        pdf = "results/reduced-dimensions/plotClusteredPCs.pdf"
    log:
        out = "results/reduced-dimensions/plotClusteredPCs.out",
        err = "results/reduced-dimensions/plotClusteredPCs.err"
    message:
        "[Dimensionality reduction] Plot clustered PCs"
    script:
        "../scripts/reduced-dimensions/plotClusteredPCs.R"

rule selectPCA:
    input:
        rds = ["results/reduced-dimensions/calculatePCA.rds", "results/reduced-dimensions/getDenoisedPCs.rds"]
    output:
        rds = "results/reduced-dimensions/selectPCA.rds"
    log:
        out = "results/reduced-dimensions/selectPCA.out",
        err = "results/reduced-dimensions/selectPCA.err"
    message:
        "[Dimensionality reduction] Select PCA"
    script:
        "../scripts/reduced-dimensions/selectPCA.R"

rule parallelTSNE:
    input:
        rds = "results/reduced-dimensions/selectPCA.rds"
    output:
        rds = "results/reduced-dimensions/parallelTSNE.rds"
    params:
        perplexity = config["parallelTSNE"]["perplexity"],
        max_iter = config["parallelTSNE"]["max_iter"]
    log:
        out = "results/reduced-dimensions/parallelTSNE.out",
        err = "results/reduced-dimensions/parallelTSNE.err"
    threads:
        16
    message:
        "[Dimensionality reduction] Perform parallel TSNE on PCA matrix"
    script:
        "../scripts/reduced-dimensions/parallelTSNE.R"

rule visualiseTSNE:
    input:
        rds = "results/reduced-dimensions/parallelTSNE.rds"
    output:
        pdf = "results/reduced-dimensions/visualiseTSNE.pdf"
    log:
        out = "results/reduced-dimensions/visualiseTSNE.out",
        err = "results/reduced-dimensions/visualiseTSNE.err"
    message:
        "[Dimensionality reduction] Plot parallel TSNE"
    script:
        "../scripts/reduced-dimensions/visualiseTSNE.R"

rule selectTSNE:
    input:
        rds = "results/reduced-dimensions/parallelTSNE.rds"
    output:
        rds = "results/reduced-dimensions/selectTSNE.rds"
    params:
        perplexity = config["calculateTSNE"]["perplexity"],
        max_iter = config["calculateTSNE"]["max_iter"]
    log:
        out = "results/reduced-dimensions/selectTSNE.out",
        err = "results/reduced-dimensions/selectTSNE.err"
    message:
        "[Dimensionality reduction] Select TSNE matrix"
    script:
        "../scripts/reduced-dimensions/selectTSNE.R"

rule parallelUMAP:
    input:
        rds = "results/reduced-dimensions/selectPCA.rds"
    output:
        rds = "results/reduced-dimensions/parallelUMAP.rds"
    params:
        n_neighbors = config["parallelUMAP"]["n_neighbors"],
        min_dist = config["parallelUMAP"]["min_dist"]
    log:
        out = "results/reduced-dimensions/parallelUMAP.out",
        err = "results/reduced-dimensions/parallelUMAP.err"
    threads:
        16
    message:
        "[Dimensionality reduction] Perform parallel UMAP on PCA matrix"
    script:
        "../scripts/reduced-dimensions/parallelUMAP.R"

rule visualiseUMAP:
    input:
        rds = "results/reduced-dimensions/parallelUMAP.rds"
    output:
        pdf = "results/reduced-dimensions/visualiseUMAP.pdf"
    log:
        out = "results/reduced-dimensions/visualiseUMAP.out",
        err = "results/reduced-dimensions/visualiseUMAP.err"
    message:
        "[Dimensionality reduction] Plot parallel UMAP"
    script:
        "../scripts/reduced-dimensions/visualiseUMAP.R"

rule selectUMAP:
    input:
        rds = "results/reduced-dimensions/parallelUMAP.rds"
    output:
        rds = "results/reduced-dimensions/selectUMAP.rds"
    params:
        n_neighbors = config["calculateUMAP"]["n_neighbors"],
        min_dist = config["calculateUMAP"]["min_dist"]
    log:
        out = "results/reduced-dimensions/selectUMAP.out",
        err = "results/reduced-dimensions/selectUMAP.err"
    message:
        "[Dimensionality reduction] Select UMAP matrix"
    script:
        "../scripts/reduced-dimensions/selectUMAP.R"
    
rule plotPCA:
    input:
        rds = ["results/quality-control/perCellQCMetrics.rds", "results/reduced-dimensions/selectPCA.rds"]
    output:
        pdf = "results/reduced-dimensions/plotPCA.{metric}.pdf"
    log:
        out = "results/reduced-dimensions/plotPCA.{metric}.out",
        err = "results/reduced-dimensions/plotPCA.{metric}.err"
    message:
        "[Dimensionality reduction] Plot PCA coloured by QC metric: {wildcards.metric}"
    script:
        "../scripts/reduced-dimensions/plotPCA.R"

rule plotTSNE:
    input:
        rds = ["results/quality-control/perCellQCMetrics.rds", "results/reduced-dimensions/selectTSNE.rds"]
    output:
        pdf = "results/reduced-dimensions/plotTSNE.{metric}.pdf"
    params:
        var = "{metric}"
    log:
        out = "results/reduced-dimensions/plotTSNE.{metric}.out",
        err = "results/reduced-dimensions/plotTSNE.{metric}.err"
    message:
        "[Dimensionality reduction] Plot TSNE coloured by QC metric: {wildcards.metric}"
    script:
        "../scripts/reduced-dimensions/plotTSNE.R"

rule plotUMAP:
    input:
        rds = ["results/quality-control/perCellQCMetrics.rds", "results/reduced-dimensions/selectUMAP.rds"]
    output:
        pdf = "results/reduced-dimensions/plotUMAP.{metric}.pdf"
    params:
        var = "{metric}"
    log:
        out = "results/reduced-dimensions/plotUMAP.{metric}.out",
        err = "results/reduced-dimensions/plotUMAP.{metric}.err"
    message:
        "[Dimensionality reduction] Plot UMAP coloured by QC metric: {wildcards.metric}"
    script:
        "../scripts/reduced-dimensions/plotUMAP.R"

rule reducedDims:
    input:
        rds = ["results/feature-selection/rowSubset.rds",
               "results/reduced-dimensions/selectPCA.rds",
               "results/reduced-dimensions/selectTSNE.rds",
               "results/reduced-dimensions/selectUMAP.rds"]
    output:
        rds = "results/reduced-dimensions/reducedDims.rds"
    log:
        out = "results/reduced-dimensions/reducedDims.out",
        err = "results/reduced-dimensions/reducedDims.err"
    message:
        "[Dimensionality reduction] Add reducedDims to SingleCellExperiment"
    script:
        "../scripts/reduced-dimensions/reducedDims.R"
