#!/usr/bin/env Rscript

main <- function(input, output, params, log) {
    
    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(scuttle)

    library(slingshot)

    sce <- readRDS(input$rds)

    ids <- colData(sce)[["Cluster"]]
    
    sce <- slingshot(sce, cluster = ids, reducedDim = "PCA", omega = params$omega)

    sce <- SlingshotDataSet(sce)

    saveRDS(sce, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)
