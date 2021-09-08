# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jashmore@ed.ac.uk
# License: MIT

rule aggregateReference:
    input:
        rds = "results/cell-cycle/addPerCellPhase.rds"
    output:
        rds = "results/marker-detection/aggregateReference.rds"
    log:
        out = "results/marker-detection/aggregateReference.out",
        err = "results/marker-detection/aggregateReference.err"
    message:
        "[Marker detection] Aggregate reference samples"
    threads:
        4
    script:
        "../scripts/marker-detection/aggregateReference.R"

rule pairwiseTTests:
    input:
        rds = "results/cell-cycle/addPerCellPhase.rds"
    output:
        rds = "results/marker-detection/pairwiseTTests.{direction}.{lfc}.rds"
    log:
        out = "results/marker-detection/pairwiseTTests.{direction}.{lfc}.out",
        err = "results/marker-detection/pairwiseTTests.{direction}.{lfc}.err"
    message:
        "[Marker detection] Perform pairwise t-tests (direction = '{wildcards.direction}', lfc = {wildcards.lfc})"
    threads:
        4
    script:
        "../scripts/marker-detection/pairwiseTTests.R"

rule combineTTests:
    input:
        rds = "results/marker-detection/pairwiseTTests.{direction}.{lfc}.rds"
    output:
        rds = "results/marker-detection/combineTTests.{direction}.{lfc}.{type}.rds"
    log:
        out = "results/marker-detection/combineTTests.{direction}.{lfc}.{type}.out",
        err = "results/marker-detection/combineTTests.{direction}.{lfc}.{type}.err"
    message:
        "[Marker detection] Combine pairwise t-tests (direction = '{wildcards.direction}', lfc = {wildcards.lfc}, pval.type = '{wildcards.type}')"
    threads:
        4
    script:
        "../scripts/marker-detection/combineTTests.R"

rule writeTTests:
    input:
        rds = "results/marker-detection/combineTTests.{direction}.{lfc}.{type}.rds"
    output:
        dir = directory("results/marker-detection/writeTTests.{direction}.{lfc}.{type}")
    log:
        out = "results/marker-detection/writeTTests.{direction}.{lfc}.{type}.out",
        err = "results/marker-detection/writeTTests.{direction}.{lfc}.{type}.err"
    message:
        "[Marker detection] Write pairwise t-tests (direction = '{wildcards.direction}', lfc = {wildcards.lfc}, pval.type = '{wildcards.type}')"
    script:
        "../scripts/marker-detection/writeTTests.R"

rule heatmapTTests:
    input:
        rds = ["results/cell-cycle/addPerCellPhase.rds", "results/marker-detection/combineTTests.{direction}.{lfc}.{type}.rds"]
    output:
        pdf = "results/marker-detection/heatmapTTests.{direction}.{lfc}.{type}.pdf"
    params:
        size = 100
    log:
        out = "results/marker-detection/heatmapTTests.{direction}.{lfc}.{type}.out",
        err = "results/marker-detection/heatmapTTests.{direction}.{lfc}.{type}.err"
    message:
        "[Marker detection] Plot expression of marker genes from t-test"
    script:
        "../scripts/marker-detection/heatmapTTests.R"

rule plotTTestsEffects:
    input:
        rds = "results/marker-detection/combineTTests.{direction}.{lfc}.{type}.rds"
    output:
        dir = directory("results/marker-detection/plotTTestsEffects.{direction}.{lfc}.{type}")
    log:
        out = "results/marker-detection/plotTTestsEffects.{direction}.{lfc}.{type}.out",
        err = "results/marker-detection/plotTTestsEffects.{direction}.{lfc}.{type}.err"
    message:
        "[Marker detection] Plot pairwise t-tests effect sizes (direction = '{wildcards.direction}', lfc = {wildcards.lfc}, pval.type = '{wildcards.type}')"
    script:
        "../scripts/marker-detection/plotTTestsEffects.R"

rule pairwiseWilcox:
    input:
        rds = "results/cell-cycle/addPerCellPhase.rds"
    output:
        rds = "results/marker-detection/pairwiseWilcox.{direction}.{lfc}.rds"
    log:
        out = "results/marker-detection/pairwiseWilcox.{direction}.{lfc}.out",
        err = "results/marker-detection/pairwiseWilcox.{direction}.{lfc}.err"
    message:
        "[Marker detection] Perform pairwise Wilcoxon rank sum tests (direction = '{wildcards.direction}', lfc = {wildcards.lfc})"
    threads:
        4
    script:
        "../scripts/marker-detection/pairwiseWilcox.R"

rule combineWilcox:
    input:
        rds = "results/marker-detection/pairwiseWilcox.{direction}.{lfc}.rds"
    output:
        rds = "results/marker-detection/combineWilcox.{direction}.{lfc}.{type}.rds"
    log:
        out = "results/marker-detection/combineWilcox.{direction}.{lfc}.{type}.out",
        err = "results/marker-detection/combineWilcox.{direction}.{lfc}.{type}.err"
    message:
        "[Marker detection] Combine pairwise Wilcoxon rank sum tests (direction = '{wildcards.direction}', lfc = {wildcards.lfc}, pval.type = '{wildcards.type}')"
    threads:
        4
    script:
        "../scripts/marker-detection/combineWilcox.R"

