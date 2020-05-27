library(PolyOriginR)
workdir <- file.path(path.package("PolyOriginR"),"example")
genofile <- "geno.csv"
pedfile <- "ped.csv"

julia_home <- "C:/Users/zheng026/AppData/Local/Programs/Julia/Julia-1.4.1/bin"
polyOriginR(genofile,pedfile,julia_home=julia_home,workdir=workdir)
