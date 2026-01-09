---
title: "Research Question 1: Baseline ctDNA Level and Duration of Complete Response"
date: "2025-12-19"
output: html_document
---

## Research Question

**What is the association between circulating tumor DNA (ctDNA) level before starting a new line of therapy and duration of complete response?**

This analysis examines whether ctDNA levels measured before starting each new line of metastatic therapy are prognostic for duration of complete response in patients with metastatic urothelial carcinoma. The analysis includes all lines of therapy (1L, 2L, 3L+, not limited to first-line), with each line of therapy as a separate observation and time 0 defined as the start of each new line of therapy.

**Note on Endpoint Definition:** We analyze "Duration of Complete Response" (DCR), which represents the time from therapy initiation until loss of complete response or death. **Events** occur when: (1) the patient dies, OR (2) the patient is alive but has obvious disease present on most recent imaging (i.e., loss of complete response, similar to RECIST progression from CR). **Patients are censored** when they are alive and have no obvious disease on most recent imaging (i.e., maintaining complete response, similar to RECIST CR). This endpoint captures both survival and maintenance of complete response, which is clinically meaningful in the metastatic setting. Note: Patients with stable disease or partial response (but with disease still present on imaging) are considered events, as they have lost or never achieved complete response. **Important:** Patients who died do NOT require imaging data for inclusion (death is an event). Only alive patients require imaging data to determine complete response status.










```
## Population Studied
```

```
**Universe:** Patients with metastatic disease starting a new line of therapy
```

```
**N = 48  patient-line observations ( 38  unique patients)
```

```
**Note:** Final analysis N (after excluding observations due to missing survival data) is shown in the exclusion and descriptive tables below.
```

```
**Inclusion Criteria:**
```

```
- Confirmed metastatic disease
```

```
- Starting a new line of palliative/metastatic therapy (includes 1L, 2L, 3L+, not limited to first-line)
```

```
- Had ctDNA level measured within 21 days before starting that line of therapy
```

```
- Time 0 = start of each new line of therapy
```

```
**Note:** Each patient can contribute multiple observations (one per line of therapy). Line of therapy is included as a covariate in the analysis.
```

<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
<caption>Palliative Systemic Therapy Classes (ADC/ICI/Chemo/Targeted/Other). Note: patients can appear in multiple classes if they received combination regimens (e.g., ADC + ICI). Percentages are calculated based on total unique patients receiving palliative therapy.</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Therapy Class </th>
   <th style="text-align:left;"> N Patients (%) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> ADC </td>
   <td style="text-align:left;"> 60 (60.6%) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Chemo </td>
   <td style="text-align:left;"> 36 (36.4%) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ICI </td>
   <td style="text-align:left;"> 34 (34.3%) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Other </td>
   <td style="text-align:left;"> 10 (10.1%) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> unspecified </td>
   <td style="text-align:left;"> 4 (4%) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Targeted </td>
   <td style="text-align:left;"> 2 (2%) </td>
  </tr>
</tbody>
</table>




```
No observations excluded - all 48 patient-line observations had valid survival data.
```


```
## Patient IDs Excluded Due to Missing Imaging Data

**No patients excluded due to missing imaging data.**
(All alive patients had imaging data available, or all excluded patients had died and did not require imaging data.)
```

<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
<caption>Descriptive Characteristics of Study Population</caption>
 <thead>
  <tr>
   <th style="text-align:right;"> N (Patient-Line Observations) </th>
   <th style="text-align:right;"> N (Unique Patients) </th>
   <th style="text-align:right;"> 1L </th>
   <th style="text-align:right;"> 2L </th>
   <th style="text-align:right;"> 3L </th>
   <th style="text-align:right;"> 4L+ </th>
   <th style="text-align:left;"> ctDNA Before Therapy (median, IQR) </th>
   <th style="text-align:left;"> Days from ctDNA to Therapy Start (median, IQR) </th>
   <th style="text-align:right;"> DCR Events </th>
   <th style="text-align:right;"> Median DCR (months) </th>
   <th style="text-align:right;"> 1-year DCR % </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 48 </td>
   <td style="text-align:right;"> 38 </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:right;"> 13 </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:left;"> 13.12 (2.47-83.64) </td>
   <td style="text-align:left;"> 10 (0-18) </td>
   <td style="text-align:right;"> 33 </td>
   <td style="text-align:right;"> 8.2 </td>
   <td style="text-align:right;"> 30.3 </td>
  </tr>
</tbody>
</table>






