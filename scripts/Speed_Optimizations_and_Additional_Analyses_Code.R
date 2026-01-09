# ====================================================================================
# SPEED OPTIMIZATIONS AND ADDITIONAL ANALYSES FOR QUESTION 1
# ====================================================================================
# This file contains optimized code and additional analyses for Research Question 2
# Add these to your R Markdown file
# ====================================================================================

# ====================================================================================
# PART 1: SPEED OPTIMIZATIONS
# ====================================================================================

# OPTIMIZATION 1: Pre-filter ctDNA data before joins (for landmark analysis)
# Replace the landmark_analysis_early_response chunk with this optimized version:

landmark_analysis_early_response_OPTIMIZED <- function(outcomes, ctdna_long, 
                                                        landmark_window_start_days, 
                                                        landmark_window_end_days) {
  # Pre-calculate date ranges for each patient-line to filter ctdna_long
  date_ranges <- outcomes %>%
    select(patient_id, therapy_line, time_zero_date) %>%
    mutate(
      min_date = time_zero_date + days(landmark_window_start_days),
      max_date = time_zero_date + days(landmark_window_end_days)
    )
  
  # Filter ctdna_long to only relevant dates BEFORE joining (much faster)
  ctdna_filtered <- ctdna_long %>%
    inner_join(date_ranges, by = "patient_id") %>%
    filter(ctdna_date >= min_date, ctdna_date <= max_date) %>%
    mutate(
      days_from_therapy_start = as.numeric(ctdna_date - time_zero_date),
      in_landmark_window = days_from_therapy_start >= landmark_window_start_days & 
                          days_from_therapy_start <= landmark_window_end_days
    ) %>%
    filter(in_landmark_window) %>%
    # For each patient-line, take the LATEST on-treatment ctDNA in the window
    arrange(patient_id, therapy_line, desc(days_from_therapy_start)) %>%
    group_by(patient_id, therapy_line) %>%
    slice_head(n = 1) %>%
    ungroup()
  
  # Now join with outcomes (much smaller dataset)
  landmark_data <- outcomes %>%
    select(patient_id, therapy_line, time_zero_date, ctdna_before_line_date, 
           ctdna_before_line_value, mfs_time, mfs_event) %>%
    left_join(
      ctdna_filtered %>%
        select(patient_id, therapy_line, ctdna_date, ctdna_value, days_from_therapy_start),
      by = c("patient_id", "therapy_line")
    ) %>%
    filter(!is.na(ctdna_date)) %>%  # Only keep those with on-treatment ctDNA
    mutate(
      baseline_ctdna = ctdna_before_line_value,
      on_tx_ctdna = ctdna_value,
      pct_decline = case_when(
        baseline_ctdna > 0 ~ ((baseline_ctdna - on_tx_ctdna) / baseline_ctdna) * 100,
        baseline_ctdna == 0 & on_tx_ctdna == 0 ~ 0,
        baseline_ctdna == 0 & on_tx_ctdna > 0 ~ -Inf,
        TRUE ~ NA_real_
      ),
      ctdna_cleared_at_landmark = case_when(
        baseline_ctdna > 0 & on_tx_ctdna == 0 ~ TRUE,
        baseline_ctdna > 0 & on_tx_ctdna > 0 ~ FALSE,
        baseline_ctdna == 0 ~ NA,
        TRUE ~ NA
      ),
      response_category = case_when(
        ctdna_cleared_at_landmark == TRUE ~ "Cleared (100% decline)",
        pct_decline >= 50 ~ "Major Response (≥50% decline)",
        pct_decline >= 0 & pct_decline < 50 ~ "Minor Response (0-50% decline)",
        pct_decline < 0 ~ "Progression (increase)",
        TRUE ~ "Unknown"
      ),
      landmark_time = days_from_therapy_start
    ) %>%
    select(patient_id, therapy_line, time_zero_date, landmark_time,
           baseline_ctdna, on_tx_ctdna, pct_decline, ctdna_cleared_at_landmark, response_category)
  
  return(landmark_data)
}

