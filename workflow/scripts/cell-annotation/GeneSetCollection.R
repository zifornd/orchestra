#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(tidyr)
    
    dat <- read.delim(input$txt)
    
    dat$geneSymbol <- gsub("\\[|\\]", "", dat$geneSymbol)
    
    dat <- separate_rows(dat, geneSymbol, sep = ",\\s+")
    
    dat <- subset(dat, !grepl("family", geneSymbol))
    
    dat <- subset(dat, geneSymbol != "")
    
    dat <- split(dat$geneSymbol, dat$cellName)
    
    dat <- lapply(dat, unique)
    
    saveRDS(dat, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log)