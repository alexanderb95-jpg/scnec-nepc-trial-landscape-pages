#!/usr/bin/env Rscript
# StemAI cloud/local render: staged prerequisites + full Master knit.
# Usage (project root): Rscript scripts/render_stemai_cloud.R
# Env: STEMAI_SKIP_TCGA=1 to skip TCGA download attempts
#      STEMAI_CHILD_ONLY=StemAI_01_Data_Loading to render one child for debugging

if (!requireNamespace("here", quietly = TRUE)) install.packages("here", repos = "https://cloud.r-project.org")
root <- here::here()
setwd(root)
log_dir <- here::here("data", "stemai_qc")
dir.create(log_dir, recursive = TRUE, showWarnings = FALSE)
log_file <- file.path(log_dir, paste0("render_log_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".txt"))
log_msg <- function(...) {
  line <- paste0(format(Sys.time(), "%Y-%m-%d %H:%M:%S"), " | ", paste(..., collapse = " "))
  message(line)
  cat(line, "\n", file = log_file, append = TRUE)
}

log_msg("StemAI render start at ", root)

# --- Stage 0: DepMap cache ---
cache_path <- here::here("data", "HMA_BCL2_depmap_cache.rds")
if (!file.exists(cache_path) || file.size(cache_path) < 1000) {
  log_msg("Building DepMap cache...")
  source(here::here("scripts", "load_depmap_cache.R"), local = new.env())
} else {
  log_msg("DepMap cache OK")
}

# --- Stage 1: TCGA harmonized (optional) ---
if (!identical(Sys.getenv("STEMAI_SKIP_TCGA"), "1")) {
  for (script in c("download_tcga_prad.R", "download_tcga_laml.R")) {
    sp <- here::here("scripts", script)
    if (file.exists(sp)) {
      log_msg("Running ", script, " (may be slow on first run)...")
      tryCatch(source(sp, local = new.env()), error = function(e) log_msg(script, " failed: ", conditionMessage(e)))
    }
  }
  tryCatch(source(here::here("scripts", "load_tcga_stemai.R"), local = new.env()), error = function(e) log_msg("load_tcga_stemai failed: ", conditionMessage(e)))
} else {
  log_msg("STEMAI_SKIP_TCGA=1; skipping TCGA download/harmonize")
}

# --- Stage 2: Cohort RDS hint ---
cohort_ext <- here::here("data", "HMA_BCL2_cohort_assignments_TNBC_Lymphoma.rds")
if (!file.exists(cohort_ext)) {
  log_msg("NOTE: ", cohort_ext, " missing. StemAI_01 uses fallback cohort or inline TNBC_Lymphoma assignment (knit Cell_Line_Assignment_Verification_TNBC_Lymphoma.Rmd for full DLBCL/neuroblastoma strata).")
}

# --- Stage 3: Render ---
child_only <- Sys.getenv("STEMAI_CHILD_ONLY", "")
if (nzchar(child_only)) {
  child_file <- if (!grepl("\\.Rmd$", child_only, ignore.case = TRUE)) paste0(child_only, ".Rmd") else child_only
  rmd <- here::here("rmarkdown", child_file)
  log_msg("Rendering child only: ", rmd)
  out <- rmarkdown::render(rmd, output_dir = here::here("outputs"), quiet = FALSE)
  log_msg("Child output: ", out)
  quit(save = "no", status = 0)
}

master_rmd <- here::here("rmarkdown", "StemAI_Master.Rmd")
if (!file.exists(master_rmd)) stop("Missing ", master_rmd)

log_msg("Rendering StemAI_Master.Rmd (long run; use Cloud agent for best results)...")
out <- tryCatch(
  rmarkdown::render(
    master_rmd,
    output_dir = here::here("outputs"),
    output_file = "StemAI_Master.html",
    envir = new.env(),
    quiet = FALSE
  ),
  error = function(e) {
    log_msg("RENDER FAILED: ", conditionMessage(e))
    stop(e)
  }
)
log_msg("SUCCESS: ", out)
log_msg("Artifacts: ", here::here("data", "StemAI_*.rds"), " and figures/StemAI/")
invisible(out)
