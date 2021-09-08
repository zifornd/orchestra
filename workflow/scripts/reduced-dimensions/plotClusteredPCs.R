#!/usr/bin/env Rscript

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(ggplot2)

    library(scales)

    library(scran)

    num <- readRDS(input$rds)

    dat <- attr(num, "clusters")

    lab <- sprintf("PCs = %s", num)

    plt <- ggplot(as.data.frame(dat), aes(n.pcs, n.clusters)) + 
        geom_point(colour = "#BAB0AC") + 
        geom_abline(intercept = 1, slope = 1, colour = "#000000", linetype = "solid") + 
        geom_vline(xintercept = num, colour = "#E15759", linetype = "dashed") + 
        annotate("text", x = num, y = Inf, label = lab, angle = 90, vjust = -1, hjust = 1.1, colour = "#E15759") +
        scale_x_continuous(name = "Principal component", breaks = c(1, 10, 20, 30, 40, 50), labels = label_ordinal()) + 
        scale_y_continuous(name = "Number of clusters", breaks = breaks_extended()) +  
        theme_bw()

    ggsave(output$pdf, plot = plt, width = 8, height = 6, scale = 0.8)

}

main(snakemake@input, snakemake@output, snakemake@log)