# OPTIMIZATION 2: Cache intermediate results
# Add at end of define_universe chunk:
if (!dir.exists("cache")) dir.create("cache")
saveRDS(universe, "cache/universe.rds")
saveRDS(outcomes, "cache/outcomes.rds")

# Then at start of subsequent chunks, load if exists:
if (file.exists("cache/universe.rds") && !exists("universe")) {
  universe <- readRDS("cache/universe.rds")
}

# OPTIMIZATION 3: Pre-compute therapy_line_factor once
# Add to outcomes after it's created:
outcomes <- outcomes %>%
  mutate(
    therapy_line_grouped = case_when(
      therapy_line == 1 ~ "1L",
      therapy_line == 2 ~ "2L",
      therapy_line == 3 ~ "3L",
      therapy_line >= 4 ~ "4L+",
      TRUE ~ as.character(therapy_line)
    ),
    therapy_line_factor = factor(therapy_line_grouped, levels = c("1L", "2L", "3L", "4L+"))
  )

# ====================================================================================
# PART 2: ADDITIONAL ANALYSES FOR RESEARCH QUESTION 2
# ====================================================================================

# ANALYSIS 1: Continuous ctDNA at landmark (log-transformed)
# Add this after landmark_outcomes is created:

landmark_outcomes <- landmark_outcomes %>%
  mutate(
    # Continuous variables for analysis
    log_on_tx_ctdna = log(on_tx_ctdna + 1),
    log_baseline_ctdna = log(baseline_ctdna + 1),
    # Keep binary for comparison
    ctdna_cleared_at_landmark = ctdna_cleared_at_landmark
  )

# Cox model with continuous on-treatment ctDNA
cox_continuous_on_tx <- coxph(
  Surv(mfs_time_from_landmark, mfs_event_from_landmark) ~ 
    log_on_tx_ctdna + therapy_line_factor + therapy_class_factor + 
    kps_factor + visceral_mets_factor,
  data = landmark_outcomes %>% 
    filter(!is.na(log_on_tx_ctdna), !is.na(kps_binary), !is.na(visceral_mets_binary))
)

# ANALYSIS 2: Percent decline as continuous variable
cox_pct_decline_continuous <- coxph(
  Surv(mfs_time_from_landmark, mfs_event_from_landmark) ~ 
    pct_decline + therapy_line_factor + therapy_class_factor + 
    kps_factor + visceral_mets_factor,
  data = landmark_outcomes %>% 
    filter(!is.na(pct_decline), !is.na(kps_binary), !is.na(visceral_mets_binary))
)

# ANALYSIS 3: Interaction between baseline and on-treatment ctDNA
landmark_outcomes <- landmark_outcomes %>%
  mutate(
    baseline_high = log_baseline_ctdna > median(log_baseline_ctdna, na.rm = TRUE),
    baseline_high_factor = factor(baseline_high, levels = c(FALSE, TRUE), 
                                   labels = c("Low Baseline", "High Baseline"))
  )

cox_interaction_baseline <- coxph(
  Surv(mfs_time_from_landmark, mfs_event_from_landmark) ~ 
    ctdna_cleared_at_landmark * baseline_high_factor + 
    therapy_line_factor + therapy_class_factor + 
    kps_factor + visceral_mets_factor,
  data = landmark_outcomes %>% 
    filter(!is.na(ctdna_cleared_at_landmark), !is.na(baseline_high),
           !is.na(kps_binary), !is.na(visceral_mets_binary))
)

# ANALYSIS 4: Combined model (baseline + on-treatment)
cox_combined_baseline_on_tx <- coxph(
  Surv(mfs_time_from_landmark, mfs_event_from_landmark) ~ 
    log_baseline_ctdna + 
    ctdna_cleared_at_landmark + 
    therapy_line_factor + therapy_class_factor + 
    kps_factor + visceral_mets_factor,
  data = landmark_outcomes %>% 
    filter(!is.na(log_baseline_ctdna), !is.na(ctdna_cleared_at_landmark),
           !is.na(kps_binary), !is.na(visceral_mets_binary))
)

