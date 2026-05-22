#!/usr/bin/env Rscript
# Idempotent dependency sync for Cursor Cloud Agents (runs from repo root on VM boot).
# Add packages here when new Rmds fail with "there is no package called ...".

options(repos = c(CRAN = "https://cloud.r-project.org"))

cran_packages <- c(
  "here", "rmarkdown", "knitr", "kableExtra", "gtsummary", "janitor",
  "tidyverse", "readxl", "writexl", "survival", "survminer", "lubridate",
  "forcats", "scales", "patchwork", "ggrepel", "pROC", "glmnet",
  "httr", "httr2", "jsonlite", "cbioportalR", "pdftools", "shiny",
  "rsconnect", "remotes", "rentrez", "digest", "DiagrammeR"
)

install_if_missing <- function(pkgs) {
  missing <- pkgs[!vapply(pkgs, requireNamespace, quietly = TRUE, FUN.VALUE = logical(1))]
  if (length(missing) == 0L) return(invisible(NULL))
  message("Installing CRAN packages: ", paste(missing, collapse = ", "))
  install.packages(missing, repos = getOption("repos"), Ncpus = max(1L, parallel::detectCores() - 1L))
  invisible(NULL)
}

install_if_missing(cran_packages)

if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager", repos = getOption("repos"))
}
bioc_packages <- c("GEOquery")
bioc_missing <- bioc_packages[!vapply(bioc_packages, requireNamespace, quietly = TRUE, FUN.VALUE = logical(1))]
if (length(bioc_missing) > 0L) {
  message("Installing Bioconductor packages: ", paste(bioc_missing, collapse = ", "))
  BiocManager::install(bioc_missing, ask = FALSE, update = FALSE)
}

if (!requireNamespace("here", quietly = TRUE)) stop("here is required but not installed")
root <- here::here()
if (!dir.exists(root)) stop("Project root not found: ", root)
message("Cloud agent R environment OK at ", root)