rule writeWilcox:
    input:
        rds = "results/marker-detection/combineWilcox.{direction}.{lfc}.{type}.rds"
    output:
        dir = directory("results/marker-detection/writeWilcox.{direction}.{lfc}.{type}")
    log:
        out = "results/marker-detection/writeWilcox.{direction}.{lfc}.{type}.out",
        err = "results/marker-detection/writeWilcox.{direction}.{lfc}.{type}.err"
    message:
        "[Marker detection] Write pairwise Wilcoxon rank sum tests (direction = '{wildcards.direction}', lfc = {wildcards.lfc}, pval.type = '{wildcards.type}')"
    script:
        "../scripts/marker-detection/writeWilcox.R"

rule heatmapWilcox:
    input:
        rds = ["results/cell-cycle/addPerCellPhase.rds", "results/marker-detection/combineWilcox.{direction}.{lfc}.{type}.rds"]
    output:
        pdf = "results/marker-detection/heatmapWilcox.{direction}.{lfc}.{type}.pdf"
    params:
        size = 100
    log:
        out = "results/marker-detection/heatmapWilcox.{direction}.{lfc}.{type}.out",
        err = "results/marker-detection/heatmapWilcox.{direction}.{lfc}.{type}.err"
    message:
        "[Marker detection] Plot expression of marker genes from Wilcoxon rank sum test"
    script:
        "../scripts/marker-detection/heatmapWilcox.R"

rule plotWilcoxEffects:
    input:
        rds = "results/marker-detection/combineWilcox.{direction}.{lfc}.{type}.rds"
    output:
        dir = directory("results/marker-detection/plotWilcoxEffects.{direction}.{lfc}.{type}")
    log:
        out = "results/marker-detection/plotWilcoxEffects.{direction}.{lfc}.{type}.out",
        err = "results/marker-detection/plotWilcoxEffects.{direction}.{lfc}.{type}.err"
    message:
        "[Marker detection] Plot pairwise Wilcoxon effect sizes (direction = '{wildcards.direction}', lfc = {wildcards.lfc}, pval.type = '{wildcards.type}')"
    script:
        "../scripts/marker-detection/plotWilcoxEffects.R"

rule pairwiseBinom:
    input:
        rds = "results/cell-cycle/addPerCellPhase.rds"
    output:
        rds = "results/marker-detection/pairwiseBinom.{direction}.{lfc}.rds"
    log:
        out = "results/marker-detection/pairwiseBinom.{direction}.{lfc}.out",
        err = "results/marker-detection/pairwiseBinom.{direction}.{lfc}.err"
    message:
        "[Marker detection] Perform pairwise binomial tests (direction = '{wildcards.direction}', lfc = {wildcards.lfc})"
    threads:
        4
    script:
        "../scripts/marker-detection/pairwiseBinom.R"

rule combineBinom:
    input:
        rds = "results/marker-detection/pairwiseBinom.{direction}.{lfc}.rds"
    output:
        rds = "results/marker-detection/combineBinom.{direction}.{lfc}.{type}.rds"
    log:
        out = "results/marker-detection/combineBinom.{direction}.{lfc}.{type}.out",
        err = "results/marker-detection/combineBinom.{direction}.{lfc}.{type}.err"
    message:
        "[Marker detection] Combine pairwise binomial tests (direction = '{wildcards.direction}', lfc = {wildcards.lfc}, pval.type = '{wildcards.type}')"
    threads:
        4
    script:
        "../scripts/marker-detection/combineBinom.R"

rule writeBinom:
    input:
        rds = "results/marker-detection/combineBinom.{direction}.{lfc}.{type}.rds"
    output:
        dir = directory("results/marker-detection/writeBinom.{direction}.{lfc}.{type}")
    log:
        out = "results/marker-detection/writeBinom.{direction}.{lfc}.{type}.out",
        err = "results/marker-detection/writeBinom.{direction}.{lfc}.{type}.err"
    message:
        "[Marker detection] Write pairwise binomial tests (direction = '{wildcards.direction}', lfc = {wildcards.lfc}, pval.type = '{wildcards.type}')"
    script:
        "../scripts/marker-detection/writeBinom.R"

rule heatmapBinom:
    input:
        rds = ["results/cell-cycle/addPerCellPhase.rds", "results/marker-detection/combineBinom.{direction}.{lfc}.{type}.rds"]
    output:
        pdf = "results/marker-detection/heatmapBinom.{direction}.{lfc}.{type}.pdf"
    params:
        size = 100
    log:
        out = "results/marker-detection/heatmapBinom.{direction}.{lfc}.{type}.out",
        err = "results/marker-detection/heatmapBinom.{direction}.{lfc}.{type}.err"
    message:
        "[Marker detection] Plot expression of marker genes from binomial test"
    script:
        "../scripts/marker-detection/heatmapBinom.R"

rule plotBinomEffects:
    input:
        rds = "results/marker-detection/combineBinom.{direction}.{lfc}.{type}.rds"
    output:
        dir = directory("results/marker-detection/plotBinomEffects.{direction}.{lfc}.{type}")
    log:
        out = "results/marker-detection/plotBinomEffects.{direction}.{lfc}.{type}.out",
        err = "results/marker-detection/plotBinomEffects.{direction}.{lfc}.{type}.err"
    message:
        "[Marker detection] Plot pairwise binomial effect sizes (direction = '{wildcards.direction}', lfc = {wildcards.lfc}, pval.type = '{wildcards.type}')"
    script:
        "../scripts/marker-detection/plotBinomEffects.R"