#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(SingleCellExperiment)

    library(S4Vectors)

    sce <- readRDS(input$rds[1])

    dbl <- list(
        findDoubletClusters   = readRDS("results/doublet-detection/findDoubletClusters.rds"),
        computeDoubletDensity = readRDS("results/doublet-detection/computeDoubletDensity.rds"),
        scDblFinder           = readRDS("results/doublet-detection/scDblFinder.rds")
    )

    sce$DoubletCluster <- sce$Cluster %in% dbl$findDoubletClusters$clusters

    sce$DoubletDensity <- dbl$computeDoubletDensity

    sce$DoubletScore <- dbl$scDblFinder$score

    sce$DoubletClass <- dbl$scDblFinder$class

    saveRDS(sce, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log)