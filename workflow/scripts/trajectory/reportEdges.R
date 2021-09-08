#!/usr/bin/env Rscript

main <- function(input, output, params, log) {
    
    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(SingleCellExperiment)

    library(TSCAN)

    sce <- readRDS(input$rds[1])

    mst <- readRDS(input$rds[2])

    dat <- reportEdges(sce, mst = mst, clusters = NULL, use.dimred = params$dim)

    saveRDS(dat, file = output$rds)


}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)
