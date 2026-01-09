## Research Question 1: **What is the association between circulating tumor DNA (ctDNA) level before starting a new line of therapy and OS?**

    ## Population Studied
    **Universe:** Patients with metastatic disease starting a new line of therapy
    **N = 48  patient-line observations ( 38  unique patients)
    
    **Inclusion Criteria:**
- Confirmed metastatic disease
- Starting a new line of palliative/metastatic therapy (includes 1L, 2L, 3L+, not limited to first-line)
- Had ctDNA level measured within 21 days before starting that line of therapy
- Time 0 = start of each new line of therapy
    

## **Overall Survival Endpoint Definition**

**Endpoint:** Overall Survival (OS)

**Definition:** Time from therapy initiation (time 0) until death.

**Event:** Death (coded as 1)

**Censoring:** Patients alive at last follow-up (coded as 0).

**Ascertainment:** Death dates from medical records; censoring based on last follow-up.

|
| Baseline ctDNA Tertile Values (T1-T3) for Overall Survival Analysis                                                  |
|----------------|
| **Tertile**    | **N**          | **Min ctDNA**  | **25th         | **Median       | **75th         | **Max ctDNA**  |
|                |                |                | Percentile**   | ctDNA**        | Percentile**   |                |
|===============::::::+
| T1 (Lowest)    | 17             | 0.00           | 0.00           | 1.33           | 2.57           | 2.77           |
|----------------|
| T2             | 16             | 4.63           | 9.27           | 15.02          | 36.66          | 64.05          |
|----------------|
| T3 (Highest)   | 16             | 74.76          | 89.34          | 189.58         | 399.24         | 5879.21        |
|----------------|

  --------------------------
  Therapy Class N Patients
                (%)
  ------------- ------------
  ADC           30 (78.9%)

  Chemo         17 (44.7%)

  ICI           13 (34.2%)

  unspecified   4 (10.5%)

  Targeted      1 (2.6%)
  --------------------------: Palliative Systemic Therapy Classes (ADC/ICI/Chemo/Targeted/Other)
  . Note: patients can appear in multiple classes if
  they received combination regimens (e.g., ADC + ICI). Percentages are
  calculated based on total unique patients in the analysis universe (N
  = 38).

  --------------------------------------------------------------------------------------------------------------------
  N (Patient-Line   N (Unique   1L   2L   3L   4L+ ctDNA Before   Days from       DCR Median DCR   1-year Median
    Observations)   Patients)                      Therapy        ctDNA to     Events   (months)    DCR % Follow-up
                                                   (median, IQR)  Therapy                                 (months)
                                                                  Start                                   
                                                                  (median, IQR)                                    
  --------------- ----------- ---- ---- ---- ----- -------------- ---------- -------- ---------- -------- ------------
               48          38   19   13    9     7 13.12          10 (0-18)        33        8.2     30.3 8.2
                                                   (2.47-83.64)                                           (3.5-14.4)

  --------------------------------------------------------------------------------------------------------------------: Descriptive Characteristics of Study Population

    **Summary:**
    Total unique patients in analysis: 38 
    Pure urothelial carcinoma: 29 patients ( 76.3 %)
    Variant or mixed histology: 9 patients ( 23.7 %)

  ---------------------------------------------------------------------------
  Model                                              HR (95% CI)    P-value
  -------------------------------------------------- -------------- ---------
  Unadjusted                                         2.55           \<0.001
                                                     (1.48-4.41)    

  Adjusted for line of therapy                       2.55           \<0.001
                                                     (1.51-4.3)     

  Adjusted for KPS                                   2.57           0.001
                                                     (1.46-4.53)    

  Adjusted for visceral metastases                   2.71           \<0.001
                                                     (1.5-4.88)     

  Adjusted for therapy class                         2.43           0.001
                                                     (1.41-4.2)     

  Adjusted for line of therapy, therapy class, KPS,  2.97           0.002
  and visceral metastases                            (1.51-5.84)    

  T2 vs T1 (Unadjusted)                              1.08           0.911
                                                     (0.27-4.36)    

  T3 vs T1 (Unadjusted)                              4.52           0.012
                                                     (1.39-14.73)   

  T2 vs T1 (Adjusted for line of therapy)            1.08           0.914
                                                     (0.25-4.69)    

  T3 vs T1 (Adjusted for line of therapy)            5.63           0.006
                                                     (1.64-19.3)    
  ---------------------------------------------------------------------------: Cox Proportional Hazards Model: ctDNA Level Before Therapy and
  Overall Survival. Top section shows continuous ctDNA (log10(ctDNA +
  1)) with HR progression as covariates are added. Bottom section shows
  tertile comparisons (T2 vs T1, T3 vs T1) with T1 (Lowest) as
  reference. HR \> 1 indicates shorter overall survival (higher risk of
  death) compared to reference.

