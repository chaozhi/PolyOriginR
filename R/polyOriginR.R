
#' @title polyOriginR
#' @description Haplotype reconstruction in polyploid multiparental populations
#' @param genofile Input genotypic data for parents and offspring
#' @param pedfile Input breeding pedigree
#' @param juliapath Path to julia, Default: ''
#' @param epsilon genotyping error probability, Default: 0.01
#' @param seqerr sequencing read error probability for GBS data, Default: 0.001
#' @param chrpairing_phase chromosome pairing in parental phasing, with 22 being only bivalent formations and 44 being bi- and quadri-valent formations, Default: 22
#' @param chrpairing chromosome pairing in offspring decoding, with 22 being only bivalent formations and 44 being bivalent and quadrivalent formations, Default: 44
#' @param chrsubset subset of chromosomes, c(1,10) denotes first and tenth chromosomes, and NULL for all chromosomes, Default: NULL
#' @param snpthin subset of markers, take every snpthin-th markers, Default: 1
#' @param nworker number of parallel workers for computing among chromosomes, nonparallel if nworker=1, Default: 1
#' @param delsiglevel significance level for deleting markers, Default: 0.05
#' @param maxstuck the max number of consecutive iterations that are rejected in a phasing run, Default: 5
#' @param maxiter the max number of iterations in a phasing run, Default: 30
#' @param minrun if the min number of phasing runs that are at the same local maximimum or have the same parental phases reaches minrun, phasing algorithm will stop before reaching the maxrun, Default: 3
#' @param maxrun the max number of phasing runs, Default: 10
#' @param byparent if TRUE, update parental phases parent by parent, Default: TRUE
#' @param refhapfile reference haplotype file for setting absolute parental phases, Default: 'nothing'
#' @param correctthreshold a candidate marker is selected for parental error correction if the fraction of offspring genotypic error >= correctthreshold, Default: 0.15
#' @param refinemap if TRUE, refine marker map, Default: FALSE
#' @param refineorder if TRUE, refine marker mordering, valid only if refinemap=TRUE, Default: FALSE
#' @param maxwinsize max size of sliding windown in map refinning, Default: 50
#' @param inittemperature initial temperature of simulated annealing in map refinning, Default: 4
#' @param coolingrate cooling rate of annealing temperature in map refinning, Default: 0.5
#' @param stripdis a chromosome end in map refinement is removed if it has a distance gap > stripdis(centiMorgan) and it contains less than 5% markers, Default: 20
#' @param maxepsilon markers in map refinement are removed it they have error rates > maxepsilon, Default: 0.5
#' @param skeletonsize the number of markers in the skeleton map that is used to reduce map length inflation by subsampling markers, Default: 50
#' @param isphysmap TRUE, if input marker map in genofile is physical map, Default: FALSE
#' @param recomrate Recombination rate in cM/Mpb, Default: 1
#' @param isplot TURE, if plot haploprob, Default: FALSE
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
#' PolyOriginR is implemented via PolyOriginCmd, which uses PolyOrigin.jl by a command line.
#' @examples 
#' \dontrun{
#'   polyOriginR("geno.csv","ped.csv",juliapath="C:/path/to/bin",workdir="workdir")
#' }
#' @rdname polyOriginR
#' @export 
polyOriginR <- function(genofile,pedfile,juliapath = "",
              epsilon=0.01, seqerr=0.001,
              chrpairing_phase=22, chrpairing=44, 
              chrsubset=NULL,snpthin=1,
              nworker=1, delsiglevel=0.05,
              maxstuck=5,maxiter=30,minrun=3,maxrun=10,
              byparent=TRUE, refhapfile = "nothing",
              correctthreshold=0.15,
              refinemap=FALSE,refineorder=FALSE,
              maxwinsize=50,inittemperature=4,coolingrate=0.5,
              stripdis=20, maxepsilon=0.5,skeletonsize=50,
              isphysmap = FALSE, recomrate = 1.0, isplot = FALSE, 
              workdir=getwd(),outstem = "outstem",verbose = TRUE){
  
  ## Getting OS
  genofile2 = if (dirname(genofile) == ".") file.path(workdir,genofile) else normalizePath(genofile)
  pedfile2 = if (dirname(pedfile) == ".") file.path(workdir,pedfile) else normalizePath(pedfile)
  mainfile <- file.path(path.package("PolyOriginR"),"bin","polyOrigin_main.jl")
  juliaexe <- paste0("\"",juliapath,"\"")
  mainfile <- paste0("\"",mainfile,"\"")
  genofile2 <- paste0("\"",genofile2,"\"")
  pedfile2 <- paste0("\"",pedfile2,"\"")
  workdir2 <- paste0("\"",workdir,"\"")
  recomrate2 <- format(recomrate,nsmall=3)
  chrsubset2 <- if (is.null(chrsubset)) "nothing" else paste0("[",paste(chrsubset, collapse=","),"]")
  # bool options
  refinemap2<- if (refinemap) "true" else "false"
  refineorder2<- if (refineorder) "true" else "false"
  byparent2 <- if (byparent) "true" else "false"
  isphysmap2 <- if (isphysmap) "true" else "false"
  isplot2 <- if (isplot) "true" else "false"
  verbose2 <- if (verbose) "true" else "false"
  opt <- paste("--epsilon",epsilon,"--seqerr",seqerr,
    "--chrpairing_phase",chrpairing_phase,"--chrpairing",chrpairing,
    "--chrsubset",chrsubset2,"--snpthin",snpthin,
    "--nworker",nworker,
    "--delsiglevel",delsiglevel,
    "--maxstuck",maxstuck,"--maxiter",maxiter,
    "--minrun",minrun,"--maxrun",maxrun,
    "--byparent",byparent2,"--refhapfile",refhapfile,
    "--correctthreshold",correctthreshold,
    "--refinemap",refinemap2,"--refineorder",refineorder2,
    "--maxwinsize",maxwinsize,"--inittemperature",inittemperature,
    "--coolingrate",coolingrate,"--stripdis",stripdis,
    "--maxepsilon",maxepsilon,"--skeletonsize",skeletonsize,
    "--isphysmap",isphysmap2,"--recomrate",recomrate2,
    "--isplot",isplot2,"-w",workdir2,
    "-o",outstem,"-v",verbose2)
  cmdstr <- paste(juliaexe, mainfile,"-g",genofile2,"-p",pedfile2, opt)
  system(cmdstr)
  logfile <-file.path(workdir,paste0(outstem,".log"))
  cat("Assembled command line: ",cmdstr,file=logfile,sep="\n",append=TRUE)
  return()
}
