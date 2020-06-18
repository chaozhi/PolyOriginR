
# PolyOriginR

<!-- badges: start -->
<!-- badges: end -->

PolyOriginR is a wrapper of PolyOrigin.jl (https://github.com/chaozhi/PolyOrigin.jl), for haplotye reconstruction in polyploid multiparental pouplations. 

## Installation

First download and install Julia available at https://julialang.org/. Then install the development version of PolyOriginR from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("chaozhi/PolyOriginR")
```

## Example

``` r
library(PolyOriginR)
polyOriginR("geno.csv","ped.csv",juliapath="C:/path/to/bin",workdir="workdir")
```
Here julia_home is where julia.exe is located, and workdir is the directory for input and output files. See R script and input files in the "inst/example" folder. 


## Usage

```r
polyOriginR(
  genofile,
  pedfile,
  juliapath = "",
  epsilon = 0.01,
  seqerr = 0.001,
  chrpairing_phase = 22,
  chrpairing = 44,
  chrsubset = NULL,
  snpthin = 1,
  nworker = 1,
  delsiglevel = 0.05,
  maxstuck = 5,
  maxiter = 30,
  minrun = 3,
  maxrun = 10,
  byparent = TRUE,
  refhapfile = "nothing",
  correctthreshold = 0.15,
  refinemap = FALSE,
  refineorder = FALSE,
  maxwinsize = 50,
  inittemperature = 4,
  coolingrate = 0.5,
  stripdis = 20,
  maxepsilon = 0.5,
  skeletonsize = 50,
  isphysmap = FALSE,
  recomrate = 1,
  workdir = getwd(),
  outstem = "outstem",
  verbose = TRUE
)
```


## Arguments

Argument      |Description
------------- |----------------
```genofile```     |     Input genotypic data for parents and offspring
```pedfile```     |     Input breeding pedigree
```juliapath```     |     Path to julia.exe, Default: ''
```epsilon```     |     genotyping error probability, Default: 0.01
```seqerr```     |     sequencing read error probability for GBS data, Default: 0.001
```chrpairing_phase```     |     chromosome pairing in parental phasing, with 22 being only bivalent formations and 44 being bi- and quadri-valent formations, Default: 22
```chrpairing```     |     chromosome pairing in offspring decoding, with 22 being only bivalent formations and 44 being bivalent and quadrivalent formations, Default: 44
```chrsubset```     |     subset of chromosomes, c(1,10) denotes first and tenth chromosomes, and NULL for all chromosomes, Default: NULL
```snpthin```     |     subset of markers, take every snpthin-th markers, Default: 1
```nworker```     |     number of parallel workers for computing among chromosomes, nonparallel if nworker=1, Default: 1
```delsiglevel```     |     significance level for deleting markers, Default: 0.05
```maxstuck```     |     the max number of consecutive iterations that are rejected in a phasing run, Default: 5
```maxiter```     |     the max number of iterations in a phasing run, Default: 30
```minrun```     |     if the min number of phasing runs that are at the same local maximimum or have the same parental phases reaches minrun, phasing algorithm will stop before reaching the maxrun, Default: 3
```maxrun```     |     the max number of phasing runs, Default: 10
```byparent```     |     if TRUE, update parental phases parent by parent, Default: TRUE
```refhapfile```     |     reference haplotype file for setting absolute parental phases, Default: 'nothing'
```correctthreshold```     |     a candidate marker is selected for parental error correction if the fraction of offspring genotypic error >= correctthreshold, Default: 0.15
```refinemap```     |     if TRUE, refine marker map, Default: FALSE
```refineorder```     |     if TRUE, refine marker mordering, valid only if refinemap=TRUE, Default: FALSE
```maxwinsize```     |     max size of sliding windown in map refinning, Default: 50
```inittemperature```     |     initial temperature of simulated annealing in map refinning, Default: 4
```coolingrate```     |     cooling rate of annealing temperature in map refinning, Default: 0.5
```stripdis```     |     a chromosome end in map refinement is removed if it has a distance gap > stripdis(centiMorgan) and it contains less than 5% markers, Default: 20
```maxepsilon```     |     markers in map refinement are removed it they have error rates > maxepsilon, Default: 0.5
```skeletonsize```     |     the number of markers in the skeleton map that is used to reduce map length inflation by subsampling markers, Default: 50
```isphysmap```     |     TRUE, if input marker map in genofile is physical map, Default: FALSE
```recomrate```     |     Recombination rate in cM/Mpb, Default: 1
```isplot```     |     TURE, if plot haploprob, Default: FALSE
```workdir```     |     Work directory, Default: getwd()
```outstem```     |     Stem of output files, Default: 'outstem'
```verbose```     |     TURE, if print details, Default: TRUE

## Details


 PolyOriginR is implemented via PolyOriginCmd, which uses PolyOrigin.jl by a command line.


## Value


 Return 0 if success, and export four output files.
 
 Argument      |Description
------------- |----------------
```outstem.log```     |  log file
```outstem_doseprob.csv```     |  posterior dosage probabilities for all offspring
```outstem_parentphased.csv```     |  same as input genofile except parents being phased
```outstem_parentphased_corrected.csv```     |  exported if there exist detected parental errors
```outstem_polyancestry.csv```     |  genoprob and estimation of chromosome pairing 
```outstem_genoprob.csv```     |  a simplified version of outstem_polyancestry.csv
```outstem_plots```     |  a folder contains plots of haploprob if isplot = true

Here outstem_doseprob.csv, outstem_parentphased.csv, and outstem_parentphased_corrected.csv can be iteratively used as input genofile, so that the step of parental phasing will be skipped.  The outstem_doseprob.csv can be used for correcting observed genotypes and imputing missing genotypes, using an appropriate threshould. 

## Citing PolyOrigin

 If you use PolyOriginR in your analyses and publish your results, please cite the article:

  *Zheng C, Amadeu R, Munoz P, and Endelman J. 2020. Haplotype reconstruction in tetraploid multi-parental populations. In preparation.*


