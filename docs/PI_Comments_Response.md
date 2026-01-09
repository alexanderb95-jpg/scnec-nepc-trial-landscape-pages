# Response to PI Comments: Time-Dependent Variables and Guarantee Time Bias

## Summary of PI Concerns

1. **Time-dependent nature of variables**: Are the survival models accounting for the time-dependent nature of ctDNA measurements?
2. **Guarantee time bias**: Does the "Persistent Negative" group require patients to be alive for a certain duration, creating a survival bias?

## Current Analysis Issues

### Issue 1: Time-Fixed vs Time-Dependent Models

**Current Approach:**
- ctDNA groups are assigned based on ALL measurements throughout follow-up
- Groups are then used as **fixed covariates** in standard Cox models
- Example: "Persistent Negative" = baseline negative AND never became positive AND last value negative

**Problem:**
- This treats ctDNA status as constant over time, when it actually changes
- A patient who converts from negative to positive at month 6 is classified the same way as someone who stays negative
- This violates the proportional hazards assumption and can bias results

**Evidence from Code:**
```r
# Lines 1104-1144: Groups assigned based on entire follow-up
qualitative_group = case_when(
  baseline_status == "Negative" & !became_positive_after ~ "Persistent Negative",
  ...
)

# Lines 1405-1407: Used as fixed covariate
surv_formula <- as.formula(paste0("Surv(", time_var, ", ", event_var, ") ~ ", group_var))
coxph(surv_formula, data = data_clean)
```

### Issue 2: Guarantee Time Bias

**Current Approach:**
- "Persistent Negative" requires:
  - Baseline negative
  - Never became positive after baseline
  - Last value negative

**Problem:**
- To be classified as "Persistent Negative," a patient must:
  1. Survive long enough to have multiple ctDNA measurements
  2. Survive to the time of their "last" measurement
  3. Not have died before demonstrating persistence
  
- Patients who die early cannot be classified as persistently negative
- This artificially inflates survival in the "Persistent Negative" group
- This is a form of **immortal time bias** or **guarantee time bias**

**Example:**
- Patient A: Baseline negative, dies at month 2 → Cannot be "Persistent Negative" (needs multiple measurements)
- Patient B: Baseline negative, alive at month 12 with all negative values → "Persistent Negative"
- Patient B appears to have better survival, but this is partly because they survived long enough to be classified

## Recommended Solutions

### Solution 1: Time-Dependent Cox Models

Convert ctDNA status to a time-dependent covariate that changes at each measurement time.

**Approach:**
1. Create a dataset with one row per patient per ctDNA measurement time
2. Use `tmerge()` or manual creation of time-dependent intervals
3. Fit time-dependent Cox model: `coxph(Surv(tstart, tstop, event) ~ ctdna_status, data = tdata)`

**Benefits:**
- Accounts for when ctDNA status changes
- Properly handles patients who convert from negative to positive
- More accurate hazard ratios

**Limitations:**
- More complex to implement and interpret
- Requires careful handling of measurement times

### Solution 2: Landmark Analysis

Use landmark analysis to address guarantee time bias.

**Approach:**
1. Define a landmark time (e.g., 3 months, 6 months)
2. Only include patients alive at the landmark time
3. Classify ctDNA status based on measurements up to landmark time
4. Analyze survival from landmark time forward

**Benefits:**
- Addresses guarantee time bias by ensuring all patients survive to landmark
- Simpler than time-dependent models
- Common approach in oncology

**Limitations:**
- Loses patients who die before landmark
- May reduce sample size
- Choice of landmark time is somewhat arbitrary

### Solution 3: Baseline-Only Analysis (Simplest)

Use only baseline ctDNA status as a fixed covariate.

**Approach:**
1. Classify patients based on baseline ctDNA only (positive vs negative)
2. Use standard Cox model with baseline status
3. No guarantee time bias (all patients have baseline measurement)

