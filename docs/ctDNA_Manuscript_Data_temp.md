# ctDNA as a Prognostic and Intermediate Endpoint in Metastatic Urothelial Carcinoma

## Research Question 1: Association Between Quantitative Baseline ctDNA and Overall Survival

We retrospectively analyzed patients with metastatic bladder cancer (UC,
variant, or mixed histology) treated at our institution who had baseline
ctDNA measured within 21 days prior to initiating a systemic therapy
line. The primary endpoint was OS. Alive patients censored at last
follow-up . Cox proportional hazards models were used to estimate hazard
ratios (HRs) with 95% confidence intervals (CIs), evaluating baseline
ctDNA as either a quantitative continuous variable (log10-transformed)
or a qualitative binary variable (detectable vs undetectable).
Multivariable models were adjusted for line of therapy, therapy class,
Karnofsky Performance Status (KPS) \<80%, and presence of visceral
metastases. Effect modification by histology was evaluated by including
an interaction term within multivariable Cox models. Performance of the
models was compared using Akaike Information Criterion (AIC), with
likelihood ratio testing used to assess incremental prognostic value of
quantitative over qualitative ctDNA.

**Results**

Descriptive Characteristics of Study Population

+---------------+-----------+----+----+----+-----+--------------+----------+----------------+
| N             | N (Unique | 1L | 2L | 3L | 4L+ | ctDNA Before | Days     | Median         |
| (Patient-Line | Patients) |    |    |    |     | Therapy      | from     | Follow-up      |
| Observations) |           |    |    |    |     | (median,     | ctDNA to | (months)       |
|               |           |    |    |    |     | IQR)         | Therapy  |                |
|               |           |    |    |    |     |              | Start    |                |
|               |           |    |    |    |     |              | (median, |                |
|               |           |    |    |    |     |              | IQR)     |                |
+==============:+==========:+===:+===:+===:+====:+==============+==========+================+
| 48            | 38        | 19 | 13 | 9  | 7   | 13.12        | 10       | 2.  (3.5-14.4) |
|               |           |    |    |    |     | (2.47-83.64) | (0-18)   |                |
+---------------+-----------+----+----+----+-----+--------------+----------+----------------+

: Descriptive Characteristics of Study Population

Pure urothelial carcinoma: 29 patients ( 76.3 %) Variant or mixed
histology: 9 patients (23.7 %)

Palliative Systemic Therapy Classes: patients can appear in multiple
classes if they received combination regimens (e.g., ADC + ICI).
Percentages are calculated based on total unique patients in the
analysis universe (N = 38).

  ---------------------------
  Therapy Class N Patients
                (%)
  ------------- -------------
  ADC           30 (78.9%)

  Chemo         17 (44.7%)

  ICI           13 (34.2%)

  unspecified   4 (10.5%)

  Targeted      1 (2.6%)
  ---------------------------

  : Palliative Systemic Therapy Classes (ADC/ICI/Chemo/Targeted/Other)
  (baseline universe). Note: patients can appear in multiple classes if
  they received combination regimens (e.g., ADC + ICI). Percentages are
  calculated based on total unique patients in the analysis universe (N
  = 38).

  ----------------------------------------------------------------
  Model                            HR (95% CI)          P-value
  -------------------------------- -------------------- ----------
  Unadjusted                       2.55 (1.48-4.41)     \<0.001

  Adjusted for line of therapy     2.55 (1.51-4.3)      \<0.001

  Adjusted for KPS                 2.57 (1.46-4.53)     0.001

  Adjusted for visceral metastases 2.71 (1.5-4.88)      \<0.001

  Adjusted for therapy class       2.43 (1.41-4.2)      0.001

  Adjusted for line of therapy,    2.97 (1.51-5.84)     0.002
  therapy class, KPS, and visceral                      
  metastases                                            

  T2 vs T1 (Unadjusted)            1.08 (0.27-4.36)     0.911

  T3 vs T1 (Unadjusted)            4.52 (1.39-14.73)    0.012

  T2 vs T1 (Adjusted for line of   1.08 (0.25-4.69)     0.914
  therapy)                                              

  T3 vs T1 (Adjusted for line of   5.63 (1.64-19.3)     0.006
  therapy)                                              
  ----------------------------------------------------------------

  : Cox Proportional Hazards Model: ctDNA Level Before Therapy and
  Overall Survival. Top section shows continuous ctDNA (log10(ctDNA +
  1)) with HR progression as covariates are added. Bottom section shows
  tertile comparisons (T2 vs T1, T3 vs T1) with T1 (Lowest) as
  reference. HR \> 1 indicates shorter overall survival (higher risk of
  death) compared to reference.

**Tertile Cutoffs Summary:**

> **T1 (Lowest):** ctDNA ≤ 2.77
>
> **T2:** ctDNA from 2.77 to 59.73
>
> **T3 (Highest):** ctDNA ≥ 64.05

- **Note:** Tertiles are created by dividing the ctDNA values into three
  equal groups based on rank (ntile function). T1 (Lowest) contains the
  lowest third of ctDNA values, T2 contains the middle third, and T3
  (Highest) contains the highest third.

