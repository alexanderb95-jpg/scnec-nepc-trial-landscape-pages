# ====================================================================================
# Patients Missing Bajorin Risk Factors
# ====================================================================================
# This script identifies patients who were included in the final analysis cohorts
# for Question 1 (Baseline ctDNA Prognosis) and Question 2 (On-Treatment ctDNA Response)
# but did not have Bajorin risk factors (KPS and visceral metastases) available.
# ====================================================================================

# Load required libraries
suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
  library(stringr)
  library(readxl)
  library(lubridate)
})

# Set working directory
setwd("~/R")

# Load shared setup
source("ctDNA_Research_Questions_Shared_Setup.R")

# Load minimal data
data_list <- load_minimal_data(include_survival = TRUE)
dat_combined <- data_list$dat_combined
ctdna_long <- data_list$ctdna_long
survival_data <- data_list$survival_data

# ====================================================================================
# Load Bajorin Risk Factors Data
# ====================================================================================
bajorin_data <- tryCatch({
  bajorin_raw <- read_excel("ctDNA_Bajorin_Lexi.xlsx", sheet = 1, skip = 1)
  
  if (nrow(bajorin_raw) > 0 && ncol(bajorin_raw) >= 7) {
    bajorin_clean <- tibble(
      patient_id_raw = as.character(bajorin_raw[[2]]),
      therapy_line_raw = as.character(bajorin_raw[[4]]),
      kps_raw = as.character(bajorin_raw[[6]]),
      visceral_mets_raw = as.character(bajorin_raw[[7]])
    ) %>%
      filter(!str_detect(tolower(patient_id_raw), "patient|id|screener|mrn|therapy")) %>%
      filter(!is.na(patient_id_raw), patient_id_raw != "", patient_id_raw != "NA") %>%
      mutate(
        patient_id = as.character(patient_id_raw),
        therapy_line = case_when(
          str_detect(toupper(therapy_line_raw), "^1L$") ~ 1,
          str_detect(toupper(therapy_line_raw), "^2L$") ~ 2,
          str_detect(toupper(therapy_line_raw), "^3L$") ~ 3,
          str_detect(toupper(therapy_line_raw), "^4L\\+") ~ 4,
          str_detect(therapy_line_raw, "^\\d+") ~ as.numeric(str_extract(therapy_line_raw, "^\\d+")),
          TRUE ~ NA_real_
        ),
        kps_binary = case_when(
          kps_raw == "1" | kps_raw == 1 ~ 1,
          kps_raw == "0" | kps_raw == 0 ~ 0,
          TRUE ~ NA_real_
        ),
        visceral_mets_binary = case_when(
          str_detect(tolower(visceral_mets_raw), "^yes$|^y$") ~ 1,
          str_detect(tolower(visceral_mets_raw), "^no$|^n$") ~ 0,
          TRUE ~ NA_real_
        )
      ) %>%
      filter(!is.na(patient_id), !is.na(therapy_line), patient_id != "") %>%
      select(patient_id, therapy_line, kps_binary, visceral_mets_binary)
    
    bajorin_clean
  } else {
    tibble(patient_id = character(0), therapy_line = numeric(0), 
           kps_binary = numeric(0), visceral_mets_binary = numeric(0))
  }
}, error = function(e) {
  cat("Warning: Could not load Bajorin data file:", e$message, "\n")
  tibble(patient_id = character(0), therapy_line = numeric(0), 
         kps_binary = numeric(0), visceral_mets_binary = numeric(0))
})

# ====================================================================================
# QUESTION 1: Baseline ctDNA Prognosis Analysis
# ====================================================================================
# Replicate the universe and outcomes definition from Question1_Baseline_ctDNA_Prognosis.Rmd

# Extract therapy start dates and settings
therapy_start_cols <- names(dat_combined)[str_detect(names(dat_combined), regex("systemic.*therapy.*\\d+.*start.*date", ignore_case = TRUE))]
therapy_setting_cols <- names(dat_combined)[str_detect(names(dat_combined), regex("systemic.*therapy.*\\d+.*treatment.*setting", ignore_case = TRUE))]

# Get all palliative therapy lines
all_palliative_therapy_lines <- tibble(patient_id = character(0), therapy_line = integer(0), therapy_start_date = as.Date(character(0)))

