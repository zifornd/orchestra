#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(AUCell)

    mat <- readRDS(input$rds[1])

    dat <- readRDS(input$rds[2])

    fit <- AUCell_calcAUC(rankings = mat, geneSets = dat, verbose = FALSE)

    saveRDS(fit, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log)