+--------------------------------------------------------------------------------------------------------------+
| - Censoring Rate Analysis by Baseline ctDNA Tertile                                                          |
+===================+===================+===================+===================+==============================+
| **ctDNA Tertile** | **N**             | **Events**        | **Censored**      | **Censoring Rate**           |
+-------------------+-------------------+-------------------+-------------------+------------------------------+
| T1 (Lowest)       | 16                | 6                 | 10                | 62.5%                        |
+-------------------+-------------------+-------------------+-------------------+------------------------------+
| T2                | 16                | 13                | 3                 | 18.8%                        |
+-------------------+-------------------+-------------------+-------------------+------------------------------+
| T3 (Highest)      | 16                | 10                | 6                 | 37.5%                        |
+-------------------+-------------------+-------------------+-------------------+------------------------------+

Note: Chi-Square P-value=0.004 for differences in censoring rates
between groups

Sensitivity Analysis: Treating Censored Observations as Events
(Worst-Case Scenario)

  --------------------------------------------------------------------
  **Analysis**                     **HR (95% CI)**      **P-value**
  -------------------------------- -------------------- --------------
  Standard (Censored)              2.55 (1.51-4.3)      \<0.001

  Sensitivity (All Events)         1.57 (1.11-2.23)     0.011
  --------------------------------------------------------------------

![A graph of survival of a patient AI-generated content may be
incorrect.](media/image1.png){width="5.833333333333333in"
height="4.166666666666667in"}

![A graph with a line and a line AI-generated content may be
incorrect.](media/image2.png){width="5.833333333333333in"
height="4.166666666666667in"}

**Test for interaction (histology × ctDNA):** P-value for interaction
(adjusted model): 0.353 → No significant interaction: The association
between ctDNA and OS does not significantly differ between histology
groups (p = 0.353)

- 

  ------------------------------------------------------------------------------------------------------------------------------------------------
  Model Type   Quantitative   Quantitative     Quantitative Qualitative HR Qualitative     Qualitative          AIC Better Model   P-value
               HR (95% CI)    P-value                   AIC (95% CI)       P-value                 AIC   Difference (AIC)          (Quantitative
                                                                                                           (Quant -                Better)
                                                                                                              Qual)                
  ------------ -------------- -------------- -------------- -------------- ------------- ------------- ------------ -------------- ---------------
  Unadjusted   2.55           \<0.001                 105.7 2.42           0.391                 116.4        -10.7 Quantitative   \<0.001
               (1.48-4.41)                                  (0.32-18.24)                                                           

  Adjusted for 2.55           \<0.001                 108.5 2.71           0.335                 119.5        -11.0 Quantitative   \<0.001
  line of      (1.51-4.3)                                   (0.36-20.48)                                                           
  therapy                                                                                                                          

  Adjusted for 2.97           0.002                   113.7 1.9            0.593                 123.6         -9.9 Quantitative   0.002
  line of      (1.51-5.84)                                  (0.18-20.02)                                                           
  therapy,                                                                                                                         
  therapy                                                                                                                          
  class, KPS,                                                                                                                      
  and visceral                                                                                                                     
  metastases                                                                                                                       
  ------------------------------------------------------------------------------------------------------------------------------------------------

  : Comparison: Quantitative vs Qualitative Models for Overall
  Survival..

**Research Question 2:** On-Treatment ctDNA Changes as an Intermediate
Endpoint

We conducted a retrospective analysis of all patients at our institution
with metastatic bladder cancer (UC, variant, or mixed histology)
receiving any palliative systemic therapy, who had baseline ctDNA
measured ≤21 days before and on-treatment ctDNA assessed 6-24 weeks
after therapy initiation. The most recent on-treatment ctDNA measurement
within this window defined the landmark time (LT). Multiple ctDNA
response definitions were evaluated, including complete clearance (100%
decline), ≥90%, ≥70%, ≥50%, and ≥30% declines, as well as absolute
on-treatment ctDNA thresholds. OS was analyzed from the LT using Cox
proportional hazards models or stratified log-rank tests when Cox models
could not be estimated due to perfect separation. Models were adjusted
for line of therapy when feasible.

Descriptive analysis

Landmark Cohort

- 30 patient-line observations

- 24 unique patients

- Pure UC: 18 (75%)