if (length(therapy_start_cols) > 0 && length(therapy_setting_cols) > 0) {
  therapy_dates_with_lines <- dat_combined %>%
    select(patient_id, any_of(therapy_start_cols)) %>%
    pivot_longer(-patient_id, names_to = "therapy_var", values_to = "start_date_raw") %>%
    mutate(
      start_date = as_date_safe(start_date_raw),
      therapy_line = as.integer(str_extract(therapy_var, "\\d+"))
    ) %>%
    filter(!is.na(start_date), !is.na(therapy_line)) %>%
    select(patient_id, therapy_line, therapy_start_date = start_date)
  
  therapy_settings_with_lines <- dat_combined %>%
    select(patient_id, any_of(therapy_setting_cols)) %>%
    pivot_longer(-patient_id, names_to = "setting_var", values_to = "setting_raw") %>%
    mutate(
      setting = as.character(setting_raw),
      therapy_line = as.integer(str_extract(setting_var, "\\d+"))
    ) %>%
    filter(!is.na(therapy_line)) %>%
    select(patient_id, therapy_line, setting)
  
  all_palliative_therapy_lines <- therapy_dates_with_lines %>%
    left_join(therapy_settings_with_lines, by = c("patient_id", "therapy_line")) %>%
    mutate(
      setting_lower = tolower(setting),
      is_palliative = str_detect(setting_lower, "palliative|metastatic|1l.*metastatic|2l.*metastatic|3l.*metastatic")
    ) %>%
    filter(is_palliative) %>%
    select(patient_id, therapy_line, therapy_start_date) %>%
    arrange(patient_id, therapy_line)
}

# Identify patients with confirmed metastatic disease
clinical_state_cols <- names(dat_combined)[str_detect(names(dat_combined), regex("clinical_disease_state.*metastatic|clinical_disease_state.*first.*ct", ignore_case = TRUE))]
metastatic_cols <- names(dat_combined)[str_detect(names(dat_combined), regex("metastatic_disease_ever_diagnosed|metastatic.*yes.*no", ignore_case = TRUE))]
m_stage_cols <- names(dat_combined)[str_detect(names(dat_combined), regex("pathology_m_stage", ignore_case = TRUE))]

first_palliative_therapy <- all_palliative_therapy_lines %>%
  group_by(patient_id) %>%
  summarise(first_palliative_start = min(therapy_start_date, na.rm = TRUE), .groups = "drop")

metastatic_status <- dat_combined %>%
  select(patient_id, 
         any_of(clinical_state_cols),
         any_of(metastatic_cols),
         any_of(m_stage_cols)) %>%
  mutate(
    metastatic_at_ctdna = if (length(clinical_state_cols) > 0) {
      str_detect(tolower(as.character(.data[[clinical_state_cols[1]]])), "metastatic|advanced")
    } else {
      NA
    },
    metastatic_ever_diagnosed = if (length(metastatic_cols) > 0) {
      case_when(
        str_detect(tolower(as.character(.data[[metastatic_cols[1]]])), "yes|y|1") ~ TRUE,
        str_detect(tolower(as.character(.data[[metastatic_cols[1]]])), "no|n|0") ~ FALSE,
        TRUE ~ NA
      )
    } else {
      NA
    },
    m_stage_metastatic = if (length(m_stage_cols) > 0) {
      str_detect(toupper(as.character(.data[[m_stage_cols[1]]])), "M1")
    } else {
      NA
    }
  ) %>%
  left_join(first_palliative_therapy, by = "patient_id") %>%
  mutate(
    has_palliative_therapy = !is.na(first_palliative_start),
    has_metastatic_disease = case_when(
      !is.na(metastatic_at_ctdna) & metastatic_at_ctdna == TRUE ~ TRUE,
      has_palliative_therapy == TRUE ~ TRUE,
      !is.na(m_stage_metastatic) & m_stage_metastatic == TRUE ~ TRUE,
      !is.na(metastatic_ever_diagnosed) & metastatic_ever_diagnosed == TRUE ~ TRUE,
      TRUE ~ NA
    )
  ) %>%
  filter(has_metastatic_disease == TRUE) %>%
  select(patient_id)