<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
<caption>Data Completeness for Event Classification</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Metric </th>
   <th style="text-align:right;"> Value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> N </td>
   <td style="text-align:right;"> 48.000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Has Death Date </td>
   <td style="text-align:right;"> 18.000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Has Last FU Date </td>
   <td style="text-align:right;"> 38.000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Has Alive Status </td>
   <td style="text-align:right;"> 48.000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Alive Status = Yes </td>
   <td style="text-align:right;"> 30.000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Alive Status = No </td>
   <td style="text-align:right;"> 18.000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Alive Status Missing </td>
   <td style="text-align:right;"> 0.000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Events </td>
   <td style="text-align:right;"> 33.000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Censored </td>
   <td style="text-align:right;"> 15.000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Censoring Rate </td>
   <td style="text-align:right;"> 0.312 </td>
  </tr>
</tbody>
</table>

<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
<caption>Breakdown of DCR Event vs. Censored Classification

Note: DCR Events include: (1) Death (death_date or alive_status=No), OR (2) Alive with obvious disease on most recent imaging (loss of complete response, includes stable disease, partial response, or progressive disease). DCR Censored = Alive without obvious disease on imaging (maintaining complete response, similar to RECIST CR). Only alive patients with missing imaging data are excluded (imaging data is required for alive patients only; patients who died do not require imaging data).</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Classification </th>
   <th style="text-align:right;"> N </th>
   <th style="text-align:right;"> % </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Censored: Alive without disease on imaging </td>
   <td style="text-align:right;"> 15 </td>
   <td style="text-align:right;"> 31.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Event: Death (has death_date) </td>
   <td style="text-align:right;"> 18 </td>
   <td style="text-align:right;"> 37.5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Event: Imaging shows disease (alive with disease) </td>
   <td style="text-align:right;"> 15 </td>
   <td style="text-align:right;"> 31.2 </td>
  </tr>
</tbody>
</table>

<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
<caption>Censoring Rate Analysis by ctDNA Tertile</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Group </th>
   <th style="text-align:right;"> N </th>
   <th style="text-align:right;"> N Events </th>
   <th style="text-align:right;"> N Censored </th>
   <th style="text-align:left;"> Censoring Rate </th>
   <th style="text-align:left;"> Interpretation </th>
   <th style="text-align:left;"> Chi-square P-value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> T1 (Lowest) </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:left;"> 62.5% </td>
   <td style="text-align:left;"> ⚠️ Potentially informative </td>
   <td style="text-align:left;"> |0.004 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> T2 </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:right;"> 13 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> 18.8% </td>
   <td style="text-align:left;"> ⚠️ Potentially informative </td>
   <td style="text-align:left;"> | </td>
  </tr>
  <tr>
   <td style="text-align:left;"> T3 (Highest) </td>
   <td style="text-align:right;"> 16 </td>
   <td style="text-align:right;"> 14 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:left;"> 12.5% </td>
   <td style="text-align:left;"> ⚠️ Potentially informative </td>
   <td style="text-align:left;"> | </td>
  </tr>
</tbody>
</table>

```

**Interpretation:** Censoring may be informative (p = 0.004 ). Consider sensitivity analyses.
```

