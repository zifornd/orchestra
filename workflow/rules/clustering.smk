# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jashmore@ed.ac.uk
# License: MIT

# Hierarchical clustering

rule HclustParam:
    input:
        rds = "results/reduced-dimensions/selectPCA.rds"
    output:
        rds = "results/clustering/HclustParam.rds"
    log:
        out = "results/clustering/HclustParam.out",
        err = "results/clustering/HclustParam.err"
    message:
        "[Clustering] Perform hierarchical clustering"
    script:
        "../scripts/clustering/HclustParam.R"

rule HclustPCAPlot:
    input:
        rds = ["results/reduced-dimensions/selectPCA.rds", "results/clustering/HclustParam.rds"]
    output:
        pdf = "results/clustering/HclustPCAPlot.pdf"
    log:
        out = "results/clustering/HclustPCAPlot.out",
        err = "results/clustering/HclustPCAPlot.err"
    message:
        "[Clustering] Plot PCA coloured by hierarchical clusters"
    script:
        "../scripts/clustering/HclustPCAPlot.R"

rule HclustTSNEPlot:
    input:
        rds = ["results/reduced-dimensions/selectTSNE.rds", "results/clustering/HclustParam.rds"]
    output:
        pdf = "results/clustering/HclustTSNEPlot.pdf"
    log:
        out = "results/clustering/HclustTSNEPlot.out",
        err = "results/clustering/HclustTSNEPlot.err"
    message:
        "[Clustering] Plot TSNE coloured by hierarchical clusters"
    script:
        "../scripts/clustering/HclustTSNEPlot.R"

rule HclustUMAPPlot:
    input:
        rds = ["results/reduced-dimensions/selectUMAP.rds", "results/clustering/HclustParam.rds"]
    output:
        pdf = "results/clustering/HclustUMAPPlot.pdf"
    log:
        out = "results/clustering/HclustUMAPPlot.out",
        err = "results/clustering/HclustUMAPPlot.err"
    message:
        "[Clustering] Plot UMAP coloured by hierarchical clusters"
    script:
        "../scripts/clustering/HclustUMAPPlot.R"

rule HclustSilhouette:
    input:
        rds = ["results/reduced-dimensions/selectPCA.rds", "results/clustering/HclustParam.rds"]
    output:
        rds = "results/clustering/HclustSilhouette.rds"
    log:
        out = "results/clustering/HclustSilhouette.out",
        err = "results/clustering/HclustSilhouette.err"
    message:
        "[Clustering] Approximate silhouette width"
    script:
        "../scripts/clustering/HclustSilhouette.R"

rule HclustSilhouettePlot:
    input:
        rds = "results/clustering/HclustSilhouette.rds"
    output:
        pdf = "results/clustering/HclustSilhouettePlot.pdf"
    log:
        out = "results/clustering/HclustSilhouettePlot.out",
        err = "results/clustering/HclustSilhouettePlot.err"
    message:
        "[Clustering] Plot silhouette width"
    script:
        "../scripts/clustering/HclustSilhouettePlot.R"

rule HclustPurity:
    input:
        rds = ["results/reduced-dimensions/selectPCA.rds", "results/clustering/HclustParam.rds"]
    output:
        rds = "results/clustering/HclustPurity.rds"
    log:
        out = "results/clustering/HclustPurity.out",
        err = "results/clustering/HclustPurity.err"
    message:
        "[Clustering] Compute neighborhood purity"
    script:
        "../scripts/clustering/HclustPurity.R"

rule HclustPurityPlot:
    input:
        rds = "results/clustering/HclustPurity.rds"
    output:
        pdf = "results/clustering/HclustPurityPlot.pdf"
    log:
        out = "results/clustering/HclustPurityPlot.out",
        err = "results/clustering/HclustPurityPlot.err"
    message:
        "[Clustering] Plot neighborhood purity"
    script:
        "../scripts/clustering/HclustPurityPlot.R"

# K-means clustering

rule KmeansParam:
    input:
        rds = "results/reduced-dimensions/selectPCA.rds"
    output:
        rds = "results/clustering/KmeansParam.{centers}.rds"
    log:
        out = "results/clustering/KmeansParam.{centers}.out",
        err = "results/clustering/KmeansParam.{centers}.err"
    message:
        "[Clustering] Perform K-means clustering (centers = {wildcards.centers})"
    script:
        "../scripts/clustering/KmeansParam.R"

rule KmeansPCAPlot:
    input:
        rds = ["results/reduced-dimensions/selectPCA.rds", "results/clustering/KmeansParam.{centers}.rds"]
    output:
        pdf = "results/clustering/KmeansPCAPlot.{centers}.pdf"
    log:
        out = "results/clustering/KmeansPCAPlot.{centers}.out",
        err = "results/clustering/KmeansPCAPlot.{centers}.err"
    message:
        "[Clustering] Plot PCA coloured by K-means clusters"
    script:
        "../scripts/clustering/KmeansPCAPlot.R"

