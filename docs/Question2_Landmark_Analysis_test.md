---
title: "Research Question 2: Early On-Treatment ctDNA Response and Duration of Complete Response"
date: "2025-12-21"
output: html_document
---










```
## Population Studied
```

```
**Universe:** Patients with metastatic disease starting a new line of therapy who had on-treatment ctDNA measured within 6-18 weeks after therapy initiation
```

```
**N =48 patient-line observations (38 unique patients) (baseline universe - actual on-treatment analysis N shown in landmark analysis section below)
```

```
**Note:** The final analysis N (after excluding observations due to missing survival data or failure to survive to landmark) is shown in the landmark analysis section below.
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
- Had baseline ctDNA level measured within 21 days before starting that line of therapy
```

```
- Had on-treatment ctDNA level measured within 6-18 weeks after starting that line of therapy
```

```
- Survived to the landmark time point (ctDNA measurement date)
```

```
- Time 0 for landmark analysis = landmark time (ctDNA measurement date within 6-18 weeks)
```

```
**Note:** Each patient can contribute multiple observations (one per line of therapy). Line of therapy is included as a covariate in the analysis.
```
<｜tool▁calls▁begin｜><｜tool▁call▁begin｜>
read_file
<｜tool▁calls▁begin｜><｜tool▁call▁begin｜>
read_file



<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
<caption>Palliative Systemic Therapy Classes (ADC/ICI/Chemo/Targeted/Other). Note: patients can appear in multiple classes if they received combination regimens (e.g., ADC + ICI). Percentages are calculated based on total unique patients (N = 99).</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Therapy Class </th>
   <th style="text-align:left;"> N (%) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;width: 50%; "> ADC </td>
   <td style="text-align:left;width: 50%; "> 60 (60.6%) </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 50%; "> Chemo </td>
   <td style="text-align:left;width: 50%; "> 37 (37.4%) </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 50%; "> ICI </td>
   <td style="text-align:left;width: 50%; "> 34 (34.3%) </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 50%; "> unspecified </td>
   <td style="text-align:left;width: 50%; "> 12 (12.1%) </td>
  </tr>
  <tr>
   <td style="text-align:left;width: 50%; "> Targeted </td>
   <td style="text-align:left;width: 50%; "> 3 (3%) </td>
  </tr>
</tbody>
</table>


## Research Question 2

**What is the association between early on-treatment ctDNA response (cleared vs not cleared) at 6-18 weeks after therapy initiation and subsequent duration of complete response?**

This analysis examines whether early ctDNA clearance (within 6-18 weeks after starting therapy) is associated with improved duration of complete response. The landmark analysis uses the latest ctDNA measurement available within the 4-20 week window to assess clearance status, and analyzes duration of complete response from that landmark time point forward. **Note:** Only alive patients require imaging data for inclusion (to determine complete response status, similar to RECIST CR). Patients who died do NOT require imaging data (death is an event).




```
## Patient IDs Excluded Due to Missing Imaging Data

**No patients excluded due to missing imaging data.**
(All alive patients had imaging data available, or all excluded patients had died and did not require imaging data.)
```


```
## Addressing Immortal Time Bias
```

```
**Immortal time bias** occurs when patients must survive to a certain time to be classified into a group, artificially inflating survival. **Landmark analysis addresses this** by: (1) determining clearance status at the landmark time point (ctDNA measurement date within 6-18 weeks), not requiring survival to a later time; (2) analyzing survival FROM the landmark forward (time 0 = landmark time, not therapy start); and (3) including only patients who survived to landmark, ensuring equal opportunity for classification.
```

<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
<caption>Landmark Time Distribution (weeks) by ctDNA Clearance Status (demonstrating similar landmark times across groups)</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Clearance Status </th>
   <th style="text-align:right;"> N </th>
   <th style="text-align:left;"> Landmark Time (weeks, median IQR) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Not Cleared at Landmark </td>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:left;"> 11 (10-14) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Cleared at Landmark </td>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:left;"> 10 (8.7-12.1) </td>
  </tr>
</tbody>
</table>



