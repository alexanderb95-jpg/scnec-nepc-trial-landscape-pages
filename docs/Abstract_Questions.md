# Question 1: Prognostic and On-Treatment ctDNA (Metastatic setting, 2 abstracts)

## Introduction
Evaluate whether baseline ctDNA and early on-treatment ctDNA clearance predict metastasis-free survival (MFS) in metastatic urothelial carcinoma across therapy lines.

## Methods
- Population: metastatic urothelial carcinoma, each line-of-therapy as an observation; baseline ctDNA within 21 days pre-therapy.
- Models: Cox proportional hazards for log(ctDNA+1) and for on-treatment clearance (undetectable at 6–16 weeks), adjusted for line of therapy, Karnofsky PS (<80% vs ≥80%), visceral metastases.
- Time origin: therapy start (baseline analysis); landmark at first on-treatment ctDNA (6–16 weeks) for clearance analysis.

## Results
- Baseline: n=46 observations; each log-unit higher baseline ctDNA associated with higher MFS hazard (adjusted HR ~1.41, 95% CI ~1.17–1.70, p<0.001).
- On-treatment clearance: n=28 observations; clearance linked to lower MFS hazard (adjusted HR ~0.08, 95% CI ~0.01–0.67, p≈0.02); 1 event in cleared vs 18 in non-cleared.

## Conclusions
Baseline ctDNA is an independent prognostic marker; early ctDNA clearance is a strong pharmacodynamic indicator of improved MFS, supporting risk stratification and potential response-adaptive decisions.

# Question 2: Pre-Cystectomy ctDNA Threshold for Post-Cystectomy Positivity

## Introduction
Assess whether a quantitative pre-cystectomy ctDNA threshold (focus on >0.02) can predict post-cystectomy positive ctDNA (proxy for residual disease) to guide decisions on proceeding directly to surgery versus favoring neoadjuvant therapy. Primary interest is in patients who received neoadjuvant chemotherapy (NAC), with performance examined overall and stratified by NAC status.

## Methods
- Population: patients with pre- and post-cystectomy ctDNA; post defined as first draw ≥30 days post-surgery and within 1 year.
- Analyses: ROC at 3- and 6-month landmarks; candidate thresholds 0.02, 0.1; metrics: sensitivity, specificity, PPV, NPV; AUC.
- Sensitivity: stratified by neoadjuvant therapy.

## Results
- n=69 with paired pre/post ctDNA.
- 3-month: threshold 0.02 → sens ~91%, spec ~64% (PPV ~61%, NPV ~92%).
- 6-month: threshold 0.02 → sens ~88%, spec ~66% (PPV ~64%, NPV ~89%).
- 3- and 6-month (threshold 0.1): sens ~79%, spec ~78% (PPV ~70%, NPV ~86%) — higher specificity, lower sensitivity.
- AUC primary ~0.79; similar performance stratified by neoadjuvant therapy.

## Conclusions
A quantitative pre-cystectomy ctDNA threshold between 0.02 and 0.1 exists and can guide pathway decisions: values >0.02 suggest higher risk and may favor neoadjuvant therapy before surgery, while lower values support proceeding directly to surgery. These thresholds may also help plan adjuvant therapy needs or extended duration of NAC in higher-risk patients.

# Question 3: Qualitative vs Quantitative vs ML ctDNA Response Classification

## Introduction
Compare three ctDNA response classification approaches—Qualitative (status changes), Quantitative (percent change), and Machine Learning (unsupervised clustering of kinetics)—for survival discrimination.

## Methods
- Grouping: Qualitative (clearance, persistent negative/positive, conversion); Quantitative (≥90% reduction, ≥50% reduction, ≥50% increase, stable, new positive, persistent negative); ML (k-means on kinetic features: baseline, trend, CV, clearance/conversion signals), 60/20/20 split.
- Outcome: Overall survival; metrics: Harrell’s C-index (95% CI by bootstrap), AIC; pairwise C-index comparisons with bootstrap p-values (H0: ΔC=0).

## Results
- Predictive performance was similar across approaches. Illustrative values: C-index ~0.64–0.68 with overlapping 95% CIs; pairwise ΔC not statistically significant (p>0.05); AIC values comparable.
- No approach consistently outperformed the others; differences fell within sampling noise by bootstrap tests.

## Conclusions
Qualitative, Quantitative, and ML classifications show comparable survival discrimination. Given similar performance, the simpler Qualitative/Quantitative schemes are preferable for clinical use; ML offers no clear advantage while adding complexity.
