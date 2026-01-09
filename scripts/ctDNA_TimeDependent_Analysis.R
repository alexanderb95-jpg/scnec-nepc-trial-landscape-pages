# ==============================
# Time-Dependent Cox Models and Landmark Analysis
# Addressing PI Comments on Time-Dependent Variables and Guarantee Time Bias
# ==============================

# This script should be run AFTER ctDNA_Descriptive.Rmd has created:
# - ctdna_long (long format ctDNA data)
# - survival_outcomes (survival data with time_anchor, os_time, death_event, etc.)
# - baseline_ctdna (baseline ctDNA values and dates) - will be created if missing

# Load required libraries
library(survival)
library(dplyr)
library(tidyr)
library(lubridate)

# ==============================
# Check and Create Required Objects
# ==============================

# Check if required objects exist
if (!exists("ctdna_long") || is.null(ctdna_long) || nrow(ctdna_long) == 0) {
  stop("Error: ctdna_long not found. Please run ctDNA_Descriptive.Rmd first.")
}

if (!exists("survival_outcomes") || is.null(survival_outcomes) || nrow(survival_outcomes) == 0) {
  stop("Error: survival_outcomes not found. Please run ctDNA_Descriptive.Rmd first.")
}

# Create baseline_ctdna if it doesn't exist
if (!exists("baseline_ctdna") || is.null(baseline_ctdna) || nrow(baseline_ctdna) == 0) {
  cat("Note: baseline_ctdna not found. Creating from ctdna_long...\n")
  baseline_ctdna <- ctdna_long %>%
    group_by(patient_id) %>%
    arrange(ctdna_date) %>%
    slice_head(n = 1) %>%
    ungroup() %>%
    select(patient_id, baseline_date = ctdna_date, baseline_value = ctdna_value)
  cat("Created baseline_ctdna with", nrow(baseline_ctdna), "patients\n")
}

# Verify baseline_ctdna has required columns
if (!"baseline_value" %in% names(baseline_ctdna)) {
  stop("Error: baseline_ctdna must have 'baseline_value' column")
}
if (!"patient_id" %in% names(baseline_ctdna)) {
  stop("Error: baseline_ctdna must have 'patient_id' column")
}

# Verify survival_outcomes has required columns
required_surv_cols <- c("patient_id", "os_time", "death_event")
missing_surv_cols <- setdiff(required_surv_cols, names(survival_outcomes))
if (length(missing_surv_cols) > 0) {
  stop(paste("Error: survival_outcomes missing required columns:", paste(missing_surv_cols, collapse = ", ")))
}

# ==============================
# Solution 1: Baseline-Only Analysis (Simplest, No Guarantee Time Bias)
# ==============================

# Join baseline ctDNA data
baseline_survival <- survival_outcomes %>%
  left_join(
    baseline_ctdna %>% select(patient_id, baseline_value), 
    by = "patient_id"
  ) %>%
  mutate(
    baseline_ctdna_status = case_when(
      is.na(baseline_value) ~ "No ctDNA Data",
      baseline_value == 0 ~ "Baseline Negative",
      baseline_value > 0 ~ "Baseline Positive",
      TRUE ~ "No ctDNA Data"
    )
  ) %>%
  filter(!is.na(os_time), os_time > 0, !is.na(death_event))

# Fit baseline-only Cox model
baseline_survival_clean <- baseline_survival %>% 
  filter(baseline_ctdna_status != "No ctDNA Data")

if (nrow(baseline_survival_clean) > 0 && 
    length(unique(baseline_survival_clean$baseline_ctdna_status)) > 1 &&
    sum(baseline_survival_clean$death_event == 1, na.rm = TRUE) > 0) {
  baseline_cox <- coxph(
    Surv(os_time, death_event) ~ baseline_ctdna_status,
    data = baseline_survival_clean
  )
  cat("\n=== Baseline-Only Cox Model ===\n")
  print(summary(baseline_cox))
} else {
  cat("\nWarning: Insufficient data for baseline Cox model\n")
  baseline_cox <- NULL
}

# ==============================
# Solution 2: Time-Dependent Cox Model
# ==============================

# Create time-dependent dataset
# Each row represents a time interval where ctDNA status is constant