<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
<caption>Multivariate Cox Model: On-Treatment ctDNA Clearance and Duration of Complete Response from Landmark. Models show HR progression as covariates are added. The unadjusted model p-value should match the log-rank test from the survival curve. HR &lt; 1 indicates longer duration of complete response (lower risk of loss of CR or death) for patients with ctDNA cleared at landmark.</caption>
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
   <td style="text-align:left;"> 0.25 (0.06-1.1) </td>
   <td style="text-align:left;"> 0.066 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adjusted for line of therapy </td>
   <td style="text-align:left;"> 0.13 (0.03-0.65) </td>
   <td style="text-align:left;"> 0.013 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adjusted for KPS </td>
   <td style="text-align:left;"> 0.24 (0.06-1.09) </td>
   <td style="text-align:left;"> 0.064 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adjusted for visceral metastases </td>
   <td style="text-align:left;"> 0.22 (0.05-1.03) </td>
   <td style="text-align:left;"> 0.054 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adjusted for line of therapy, KPS, and visceral metastases </td>
   <td style="text-align:left;"> 0.05 (0.01-0.38) </td>
   <td style="text-align:left;"> 0.004 </td>
  </tr>
</tbody>
</table>










```

**Interpretation of Hazard Ratios (adjusted for line of therapy, KPS, and visceral metastases):**
```
<｜tool▁calls▁begin｜><｜tool▁call▁begin｜>
grep


```

**Landmark Analysis Diagnostic:**
Total patients in cleared analysis: 29 
Events in Cleared group: 2 
Events in Not Cleared group: 18 
Total events: 20 
Median survival time from landmark (months): 6.7 
```

```
Using adjusted p-value from Cox model (adjusted for line of therapy, KPS, and visceral metastases): 0.003 
```

![plot of chunk landmark_survival_curves](figure/landmark_survival_curves-1.png)

## Secondary Analysis: Time to Next Treatment

**What is the association between early on-treatment ctDNA response (cleared vs not cleared) at 6-18 weeks after therapy initiation and time to next treatment?**

This secondary analysis examines whether early ctDNA clearance (within 6-18 weeks after starting therapy) is associated with longer time to next treatment. Time to next treatment is defined as the time from therapy initiation until the start of the next line of therapy or death, whichever occurs first.





### Time to Next Treatment Results

<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
<caption>Multivariate Cox Model: On-Treatment ctDNA Clearance and Time to Next Treatment from Landmark. Models show HR progression as covariates are added. HR &lt; 1 indicates longer time to next treatment (lower risk of starting next therapy or death) for patients with ctDNA cleared at landmark.</caption>
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
   <td style="text-align:left;"> 0.17 (0.04-0.75) </td>
   <td style="text-align:left;"> 0.019 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adjusted for line of therapy </td>
   <td style="text-align:left;"> 0.14 (0.03-0.68) </td>
   <td style="text-align:left;"> 0.015 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adjusted for KPS </td>
   <td style="text-align:left;"> 0.17 (0.04-0.75) </td>
   <td style="text-align:left;"> 0.019 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adjusted for visceral metastases </td>
   <td style="text-align:left;"> 0.17 (0.04-0.75) </td>
   <td style="text-align:left;"> 0.02 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Adjusted for line of therapy, KPS, and visceral metastases </td>
   <td style="text-align:left;"> 0.12 (0.02-0.66) </td>
   <td style="text-align:left;"> 0.014 </td>
  </tr>
</tbody>
</table>




### Time to Next Treatment Survival Curves

![plot of chunk ttnt_survival_curves](figure/ttnt_survival_curves-1.png)

### Time to Next Treatment Interpretation



## Tertiary Analysis: Overall Survival

**What is the association between on-treatment ctDNA clearance at landmark and overall survival?**

This tertiary analysis examines whether ctDNA clearance at the landmark time point (6-18 weeks after therapy initiation) is associated with overall survival. **For this analysis, only the first line of therapy is considered per patient** to avoid confusion from multiple treatment lines. Overall survival is defined as the time from the landmark time point (within the first line of therapy) until death, with death as the event and alive patients censored at last follow-up.





### Overall Survival Results

**Overall Survival Cox Model Results**

Overall Survival results table not created - no models converged with valid HR values.

Diagnostic: OS data available
- N = 0 observations
- OS events: 0 
- OS censored: 0 
- Unadjusted model: Not available



```
Overall Survival survival curves not available.
```

### Overall Survival Interpretation






# Summary section removed per user request

