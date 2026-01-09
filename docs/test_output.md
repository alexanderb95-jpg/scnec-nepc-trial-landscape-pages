---
title: "Research Question 1: Baseline ctDNA Level and Duration of Complete Response"
date: "2026-01-05"
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


```
Error in `mutate()`:
ℹ In argument: `keep_class = if (...) NULL`.
ℹ In group 2: `patient_id = "11"`.
Caused by error in `if (has_non_unspecified) ...`:
! the condition has length > 1
```




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
   <th style="text-align:left;"> Median Follow-up (months) </th>
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
   <td style="text-align:left;"> 8.2 (3.5-14.4) </td>
  </tr>
</tbody>
</table>


```

**Summary:**
Total unique patients in analysis: 38 
Pure urothelial carcinoma: 29 patients ( 76.3 %)
Variant or mixed histology: 9 patients ( 23.7 %)
```






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

## Tertiary Analysis: Overall Survival

**What is the association between baseline ctDNA level before starting a new line of therapy and overall survival?**

This tertiary analysis examines whether baseline ctDNA levels (measured within 21 days before starting therapy) are associated with overall survival. Overall survival is defined as the time from therapy initiation until death, with death as the event and alive patients censored at last follow-up.





<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
<caption>Cox Proportional Hazards Model: ctDNA Level Before Therapy and Overall Survival. Top section shows continuous ctDNA (log10(ctDNA + 1)) with HR progression as covariates are added. Bottom section shows tertile comparisons (T2 vs T1, T3 vs T1) with T1 (Lowest) as reference. HR &gt; 1 indicates shorter overall survival (higher risk of death) compared to reference.</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Model </th>
   <th style="text-align:left;"> HR (95% CI) </th>
   <th style="text-align:left;"> P-value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Unadjusted </td>
   <td style="text-align:left;"> 2.55 (1.48-4.41) </td>
   <td style="text-align:left;"> &lt;0.001 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adjusted for line of therapy </td>
   <td style="text-align:left;"> 2.55 (1.51-4.3) </td>
   <td style="text-align:left;"> &lt;0.001 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adjusted for KPS </td>
   <td style="text-align:left;"> 2.57 (1.46-4.53) </td>
   <td style="text-align:left;"> 0.001 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adjusted for visceral metastases </td>
   <td style="text-align:left;"> 2.71 (1.5-4.88) </td>
   <td style="text-align:left;"> &lt;0.001 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adjusted for therapy class </td>
   <td style="text-align:left;"> 2.43 (1.41-4.2) </td>
   <td style="text-align:left;"> 0.001 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adjusted for line of therapy, therapy class, KPS, and visceral metastases </td>
   <td style="text-align:left;"> 2.97 (1.51-5.84) </td>
   <td style="text-align:left;"> 0.002 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> T2 vs T1 (Unadjusted) </td>
   <td style="text-align:left;"> 1.08 (0.27-4.36) </td>
   <td style="text-align:left;"> 0.911 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> T3 vs T1 (Unadjusted) </td>
   <td style="text-align:left;"> 4.52 (1.39-14.73) </td>
   <td style="text-align:left;"> 0.012 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> T2 vs T1 (Adjusted for line of therapy) </td>
   <td style="text-align:left;"> 1.08 (0.25-4.69) </td>
   <td style="text-align:left;"> 0.914 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> T3 vs T1 (Adjusted for line of therapy) </td>
   <td style="text-align:left;"> 5.63 (1.64-19.3) </td>
   <td style="text-align:left;"> 0.006 </td>
  </tr>
</tbody>
</table>

## Comparison: Quantitative vs Qualitative ctDNA Models for Overall Survival

This analysis compares whether a quantitative (continuous log-transformed) ctDNA model is more informative than a qualitative (binary: 0 vs >0) threshold model for overall survival.




```

**Among ctDNA > 0 (Positive):** median = 29.94 , IQR = [ 2.77 ,  89.34 ]
```

