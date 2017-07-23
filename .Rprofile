###----------------------------------------------------------------------------
###
###----------------------------------------------------------------------------
if(interactive())
{
    setwd("~/code/cdcopula/")
}

##-----------------------------------------------------------------------------
## Settings on R start up
##-----------------------------------------------------------------------------

## Some settings and variables created for hidden environment
.mylocal.env <- new.env()
local(expr <- {

  ## Set CRAN
  options(repos="https://cloud.r-project.org/")
  options(download.file.method="wget")
  ## Load history
  history.path <- "~/.Rhistory"
  try(utils::loadhistory(file=history.path), silent = TRUE)

  ## Load sourceDir() to the base environment
  code.path <- "~/code/"
  ## sys.source(paste(code.path, "flutils/R/systools/sourceDir.R", sep = ""), envir = baseenv())
  ## sys.source(paste(Rutils.path, "/systools/autoupdate.packages.R", sep = ""),
  ##            envir = baseenv())

##   R.user.path <- paste(
##         "~/.R/library/", R.version$major, ".",  "xxx","@",
##         gsub(.Platform$file.sep, "-",
##              substr(Sys.getenv("R_HOME"), 2, nchar(Sys.getenv("R_HOME"))-6))
##         , sep = "")

##     if(!file.exists(R.user.path))
##         {
##             dir.create(R.user.path, recursive = TRUE)
##         }

}, envir = .mylocal.env)


## Library
## .libPaths(get("R.user.path", envir = .mylocal.env))

##------------------------------------------------------------------------------
## source Rutiles
##------------------------------------------------------------------------------
## use devtools::install_local("flutils")
## sourceDir(paste(get("code.path", envir = .mylocal.env), "flutils", sep = ""),
##           byte.compile = 1,
##           recursive = TRUE,
##           ignore.error = TRUE)

##------------------------------------------------------------------------------
## Check packages in personal library for update
##------------------------------------------------------------------------------
## autoupdate.packages(when = "Friday", insOnloc.if.noPrivilege = FALSE)

if(interactive())
    {

###-----------------------------------------------------------------------------
### Load packages
###-----------------------------------------------------------------------------
        require("mvtnorm", quiet = TRUE)
        require("VineCopuladiscretecontinuous", quiet = TRUE)
        require("DiscreteRVine", quiet = TRUE)
        require("flutils")

###-----------------------------------------------------------------------------
### Start up information
###-----------------------------------------------------------------------------
        ## setwd("~/WorkSpace/MovingKnots/R")
        .welcome <- function()
            {
                message(c("Working directory: ","\"", getwd(),"\""))
                message(c("R home:            ","\"", Sys.getenv("R_HOME"),"\""))
                ## message(c("Attached packages: ","\"", search()[search()%in%paste("package:",loadedNamespaces(),sep="")],"\""))
                message(c("OMP_NUM_THREADS:   ","\"", Sys.getenv("OMP_NUM_THREADS"),"\""))
            }
        .welcome()

  ##------------------------------------------------------------
  ## Options
  ##------------------------------------------------------------
  ##
        options(browserNLdisabled = TRUE, # Disable newline in browser
                width = 90 # max print width
                )
    }

##------------------------------------------------------------------------------
## Settings on R exit
##------------------------------------------------------------------------------
.Last <- function()
    {
        ## Save history
        if(interactive() == TRUE)
            {
                timestamp(quiet = TRUE) ## create a time stamp on this history
                try(savehistory(file=get("history.path", envir = .mylocal.env)), silent = TRUE)
            }
    }
