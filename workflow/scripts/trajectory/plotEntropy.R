#!/usr/bin/env Rscript

theme_custom <- function() {

    # Return custom theme

    theme_bw() +
    theme(
        axis.title.x = element_text(margin = unit(c(1, 0, 0, 0), "lines")),
        axis.title.y = element_text(margin = unit(c(0, 1, 0, 0), "lines"))
    )

}

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(ggforce)

    library(ggplot2)

    library(scuttle)

    sce <- readRDS(input$rds[1])

    res <- readRDS(input$rds[2])

    dat <- makePerCellDF(sce)

    dat$Entropy <- res

    plt <- ggplot(dat, aes(Cluster, Entropy, colour = Cluster)) + 
        geom_sina(show.legend = FALSE) + 
        stat_summary(fun = median, geom = "point", colour = "#000000", show.legend = FALSE) + 
        theme_custom()

    ggsave(output$pdf, plot = plt, width = 8, height = 6, scale = 0.8)

}

main(snakemake@input, snakemake@output, snakemake@log)