<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
<caption>Comparison: Quantitative vs Qualitative Models for Overall Survival. P-value (Quantitative Better) from likelihood ratio test - p &lt; 0.05 indicates quantitative model performs significantly better than qualitative model.</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Model Type </th>
   <th style="text-align:left;"> Quantitative HR (95% CI) </th>
   <th style="text-align:left;"> Quantitative P-value </th>
   <th style="text-align:right;"> Quantitative AIC </th>
   <th style="text-align:right;"> Quantitative BIC </th>
   <th style="text-align:left;"> Qualitative HR (95% CI) </th>
   <th style="text-align:left;"> Qualitative P-value </th>
   <th style="text-align:right;"> Qualitative AIC </th>
   <th style="text-align:right;"> Qualitative BIC </th>
   <th style="text-align:right;"> AIC Difference (Quant - Qual) </th>
   <th style="text-align:right;"> BIC Difference (Quant - Qual) </th>
   <th style="text-align:left;"> Better Model (AIC) </th>
   <th style="text-align:left;"> Better Model (BIC) </th>
   <th style="text-align:left;"> P-value (Quantitative Better) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Unadjusted </td>
   <td style="text-align:left;"> 2.55 (1.48-4.41) </td>
   <td style="text-align:left;"> &lt;0.001 </td>
   <td style="text-align:right;"> 105.7 </td>
   <td style="text-align:right;"> 106.6 </td>
   <td style="text-align:left;"> 2.42 (0.32-18.24) </td>
   <td style="text-align:left;"> 0.391 </td>
   <td style="text-align:right;"> 116.4 </td>
   <td style="text-align:right;"> 117.3 </td>
   <td style="text-align:right;"> -10.7 </td>
   <td style="text-align:right;"> -10.7 </td>
   <td style="text-align:left;"> Quantitative </td>
   <td style="text-align:left;"> Quantitative </td>
   <td style="text-align:left;"> &lt;0.001 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adjusted for line of therapy </td>
   <td style="text-align:left;"> 2.55 (1.51-4.3) </td>
   <td style="text-align:left;"> &lt;0.001 </td>
   <td style="text-align:right;"> 108.5 </td>
   <td style="text-align:right;"> 112.0 </td>
   <td style="text-align:left;"> 2.71 (0.36-20.48) </td>
   <td style="text-align:left;"> 0.335 </td>
   <td style="text-align:right;"> 119.5 </td>
   <td style="text-align:right;"> 123.1 </td>
   <td style="text-align:right;"> -11.0 </td>
   <td style="text-align:right;"> -11.1 </td>
   <td style="text-align:left;"> Quantitative </td>
   <td style="text-align:left;"> Quantitative </td>
   <td style="text-align:left;"> &lt;0.001 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adjusted for line of therapy, therapy class, KPS, and visceral metastases </td>
   <td style="text-align:left;"> 2.97 (1.51-5.84) </td>
   <td style="text-align:left;"> 0.002 </td>
   <td style="text-align:right;"> 113.7 </td>
   <td style="text-align:right;"> 121.7 </td>
   <td style="text-align:left;"> 1.9 (0.18-20.02) </td>
   <td style="text-align:left;"> 0.593 </td>
   <td style="text-align:right;"> 123.6 </td>
   <td style="text-align:right;"> 131.6 </td>
   <td style="text-align:right;"> -9.9 </td>
   <td style="text-align:right;"> -9.9 </td>
   <td style="text-align:left;"> Quantitative </td>
   <td style="text-align:left;"> Quantitative </td>
   <td style="text-align:left;"> 0.002 </td>
  </tr>
</tbody>
</table>


## Updated Comparison Table with Statistical Test P-values

**Key Finding:**
The likelihood ratio test comparing qualitative (binary-only) vs quantitative (binary+continuous) models shows: **Quantitative model significantly better (continuous adds info beyond binary)** (p = 0.002 ).
This provides formal statistical evidence that the quantitative model performs significantly better than the qualitative model.

