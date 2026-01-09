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

    **N:** 48 patient-line observations (38 unique patients)

    **Note:** Final analysis N (after excluding observations due to missing survival data) is shown in the exclusion and descriptive tables below.

    **Inclusion Criteria:**

- Confirmed metastatic disease

- Starting a new line of palliative/metastatic therapy (includes 1L, 2L,
  3L+, not limited to first-line)

- Had ctDNA level measured within 21 days before starting that line of
  therapy

- Time 0 = start of each new line of therapy

  **Note:** Each patient can contribute multiple observations (one per
  line of therapy). Line of therapy is included as a covariate in the
  analysis.

    Therapy Class   N Patients (%)
    --------------- ----------------
    ADC             30 (78.9%)
    Chemo           17 (44.7%)
    ICI             13 (34.2%)
    unspecified     4 (10.5%)
    Targeted        1 (2.6%)

    : Palliative Systemic Therapy Classes (ADC/ICI/Chemo/Targeted/Other)
    (baseline universe). Note: patients can appear in multiple classes
    if they received combination regimens (e.g., ADC + ICI). Percentages
    are calculated based on total unique patients in the analysis
    universe (N = 38). {.table .table-striped .table-hover
    style="margin-left: auto; margin-right: auto;"}

  No observations excluded - all 48 patient-line observations had valid
  survival data.

  \## Patient IDs Excluded Due to Missing Imaging Data

  **No patients excluded due to missing imaging data.** (All alive
  patients had imaging data available, or all excluded patients had died
  and did not require imaging data.)

      N (Patient-Line Observations)   N (Unique Patients)   1L   2L   3L   4L+ ctDNA Before Therapy (median, IQR)   Days from ctDNA to Therapy Start (median, IQR)     DCR Events   Median DCR (months)   1-year DCR % Median Follow-up (months)
    ------------------------------- --------------------- ---- ---- ---- ----- ------------------------------------ ------------------------------------------------ ------------ --------------------- -------------- ---------------------------
                                 48                    38   19   13    9     7 13.12 (2.47-83.64)                   10 (0-18)                                                  33                   8.2           30.3 8.2 (3.5-14.4)

    : Descriptive Characteristics of Study Population {.table
    .table-striped .table-hover
    style="margin-left: auto; margin-right: auto;"}

  **Summary:** Total unique patients in analysis: 38 Pure urothelial
  carcinoma: 29 patients ( 76.3 %) Variant or mixed histology: 9
  patients ( 23.7 %)

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
    progressive disease). DCR Censored = Alive without obvious disease
    on imaging (maintaining complete response, similar to RECIST CR).
    Only alive patients with missing imaging data are excluded (imaging
    data is required for alive patients only; patients who died do not
    require imaging data). {.table .table-striped .table-hover
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

  **Test for interaction (histology × ctDNA):** P-value for interaction
  (adjusted model): 0.353 → No significant interaction: The association
  between ctDNA and OS does not significantly differ between histology
  groups (p = 0.353 )

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

- Positive log-likelihood difference (Quant - Qual) favors quantitative
  model

  \## Model Comparison Summary

  **AIC/BIC Interpretation:**

- Lower AIC/BIC indicates better model fit (penalizes complexity)

- Differences \> 2 are considered meaningful

- Negative differences (Quant - Qual) favor quantitative model

- Positive differences favor qualitative model

  **Unadjusted:** AIC difference: -12.3 BIC difference: -12.3
  Quantitative model p-value: \<0.001 Qualitative model p-value: 0.132 →
  Quantitative model has better fit (AIC difference: -12.3 )

  **Adjusted for line of therapy:** AIC difference: -11.4 BIC
  difference: -11.4 Quantitative model p-value: \<0.001 Qualitative
  model p-value: 0.186 → Quantitative model has better fit (AIC
  difference: -11.4 )

  **Adjusted for line of therapy, therapy class, KPS, and visceral
  metastases:** AIC difference: -15.3 BIC difference: -15.2 Quantitative
  model p-value: \<0.001 Qualitative model p-value: 0.098 → Quantitative
  model has better fit (AIC difference: -15.3 )

  **Conclusion:**

  The quantitative (continuous) ctDNA model provides better fit than the
  qualitative (binary) model (AIC difference: -15.3 ), suggesting that
  ctDNA level contains more prognostic information than a simple
  positive/negative threshold. The formal likelihood ratio test confirms
  that continuous ctDNA adds significant prognostic information beyond
  the binary threshold (p = \<0.001). Additionally, the quantitative
  model achieves statistical significance (p\<0.001) while the
  qualitative model does not (p = 0.098), providing further evidence
  that the continuous ctDNA value captures more prognostic information
  than the binary threshold.

  **N for multivariate model:** 48 observations **Note:** This model
  includes Bajorin risk factors (KPS and visceral metastases) in
  addition to ctDNA level and line of therapy.

  **Tertile Cutoffs Summary:**

- **T1 (Lowest):** ctDNA ≤ 2.77

- **T2:** ctDNA from 2.77 to 59.73

- **T3 (Highest):** ctDNA ≥ 64.05

  **Note:** Tertiles are created by dividing the ctDNA values into three
  equal groups based on rank (ntile function). T1 (Lowest) contains the
  lowest third of ctDNA values, T2 contains the middle third, and T3
  (Highest) contains the highest third.

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

- Hazard Ratio per log10-unit increase in ctDNA (adjusted for line of
  therapy, KPS, and visceral metastases): 3.27 (95% CI: 1.91 - 5.59 )

- P-value: \<0.001

  **Interpretation:**

  Higher ctDNA levels before starting a new line of therapy are
  significantly associated with worse duration of complete response (HR
  = 3.27, 95% CI: 1.91-5.59), adjusted for line of therapy, KPS, and
  visceral metastases. This finding suggests that ctDNA level before
  therapy initiation may serve as a prognostic biomarker for duration of
  complete response outcomes across multiple lines of therapy in
  patients with metastatic urothelial carcinoma.
:::

:::: {.container-fluid .main-container}
::: {#header}
# Research Question 2: Defining Optimal On-Treatment Changes in ctDNA as an Intermediate Endpoint in Metastatic UC {#research-question-2-defining-optimal-on-treatment-changes-in-ctdna-as-an-intermediate-endpoint-in-metastatic-uc .title .toc-ignore}
:::
::::
