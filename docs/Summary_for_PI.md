# Summary: Addressing Time-Dependent Variables and Guarantee Time Bias

## Executive Summary

The PI correctly identified two critical methodological issues in the current ctDNA survival analysis:

1. **Time-dependent nature**: ctDNA status changes over time but is treated as a fixed covariate
2. **Guarantee time bias**: "Persistent Negative" classification requires patients to survive long enough to demonstrate persistence

## Current Analysis Problems

### Problem 1: Time-Fixed Models with Time-Dependent Data

**What we're doing now:**
- Classify patients into groups based on ALL their ctDNA measurements
- Use these groups as fixed covariates in Cox models
- Example: "Persistent Negative" = never positive throughout entire follow-up

**Why this is problematic:**
- ctDNA status is **time-dependent** - it changes over time
- A patient who converts from negative to positive at month 6 is treated the same as someone who stays negative
- This violates the proportional hazards assumption
- Results may be biased

### Problem 2: Guarantee Time Bias

**What we're doing now:**
- "Persistent Negative" requires:
  - Baseline negative
  - Never became positive
  - Last value negative

**Why this is problematic:**
- To be "Persistent Negative," a patient must:
  1. Survive long enough to have multiple measurements
  2. Survive to their last measurement time
  3. Not die before demonstrating persistence
  
- **Patients who die early cannot be classified as persistently negative**
- This artificially inflates survival in the "Persistent Negative" group
- This is a form of **immortal time bias**

**Example:**
- Patient A: Baseline negative, dies at month 2 → Cannot be "Persistent Negative"
- Patient B: Baseline negative, alive at month 12 with all negative → "Persistent Negative"
- Patient B appears to have better survival, but this is partly because they survived long enough to be classified

## Solutions Implemented

### Solution 1: Baseline-Only Analysis ✅ **RECOMMENDED FOR PRIMARY**

**Approach:**
- Classify patients based on baseline ctDNA only (positive vs negative)
- Use standard Cox model with baseline status as fixed covariate
- All patients have baseline measurement, so no guarantee time bias

**Advantages:**
- ✅ No guarantee time bias
- ✅ Simple and interpretable
- ✅ Standard approach in oncology
- ✅ Easy to implement

**Limitations:**
- Loses information about ctDNA changes over time
- May miss prognostic value of dynamic changes

**Code:** See `ctDNA_TimeDependent_Analysis.R` - Solution 1

### Solution 2: Time-Dependent Cox Models

**Approach:**
- Create time-dependent dataset where ctDNA status changes at each measurement
- Use `coxph(Surv(tstart, tstop, event) ~ ctdna_status)`
- Accounts for when status changes

**Advantages:**
- ✅ Properly handles time-dependent nature of ctDNA
- ✅ More accurate hazard ratios
- ✅ Captures dynamic changes

**Limitations:**
- More complex to implement and interpret
- Does not directly address guarantee time bias
- Requires careful handling of measurement times

**Code:** See `ctDNA_TimeDependent_Analysis.R` - Solution 2

### Solution 3: Landmark Analysis ✅ **RECOMMENDED FOR SENSITIVITY**

**Approach:**
- Define landmark time (e.g., 6 months)
- Only include patients alive at landmark
- Classify ctDNA status based on measurements up to landmark
- Analyze survival from landmark forward

**Advantages:**
- ✅ Addresses guarantee time bias
- ✅ Simpler than full time-dependent models
- ✅ Common approach in oncology
- ✅ Can use multiple landmarks for sensitivity

**Limitations:**
- Loses patients who die before landmark
- Choice of landmark time is somewhat arbitrary
- May reduce sample size

**Code:** See `ctDNA_TimeDependent_Analysis.R` - Solution 3

### Solution 4: Left-Truncation with Time-Dependent Covariates

**Approach:**
- Combine time-dependent models with left-truncation
- Patients enter analysis at first ctDNA measurement
- Status changes at each subsequent measurement

**Advantages:**
- ✅ Handles both time-dependence and guarantee time bias
- ✅ Most methodologically rigorous

**Limitations:**
- Most complex to implement
- Requires careful interpretation

**Code:** See `ctDNA_TimeDependent_Analysis.R` - Solution 4

## Recommended Analysis Plan

### Primary Analysis
**Use: Baseline-Only Analysis**
- Classify by baseline ctDNA status (positive vs negative)
- Standard Cox model
- Addresses guarantee time bias
- Simple and interpretable

### Sensitivity Analysis
**Use: Landmark Analysis at 6 months**
- Include patients alive at 6 months
- Classify ctDNA status at 6 months
- Analyze survival from 6 months forward
- Addresses both issues

### Exploratory Analysis
**Use: Time-Dependent Cox Model**
- Show how results change when accounting for time-dependence
- Demonstrate robustness of findings

## Implementation

1. **Immediate:** Re-run analysis using baseline-only approach
2. **Next:** Implement landmark analysis at 3, 6, and 12 months
3. **Optional:** Implement time-dependent Cox models for comparison

## Manuscript Language

When writing the methods section, include:

> "To address potential guarantee time bias in the 'Persistent Negative' group (which requires patients to survive long enough to demonstrate persistence), we performed two complementary analyses: (1) a baseline-only analysis using baseline ctDNA status as a fixed covariate, and (2) a landmark analysis at 6 months post-baseline. The baseline-only analysis eliminates guarantee time bias as all patients have a baseline measurement. The landmark analysis addresses both guarantee time bias and the time-dependent nature of ctDNA by classifying status at a fixed time point and analyzing survival from that point forward."

## Files Created

1. **PI_Comments_Response.md** - Detailed explanation of issues and solutions
2. **ctDNA_TimeDependent_Analysis.R** - Implementation code for all solutions
3. **Summary_for_PI.md** - This document

## Next Steps

1. Review the code in `ctDNA_TimeDependent_Analysis.R`
2. Run the baseline-only analysis as primary
3. Run landmark analysis as sensitivity
4. Compare results across approaches
5. Update manuscript with appropriate methods and limitations

## Additional Analysis: Non-Informative Censoring

### Why This Matters

A critical assumption in survival analysis is **non-informative censoring**:
- Censoring should be unrelated to the outcome
- Patients who are censored should have the same risk as those not censored (conditional on observed factors)

### What We're Testing

1. **Censoring rates**: Do different ctDNA groups have different proportions of censored patients?
2. **Censoring times**: Do censored patients in different groups have different censoring times?
3. **Baseline characteristics**: Do censored patients differ from event patients?

### If Censoring is Informative

- Results may be biased
- Consider competing risks analysis
- Perform sensitivity analyses
- Acknowledge limitation in manuscript

### Implementation

See `ctDNA_TimeDependent_Analysis.R` - Solution 5 for comprehensive censoring analysis including:
- Statistical tests comparing censoring patterns
- Visualizations of censoring distributions
- Tests for differences in baseline characteristics

## Questions for PI

1. Which approach would you prefer as the primary analysis?
2. Should we present all approaches or focus on one?
3. Are there specific landmark times you'd prefer (e.g., 3, 6, 12 months)?
4. Should we also address this for PFS (progression-free survival) in addition to OS?
5. Should we include censoring pattern analysis in the manuscript?

