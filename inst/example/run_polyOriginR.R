library(PolyOriginR)
workdir <- "C:/Chaozhi/Workspace/RWorkspace/workspace_PolyOriginR/run_PolyOriginR"
genofile <- "geno.csv"
pedfile <- "ped.csv"
julia_home <- "C:/Users/zheng026/AppData/Local/Programs/Julia/Julia-1.4.1/bin"
polyOriginR(genofile,pedfile,julia_home=julia_home,workdir=workdir)