<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
<caption>Cox Proportional Hazards Model: ctDNA Level Before Therapy and Duration of Complete Response. Top section shows continuous ctDNA (Ln(ctDNA + 1)) with HR progression as covariates are added. Bottom section shows tertile comparisons (T2 vs T1, T3 vs T1) with T1 (Lowest) as reference. HR &gt; 1 indicates shorter duration of complete response (higher risk of loss of CR or death) compared to reference.</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Model </th>
   <th style="text-align:left;"> HR (95% CI) </th>
   <th style="text-align:left;"> P-value </th>
   <th style="text-align:right;"> N </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Unadjusted </td>
   <td style="text-align:left;"> 1.44 (1.2-1.72) </td>
   <td style="text-align:left;"> &lt;0.001 </td>
   <td style="text-align:right;"> 49 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adjusted for line of therapy </td>
   <td style="text-align:left;"> 1.43 (1.19-1.73) </td>
   <td style="text-align:left;"> &lt;0.001 </td>
   <td style="text-align:right;"> 49 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adjusted for KPS </td>
   <td style="text-align:left;"> 1.44 (1.18-1.75) </td>
   <td style="text-align:left;"> &lt;0.001 </td>
   <td style="text-align:right;"> 45 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adjusted for visceral metastases </td>
   <td style="text-align:left;"> 1.49 (1.2-1.84) </td>
   <td style="text-align:left;"> &lt;0.001 </td>
   <td style="text-align:right;"> 45 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adjusted for line of therapy, KPS, and visceral metastases </td>
   <td style="text-align:left;"> 1.5 (1.2-1.87) </td>
   <td style="text-align:left;"> &lt;0.001 </td>
   <td style="text-align:right;"> 45 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> T2 vs T1 (Unadjusted) </td>
   <td style="text-align:left;"> 1.71 (0.67-4.39) </td>
   <td style="text-align:left;"> 0.265 </td>
   <td style="text-align:right;"> 49 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> T3 vs T1 (Unadjusted) </td>
   <td style="text-align:left;"> 4.87 (1.89-12.53) </td>
   <td style="text-align:left;"> 0.001 </td>
   <td style="text-align:right;"> 49 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> T2 vs T1 (Adjusted for line of therapy) </td>
   <td style="text-align:left;"> 1.66 (0.6-4.56) </td>
   <td style="text-align:left;"> 0.329 </td>
   <td style="text-align:right;"> 49 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> T3 vs T1 (Adjusted for line of therapy) </td>
   <td style="text-align:left;"> 4.65 (1.66-12.99) </td>
   <td style="text-align:left;"> 0.003 </td>
   <td style="text-align:right;"> 49 </td>
  </tr>
</tbody>
</table>


```

**N for multivariate model:** 45 observations
**Note:** This model includes Bajorin risk factors (KPS and visceral metastases) in addition to ctDNA level and line of therapy.
```




```

**Tertile Cutoffs Summary:**
- **T1 (Lowest):** ctDNA ≤ 2.77
- **T2:** ctDNA from 2.77 to 59.73
- **T3 (Highest):** ctDNA ≥ 64.05

**Note:** Tertiles are created by dividing the ctDNA values into three equal groups based on rank (ntile function). T1 (Lowest) contains the lowest third of ctDNA values, T2 contains the middle third, and T3 (Highest) contains the highest third.
```

![plot of chunk survival_curves_by_ctdna_tertiles](figure/survival_curves_by_ctdna_tertiles-1.png)




```

**Overall Test for Trend:**
Wald test p-value: 0.001 
```

<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
<caption>Sensitivity Analysis: Treating Censored Observations as Events (Worst-Case Scenario)</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Analysis </th>
   <th style="text-align:left;"> HR (95% CI) </th>
   <th style="text-align:left;"> P-value </th>
   <th style="text-align:right;"> N Events </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Standard (Censored) </td>
   <td style="text-align:left;"> 1.43 (1.19-1.73) </td>
   <td style="text-align:left;"> &lt;0.001 </td>
   <td style="text-align:right;"> 33 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sensitivity (All Events) </td>
   <td style="text-align:left;"> 1.22 (1.05-1.41) </td>
   <td style="text-align:left;"> 0.011 </td>
   <td style="text-align:right;"> 48 </td>
  </tr>
</tbody>
</table>

```

**Note:** This sensitivity analysis assumes all censored patients had events at their censoring time.
```

```
This provides a worst-case scenario to assess robustness of findings.
```

![plot of chunk continuous_association_plot](figure/continuous_association_plot-1.png)


```
## Summary
```

```
**Universe - Prognostic Cohort (Baseline ctDNA Analysis):** Patients with metastatic disease starting a new line of therapy
```

```
  - Includes all lines of therapy (1L, 2L, 3L+, not limited to first-line)
```

```
  - ctDNA measured within 21 days before starting each new line
```

```
  - Time 0 = start of each new line of therapy
```

```
  - **N = 48  patient-line observations
```

```
**Key Findings - Prognostic (Baseline ctDNA):**
```

```
- Median ctDNA before therapy: 13.12 
```

```
- Hazard Ratio per log-unit increase in ctDNA (adjusted for line of therapy, KPS, and visceral metastases): 1.5  (95% CI:  1.2 - 1.87 )
- P-value: <0.001 
```

```
**Interpretation:**
```

```
Higher ctDNA levels before starting a new line of therapy are significantly associated with worse duration of complete response (HR = 1.5, 95% CI: 1.2-1.87), adjusted for line of therapy, KPS, and visceral metastases. This finding suggests that ctDNA level before therapy initiation may serve as a prognostic biomarker for duration of complete response outcomes across multiple lines of therapy in patients with metastatic urothelial carcinoma.
```

