# StemAI shared configuration (sourced by Master/children and cloud render).
# Query scope for sentinel reproducibility checks (RCAN1 is diagnostic, not forced).

if (!requireNamespace("here", quietly = TRUE)) {
  install.packages("here", repos = "https://cloud.r-project.org")
}

STEMAI_QUERY_SCOPE <- paste(
  "HMA+BCL2 and novel epigenetic combination therapies",
  "in stem-like cancers"
)

STEMAI_STEM_LIKE_LEVELS <- c(
  "SCLC",
  "ExPulm-SCNEC",
  "AML (control)",
  "DLBCL/MCL/CLL",
  "Neuroblastoma"
)

STEMAI_NON_STEM_LABEL <- "Non-stem-like"

STEMAI_VALIDATION_PARTITIONS <- c("seen", "unseen", "external_literature_supported")

STEMAI_SEEN_SOURCES <- c("DepMap", "GDSC", "CTRPv2", "GSE68379")
STEMAI_UNSEEN_SOURCES <- c("TCGA-PRAD", "TCGA-LAML", "PubMed")

stemai_data_dir <- here::here("data")
stemai_outputs_dir <- here::here("outputs")
stemai_figures_dir <- here::here("figures", "StemAI")
stemai_qc_dir <- here::here("data", "stemai_qc")
stemai_cache_dir <- here::here("_cache", "StemAI_")

for (d in c(stemai_data_dir, stemai_outputs_dir, stemai_figures_dir, stemai_qc_dir)) {
  if (!dir.exists(d)) dir.create(d, recursive = TRUE, showWarnings = FALSE)
}

STEMAI_WORKSPACE_RDS <- file.path(stemai_data_dir, "StemAI_workspace.rds")
STEMAI_FEATURES_RDS <- file.path(stemai_data_dir, "StemAI_engineered_features.rds")
STEMAI_RANKED_RDS <- file.path(stemai_data_dir, "StemAI_ranked_outputs.rds")
STEMAI_EVIDENCE_RDS <- file.path(stemai_data_dir, "StemAI_evidence_packages.rds")
STEMAI_RCAN1_BASELINE_RDS <- file.path(stemai_qc_dir, "RCAN1_sentinel_baseline.rds")
STEMAI_RCAN1_LAST_RUN_RDS <- file.path(stemai_qc_dir, "RCAN1_sentinel_last_run.rds")
STEMAI_REPRO_REPORT_RDS <- file.path(stemai_qc_dir, "RCAN1_sentinel_repro_report.rds")

assign_stem_like_group <- function(lineage_group_chr) {
  lg <- as.character(lineage_group_chr)
  dplyr::case_when(
    lg %in% STEMAI_STEM_LIKE_LEVELS ~ "Stem-like",
    grepl("Neuroblastoma", lg, fixed = TRUE) ~ "Stem-like",
    grepl("lymphoma|DLBCL|MCL|CLL", lg, ignore.case = TRUE) ~ "Stem-like",
    is.na(lg) | !nzchar(lg) ~ NA_character_,
    TRUE ~ STEMAI_NON_STEM_LABEL
  )
}

assign_stem_like_subtype <- function(lineage_group_chr) {
  lg <- as.character(lineage_group_chr)
  dplyr::case_when(
    lg == "SCLC" ~ "SCLC",
    lg == "ExPulm-SCNEC" ~ "ExPulm-SCNEC",
    lg == "AML (control)" ~ "AML",
    lg %in% c("DLBCL/MCL/CLL") | grepl("lymphoma|DLBCL|MCL|CLL", lg, ignore.case = TRUE) ~ "DLBCL/high-grade lymphoma",
    grepl("Neuroblastoma", lg, fixed = TRUE) ~ "Neuroblastoma",
    TRUE ~ lg
  )
}
