# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jashmore@ed.ac.uk
# License: MIT

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

rule aggregateAcrossCells:
    input:
        rds = "results/cell-cycle/addPerCellPhase.rds"
    output:
        rds = "results/trajectory/aggregateAcrossCells.rds"
    log:
        out = "results/trajectory/aggregateAcrossCells.out",
        err = "results/trajectory/aggregateAcrossCells.err"
    message:
        "[Trajectory analysis]"
    script:
        "../scripts/trajectory/aggregateAcrossCells.R"

rule createClusterMST:
    input:
        rds = "results/trajectory/aggregateAcrossCells.rds"
    output:
        rds = "results/trajectory/createClusterMST.rds"
    params:
        outgroup = True
    log:
        out = "results/trajectory/createClusterMST.out",
        err = "results/trajectory/createClusterMST.err"
    message:
        "[Trajectory analysis] Create MST on cluster centroids"
    script:
        "../scripts/trajectory/createClusterMST.R"

rule reportEdges:
    input:
        rds = ["results/trajectory/aggregateAcrossCells.rds", "results/trajectory/createClusterMST.rds"]
    output:
        rds = "results/trajectory/reportEdges.{dim}.rds"
    params:
        dim = "{dim}"
    log:
        out = "results/trajectory/reportEdges.{dim}.out",
        err = "results/trajectory/reportEdges.{dim}.err"
    message:
        "[Trajectory analysis] Report MST edge coordinates"
    script:
        "../scripts/trajectory/reportEdges.R"

rule plotEdges:
    input:
        rds = ["results/cell-cycle/addPerCellPhase.rds", "results/trajectory/reportEdges.{dim}.rds"]
    output:
        pdf = "results/trajectory/plotEdges.{dim}.pdf"
    params:
        dim = "{dim}"
    log:
        out = "results/trajectory/plotEdges.{dim}.out",
        err = "results/trajectory/plotEdges.{dim}.err"
    message:
        "[Trajectory analysis] Plot MST edge coordinates"
    script:
        "../scripts/trajectory/plotEdges.R"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

rule slingshot:
    input:
        rds = "results/cell-cycle/addPerCellPhase.rds"
    output:
        rds = "results/trajectory/slingshot.rds"
    params:
        omega = True
    log:
        out = "results/trajectory/slingshot.out",
        err = "results/trajectory/slingshot.err"
    message:
        "[Trajectory analysis] Perform lineage inference with Slingshot"
    script:
        "../scripts/trajectory/slingshot.R"

rule slingPseudotime:
    input:
        rds = "results/trajectory/slingshot.rds"
    output:
        rds = "results/trajectory/slingPseudotime.rds"
    log:
        out = "results/trajectory/slingPseudotime.out",
        err = "results/trajectory/slingPseudotime.err"
    message:
        "[Trajectory analysis] Get Slingshot pseudotime values"
    script:
        "../scripts/trajectory/slingPseudotime.R"

rule embedCurves:
    input:
        rds = ["results/cell-cycle/addPerCellPhase.rds", "results/trajectory/slingshot.rds"]
    output:
        rds = "results/trajectory/embedCurves.{dim}.rds"
    params:
        dim = "{dim}"
    log:
        out = "results/trajectory/embedCurves.{dim}.out",
        err = "results/trajectory/embedCurves.{dim}.err"
    message:
        "[Trajectory analysis] Embed trajectory in new space"
    script:
        "../scripts/trajectory/embedCurves.R"

rule slingCurves:
    input:
        rds = "results/trajectory/embedCurves.{dim}.rds"
    output:
        rds = "results/trajectory/slingCurves.{dim}.rds"
    log:
        out = "results/trajectory/slingCurves.{dim}.out",
        err = "results/trajectory/slingCurves.{dim}.err"
    message:
        "[Trajectory analysis] Extract simultaneous principal curves"
    script:
        "../scripts/trajectory/slingCurves.R"

rule plotCurves:
    input:
        rds = ["results/cell-cycle/addPerCellPhase.rds",
               "results/trajectory/slingPseudotime.rds",
               "results/trajectory/slingCurves.{dim}.rds"]
    output:
        pdf = "results/trajectory/plotCurves.{dim}.pdf"
    params:
        dim = "{dim}"
    log:
        out = "results/trajectory/plotCurves.{dim}.out",
        err = "results/trajectory/plotCurves.{dim}.err"
    message:
        "[Trajectory analysis] Plot principal curvers"
    script:
        "../scripts/trajectory/plotCurves.R"