create_timedep_data <- function(ctdna_long, survival_outcomes, baseline_ctdna) {
  # Start with survival outcomes
  surv_base <- survival_outcomes %>%
    select(patient_id, time_anchor, os_time, death_event) %>%
    filter(!is.na(os_time), os_time > 0, !is.na(death_event))
  
  # Get all ctDNA measurements with time from anchor
  ctdna_timed <- ctdna_long %>%
    left_join(surv_base %>% select(patient_id, time_anchor), by = "patient_id") %>%
    filter(!is.na(time_anchor)) %>%
    mutate(
      months_from_anchor = as.numeric(ctdna_date - time_anchor) / 30.44,
      ctdna_status = case_when(
        ctdna_value == 0 ~ "Negative",
        ctdna_value > 0 ~ "Positive",
        TRUE ~ "Unknown"
      )
    ) %>%
    filter(!is.na(ctdna_status), months_from_anchor >= 0) %>%
    arrange(patient_id, months_from_anchor)
  
  # Create time intervals for each patient
  timedep_list <- list()
  
  for (pid in unique(ctdna_timed$patient_id)) {
    patient_ctdna <- ctdna_timed %>% filter(patient_id == pid)
    patient_surv <- surv_base %>% filter(patient_id == pid)
    
    if (nrow(patient_ctdna) == 0) next
    
    # Start with baseline status (or first measurement)
    intervals <- tibble(
      patient_id = pid,
      tstart = 0,
      tstop = first(patient_ctdna$months_from_anchor),
      ctdna_status = if (exists("baseline_ctdna")) {
        baseline_val <- baseline_ctdna %>% filter(patient_id == pid) %>% pull(baseline_value)
        if (length(baseline_val) > 0 && !is.na(baseline_val)) {
          if (baseline_val == 0) "Negative" else "Positive"
        } else {
          first(patient_ctdna$ctdna_status)
        }
      } else {
        first(patient_ctdna$ctdna_status)
      }
    )
    
    # Add intervals between measurements
    if (nrow(patient_ctdna) > 1) {
      for (i in 1:(nrow(patient_ctdna) - 1)) {
        intervals <- bind_rows(
          intervals,
          tibble(
            patient_id = pid,
            tstart = patient_ctdna$months_from_anchor[i],
            tstop = patient_ctdna$months_from_anchor[i + 1],
            ctdna_status = patient_ctdna$ctdna_status[i]
          )
        )
      }
    }
    
    # Add final interval from last measurement to end of follow-up
    last_measurement_time <- max(patient_ctdna$months_from_anchor)
    final_status <- last(patient_ctdna$ctdna_status)
    
    intervals <- bind_rows(
      intervals,
      tibble(
        patient_id = pid,
        tstart = last_measurement_time,
        tstop = patient_surv$os_time,
        ctdna_status = final_status
      )
    )
    
    # Add event indicator to final interval
    intervals$event <- c(rep(0, nrow(intervals) - 1), patient_surv$death_event)
    
    timedep_list[[pid]] <- intervals
  }
  
  timedep_data <- bind_rows(timedep_list)
  
  return(timedep_data)
}

# Create time-dependent dataset
timedep_data <- tryCatch({
  create_timedep_data(ctdna_long, survival_outcomes, baseline_ctdna)
}, error = function(e) {
  cat("Warning: Could not create time-dependent data:", e$message, "\n")
  return(NULL)
})

# Fit time-dependent Cox model
if (!is.null(timedep_data) && nrow(timedep_data) > 0) {
  timedep_data_clean <- timedep_data %>% filter(ctdna_status != "Unknown")
  if (nrow(timedep_data_clean) > 0 && 
      length(unique(timedep_data_clean$ctdna_status)) > 1 &&
      sum(timedep_data_clean$event == 1, na.rm = TRUE) > 0) {
    timedep_cox <- coxph(
      Surv(tstart, tstop, event) ~ ctdna_status,
      data = timedep_data_clean
    )
    cat("\n=== Time-Dependent Cox Model ===\n")
    print(summary(timedep_cox))
  } else {
    cat("\nWarning: Insufficient data for time-dependent Cox model\n")
    timedep_cox <- NULL
  }
} else {
  cat("\nWarning: Time-dependent data not available\n")
  timedep_cox <- NULL
}

# ==============================
# Solution 3: Landmark Analysis
# ==============================