## Model Comparison Summary
**AIC/BIC Interpretation:**
- Lower AIC/BIC indicates better model fit (penalizes complexity)
- Differences > 2 are considered meaningful
- Negative differences (Quant - Qual) favor quantitative model
- Positive differences favor qualitative model
**Unadjusted:**
  AIC difference: -10.7 
  BIC difference: -10.7 
  Quantitative model p-value: <0.001 
  Qualitative model p-value: 0.391 
  → Quantitative model has better fit (AIC difference: -10.7 )

**Adjusted for line of therapy:**
  AIC difference: -11 
  BIC difference: -11.1 
  Quantitative model p-value: <0.001 
  Qualitative model p-value: 0.335 
  → Quantitative model has better fit (AIC difference: -11 )

**Adjusted for line of therapy, therapy class, KPS, and visceral metastases:**
  AIC difference: -9.9 
  BIC difference: -9.9 
  Quantitative model p-value: 0.002 
  Qualitative model p-value: 0.593 
  → Quantitative model has better fit (AIC difference: -9.9 )

**Conclusion:**
The quantitative (continuous) ctDNA model provides better fit than the qualitative (binary) model (AIC difference: -9.9 ), suggesting that ctDNA level contains more prognostic information than a simple positive/negative threshold. The formal likelihood ratio test confirms that continuous ctDNA adds significant prognostic information beyond the binary threshold (p = 0.002 ). Additionally, the quantitative model achieves statistical significance (p= 0.002 ) while the qualitative model does not (p = 0.593 ), providing further evidence that the continuous ctDNA value captures more prognostic information than the binary threshold.

## Sensitivity Analysis: Overall Survival by Histology

This sensitivity analysis examines whether the association between baseline ctDNA and overall survival differs between patients with pure urothelial carcinoma (UC) versus those with variant or unknown histology.




```

**Sample sizes:**
- UC group: N = 38 patient-line observations
- Variant/Unknown group: N = 12 patient-line observations

**Test for interaction (histology × ctDNA):**
P-value for interaction (adjusted model): 0.353 
→ No significant interaction: The association between ctDNA and OS does not significantly differ between histology groups (p = 0.353 )
```

![plot of chunk os_survival_curves_q1](figure/os_survival_curves_q1-1.png)

![plot of chunk continuous_association_plot_os](figure/continuous_association_plot_os-1.png)


```
## Overall Survival Interpretation
```

```
**Interpretation:**
```

```
Higher baseline ctDNA levels before starting a new line of therapy are significantly associated with shorter overall survival (HR = 2.97, 95% CI: 1.51-5.84), adjusted for line of therapy, therapy class, KPS, and visceral metastases. This finding suggests that baseline ctDNA level may serve as a prognostic biomarker for overall survival outcomes.
```

```
Diagnostic: Dataset sizes
```

```
  outcomes (before joins): 48 rows
```

```
  outcomes_for_model (after joins): 48 rows
```

