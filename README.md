
# PolyOriginR

<!-- badges: start -->
<!-- badges: end -->

PolyOriginR is a wrapper for using PolyOrigin.jl (https://github.com/chaozhi/PolyOrigin.jl), for haplotye reconstruction in polyploid multiparental pouplations. 

## Installation

First download and install Julia available at https://julialang.org/. Then install the development version of PolyOriginR from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("chaozhi/PolyOriginR")
```

## Example

``` r
library(PolyOriginR)
polyOriginR("geno.csv","ped.csv",julia_home="C:/path/to/bin",workdir="workdir")
```
Here julia_home is where julia.exe is located, and "workdir" is the directory for input and output files. See R script and input files in the "inst/example" folder. 

