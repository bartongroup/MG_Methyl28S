suppressPackageStartupMessages({
  library(targets)
  library(tarchetypes)
  library(dplyr)
  library(tibble)
  library(qs)
})

options(tidyverse.quiet = TRUE, dplyr.summarise.inform = FALSE)

# attach R packages
required_packages <- read.delim("R/packages", header = FALSE, col.names = "name")$name
tar_option_set(packages = required_packages, format = "qs")

# Create dirs if necessary
# for (d in c("tab", "fig", "cache")) if (!dir.exists(d)) dir.create(d)

# for interactive session only
if (interactive()) sapply(required_packages, library, character.only = TRUE)

# load all functions from .R files
files_R <- list.files(c("R", "targets"), pattern = "*.R$", full.names = TRUE)
sr_ <- sapply(files_R, source)

# prevent other packages from stealing from tidyverse
filter <- dplyr::filter
rename <- dplyr::rename
select <- dplyr::select
slice <- dplyr::slice
first <- dplyr::first
last <- dplyr::last

# Add session info
sesinfo <- list(
  tar_target(session_info, sessionInfo())
)

# Targets
c(
  sesinfo,
  targets_main()
)