# ANALYSIS 5: Treatment-specific ctDNA response
cox_treatment_interaction <- coxph(
  Surv(mfs_time_from_landmark, mfs_event_from_landmark) ~ 
    ctdna_cleared_at_landmark * therapy_class_factor + 
    therapy_line_factor + kps_factor + visceral_mets_factor,
  data = landmark_outcomes %>% 
    filter(!is.na(ctdna_cleared_at_landmark), !is.na(kps_binary), 
           !is.na(visceral_mets_binary))
)

# ANALYSIS 6: Population comparison (baseline vs on-treatment)
baseline_vs_landmark_comparison <- function(outcomes, landmark_outcomes) {
  baseline_summary <- outcomes %>%
    summarise(
      Analysis = "Baseline ctDNA",
      N = n(),
      N_patients = n_distinct(patient_id),
      Median_baseline_ctdna = median(ctdna_before_line_value, na.rm = TRUE),
      IQR_lower = quantile(ctdna_before_line_value, 0.25, na.rm = TRUE),
      IQR_upper = quantile(ctdna_before_line_value, 0.75, na.rm = TRUE),
      Events = sum(mfs_event, na.rm = TRUE),
      Median_survival_days = median(mfs_time, na.rm = TRUE),
      .groups = "drop"
    )
  
  landmark_summary <- landmark_outcomes %>%
    summarise(
      Analysis = "On-treatment ctDNA",
      N = n(),
      N_patients = n_distinct(patient_id),
      Median_baseline_ctdna = median(baseline_ctdna, na.rm = TRUE),
      IQR_lower = quantile(baseline_ctdna, 0.25, na.rm = TRUE),
      IQR_upper = quantile(baseline_ctdna, 0.75, na.rm = TRUE),
      Events = sum(mfs_event_from_landmark, na.rm = TRUE),
      Median_survival_days = median(mfs_time_from_landmark, na.rm = TRUE),
      .groups = "drop"
    )
  
  comparison_table <- bind_rows(baseline_summary, landmark_summary) %>%
    mutate(
      Baseline_ctdna_IQR = paste0(round(Median_baseline_ctdna, 2), 
                                   " (", round(IQR_lower, 2), "-", 
                                   round(IQR_upper, 2), ")")
    ) %>%
    select(Analysis, N, N_patients, Baseline_ctdna_IQR, Events, Median_survival_days)
  
  return(comparison_table)
}

