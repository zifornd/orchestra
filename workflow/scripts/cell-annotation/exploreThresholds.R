#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(AUCell)

    res <- readRDS(input$rds)

    pdf(output$pdf, width = 8, height = 6)

    AUCell_exploreThresholds(res, nCores = 1, plotHist = TRUE)

    dev.off()

}

main(snakemake@input, snakemake@output, snakemake@log)
