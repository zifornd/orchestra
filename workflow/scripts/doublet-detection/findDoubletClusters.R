#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(scater)

    library(scDblFinder)

    sce <- readRDS(input$rds)

    dbl <- findDoubletClusters(sce, clusters = sce$Cluster)

    out <- isOutlier(dbl$num.de, type = "lower", log = TRUE)

    metadata(dbl)$clusters <- rownames(dbl)[out]

    saveRDS(dbl, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log)