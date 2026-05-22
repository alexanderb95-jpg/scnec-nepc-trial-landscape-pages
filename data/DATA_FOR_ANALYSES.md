# Data for NEPC/SCLC / lineage-plastic analyses

Run **`Rscript scripts/setup_analysis_data.R`** from the project root to build the main cache (DepMap). Other data are optional or fetched on first run.

| Analysis / Rmd | Data needed | How to get it |
|----------------|-------------|---------------|
| **HMA_BCL2_OpenSource_Preclinical_Analysis_Expanded_Cohort.Rmd** | DepMap cache | `Rscript scripts/load_depmap_cache.R` (or `setup_analysis_data.R`). Saves `data/HMA_BCL2_depmap_cache.rds`. |
| **StemAI_Master.Rmd** (+ children `StemAI_01`–`06`) | DepMap cache; TNBC/Lymphoma cohort RDS; GDSC/CTRP; optional TCGA | `Rscript scripts/render_stemai_cloud.R` (cloud agent recommended). See `docs/StemAI_Cloud_Runbook.md`. Stem-like strata include DLBCL/high-grade lymphoma and neuroblastoma via `HMA_BCL2_cohort_assignments_TNBC_Lymphoma.rds`. |
| Same | GDSC dose-response | Optional. Download from [CancerRxGene](https://www.cancerrxgene.org/downloads/bulk_download): **GDSC2_fitted_dose_response** → save as `data/GDSC2_fitted_dose_response_27Oct23.csv` or `.xlsx`. |
| **Analysis_TCGA_BCL2_Neuroendocrine.Rmd** | TCGA-PRAD cache | `Rscript scripts/download_tcga_prad.R` (or run `setup_analysis_data.R`). Saves `data/TCGA_PRAD_BCL2_NE.rds`. |
| AML cohorts (TCGA-LAML, Beat AML GDC) | RNA + clinical RDS | `Rscript scripts/download_tcga_laml.R` → `data/TCGA_LAML_expression_clinical.rds` (falls back to STAR TSV assembly + GDC cases API if `GDCprepare` fails). `Rscript scripts/download_beataml_cohort.R` → `data/BEATAML1.0_COHORT_expression_clinical.rds` (default 50 samples; `FULL=1` for full cohort, large download). Shared helpers: `scripts/gdc_rna_helpers.R`. Raw GDC files under `data/GDCdata/`. |
| **Analysis_GEO_Methylation_NEPC_SCLC_Signature.Rmd** | GEO | GSE68379 (and others) downloaded on first run via GEOquery. |
| **Analysis_ClinicalTrials_Landscape_NEPC_SCLC.Rmd** | None (API) | Uses ClinicalTrials.gov API; no local data. |
| **Analysis_NEPC_Clinical_Trial_Eligibility_Definition.Rmd** | None (API) | Uses ClinicalTrials.gov API. |
| **Analysis_PubMed_Review_*.Rmd** | None | Uses rentrez/PubMed; no local data. |
| **Analysis_SEER_NCDB_Neuroendocrine_Epidemiology.Rmd** | SEER or NCDB export | Add `data/SEER_neuroendocrine_small_cell_by_site.csv` or `data/SEER_neuroendocrine_small_cell_cases.csv` (see Rmd for expected columns). |

**Knit output:** All analysis Rmds use `echo = FALSE`, so the knitted HTML/Word shows results and figures only, not code.
