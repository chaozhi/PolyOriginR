
# PolyOriginR

<!-- badges: start -->
<!-- badges: end -->

PolyOriginR is a wrapper for using PolyOrigin.jl, for haplotye reconstruction in polyploid multiparental pouplations. 

## Installation

You can install the development version of PolyOriginR from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("chaozhi/PolyOriginR")
```

## Example

``` r
library(PolyOriginR)
polyOriginR("geno.csv","ped.csv",
  julia_home="C:/path/to/julia/bin",workdir="workdir")
```
Here julia_home is where julia.exe is located, and "workdir" is the directory for input and output files.