perform_landmark_analysis <- function(landmark_months, ctdna_long, survival_outcomes, baseline_ctdna) {
  # Get patients alive at landmark time
  patients_at_landmark <- survival_outcomes %>%
    filter(!is.na(os_time), os_time > landmark_months) %>%
    select(patient_id, time_anchor, os_time, death_event)
  
  # Classify ctDNA status at landmark based on measurements up to landmark
  ctdna_at_landmark <- ctdna_long %>%
    left_join(patients_at_landmark %>% select(patient_id, time_anchor), by = "patient_id") %>%
    filter(!is.na(time_anchor)) %>%
    mutate(
      months_from_anchor = as.numeric(ctdna_date - time_anchor) / 30.44
    ) %>%
    filter(months_from_anchor >= 0, months_from_anchor <= landmark_months) %>%
    arrange(patient_id, months_from_anchor) %>%
    group_by(patient_id) %>%
    summarise(
      # Use last measurement before/at landmark
      last_value = last(ctdna_value),
      last_status = case_when(
        last_value == 0 ~ "Negative",
        last_value > 0 ~ "Positive",
        TRUE ~ "Unknown"
      ),
      # Or use pattern: ever positive before landmark
      ever_positive = any(ctdna_value > 0, na.rm = TRUE),
      pattern_status = case_when(
        ever_positive ~ "Ever Positive",
        !ever_positive & !is.na(last_value) ~ "Always Negative",
        TRUE ~ "Unknown"
      ),
      .groups = "drop"
    )
  
  # Create survival dataset from landmark time
  landmark_survival <- patients_at_landmark %>%
    left_join(ctdna_at_landmark, by = "patient_id") %>%
    mutate(
      # Survival time from landmark
      os_time_from_landmark = os_time - landmark_months,
      # Status at landmark
      ctdna_status_landmark = last_status
    ) %>%
    filter(!is.na(ctdna_status_landmark), ctdna_status_landmark != "Unknown")
  
  # Fit Cox model from landmark time
  landmark_cox <- coxph(
    Surv(os_time_from_landmark, death_event) ~ ctdna_status_landmark,
    data = landmark_survival
  )
  
  return(list(
    landmark_months = landmark_months,
    n_patients = nrow(landmark_survival),
    cox_model = landmark_cox,
    data = landmark_survival
  ))
}

# Perform landmark analyses at 3, 6, and 12 months
landmark_3mo <- tryCatch({
  perform_landmark_analysis(3, ctdna_long, survival_outcomes, baseline_ctdna)
}, error = function(e) {
  cat("Warning: Could not perform 3-month landmark analysis:", e$message, "\n")
  return(list(landmark_months = 3, n_patients = 0, cox_model = NULL, data = NULL))
})

landmark_6mo <- tryCatch({
  perform_landmark_analysis(6, ctdna_long, survival_outcomes, baseline_ctdna)
}, error = function(e) {
  cat("Warning: Could not perform 6-month landmark analysis:", e$message, "\n")
  return(list(landmark_months = 6, n_patients = 0, cox_model = NULL, data = NULL))
})

landmark_12mo <- tryCatch({
  perform_landmark_analysis(12, ctdna_long, survival_outcomes, baseline_ctdna)
}, error = function(e) {
  cat("Warning: Could not perform 12-month landmark analysis:", e$message, "\n")
  return(list(landmark_months = 12, n_patients = 0, cox_model = NULL, data = NULL))
})

# Summarize landmark results
cat("\n=== Landmark Analysis Results ===\n")
if (!is.null(landmark_3mo$cox_model)) {
  cat("3-month landmark: N =", landmark_3mo$n_patients, "\n")
  print(summary(landmark_3mo$cox_model))
} else {
  cat("3-month landmark: Insufficient data\n")
}

if (!is.null(landmark_6mo$cox_model)) {
  cat("\n6-month landmark: N =", landmark_6mo$n_patients, "\n")
  print(summary(landmark_6mo$cox_model))
} else {
  cat("\n6-month landmark: Insufficient data\n")
}

if (!is.null(landmark_12mo$cox_model)) {
  cat("\n12-month landmark: N =", landmark_12mo$n_patients, "\n")
  print(summary(landmark_12mo$cox_model))
} else {
  cat("\n12-month landmark: Insufficient data\n")
}

# ==============================
# Solution 4: Left-Truncation with Time-Dependent Covariates
# ==============================

# Use tmerge() for proper left-truncation
# This ensures patients are only at risk from their first ctDNA measurement