<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
<caption>Cox Proportional Hazards Model: ctDNA Level Before Therapy and Duration of Complete Response. Top section shows continuous ctDNA (Ln(ctDNA + 1)) with HR progression as covariates are added. Bottom section shows tertile comparisons (T2 vs T1, T3 vs T1) with T1 (Lowest) as reference. HR &gt; 1 indicates shorter duration of complete response (higher risk of loss of CR or death) compared to reference.</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Model </th>
   <th style="text-align:left;"> HR (95% CI) </th>
   <th style="text-align:left;"> P-value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Unadjusted </td>
   <td style="text-align:left;"> 2.28 (1.51-3.45) </td>
   <td style="text-align:left;"> &lt;0.001 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adjusted for line of therapy </td>
   <td style="text-align:left;"> 2.27 (1.48-3.49) </td>
   <td style="text-align:left;"> &lt;0.001 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adjusted for KPS </td>
   <td style="text-align:left;"> 2.27 (1.5-3.46) </td>
   <td style="text-align:left;"> &lt;0.001 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adjusted for visceral metastases </td>
   <td style="text-align:left;"> 2.43 (1.54-3.82) </td>
   <td style="text-align:left;"> &lt;0.001 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adjusted for line of therapy and therapy class </td>
   <td style="text-align:left;"> 2.81 (1.78-4.44) </td>
   <td style="text-align:left;"> &lt;0.001 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adjusted for line of therapy, therapy class, KPS, and visceral metastases </td>
   <td style="text-align:left;"> 3.27 (1.91-5.59) </td>
   <td style="text-align:left;"> &lt;0.001 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> T2 vs T1 (Unadjusted) </td>
   <td style="text-align:left;"> 2.05 (0.77-5.43) </td>
   <td style="text-align:left;"> 0.15 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> T3 vs T1 (Unadjusted) </td>
   <td style="text-align:left;"> 5.45 (2-14.87) </td>
   <td style="text-align:left;"> &lt;0.001 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> T2 vs T1 (Adjusted for line of therapy) </td>
   <td style="text-align:left;"> 2.01 (0.7-5.79) </td>
   <td style="text-align:left;"> 0.196 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> T3 vs T1 (Adjusted for line of therapy) </td>
   <td style="text-align:left;"> 5.18 (1.78-15.09) </td>
   <td style="text-align:left;"> 0.003 </td>
  </tr>
</tbody>
</table>

<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
<caption>Distribution of Baseline ctDNA Values (Qualitative Threshold Analysis)</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Category </th>
   <th style="text-align:right;"> N </th>
   <th style="text-align:left;"> % </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Total observations </td>
   <td style="text-align:right;"> 48 </td>
   <td style="text-align:left;"> 100.0 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ctDNA = 0 (Negative) </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:left;"> 10.4% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ctDNA &gt; 0 (Positive) </td>
   <td style="text-align:right;"> 43 </td>
   <td style="text-align:left;"> 89.6% </td>
  </tr>
</tbody>
</table>

```
**Among ctDNA > 0 (Positive):** median = 22.56 , IQR = [ 2.77 ,  125.27 ]
```

```

**Key Finding:**
The likelihood ratio test comparing qualitative (binary-only) vs quantitative (binary+continuous) models shows: **Quantitative model significantly better (continuous adds info beyond binary)** (p = <0.001).
This provides formal statistical evidence that the quantitative model performs significantly better than the qualitative model.

## Updated Comparison Table with Statistical Test P-values
```

