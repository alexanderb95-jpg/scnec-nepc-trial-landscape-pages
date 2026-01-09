---
title: "Research Question 2: Early On-Treatment ctDNA Response and Duration of Complete Response"
date: "2025-12-19"
output: html_document
---










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

<table class="table table-striped table-hover" style="font-size: 9px; margin-left: auto; margin-right: auto;">
<caption style="font-size: initial !important;">Patient IDs with Baseline ctDNA Dates by Therapy Line (N = 38 patients, 48 patient-line observations)</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Patient ID </th>
   <th style="text-align:left;"> Therapy Line </th>
   <th style="text-align:left;"> Baseline ctDNA Date </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 106 </td>
   <td style="text-align:left;"> 1L </td>
   <td style="text-align:left;"> 2023-09-14 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> 1L </td>
   <td style="text-align:left;"> 2023-11-30 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 11 </td>
   <td style="text-align:left;"> 2L </td>
   <td style="text-align:left;"> 2024-05-21 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 128 </td>
   <td style="text-align:left;"> 2L </td>
   <td style="text-align:left;"> 2025-04-03 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 135 </td>
   <td style="text-align:left;"> 2L </td>
   <td style="text-align:left;"> 2024-04-16 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 159 </td>
   <td style="text-align:left;"> 3L </td>
   <td style="text-align:left;"> 2023-10-19 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 167 </td>
   <td style="text-align:left;"> 1L </td>
   <td style="text-align:left;"> 2023-02-16 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 172 </td>
   <td style="text-align:left;"> 2L </td>
   <td style="text-align:left;"> 2022-12-29 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 172 </td>
   <td style="text-align:left;"> 3L </td>
   <td style="text-align:left;"> 2023-07-06 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 172 </td>
   <td style="text-align:left;"> 4L+ </td>
   <td style="text-align:left;"> 2024-03-21 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 178 </td>
   <td style="text-align:left;"> 1L </td>
   <td style="text-align:left;"> 2023-05-16 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 179 </td>
   <td style="text-align:left;"> 3L </td>
   <td style="text-align:left;"> 2023-10-20 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 179 </td>
   <td style="text-align:left;"> 4L+ </td>
   <td style="text-align:left;"> 2025-03-05 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 187 </td>
   <td style="text-align:left;"> 1L </td>
   <td style="text-align:left;"> 2024-04-16 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 188 </td>
   <td style="text-align:left;"> 1L </td>
   <td style="text-align:left;"> 2024-09-05 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 19 </td>
   <td style="text-align:left;"> 3L </td>
   <td style="text-align:left;"> 2023-06-22 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 197 </td>
   <td style="text-align:left;"> 1L </td>
   <td style="text-align:left;"> 2022-09-21 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 198 </td>
   <td style="text-align:left;"> 2L </td>
   <td style="text-align:left;"> 2025-04-10 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 22 </td>
   <td style="text-align:left;"> 3L </td>
   <td style="text-align:left;"> 2023-12-05 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 22 </td>
   <td style="text-align:left;"> 4L+ </td>
   <td style="text-align:left;"> 2024-11-05 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 22 </td>
   <td style="text-align:left;"> 4L+ </td>
   <td style="text-align:left;"> 2025-05-06 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 230 </td>
   <td style="text-align:left;"> 1L </td>
   <td style="text-align:left;"> 2024-08-17 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 25 </td>
   <td style="text-align:left;"> 1L </td>
   <td style="text-align:left;"> 2025-06-12 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 250 </td>
   <td style="text-align:left;"> 4L+ </td>
   <td style="text-align:left;"> 2025-03-11 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 259 </td>
   <td style="text-align:left;"> 1L </td>
   <td style="text-align:left;"> 2025-01-16 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 263 </td>
   <td style="text-align:left;"> 2L </td>
   <td style="text-align:left;"> 2023-07-25 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 263 </td>
   <td style="text-align:left;"> 3L </td>
   <td style="text-align:left;"> 2023-10-03 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 263 </td>
   <td style="text-align:left;"> 4L+ </td>
   <td style="text-align:left;"> 2024-02-24 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 265 </td>
   <td style="text-align:left;"> 2L </td>
   <td style="text-align:left;"> 2025-01-02 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 273 </td>
   <td style="text-align:left;"> 1L </td>
   <td style="text-align:left;"> 2022-09-09 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 279 </td>
   <td style="text-align:left;"> 3L </td>
   <td style="text-align:left;"> 2023-07-12 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 28 </td>
   <td style="text-align:left;"> 1L </td>
   <td style="text-align:left;"> 2022-12-27 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 280 </td>
   <td style="text-align:left;"> 2L </td>
   <td style="text-align:left;"> 2023-09-12 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 281 </td>
   <td style="text-align:left;"> 1L </td>
   <td style="text-align:left;"> 2023-11-09 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 288 </td>
   <td style="text-align:left;"> 1L </td>
   <td style="text-align:left;"> 2023-11-06 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 292 </td>
   <td style="text-align:left;"> 2L </td>
   <td style="text-align:left;"> 2025-04-08 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 312 </td>
   <td style="text-align:left;"> 3L </td>
   <td style="text-align:left;"> 2024-08-08 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 316 </td>
   <td style="text-align:left;"> 1L </td>
   <td style="text-align:left;"> 2024-06-21 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 317 </td>
   <td style="text-align:left;"> 3L </td>
   <td style="text-align:left;"> 2023-06-22 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 33 </td>
   <td style="text-align:left;"> 1L </td>
   <td style="text-align:left;"> 2024-12-17 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 343 </td>
   <td style="text-align:left;"> 2L </td>
   <td style="text-align:left;"> 2022-10-28 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 43 </td>
   <td style="text-align:left;"> 1L </td>
   <td style="text-align:left;"> 2024-09-27 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 43 </td>
   <td style="text-align:left;"> 2L </td>
   <td style="text-align:left;"> 2024-12-05 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 45 </td>
   <td style="text-align:left;"> 2L </td>
   <td style="text-align:left;"> 2025-06-12 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 47 </td>
   <td style="text-align:left;"> 1L </td>
   <td style="text-align:left;"> 2024-04-02 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 84 </td>
   <td style="text-align:left;"> 1L </td>
   <td style="text-align:left;"> 2022-12-22 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 84 </td>
   <td style="text-align:left;"> 2L </td>
   <td style="text-align:left;"> 2023-03-15 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 99 </td>
   <td style="text-align:left;"> 4L+ </td>
   <td style="text-align:left;"> 2025-01-09 </td>
  </tr>
