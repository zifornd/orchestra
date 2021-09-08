# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jashmore@ed.ac.uk
# License: MIT

rule barcodeRanks:
    input:
        rds = "data/pbmc4k.rds"
    output:
        rds = "results/droplet-processing/barcodeRanks.rds"
    params:
        lower = config["DropletUtils"]["barcodeRanks"]["lower"]
    log:
        out = "results/droplet-processing/barcodeRanks.out",
        err = "results/droplet-processing/barcodeRanks.err"
    message:
        "[Droplet processing] Calculate barcode ranks"
    script:
        "../scripts/droplet-processing/barcodeRanks.R"

rule barcodeRanksPlot:
    input:
        rds = "results/droplet-processing/barcodeRanks.rds"
    output:
        pdf = "results/droplet-processing/barcodeRanksPlot.pdf"
    log:
        out = "results/droplet-processing/barcodeRanksPlot.out",
        err = "results/droplet-processing/barcodeRanksPlot.err"
    message:
        "[Droplet processing] Plot barcode ranks"
    script:
        "../scripts/droplet-processing/barcodeRanksPlot.R"

rule emptyDrops:
    input:
        rds = "data/pbmc4k.rds"
    output:
        rds = "results/droplet-processing/emptyDrops.rds"
    params:
        lower = config["DropletUtils"]["emptyDrops"]["lower"],
        niters = config["DropletUtils"]["emptyDrops"]["niters"]
    log:
        out = "results/droplet-processing/emptyDrops.out",
        err = "results/droplet-processing/emptyDrops.err"
    message:
        "[Droplet processing] Identify empty droplets"
    script:
        "../scripts/droplet-processing/emptyDrops.R"

rule emptyDropsLimited:
    input:
        rds = "results/droplet-processing/emptyDrops.rds"
    output:
        pdf = "results/droplet-processing/emptyDropsLimited.pdf"
    params:
        FDR = config["DropletUtils"]["emptyDrops"]["FDR"]
    log:
        out = "results/droplet-processing/emptyDropsLimited.out",
        err = "results/droplet-processing/emptyDropsLimited.err"
    message:
        "[Droplet processing] Plot droplet limited"
    script:
        "../scripts/droplet-processing/emptyDropsLimited.R"

rule emptyDropsAmbient:
    input:
        rds = "data/pbmc4k.rds"
    output:
        rds = "results/droplet-processing/emptyDropsAmbient.rds"
    params:
        lower = config["DropletUtils"]["emptyDrops"]["lower"],
        niters = config["DropletUtils"]["emptyDrops"]["niters"]
    log:
        out = "results/droplet-processing/emptyDropsAmbient.out",
        err = "results/droplet-processing/emptyDropsAmbient.err"
    message:
        "[Droplet processing] Test ambient droplets"
    script:
        "../scripts/droplet-processing/emptyDropsAmbient.R"

rule emptyDropsPValue:
    input:
        rds = "results/droplet-processing/emptyDropsAmbient.rds"
    output:
        pdf = "results/droplet-processing/emptyDropsPValue.pdf"
    log:
        out = "results/droplet-processing/emptyDropsPValue.out",
        err = "results/droplet-processing/emptyDropsPValue.err"
    message:
        "[Droplet processing] Plot ambient droplet P value"
    script:
        "../scripts/droplet-processing/emptyDropsPValue.R"

rule emptyDropsLogProb:
    input:
        rds = "results/droplet-processing/emptyDrops.rds"
    output:
        pdf = "results/droplet-processing/emptyDropsLogProb.pdf"
    params:
        FDR = config["DropletUtils"]["emptyDrops"]["FDR"]
    log:
        out = "results/droplet-processing/emptyDropsLogProb.out",
        err = "results/droplet-processing/emptyDropsLogProb.err"
    message:
        "[Droplet processing] Plot droplet log probability"
    script:
        "../scripts/droplet-processing/emptyDropsLogProb.R"

rule emptyDropsRank:
    input:
        rds = "results/droplet-processing/emptyDrops.rds"
    output:
        pdf = "results/droplet-processing/emptyDropsRank.pdf"
    params:
        FDR = config["DropletUtils"]["emptyDrops"]["FDR"]
    log:
        out = "results/droplet-processing/emptyDropsRank.out",
        err = "results/droplet-processing/emptyDropsRank.err"
    message:
        "[Droplet processing] Plot droplet rank"
    script:
        "../scripts/droplet-processing/emptyDropsRank.R"

rule filterByDrops:
    input:
        rds = ["data/pbmc4k.rds", "results/droplet-processing/emptyDrops.rds"]
    output:
        rds = "results/droplet-processing/filterByDrops.rds"
    params:
        FDR = config["DropletUtils"]["emptyDrops"]["FDR"]
    log:
        out = "results/droplet-processing/filterByDrops.out",
        err = "results/droplet-processing/filterByDrops.err"
    message:
        "[Droplet processing] Filter droplets by {params.FDR} FDR threshold"
    script:
        "../scripts/droplet-processing/filterByDrops.R"