# Create universe for Question 1
universe_q1 <- all_palliative_therapy_lines %>%
  inner_join(metastatic_status, by = "patient_id") %>%
  left_join(ctdna_long, by = "patient_id") %>%
  filter(
    !is.na(ctdna_date),
    ctdna_date <= therapy_start_date,
    ctdna_date >= (therapy_start_date - days(21))
  ) %>%
  arrange(patient_id, therapy_line, desc(ctdna_date)) %>%
  group_by(patient_id, therapy_line, therapy_start_date) %>%
  slice_head(n = 1) %>%
  ungroup() %>%
  select(patient_id, therapy_line, therapy_start_date, 
         ctdna_date, ctdna_value) %>%
  rename(
    ctdna_before_line_date = ctdna_date,
    ctdna_before_line_value = ctdna_value
  ) %>%
  mutate(time_zero_date = therapy_start_date)

# Extract outcomes for Question 1 (with survival data filtering)
death_date_cols <- names(dat_combined)[str_detect(names(dat_combined), regex("^death_date$|death.*date$", ignore_case = TRUE)) & 
                                       !str_detect(names(dat_combined), regex("cause|reason", ignore_case = TRUE))]
survival_cols <- names(dat_combined)[str_detect(names(dat_combined), regex("last.*follow.*up.*date|follow.*up.*date", ignore_case = TRUE)) & 
                                     !str_detect(names(dat_combined), regex("death", ignore_case = TRUE))]
alive_cols <- names(dat_combined)[str_detect(names(dat_combined), regex("^alive_yes_no$|alive.*yes.*no", ignore_case = TRUE))]
imaging_cols <- names(dat_combined)[str_detect(names(dat_combined), regex("obvious.*disease.*imaging|disease.*present.*imaging", ignore_case = TRUE))]

outcomes_q1 <- universe_q1 %>%
  left_join(
    dat_combined %>%
      select(patient_id, all_of(c(death_date_cols, survival_cols, alive_cols, imaging_cols))),
    by = "patient_id"
  ) %>%
  mutate(
    death_date = if (length(death_date_cols) > 0) {
      as_date_safe(.data[[death_date_cols[1]]])
    } else {
      as.Date(NA)
    },
    last_fu_date = if (length(survival_cols) > 0) {
      as_date_safe(.data[[survival_cols[1]]])
    } else {
      as.Date(NA)
    },
    alive_status = if (length(alive_cols) > 0) {
      case_when(
        str_detect(tolower(as.character(.data[[alive_cols[1]]])), "yes|y|1") ~ "Yes",
        str_detect(tolower(as.character(.data[[alive_cols[1]]])), "no|n|0") ~ "No",
        TRUE ~ NA_character_
      )
    } else {
      NA_character_
    },
    imaging_disease_present = if (length(imaging_cols) > 0) {
      case_when(
        str_detect(tolower(as.character(.data[[imaging_cols[1]]])), "yes|y|1") ~ "Yes",
        str_detect(tolower(as.character(.data[[imaging_cols[1]]])), "no|n|0") ~ "No",
        TRUE ~ NA_character_
      )
    } else {
      NA_character_
    },
    event_or_censor_date = case_when(
      !is.na(death_date) ~ death_date,
      !is.na(last_fu_date) ~ last_fu_date,
      TRUE ~ as.Date(NA)
    ),
    mfs_time = as.numeric(event_or_censor_date - time_zero_date),
    mfs_event = case_when(
      !is.na(death_date) ~ 1,
      alive_status == "No" ~ 1,
      alive_status == "Yes" & imaging_disease_present == "Yes" ~ 1,
      alive_status == "Yes" & imaging_disease_present == "No" ~ 0,
      alive_status == "Yes" & is.na(imaging_disease_present) ~ NA_real_,
      TRUE ~ NA_real_
    ),
    imaging_required = case_when(
      !is.na(death_date) ~ FALSE,
      alive_status == "No" ~ FALSE,
      alive_status == "Yes" ~ TRUE,
      TRUE ~ TRUE
    )
  ) %>%
  filter(!is.na(mfs_time), mfs_time > 0, 
         !(imaging_required == TRUE & is.na(imaging_disease_present)))

# Join Bajorin data for Question 1
outcomes_q1_with_bajorin <- outcomes_q1 %>%
  left_join(
    bajorin_data %>% select(patient_id, therapy_line, kps_binary, visceral_mets_binary),
    by = c("patient_id", "therapy_line")
  )

