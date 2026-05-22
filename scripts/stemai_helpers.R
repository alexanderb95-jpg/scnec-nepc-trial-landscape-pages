# StemAI helpers: evidence packages, ranking exports, RCAN1 sentinel reproducibility (non-forcing).

if (!requireNamespace("here", quietly = TRUE)) install.packages("here", repos = "https://cloud.r-project.org")
source(here::here("scripts", "stemai_config.R"), local = FALSE)

`%||%` <- function(x, y) if (is.null(x) || length(x) == 0) y else x

evidence_package_required_fields <- c(
  "target_id",
  "evidence_package_status",
  "supportive_evidence",
  "contradictory_evidence",
  "mechanism_chain",
  "cross_disease_transferability",
  "translational_trial_context",
  "source_quality_grade",
  "pmid_or_doi",
  "evidence_gaps",
  "query_scope"
)

validate_evidence_package <- function(pkg) {
  missing <- setdiff(evidence_package_required_fields, names(pkg))
  if (length(missing) > 0) {
    return(list(ok = FALSE, reason = paste("missing_fields:", paste(missing, collapse = ", "))))
  }
  n_support <- nchar(pkg$supportive_evidence %||% "")
  if (n_support < 20L) {
    return(list(ok = FALSE, reason = "insufficient_supportive_literature"))
  }
  if (!nzchar(pkg$contradictory_evidence %||% "") && !nzchar(pkg$evidence_gaps %||% "")) {
    return(list(ok = FALSE, reason = "contradictory_or_gaps_not_documented"))
  }
  if (!nzchar(pkg$mechanism_chain %||% "")) {
    return(list(ok = FALSE, reason = "mechanism_chain_empty"))
  }
  list(ok = TRUE, reason = "complete")
}

pubmed_fetch_for_target <- function(target_id, max_records = 12L) {
  if (!requireNamespace("rentrez", quietly = TRUE)) {
    return(tibble::tibble(pmid = character(), title = character(), journal = character(), year = character()))
  }
  queries <- list(
    RCAN1 = paste(
      "(RCAN1[Title/Abstract]) AND",
      "(hypomethylat* OR azacitidine OR decitabine OR DNMT*) AND",
      "(BCL2 OR venetoclax OR apoptosis OR mitochondrial)"
    ),
    BCL2 = "(BCL2[Title/Abstract]) AND (venetoclax OR hypomethylat* OR stem cell OR small cell)",
    DNMT1 = "(DNMT1[Title/Abstract]) AND (hypomethylat* OR decitabine) AND (BCL2 OR venetoclax)"
  )
  q <- queries[[target_id]]
  if (is.null(q)) q <- paste0("(", target_id, "[Title/Abstract]) AND (cancer OR neoplasm)")
  ids <- tryCatch(
    rentrez::entrez_search(db = "pubmed", term = q, retmax = max_records)$ids,
    error = function(e) character(0)
  )
  if (length(ids) == 0) {
    return(tibble::tibble(pmid = character(), title = character(), journal = character(), year = character()))
  }
  rec <- tryCatch(
    rentrez::entrez_fetch(db = "pubmed", id = ids, rettype = "xml", parsed = TRUE),
    error = function(e) NULL
  )
  if (is.null(rec) || length(rec) == 0) {
    return(tibble::tibble(pmid = ids, title = NA_character_, journal = NA_character_, year = NA_character_))
  }
  tibble::tibble(
    pmid = ids,
    title = vapply(rec, function(x) paste(x$title, collapse = " "), character(1)),
    journal = vapply(rec, function(x) paste(x$source, collapse = " "), character(1)),
    year = vapply(rec, function(x) as.character(x$year), character(1))
  )
}

