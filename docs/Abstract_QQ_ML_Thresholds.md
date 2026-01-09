# Abstract: Comparison of Qualitative, Quantitative, and Machine Learning Approaches for Classifying ctDNA Response Patterns

## Introduction

Multiple approaches exist for classifying circulating tumor DNA (ctDNA) response patterns, but their relative performance in predicting survival outcomes has not been systematically compared. This analysis compares three classification approaches: (1) Qualitative (binary status changes), (2) Quantitative (percent change from baseline), and (3) Machine Learning (unsupervised clustering of kinetic features).

## Methods

We classified patients into response groups using each approach. The Qualitative approach categorized patients as: ctDNA Clearance, Persistent Positive, Persistent Negative, or ctDNA Conversion. The Quantitative approach used percent change thresholds: Major Response (≥90% reduction), Partial Response (≥50% reduction), Progressive (≥50% increase), Stable, New Positive, or Persistent Negative. The ML approach used k-means clustering (60/20/20 train/validation/test split) on multiple ctDNA kinetic features including baseline value, trend, coefficient of variation, and clearance/conversion patterns. Performance was evaluated using Harrell's C-index (concordance index) and Akaike Information Criterion (AIC) from Cox proportional hazards models for overall survival (OS). Bootstrap resampling (n=1000) was used to calculate 95% confidence intervals for C-indices and to perform pairwise comparisons with p-values testing the null hypothesis that C-index differences equal zero.

## Results

All three approaches showed similar predictive performance. The Qualitative approach achieved a C-index of [value] (95% CI: [lower]-[upper]), Quantitative approach [value] (95% CI: [lower]-[upper]), and ML approach [value] (95% CI: [lower]-[upper]). Pairwise comparisons showed no statistically significant differences between approaches (all p-values >0.05). AIC values were comparable across approaches, suggesting similar model fit.

## Conclusions

Qualitative, Quantitative, and Machine Learning approaches for classifying ctDNA response patterns demonstrate similar predictive performance for overall survival. The simpler Qualitative and Quantitative approaches may be preferred for clinical implementation due to their interpretability and ease of application, while the ML approach provides similar performance but requires more complex feature engineering and may be less transparent.
