
#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param genofile PARAM_DESCRIPTION
#' @param pedfile PARAM_DESCRIPTION
#' @param julia_home PARAM_DESCRIPTION, Default: ''
#' @param epsilon PARAM_DESCRIPTION, Default: 0.01
#' @param seqerr PARAM_DESCRIPTION, Default: 0.001
#' @param chrpairing_phase PARAM_DESCRIPTION, Default: 22
#' @param chrpairing PARAM_DESCRIPTION, Default: 44
#' @param chrsubset PARAM_DESCRIPTION, Default: 'nothing'
#' @param isparallel PARAM_DESCRIPTION, Default: FALSE
#' @param delmarker PARAM_DESCRIPTION, Default: TRUE
#' @param delsiglevel PARAM_DESCRIPTION, Default: 0.05
#' @param maxstuck PARAM_DESCRIPTION, Default: 5
#' @param maxiter PARAM_DESCRIPTION, Default: 30
#' @param minrun PARAM_DESCRIPTION, Default: 3
#' @param maxrun PARAM_DESCRIPTION, Default: 10
#' @param byparent PARAM_DESCRIPTION, Default: TRUE
#' @param refhapfile PARAM_DESCRIPTION, Default: 'nothing'
#' @param correctthreshold PARAM_DESCRIPTION, Default: 0.15
#' @param refinemap PARAM_DESCRIPTION, Default: FALSE
#' @param refineorder PARAM_DESCRIPTION, Default: FALSE
#' @param maxwinsize PARAM_DESCRIPTION, Default: 50
#' @param inittemperature PARAM_DESCRIPTION, Default: 4
#' @param coolingrate PARAM_DESCRIPTION, Default: 0.5
#' @param stripdis PARAM_DESCRIPTION, Default: 20
#' @param maxepsilon PARAM_DESCRIPTION, Default: 0.5
#' @param skeletonsize PARAM_DESCRIPTION, Default: 50
#' @param isphysmap PARAM_DESCRIPTION, Default: FALSE
#' @param recomrate PARAM_DESCRIPTION, Default: 1
#' @param workdir PARAM_DESCRIPTION, Default: getwd()
#' @param outstem PARAM_DESCRIPTION, Default: 'outstem'
#' @param verbose PARAM_DESCRIPTION, Default: TRUE
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname polyOriginR
#' @export 
polyOriginR <- function(genofile,pedfile,julia_home = "",
              epsilon=0.01, seqerr=0.001,
              chrpairing_phase=22, chrpairing=44, chrsubset="nothing",
              isparallel=FALSE, delmarker=TRUE,  delsiglevel=0.05,
              maxstuck=5,maxiter=30,minrun=3,maxrun=10,
              byparent=TRUE, refhapfile = "nothing",
              correctthreshold=0.15,
              refinemap=FALSE,refineorder=FALSE,
              maxwinsize=50,inittemperature=4,coolingrate=0.5,
              stripdis=20, maxepsilon=0.5,skeletonsize=50,
              isphysmap = FALSE, recomrate = 1.0,
              workdir=getwd(),outstem = "outstem",verbose = TRUE){
  genofile2 = if (dirname(genofile) == ".") file.path(workdir,genofile) else normalizePath(genofile)
  pedfile2 = if (dirname(pedfile) == ".") file.path(workdir,pedfile) else normalizePath(pedfile)
  juliaexe <- file.path(julia_home,"julia.exe")
  mainfile <- file.path(path.package("PolyOriginR"),"bin","polyOrigin_main.jl")
  # juliaexe <- paste0("\"",juliaexe,"\""); resulting in errors
  mainfile <- paste0("\"",mainfile,"\"")
  genofile2 <- paste0("\"",genofile2,"\"")
  pedfile2 <- paste0("\"",pedfile2,"\"")
  workdir2 <- paste0("\"",workdir,"\"")
  recomrate2 <- format(recomrate,nsmall=3)
  # bool options
  delmarker2<- if (delmarker) "true" else "false"
  refinemap2<- if (refinemap) "true" else "false"
  refineorder2<- if (refineorder) "true" else "false"
  byparent2 <- if (byparent) "true" else "false"
  isphysmap2 <- if (isphysmap) "true" else "false"
  verbose2 <- if (verbose) "true" else "false"
  opt <- paste("--epsilon",epsilon,"--seqerr",seqerr,
    "--chrpairing_phase",chrpairing_phase,"--chrpairing",chrpairing,
    "--chrsubset",chrsubset,"--isparallel",isparallel,
    "--delmarker",delmarker2,"--delsiglevel",delsiglevel,
    "--maxstuck",maxstuck,"--maxiter",maxiter,
    "--minrun",minrun,"--maxrun",maxrun,
    "--byparent",byparent2,"--refhapfile",refhapfile,
    "--correctthreshold",correctthreshold,
    "--refinemap",refinemap2,"--refineorder",refineorder2,
    "--maxwinsize",maxwinsize,"--inittemperature",inittemperature,
    "-coolingrate",coolingrate,"-stripdis",stripdis,
    "-maxepsilon",maxepsilon,"-skeletonsize",skeletonsize,
    "--isphysmap",isphysmap2,"--recomrate",recomrate2,
    "-w",workdir2,"-o",outstem,"-v",verbose2)
  cmdstr <- paste(juliaexe, mainfile,"-g",genofile2,"-p",pedfile2, opt)
  shell(cmdstr)
  logfile <-file.path(workdir,paste0(outstem,".log"))
  cat("Assembled command line: ",cmdstr,file=logfile,sep="\n",append=TRUE)
  return(0)
}