build_rcan1_evidence_package <- function() {
  lit <- pubmed_fetch_for_target("RCAN1")
  supportive <- if (nrow(lit) > 0) {
    paste0(
      "PMID ", lit$pmid, ": ", lit$title,
      if (!is.na(lit$journal[1])) paste0(" (", lit$journal, ")") else "",
      collapse = "\n"
    )
  } else {
    paste(
      "PubMed retrieval unavailable or empty.",
      "Slide-deck references (manual): Saenz 2015; Rahme 2024; Ma 2017;",
      "Wang 2023; Walton/NE stem-like biology."
    )
  }
  list(
    target_id = "RCAN1",
    evidence_package_status = "complete",
    supportive_evidence = supportive,
    contradictory_evidence = "Limitations: indirect translation AML→solid tumors; not all lineages have matched patient methylation validation.",
    mechanism_chain = paste(
      "DNMTi demethylation at RCAN1 loci → RCAN1 upregulation →",
      "mitochondrial/apoptotic priming (BIM/NOXA context) → enhanced BCL2i sensitivity"
    ),
    cross_disease_transferability = "AML (HMA+BCL2i), SCLC/NEPC, neuroblastoma, DLBCL/high-grade lymphoma exploratory concordance.",
    translational_trial_context = "Biomarker-driven Phase II HMA+BCL2i in ES-SCLC; RCAN1/ctDNA methylation correlatives.",
    source_quality_grade = "Mixed preclinical + observational + pharmacogenomic (hypothesis-generating).",
    pmid_or_doi = if (nrow(lit) > 0) paste(lit$pmid, collapse = ";") else NA_character_,
    evidence_gaps = "Prospective solid-tumor RCAN1-directed combination trials remain limited.",
    query_scope = STEMAI_QUERY_SCOPE
  )
}

build_rcan1_sentinel_snapshot <- function(expr_target, ranked_targets, evidence_pkgs) {
  rcan1_rank <- NA_integer_
  if (!is.null(ranked_targets) && nrow(ranked_targets) > 0 && "target_id" %in% names(ranked_targets)) {
    idx <- which(ranked_targets$target_id == "RCAN1")
    if (length(idx) > 0) rcan1_rank <- ranked_targets$rank[idx[1]]
  }
  rcan1_expr_median <- NA_real_
  if (!is.null(expr_target) && nrow(expr_target) > 0) {
    if ("RCAN1" %in% names(expr_target) && "stem_like_group" %in% names(expr_target)) {
      sl <- expr_target$stem_like_group == "Stem-like"
      if (any(sl, na.rm = TRUE)) {
        rcan1_expr_median <- median(expr_target$RCAN1[sl], na.rm = TRUE)
      }
    }
  }
  pkg <- evidence_pkgs[["RCAN1"]]
  n_pmids <- 0L
  if (!is.null(pkg) && nzchar(pkg$pmid_or_doi %||% "")) {
    n_pmids <- length(strsplit(pkg$pmid_or_doi, ";", fixed = TRUE)[[1]])
  }
  mech <- pkg$mechanism_chain %||% ""
  mech_hash <- if (requireNamespace("digest", quietly = TRUE)) {
    digest::digest(mech, algo = "xxhash64")
  } else {
    as.character(nchar(mech))
  }
  list(
    query_scope = STEMAI_QUERY_SCOPE,
    timestamp = Sys.time(),
    rcan1_rank = rcan1_rank,
    rcan1_expr_median_stem_like = rcan1_expr_median,
    n_supportive_pmids = n_pmids,
    mechanism_chain_hash = mech_hash,
    package_status = pkg$evidence_package_status %||% NA_character_
  )
}

compare_rcan1_sentinel <- function(baseline, current, rank_tol = 3L) {
  if (is.null(baseline)) {
    return(list(status = "no_baseline", message = "No baseline snapshot; saving current run as baseline.", warnings = character(0)))
  }
  warnings <- character(0)
  if (!identical(baseline$query_scope, current$query_scope)) {
    warnings <- c(warnings, "query_scope_mismatch")
  }
  if (!is.na(baseline$rcan1_rank) && !is.na(current$rcan1_rank)) {
    if (abs(baseline$rcan1_rank - current$rcan1_rank) > rank_tol) {
      warnings <- c(warnings, "rank_drift")
    }
  }
  if (!is.na(baseline$rcan1_expr_median_stem_like) && !is.na(current$rcan1_expr_median_stem_like)) {
    rel <- abs(current$rcan1_expr_median_stem_like - baseline$rcan1_expr_median_stem_like) /
      max(abs(baseline$rcan1_expr_median_stem_like), 1e-6)
    if (rel > 0.25) warnings <- c(warnings, "expression_median_drift")
  }
  if (baseline$n_supportive_pmids > 0 && current$n_supportive_pmids < max(2L, baseline$n_supportive_pmids - 2L)) {
    warnings <- c(warnings, "literature_coverage_drop")
  }
  if (length(warnings) > 0) {
    return(list(
      status = "qc_reproducibility_warning",
      warnings = warnings,
      message = paste("RCAN1 sentinel drift detected:", paste(warnings, collapse = ", "))
    ))
  }
  list(status = "ok", warnings = character(0), message = "RCAN1 sentinel reproducibility within tolerance.")
}
