# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jashmore@ed.ac.uk
# License: MIT

rule perCellQCMetrics:
    input:
        rds = "results/droplet-processing/filterByDrops.rds",
        txt = expand("resources/subsets/{subset}.txt", subset = config["scuttle"]["perCellQCMetrics"]["subsets"])
    output:
        rds = "results/quality-control/perCellQCMetrics.rds"
    log:
        out = "results/quality-control/perCellQCMetrics.out",
        err = "results/quality-control/perCellQCMetrics.err"
    message:
        "[Quality Control] Compute per-cell quality control metrics"
    script:
        "../scripts/quality-control/perCellQCMetrics.R"

rule quickPerCellQC:
    input:
        rds = "results/quality-control/perCellQCMetrics.rds"
    output:
        rds = "results/quality-control/quickPerCellQC.rds"
    params:
        subsets = config["scuttle"]["quickPerCellQC"]["subsets"],
        nmads = config["scuttle"]["quickPerCellQC"]["nmads"]
    log:
        out = "results/quality-control/quickPerCellQC.out",
        err = "results/quality-control/quickPerCellQC.err"
    message:
        "[Quality Control] Identify low-quality cells based on frequently used QC metrics"
    script:
        "../scripts/quality-control/quickPerCellQC.R"

rule plotCellQCMetrics_sum:
    input:
        rds = ["results/quality-control/perCellQCMetrics.rds", "results/quality-control/quickPerCellQC.rds"]
    output:
        pdf = report("results/quality-control/plotCellQCMetrics.sum.pdf", caption = "../report/quality-control.rst", category = "Quality Control")
    log:
        out = "results/quality-control/plotCellQCMetrics.sum.out",
        err = "results/quality-control/plotCellQCMetrics.sum.err"
    message:
        "[Quality Control] Plot the sum of counts for each cell"
    script:
        "../scripts/quality-control/plotCellQCMetrics.sum.R"

rule plotCellQCMetrics_detected:
    input:
        rds = ["results/quality-control/perCellQCMetrics.rds", "results/quality-control/quickPerCellQC.rds"]
    output:
        pdf = "results/quality-control/plotCellQCMetrics.detected.pdf"
    log:
        out = "results/quality-control/plotCellQCMetrics.detected.out",
        err = "results/quality-control/plotCellQCMetrics.detected.err"
    message:
        "[Quality Control] Plot the number of observations above detection limit"
    script:
        "../scripts/quality-control/plotCellQCMetrics.detected.R"

rule plotCellQCMetrics_MT:
    input:
        rds = ["results/quality-control/perCellQCMetrics.rds", "results/quality-control/quickPerCellQC.rds"]
    output:
        pdf = "results/quality-control/plotCellQCMetrics.MT.pdf"
    log:
        out = "results/quality-control/plotCellQCMetrics.MT.out",
        err = "results/quality-control/plotCellQCMetrics.MT.err"
    message:
        "[Quality Control] Plot the proportion of mitochondrial counts"
    script:
        "../scripts/quality-control/plotCellQCMetrics.MT.R"

rule plotCellQCMetrics_sum_detected:
    input:
        rds = ["results/quality-control/perCellQCMetrics.rds", "results/quality-control/quickPerCellQC.rds"]
    output:
        pdf = "results/quality-control/plotCellQCMetrics.sum.detected.pdf"
    log:
        out = "results/quality-control/plotCellQCMetrics.sum.detected.out",
        err = "results/quality-control/plotCellQCMetrics.sum.detected.err"
    message:
        "[Quality Control] Plot the sum of counts for each cell against the number of observations above detection limit"
    script:
        "../scripts/quality-control/plotCellQCMetrics.sum.detected.R"

rule plotCellQCMetrics_sum_MT:
    input:
        rds = ["results/quality-control/perCellQCMetrics.rds", "results/quality-control/quickPerCellQC.rds"]
    output:
        pdf = "results/quality-control/plotCellQCMetrics.sum.MT.pdf"
    log:
        out = "results/quality-control/plotCellQCMetrics.sum.MT.out",
        err = "results/quality-control/plotCellQCMetrics.sum.MT.err"
    message:
        "[Quality Control] Plot the sum of counts for each cell against the proportion of mitochondrial counts"
    script:
        "../scripts/quality-control/plotCellQCMetrics.sum.MT.R"

rule filterCellsByQC:
    input:
        rds = ["results/droplet-processing/filterByDrops.rds", "results/quality-control/quickPerCellQC.rds"]
    output:
        rds = "results/quality-control/filterCellsByQC.rds"
    log:
        out = "results/quality-control/filterCellsByQC.out",
        err = "results/quality-control/filterCellsByQC.err"
    message:
        "[Quality Control] Filter low-quality cells"
    script:
        "../scripts/quality-control/filterCellsByQC.R"

rule perFeatureQCMetrics:
    input:
        rds = "results/quality-control/filterCellsByQC.rds"
    output:
        rds = "results/quality-control/perFeatureQCMetrics.rds"
    log:
        out = "results/quality-control/perFeatureQCMetrics.out",
        err = "results/quality-control/perFeatureQCMetrics.err"
    message:
        "[Quality Control] Compute per-feature quality control metrics"
    script:
        "../scripts/quality-control/perFeatureQCMetrics.R"

