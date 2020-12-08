
# devtools::install_github("chaozhi/PolyOriginR")

library(PolyOriginR)
workdir <- file.path(path.package("PolyOriginR"),"example")
genofile <- "geno.csv"
pedfile <- "ped.csv"

## If Windows julia.exe path
juliapath <- "C:/Users/zheng026/AppData/Local/Programs/Julia 1.5.3/bin/julia.exe"

## If Linux/Mac julia path
juliapath <- "/home/username/Julia/Julia-1.5.3/bin/julia"

polyOriginR(genofile,pedfile,juliapath=juliapath,workdir=workdir)