# ANALYSIS 7: Create comprehensive results table
create_comprehensive_landmark_results <- function(cox_cleared, cox_continuous_on_tx, 
                                                   cox_pct_decline, cox_combined) {
  results_list <- list()
  
  # Binary clearance (existing)
  if (!is.null(cox_cleared)) {
    cox_cleared_summary <- summary(cox_cleared)
    results_list[[length(results_list) + 1]] <- tibble(
      Model = "Binary: Cleared vs Not Cleared",
      Variable = "ctDNA Cleared at Landmark",
      HR = round(cox_cleared_summary$conf.int[1, "exp(coef)"], 2),
      CI_lower = round(cox_cleared_summary$conf.int[1, "lower .95"], 2),
      CI_upper = round(cox_cleared_summary$conf.int[1, "upper .95"], 2),
      P_value = ifelse(cox_cleared_summary$coefficients[1, "Pr(>|z|)"] < 0.001, 
                       "<0.001", 
                       round(cox_cleared_summary$coefficients[1, "Pr(>|z|)"], 3)),
      N = cox_cleared$n
    )
  }
  
  # Continuous on-treatment ctDNA
  if (!is.null(cox_continuous_on_tx)) {
    cox_cont_summary <- summary(cox_continuous_on_tx)
    results_list[[length(results_list) + 1]] <- tibble(
      Model = "Continuous: Log(On-treatment ctDNA + 1)",
      Variable = "Per log-unit increase in on-treatment ctDNA",
      HR = round(cox_cont_summary$conf.int[1, "exp(coef)"], 2),
      CI_lower = round(cox_cont_summary$conf.int[1, "lower .95"], 2),
      CI_upper = round(cox_cont_summary$conf.int[1, "upper .95"], 2),
      P_value = ifelse(cox_cont_summary$coefficients[1, "Pr(>|z|)"] < 0.001, 
                       "<0.001", 
                       round(cox_cont_summary$coefficients[1, "Pr(>|z|)"], 3)),
      N = cox_continuous_on_tx$n
    )
  }
  
  # Percent decline
  if (!is.null(cox_pct_decline)) {
    cox_pct_summary <- summary(cox_pct_decline)
    results_list[[length(results_list) + 1]] <- tibble(
      Model = "Continuous: Percent Decline from Baseline",
      Variable = "Per 10% increase in decline",
      HR = round(exp(cox_pct_summary$coefficients[1, "coef"] * 10), 2),  # Per 10% unit
      CI_lower = round(exp((cox_pct_summary$coefficients[1, "coef"] - 
                           1.96 * cox_pct_summary$coefficients[1, "se(coef)"]) * 10), 2),
      CI_upper = round(exp((cox_pct_summary$coefficients[1, "coef"] + 
                           1.96 * cox_pct_summary$coefficients[1, "se(coef)"]) * 10), 2),
      P_value = ifelse(cox_pct_summary$coefficients[1, "Pr(>|z|)"] < 0.001, 
                       "<0.001", 
                       round(cox_pct_summary$coefficients[1, "Pr(>|z|)"], 3)),
      N = cox_pct_decline$n
    )
  }
  
  # Combined model
  if (!is.null(cox_combined)) {
    cox_comb_summary <- summary(cox_combined)
    # Baseline ctDNA
    results_list[[length(results_list) + 1]] <- tibble(
      Model = "Combined: Baseline + On-treatment",
      Variable = "Baseline ctDNA (per log-unit)",
      HR = round(cox_comb_summary$conf.int[1, "exp(coef)"], 2),
      CI_lower = round(cox_comb_summary$conf.int[1, "lower .95"], 2),
      CI_upper = round(cox_comb_summary$conf.int[1, "upper .95"], 2),
      P_value = ifelse(cox_comb_summary$coefficients[1, "Pr(>|z|)"] < 0.001, 
                       "<0.001", 
                       round(cox_comb_summary$coefficients[1, "Pr(>|z|)"], 3)),
      N = cox_combined$n
    )
    # On-treatment clearance
    results_list[[length(results_list) + 1]] <- tibble(
      Model = "Combined: Baseline + On-treatment",
      Variable = "On-treatment ctDNA Cleared",
      HR = round(cox_comb_summary$conf.int[2, "exp(coef)"], 2),
      CI_lower = round(cox_comb_summary$conf.int[2, "lower .95"], 2),
      CI_upper = round(cox_comb_summary$conf.int[2, "upper .95"], 2),
      P_value = ifelse(cox_comb_summary$coefficients[2, "Pr(>|z|)"] < 0.001, 
                       "<0.001", 
                       round(cox_comb_summary$coefficients[2, "Pr(>|z|)"], 3)),
      N = cox_combined$n
    )
  }
  
  comprehensive_results <- bind_rows(results_list) %>%
    mutate(
      `HR (95% CI)` = paste0(HR, " (", CI_lower, "-", CI_upper, ")")
    ) %>%
    select(Model, Variable, `HR (95% CI)`, `P-value` = P_value, N)
  
  return(comprehensive_results)
}

# ====================================================================================
# USAGE INSTRUCTIONS
# ====================================================================================
# 
# 1. Replace the landmark_analysis_early_response chunk with the optimized version
# 2. Add the continuous analyses after landmark_outcomes is created
# 3. Create comprehensive results table combining binary and continuous models
# 4. Add population comparison table to show differences between baseline and 
#    on-treatment cohorts
#
# This will provide:
# - Faster code execution
# - More comprehensive analysis (binary + continuous)
# - Better understanding of ctDNA as a response biomarker
# ====================================================================================