</tbody>
</table>

<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
<caption>Palliative Systemic Therapy Classes (ADC/ICI/Chemo/Targeted/Other). Note: patients can appear in multiple classes if they received combination regimens (e.g., ADC + ICI).</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> therapy_class </th>
   <th style="text-align:right;"> n_lines </th>
   <th style="text-align:right;"> n_patients </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> ADC </td>
   <td style="text-align:right;"> 86 </td>
   <td style="text-align:right;"> 60 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Chemo </td>
   <td style="text-align:right;"> 42 </td>
   <td style="text-align:right;"> 36 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ICI </td>
   <td style="text-align:right;"> 41 </td>
   <td style="text-align:right;"> 34 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Other </td>
   <td style="text-align:right;"> 14 </td>
   <td style="text-align:right;"> 10 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> unspecified </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Targeted </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
</tbody>
</table>


## Research Question 2

**What is the association between early on-treatment ctDNA response (cleared vs not cleared) at 6-16 weeks after therapy initiation and subsequent duration of complete response?**

This analysis examines whether early ctDNA clearance (within 6-16 weeks after starting therapy) is associated with improved duration of complete response. The landmark analysis uses the latest ctDNA measurement available within the 6-16 week window to assess clearance status, and analyzes duration of complete response from that landmark time point forward. **Note:** Only alive patients require imaging data for inclusion (to determine complete response status, similar to RECIST CR). Patients who died do NOT require imaging data (death is an event).




```
## Patient IDs Excluded Due to Missing Imaging Data

**No patients excluded due to missing imaging data.**
(All alive patients had imaging data available, or all excluded patients had died and did not require imaging data.)
```


```
## Addressing Immortal Time Bias
```

```
**Immortal time bias** occurs when patients must survive to a certain time to be classified into a group, artificially inflating survival. **Landmark analysis addresses this** by: (1) determining clearance status at the landmark time point (ctDNA measurement date within 6-16 weeks), not requiring survival to a later time; (2) analyzing survival FROM the landmark forward (time 0 = landmark time, not therapy start); and (3) including only patients who survived to landmark, ensuring equal opportunity for classification.
```

<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
<caption>Landmark Time Distribution (weeks) by ctDNA Clearance Status (demonstrating similar landmark times across groups)</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Clearance Status </th>
   <th style="text-align:right;"> N </th>
   <th style="text-align:left;"> Landmark Time (weeks, median IQR) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Not Cleared at Landmark </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:left;"> 10.9 (9.6-12.9) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Cleared at Landmark </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:left;"> 9.9 (8.6-11.8) </td>
  </tr>
</tbody>
</table>


```
Note: Multivariate model did not converge (likely due to small sample size or too many covariates). Model not included in results table.
```

Landmark analysis results table not available.


