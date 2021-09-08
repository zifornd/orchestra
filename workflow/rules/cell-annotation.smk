# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jashmore@ed.ac.uk
# License: MIT

# REFERENCE DATA 

rule classifySingleR:
    input:
        rds = ["results/cell-cycle/addPerCellPhase.rds", "resources/references/trainSingleR.rds"]
    output:
        rds = "results/cell-annotation/classifySingleR.rds"
    log:
        out = "results/cell-annotation/classifySingleR.out",
        err = "results/cell-annotation/classifySingleR.err"
    message:
        "[Cell type annotation] Classify cells with SingleR"
    threads:
        4
    script:
        "../scripts/cell-annotation/classifySingleR.R"

rule plotScoreHeatmap:
    input:
        rds = "results/cell-annotation/classifySingleR.rds"
    output:
        pdf = "results/cell-annotation/plotScoreHeatmap.pdf"
    log:
        out = "results/cell-annotation/plotScoreHeatmap.out",
        err = "results/cell-annotation/plotScoreHeatmap.err"
    message:
        "[Cell type annotation] Plot a score heatmap"
    script:
        "../scripts/cell-annotation/plotScoreHeatmap.R"

# GENE SETS

rule GeneSetCollection:
    input:
        txt = "resources/markers/human.txt"
    output:
        rds = "results/cell-annotation/GeneSetCollection.rds"
    log:
        out = "results/cell-annotation/GeneSetCollection.out",
        err = "results/cell-annotation/GeneSetCollection.err"
    message:
        "[Cell type annotation]"
    script:
        "../scripts/cell-annotation/GeneSetCollection.R"

rule buildRankings:
    input:
        rds = "results/cell-cycle/addPerCellPhase.rds"
    output:
        rds = "results/cell-annotation/buildRankings.rds"
    log:
        out = "results/cell-annotation/buildRankings.out",
        err = "results/cell-annotation/buildRankings.err"
    message:
        "[Cell type annotation] Build gene expression rankings for each cell"
    script:
        "../scripts/cell-annotation/buildRankings.R"

rule calcAUC:
    input:
        rds = ["results/cell-annotation/buildRankings.rds", "results/cell-annotation/GeneSetCollection.rds"]
    output:
        rds = "results/cell-annotation/calcAUC.rds"
    log:
        out = "results/cell-annotation/buildRankings.out",
        err = "results/cell-annotation/buildRankings.err"
    message:
        "[Cell type annotation] Calculate AUC"
    script:
        "../scripts/cell-annotation/calcAUC.R"

rule exploreThresholds:
    input:
        rds = "results/cell-annotation/calcAUC.rds"
    output:
        pdf = "results/cell-annotation/exploreThresholds.pdf"
    log:
        out = "results/cell-annotation/exploreThresholds.out",
        err = "results/cell-annotation/exploreThresholds.err"
    message:
        "[Cell type annotation] Plot AUC histograms"
    script:
        "../scripts/cell-annotation/exploreThresholds.R"

# CLUSTER MARKERS

rule goana:
    input:
        rds = "results/marker-detection/combineTTests.any.0.all.rds"
    output:
        rds = "results/cell-annotation/goana.rds"
    params:
        species = "Hs",
        FDR = 0.05
    log:
        out = "results/cell-annotation/goana.out",
        err = "results/cell-annotation/goana.err"
    message:
        "[Cell type annotation] Test for over-representation of gene ontology (GO) terms"
    script:
        "../scripts/cell-annotation/goana.R"

rule plotGOTerms:
    input:
        rds = "results/cell-annotation/goana.rds"
    output:
        pdf = "results/cell-annotation/plotGOTerms.pdf"
    log:
        out = "results/cell-annotation/plotGOTerms.out",
        err = "results/cell-annotation/plotGOTerms.err"
    message:
        "[Cell type annotation] Plot over-represented gene ontology (GO) terms"
    script:
        "../scripts/cell-annotation/plotGOTerms.R"

# GENE SET ACTIVITY

rule GOALL:
    input:
        rds = "results/cell-cycle/addPerCellPhase.rds"
    output:
        rds = "results/cell-annotation/GOALL.rds"
    params:
        species = "Hs"
    log:
        out = "results/cell-annotation/GOALL.out",
        err = "results/cell-annotation/GOALL.err"
    message:
        "[Cell annotation] Select GO"
    script:
        "../scripts/cell-annotation/GOALL.R"

rule sumCountsAcrossFeatures:
    input:
        rds = ["results/cell-cycle/addPerCellPhase.rds", "results/cell-annotation/GOALL.rds"]
    output:
        rds = "results/cell-annotation/sumCountsAcrossFeatures.rds"
    log:
        out = "results/cell-annotation/sumCountsAcrossFeatures.out",
        err = "results/cell-annotation/sumCountsAcrossFeatures.err"
    script:
        "../scripts/cell-annotation/sumCountsAcrossFeatures.R"

rule heatmap:
    input:
        rds = "results/cell-annotation/sumCountsAcrossFeatures.rds"
    output:
        pdf = "results/cell-annotation/heatmap.pdf"
    params:
        n = 20
    log:
        out = "results/cell-annotation/heatmap.out",
        err = "results/cell-annotation/heatmap.err"
    script:
        "../scripts/cell-annotation/heatmap.R"