rule KmeansTSNEPlot:
    input:
        rds = ["results/reduced-dimensions/selectTSNE.rds", "results/clustering/KmeansParam.{centers}.rds"]
    output:
        pdf = "results/clustering/KmeansTSNEPlot.{centers}.pdf"
    log:
        out = "results/clustering/KmeansTSNEPlot.{centers}.out",
        err = "results/clustering/KmeansTSNEPlot.{centers}.err"
    message:
        "[Clustering] Plot TSNE coloured by K-means clusters"
    script:
        "../scripts/clustering/KmeansTSNEPlot.R"

rule KmeansUMAPPlot:
    input:
        rds = ["results/reduced-dimensions/selectUMAP.rds", "results/clustering/KmeansParam.{centers}.rds"]
    output:
        pdf = "results/clustering/KmeansUMAPPlot.{centers}.pdf"
    log:
        out = "results/clustering/KmeansUMAPPlot.{centers}.out",
        err = "results/clustering/KmeansUMAPPlot.{centers}.err"
    message:
        "[Clustering] Plot UMAP coloured by K-means clusters"
    script:
        "../scripts/clustering/KmeansUMAPPlot.R"

rule KmeansSilhouette:
    input:
        rds = ["results/reduced-dimensions/selectPCA.rds", "results/clustering/KmeansParam.{centers}.rds"]
    output:
        rds = "results/clustering/KmeansSilhouette.{centers}.rds"
    log:
        out = "results/clustering/KmeansSilhouette.{centers}.out",
        err = "results/clustering/KmeansSilhouette.{centers}.err"
    message:
        "[Clustering] Approximate silhouette width"
    script:
        "../scripts/clustering/KmeansSilhouette.R"

rule KmeansSilhouettePlot:
    input:
        rds = "results/clustering/KmeansSilhouette.{centers}.rds"
    output:
        pdf = "results/clustering/KmeansSilhouettePlot.{centers}.pdf"
    log:
        out = "results/clustering/KmeansSilhouettePlot.{centers}.out",
        err = "results/clustering/KmeansSilhouettePlot.{centers}.err"
    message:
        "[Clustering] Plot silhouette width"
    script:
        "../scripts/clustering/KmeansSilhouettePlot.R"

rule KmeansPurity:
    input:
        rds = ["results/reduced-dimensions/selectPCA.rds", "results/clustering/KmeansParam.{centers}.rds"]
    output:
        rds = "results/clustering/KmeansPurity.{centers}.rds"
    log:
        out = "results/clustering/KmeansPurity.{centers}.out",
        err = "results/clustering/KmeansPurity.{centers}.err"
    message:
        "[Clustering] Compute neighborhood purity"
    script:
        "../scripts/clustering/KmeansPurity.R"

rule KmeansPurityPlot:
    input:
        rds = "results/clustering/KmeansPurity.{centers}.rds"
    output:
        pdf = "results/clustering/KmeansPurityPlot.{centers}.pdf"
    log:
        out = "results/clustering/KmeansPurityPlot.{centers}.out",
        err = "results/clustering/KmeansPurityPlot.{centers}.err"
    message:
        "[Clustering] Plot neighborhood purity"
    script:
        "../scripts/clustering/KmeansPurityPlot.R"

# Graph-based clustering

rule NNGraphParam:
    input:
        rds = "results/reduced-dimensions/selectPCA.rds"
    output:
        rds = "results/clustering/NNGraphParam.{k}.{type}.{fun}.rds"
    log:
        out = "results/clustering/NNGraphParam.{k}.{type}.{fun}.out",
        err = "results/clustering/NNGraphParam.{k}.{type}.{fun}.err"
    message:
        "[Clustering] Perform graph-based clustering (k = {wildcards.k}, type = '{wildcards.type}', cluster.fun = '{wildcards.fun}')"
    script:
        "../scripts/clustering/NNGraphParam.R"

rule NNGraphPCAPlot:
    input:
        rds = ["results/reduced-dimensions/selectPCA.rds", "results/clustering/NNGraphParam.{k}.{type}.{fun}.rds"]
    output:
        pdf = "results/clustering/NNGraphPCAPlot.{k}.{type}.{fun}.pdf"
    log:
        out = "results/clustering/NNGraphPCAPlot.{k}.{type}.{fun}.out",
        err = "results/clustering/NNGraphPCAPlot.{k}.{type}.{fun}.err"
    message:
        "[Clustering] Plot PCA coloured by graph-based clusters"
    script:
        "../scripts/clustering/NNGraphPCAPlot.R"

rule NNGraphTSNEPlot:
    input:
        rds = ["results/reduced-dimensions/selectTSNE.rds", "results/clustering/NNGraphParam.{k}.{type}.{fun}.rds"]
    output:
        pdf = "results/clustering/NNGraphTSNEPlot.{k}.{type}.{fun}.pdf"
    log:
        out = "results/clustering/NNGraphTSNEPlot.{k}.{type}.{fun}.out",
        err = "results/clustering/NNGraphTSNEPlot.{k}.{type}.{fun}.err"
    message:
        "[Clustering] Plot TSNE coloured by graph-based clusters"
    script:
        "../scripts/clustering/NNGraphTSNEPlot.R"

