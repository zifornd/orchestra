#!/usr/bin/env Rscript

theme_custom <- function() {

    # Return custom theme

    theme_bw() +
    theme(
        axis.title.x = element_text(margin = unit(c(1, 0, 0, 0), "lines")),
        axis.title.y = element_text(margin = unit(c(0, 1, 0, 0), "lines")),
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

    library(scales)
    
    library(scuttle)

    sce <- readRDS(input$rds)

    dat <- makePerCellDF(sce)

    dat <- as.data.frame(dat)

    dat$DoubletCluster <- ifelse(dat$DoubletCluster == TRUE, "Doublet Cluster = Yes", "Doublet Cluster = No")

    dat$DoubletCluster <- factor(dat$DoubletCluster, levels = c("Doublet Cluster = Yes", "Doublet Cluster = No"))

    dat$DoubletClass <- ifelse(dat$DoubletClass == "doublet", "Doublet Class = Doublet", "Doublet Class = Singlet")

    dat$DoubletClass <- factor(dat$DoubletClass, levels = c("Doublet Class = Doublet", "Doublet Class = Singlet"))

    plt <- ggplot(dat, aes(Cluster, jitter(DoubletDensity), colour = DoubletScore)) + 
        geom_sina() + 
        scale_colour_viridis_c(name = "Doublet Score", limits = c(0, 1)) + 
        labs(x = "Cluster", y = "Doublet Density") + 
        facet_grid(DoubletCluster ~ DoubletClass, drop = FALSE) + 
        theme_custom()

    ggsave(output$pdf, plot = plt, width = 8, height = 6, scale = 0.8)

}

main(snakemake@input, snakemake@output, snakemake@log)