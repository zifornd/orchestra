#!/usr/bin/env Rscript

theme_custom <- function() {

    # Return custom theme

    theme_bw() +
    theme(
        axis.title.x = element_text(margin = unit(c(1, 0, 0, 0), "lines")),
        axis.title.y = element_text(margin = unit(c(0, 1, 0, 0), "lines")),
    )

}

main <- function(input, output, log, wildcards) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(ggplot2)

    dim <- readRDS(input$rds[1])

    mem <- readRDS(input$rds[2])

    dat <- data.frame(dim, cluster = mem$clusters)

    plt <- ggplot(dat, aes(PCA.1, PCA.2, colour = cluster)) + 
        geom_point() + 
        labs(x = "PCA 1", y = "PCA 2", colour = "Cluster") + 
        coord_fixed() + 
        theme_custom()

    ggsave(file = output$pdf, plot = plt, width = 8, height = 6, scale = 0.8)

}

main(snakemake@input, snakemake@output, snakemake@log, snakemake@wildcards)