# Identify patients missing Bajorin risk factors in Question 1
missing_bajorin_q1 <- outcomes_q1_with_bajorin %>%
  filter(is.na(kps_binary) | is.na(visceral_mets_binary)) %>%
  mutate(
    missing_kps = is.na(kps_binary),
    missing_visceral_mets = is.na(visceral_mets_binary),
    missing_both = is.na(kps_binary) & is.na(visceral_mets_binary)
  ) %>%
  select(patient_id, therapy_line, missing_kps, missing_visceral_mets, missing_both) %>%
  distinct()

# ====================================================================================
# QUESTION 2: On-Treatment ctDNA Response Analysis
# ====================================================================================
# Replicate the landmark analysis setup from Question2_Landmark_Analysis.Rmd

# Use the same universe as Question 1
universe_q2 <- universe_q1

# Extract outcomes for Question 2 (same as Question 1)
outcomes_q2 <- outcomes_q1

# Landmark analysis: find on-treatment ctDNA within 6-16 weeks
landmark_window_start_days <- 6 * 7
landmark_window_end_days <- 16 * 7

landmark_data_q2 <- outcomes_q2 %>%
  select(patient_id, therapy_line, time_zero_date, ctdna_before_line_date, 
         ctdna_before_line_value, mfs_time, mfs_event) %>%
  left_join(
    ctdna_long %>%
      select(patient_id, ctdna_date, ctdna_value),
    by = "patient_id"
  ) %>%
  mutate(
    days_from_therapy_start = as.numeric(ctdna_date - time_zero_date),
    in_landmark_window = days_from_therapy_start >= landmark_window_start_days & 
                         days_from_therapy_start <= landmark_window_end_days
  ) %>%
  filter(in_landmark_window) %>%
  arrange(patient_id, therapy_line, desc(days_from_therapy_start)) %>%
  group_by(patient_id, therapy_line) %>%
  slice_head(n = 1) %>%
  ungroup() %>%
  mutate(
    baseline_ctdna = ctdna_before_line_value,
    on_tx_ctdna = ctdna_value,
    landmark_time = days_from_therapy_start
  )

# Perform landmark analysis: only include patients who survived to landmark
landmark_outcomes_q2 <- landmark_data_q2 %>%
  left_join(
    outcomes_q2 %>% 
      select(patient_id, therapy_line, mfs_time, mfs_event, time_zero_date, imaging_disease_present),
    by = c("patient_id", "therapy_line", "time_zero_date")
  ) %>%
  left_join(
    dat_combined %>%
      select(patient_id, all_of(c(death_date_cols, alive_cols))),
    by = "patient_id"
  ) %>%
  mutate(
    death_date = if (length(death_date_cols) > 0) {
      as_date_safe(.data[[death_date_cols[1]]])
    } else {
      as.Date(NA)
    },
    alive_status = if (length(alive_cols) > 0) {
      case_when(
        str_detect(tolower(as.character(.data[[alive_cols[1]]])), "yes|y|1") ~ "Yes",
        str_detect(tolower(as.character(.data[[alive_cols[1]]])), "no|n|0") ~ "No",
        TRUE ~ NA_character_
      )
    } else {
      NA_character_
    },
    survived_to_landmark = mfs_time >= landmark_time,
    mfs_time_from_landmark = mfs_time - landmark_time,
    mfs_event_from_landmark = mfs_event,
    imaging_required = case_when(
      !is.na(death_date) ~ FALSE,
      alive_status == "No" ~ FALSE,
      alive_status == "Yes" ~ TRUE,
      TRUE ~ TRUE
    )
  ) %>%
  filter(survived_to_landmark, mfs_time_from_landmark > 0,
         !(imaging_required == TRUE & is.na(imaging_disease_present)))

# Join Bajorin data for Question 2
landmark_outcomes_q2_with_bajorin <- landmark_outcomes_q2 %>%
  left_join(
    bajorin_data %>% select(patient_id, therapy_line, kps_binary, visceral_mets_binary),
    by = c("patient_id", "therapy_line")
  )

# Identify patients missing Bajorin risk factors in Question 2
missing_bajorin_q2 <- landmark_outcomes_q2_with_bajorin %>%
  filter(is.na(kps_binary) | is.na(visceral_mets_binary)) %>%
  mutate(
    missing_kps = is.na(kps_binary),
    missing_visceral_mets = is.na(visceral_mets_binary),
    missing_both = is.na(kps_binary) & is.na(visceral_mets_binary)
  ) %>%
  select(patient_id, therapy_line, missing_kps, missing_visceral_mets, missing_both) %>%
  distinct()