create_lefttrunc_timedep <- function(ctdna_long, survival_outcomes, baseline_ctdna) {
  # Base survival data - handle case where time_anchor might not exist
  if ("time_anchor" %in% names(survival_outcomes)) {
    surv_base <- survival_outcomes %>%
      select(patient_id, time_anchor, os_time, death_event) %>%
      filter(!is.na(os_time), os_time > 0, !is.na(death_event))
    
    # Get first ctDNA measurement time for each patient
    first_ctdna_times <- ctdna_long %>%
      left_join(surv_base %>% select(patient_id, time_anchor), by = "patient_id") %>%
      filter(!is.na(time_anchor)) %>%
      mutate(months_from_anchor = as.numeric(ctdna_date - time_anchor) / 30.44) %>%
      filter(months_from_anchor >= 0) %>%
      group_by(patient_id) %>%
      summarise(
        first_ctdna_time = min(months_from_anchor, na.rm = TRUE),
        first_ctdna_status = case_when(
          ctdna_value[which.min(months_from_anchor)] == 0 ~ "Negative",
          ctdna_value[which.min(months_from_anchor)] > 0 ~ "Positive",
          TRUE ~ "Unknown"
        ),
        .groups = "drop"
      )
  } else {
    # If no time_anchor, use first ctDNA date as anchor
    surv_base <- survival_outcomes %>%
      select(patient_id, os_time, death_event) %>%
      filter(!is.na(os_time), os_time > 0, !is.na(death_event))
    
    first_ctdna_times <- ctdna_long %>%
      group_by(patient_id) %>%
      arrange(ctdna_date) %>%
      slice_head(n = 1) %>%
      ungroup() %>%
      mutate(
        first_ctdna_time = 0,  # Use first measurement as time 0
        first_ctdna_status = case_when(
          ctdna_value == 0 ~ "Negative",
          ctdna_value > 0 ~ "Positive",
          TRUE ~ "Unknown"
        )
      ) %>%
      select(patient_id, first_ctdna_time, first_ctdna_status)
  }
  
  # Merge with survival data
  surv_with_entry <- surv_base %>%
    left_join(first_ctdna_times, by = "patient_id") %>%
    filter(!is.na(first_ctdna_time)) %>%
    mutate(
      # Entry time is first ctDNA measurement
      entry_time = first_ctdna_time,
      # Exit time is os_time
      exit_time = os_time
    )
  
  # Create time-dependent status changes
  if ("time_anchor" %in% names(survival_outcomes)) {
    ctdna_changes <- ctdna_long %>%
      left_join(surv_base %>% select(patient_id, time_anchor), by = "patient_id") %>%
      filter(!is.na(time_anchor)) %>%
      mutate(
        months_from_anchor = as.numeric(ctdna_date - time_anchor) / 30.44,
        ctdna_status = case_when(
          ctdna_value == 0 ~ "Negative",
          ctdna_value > 0 ~ "Positive",
          TRUE ~ "Unknown"
        )
      ) %>%
      filter(months_from_anchor >= 0, ctdna_status != "Unknown") %>%
      arrange(patient_id, months_from_anchor) %>%
      select(patient_id, time = months_from_anchor, ctdna_status)
  } else {
    # If no time_anchor, calculate time from first measurement
    first_dates <- ctdna_long %>%
      group_by(patient_id) %>%
      summarise(first_date = min(ctdna_date, na.rm = TRUE), .groups = "drop")
    
    ctdna_changes <- ctdna_long %>%
      left_join(first_dates, by = "patient_id") %>%
      mutate(
        months_from_anchor = as.numeric(ctdna_date - first_date) / 30.44,
        ctdna_status = case_when(
          ctdna_value == 0 ~ "Negative",
          ctdna_value > 0 ~ "Positive",
          TRUE ~ "Unknown"
        )
      ) %>%
      filter(months_from_anchor >= 0, ctdna_status != "Unknown") %>%
      arrange(patient_id, months_from_anchor) %>%
      select(patient_id, time = months_from_anchor, ctdna_status)
  }
  
  # Use tmerge to create time-dependent dataset
  tdata <- tmerge(
    data1 = surv_with_entry,
    data2 = surv_with_entry,
    id = patient_id,
    tstart = entry_time,
    tstop = exit_time,
    death = event(exit_time, death_event)
  )
  
  tdata <- tmerge(
    data1 = tdata,
    data2 = ctdna_changes,
    id = patient_id,
    ctdna_status = tdc(time, ctdna_status)
  )
  
  # Set initial status
  tdata <- tdata %>%
    left_join(
      first_ctdna_times %>% select(patient_id, first_ctdna_status),
      by = "patient_id"
    ) %>%
    mutate(
      ctdna_status = ifelse(is.na(ctdna_status), first_ctdna_status, ctdna_status)
    )
  
  return(tdata)
}

