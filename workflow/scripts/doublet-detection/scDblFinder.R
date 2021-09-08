#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(scDblFinder)

    sce <- readRDS(input$rds)
        
    dbl <- scDblFinder(sce, clusters = sce$Cluster, returnType = "table")

    dbl <- subset(dbl, type == "real")

    dbl <- dbl[colnames(sce), ]

    saveRDS(dbl, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log)