<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
<caption>Comparison: Quantitative vs Qualitative Models with Statistical Test Results. P-value (Quantitative Better) from likelihood ratio test - p &lt; 0.05 indicates quantitative model performs significantly better than qualitative model.</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Model Type </th>
   <th style="text-align:left;"> Quantitative HR (95% CI) </th>
   <th style="text-align:left;"> Quantitative P-value </th>
   <th style="text-align:right;"> Quantitative AIC </th>
   <th style="text-align:right;"> Quantitative BIC </th>
   <th style="text-align:left;"> Qualitative HR (95% CI) </th>
   <th style="text-align:left;"> Qualitative P-value </th>
   <th style="text-align:right;"> Qualitative AIC </th>
   <th style="text-align:right;"> Qualitative BIC </th>
   <th style="text-align:right;"> AIC Difference (Quant - Qual) </th>
   <th style="text-align:right;"> BIC Difference (Quant - Qual) </th>
   <th style="text-align:left;"> Better Model (AIC) </th>
   <th style="text-align:left;"> Better Model (BIC) </th>
   <th style="text-align:left;"> P-value (Quantitative Better) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Unadjusted </td>
   <td style="text-align:left;"> 2.28 (1.51-3.45) </td>
   <td style="text-align:left;"> &lt;0.001 </td>
   <td style="text-align:right;"> 181.5 </td>
   <td style="text-align:right;"> 183.0 </td>
   <td style="text-align:left;"> 3.06 (0.71-13.09) </td>
   <td style="text-align:left;"> 0.132 </td>
   <td style="text-align:right;"> 193.8 </td>
   <td style="text-align:right;"> 195.3 </td>
   <td style="text-align:right;"> -12.3 </td>
   <td style="text-align:right;"> -12.3 </td>
   <td style="text-align:left;"> Quantitative </td>
   <td style="text-align:left;"> Quantitative </td>
   <td style="text-align:left;"> &lt;0.001 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adjusted for line of therapy </td>
   <td style="text-align:left;"> 2.27 (1.48-3.49) </td>
   <td style="text-align:left;"> &lt;0.001 </td>
   <td style="text-align:right;"> 186.7 </td>
   <td style="text-align:right;"> 192.7 </td>
   <td style="text-align:left;"> 2.69 (0.62-11.66) </td>
   <td style="text-align:left;"> 0.186 </td>
   <td style="text-align:right;"> 198.1 </td>
   <td style="text-align:right;"> 204.1 </td>
   <td style="text-align:right;"> -11.4 </td>
   <td style="text-align:right;"> -11.4 </td>
   <td style="text-align:left;"> Quantitative </td>
   <td style="text-align:left;"> Quantitative </td>
   <td style="text-align:left;"> &lt;0.001 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adjusted for line of therapy, therapy class, KPS, and visceral metastases </td>
   <td style="text-align:left;"> 3.27 (1.91-5.59) </td>
   <td style="text-align:left;"> &lt;0.001 </td>
   <td style="text-align:right;"> 186.9 </td>
   <td style="text-align:right;"> 200.4 </td>
   <td style="text-align:left;"> 4.17 (0.77-22.64) </td>
   <td style="text-align:left;"> 0.098 </td>
   <td style="text-align:right;"> 202.2 </td>
   <td style="text-align:right;"> 215.6 </td>
   <td style="text-align:right;"> -15.3 </td>
   <td style="text-align:right;"> -15.2 </td>
   <td style="text-align:left;"> Quantitative </td>
   <td style="text-align:left;"> Quantitative </td>
   <td style="text-align:left;"> &lt;0.001 </td>
  </tr>
</tbody>
</table>

```

**Interpretation of Log-Likelihood Comparison:**
- Higher log-likelihood = better model fit
- Positive log-likelihood difference (Quant - Qual) favors quantitative model
```

```

## Model Comparison Summary
```

```
**AIC/BIC Interpretation:**
```

```
- Lower AIC/BIC indicates better model fit (penalizes complexity)
```

```
- Differences > 2 are considered meaningful
```

```
- Negative differences (Quant - Qual) favor quantitative model
```

```
- Positive differences favor qualitative model
```

```
**Unadjusted:**
  AIC difference: -12.3 
  BIC difference: -12.3 
  Quantitative model p-value: <0.001 
  Qualitative model p-value: 0.132 
  → Quantitative model has better fit (AIC difference: -12.3 )

**Adjusted for line of therapy:**
  AIC difference: -11.4 
  BIC difference: -11.4 
  Quantitative model p-value: <0.001 
  Qualitative model p-value: 0.186 
  → Quantitative model has better fit (AIC difference: -11.4 )

**Adjusted for line of therapy, therapy class, KPS, and visceral metastases:**
  AIC difference: -15.3 
  BIC difference: -15.2 
  Quantitative model p-value: <0.001 
  Qualitative model p-value: 0.098 
  → Quantitative model has better fit (AIC difference: -15.3 )
```

```
**Conclusion:**
```

```
The quantitative (continuous) ctDNA model provides better fit than the qualitative (binary) model (AIC difference: -15.3 ), suggesting that ctDNA level contains more prognostic information than a simple positive/negative threshold. The formal likelihood ratio test confirms that continuous ctDNA adds significant prognostic information beyond the binary threshold (p = <0.001). Additionally, the quantitative model achieves statistical significance (p<0.001) while the qualitative model does not (p = 0.098), providing further evidence that the continuous ctDNA value captures more prognostic information than the binary threshold.
```


