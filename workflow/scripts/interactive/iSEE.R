#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(SingleCellExperiment)

    library(iSEE)

    sce <- readRDS(input$rds)

    rownames(sce) <- uniquifyFeatureNames(rowData(sce)$ID, rowData(sce)$Symbol)

    colnames(sce) <- uniquifyFeatureNames(colData(sce)$Barcode, colData(sce)$Sample)

    app <- iSEE(sce)

    saveRDS(app, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log)