rule NNGraphUMAPPlot:
    input:
        rds = ["results/reduced-dimensions/selectUMAP.rds", "results/clustering/NNGraphParam.{k}.{type}.{fun}.rds"]
    output:
        pdf = "results/clustering/NNGraphUMAPPlot.{k}.{type}.{fun}.pdf"
    log:
        out = "results/clustering/NNGraphUMAPPlot.{k}.{type}.{fun}.out",
        err = "results/clustering/NNGraphUMAPPlot.{k}.{type}.{fun}.err"
    message:
        "[Clustering] Plot UMAP coloured by graph-based clusters"
    script:
        "../scripts/clustering/NNGraphUMAPPlot.R"

rule NNGraphSilhouette:
    input:
        rds = ["results/reduced-dimensions/selectPCA.rds", "results/clustering/NNGraphParam.{k}.{type}.{fun}.rds"]
    output:
        rds = "results/clustering/NNGraphSilhouette.{k}.{type}.{fun}.rds"
    log:
        out = "results/clustering/NNGraphSilhouette.{k}.{type}.{fun}.out",
        err = "results/clustering/NNGraphSilhouette.{k}.{type}.{fun}.err"
    message:
        "[Clustering] Approximate silhouette width"
    script:
        "../scripts/clustering/NNGraphSilhouette.R"

rule NNGraphSilhouettePlot:
    input:
        rds = "results/clustering/NNGraphSilhouette.{k}.{type}.{fun}.rds"
    output:
        pdf = "results/clustering/NNGraphSilhouettePlot.{k}.{type}.{fun}.pdf"
    log:
        out = "results/clustering/NNGraphSilhouettePlot.{k}.{type}.{fun}.out",
        err = "results/clustering/NNGraphSilhouettePlot.{k}.{type}.{fun}.err"
    message:
        "[Clustering] Plot silhouette width"
    script:
        "../scripts/clustering/NNGraphSilhouettePlot.R"

rule NNGraphPurity:
    input:
        rds = ["results/reduced-dimensions/selectPCA.rds", "results/clustering/NNGraphParam.{k}.{type}.{fun}.rds"]
    output:
        rds = "results/clustering/NNGraphPurity.{k}.{type}.{fun}.rds"
    log:
        out = "results/clustering/NNGraphPurity.{k}.{type}.{fun}.out",
        err = "results/clustering/NNGraphPurity.{k}.{type}.{fun}.err"
    message:
        "[Clustering] Compute neighborhood purity"
    script:
        "../scripts/clustering/NNGraphPurity.R"

rule NNGraphPurityPlot:
    input:
        rds = "results/clustering/NNGraphPurity.{k}.{type}.{fun}.rds"
    output:
        pdf = "results/clustering/NNGraphPurityPlot.{k}.{type}.{fun}.pdf"
    log:
        out = "results/clustering/NNGraphPurityPlot.{k}.{type}.{fun}.out",
        err = "results/clustering/NNGraphPurityPlot.{k}.{type}.{fun}.err"
    message:
        "[Clustering] Plot neighborhood purity"
    script:
        "../scripts/clustering/NNGraphPurityPlot.R"

rule NNGraphModularity:
    input:
        rds = "results/clustering/NNGraphParam.{k}.{type}.{fun}.rds"
    output:
        rds = "results/clustering/NNGraphModularity.{k}.{type}.{fun}.rds"
    log:
        out = "results/clustering/NNGraphModularity.{k}.{type}.{fun}.out",
        err = "results/clustering/NNGraphModularity.{k}.{type}.{fun}.err"
    message:
        "[Clustering] Compute pairwise modularity"
    script:
        "../scripts/clustering/NNGraphModularity.R"

rule NNGraphModularityPlot:
    input:
        rds = "results/clustering/NNGraphModularity.{k}.{type}.{fun}.rds"
    output:
        pdf = "results/clustering/NNGraphModularityPlot.{k}.{type}.{fun}.pdf"
    log:
        out = "results/clustering/NNGraphModularityPlot.{k}.{type}.{fun}.out",
        err = "results/clustering/NNGraphModularityPlot.{k}.{type}.{fun}.err"
    message:
        "[Clustering] Plot pairwise modularity"
    script:
        "../scripts/clustering/NNGraphModularityPlot.R"

# Finalise clustering

rule clusterLabels:
    input:
        rds = ["results/reduced-dimensions/reducedDims.rds", "results/clustering/NNGraphParam.10.jaccard.louvain.rds"]
    output:
        rds = "results/clustering/clusterLabels.rds"
    log:
        out = "results/clustering/clusterLabels.out",
        err = "results/clustering/clusterLabels.err"
    message:
        "[Clustering] Assign cluster labels"
    script:
        "../scripts/clustering/clusterLabels.R"