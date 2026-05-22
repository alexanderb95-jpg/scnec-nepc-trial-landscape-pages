#!/usr/bin/env Rscript
# Load harmonized TCGA-PRAD + TCGA-LAML caches for StemAI (patient-tumor layer).
# Run from project root after: Rscript scripts/download_tcga_prad.R
# and Rscript scripts/download_tcga_laml.R

if (!requireNamespace("here", quietly = TRUE)) {
  install.packages("here", repos = "https://cloud.r-project.org")
}
library(dplyr)
source(here::here("scripts", "stemai_config.R"), local = FALSE)

load_tcga_cohort <- function(cache_path, cohort_id) {
  if (!file.exists(cache_path) || file.size(cache_path) < 1000) {
    return(list(ok = FALSE, cohort = cohort_id, reason = "cache_missing"))
  }
  obj <- tryCatch(readRDS(cache_path), error = function(e) NULL)
  if (is.null(obj) || is.null(obj$rna_mat) || is.null(obj$clin)) {
    return(list(ok = FALSE, cohort = cohort_id, reason = "invalid_cache"))
  }
  gene_sym <- obj$gene_sym
  if (is.null(gene_sym) || length(gene_sym) != nrow(obj$rna_mat)) {
    gene_sym <- rownames(obj$rna_mat)
  }
  mat <- obj$rna_mat
  if (max(mat, na.rm = TRUE) > 1000) mat <- log2(1 + mat)

  bcl2_idx <- which(grepl("^BCL2$|^BCL2\\s", gene_sym, ignore.case = TRUE))[1]
  ar_genes <- c("AR", "KLK3", "TMPRSS2")
  ne_genes <- c("CHGA", "SYP", "ENO2", "ASCL1", "NCAM1")
  ar_idx <- which(gene_sym %in% ar_genes)
  ne_idx <- which(gene_sym %in% ne_genes)
  if (length(bcl2_idx) == 0 || is.na(bcl2_idx)) bcl2_idx <- which(rownames(mat) == "BCL2")[1]

  bcl2_vec <- if (length(bcl2_idx) > 0 && !is.na(bcl2_idx)) as.numeric(mat[bcl2_idx, ]) else rep(NA_real_, ncol(mat))
  ar_sig <- if (length(ar_idx) > 0) colMeans(mat[ar_idx, , drop = FALSE], na.rm = TRUE) else rep(NA_real_, ncol(mat))
  ne_sig <- if (length(ne_idx) > 0) colMeans(mat[ne_idx, , drop = FALSE], na.rm = TRUE) else rep(NA_real_, ncol(mat))

  df <- tibble::tibble(
    sample_id = colnames(mat),
    cohort = cohort_id,
    BCL2 = bcl2_vec,
    AR_signature = ar_sig,
    NE_signature = ne_sig,
    validation_partition = "unseen"
  )
  if (cohort_id == "TCGA-PRAD" && sum(!is.na(df$AR_signature)) >= 10) {
    df <- df %>%
      dplyr::mutate(
        AR_quartile = dplyr::ntile(.data$AR_signature, 4),
        NE_quartile = dplyr::ntile(.data$NE_signature, 4),
        subtype_ne_ar = dplyr::case_when(
          .data$AR_quartile <= 1L & .data$NE_quartile >= 4L ~ "NEPC-like (low AR, high NE)",
          .data$AR_quartile >= 4L ~ "ARPC-like (high AR)",
          TRUE ~ "Intermediate"
        )
      )
  }
  list(ok = TRUE, cohort = cohort_id, n = nrow(df), data = df)
}

prad_path <- file.path(stemai_data_dir, "TCGA_PRAD_BCL2_NE.rds")
laml_path <- file.path(stemai_data_dir, "TCGA_LAML_expression_clinical.rds")

tcga_prad <- load_tcga_cohort(prad_path, "TCGA-PRAD")
tcga_laml <- load_tcga_cohort(laml_path, "TCGA-LAML")

tcga_stemai <- dplyr::bind_rows(
  if (tcga_prad$ok) tcga_prad$data else NULL,
  if (tcga_laml$ok) tcga_laml$data else NULL
)

tcga_stemai_status <- tibble::tibble(
  cohort = c("TCGA-PRAD", "TCGA-LAML"),
  loaded = c(tcga_prad$ok, tcga_laml$ok),
  n_samples = c(if (tcga_prad$ok) tcga_prad$n else 0L, if (tcga_laml$ok) tcga_laml$n else 0L),
  cache_path = c(prad_path, laml_path),
  note = c(
    if (tcga_prad$ok) "ok" else tcga_prad$reason,
    if (tcga_laml$ok) "ok" else tcga_laml$reason
  )
)

saveRDS(
  list(
    tcga = tcga_stemai,
    status = tcga_stemai_status,
    loaded_at = Sys.time()
  ),
  file.path(stemai_data_dir, "StemAI_tcga_harmonized.rds")
)

message("StemAI TCGA harmonized: ", nrow(tcga_stemai), " samples written to data/StemAI_tcga_harmonized.rds")
