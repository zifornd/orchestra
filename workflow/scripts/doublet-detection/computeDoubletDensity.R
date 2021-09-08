#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(scDblFinder)

    library(SingleCellExperiment)

    sce <- readRDS(input$rds)

    hvg <- rowSubset(sce, "HVGs")

    dim <- reducedDim(sce, "PCA")

    num <- ncol(dim)

    dbl <- computeDoubletDensity(sce, subset.row = hvg, dims = num)

    saveRDS(dbl, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log)