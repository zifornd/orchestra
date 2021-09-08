#!/usr/bin/env Rscript

theme_custom <- function() {
    
    theme_no_axes() + 
    theme(
        aspect.ratio = 1,
        strip.background = element_blank()
    )

}

main <- function(input, output, log) {
    
    # Log function

    out <- file(log$out, open = "wt")

    err <- file(log$err, open = "wt")

    sink(out, type = "output")

    sink(err, type = "message")

    # Script function

    library(ggplot2)

    library(ggforce)

    library(gtools)

    dim <- readRDS(input$rds)

    dat <- lapply(dim, function(x) {

        y <- as.data.frame(x)

        y$perplexity <- attr(x, "perplexity")

        y$max_iter <- attr(x, "max_iter")

        y$cluster <- attr(dim, "cluster")

        y$params <- sprintf("[%s, %s]", y$perplexity, y$max_iter)

        return(y)

    })

    dat <- do.call(rbind, dat)

    dat$params <- factor(dat$params, levels = mixedsort(unique(dat$params)))

    plt <- ggplot(dat, aes(TSNE.1, TSNE.2, colour = cluster)) + 
        geom_point(size = 0.1, show.legend = FALSE) + 
        facet_wrap(~ params, scales = "free") + 
        labs(caption = "TSNE parameters [perplexity, max_iter]") + 
        theme_custom()

    ggsave(output$pdf, plot = plt, width = 12, height = 12, scale = 0.8)

}

main(snakemake@input, snakemake@output, snakemake@log)