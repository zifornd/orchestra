#!/usr/bin/env Rscript

set.seed(1701)

main <- function(input, output, params, log, threads) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(BiocParallel)

    library(scuttle)

    sce <- readRDS(input$rds[1])

    num <- readRDS(input$rds[2])

    sizeFactors(sce) <- num

    sce <- logNormCounts(sce, downsample = params$downsample)

    saveRDS(sce, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log, snakemake@threads)