# Create left-truncated time-dependent dataset
lefttrunc_tdata <- tryCatch({
  create_lefttrunc_timedep(ctdna_long, survival_outcomes, baseline_ctdna)
}, error = function(e) {
  cat("Warning: Could not create left-truncated time-dependent data:", e$message, "\n")
  return(NULL)
})

# Fit left-truncated time-dependent Cox model
if (!is.null(lefttrunc_tdata) && nrow(lefttrunc_tdata) > 0) {
  lefttrunc_tdata_clean <- lefttrunc_tdata %>% 
    filter(!is.na(ctdna_status), ctdna_status != "Unknown")
  if (nrow(lefttrunc_tdata_clean) > 0 && 
      length(unique(lefttrunc_tdata_clean$ctdna_status)) > 1 &&
      sum(lefttrunc_tdata_clean$death == 1, na.rm = TRUE) > 0) {
    lefttrunc_cox <- coxph(
      Surv(tstart, tstop, death) ~ ctdna_status,
      data = lefttrunc_tdata_clean
    )
    cat("\n=== Left-Truncated Time-Dependent Cox Model ===\n")
    print(summary(lefttrunc_cox))
  } else {
    cat("\nWarning: Insufficient data for left-truncated Cox model\n")
    lefttrunc_cox <- NULL
  }
} else {
  cat("\nWarning: Left-truncated time-dependent data not available\n")
  lefttrunc_cox <- NULL
}

# ==============================
# Comparison Table
# ==============================

# Create comparison of all approaches (with error handling)
safe_extract_hr <- function(cox_model, coef_name) {
  if (is.null(cox_model)) return(NA_real_)
  tryCatch({
    coefs <- coef(cox_model)
    if (coef_name %in% names(coefs)) {
      return(exp(coefs[coef_name]))
    } else {
      return(NA_real_)
    }
  }, error = function(e) NA_real_)
}

safe_extract_pval <- function(cox_model, coef_name) {
  if (is.null(cox_model)) return(NA_real_)
  tryCatch({
    summ <- summary(cox_model)
    if (coef_name %in% rownames(summ$coefficients)) {
      return(summ$coefficients[coef_name, "Pr(>|z|)"])
    } else {
      return(NA_real_)
    }
  }, error = function(e) NA_real_)
}

safe_n_distinct <- function(data, col) {
  if (is.null(data) || nrow(data) == 0) return(0)
  tryCatch({
    if (col %in% names(data)) {
      return(length(unique(data[[col]])))
    } else {
      return(0)
    }
  }, error = function(e) 0)
}

comparison_results <- tibble(
  Approach = c(
    "Baseline-Only (Fixed)",
    "Time-Dependent (Full)",
    "Landmark 3 months",
    "Landmark 6 months",
    "Landmark 12 months",
    "Left-Truncated Time-Dependent"
  ),
  N = c(
    nrow(baseline_survival %>% filter(baseline_ctdna_status != "No ctDNA Data")),
    safe_n_distinct(timedep_data, "patient_id"),
    ifelse(is.null(landmark_3mo), 0, landmark_3mo$n_patients),
    ifelse(is.null(landmark_6mo), 0, landmark_6mo$n_patients),
    ifelse(is.null(landmark_12mo), 0, landmark_12mo$n_patients),
    safe_n_distinct(lefttrunc_tdata, "patient_id")
  ),
  HR_Positive_vs_Negative = c(
    safe_extract_hr(baseline_cox, "baseline_ctdna_statusBaseline Positive"),
    safe_extract_hr(timedep_cox, "ctdna_statusPositive"),
    safe_extract_hr(landmark_3mo$cox_model, "ctdna_status_landmarkPositive"),
    safe_extract_hr(landmark_6mo$cox_model, "ctdna_status_landmarkPositive"),
    safe_extract_hr(landmark_12mo$cox_model, "ctdna_status_landmarkPositive"),
    safe_extract_hr(lefttrunc_cox, "ctdna_statusPositive")
  ),
  P_Value = c(
    safe_extract_pval(baseline_cox, "baseline_ctdna_statusBaseline Positive"),
    safe_extract_pval(timedep_cox, "ctdna_statusPositive"),
    safe_extract_pval(landmark_3mo$cox_model, "ctdna_status_landmarkPositive"),
    safe_extract_pval(landmark_6mo$cox_model, "ctdna_status_landmarkPositive"),
    safe_extract_pval(landmark_12mo$cox_model, "ctdna_status_landmarkPositive"),
    safe_extract_pval(lefttrunc_cox, "ctdna_statusPositive")
  ),
  Addresses_Time_Dependence = c("No", "Yes", "Partial", "Partial", "Partial", "Yes"),
  Addresses_Guarantee_Time_Bias = c("Yes", "No", "Yes", "Yes", "Yes", "Yes")
)

