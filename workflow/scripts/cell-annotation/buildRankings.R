#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(AUCell)

    library(SingleCellExperiment)

    sce <- readRDS(input$rds)

    mat <- counts(sce)
    
    rownames(mat) <- scuttle::uniquifyFeatureNames(rowData(sce)$ID, rowData(sce)$Symbol)

    fit <- AUCell_buildRankings(
        exprMat = mat, 
        plotStats = FALSE, 
        verbose = FALSE
    )

    saveRDS(fit, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log)