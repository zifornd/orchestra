#!/usr/bin/env Rscript

scale.name <- function(x) {
    
    d <- list(
        "sum" = "Total counts", 
        "detected" = "Total features",
        "subsets_MT_percent" = "MT proportion"
    )

    v <- ifelse(x %in% names(d), d[[x]], x)

}

scale.trans <- function(x) {

    d <- list(
        "sum" = "log10", 
        "detected" = "log10",
        "subsets_MT_percent" = "identity"
    )

    v <- ifelse(x %in% names(d), d[[x]], "identity")

}

theme_custom <- function() {

    theme_bw() + 
    theme(
        aspect.ratio = 1,
        axis.title.x = element_text(margin = unit(c(1, 0, 0, 0), "lines")),
        axis.title.y = element_text(margin = unit(c(0, 1, 0, 0), "lines"))
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

    library(scater)

    library(scales)

    dat <- lapply(input$rds, readRDS)

    use <- Reduce(intersect, lapply(dat, rownames))

    dat <- lapply(dat, function(x) x[use, , drop = FALSE])

    dat <- do.call(cbind, dat)

    dat <- as.data.frame(dat)

    plt <- ggplot(dat, aes_string("TSNE.1", "TSNE.2", colour = wildcards$metric)) + 
        geom_point() + 
        scale_colour_viridis_c(name = scale.name(wildcards$metric), trans = scale.trans(wildcards$metric)) + 
        labs(x = "TSNE 1", y = "TSNE 2") + 
        theme_custom()

    ggsave(file = output$pdf, plot = plt, width = 8, height = 6, scale = 0.8)

}

main(snakemake@input, snakemake@output, snakemake@log, snakemake@wildcards)