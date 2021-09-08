#!/usr/bin/env Rscript

main <- function(input, output, params, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(AnnotationDbi)

    pkg <- paste0("org.", params$species, ".eg.db")

    stopifnot(requireNamespace(pkg))
    
    obj <- getFromNamespace(pkg, pkg)

    sce <- readRDS(input$rds)

    ids <- select(obj, keys = rownames(sce), keytype = "ENSEMBL", columns = "GOALL")

    ids <- split(ids[, 1], ids[, 2])

    saveRDS(ids, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)
