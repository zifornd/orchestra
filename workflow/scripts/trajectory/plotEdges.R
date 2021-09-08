#!/usr/bin/env Rscript

theme_custom <- function() {

    # Return custom theme

    theme_bw() +
    theme(
        axis.title.x = element_text(margin = unit(c(1, 0, 0, 0), "lines")),
        axis.title.y = element_text(margin = unit(c(0, 1, 0, 0), "lines"))
    )

}

aspect_ratio <- function(x) {

    # Return aspect ratio

    if (x == "PCA") {

        return(coord_fixed(1))

    } else {

        return(theme(aspect.ratio = 1))

    }

}

main <- function(input, output, params, log) {
    
    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(ggplot2)

    library(scuttle)

    sce <- readRDS(input$rds[1])

    fit <- readRDS(input$rds[2])
    
    dat <- makePerCellDF(sce, use.coldata = "Cluster", use.dimred = params$dim)

    aes <- paste(params$dim, 1:2, sep = ".")

    lab <- paste(params$dim, 1:2, sep = " ")

    plt <- ggplot(dat, aes_string(aes[1], aes[2], colour = "Cluster")) + 
        geom_point(size = 1) + 
        geom_line(data = fit, mapping = aes_string(aes[1], aes[2], group = "edge"), inherit.aes = FALSE) + 
        labs(x = lab[1], y = lab[2]) + 
        theme_custom() + 
        aspect_ratio(params$dim)

    ggsave(file = output$pdf, plot = plt, width = 8, height = 6, scale = 0.8)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)
