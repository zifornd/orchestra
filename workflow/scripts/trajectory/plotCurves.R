#!/usr/bin/env Rscript

theme_custom <- function() {

    # Return custom theme

    theme_bw() +
    theme(
        axis.title.x = element_text(margin = unit(c(1, 0, 0, 0), "lines")),
        axis.title.y = element_text(margin = unit(c(0, 1, 0, 0), "lines"))
    )

}

theme_aspect <- function(x) {

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

    library(patchwork)

    library(scater)
    
    library(scuttle)

    obj <- list(
        SingleCellExperiment = readRDS(input$rds[1]),
        slingPseudotime = readRDS(input$rds[2]),
        slingCurves = readRDS(input$rds[3])
    )
    
    ind <- seq_along(obj$slingCurves)

    plt <- lapply(ind, function(i) {

        # Create pseudotime data frame

        dat <- makePerCellDF(obj$SingleCellExperiment, use.coldata = "Cluster", use.dimred = params$dim)

        dat$Pseudotime <- obj$slingPseudotime[, i]

        dat <- data.frame(dat)

        # Create principal curve data frame
        
        cur <- obj$slingCurves[[i]]

        cur <- cur$s[cur$ord, ]

        cur <- data.frame(cur)

        # Create aesthetics and labels
        
        aes <- paste(params$dim, 1:2, sep = ".")
        
        lab <- paste(params$dim, 1:2, sep = " ")

        fig <- paste("Curve", i, sep = " ")

        # Plot pseudotime and principal curve data
        
        p <- ggplot(dat, aes_string(aes[1], aes[2], colour = "Pseudotime")) + 
            geom_point() + 
            scale_colour_viridis_c() + 
            geom_path(data = cur, aes_string(aes[1], aes[2]), inherit.aes = FALSE) + 
            labs(x = lab[1], y = lab[2], title = fig) + 
            theme_custom() + 
            theme_aspect(params$dim)

        # Return plot object

        return(p)

    })

    out <- wrap_plots(plt)

    ggsave(file = output$pdf, plot = out, width = 16, height = 16, scale = 0.8)
    
}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)