## Comparison: Quantitative vs Qualitative ctDNA Models for Overall Survival

Comparison of quantitative vs qualitative ctDNA models for OS.

    **Among ctDNA > 0 (Positive):** median = 29.94, IQR = [ 2.77,  89.34 ]

  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Model Type   Quantitative   Quantitative     Quantitative   Quantitative Qualitative HR Qualitative     Qualitative   Qualitative          AIC          BIC Better Model   Better Model   P-value
               HR (95% CI)    P-value                   AIC            BIC (95% CI)       P-value                 AIC           BIC   Difference   Difference (AIC)          (BIC)          (Quantitative
                                                                                                                                        (Quant -     (Quant -                               Better)
                                                                                                                                           Qual)        Qual)                               
  ------------ -------------- -------------- -------------- -------------- -------------- ------------- ------------- ------------- ------------ ------------ -------------- -------------- ---------------
  Unadjusted   2.55           \<0.001                 105.7          106.6 2.42           0.391                 116.4         117.3        -10.7        -10.7 Quantitative   Quantitative   \<0.001
               (1.48-4.41)                                                 (0.32-18.24)                                                                                                     

  Adjusted for 2.55           \<0.001                 108.5          112.0 2.71           0.335                 119.5         123.1        -11.0        -11.1 Quantitative   Quantitative   \<0.001
  line of      (1.51-4.3)                                                  (0.36-20.48)                                                                                                     
  therapy                                                                                                                                                                                   

  Adjusted for 2.97           0.002                   113.7          121.7 1.9            0.593                 123.6         131.6         -9.9         -9.9 Quantitative   Quantitative   0.002
  line of      (1.51-5.84)                                                 (0.18-20.02)                                                                                                     
  therapy,                                                                                                                                                                                  
  therapy                                                                                                                                                                                   
  class, KPS,                                                                                                                                                                               
  and visceral                                                                                                                                                                              
  metastases                                                                                                                                                                                
  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: Comparison: Quantitative vs Qualitative Models for Overall Survival. P-value (Quantitative Better) from likelihood ratio test - p \< 0.05
  indicates quantitative model performs significantly better than
  qualitative model.

|
| |
| Censoring Rate Analysis by Baseline ctDNA Tertile                                                  |
|-------------------|
| **ctDNA Tertile** | **N**             | **Events**        | **Censored**      | **Censoring Rate** |
|==================:::|
| T1 (Lowest)       | 17                | 4                 | 13                | 76.5%              |
|-------------------|
| T2                | 16                | 4                 | 12                | 75%                |
|-------------------|
| T3 (Highest)      | 16                | 10                | 6                 | 37.5%              |
|-------------------|

|
| Sensitivity Analysis: Treating Censored Observations as Events (Worst-Case          |
| Scenario)                                                                           |
|-------------------+
| **Analysis**            | **HR (95% CI)**   | **P-value**       | **N Events**      |
|==================:+
| Standard (Censored)     | 2.55 (1.51-4.3)   | \<0.001           | 18                |
|-------------------+
| Sensitivity (All        | 1.57 (1.11-2.23)  | 0.011             | 49                |
| Events)                 |                   |                   |                   |
|-------------------+

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

![](media/image1.png){width="5.833333333333333in"
height="4.166666666666667in"}

