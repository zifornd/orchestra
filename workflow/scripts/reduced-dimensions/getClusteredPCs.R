#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(scran)

    dim <- readRDS(input$rds)

    dat <- getClusteredPCs(dim, min.rank = 1, max.rank = ncol(dim))

    num <- metadata(dat)$chosen

    attr(num, "clusters") <- dat

    saveRDS(num, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log)