- Variant/mixed: 6 (25%)

  -------------------------------------------------------------------------------------
  Threshold          Description         N (Total)       N (Met OS HR (95%    OS
                                                     Threshold) CI)           P-value
  ------------------ ------------------- --------- ------------ ------------- ---------
  Cleared (100%      Complete clearance         30           11 N/A           0.02
  decline)           (100% decline or                           (log-rank)    
                     ctDNA = 0)                                               

  ≥90% decline       ≥90% decline from          30           17 0.29          0.076
                     baseline                                   (0.07-1.14)   

  ≥70% decline       ≥70% decline from          30           19 0.57          0.389
                     baseline                                   (0.16-2.03)   

  ≥50% decline       ≥50% decline from          30           20 0.81          0.747
                     baseline                                   (0.22-2.95)   

  ≥30% decline       ≥30% decline from          30           22 0.76          0.672
                     baseline                                   (0.21-2.76)   

  On-treatment ctDNA On-treatment ctDNA         18            9 0.79          0.721
  \< median          below median of                            (0.22-2.84)   
                     positive values                                          

  Log(On-treatment   Log-transformed            18            9 0.79          0.721
  ctDNA) \< median   on-treatment ctDNA                         (0.22-2.84)   
                     below median                                             
  -------------------------------------------------------------------------------------

  : Evaluation of Different ctDNA Change Thresholds as Intermediate
  Endpoints. N (Total) = total number of patient-line observations with
  valid data for that threshold. N (Met Threshold) = number of
  patient-line observations that met the threshold criteria (e.g., had
  ≥90% decline for the ≥90% threshold). For median-based thresholds, N
  (Total) may be lower (e.g., 18 vs 30) because these require baseline
  ctDNA \> 0. HR \< 1 indicates better outcomes (longer survival) for
  patients meeting the threshold. Lower HR values suggest stronger
  predictive value.

  ------------------------------------------------------------------
  clearance_status        n_total   n_deaths   n_censored Deaths (%)
  --------------------- --------- ---------- ------------ ----------
  Cleared at Landmark          11          0           11        0.0

  Not Cleared at               19         10            9       52.6
  Landmark                                                
  ------------------------------------------------------------------

  : Overall Survival: Deaths by ctDNA Clearance Status (N = 30
  patient-line observations, 24 unique patients)

  -----------------------------------------------------------------------
  Model                                   HR (95% CI)           P-value
  --------------------------------------- --------------------- ---------
  Unadjusted                              N/A (perfect          0.044
                                          separation)           

  Adjusted for line of therapy            N/A (perfect          0.01
  (stratified log-rank)                   separation)           
  -----------------------------------------------------------------------

  : Cox Model and Log-Rank Test Results: On-Treatment ctDNA Clearance
  and Overall Survival from Landmark. The unadjusted model shows the
  crude association, and the adjusted model accounts for line of
  therapy. P-values are adjusted for multiple comparisons using
  Bonferroni correction. When Cox models cannot estimate HRs due to
  perfect separation (0 events in cleared group), stratified log-rank
  tests are used

![A graph of a number of patients AI-generated content may be
incorrect.](media/image3.png){width="5.833333333333333in"
height="4.166666666666667in"}

## Key Results

- Baseline quantitative ctDNA was strongly associated with OS. Each
  log10 increase in baseline ctDNA prior to initiating a new therapy
  line was associated with a nearly threefold higher risk of death in
  fully adjusted models (HR 2.97, 95% CI 1.51--5.84; p=0.002).

- The association between baseline ctDNA and OS was consistent across
  therapy lines, treatment classes, and histologic subtypes, with no
  evidence of effect modification by histology (interaction p=0.353).

- Quantitative ctDNA modeling outperformed qualitative (detectable vs
  undetectable) approaches, demonstrating superior model fit (lower AIC)
  and significant incremental prognostic value by likelihood ratio
  testing across unadjusted and adjusted models (all p\<0.01).

- On-treatment ctDNA clearance (100% decline) at 6--24 weeks identified
  a subgroup with exceptionally favorable outcomes, with no deaths
  observed among patients who cleared ctDNA at the landmark time point,
  compared with a 52.6% mortality rate among those who did not.

- Complete ctDNA clearance outperformed partial decline thresholds
  (≥90%, ≥70%, ≥50%, ≥30%) in predicting overall survival, whereas
  lesser declines showed weaker and non-significant associations.

## Key Conclusions

- Baseline ctDNA functions as a robust, independent prognostic biomarker
  for overall survival in metastatic urothelial carcinoma when modeled
  as a continuous variable.

- Binary ctDNA thresholds discard clinically meaningful prognostic
  information, whereas quantitative modeling preserves risk
  stratification across a broad dynamic range.

- Early on-treatment ctDNA clearance represents a strong candidate
  intermediate endpoint, demonstrating near-perfect discrimination for
  overall survival and supporting its use in response-adaptive trial
  designs.

- Together, these findings support ctDNA-guided risk stratification and
  early response assessment as biologically and clinically meaningful
  biomarkers in metastatic bladder cancer cancer to be prospectively
  validated.

## Key Limitations

- Single-center, retrospective design with a modest sample size limits
  generalizability and precludes definitive threshold calibration.

- Limited number of patient events in the landmark cohort restricted
  multivariable adjustment

- Heterogeneity of treatment regimens and lines of therapy may introduce
  residual confounding despite multivariable adjustment.

- ctDNA assays and timing were derived from routine clinical practice
  rather than a protocolized prospective schedule.

## Next Steps / Future Directions

- Prospective multicenter validation of ctDNA as a quantitative
  prognostic biomarker and surrogate endpoint in metastatic bladder
  cancer

  - Including correlation with radiographic response and
    patient-reported outcomes.

- Exploration of disease-specific and treatment-specific ctDNA
  thresholds, rather than universal cutoffs, to enhance clinical
  applicability.
