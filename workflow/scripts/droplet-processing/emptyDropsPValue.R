#!/usr/bin/env Rscript

theme_custom <- function() {

    # Return custom theme

    theme_bw() + 
    theme(
        axis.title.x = element_text(margin = unit(c(1, 0, 0, 0), "lines")), 
        axis.title.y = element_text(margin = unit(c(0, 1, 0, 0), "lines"))
    )

}

histogram_breaks <- function(x) {

    # Return histogram breaks

    pretty(range(x), n = nclass.Sturges(x), min.n = 1)

}

main <- function(input, output, log) {

    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(ggplot2)

    library(scales)

    dat <- readRDS(input$rds)

    dat <- subset(dat, Total <= metadata(dat)$lower & Total > 0)

    dat <- as.data.frame(dat)

    plt <- ggplot(dat, aes(PValue)) + 
        geom_histogram(breaks = histogram_breaks(dat$PValue), colour = "#000000", fill = "#EBEBEB") + 
        scale_x_continuous(name = "P value", breaks = breaks_extended(), labels = label_number()) + 
        scale_y_continuous(name = "Frequency", breaks = breaks_extended(), labels = label_number_si()) + 
        theme_custom()

    ggsave(output$pdf, plot = plt, width = 8, height = 6, scale = 0.8)

}

main(snakemake@input, snakemake@output, snakemake@log)