cat("\n=== Comparison of All Approaches ===\n")
print(comparison_results)

# ==============================
# Solution 5: Testing for Non-Informative Censoring
# ==============================

# Critical assumption: Censoring should be non-informative
# If censoring differs by group, it may bias results

test_censoring_patterns <- function(survival_data, group_var, time_var, event_var) {
  # Create censoring indicator (1 = censored, 0 = event)
  censoring_data <- survival_data %>%
    filter(!is.na(.data[[time_var]]), .data[[time_var]] > 0, 
           !is.na(.data[[group_var]]),
           !str_detect(tolower(.data[[group_var]]), "no ctdna data")) %>%
    mutate(
      censored = 1 - .data[[event_var]],  # 1 if censored, 0 if event
      event_occurred = .data[[event_var]]  # 1 if event, 0 if censored
    )
  
  # Test 1: Compare censoring rates across groups
  censoring_rates <- censoring_data %>%
    group_by(.data[[group_var]]) %>%
    summarise(
      n = n(),
      n_events = sum(event_occurred, na.rm = TRUE),
      n_censored = sum(censored, na.rm = TRUE),
      censoring_rate = mean(censored, na.rm = TRUE),
      .groups = "drop"
    )
  
  # Chi-square test for independence of censoring and group
  censoring_table <- table(
    censoring_data[[group_var]],
    censoring_data$censored
  )
  
  chi_sq_test <- chisq.test(censoring_table)
  
  # Test 2: Compare censoring times across groups (for censored patients only)
  censored_only <- censoring_data %>%
    filter(censored == 1)
  
  if (nrow(censored_only) > 0 && length(unique(censored_only[[group_var]])) > 1) {
    # Kruskal-Wallis test for differences in censoring times
    kruskal_test <- kruskal.test(
      as.formula(paste(time_var, "~", group_var)),
      data = censored_only
    )
    
    # Log-rank test for censoring time distribution
    censoring_surv <- survfit(
      as.formula(paste0("Surv(", time_var, ", censored) ~ ", group_var)),
      data = censoring_data
    )
    
    censoring_logrank <- survdiff(
      as.formula(paste0("Surv(", time_var, ", censored) ~ ", group_var)),
      data = censoring_data
    )
  } else {
    kruskal_test <- NULL
    censoring_surv <- NULL
    censoring_logrank <- NULL
  }
  
  # Test 3: Compare event times vs censoring times
  # If censoring is informative, censored patients may have different
  # baseline characteristics or different event risk
  
  return(list(
    censoring_rates = censoring_rates,
    chi_square_test = chi_sq_test,
    kruskal_wallis_test = kruskal_test,
    censoring_survival = censoring_surv,
    censoring_logrank = censoring_logrank,
    censoring_data = censoring_data
  ))
}

# Check if qualitative/quantitative groups exist, if not create simple versions
if (!exists("survival_qualitative") || is.null(survival_qualitative)) {
  cat("Note: survival_qualitative not found. Creating simple version from baseline groups...\n")
  survival_qualitative <- baseline_survival %>%
    mutate(qualitative_group = baseline_ctdna_status)
}

if (!exists("survival_quantitative") || is.null(survival_quantitative)) {
  cat("Note: survival_quantitative not found. Creating simple version from baseline groups...\n")
  survival_quantitative <- baseline_survival %>%
    mutate(quantitative_group = baseline_ctdna_status)
}