```

**N for multivariate model:** 48 observations
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
   <td style="text-align:left;"> 2.27 (1.48-3.49) </td>
   <td style="text-align:left;"> &lt;0.001 </td>
   <td style="text-align:right;"> 33 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sensitivity (All Events) </td>
   <td style="text-align:left;"> 1.57 (1.11-2.22) </td>
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

## Secondary Analysis: Time to Next Treatment

**What is the association between baseline ctDNA level before starting a new line of therapy and time to next treatment?**

This secondary analysis examines whether baseline ctDNA levels (measured within 21 days before starting therapy) are associated with time to next treatment. Time to next treatment is defined as the time from therapy initiation until the start of the next line of therapy or death, whichever occurs first.





<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
<caption>Cox Proportional Hazards Model: Baseline ctDNA Level and Time to Next Treatment. HR &gt; 1 indicates shorter time to next treatment (higher risk of starting next therapy or death) compared to reference.</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Model </th>
   <th style="text-align:left;"> HR (95% CI) </th>
   <th style="text-align:left;"> P-value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Unadjusted </td>
   <td style="text-align:left;"> 1.56 (1.07-2.29) </td>
   <td style="text-align:left;"> 0.022 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adjusted for line of therapy </td>
   <td style="text-align:left;"> 1.59 (1.09-2.32) </td>
   <td style="text-align:left;"> 0.015 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adjusted for line of therapy and therapy class </td>
   <td style="text-align:left;"> 1.65 (1.09-2.49) </td>
   <td style="text-align:left;"> 0.018 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adjusted for line of therapy, therapy class, KPS, and visceral metastases </td>
   <td style="text-align:left;"> 2.26 (1.34-3.81) </td>
   <td style="text-align:left;"> 0.002 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> T2 vs T1 (Unadjusted) </td>
   <td style="text-align:left;"> 0.91 (0.35-2.36) </td>
   <td style="text-align:left;"> 0.847 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> T3 vs T1 (Unadjusted) </td>
   <td style="text-align:left;"> 3.09 (1.31-7.31) </td>
   <td style="text-align:left;"> 0.01 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> T2 vs T1 (Adjusted for line of therapy) </td>
   <td style="text-align:left;"> 1.02 (0.39-2.72) </td>
   <td style="text-align:left;"> 0.963 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> T3 vs T1 (Adjusted for line of therapy) </td>
   <td style="text-align:left;"> 3.31 (1.35-8.12) </td>
   <td style="text-align:left;"> 0.009 </td>
  </tr>
</tbody>
</table>

![plot of chunk ttnt_survival_curves_q1](figure/ttnt_survival_curves_q1-1.png)


```
## Time to Next Treatment Interpretation
```

```
**Interpretation:**
```

```
Higher baseline ctDNA levels before starting a new line of therapy are significantly associated with shorter time to next treatment (HR = 2.26, 95% CI: 1.34-3.81), adjusted for line of therapy, therapy class, KPS, and visceral metastases. This finding suggests that baseline ctDNA level may serve as a prognostic biomarker for time to next treatment outcomes.
```



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
- Hazard Ratio per log10-unit increase in ctDNA (adjusted for line of therapy, KPS, and visceral metastases): 3.27  (95% CI:  1.91 - 5.59 )
- P-value: <0.001 
```

```
**Interpretation:**
```

```
Higher ctDNA levels before starting a new line of therapy are significantly associated with worse duration of complete response (HR = 3.27, 95% CI: 1.91-5.59), adjusted for line of therapy, KPS, and visceral metastases. This finding suggests that ctDNA level before therapy initiation may serve as a prognostic biomarker for duration of complete response outcomes across multiple lines of therapy in patients with metastatic urothelial carcinoma.
```

