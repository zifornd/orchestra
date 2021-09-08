#!/usr/bin/env Rscript

theme_custom <- function() {

    # Return custom theme

    theme_bw() +
    theme(
        axis.title.x = element_text(margin = unit(c(1, 0, 0, 0), "lines")),
        axis.title.y = element_text(margin = unit(c(0, 1, 0, 0), "lines")),
        legend.position = "top"
    )

}

main <- function(input, output, params, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(ggplot2)

    library(ggrepel)

    library(scales)

    library(scran)

    dec <- readRDS(input$rds[1])

    hvg <- readRDS(input$rds[2])

    dec$variable <- rownames(dec) %in% hvg

    lab <- list(
        "TRUE" = sprintf("Variable (%s)", comma(sum(dec$variable))),
        "FALSE" = sprintf("Non-variable (%s)", comma(sum(!dec$variable)))
    )

    col <- list(
        "TRUE" = "#E15759",
        "FALSE" = "#BAB0AC"
    )

    dec$name <- ""

    ind <- which(dec$bio >= sort(dec$bio, decreasing = TRUE)[params$n], arr.ind = TRUE)
    
    dec$name[ind] <- dec$symbol[ind]

    plt <- ggplot(as.data.frame(dec)) + 
        geom_point(aes(x = mean, y = total, colour = variable)) + 
        geom_line(aes(x = mean, y = tech), colour = "#000000") + 
        scale_colour_manual(name = "Features", values = col, labels = lab) + 
        geom_text_repel(aes(x = mean, y = total, label = name), colour = "#000000", size = 2, segment.size = 0.2) + 
        labs(x = "Mean", y = "Total") + 
        theme_custom()
    
    ggsave(filename = output$pdf, plot = plt, width = 8, height = 6, scale = 0.8)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)