**Benefits:**
- Simplest approach
- No guarantee time bias
- Easy to interpret

**Limitations:**
- Loses information about ctDNA changes over time
- May miss important prognostic information from dynamic changes

### Solution 4: Left-Truncation with Time-Dependent Covariates

Combine time-dependent models with left-truncation to handle guarantee time.

**Approach:**
1. Use time-dependent ctDNA status
2. Left-truncate at time of first ctDNA measurement (or landmark time)
3. Only include patients who survive to have at least one ctDNA measurement

**Benefits:**
- Handles both time-dependence and guarantee time bias
- Most methodologically rigorous

**Limitations:**
- Most complex to implement
- Requires careful interpretation

## Recommended Implementation Plan

### Phase 1: Immediate Fix (Baseline Analysis)
1. Re-run analysis using **baseline ctDNA status only**
2. Compare baseline positive vs baseline negative
3. This addresses guarantee time bias immediately

### Phase 2: Time-Dependent Analysis
1. Implement time-dependent Cox models
2. Create time-dependent dataset with `tmerge()` or manual intervals
3. Model ctDNA status as changing at each measurement time

### Phase 3: Landmark Analysis (Sensitivity)
1. Perform landmark analysis at 3, 6, and 12 months
2. Classify ctDNA status at each landmark
3. Compare results across landmarks

## Code Modifications Needed

See accompanying R script: `ctDNA_TimeDependent_Analysis.R`

Key changes:
1. Create time-dependent dataset structure
2. Use `tmerge()` or manual interval creation
3. Fit time-dependent Cox models
4. Compare with baseline-only models
5. Perform landmark analyses

## Interpretation Considerations

When presenting results, clearly state:
1. **Which approach was used** (baseline-only, time-dependent, landmark)
2. **How guarantee time bias was addressed** (or acknowledged as a limitation)
3. **Limitations of the approach** chosen
4. **Sensitivity analyses** performed

## Additional Consideration: Non-Informative Censoring

### Why This Matters

A critical assumption in survival analysis is that **censoring is non-informative**. This means:
- The reason for censoring (e.g., end of follow-up, loss to follow-up) is unrelated to the outcome
- Patients who are censored have the same risk of the event as patients who are not censored (conditional on observed covariates)

### Testing for Informative Censoring

**What to test:**
1. **Censoring rates across groups**: Do different ctDNA groups have different censoring rates?
2. **Censoring times**: Do censored patients in different groups have different censoring times?
3. **Baseline characteristics**: Do censored patients differ from event patients in baseline characteristics?

**If censoring is informative:**
- Results may be biased
- Patients with better prognosis may be more likely to be censored (or vice versa)
- This can inflate or deflate survival estimates

**Solutions if censoring is informative:**
1. **Competing risks analysis**: Model censoring as a competing risk
2. **Sensitivity analysis**: Exclude early censored patients
3. **Acknowledge limitation**: Clearly state in manuscript
4. **Stratified analysis**: Account for factors related to censoring

### Implementation

See `ctDNA_TimeDependent_Analysis.R` - Solution 5 for:
- Chi-square tests comparing censoring rates across groups
- Kruskal-Wallis tests comparing censoring times
- Log-rank tests for censoring time distributions
- Visualization of censoring patterns
- Tests comparing baseline characteristics between censored and event patients

## References

- Dafni U. (2011). Landmark analysis at the 25-year landmark point. *Circulation: Cardiovascular Quality and Outcomes*, 4(3), 363-371.
- Leung KM, Elashoff RM, Afifi AA. (1997). Censoring issues in survival analysis. *Annual Review of Public Health*, 18, 83-104.
- Suissa S. (2008). Immortal time bias in pharmaco-epidemiology. *American Journal of Epidemiology*, 167(4), 492-499.
- Klein JP, Moeschberger ML. (2003). *Survival Analysis: Techniques for Censored and Truncated Data*. Springer.