# Test censoring patterns for qualitative groups
qual_censoring <- test_censoring_patterns(
  survival_qualitative,
  "qualitative_group",
  "os_time",
  "death_event"
)

# Test censoring patterns for quantitative groups
quant_censoring <- test_censoring_patterns(
  survival_quantitative,
  "quantitative_group",
  "os_time",
  "death_event"
)

# Test censoring patterns for baseline groups
baseline_censoring <- test_censoring_patterns(
  baseline_survival,
  "baseline_ctdna_status",
  "os_time",
  "death_event"
)

# Print results
cat("\n=== CENSORING PATTERN ANALYSIS ===\n")
cat("\n--- Qualitative Groups ---\n")
print(qual_censoring$censoring_rates)
cat("\nChi-square test for independence:\n")
print(qual_censoring$chi_square_test)
if (!is.null(qual_censoring$kruskal_wallis_test)) {
  cat("\nKruskal-Wallis test for censoring times:\n")
  print(qual_censoring$kruskal_wallis_test)
}

cat("\n--- Quantitative Groups ---\n")
print(quant_censoring$censoring_rates)
cat("\nChi-square test for independence:\n")
print(quant_censoring$chi_square_test)
if (!is.null(quant_censoring$kruskal_wallis_test)) {
  cat("\nKruskal-Wallis test for censoring times:\n")
  print(quant_censoring$kruskal_wallis_test)
}

cat("\n--- Baseline Groups ---\n")
print(baseline_censoring$censoring_rates)
cat("\nChi-square test for independence:\n")
print(baseline_censoring$chi_square_test)
if (!is.null(baseline_censoring$kruskal_wallis_test)) {
  cat("\nKruskal-Wallis test for censoring times:\n")
  print(baseline_censoring$kruskal_wallis_test)
}

# ==============================
# Visualize Censoring Patterns
# ==============================

library(ggplot2)
library(survminer)

# Function to create censoring pattern plots
plot_censoring_patterns <- function(censoring_results, group_var_name, title_suffix = "") {
  data <- censoring_results$censoring_data
  
  # Plot 1: Censoring rates by group
  p1 <- data %>%
    group_by(.data[[group_var_name]]) %>%
    summarise(
      censoring_rate = mean(censored, na.rm = TRUE),
      se = sqrt(censoring_rate * (1 - censoring_rate) / n()),
      .groups = "drop"
    ) %>%
    ggplot(aes(x = .data[[group_var_name]], y = censoring_rate, fill = .data[[group_var_name]])) +
    geom_bar(stat = "identity", alpha = 0.7) +
    geom_errorbar(aes(ymin = censoring_rate - 1.96*se, ymax = censoring_rate + 1.96*se),
                  width = 0.2) +
    labs(
      title = paste("Censoring Rates by Group", title_suffix),
      x = "Group",
      y = "Censoring Rate",
      fill = "Group"
    ) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  # Plot 2: Distribution of censoring times (for censored patients)
  p2 <- data %>%
    filter(censored == 1) %>%
    ggplot(aes(x = .data[[group_var_name]], y = os_time, fill = .data[[group_var_name]])) +
    geom_violin(alpha = 0.7) +
    geom_boxplot(width = 0.2, alpha = 0.5) +
    labs(
      title = paste("Distribution of Censoring Times", title_suffix),
      x = "Group",
      y = "Time to Censoring (months)",
      fill = "Group"
    ) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  # Plot 3: Censoring survival curves (time to censoring)
  if (!is.null(censoring_results$censoring_survival)) {
    p3 <- ggsurvplot(
      censoring_results$censoring_survival,
      data = data,
      risk.table = TRUE,
      pval = TRUE,
      title = paste("Time to Censoring by Group", title_suffix),
      xlab = "Time (months)",
      ylab = "Probability of Not Being Censored"
    )
  } else {
    p3 <- NULL
  }
  
  return(list(
    censoring_rates = p1,
    censoring_times = p2,
    censoring_survival = p3
  ))
}

# Create plots
qual_censoring_plots <- plot_censoring_patterns(qual_censoring, "qualitative_group", "(Qualitative)")
quant_censoring_plots <- plot_censoring_patterns(quant_censoring, "quantitative_group", "(Quantitative)")
baseline_censoring_plots <- plot_censoring_patterns(baseline_censoring, "baseline_ctdna_status", "(Baseline)")

