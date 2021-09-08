# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jashmore@ed.ac.uk
# License: MIT

rule plotCyclins:
    input:
        rds = "results/doublet-detection/colDoublets.rds"
    output:
        pdf = "results/cell-cycle/plotCyclins.pdf"
    params:
        size = 100
    log:
        out = "results/cell-cycle/plotCyclins.out",
        err = "results/cell-cycle/plotCyclins.err"
    message:
        "[Cell cycle assignment] Plot expression of cyclins"
    script:
        "../scripts/cell-cycle/plotCyclins.R"

rule cyclone:
    input:
        rds = "results/quality-control/filterCellsByQC.rds"
    output:
        rds = "results/cell-cycle/cyclone.rds"
    params:
        rds = "human_cycle_markers.rds" # TODO: select mouse or human based on config
    log:
        out = "results/cell-cycle/cyclone.out",
        err = "results/cell-cycle/cyclone.err"
    message:
        "[Cell cycle assignment] Cell cycle phase classification"
    threads:
        4
    script:
        "../scripts/cell-cycle/cyclone.R"

rule addPerCellPhase:
    input:
        rds = ["results/doublet-detection/colDoublets.rds", "results/cell-cycle/cyclone.rds"]
    output:
        rds = "results/cell-cycle/addPerCellPhase.rds"
    log:
        out = "results/cell-cycle/addPerCellPhase.out",
        err = "results/cell-cycle/addPerCellPhase.err"
    message:
        "[Cell cycle assignment] Add cell cycle phase to SingleCellExperiment"
    script:
        "../scripts/cell-cycle/addPerCellPhase.R"

rule plotCyclone:
    input:
        rds = "results/cell-cycle/cyclone.rds"
    output:
        pdf = "results/cell-cycle/plotCyclone.pdf"
    log:
        out = "results/cell-cycle/plotCyclone.out",
        err = "results/cell-cycle/plotCyclone.err"
    message:
        "[Cell cycle assignment] Plot cyclone scores"
    script:
        "../scripts/cell-cycle/plotCyclone.R"

rule plotPhaseSina:
    input:
        rds = "results/cell-cycle/addPerCellPhase.rds"
    output:
        pdf = "results/cell-cycle/plotPhaseSina.pdf"
    log:
        out = "results/cell-cycle/plotPhaseSina.out",
        err = "results/cell-cycle/plotPhaseSina.err"
    message:
        "[Doublet detection] Plot cell-cycle phase by cluster"
    script:
        "../scripts/cell-cycle/plotPhaseSina.R"

# rule plotPhasePCA:
#     input:
#         rds = "results/cell-cycle/addPerCellPhase.rds"
#     output:
#         pdf = "results/cell-cycle/plotPhasePCA.pdf"
#     log:
#         out = "results/cell-cycle/plotPhasePCA.out",
#         err = "results/cell-cycle/plotPhasePCA.err"
#     message:
#         "[Cell cycle assignment] Plot PCA coloured by cell cycle phase"
#     script:
#         "../scripts/cell-cycle/plotPhasePCA.R"

# rule plotPhaseTSNE:
#     input:
#         rds = "results/cell-cycle/addPerCellPhase.rds"
#     output:
#         pdf = "results/cell-cycle/plotPhaseTSNE.pdf"
#     log:
#         out = "results/cell-cycle/plotPhaseTSNE.out",
#         err = "results/cell-cycle/plotPhaseTSNE.err"
#     message:
#         "[Cell cycle assignment] Plot TSNE coloured by cell cycle phase"
#     script:
#         "../scripts/cell-cycle/plotPhaseTSNE.R"

# rule plotPhaseUMAP:
#     input:
#         rds = "results/cell-cycle/addPerCellPhase.rds"
#     output:
#         pdf = "results/cell-cycle/plotPhaseUMAP.pdf"
#     log:
#         out = "results/cell-cycle/plotPhaseUMAP.out",
#         err = "results/cell-cycle/plotPhaseUMAP.err"
#     message:
#         "[Cell cycle assignment] Plot UMAP coloured by cell cycle phase"
#     script:
#         "../scripts/cell-cycle/plotPhaseUMAP.R"
