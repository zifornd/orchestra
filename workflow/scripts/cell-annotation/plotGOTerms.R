#!/usr/bin/env Rscript

getTopTerms <- function(x, n = 10, fdr.threshold = 0.05) {

    # Get top terms

    x$FDR.DE <- p.adjust(x$P.DE, method = "fdr")

    x <- subset(x, FDR.DE < fdr.threshold)
    
    x <- rownames(x)[order(x$FDR.DE)]
    
    x <- head(x, n = n)

    return(x)

}

combineTerms <- function(x) {

    # Combine pairwise terms
    
    x <- lapply(x, function(x) cbind(ID = rownames(x), x))
    
    x <- rbindlist(x, idcol = "Cluster")

    x <- as.data.frame(x)

    return(x)

}

theme_custom <- function() {

    # Return custom theme

    theme_bw() +
    theme(
        axis.title.x = element_text(margin = unit(c(1, 0, 0, 0), "lines")),
        axis.title.y = element_text(margin = unit(c(0, 1, 0, 0), "lines")),
        panel.grid = element_blank()
    )

}

main <- function(input, output, params, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function
    
    library(data.table)
    
    library(ggplot2)
    
    library(stringr)
    
    res <- readRDS(input$rds)
    
    ids <- lapply(res, getTopTerms, n = 10, fdr.threshold = 0.05)

    all <- Reduce(union, ids)

    res <- combineTerms(res) 

    res <- subset(res, ID %in% all)
    
    plt <- ggplot(res, aes(Cluster, str_to_title(Term), colour = -log10(P.DE), size = DE)) + 
        geom_point() + 
        scale_colour_viridis_c() + 
        labs(x = "Cluster", y = NULL, colour = "-log10(P)", size = "DE") + 
        facet_grid(rows = vars(Ont), scales = "free_y", space = "free_y") +
        theme_custom()
    
    ggsave(output$pdf, plot = plt, width = 8, height = 6, scale = 2)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)
