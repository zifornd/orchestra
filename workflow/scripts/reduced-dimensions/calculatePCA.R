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

    hvg <- rowSubset(sce, "HVGs")

    set.seed(1701)

    dim <- calculatePCA(sce, subset_row = hvg)

    rownames(dim) <- colnames(sce)

    colnames(dim) <- paste0("PCA.", seq_len(ncol(dim)))

    saveRDS(dim, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log)