![](media/image2.png){width="5.833333333333333in"
height="4.166666666666667in"}

    ## Overall Survival Interpretation
    **Interpretation:**
    Higher baseline ctDNA levels before starting a new line of therapy are significantly associated with shorter overall survival (HR = 2.97, 95% CI: 1.51-5.84), adjusted for line of therapy, therapy class, KPS, and visceral metastases. This finding suggests that baseline ctDNA level may serve as a prognostic biomarker for overall survival outcomes. Diagnostic: Dataset sizes
      outcomes (before joins): 48 rows
      outcomes_for_model (after joins): 48 rows

  ---------------------------------------------------------------------------
  Model                                              HR (95% CI)    P-value
  -------------------------------------------------- -------------- ---------
  Unadjusted                                         2.28           \<0.001
                                                     (1.51-3.45)    

  Adjusted for line of therapy                       2.27           \<0.001
                                                     (1.48-3.49)    

  Adjusted for KPS                                   2.27           \<0.001
                                                     (1.5-3.46)     

  Adjusted for visceral metastases                   2.43           \<0.001
                                                     (1.54-3.82)    

  Adjusted for line of therapy and therapy class     2.81           \<0.001
                                                     (1.78-4.44)    

  Adjusted for line of therapy, therapy class, KPS,  3.27           \<0.001
  and visceral metastases                            (1.91-5.59)    

  T2 vs T1 (Unadjusted)                              2.05           0.15
                                                     (0.77-5.43)    

  T3 vs T1 (Unadjusted)                              5.45 (2-14.87) \<0.001

  T2 vs T1 (Adjusted for line of therapy)            2.01           0.196
                                                     (0.7-5.79)     

  T3 vs T1 (Adjusted for line of therapy)            5.18           0.003
                                                     (1.78-15.09)   
  ---------------------------------------------------------------------------: Cox Proportional Hazards Model: ctDNA Level Before Therapy and
  Duration of Complete Response. Top section shows continuous ctDNA
  (Ln(ctDNA + 1)) with HR progression as covariates are added. Bottom
  section shows tertile comparisons (T2 vs T1, T3 vs T1) with T1
  (Lowest) as reference. HR \> 1 indicates shorter duration of complete
  response (higher risk of loss of CR or death) compared to reference.

  ------------------------------
  Category             N \%
  ----------------- ---- -------
  Total               48 100.0
  observations           

  ctDNA = 0            5 10.4%
  (Negative)             

  ctDNA \> 0          43 89.6%
  (Positive)             
  ------------------------------: Distribution of Baseline ctDNA Values (Qualitative Threshold
  Analysis)

    **Among ctDNA > 0 (Positive):** median = 22.56, IQR = [ 2.77,  125.27 ]

    **Key Finding:**
    The likelihood ratio test comparing qualitative (binary-only) vs quantitative (binary+continuous) models shows: **Quantitative model significantly better (continuous adds info beyond binary)** (p = <0.001). This provides formal statistical evidence that the quantitative model performs significantly better than the qualitative model.

    ## Updated Comparison Table with Statistical Test P-values

  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Model Type   Quantitative   Quantitative     Quantitative   Quantitative Qualitative HR Qualitative     Qualitative   Qualitative          AIC          BIC Better Model   Better Model   P-value
               HR (95% CI)    P-value                   AIC            BIC (95% CI)       P-value                 AIC           BIC   Difference   Difference (AIC)          (BIC)          (Quantitative
                                                                                                                                        (Quant -     (Quant -                               Better)
                                                                                                                                           Qual)        Qual)                               
  ------------ -------------- -------------- -------------- -------------- -------------- ------------- ------------- ------------- ------------ ------------ -------------- -------------- ---------------
  Unadjusted   2.28           \<0.001                 181.5          183.0 3.06           0.132                 193.8         195.3        -12.3        -12.3 Quantitative   Quantitative   \<0.001
               (1.51-3.45)                                                 (0.71-13.09)                                                                                                     

  Adjusted for 2.27           \<0.001                 186.7          192.7 2.69           0.186                 198.1         204.1        -11.4        -11.4 Quantitative   Quantitative   \<0.001
  line of      (1.48-3.49)                                                 (0.62-11.66)                                                                                                     
  therapy                                                                                                                                                                                   

  Adjusted for 3.27           \<0.001                 186.9          200.4 4.17           0.098                 202.2         215.6        -15.3        -15.2 Quantitative   Quantitative   \<0.001
  line of      (1.91-5.59)                                                 (0.77-22.64)                                                                                                     
  therapy,                                                                                                                                                                                  
  therapy                                                                                                                                                                                   
  class, KPS,                                                                                                                                                                               
  and visceral                                                                                                                                                                              
  metastases                                                                                                                                                                                
  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: Comparison: Quantitative vs Qualitative Models with Statistical Test
  Results. P-value (Quantitative Better) from likelihood ratio test - p
  \< 0.05 indicates quantitative model performs significantly better
  than qualitative model.

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

## Research Question 2: Defining Optimal On-Treatment Changes in ctDNA as an Intermediate Endpoint in Metastatic UC

#### 2026-01-04

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
     because the Cox models did not converge or produced extreme HR values.
