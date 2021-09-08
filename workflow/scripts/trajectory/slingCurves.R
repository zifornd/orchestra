#!/usr/bin/env Rscript

main <- function(input, output, log) {
    
    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(slingshot)

    sds <- readRDS(input$rds)

    out <- slingCurves(sds)

    saveRDS(out, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log)
