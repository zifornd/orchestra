#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(SingleCellExperiment)

    library(TSCAN)

    sce <- readRDS(input$rds[1])

    mat <- readRDS(input$rds[2])

    vec <- split(mat, col(mat))

    res <- mapply(
        FUN = testPseudotime,
        pseudotime = vec,
        MoreArgs = list(x = logcounts(sce)),
        SIMPLIFY = FALSE
    )

    ids <- setNames(rowData(sce)$Symbol, rowData(sce)$ID)
    
    res <- lapply(res, function(x) DataFrame(gene.id = rownames(x), gene.name = ids[rownames(x)], x, row.names = rownames(x)))

    saveRDS(res, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@log)