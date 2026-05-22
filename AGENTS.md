# Agent instructions for this project

When helping with this repo:

0. **Researcher context**  
   For user preferences, role, and project conventions, read **docs/Researcher_Context.md** and use it to tailor responses (analysis style, figure conventions, etc.). Treat it as limited persistent memory about the user. Repo-local Cursor skills (readable by collaborators and agents): **skills/biomarker_analysis/SKILL.md** (Rmd pipelines, figures, portals, DOCX alignment, **embedded Cox/KM/landmark survival review**), **skills/grill-me/SKILL.md** (clarifying questions before big tasks), **skills/find-skills/SKILL.md** (discover skills on GitHub), **skills/slidev/SKILL.md** (Slidev Markdown decks; official skill vendored from [slidevjs/slidev](https://github.com/slidevjs/slidev/tree/main/skills/slidev); upstream install: `npx skills add slidevjs/slidev`, docs: [Work with AI](https://sli.dev/guide/work-with-ai); lives under `skills/` so it is not dropped by `.gitignore` on `.cursor/`). **skills/survival-analysis-review/SKILL.md** is a **pointer** to the survival section inside `biomarker_analysis`. Copy into `.cursor/skills/<name>/` if you use the picker.

1. **Evidence and literature**  
   For any medical/clinical claims or literature questions, use high-fidelity search: PubMed first, cite sources (DOI/PMID), and only state what is verifiable from retrieved text. Do not infer beyond sources.

2. **R and R Markdown**  
   Follow `.cursorrules`: tidyverse style, `here::here()` for paths, survival/survminer for time-to-event. Any changed R Markdown must knit successfully before the task is done.

3. **Outputs**  
   Prefer simple, clinically interpretable analyses and publication-ready tables/figures (clear labels, appropriate effect sizes and CIs).

4. **Review HTML and figures after user-requested changes**  
   When the user asks for changes that affect figures, tables, or terminology (e.g. “use Localized instead of Primary,” “remove X from Table 1”): (1) After implementing code, knit the report so HTML and figures are generated. (2) Open the rendered HTML (e.g. in `outputs/`) and check that figure labels, axis/legend text, tables, and captions use the exact terminology requested. (3) If a figure still shows old wording, trace labels to their source (e.g. `lineage_levels`, `expr_target$lineage_group`, or saved RDS) and fix the data or factor levels so the plot reflects the change. Do not mark the task complete until the rendered output accurately represents the user’s request. **Table consistency:** For trial-style tables with a total N and breakdown rows (sex, ECOG, disposition), verify **components sum to the total** in the rendered output; prefer knit-time `stop()` checks (see **skills/biomarker_analysis/SKILL.md**, table arithmetic) so mismatches fail the build instead of publishing.

5. **Combination repurposing Shiny app**  
   When the Shiny app in **shiny/combination_repurposing/** is built or updated, an agent should run it to verify it works and results are accurate. See **shiny/combination_repurposing/README.md** for run instructions and verification steps (Load data → Run analysis → check table and Rationale column).

6. **Long R Markdown files (e.g. HMA_BCL2 ~3k lines)**  
   For multi-step tasks (e.g. “add units to all axes and captions,” “audit every figure chunk”), use **parallel subagents**: launch 2–3 agents in one turn with separate instructions (e.g. one agent: fix all `labs(x =` / `labs(y =`; another: fix all `fig.cap`; optional third: run knit and report errors). This speeds up edits and avoids long sequential passes.

For detailed workflows (rules and slash commands), see **docs/Cursor_Clinical_Research_Workflow.md**.

## Cursor Cloud specific instructions

Cloud agents run on Ubuntu VMs configured by **`.cursor/environment.json`** (see **docs/Cursor_Cloud_Agent_Setup.md**).

- **Working directory:** Always treat the git repo root as the project root (`here::here()`). Paths: `data/`, `rmarkdown/`, `outputs/`, `figures/`, `scripts/`.
- **Dependencies:** On VM boot, `scripts/cloud_agent_install.R` runs automatically. If knitting fails with a missing package, add it to that script and commit.
- **Knit target:** Prefer **HTML** to `outputs/` unless the user asks for PDF. Example: `rmarkdown::render("rmarkdown/FILE.Rmd", output_dir = "outputs")`.
- **StemAI (parallel to HMA_BCL2_Expanded):** Cloud/long runs: `Rscript scripts/render_stemai_cloud.R` → `outputs/StemAI_Master.html`. See `docs/StemAI_Cloud_Runbook.md`. Do not modify `HMA_BCL2_OpenSource_Preclinical_Analysis_Expanded_Cohort.Rmd` when extending StemAI.
- **Secrets:** API keys and tokens live in the [Cloud Agents Secrets](https://cursor.com/dashboard/cloud-agents) dashboard, not in the repo. Do not read or commit `.Renviron`, `.env`, or `data/cbioportal_token.txt`.
- **PHI:** Do not use patient-identifiable data in cloud tasks; use de-identified or public datasets only.
- **After figure/table/terminology changes:** Knit the affected Rmd, then verify rendered HTML under `outputs/` matches the user’s wording (same as local rule §4).
- **Large Rmds:** For multi-hundred-line audit tasks, split work (axes, captions, knit verification) across parallel cloud runs if the UI allows.