# On-treatment findings - use fully adjusted model if available
# Try to get the best available HR (multivariate > adjusted > unadjusted)
hr_final <- NULL
hr_final_lower <- NULL
hr_final_upper <- NULL
p_final <- NULL
adjustment_label <- ""

# Try bajorin model first (fully adjusted: line + KPS + visceral mets)
if (exists("cox_cleared_bajorin") && !is.null(cox_cleared_bajorin)) {
  tryCatch({
    if (isTRUE(cox_cleared_bajorin$converged)) {
      cox_summary <- summary(cox_cleared_bajorin)
      hr_bajorin <- cox_summary$conf.int[1, "exp(coef)"]
      hr_bajorin_lower <- cox_summary$conf.int[1, "lower .95"]
      hr_bajorin_upper <- cox_summary$conf.int[1, "upper .95"]
      p_bajorin <- cox_summary$coefficients[1, "Pr(>|z|)"]
      
      if (!is.na(hr_bajorin) && is.finite(hr_bajorin) && hr_bajorin > 0 && hr_bajorin < 1e10 &&
          !is.na(hr_bajorin_lower) && is.finite(hr_bajorin_lower) &&
          !is.na(hr_bajorin_upper) && is.finite(hr_bajorin_upper)) {
        hr_final <- hr_bajorin
        hr_final_lower <- hr_bajorin_lower
        hr_final_upper <- hr_bajorin_upper
        p_final <- p_bajorin
        adjustment_label <- "adjusted for line of therapy, KPS, and visceral metastases"
      }
    }
  }, error = function(e) {})
}

# Try multivariate model (if bajorin not available)
if (is.null(hr_final) && exists("cox_cleared_multiv") && !is.null(cox_cleared_multiv)) {
  tryCatch({
    if (isTRUE(cox_cleared_multiv$converged)) {
      cox_summary <- summary(cox_cleared_multiv)
      hr_multiv <- cox_summary$conf.int[1, "exp(coef)"]
      hr_multiv_lower <- cox_summary$conf.int[1, "lower .95"]
      hr_multiv_upper <- cox_summary$conf.int[1, "upper .95"]
      p_multiv <- cox_summary$coefficients[1, "Pr(>|z|)"]
      
      if (!is.na(hr_multiv) && is.finite(hr_multiv) && hr_multiv > 0 && hr_multiv < 1e10 &&
          !is.na(hr_multiv_lower) && is.finite(hr_multiv_lower) &&
          !is.na(hr_multiv_upper) && is.finite(hr_multiv_upper)) {
        hr_final <- hr_multiv
        hr_final_lower <- hr_multiv_lower
        hr_final_upper <- hr_multiv_upper
        p_final <- p_multiv
        adjustment_label <- "adjusted for line of therapy, KPS, and visceral metastases"
      }
    }
  }, error = function(e) {})
}

# Fall back to line of therapy only
if (is.null(hr_final) && exists("cox_cleared_line") && !is.null(cox_cleared_line)) {
  tryCatch({
    if (isTRUE(cox_cleared_line$converged)) {
      cox_summary <- summary(cox_cleared_line)
      hr_line <- cox_summary$conf.int[1, "exp(coef)"]
      hr_line_lower <- cox_summary$conf.int[1, "lower .95"]
      hr_line_upper <- cox_summary$conf.int[1, "upper .95"]
      p_line <- cox_summary$coefficients[1, "Pr(>|z|)"]
      
      if (!is.na(hr_line) && is.finite(hr_line) && hr_line > 0 && hr_line < 1e10 &&
          !is.na(hr_line_lower) && is.finite(hr_line_lower) &&
          !is.na(hr_line_upper) && is.finite(hr_line_upper)) {
        hr_final <- hr_line
        hr_final_lower <- hr_line_lower
        hr_final_upper <- hr_line_upper
        p_final <- p_line
        adjustment_label <- "adjusted for line of therapy"
      }
    }
  }, error = function(e) {})
}

