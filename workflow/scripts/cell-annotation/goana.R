#!/usr/bin/env Rscript

OrgDb <- function(x) {

    # Load OrgDb package

    pkg <- paste0("org.", x, ".eg.db")

    obj <- getFromNamespace(pkg, pkg)

}

main <- function(input, output, params, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(AnnotationDbi)

    library(S4Vectors)

    library(limma)

    res <- readRDS(input$rds)

    org <- OrgDb(params$species)

    key <- Reduce(intersect, lapply(res, rownames))
    
    ann <- mapIds(org, keys = key, column = "ENTREZID", keytype = "ENSEMBL")

    sig <- lapply(res, subset, FDR < params$FDR)

    ids <- lapply(sig, function(x) ann[rownames(x)])

    out <- lapply(ids, goana, species = params$species, universe = ann)

    saveRDS(out, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)
