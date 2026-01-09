# Guide: Testing for Non-Informative Censoring

## What is Non-Informative Censoring?

**Non-informative censoring** means that the reason a patient is censored (e.g., end of follow-up, loss to follow-up) is **unrelated to their risk of the event** (death, progression, etc.).

### Key Assumption

In standard survival analysis (Cox models, Kaplan-Meier), we assume:
- Patients who are censored have the same risk of the event as patients who are not censored
- This must hold **conditional on observed covariates** (e.g., ctDNA status, age, stage)

### Why This Matters

If censoring is **informative** (related to outcome risk):
- Results may be **biased**
- Survival estimates may be **inflated or deflated**
- Hazard ratios may be **incorrect**

## Common Scenarios of Informative Censoring

1. **Differential loss to follow-up**: Patients with worse prognosis are more likely to be lost to follow-up
2. **Early censoring in one group**: One group has more early censoring, suggesting better prognosis (but may be due to other factors)
3. **Administrative censoring related to prognosis**: Patients with better outcomes are more likely to reach end of study

## How to Test for Informative Censoring

### Test 1: Compare Censoring Rates Across Groups

**Question**: Do different ctDNA groups have different proportions of censored patients?

**Test**: Chi-square test of independence
- Null hypothesis: Censoring is independent of group
- If p < 0.05: Censoring may be informative

**Interpretation**:
- Similar censoring rates across groups → Non-informative censoring likely
- Different censoring rates → Potential informative censoring

### Test 2: Compare Censoring Times

**Question**: Do censored patients in different groups have different censoring times?

**Tests**:
- Kruskal-Wallis test (non-parametric)
- Log-rank test on censoring time distribution

**Interpretation**:
- Similar censoring times → Non-informative censoring likely
- Different censoring times → May indicate informative censoring

### Test 3: Compare Baseline Characteristics

**Question**: Do censored patients differ from event patients in baseline characteristics?

**Tests**:
- t-test or Wilcoxon test for continuous variables (age, baseline ctDNA)
- Chi-square test for categorical variables (stage, histology)

**Interpretation**:
- Similar baseline characteristics → Non-informative censoring likely
- Different baseline characteristics → Suggests informative censoring

## Example: What to Look For

### Scenario 1: Non-Informative Censoring ✅

```
Group              N    Events   Censored   Censoring Rate
Persistent Neg    50    20       30         60%
Persistent Pos    48    25       23         48%
ctDNA Clearance   45    22       23         51%
```

- Censoring rates are similar (48-60%)
- Chi-square p = 0.45 (not significant)
- **Conclusion**: Non-informative censoring likely

### Scenario 2: Informative Censoring ⚠️

```
Group              N    Events   Censored   Censoring Rate
Persistent Neg    50    5        45         90%
Persistent Pos    48    35       13         27%
ctDNA Clearance   45    30       15         33%
```

- Censoring rates are very different (27% vs 90%)
- Chi-square p < 0.001 (highly significant)
- **Conclusion**: Informative censoring likely - "Persistent Negative" group has much higher censoring

**Why this is problematic**:
- Patients in "Persistent Negative" group who would have died may have been censored
- This artificially inflates survival in this group
- Results are biased

## What to Do If Censoring is Informative

### Option 1: Competing Risks Analysis

Model censoring as a competing risk:
- Use Fine-Gray subdistribution hazards model
- Accounts for competing risks explicitly

### Option 2: Sensitivity Analysis

- Exclude patients censored early (e.g., < 6 months)
- Re-run analysis and compare results
- If results are similar, censoring may not be a major issue

### Option 3: Stratified Analysis

- Stratify by factors related to censoring (e.g., follow-up duration, study site)
- Account for these factors in the model

### Option 4: Acknowledge Limitation

- Clearly state in manuscript that censoring may be informative
- Discuss potential impact on results
- Present both unadjusted and adjusted analyses

## Implementation in R

See `ctDNA_TimeDependent_Analysis.R` - Solution 5 for complete implementation:

```r
# Test censoring patterns
censoring_results <- test_censoring_patterns(
  survival_data,
  "qualitative_group",
  "os_time",
  "death_event"
)

# View results
print(censoring_results$censoring_rates)
print(censoring_results$chi_square_test)

# Visualize
plot_censoring_patterns(censoring_results, "qualitative_group")
```

## Reporting in Manuscript

### Methods Section

> "We tested the assumption of non-informative censoring by comparing censoring rates and censoring times across ctDNA groups using chi-square tests and log-rank tests. Baseline characteristics were compared between censored and event patients using t-tests and chi-square tests."

### Results Section

> "Censoring rates were similar across ctDNA groups (range: 45-55%, p = 0.32), and censoring times did not differ significantly (log-rank p = 0.18). Baseline characteristics were similar between censored and event patients (all p > 0.05), supporting the assumption of non-informative censoring."

### If Censoring is Informative

> "Censoring rates differed significantly across groups (p < 0.001), with the 'Persistent Negative' group having higher censoring (85% vs 30-40% in other groups). This may indicate informative censoring, where patients with better prognosis are more likely to be censored. We performed sensitivity analyses excluding patients censored within 6 months, which yielded similar results (data not shown)."

## Key Takeaways

1. **Always test** for non-informative censoring
2. **Compare censoring rates** across groups
3. **Compare censoring times** across groups
4. **Compare baseline characteristics** between censored and event patients
5. **If informative**: Consider competing risks, sensitivity analyses, or acknowledge limitation
6. **Report results** in manuscript methods and results sections

## References

- Klein JP, Moeschberger ML. (2003). *Survival Analysis: Techniques for Censored and Truncated Data*. Springer.
- Leung KM, Elashoff RM, Afifi AA. (1997). Censoring issues in survival analysis. *Annual Review of Public Health*, 18, 83-104.
- Fine JP, Gray RJ. (1999). A proportional hazards model for the subdistribution of a competing risk. *Journal of the American Statistical Association*, 94(446), 496-509.

