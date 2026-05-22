# StemAI cloud-agent runbook

StemAI is a **separate** Master+child pipeline from `HMA_BCL2_OpenSource_Preclinical_Analysis_Expanded_Cohort.Rmd`. It implements the PowerPoint AI co-scientist frame: inputs → integration → engineered features → mechanistic mapping → ranked outputs + PubMed evidence, with TCGA as unseen validation.

## Cloud agent task (copy/paste)

Run from repo root on a **Cloud** agent:

```text
Execute StemAI full repro:
1. Rscript scripts/render_stemai_cloud.R
2. If knit fails, fix missing packages in scripts/cloud_agent_install.R and retry only failed stage (STEMAI_CHILD_ONLY=StemAI_XX).
3. Return paths to outputs/StemAI_Master.html, data/StemAI_*.rds, data/stemai_qc/RCAN1_sentinel_*.rds, and figures/StemAI/.
4. Report RCAN1 sentinel status from data/stemai_qc/RCAN1_sentinel_repro_report.rds (diagnostic only; do not force RCAN1 rank).
```

## Prerequisites

| Step | Command / file |
|------|----------------|
| DepMap cache | `Rscript scripts/load_depmap_cache.R` (auto in render script) |
| Extended cohort (DLBCL, neuroblastoma) | Knit `rmarkdown/Cell_Line_Assignment_Verification_TNBC_Lymphoma.Rmd` → `data/HMA_BCL2_cohort_assignments_TNBC_Lymphoma.rds` |
| TCGA (optional unseen layer) | `Rscript scripts/download_tcga_prad.R`; `Rscript scripts/download_tcga_laml.R` |
| GDSC / CTRP local files | Same as HMA_BCL2 (`data/GDSC2_*`, `data/CTRPv2.rds`) |

## Local vs cloud

- **Cloud (recommended):** full `StemAI_Master.Rmd` knit; 30+ min possible with cold TCGA download.
- **Debug one child:** `STEMAI_CHILD_ONLY=StemAI_03_Feature_Engineering Rscript scripts/render_stemai_cloud.R`
- **Skip TCGA on fast pass:** `STEMAI_SKIP_TCGA=1 Rscript scripts/render_stemai_cloud.R`

## Outputs

| Artifact | Purpose |
|----------|---------|
| `outputs/StemAI_Master.html` | Full report |
| `data/StemAI_engineered_features.rds` | Model input features |
| `data/StemAI_ranked_outputs.rds` | Ranked targets + combinations |
| `data/StemAI_evidence_packages.rds` | Literature packages (RCAN1 comprehensive) |
| `data/stemai_qc/RCAN1_sentinel_baseline.rds` | First-run sentinel snapshot |
| `data/stemai_qc/RCAN1_sentinel_repro_report.rds` | Rerun reproducibility diagnostic |
| `figures/StemAI/*.png` | PowerPoint-aligned panels |

## RCAN1 sentinel (quality check, not forcing)

Scope: `HMA+BCL2 and novel epigenetic combination therapies in stem-like cancers`.

A second agent rerun with **matched inputs/settings** should recover similar RCAN1 signal direction, comparable rank band, and literature coverage. Drift → `qc_reproducibility_warning` in repro report (investigate data/version/config; do not hard-code RCAN1 as top target).

## Query scope lock

All exports include `query_scope` from `scripts/stemai_config.R` (`STEMAI_QUERY_SCOPE`).