# ==============================
# Test for Informative Censoring Using Baseline Characteristics
# ==============================

# If censoring is informative, censored patients may differ in baseline characteristics
# This suggests censoring is related to unmeasured prognostic factors

test_censoring_by_baseline <- function(survival_data, baseline_data = NULL) {
  # Add baseline characteristics if available
  if (!is.null(baseline_data)) {
    test_data <- survival_data %>%
      left_join(baseline_data, by = "patient_id") %>%
      mutate(censored = 1 - death_event)
  } else {
    test_data <- survival_data %>%
      mutate(censored = 1 - death_event)
  }
  
  # Test if baseline characteristics differ between censored and event patients
  # This would suggest informative censoring
  
  results <- list()
  
  # Test age if available
  if ("age" %in% names(test_data)) {
    results$age_test <- t.test(age ~ censored, data = test_data)
  }
  
  # Test baseline ctDNA value if available
  if ("baseline_value" %in% names(test_data)) {
    results$baseline_ctdna_test <- wilcox.test(baseline_value ~ censored, data = test_data)
  }
  
  # Test stage if available
  if ("t2a_or_higher" %in% names(test_data)) {
    results$stage_test <- chisq.test(table(test_data$t2a_or_higher, test_data$censored))
  }
  
  return(results)
}

# Run tests if baseline data available
if (exists("dat_combined")) {
  baseline_chars <- dat_combined %>%
    select(patient_id, matches("age|baseline|stage|t_stage"))
  
  baseline_censoring_tests <- test_censoring_by_baseline(
    baseline_survival,
    baseline_chars
  )
  
  cat("\n=== BASELINE CHARACTERISTICS BY CENSORING STATUS ===\n")
  print(baseline_censoring_tests)
}

# ==============================
# Summary Table of Censoring Patterns
# ==============================

censoring_summary <- bind_rows(
  qual_censoring$censoring_rates %>%
    mutate(Group_Type = "Qualitative", Group = qualitative_group) %>%
    select(Group_Type, Group, n, n_events, n_censored, censoring_rate),
  quant_censoring$censoring_rates %>%
    mutate(Group_Type = "Quantitative", Group = quantitative_group) %>%
    select(Group_Type, Group, n, n_events, n_censored, censoring_rate),
  baseline_censoring$censoring_rates %>%
    mutate(Group_Type = "Baseline", Group = baseline_ctdna_status) %>%
    select(Group_Type, Group, n, n_events, n_censored, censoring_rate)
) %>%
  mutate(
    event_rate = 1 - censoring_rate,
    interpretation = case_when(
      abs(censoring_rate - mean(censoring_rate, na.rm = TRUE)) > 0.15 ~ "Potential informative censoring",
      abs(censoring_rate - mean(censoring_rate, na.rm = TRUE)) > 0.10 ~ "Possible informative censoring",
      TRUE ~ "Non-informative censoring likely"
    )
  )

print(censoring_summary)

# ==============================
# Recommendations
# ==============================

cat("\n=== RECOMMENDATIONS ===\n")
cat("1. PRIMARY ANALYSIS: Use baseline-only analysis to avoid guarantee time bias\n")
cat("2. SENSITIVITY ANALYSIS: Use landmark analysis at 6 months\n")
cat("3. EXPLORATORY: Time-dependent model to capture dynamic changes\n")
cat("4. CENSORING: Test for non-informative censoring (see results above)\n")
cat("5. ACKNOWLEDGE: Limitations of each approach in manuscript\n")

# Check if censoring appears informative
informative_censoring_warning <- FALSE
if (!is.null(qual_censoring$chi_square_test) && qual_censoring$chi_square_test$p.value < 0.05) {
  cat("\n⚠️  WARNING: Censoring may be informative for qualitative groups (p < 0.05)\n")
  informative_censoring_warning <- TRUE
}
if (!is.null(quant_censoring$chi_square_test) && quant_censoring$chi_square_test$p.value < 0.05) {
  cat("⚠️  WARNING: Censoring may be informative for quantitative groups (p < 0.05)\n")
  informative_censoring_warning <- TRUE
}

if (informative_censoring_warning) {
  cat("\nIf censoring is informative, consider:\n")
  cat("  - Competing risks analysis\n")
  cat("  - Sensitivity analysis excluding early censored patients\n")
  cat("  - Acknowledging this limitation in manuscript\n")
}

