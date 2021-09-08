#!/usr/bin/env Rscript

main <- function(input, output, log) {
    
    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(scater)

    sce <- readRDS(input$rds)

    sce <- aggregateAcrossCells(sce, ids = sce$Cluster)

    saveRDS(sce, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log)