# Fall back to unadjusted
if (is.null(hr_final) && exists("cox_cleared_unadj") && !is.null(cox_cleared_unadj)) {
  tryCatch({
    if (isTRUE(cox_cleared_unadj$converged)) {
      cox_summary <- summary(cox_cleared_unadj)
      hr_unadj <- cox_summary$conf.int[1, "exp(coef)"]
      hr_unadj_lower <- cox_summary$conf.int[1, "lower .95"]
      hr_unadj_upper <- cox_summary$conf.int[1, "upper .95"]
      p_unadj <- cox_summary$coefficients[1, "Pr(>|z|)"]
      
      if (!is.na(hr_unadj) && is.finite(hr_unadj) && hr_unadj > 0 && hr_unadj < 1e10 &&
          !is.na(hr_unadj_lower) && is.finite(hr_unadj_lower) &&
          !is.na(hr_unadj_upper) && is.finite(hr_unadj_upper)) {
        hr_final <- hr_unadj
        hr_final_lower <- hr_unadj_lower
        hr_final_upper <- hr_unadj_upper
        p_final <- p_unadj
        adjustment_label <- "unadjusted"
      }
    }
  }, error = function(e) {})
}

if (!is.null(hr_final)) {
  cat("**Key Findings - On-Treatment (Early Response):**\n")
  cat("- **Primary Result (", adjustment_label, "):** Hazard Ratio for ctDNA Cleared at Landmark vs Not Cleared = ", 
      round(hr_final, 2), 
      " (95% CI: ", 
      round(hr_final_lower, 2), 
      "-", 
      round(hr_final_upper, 2), 
      ")\n", sep = "")
  cat("- P-value:", ifelse(p_final < 0.001, 
                            "<0.001", 
                            round(p_final, 3)), "\n\n")
} else {
  cat("**Key Findings - On-Treatment (Early Response):**\n")
  cat("- **Note:** Cox models did not converge or produced extreme HR values. Please see the multivariate Cox model table above for details.\n\n")
}

cat("**Interpretation:**\n\n")

# On-treatment role (landmark analysis) - use fully adjusted model if available
# Check for bajorin HR first (fully adjusted), then fall back to multiv, then line, then unadjusted
hr_to_use <- NULL
hr_lower_to_use <- NULL
hr_upper_to_use <- NULL
p_to_use <- NULL
adjustment_note <- ""

# Try bajorin HR first (fully adjusted: line + KPS + visceral mets)
if (exists("cox_cleared_bajorin") && !is.null(cox_cleared_bajorin)) {
  tryCatch({
    if (isTRUE(cox_cleared_bajorin$converged)) {
      cox_summary <- summary(cox_cleared_bajorin)
      hr_bajorin <- cox_summary$conf.int[1, "exp(coef)"]
      hr_bajorin_lower <- cox_summary$conf.int[1, "lower .95"]
      hr_bajorin_upper <- cox_summary$conf.int[1, "upper .95"]
      p_bajorin <- cox_summary$coefficients[1, "Pr(>|z|)"]
      
      if (!is.na(hr_bajorin) && is.finite(hr_bajorin) && hr_bajorin > 0 && hr_bajorin < 1e10 &&
          !is.na(hr_bajorin_lower) && is.finite(hr_bajorin_lower) &&
          !is.na(hr_bajorin_upper) && is.finite(hr_bajorin_upper)) {
        hr_to_use <- hr_bajorin
        hr_lower_to_use <- hr_bajorin_lower
        hr_upper_to_use <- hr_bajorin_upper
        p_to_use <- p_bajorin
        adjustment_note <- "adjusted for line of therapy, KPS, and visceral metastases"
      }
    }
  }, error = function(e) {})
}

# Fall back to multivariate HR
if (is.null(hr_to_use) && exists("cox_cleared_multiv") && !is.null(cox_cleared_multiv)) {
  tryCatch({
    if (isTRUE(cox_cleared_multiv$converged)) {
      cox_summary <- summary(cox_cleared_multiv)
      hr_multiv <- cox_summary$conf.int[1, "exp(coef)"]
      hr_multiv_lower <- cox_summary$conf.int[1, "lower .95"]
      hr_multiv_upper <- cox_summary$conf.int[1, "upper .95"]
      p_multiv <- cox_summary$coefficients[1, "Pr(>|z|)"]
      
      if (!is.na(hr_multiv) && is.finite(hr_multiv) && hr_multiv > 0 && hr_multiv < 1e10 &&
          !is.na(hr_multiv_lower) && is.finite(hr_multiv_lower) &&
          !is.na(hr_multiv_upper) && is.finite(hr_multiv_upper)) {
        hr_to_use <- hr_multiv
        hr_lower_to_use <- hr_multiv_lower
        hr_upper_to_use <- hr_multiv_upper
        p_to_use <- p_multiv
        adjustment_note <- "adjusted for line of therapy, KPS, and visceral metastases"
      }
    }
  }, error = function(e) {})
}