```

**Note on therapy class adjustment:** Palliative systemic therapy regimens were classified into therapy classes (ADC, ICI, Chemo, Targeted, Other, and combinations such as ADC + ICI) based on the regimen received. Therapy class was included as a categorical covariate in the adjusted Cox models to account for potential differences in treatment efficacy across therapy types.
```

<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
<caption>Multivariate Cox Model: On-Treatment ctDNA Clearance and Duration of Complete Response from Landmark (adjusted for line of therapy, therapy class, KPS, and visceral metastases). Note: Only coefficients with reasonable HR values (converged models) are shown. Models with extreme HR values (0, Inf, or very large) are excluded due to convergence issues, likely due to small sample size or complete separation.</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Variable </th>
   <th style="text-align:left;"> HR (95% CI) </th>
   <th style="text-align:left;"> P-value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> ctDNA Cleared at Landmark vs Not Cleared </td>
   <td style="text-align:left;"> 0.01 (0-0.29) </td>
   <td style="text-align:left;"> 0.006 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> KPS ≥80% vs &lt;80% </td>
   <td style="text-align:left;"> 5 (0.7-35.67) </td>
   <td style="text-align:left;"> 0.108 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Visceral Mets vs No Visceral Mets </td>
   <td style="text-align:left;"> 4.7 (0.37-60.29) </td>
   <td style="text-align:left;"> 0.235 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Therapy Class: Chemo vs reference </td>
   <td style="text-align:left;"> 0.6 (0.13-2.71) </td>
   <td style="text-align:left;"> 0.506 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Therapy Class: ICI vs reference </td>
   <td style="text-align:left;"> 3.82 (0.34-42.92) </td>
   <td style="text-align:left;"> 0.278 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Therapy Class: Other vs reference </td>
   <td style="text-align:left;"> 0 (0-Inf) </td>
   <td style="text-align:left;"> 0.999 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Therapy Class: unspecified vs reference </td>
   <td style="text-align:left;"> NA (NA-NA) </td>
   <td style="text-align:left;"> NA </td>
  </tr>
</tbody>
</table>



**N for multivariate on-treatment model:** 27 observations




Continuous ctDNA analyses not available (insufficient data or models could not be fitted).

<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
<caption>Population Comparison: Baseline vs On-Treatment Analysis Cohorts. Note: These are different patient populations - baseline analysis includes all patients with baseline ctDNA, while on-treatment analysis includes only patients who had on-treatment ctDNA measured within 6-16 weeks and survived to landmark.</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Analysis </th>
   <th style="text-align:right;"> N (Patient-Line Observations) </th>
   <th style="text-align:right;"> N (Unique Patients) </th>
   <th style="text-align:left;"> Median Baseline ctDNA (IQR) </th>
   <th style="text-align:right;"> MFS Events </th>
   <th style="text-align:right;"> Median MFS (days) </th>
   <th style="text-align:right;"> Median MFS from Landmark (days) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> On-treatment ctDNA (Research Question 2) </td>
   <td style="text-align:right;"> 48 </td>
   <td style="text-align:right;"> 38 </td>
   <td style="text-align:left;"> 13.12 (2.47-83.64) </td>
   <td style="text-align:right;"> 33 </td>
   <td style="text-align:right;"> 250 </td>
   <td style="text-align:right;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> On-treatment ctDNA (Research Question 2) </td>
   <td style="text-align:right;"> 28 </td>
   <td style="text-align:right;"> 23 </td>
   <td style="text-align:left;"> 10.65 (2.54-80.54) </td>
   <td style="text-align:right;"> 18 </td>
   <td style="text-align:right;"> NA </td>
   <td style="text-align:right;"> 211 </td>
  </tr>
</tbody>
</table>


<｜tool▁calls▁begin｜><｜tool▁call▁begin｜>
grep


```

**Landmark Analysis Diagnostic:**
Total patients in cleared analysis: 28 
Events in Cleared group: 1 
Events in Not Cleared group: 18 
Total events: 19 
Median survival time from landmark (months): 6.9 
```

```
Using adjusted p-value from Cox model (adjusted for line of therapy, therapy class, KPS, and visceral metastases): 0.006 
```

![plot of chunk landmark_survival_curves](figure/landmark_survival_curves-1.png)


```
## Summary
```

```
**Universe - On-Treatment Cohort (Landmark Analysis):** Patients with metastatic disease starting a new line of therapy
  - Includes all lines of therapy (1L, 2L, 3L+, not limited to first-line)
  - Had on-treatment ctDNA measurement within 6-16 weeks after starting each new line
  - Landmark time = ctDNA measurement date within 6-16 week window
  - Time 0 for landmark analysis = landmark time (ctDNA measurement date)
  - **N = 30  patient-line observations
```

```
**Interpretation:**
```

