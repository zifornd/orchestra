#!/usr/bin/env Rscript

theme_custom <- function() {

    # Return custom theme

    theme_bw() +
    theme(
        aspect.ratio = 1,
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

    res <- readRDS(input$rds)

    dat <- data.frame(G1 = res$score$G1, G2M = res$score$G2M, phase = res$phases)

    col <- c("G1" = "#E03531", "S" = "#F0BD27", "G2M" = "#51B364")

    brk <- c("G1", "S", "G2M")

    lab <- sapply(brk, function(x) {
        
        num <- sum(x == dat$phase)
        
        pct <- (num / length(dat$phase)) * 100
        
        lab <- sprintf("%s (%s%%)", x, round(pct, digits = 2))
        
        lab <- sub("G2M", "G2/M", lab)

    })

    plt <- ggplot(dat, aes(G1, G2M, colour = phase)) + 
        geom_point() + 
        scale_colour_manual(values = col, breaks = brk, labels = lab) + 
        labs(x = "G1 score", y = "G2/M score", colour = "Phase") + 
        theme_custom()

    ggsave(output$pdf, plot = plt, width = 6, height = 6, scale = 0.8)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)