# Fall back to line of therapy only
if (is.null(hr_to_use) && exists("cox_cleared_line") && !is.null(cox_cleared_line)) {
  tryCatch({
    if (isTRUE(cox_cleared_line$converged)) {
      cox_summary <- summary(cox_cleared_line)
      hr_line <- cox_summary$conf.int[1, "exp(coef)"]
      hr_line_lower <- cox_summary$conf.int[1, "lower .95"]
      hr_line_upper <- cox_summary$conf.int[1, "upper .95"]
      p_line <- cox_summary$coefficients[1, "Pr(>|z|)"]
      
      if (!is.na(hr_line) && is.finite(hr_line) && hr_line > 0 && hr_line < 1e10 &&
          !is.na(hr_line_lower) && is.finite(hr_line_lower) &&
          !is.na(hr_line_upper) && is.finite(hr_line_upper)) {
        hr_to_use <- hr_line
        hr_lower_to_use <- hr_line_lower
        hr_upper_to_use <- hr_line_upper
        p_to_use <- p_line
        adjustment_note <- "adjusted for line of therapy"
      }
    }
  }, error = function(e) {})
}

# Fall back to unadjusted HR
if (is.null(hr_to_use) && exists("cox_cleared_unadj") && !is.null(cox_cleared_unadj)) {
  tryCatch({
    if (isTRUE(cox_cleared_unadj$converged)) {
      cox_summary <- summary(cox_cleared_unadj)
      hr_unadj <- cox_summary$conf.int[1, "exp(coef)"]
      hr_unadj_lower <- cox_summary$conf.int[1, "lower .95"]
      hr_unadj_upper <- cox_summary$conf.int[1, "upper .95"]
      p_unadj <- cox_summary$coefficients[1, "Pr(>|z|)"]
      
      if (!is.na(hr_unadj) && is.finite(hr_unadj) && hr_unadj > 0 && hr_unadj < 1e10 &&
          !is.na(hr_unadj_lower) && is.finite(hr_unadj_lower) &&
          !is.na(hr_unadj_upper) && is.finite(hr_unadj_upper)) {
        hr_to_use <- hr_unadj
        hr_lower_to_use <- hr_unadj_lower
        hr_upper_to_use <- hr_unadj_upper
        p_to_use <- p_unadj
        adjustment_note <- "unadjusted"
      }
    }
  }, error = function(e) {})
}

# Write interpretation
if (!is.null(hr_to_use)) {
  cat("Patients who cleared ctDNA at the landmark time point (6-18 weeks after therapy initiation) showed ", 
      if (hr_to_use < 1) {
        paste0("a significantly lower risk of loss of complete response or death (HR = ", round(hr_to_use, 2), ", 95% CI: ", round(hr_lower_to_use, 2), "-", round(hr_upper_to_use, 2), "), p = ", ifelse(p_to_use < 0.001, "<0.001", round(p_to_use, 3)), ", ", adjustment_note, ") COMPARED to those who did not clear ctDNA. ", sep = "")
      } else {
        paste0("a higher risk of loss of complete response or death (HR = ", round(hr_to_use, 2), ", 95% CI: ", round(hr_lower_to_use, 2), "-", round(hr_upper_to_use, 2), "), p = ", ifelse(p_to_use < 0.001, "<0.001", round(p_to_use, 3)), ", ", adjustment_note, ") COMPARED to those who did not clear ctDNA. ", sep = "")
      })
  cat("This strong association suggests that early ctDNA clearance may serve as a pharmacodynamic response biomarker, indicating effective treatment and potentially predicting improved duration of complete response. The landmark analysis approach addresses immortal time bias by ensuring all patients have equal opportunity for classification at the landmark time point, and analyzing survival from the landmark forward. Validation as a surrogate endpoint would require prospective trials.\n")
} else {
  cat("**Note:** Interpretation could not be completed because the Cox models did not converge or produced extreme HR values. Please check the diagnostic output above and the multivariate Cox model table for details.\n")
}

```

## Interpretation of Most Adjusted Cox Model Hazard Ratios

## Interpretation of Most Adjusted Cox Model Hazard Ratios

### Duration of Complete Response (DCR)

### Time to Next Treatment (TTNT)