rule testPseudotime:
    input:
        rds = ["results/cell-cycle/addPerCellPhase.rds", "results/trajectory/slingPseudotime.rds"]
    output:
        rds = "results/trajectory/testPseudotime.rds"
    log:
        out = "results/trajectory/testPseudotime.out",
        err = "results/trajectory/testPseudotime.err"
    message:
        "[Trajectory analysis] Test for differences along pseudotime"
    script:
        "../scripts/trajectory/testPseudotime.R"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

rule perCellEntropy:
    input:
        rds = "results/cell-cycle/addPerCellPhase.rds"
    output:
        rds = "results/trajectory/perCellEntropy.rds"
    log:
        out = "results/trajectory/perCellEntropy.out",
        err = "results/trajectory/perCellEntropy.err"
    message:
        "[Trajectory analysis] Compute the per-cell entropy"
    script:
        "../scripts/trajectory/perCellEntropy.R"

rule plotEntropy:
    input:
        rds = ["results/cell-cycle/addPerCellPhase.rds", "results/trajectory/perCellEntropy.rds"]
    output:
        pdf = "results/trajectory/plotEntropy.pdf"
    log:
        out = "results/trajectory/plotEntropy.out",
        err = "results/trajectory/plotEntropy.err"
    message:
        "[Trajectory analysis] Plot the per-cell entropy"
    script:
        "../scripts/trajectory/plotEntropy.R"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

rule scvelo:
    input:
        rds = "results/cell-cycle/addPerCellPhase.rds"
    output:
        rds = "results/trajectory/scvelo.rds"
    log:
        out = "results/trajectory/scvelo.out",
        err = "results/trajectory/scvelo.err"
    message:
        "[Trajectory analysis] RNA velocity with scVelo"
    threads:
        4
    script:
        "../scripts/trajectory/scvelo.R"

rule embedVelocity:
    input:
        rds = ["results/cell-cycle/addPerCellPhase.rds", "results/trajectory/scvelo.rds"]
    output:
        rds = "results/trajectory/embedVelocity.{reducedDim}.rds"
    log:
        out = "results/trajectory/embedVelocity.{reducedDim}.out",
        err = "results/trajectory/embedVelocity.{reducedDim}.err"
    message:
        "[Trajectory analysis] Project velocities onto {wildcards.reducedDim} embedding"
    script:
        "../scripts/trajectory/embedVelocity.R"

rule gridVectors:
    input:
        rds = ["results/cell-cycle/addPerCellPhase.rds", "results/trajectory/embedVelocity.{reducedDim}.rds"]
    output:
        rds = "results/trajectory/gridVectors.{reducedDim}.rds"
    log:
        out = "results/trajectory/gridVectors.{reducedDim}.out",
        err = "results/trajectory/gridVectors.{reducedDim}.err"
    message:
        "[Trajectory analysis] Summarize {wildcards.reducedDim} vectors into a grid"
    script:
        "../scripts/trajectory/gridVectors.R"

rule plotVeloPCA:
    input:
        rds = ["results/cell-cycle/addPerCellPhase.rds", "results/trajectory/gridVectors.PCA.rds"]
    output:
        pdf = "results/trajectory/plotVeloPCA.pdf"
    log:
        out = "results/trajectory/plotVeloPCA.out",
        err = "results/trajectory/plotVeloPCA.err"
    message:
        "[Trajectory analysis] Plot PCA and RNA velocity vectors"
    script:
        "../scripts/trajectory/plotVeloPCA.R"

rule plotVeloTSNE:
    input:
        rds = ["results/cell-cycle/addPerCellPhase.rds", "results/trajectory/gridVectors.TSNE.rds"]
    output:
        pdf = "results/trajectory/plotVeloTSNE.pdf"
    log:
        out = "results/trajectory/plotVeloTSNE.out",
        err = "results/trajectory/plotVeloTSNE.err"
    message:
        "[Trajectory analysis] Plot TSNE and RNA velocity vectors"
    script:
        "../scripts/trajectory/plotVeloTSNE.R"

rule plotVeloUMAP:
    input:
        rds = ["results/cell-cycle/addPerCellPhase.rds", "results/trajectory/gridVectors.UMAP.rds"]
    output:
        pdf = "results/trajectory/plotVeloUMAP.pdf"
    log:
        out = "results/trajectory/plotVeloUMAP.out",
        err = "results/trajectory/plotVeloUMAP.err"
    message:
        "[Trajectory analysis] Plot UMAP and RNA velocity vectors"
    script:
        "../scripts/trajectory/plotVeloUMAP.R"