# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jashmore@ed.ac.uk
# License: MIT

rule findDoubletClusters:
    input:
        rds = "results/clustering/clusterLabels.rds"
    output:
        rds = "results/doublet-detection/findDoubletClusters.rds"
    log:
        out = "results/doublet-detection/findDoubletClusters.out",
        err = "results/doublet-detection/findDoubletClusters.err"
    message:
        "[Doublet detection] Detect doublet clusters"
    script:
        "../scripts/doublet-detection/findDoubletClusters.R"

rule computeDoubletDensity:
    input:
        rds = "results/clustering/clusterLabels.rds"
    output:
        rds = "results/doublet-detection/computeDoubletDensity.rds"
    log:
        out = "results/doublet-detection/computeDoubletDensity.out",
        err = "results/doublet-detection/computeDoubletDensity.err"
    message:
        "[Doublet detection] Compute the density of simulated doublets"
    script:
        "../scripts/doublet-detection/computeDoubletDensity.R"

rule scDblFinder:
    input:
        rds = "results/clustering/clusterLabels.rds"
    output:
        rds = "results/doublet-detection/scDblFinder.rds"
    log:
        out = "results/doublet-detection/scDblFinder.out",
        err = "results/doublet-detection/scDblFinder.err"
    message:
        "[Doublet detection] scDblFinder"
    script:
        "../scripts/doublet-detection/scDblFinder.R"

rule colDoublets:
    input:
        rds = [
            "results/clustering/clusterLabels.rds",
            "results/doublet-detection/findDoubletClusters.rds",
            "results/doublet-detection/computeDoubletDensity.rds",
            "results/doublet-detection/scDblFinder.rds"
        ]
    output:
        rds = "results/doublet-detection/colDoublets.rds"
    log:
        out = "results/doublet-detection/colDoublets.out",
        err = "results/doublet-detection/colDoublets.err"
    message:
        "[Doublet detection] Assign doublet clusters"
    script:
        "../scripts/doublet-detection/colDoublets.R"

rule plotDoubletSina:
    input:
        rds = "results/doublet-detection/colDoublets.rds"
    output:
        pdf = "results/doublet-detection/plotDoubletSina.pdf"
    log:
        out = "results/doublet-detection/plotDoubletSina.out",
        err = "results/doublet-detection/plotDoubletSina.err"
    message:
        "[Doublet detection] Plot doublet density by cluster"
    script:
        "../scripts/doublet-detection/plotDoubletSina.R"

rule plotDoubletPCA:
    input:
        rds = "results/doublet-detection/colDoublets.rds"
    output:
        pdf = "results/doublet-detection/plotDoubletPCA.pdf"
    log:
        out = "results/doublet-detection/plotDoubletPCA.out",
        err = "results/doublet-detection/plotDoubletPCA.err"
    message:
        "[Doublet detection] Plot PCA coloured by doublet density"
    script:
        "../scripts/doublet-detection/plotDoubletPCA.R"

rule plotDoubletTSNE:
    input:
        rds = "results/doublet-detection/colDoublets.rds"
    output:
        pdf = "results/doublet-detection/plotDoubletTSNE.pdf"
    log:
        out = "results/doublet-detection/plotDoubletTSNE.out",
        err = "results/doublet-detection/plotDoubletTSNE.err"
    message:
        "[Doublet detection] Plot TSNE coloured by doublet density"
    script:
        "../scripts/doublet-detection/plotDoubletTSNE.R"

rule plotDoubletUMAP:
    input:
        rds = "results/doublet-detection/colDoublets.rds"
    output:
        pdf = "results/doublet-detection/plotDoubletUMAP.pdf"
    log:
        out = "results/doublet-detection/plotDoubletUMAP.out",
        err = "results/doublet-detection/plotDoubletUMAP.err"
    message:
        "[Doublet detection] Plot UMAP coloured by doublet density"
    script:
        "../scripts/doublet-detection/plotDoubletUMAP.R"
