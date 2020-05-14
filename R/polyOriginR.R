
#' @title polyOriginR
#' @description Haplotype reconstruction in polyploid multiparental populations
#' @param genofile Input genotypic data for parents and offspring
#' @param pedfile Input breeding pedigree
#' @param julia_home Path to julia.exe, Default: ''
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
  # outstem2 <- paste0("\"",outstem,"\"")
  # workdir2 <- paste0("\"",workdir,"\"")
  isphysmap2 <- if (isphysmap) "true" else "false"
  verbose2 <- if (verbose) "true" else "false"
  recomrate2 <- format(recomrate,nsmall=3)
  opt1 <- paste("--isphysmap",isphysmap2,"--recomrate",recomrate2,
                "-w",workdir,"-o",outstem,"-v",verbose2);
  cmdstr <- paste(juliaexe, mainfile,"-g",genofile2,"-p",pedfile2, opt1)
  shell(cmdstr)
  logfile <-file.path(workdir,paste0(outstem,".log"))
  cat("Assembled command line: ",cmdstr,file=logfile,sep="\n",append=TRUE)
  return(0)
}
