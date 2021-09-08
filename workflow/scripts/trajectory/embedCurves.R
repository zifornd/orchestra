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

    sce <- readRDS(input$rds[1])

    sds <- readRDS(input$rds[2])

    dim <- reducedDim(sce, params$dim)

    out <- embedCurves(sds, dim)

    saveRDS(out, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)
