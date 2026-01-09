::::: {.container-fluid .main-container}
::: {#header}
# Research Question 1: Baseline ctDNA Level and Duration of Complete Response {#research-question-1-baseline-ctdna-level-and-duration-of-complete-response .title .toc-ignore}

#### 2026-01-04 {#section .date}
:::

::: {#research-question .section .level2}
## Research Question

**What is the association between circulating tumor DNA (ctDNA) level
before starting a new line of therapy and duration of complete
response?**

This analysis examines whether ctDNA levels measured before starting
each new line of metastatic therapy are prognostic for duration of
complete response in patients with metastatic urothelial carcinoma. The
analysis includes all lines of therapy (1L, 2L, 3L+, not limited to
first-line), with each line of therapy as a separate observation and
time 0 defined as the start of each new line of therapy.

**Note on Endpoint Definition:** We analyze "Duration of Complete
Response" (DCR), which represents the time from therapy initiation until
loss of complete response or death. **Events** occur when: (1) the
patient dies, OR (2) the patient is alive but has obvious disease
present on most recent imaging (i.e., loss of complete response, similar
to RECIST progression from CR). **Patients are censored** when they are
alive and have no obvious disease on most recent imaging (i.e.,
maintaining complete response, similar to RECIST CR). This endpoint
captures both survival and maintenance of complete response, which is
clinically meaningful in the metastatic setting. Note: Patients with
stable disease or partial response (but with disease still present on
imaging) are considered events, as they have lost or never achieved
complete response. **Important:** Patients who died do NOT require
imaging data for inclusion (death is an event). Only alive patients
require imaging data to determine complete response status.

    ## Population Studied

    **Universe:** Patients with metastatic disease starting a new line of therapy

    **N = 48  patient-line observations ( 38  unique patients)

    **Note:** Final analysis N (after excluding observations due to missing survival data) is shown in the exclusion and descriptive tables below.

    **Inclusion Criteria:**

    - Confirmed metastatic disease

    - Starting a new line of palliative/metastatic therapy (includes 1L, 2L, 3L+, not limited to first-line)

    - Had ctDNA level measured within 21 days before starting that line of therapy

    - Time 0 = start of each new line of therapy

    **Note:** Each patient can contribute multiple observations (one per line of therapy). Line of therapy is included as a covariate in the analysis.

  Therapy Class   N Patients (%)
  --------------- ----------------
  ADC             30 (78.9%)
  Chemo           17 (44.7%)
  ICI             13 (34.2%)
  unspecified     4 (10.5%)
  Targeted        1 (2.6%)

  : Palliative Systemic Therapy Classes (ADC/ICI/Chemo/Targeted/Other)
  (baseline universe). Note: patients can appear in multiple classes if
  they received combination regimens (e.g., ADC + ICI). Percentages are
  calculated based on total unique patients in the analysis universe (N
  = 38). {.table .table-striped .table-hover
  style="margin-left: auto; margin-right: auto;"}

    No observations excluded - all 48 patient-line observations had valid survival data.

    ## Patient IDs Excluded Due to Missing Imaging Data

    **No patients excluded due to missing imaging data.**
    (All alive patients had imaging data available, or all excluded patients had died and did not require imaging data.)

    N (Patient-Line Observations)   N (Unique Patients)   1L   2L   3L   4L+ ctDNA Before Therapy (median, IQR)   Days from ctDNA to Therapy Start (median, IQR)     DCR Events   Median DCR (months)   1-year DCR % Median Follow-up (months)
  ------------------------------- --------------------- ---- ---- ---- ----- ------------------------------------ ------------------------------------------------ ------------ --------------------- -------------- ---------------------------
                               48                    38   19   13    9     7 13.12 (2.47-83.64)                   10 (0-18)                                                  33                   8.2           30.3 8.2 (3.5-14.4)

  : Descriptive Characteristics of Study Population {.table
  .table-striped .table-hover
  style="margin-left: auto; margin-right: auto;"}


    **Summary:**
    Total unique patients in analysis: 38 
    Pure urothelial carcinoma: 29 patients ( 76.3 %)
    Variant or mixed histology: 9 patients ( 23.7 %)

  Metric                    Value
  ---------------------- --------
  N                        48.000
  Has Death Date           18.000
  Has Last FU Date         38.000
  Has Alive Status         48.000
  Alive Status = Yes       30.000
  Alive Status = No        18.000
  Alive Status Missing      0.000
  Events                   33.000
  Censored                 15.000
  Censoring Rate            0.312

  : Data Completeness for Event Classification {.table .table-striped
  .table-hover style="margin-left: auto; margin-right: auto;"}

  Classification                                         N     \%
  --------------------------------------------------- ---- ------
  Censored: Alive without disease on imaging            15   31.2
  Event: Death (has death_date)                         18   37.5
  Event: Imaging shows disease (alive with disease)     15   31.2

  : Breakdown of DCR Event vs. Censored Classification\
  Note: DCR Events include: (1) Death (death_date or alive_status=No),
  OR (2) Alive with obvious disease on most recent imaging (loss of
  complete response, includes stable disease, partial response, or
  progressive disease). DCR Censored = Alive without obvious disease on
  imaging (maintaining complete response, similar to RECIST CR). Only
  alive patients with missing imaging data are excluded (imaging data is
  required for alive patients only; patients who died do not require
  imaging data). {.table .table-striped .table-hover
  style="margin-left: auto; margin-right: auto;"}

Censoring Rate Analysis by ctDNA Tertile

Group
:::
:::::

N

N Events

N Censored

Censoring Rate

Interpretation

Chi-square P-value

T1 (Lowest)

16

6

10

62.5%

⚠️ Potentially informative

\|0.004

T2

16

13

3

18.8%

⚠️ Potentially informative

| 


    **Interpretation:** Censoring may be informative (p = 0.004 ). Consider sensitivity analyses.

::: {#tertiary-analysis-overall-survival .section .level2}
## Tertiary Analysis: Overall Survival

**What is the association between baseline ctDNA level before starting a
new line of therapy and overall survival?**

This tertiary analysis examines whether baseline ctDNA levels (measured
within 21 days before starting therapy) are associated with overall
survival. Overall survival is defined as the time from therapy
initiation until death, with death as the event and alive patients
censored at last follow-up.

  Model                                                                       HR (95% CI)         P-value
  --------------------------------------------------------------------------- ------------------- ---------
  Unadjusted                                                                  2.55 (1.48-4.41)    \<0.001
  Adjusted for line of therapy                                                2.55 (1.51-4.3)     \<0.001
  Adjusted for KPS                                                            2.57 (1.46-4.53)    0.001
  Adjusted for visceral metastases                                            2.71 (1.5-4.88)     \<0.001
  Adjusted for therapy class                                                  2.43 (1.41-4.2)     0.001
  Adjusted for line of therapy, therapy class, KPS, and visceral metastases   2.97 (1.51-5.84)    0.002
  T2 vs T1 (Unadjusted)                                                       1.08 (0.27-4.36)    0.911
  T3 vs T1 (Unadjusted)                                                       4.52 (1.39-14.73)   0.012
  T2 vs T1 (Adjusted for line of therapy)                                     1.08 (0.25-4.69)    0.914
  T3 vs T1 (Adjusted for line of therapy)                                     5.63 (1.64-19.3)    0.006

  : Cox Proportional Hazards Model: ctDNA Level Before Therapy and
  Overall Survival. Top section shows continuous ctDNA (log10(ctDNA +
  1)) with HR progression as covariates are added. Bottom section shows
  tertile comparisons (T2 vs T1, T3 vs T1) with T1 (Lowest) as
  reference. HR \> 1 indicates shorter overall survival (higher risk of
  death) compared to reference. {.table .table-striped .table-hover
  style="margin-left: auto; margin-right: auto;"}
:::

::: {#comparison-quantitative-vs-qualitative-ctdna-models-for-overall-survival .section .level2}
## Comparison: Quantitative vs Qualitative ctDNA Models for Overall Survival

This analysis compares whether a quantitative (continuous
log-transformed) ctDNA model is more informative than a qualitative
(binary: 0 vs \>0) threshold model for overall survival.


    **Among ctDNA > 0 (Positive):** median = 29.94 , IQR = [ 2.77 ,  89.34 ]

  Model Type                                                                  Quantitative HR (95% CI)   Quantitative P-value     Quantitative AIC   Quantitative BIC Qualitative HR (95% CI)   Qualitative P-value     Qualitative AIC   Qualitative BIC   AIC Difference (Quant - Qual)   BIC Difference (Quant - Qual) Better Model (AIC)   Better Model (BIC)   P-value (Quantitative Better)
  --------------------------------------------------------------------------- -------------------------- ---------------------- ------------------ ------------------ ------------------------- --------------------- ----------------- ----------------- ------------------------------- ------------------------------- -------------------- -------------------- -------------------------------
  Unadjusted                                                                  2.55 (1.48-4.41)           \<0.001                             105.7              106.6 2.42 (0.32-18.24)         0.391                             116.4             117.3                           -10.7                           -10.7 Quantitative         Quantitative         \<0.001
  Adjusted for line of therapy                                                2.55 (1.51-4.3)            \<0.001                             108.5              112.0 2.71 (0.36-20.48)         0.335                             119.5             123.1                           -11.0                           -11.1 Quantitative         Quantitative         \<0.001
  Adjusted for line of therapy, therapy class, KPS, and visceral metastases   2.97 (1.51-5.84)           0.002                               113.7              121.7 1.9 (0.18-20.02)          0.593                             123.6             131.6                            -9.9                            -9.9 Quantitative         Quantitative         0.002

  : Comparison: Quantitative vs Qualitative Models for Overall Survival.
  P-value (Quantitative Better) from likelihood ratio test - p \< 0.05
  indicates quantitative model performs significantly better than
  qualitative model. {.table .table-striped .table-hover
  style="margin-left: auto; margin-right: auto;"}
:::

::: {#updated-comparison-table-with-statistical-test-p-values .section .level2}
## Updated Comparison Table with Statistical Test P-values

**Key Finding:** The likelihood ratio test comparing qualitative
(binary-only) vs quantitative (binary+continuous) models shows:
**Quantitative model significantly better (continuous adds info beyond
binary)** (p = 0.002 ). This provides formal statistical evidence that
the quantitative model performs significantly better than the
qualitative model.
:::

::: {#model-comparison-summary .section .level2}
## Model Comparison Summary

**AIC/BIC Interpretation:** - Lower AIC/BIC indicates better model fit
(penalizes complexity) - Differences \> 2 are considered meaningful -
Negative differences (Quant - Qual) favor quantitative model - Positive
differences favor qualitative model **Unadjusted:** AIC difference:
-10.7 BIC difference: -10.7 Quantitative model p-value: \<0.001
Qualitative model p-value: 0.391 → Quantitative model has better fit
(AIC difference: -10.7 )

**Adjusted for line of therapy:** AIC difference: -11 BIC difference:
-11.1 Quantitative model p-value: \<0.001 Qualitative model p-value:
0.335 → Quantitative model has better fit (AIC difference: -11 )

**Adjusted for line of therapy, therapy class, KPS, and visceral
metastases:** AIC difference: -9.9 BIC difference: -9.9 Quantitative
model p-value: 0.002 Qualitative model p-value: 0.593 → Quantitative
model has better fit (AIC difference: -9.9 )

**Conclusion:** The quantitative (continuous) ctDNA model provides
better fit than the qualitative (binary) model (AIC difference: -9.9 ),
suggesting that ctDNA level contains more prognostic information than a
simple positive/negative threshold. The formal likelihood ratio test
confirms that continuous ctDNA adds significant prognostic information
beyond the binary threshold (p = 0.002 ). Additionally, the quantitative
model achieves statistical significance (p= 0.002 ) while the
qualitative model does not (p = 0.593 ), providing further evidence that
the continuous ctDNA value captures more prognostic information than the
binary threshold.
:::

::: {#sensitivity-analysis-overall-survival-by-histology .section .level2}
## Sensitivity Analysis: Overall Survival by Histology

This sensitivity analysis examines whether the association between
baseline ctDNA and overall survival differs between patients with pure
urothelial carcinoma (UC) versus those with variant or unknown
histology.


    **Sample sizes:**
    - UC group: N = 38 patient-line observations
    - Variant/Unknown group: N = 12 patient-line observations

    **Test for interaction (histology × ctDNA):**
    P-value for interaction (adjusted model): 0.353 
    → No significant interaction: The association between ctDNA and OS does not significantly differ between histology groups (p = 0.353 )

![](./media/16c4f435ffbba1f5d738764a332216fc85cbd6c7.png){role="img"
width="672"}

![](./media/f067f97abe00c13d5a13c3927353c468d3d7406d.png){role="img"
width="672"}

    ## Overall Survival Interpretation

    **Interpretation:**

    Higher baseline ctDNA levels before starting a new line of therapy are significantly associated with shorter overall survival (HR = 2.97, 95% CI: 1.51-5.84), adjusted for line of therapy, therapy class, KPS, and visceral metastases. This finding suggests that baseline ctDNA level may serve as a prognostic biomarker for overall survival outcomes.

    Diagnostic: Dataset sizes

      outcomes (before joins): 48 rows

      outcomes_for_model (after joins): 48 rows

  Model                                                                       HR (95% CI)         P-value
  --------------------------------------------------------------------------- ------------------- ---------
  Unadjusted                                                                  2.28 (1.51-3.45)    \<0.001
  Adjusted for line of therapy                                                2.27 (1.48-3.49)    \<0.001
  Adjusted for KPS                                                            2.27 (1.5-3.46)     \<0.001
  Adjusted for visceral metastases                                            2.43 (1.54-3.82)    \<0.001
  Adjusted for line of therapy and therapy class                              2.81 (1.78-4.44)    \<0.001
  Adjusted for line of therapy, therapy class, KPS, and visceral metastases   3.27 (1.91-5.59)    \<0.001
  T2 vs T1 (Unadjusted)                                                       2.05 (0.77-5.43)    0.15
  T3 vs T1 (Unadjusted)                                                       5.45 (2-14.87)      \<0.001
  T2 vs T1 (Adjusted for line of therapy)                                     2.01 (0.7-5.79)     0.196
  T3 vs T1 (Adjusted for line of therapy)                                     5.18 (1.78-15.09)   0.003

  : Cox Proportional Hazards Model: ctDNA Level Before Therapy and
  Duration of Complete Response. Top section shows continuous ctDNA
  (Ln(ctDNA + 1)) with HR progression as covariates are added. Bottom
  section shows tertile comparisons (T2 vs T1, T3 vs T1) with T1
  (Lowest) as reference. HR \> 1 indicates shorter duration of complete
  response (higher risk of loss of CR or death) compared to reference.
  {.table .table-striped .table-hover
  style="margin-left: auto; margin-right: auto;"}

  Category                   N \%
  ----------------------- ---- -------
  Total observations        48 100.0
  ctDNA = 0 (Negative)       5 10.4%
  ctDNA \> 0 (Positive)     43 89.6%

  : Distribution of Baseline ctDNA Values (Qualitative Threshold
  Analysis) {.table .table-striped .table-hover
  style="margin-left: auto; margin-right: auto;"}

    **Among ctDNA > 0 (Positive):** median = 22.56 , IQR = [ 2.77 ,  125.27 ]


    **Key Finding:**
    The likelihood ratio test comparing qualitative (binary-only) vs quantitative (binary+continuous) models shows: **Quantitative model significantly better (continuous adds info beyond binary)** (p = <0.001).
    This provides formal statistical evidence that the quantitative model performs significantly better than the qualitative model.

    ## Updated Comparison Table with Statistical Test P-values

  Model Type                                                                  Quantitative HR (95% CI)   Quantitative P-value     Quantitative AIC   Quantitative BIC Qualitative HR (95% CI)   Qualitative P-value     Qualitative AIC   Qualitative BIC   AIC Difference (Quant - Qual)   BIC Difference (Quant - Qual) Better Model (AIC)   Better Model (BIC)   P-value (Quantitative Better)
  --------------------------------------------------------------------------- -------------------------- ---------------------- ------------------ ------------------ ------------------------- --------------------- ----------------- ----------------- ------------------------------- ------------------------------- -------------------- -------------------- -------------------------------
  Unadjusted                                                                  2.28 (1.51-3.45)           \<0.001                             181.5              183.0 3.06 (0.71-13.09)         0.132                             193.8             195.3                           -12.3                           -12.3 Quantitative         Quantitative         \<0.001
  Adjusted for line of therapy                                                2.27 (1.48-3.49)           \<0.001                             186.7              192.7 2.69 (0.62-11.66)         0.186                             198.1             204.1                           -11.4                           -11.4 Quantitative         Quantitative         \<0.001
  Adjusted for line of therapy, therapy class, KPS, and visceral metastases   3.27 (1.91-5.59)           \<0.001                             186.9              200.4 4.17 (0.77-22.64)         0.098                             202.2             215.6                           -15.3                           -15.2 Quantitative         Quantitative         \<0.001

  : Comparison: Quantitative vs Qualitative Models with Statistical Test
  Results. P-value (Quantitative Better) from likelihood ratio test - p
  \< 0.05 indicates quantitative model performs significantly better
  than qualitative model. {.table .table-striped .table-hover
  style="margin-left: auto; margin-right: auto;"}


    **Interpretation of Log-Likelihood Comparison:**
    - Higher log-likelihood = better model fit
    - Positive log-likelihood difference (Quant - Qual) favors quantitative model


    ## Model Comparison Summary

    **AIC/BIC Interpretation:**

    - Lower AIC/BIC indicates better model fit (penalizes complexity)

    - Differences > 2 are considered meaningful

    - Negative differences (Quant - Qual) favor quantitative model

    - Positive differences favor qualitative model

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

    **Conclusion:**

    The quantitative (continuous) ctDNA model provides better fit than the qualitative (binary) model (AIC difference: -15.3 ), suggesting that ctDNA level contains more prognostic information than a simple positive/negative threshold. The formal likelihood ratio test confirms that continuous ctDNA adds significant prognostic information beyond the binary threshold (p = <0.001). Additionally, the quantitative model achieves statistical significance (p<0.001) while the qualitative model does not (p = 0.098), providing further evidence that the continuous ctDNA value captures more prognostic information than the binary threshold.


    **N for multivariate model:** 48 observations
    **Note:** This model includes Bajorin risk factors (KPS and visceral metastases) in addition to ctDNA level and line of therapy.


    **Tertile Cutoffs Summary:**
    - **T1 (Lowest):** ctDNA ≤ 2.77
    - **T2:** ctDNA from 2.77 to 59.73
    - **T3 (Highest):** ctDNA ≥ 64.05

    **Note:** Tertiles are created by dividing the ctDNA values into three equal groups based on rank (ntile function). T1 (Lowest) contains the lowest third of ctDNA values, T2 contains the middle third, and T3 (Highest) contains the highest third.

![](./media/2e56dd47d8e1dc51cd4d391634871786af02a021.png){role="img"
width="672"}


    **Overall Test for Trend:**
    Wald test p-value: 0.001 

  Analysis                   HR (95% CI)        P-value     N Events
  -------------------------- ------------------ --------- ----------
  Standard (Censored)        2.27 (1.48-3.49)   \<0.001           33
  Sensitivity (All Events)   1.57 (1.11-2.22)   0.011             48

  : Sensitivity Analysis: Treating Censored Observations as Events
  (Worst-Case Scenario) {.table .table-striped .table-hover
  style="margin-left: auto; margin-right: auto;"}


    **Note:** This sensitivity analysis assumes all censored patients had events at their censoring time.

    This provides a worst-case scenario to assess robustness of findings.

![](./media/5b965c253646ab83ad09e4c7adf2ceac1429c553.png){role="img"
width="672"}
:::

::: {#secondary-analysis-time-to-next-treatment .section .level2}
## Secondary Analysis: Time to Next Treatment

**What is the association between baseline ctDNA level before starting a
new line of therapy and time to next treatment?**

This secondary analysis examines whether baseline ctDNA levels (measured
within 21 days before starting therapy) are associated with time to next
treatment. Time to next treatment is defined as the time from therapy
initiation until the start of the next line of therapy or death,
whichever occurs first.

  Model                                                                       HR (95% CI)        P-value
  --------------------------------------------------------------------------- ------------------ ---------
  Unadjusted                                                                  1.56 (1.07-2.29)   0.022
  Adjusted for line of therapy                                                1.59 (1.09-2.32)   0.015
  Adjusted for line of therapy and therapy class                              1.65 (1.09-2.49)   0.018
  Adjusted for line of therapy, therapy class, KPS, and visceral metastases   2.26 (1.34-3.81)   0.002
  T2 vs T1 (Unadjusted)                                                       0.91 (0.35-2.36)   0.847
  T3 vs T1 (Unadjusted)                                                       3.09 (1.31-7.31)   0.01
  T2 vs T1 (Adjusted for line of therapy)                                     1.02 (0.39-2.72)   0.963
  T3 vs T1 (Adjusted for line of therapy)                                     3.31 (1.35-8.12)   0.009

  : Cox Proportional Hazards Model: Baseline ctDNA Level and Time to
  Next Treatment. HR \> 1 indicates shorter time to next treatment
  (higher risk of starting next therapy or death) compared to reference.
  {.table .table-striped .table-hover
  style="margin-left: auto; margin-right: auto;"}

![](./media/314eddd0f316d3a23b37dc88daa3cffb5de6ab85.png){role="img"
width="672"}

    ## Time to Next Treatment Interpretation

    **Interpretation:**

    Higher baseline ctDNA levels before starting a new line of therapy are significantly associated with shorter time to next treatment (HR = 2.26, 95% CI: 1.34-3.81), adjusted for line of therapy, therapy class, KPS, and visceral metastases. This finding suggests that baseline ctDNA level may serve as a prognostic biomarker for time to next treatment outcomes.

    ## Summary

    **Universe - Prognostic Cohort (Baseline ctDNA Analysis):** Patients with metastatic disease starting a new line of therapy

      - Includes all lines of therapy (1L, 2L, 3L+, not limited to first-line)

      - ctDNA measured within 21 days before starting each new line

      - Time 0 = start of each new line of therapy

      - **N = 48  patient-line observations

    **Key Findings - Prognostic (Baseline ctDNA):**

    - Median ctDNA before therapy: 13.12 

    - Hazard Ratio per log10-unit increase in ctDNA (adjusted for line of therapy, KPS, and visceral metastases): 3.27  (95% CI:  1.91 - 5.59 )
    - P-value: <0.001 

    **Interpretation:**

    Higher ctDNA levels before starting a new line of therapy are significantly associated with worse duration of complete response (HR = 3.27, 95% CI: 1.91-5.59), adjusted for line of therapy, KPS, and visceral metastases. This finding suggests that ctDNA level before therapy initiation may serve as a prognostic biomarker for duration of complete response outcomes across multiple lines of therapy in patients with metastatic urothelial carcinoma.
:::

::::::::::: {.container-fluid .main-container}
::: {#header}
# Research Question 2: Defining Optimal On-Treatment Changes in ctDNA as an Intermediate Endpoint in Metastatic UC {#research-question-2-defining-optimal-on-treatment-changes-in-ctdna-as-an-intermediate-endpoint-in-metastatic-uc .title .toc-ignore}

#### 2026-01-04 {#section-1 .date}
:::

**RESEARCH QUESTION:**

**Defining optimal on-treatment changes in ctDNA as an intermediate
endpoint in metastatic UC**

This analysis aims to: 1. Define what constitutes "optimal" on-treatment
ctDNA changes (e.g., thresholds for percent decline, clearance, absolute
values) 2. Validate these ctDNA changes as intermediate endpoints by
demonstrating their association with clinical outcomes (duration of
complete response, overall survival, time to next treatment) 3. Identify
the optimal threshold(s) that best predict clinical benefit in patients
with metastatic urothelial carcinoma receiving systemic therapy

    ## Population Studied

    **Universe:** Patients with metastatic disease starting a new line of therapy who had on-treatment ctDNA measured within 6-24 weeks after therapy initiation

    **N =48 patient-line observations (38 unique patients) (baseline universe - actual on-treatment analysis N shown in landmark analysis section below)

    **Note:** The final analysis N (after excluding observations due to missing survival data or failure to survive to landmark) is shown in the landmark analysis section below.

    **Inclusion Criteria:**

    - Confirmed metastatic disease

    - Starting a new line of palliative/metastatic therapy (includes 1L, 2L, 3L+, not limited to first-line)

    - Had baseline ctDNA level measured within 21 days before starting that line of therapy

    - Had on-treatment ctDNA level measured within 6-24 weeks after starting that line of therapy

    - Survived to the landmark time point (ctDNA measurement date)

    - Time 0 for landmark analysis = landmark time (ctDNA measurement date within 6-24 weeks)

    **Note:** Each patient can contribute multiple observations (one per line of therapy). Line of therapy is included as a covariate in the analysis.

\<｜tool▁calls▁begin｜\>\<｜tool▁call▁begin｜\> read_file
\<｜tool▁calls▁begin｜\>\<｜tool▁call▁begin｜\> read_file

  Therapy Class   N (%)
  --------------- ------------
  ADC             30 (78.9%)
  Chemo           17 (44.7%)
  ICI             13 (34.2%)
  unspecified     4 (10.5%)
  Targeted        1 (2.6%)

  : Palliative Systemic Therapy Classes (ADC/ICI/Chemo/Targeted/Other).
  Note: patients can appear in multiple classes if they received
  combination regimens (e.g., ADC + ICI). Percentages are calculated
  based on total unique patients in the analysis universe (N = 38).
  {.table .table-striped .table-hover
  style="margin-left: auto; margin-right: auto;"}

::: {#research-question-2-defining-optimal-on-treatment-changes-in-ctdna-as-an-intermediate-endpoint .section .level2}
## Research Question 2: Defining Optimal On-Treatment Changes in ctDNA as an Intermediate Endpoint

**Research Question:** Defining optimal on-treatment changes in ctDNA as
an intermediate endpoint in metastatic UC

This analysis systematically evaluates different thresholds for
on-treatment ctDNA changes (e.g., percent decline, clearance, absolute
values) to identify which best predict clinical outcomes. The goal is to
validate ctDNA changes as intermediate endpoints that can serve as early
indicators of treatment response and clinical benefit in patients with
metastatic urothelial carcinoma.

**Approach:** 1. **Define multiple thresholds:** Test various
definitions of "optimal" ctDNA response (e.g., 30%, 50%, 70%, 90%, 100%
decline; absolute thresholds) 2. **Validate as intermediate endpoints:**
Assess association of each threshold with clinical outcomes (duration of
complete response, overall survival, time to next treatment) 3.
**Identify optimal threshold(s):** Determine which threshold(s) best
predict clinical benefit

The landmark analysis uses the latest ctDNA measurement available within
the 6-24 week window after therapy initiation to assess response status,
and analyzes clinical outcomes from that landmark time point forward.
**Note:** Only alive patients require imaging data for inclusion (to
determine complete response status, similar to RECIST CR). Patients who
died do NOT require imaging data (death is an event).

    ## Patient IDs Excluded Due to Missing Imaging Data

    **No patients excluded due to missing imaging data.**
    (All alive patients had imaging data available, or all excluded patients had died and did not require imaging data.)

    ## Addressing Immortal Time Bias

    **Immortal time bias** occurs when patients must survive to a certain time to be classified into a group, artificially inflating survival. **Landmark analysis addresses this** by: (1) determining clearance status at the landmark time point (ctDNA measurement date within 6-24 weeks), not requiring survival to a later time; (2) analyzing survival FROM the landmark forward (time 0 = landmark time, not therapy start); and (3) including only patients who survived to landmark, ensuring equal opportunity for classification.
:::

:::::::: {#defining-optimal-on-treatment-ctdna-changes-as-intermediate-endpoints .section .level1}
# Defining Optimal On-Treatment ctDNA Changes as Intermediate Endpoints

::: {#systematic-evaluation-of-ctdna-change-thresholds .section .level2}
## Systematic Evaluation of ctDNA Change Thresholds

This analysis tests multiple thresholds for on-treatment ctDNA changes
to identify which best predict clinical outcomes. **Lower HR values
indicate better outcomes** (longer survival, longer DCR, longer TTNT)
for patients meeting the threshold.

**Note on sample sizes:** The landmark analysis includes 30 patient-line
observations (24 unique patients). The threshold analysis below includes
30 patient-line observations with valid percent decline calculations.
Some thresholds may have smaller N due to additional filtering
requirements (e.g., requiring baseline ctDNA \> 0 for certain
thresholds).

**Understanding the table columns:** - **N (Total)**: Total number of
patient-line observations with valid data for evaluating that
threshold. - **N (Met Threshold)**: Number of patient-line observations
that met the threshold criteria (e.g., had ≥90% decline for the ≥90%
threshold). As thresholds become less strict (from 100% clearance to 30%
decline), more patients meet the criteria, so this number increases. For
example, 11 patients had complete clearance (100%), while 22 patients
had ≥30% decline. - For median-based thresholds (on-treatment ctDNA \<
median), N (Total) may be lower (e.g., 18 vs 30) because these require
baseline ctDNA \> 0 to calculate percent decline.

  Threshold                           Description                                            N (Total)   N (Met Threshold) DCR HR (95% CI)    DCR P-value   OS HR (95% CI)     OS P-value   TTNT HR (95% CI)   TTNT P-value
  ----------------------------------- ---------------------------------------------------- ----------- ------------------- ------------------ ------------- ------------------ ------------ ------------------ --------------
  Cleared (100% decline)              Complete clearance (100% decline or ctDNA = 0)                30                  11 0.25 (0.06-1.09)   0.065         N/A (log-rank)     0.02         0.07 (0.01-0.56)   0.012
  ≥90% decline                        ≥90% decline from baseline                                    30                  17 0.56 (0.22-1.45)   0.235         0.29 (0.07-1.14)   0.076        0.25 (0.08-0.75)   0.014
  ≥70% decline                        ≥70% decline from baseline                                    30                  19 0.76 (0.29-1.97)   0.574         0.57 (0.16-2.03)   0.389        0.4 (0.14-1.16)    0.092
  ≥50% decline                        ≥50% decline from baseline                                    30                  20 0.9 (0.34-2.38)    0.83          0.81 (0.22-2.95)   0.747        0.49 (0.17-1.43)   0.194
  ≥30% decline                        ≥30% decline from baseline                                    30                  22 1.41 (0.49-4.1)    0.525         0.76 (0.21-2.76)   0.672        0.34 (0.12-0.99)   0.048
  On-treatment ctDNA \< median        On-treatment ctDNA below median of positive values            18                   9 1.47 (0.54-4.01)   0.447         0.79 (0.22-2.84)   0.721        0.42 (0.14-1.23)   0.112
  Log(On-treatment ctDNA) \< median   Log-transformed on-treatment ctDNA below median               18                   9 1.47 (0.54-4.01)   0.447         0.79 (0.22-2.84)   0.721        0.42 (0.14-1.23)   0.112

  : Evaluation of Different ctDNA Change Thresholds as Intermediate
  Endpoints. N (Total) = total number of patient-line observations with
  valid data for that threshold. N (Met Threshold) = number of
  patient-line observations that met the threshold criteria (e.g., had
  ≥90% decline for the ≥90% threshold). As thresholds become less strict
  (from 100% to 30% decline), more patients meet the criteria, so N (Met
  Threshold) increases. For median-based thresholds, N (Total) may be
  lower (e.g., 18 vs 30) because these require baseline ctDNA \> 0. HR
  \< 1 indicates better outcomes (longer survival/DCR/TTNT) for patients
  meeting the threshold. Lower HR values suggest stronger predictive
  value. {.table .table-striped .table-hover
  style="font-size: 10px; margin-left: auto; margin-right: auto;"}
:::

::: {#optimal-threshold-identification .section .level2}
## Optimal Threshold Identification

**Criteria for optimal threshold:** 1. Statistically significant
association (p \< 0.05) with clinical outcomes 2. Strongest effect size
(lowest HR) across multiple outcomes 3. Clinically meaningful (e.g.,
complete clearance or substantial decline)

**Thresholds with statistically significant associations (p \< 0.05):**

- **Cleared (100% decline)**: Complete clearance (100% decline or ctDNA
  = 0)
  - OS: HR = N/A (log-rank), p = 0.02
  - TTNT: HR = 0.07 (0.01-0.56), p = 0.012
- **≥90% decline**: ≥90% decline from baseline
  - TTNT: HR = 0.25 (0.08-0.75), p = 0.014
- **≥30% decline**: ≥30% decline from baseline
  - TTNT: HR = 0.34 (0.12-0.99), p = 0.048

------------------------------------------------------------------------

\<｜tool▁calls▁begin｜\>\<｜tool▁call▁begin｜\> grep

This secondary analysis examines whether early ctDNA clearance (within
6-24 weeks after starting therapy) is associated with longer time to
next treatment. Time to next treatment is defined as the time from
therapy initiation until the start of the next line of therapy or death,
whichever occurs first.
:::

::::: {#tertiary-analysis-overall-survival .section .level2}
## Tertiary Analysis: Overall Survival

**What is the association between on-treatment ctDNA clearance at
landmark and overall survival?**

This tertiary analysis examines whether ctDNA clearance at the landmark
time point (6-24 weeks after therapy initiation) is associated with
overall survival. All therapy lines are included in this analysis, with
adjustment for line of therapy in the multivariate models. Overall
survival is defined as the time from the landmark time point (within
each therapy line) until death, with death as the event and alive
patients censored at last follow-up.


    **Summary:**
    Total unique patients in landmark analysis: 24 
    Patient-line observations in OS analysis:30 (24 unique patients)
    Pure urothelial carcinoma: 18 patients ( 75 %)
    Variant or mixed histology: 6 patients ( 25.1 %)

::: {#overall-survival-results .section .level3}
### Overall Survival Results

**Overall Survival Cox Model Results**

  Model                                                HR (95% CI)                P-value
  ---------------------------------------------------- -------------------------- ---------
  Unadjusted                                           N/A (perfect separation)   0.044
  Adjusted for line of therapy (stratified log-rank)   N/A (perfect separation)   0.01

  : Cox Model and Log-Rank Test Results: On-Treatment ctDNA Clearance
  and Overall Survival from Landmark. The unadjusted model shows the
  crude association, and the adjusted model accounts for line of
  therapy. P-values are adjusted for multiple comparisons using
  Bonferroni correction. When Cox models cannot estimate HRs due to
  perfect separation (0 events in cleared group), stratified log-rank
  tests are used. HR \< 1 indicates longer overall survival (lower risk
  of death) for patients with ctDNA cleared at landmark. {.table
  .table-striped .table-hover
  style="margin-left: auto; margin-right: auto;"}

**Statistical Note on Sample Size and Model Adjustments:**

The current analysis includes 30 patient-line observations (24 unique
patients) with 10 OS events (deaths). Given the limited number of
events, we only adjust for line of therapy in the adjusted model.
Additional adjustment for other variables (KPS, visceral metastases,
therapy class) is not performed due to insufficient events.

**Rationale for limited adjustment:**

1.  **Events per variable rule**: For Cox regression, a common guideline
    is to have 10-15 events per variable in the model. With 10 total
    events, reliable adjustment is limited to 0-1 variables. Adjusting
    for multiple variables (e.g., line of therapy + KPS + visceral
    metastases) would require at least 30-45 events, which exceeds the
    available 10 events.

2.  **Perfect separation**: The data show perfect separation (0 events
    in the ctDNA cleared group, 10 events in the non-cleared group),
    which makes Cox regression unstable. This is why some models show
    "N/A (perfect separation)" and stratified log-rank tests are used as
    fallbacks.

3.  **Model selection**: We present both unadjusted and adjusted (for
    line of therapy) models. The adjusted model accounts for potential
    confounding by therapy line, which is a key clinical factor. Further
    adjustment for KPS, visceral metastases, or other variables is not
    performed due to the small number of events, which would lead to
    overfitting and unreliable estimates.

**Interaction Test: Histology × ctDNA Clearance**

To test whether the association between ctDNA clearance and overall
survival differs by histology (UC vs variant/mixed), we attempted to
perform a likelihood ratio test comparing nested Cox models with and
without a histology × ctDNA clearance interaction term, adjusted for
line of therapy, therapy class, KPS, and visceral metastases.

**Interaction test p-value:** Cannot be performed (Cox models could not
be fitted due to perfect separation)

The interaction test could not be performed because the underlying Cox
models could not be fitted due to perfect separation (0 events in the
cleared group). When Cox models cannot estimate hazard ratios,
likelihood ratio tests comparing nested models are not valid. In this
case, stratified log-rank tests or descriptive comparisons by histology
group could be considered as alternative approaches.

**Overall Survival: Deaths by ctDNA Clearance Status**

  clearance_status            n_total   n_deaths   n_censored   Deaths (%)
  ------------------------- --------- ---------- ------------ ------------
  Cleared at Landmark              11          0           11          0.0
  Not Cleared at Landmark          19         10            9         52.6

  : Overall Survival: Deaths by ctDNA Clearance Status (N = 30
  patient-line observations, 24 unique patients) {.table .table-striped
  .table-hover
  style="width: auto !important; margin-left: auto; margin-right: auto;"}

**Diagnostic Performance of ctDNA Clearance for Predicting Overall
Survival:**

Using ctDNA clearance as a predictor of OS (cleared = predicts survival,
not cleared = predicts death):

  Metric                            Definition                                                   Value (%)
  --------------------------------- ------------------------------------------------------------ -----------
  Sensitivity                       Among patients who died, proportion with ctDNA not cleared   100%
  Specificity                       Among patients who survived, proportion with ctDNA cleared   55%
  Positive Predictive Value (PPV)   Among patients with ctDNA not cleared, proportion who died   52.6%
  Negative Predictive Value (NPV)   Among patients with ctDNA cleared, proportion who survived   100%

  : Diagnostic Performance Metrics: ctDNA Clearance as a Predictor of
  Overall Survival. Sensitivity = ability to identify patients who will
  die (among those who died, how many had ctDNA not cleared).
  Specificity = ability to identify patients who will survive (among
  those who survived, how many had ctDNA cleared). PPV = probability of
  death given ctDNA not cleared. NPV = probability of survival given
  ctDNA cleared. {.table .table-striped .table-hover
  style="width: auto !important; margin-left: auto; margin-right: auto;"}

![](./media/1628b9c28cacd1bd41095682fa959cced8179e42.png){role="img"
width="672"}
:::

::: {#overall-survival-interpretation .section .level3}
### Overall Survival Interpretation

    **Interpretation:**

    Overall Survival analysis: Results are shown in the table above. Both the unadjusted and adjusted models show perfect separation (0 deaths in the cleared group, 10 deaths in the non-cleared group), which prevents Cox regression from estimating hazard ratios. The unadjusted log-rank test shows a strong association between ctDNA clearance and overall survival (p=0.044, Bonferroni-adjusted), and the stratified log-rank test (adjusted for line of therapy) shows an even stronger association (p=0.01, Bonferroni-adjusted). These results indicate that patients who cleared ctDNA at the landmark time point (6-24 weeks after therapy initiation) had a substantially lower risk of death compared to those who did not clear ctDNA. Both models were fit using N = 30 patient-line observations (24 unique patients) with 10 OS events. The perfect separation (0 events in cleared group) makes Cox regression unstable, which is why log-rank tests are used. This pattern strongly suggests that ctDNA clearance is associated with improved overall survival outcomes.

    ## Summary

    **Universe - On-Treatment Cohort (Landmark Analysis):** Patients with metastatic disease starting a new line of therapy
      - Includes all lines of therapy (1L, 2L, 3L+, not limited to first-line)
      - Had on-treatment ctDNA measurement within 6-24 weeks after starting each new line
      - Landmark time = ctDNA measurement date within 6-24 week window
      - Time 0 for landmark analysis = landmark time (ctDNA measurement date)
      - **N = 30  patient-line observations

    **Key Findings:**

    **Key Findings - On-Treatment (Early Response):**
    - **Note:** Cox models did not converge or produced extreme HR values. Please see the multivariate Cox model table above for details.

    **Interpretation:**

    **Note:** Interpretation could not be completed because the Cox models did not converge or produced extreme HR values. Please check the diagnostic output above and the multivariate Cox model table for details.
:::
:::::
::::::::
:::::::::::
