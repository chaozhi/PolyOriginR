
#' @title polyOriginR
#' @description Haplotype reconstruction in polyploid multiparental populations
#' @param genofile Input genotypic data for parents and offspring
#' @param pedfile Input breeding pedigree
#' @param julia_home Path to julia.exe, Default: ''
#' @param epsilon genotyping error probability, Default: 0.01
#' @param seqerr sequencing read error probability for GBS data, Default: 0.001
#' @param chrpairing_phase chromosome pairing in parental phasing, with 22 being only bivalent formations and 44 being bi- and quadri-valent formations, Default: 22
#' @param chrpairing chromosome pairing in offspring decoding, with 22 being only bivalent formations and 44 being bivalent and quadrivalent formations, Default: 44
#' @param chrsubset subset of chromosomes, with nothing denoting all chromosomes, Default: 'nothing'
#' @param isparallel if true, multicore computing over chromosomes, Default: FALSE
#' @param delmarker if true, delete markers during parental phasing, Default: TRUE
#' @param delsiglevel significance level for deleting markers, Default: 0.05
#' @param maxstuck the max number of consecutive iterations that are rejected in a phasing run, Default: 5
#' @param maxiter the max number of iterations in a phasing run, Default: 30
#' @param minrun if the min number of phasing runs that are at the same local maximimum or have the same parental phases reaches minrun, phasing algorithm will stop before reaching the maxrun, Default: 3
#' @param maxrun the max number of phasing runs, Default: 10
#' @param byparent if true, update parental phases parent by parent, Default: TRUE
#' @param refhapfile reference haplotype file for setting absolute parental phases, Default: 'nothing'
#' @param correctthreshold a candidate marker is selected for parental error correction if the fraction of offspring genotypic error >= correctthreshold, Default: 0.15
#' @param refinemap if true, refine marker map, Default: FALSE
#' @param refineorder if true, refine marker mordering, valid only if refinemap=true, Default: FALSE
#' @param maxwinsize max size of sliding windown in map refinning, Default: 50
#' @param inittemperature initial temperature of simulated annealing in map refinning, Default: 4
#' @param coolingrate cooling rate of annealing temperature in map refinning, Default: 0.5
#' @param stripdis a chromosome end in map refinement is removed if it has a distance gap > stripdis(centiMorgan) and it contains less than 5% markers, Default: 20
#' @param maxepsilon markers in map refinement are removed it they have error rates > maxepsilon, Default: 0.5
#' @param skeletonsize the number of markers in the skeleton map that is used to reduce map length inflation by subsampling markers, Default: 50
#' @param isphysmap TRUE, if input marker map in genofile is physical map, Default: FALSE
#' @param recomrate Recombination rate in cM/Mpb, Default: 1
#' @param workdir Work directory, Default: getwd()
#' @param outstem Stem of output files, Default: 'outstem'
#' @param verbose TURE, if print details, Default: TRUE
#' @return Return 0 if sucess, and save four output files: 
#' log file: outstem.log, 
#' outstem_parentphased.csv,
#' outstem_parentphased_corrected.csv (if there exist detected errors),
#' outstem_genoprob.csv, and
#' outstem_polyancestry.csv.
#' @details 
#' PolyOriginR is implemented via PolyOriginCmd that using PolyOrigin.jl by a command line.
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  polyOriginR("geno.csv","ped.csv",julia_home="C:/path/tojulia",workdir="workdir")
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
