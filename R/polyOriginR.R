
#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param genofile PARAM_DESCRIPTION
#' @param pedfile PARAM_DESCRIPTION
#' @param julia_home PARAM_DESCRIPTION, Default: ''
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