# ====================================================================================
# Create Summary Tables
# ====================================================================================

# Question 1 Summary
cat("=== QUESTION 1: Baseline ctDNA Prognosis Analysis ===\n\n")
cat("Total patient-line observations in final analysis:", nrow(outcomes_q1), "\n")
cat("Unique patients in final analysis:", length(unique(outcomes_q1$patient_id)), "\n\n")

cat("Patients missing Bajorin risk factors:\n")
cat("  - Total patient-line observations missing KPS or visceral mets:", nrow(missing_bajorin_q1), "\n")
cat("  - Unique patients missing KPS or visceral mets:", length(unique(missing_bajorin_q1$patient_id)), "\n")
cat("  - Missing KPS only:", sum(missing_bajorin_q1$missing_kps & !missing_bajorin_q1$missing_visceral_mets), "\n")
cat("  - Missing visceral mets only:", sum(!missing_bajorin_q1$missing_kps & missing_bajorin_q1$missing_visceral_mets), "\n")
cat("  - Missing both:", sum(missing_bajorin_q1$missing_both), "\n\n")

# Question 2 Summary
cat("=== QUESTION 2: On-Treatment ctDNA Response Analysis ===\n\n")
cat("Total patient-line observations in final landmark analysis:", nrow(landmark_outcomes_q2), "\n")
cat("Unique patients in final landmark analysis:", length(unique(landmark_outcomes_q2$patient_id)), "\n\n")

cat("Patients missing Bajorin risk factors:\n")
cat("  - Total patient-line observations missing KPS or visceral mets:", nrow(missing_bajorin_q2), "\n")
cat("  - Unique patients missing KPS or visceral mets:", length(unique(missing_bajorin_q2$patient_id)), "\n")
cat("  - Missing KPS only:", sum(missing_bajorin_q2$missing_kps & !missing_bajorin_q2$missing_visceral_mets), "\n")
cat("  - Missing visceral mets only:", sum(!missing_bajorin_q2$missing_kps & missing_bajorin_q2$missing_visceral_mets), "\n")
cat("  - Missing both:", sum(missing_bajorin_q2$missing_both), "\n\n")

# ====================================================================================
# Export Results
# ====================================================================================

# Create detailed tables
missing_bajorin_q1_detailed <- missing_bajorin_q1 %>%
  arrange(patient_id, therapy_line) %>%
  mutate(
    Analysis = "Question 1: Baseline ctDNA Prognosis",
    `Missing KPS` = ifelse(missing_kps, "Yes", "No"),
    `Missing Visceral Mets` = ifelse(missing_visceral_mets, "Yes", "No"),
    `Missing Both` = ifelse(missing_both, "Yes", "No")
  ) %>%
  select(Analysis, patient_id, therapy_line, `Missing KPS`, `Missing Visceral Mets`, `Missing Both`)

missing_bajorin_q2_detailed <- missing_bajorin_q2 %>%
  arrange(patient_id, therapy_line) %>%
  mutate(
    Analysis = "Question 2: On-Treatment ctDNA Response",
    `Missing KPS` = ifelse(missing_kps, "Yes", "No"),
    `Missing Visceral Mets` = ifelse(missing_visceral_mets, "Yes", "No"),
    `Missing Both` = ifelse(missing_both, "Yes", "No")
  ) %>%
  select(Analysis, patient_id, therapy_line, `Missing KPS`, `Missing Visceral Mets`, `Missing Both`)

# Combine both analyses
missing_bajorin_combined <- bind_rows(missing_bajorin_q1_detailed, missing_bajorin_q2_detailed) %>%
  arrange(Analysis, patient_id, therapy_line)

# Export to CSV
write.csv(missing_bajorin_combined, "Patients_Missing_Bajorin_Risk_Factors.csv", row.names = FALSE)

cat("=== EXPORT ===\n")
cat("Results exported to: Patients_Missing_Bajorin_Risk_Factors.csv\n\n")

# Display summary table
cat("Summary Table:\n")
print(missing_bajorin_combined)

cat("\n=== COMPLETE ===\n")