rule plotFeatureQCMetrics_mean:
    input:
        rds = "results/quality-control/perFeatureQCMetrics.rds"
    output:
        pdf = "results/quality-control/plotFeatureQCMetrics.mean.pdf"
    log:
        out = "results/quality-control/plotFeatureQCMetrics.mean.out",
        err = "results/quality-control/plotFeatureQCMetrics.mean.err"
    message:
        "[Quality Control] Plot the mean counts for each feature"
    script:
        "../scripts/quality-control/plotFeatureQCMetrics.mean.R"

rule plotFeatureQCMetrics_detected:
    input:
        rds = "results/quality-control/perFeatureQCMetrics.rds"
    output:
        pdf = "results/quality-control/plotFeatureQCMetrics.detected.pdf"
    log:
        out = "results/quality-control/plotFeatureQCMetrics.detected.out",
        err = "results/quality-control/plotFeatureQCMetrics.detected.err"
    message:
        "[Quality Control] Plot the percentage of observations above detection limit"
    script:
        "../scripts/quality-control/plotFeatureQCMetrics.detected.R"

rule plotMeanVsDetected:
    input:
        rds = "results/quality-control/perFeatureQCMetrics.rds"
    output:
        pdf = "results/quality-control/plotMeanVsDetected.pdf"
    params:
        n = 50
    log:
        out = "results/quality-control/plotMeanVsDetected.out",
        err = "results/quality-control/plotMeanVsDetected.err"
    message:
        "[Quality Control] Plot mean counts against number of expressed features"
    script:
        "../scripts/quality-control/plotMeanVsDetected.R"

rule plotHighestExprs:
    input:
        rds = "results/quality-control/filterCellsByQC.rds"
    output:
        pdf = "results/quality-control/plotHighestExprs.pdf"
    params:
        n = 50
    log:
        out = "results/quality-control/plotHighestExprs.out",
        err = "results/quality-control/plotHighestExprs.err"
    message:
        "[Quality Control] Plot the highest expressing features"
    script:
        "../scripts/quality-control/plotHighestExprs.R"

# rule calculatePCA:
#     input:
#         rds = "results/quality-control/filterCellsByQC.rds"
#     output:
#         rds = "results/quality-control/calculatePCA.rds"
#     log:
#         out = "results/quality-control/calculatePCA.out",
#         err = "results/quality-control/calculatePCA.err"
#     message:
#         "[Quality Control] Perform PCA on expression data"
#     script:
#         "../scripts/quality-control/calculatePCA.R"

# rule calculateTSNE:
#     input:
#         rds = "results/quality-control/calculatePCA.rds"
#     output:
#         rds = "results/quality-control/calculateTSNE.rds"
#     log:
#         out = "results/quality-control/calculateTSNE.out",
#         err = "results/quality-control/calculateTSNE.err"
#     message:
#         "[Quality Control] Perform TSNE on expression data"
#     script:
#         "../scripts/quality-control/calculateTSNE.R"

# rule calculateUMAP:
#     input:
#         rds = "results/quality-control/calculatePCA.rds"
#     output:
#         rds = "results/quality-control/calculateUMAP.rds"
#     log:
#         out = "results/quality-control/calculateUMAP.out",
#         err = "results/quality-control/calculateUMAP.err"
#     message:
#         "[Quality Control] Perform UMAP on expression data"
#     script:
#         "../scripts/quality-control/calculateUMAP.R"

# rule plotPCA:
#     input:
#         rds = ["results/quality-control/perCellQCMetrics.rds", "results/quality-control/calculatePCA.rds"]
#     output:
#         pdf = "results/quality-control/plotPCA.{metric}.pdf"
#     log:
#         out = "results/quality-control/plotPCA.{metric}.out",
#         err = "results/quality-control/plotPCA.{metric}.err"
#     message:
#         "[Quality Control] Plot PCA coloured by QC metric: {wildcards.metric}"
#     script:
#         "../scripts/quality-control/plotPCA.R"

# rule plotTSNE:
#     input:
#         rds = ["results/quality-control/perCellQCMetrics.rds", "results/quality-control/calculateTSNE.rds"]
#     output:
#         pdf = "results/quality-control/plotTSNE.{metric}.pdf"
#     params:
#         var = "{metric}"
#     log:
#         out = "results/quality-control/plotTSNE.{metric}.out",
#         err = "results/quality-control/plotTSNE.{metric}.err"
#     message:
#         "[Quality Control] Plot TSNE coloured by QC metric: {wildcards.metric}"
#     script:
#         "../scripts/quality-control/plotTSNE.R"

# rule plotUMAP:
#     input:
#         rds = ["results/quality-control/perCellQCMetrics.rds", "results/quality-control/calculateUMAP.rds"]
#     output:
#         pdf = "results/quality-control/plotUMAP.{metric}.pdf"
#     params:
#         var = "{metric}"
#     log:
#         out = "results/quality-control/plotUMAP.{metric}.out",
#         err = "results/quality-control/plotUMAP.{metric}.err"
#     message:
#         "[Quality Control] Plot UMAP coloured by QC metric: {wildcards.metric}"
#     script:
#         "../scripts/quality-control/plotUMAP.R"