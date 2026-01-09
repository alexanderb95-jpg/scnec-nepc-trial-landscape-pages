#!/usr/bin/env Rscript
# Extract therapy combination distribution from Question 1 analysis

library(dplyr)
library(tidyr)
library(stringr)
library(readxl)
library(janitor)

# Load shared setup
source("ctDNA_Research_Questions_Shared_Setup.R")

# Load data
data_list <- load_minimal_data(include_survival = TRUE)
dat_combined <- data_list$dat_combined

# Get therapy regimen columns
regimen_cols <- names(dat_combined)[str_detect(names(dat_combined), regex("systemic.*therapy.*\\d+.*regimen|treatment.*regimen", ignore_case = TRUE))]
if (length(regimen_cols) == 0) {
  regimen_cols <- names(dat_combined)[str_detect(names(dat_combined), regex("^systemic_therapy_\\d+$", ignore_case = TRUE))]
}

# Get therapy setting columns
therapy_setting_cols <- names(dat_combined)[str_detect(names(dat_combined), regex("systemic.*therapy.*\\d+.*treatment.*setting", ignore_case = TRUE))]
therapy_start_cols <- names(dat_combined)[str_detect(names(dat_combined), regex("systemic.*therapy.*\\d+.*start.*date", ignore_case = TRUE))]

# Get palliative therapy lines (simplified - full code is more complex)
if (length(regimen_cols) > 0 && length(therapy_setting_cols) > 0) {
  # Get therapy with settings
  therapy_with_settings <- dat_combined %>%
    select(patient_id, any_of(c(therapy_start_cols, therapy_setting_cols, regimen_cols))) %>%
    pivot_longer(-patient_id, names_to = "var", values_to = "value") %>%
    mutate(
      therapy_num = str_extract(var, "\\d+"),
      var_type = case_when(
        str_detect(var, "regimen") ~ "regimen",
        str_detect(var, "setting") ~ "setting",
        str_detect(var, "start.*date") ~ "start_date",
        TRUE ~ "other"
      )
    ) %>%
    filter(!is.na(value), value != "", value != "NA") %>%
    pivot_wider(id_cols = c(patient_id, therapy_num), names_from = var_type, values_from = value) %>%
    mutate(
      setting_lower = tolower(as.character(setting)),
      is_palliative = str_detect(setting_lower, "palliative|metastatic|1l.*metastatic|2l.*metastatic")
    ) %>%
    filter(is_palliative == TRUE, !is.na(regimen)) %>%
    select(patient_id, therapy_num, regimen)
  
  if (nrow(therapy_with_settings) > 0) {
    # Classify regimens into therapy classes (simplified version)
    therapy_classified <- therapy_with_settings %>%
      mutate(
        regimen_lower = tolower(as.character(regimen)),
        is_adc = str_detect(regimen_lower, regex("enfortumab|disitimab|sacituzumab|trastuzumab.*deruxtecan|dato|bt8009|adc", ignore_case = TRUE)),
        is_ici = str_detect(regimen_lower, regex("pembro|pembrolizumab|nivolumab|nivo\\b|atezo|atezolizumab|durva|durvalumab|relatlimab|avelumab|pd-1|pd1|pd-l1|pdl1", ignore_case = TRUE)),
        is_chemo = str_detect(regimen_lower, regex("gem\\b|gemcitabine|cis\\b|cisplatin|carbo|carboplatin|oxaliplatin|taxol|docetaxel|cabazitaxel|folfox|folfiri|mvac", ignore_case = TRUE)),
        is_targeted = str_detect(regimen_lower, regex("erdafitinib|olaparib|loxo|fgfr|fx909", ignore_case = TRUE)),
        is_other = str_detect(regimen_lower, regex("vaccine|peptide|intravesical.*bcg|bcg.*intravesical", ignore_case = TRUE)),
        class_vec = list(c(
          if (is_adc) "ADC",
          if (is_ici) "ICI",
          if (is_chemo) "Chemo",
          if (is_targeted) "Targeted",
          if (is_other) "Other"
        )),
        therapy_class = {
          cv <- class_vec[[1]]
          if (length(cv) == 0) {
            "unspecified"
          } else if (length(cv) == 1) {
            cv[1]  # Monotherapy
          } else {
            paste(cv, collapse = " + ")  # Combination
          }
        }
      ) %>%
      ungroup()
    
    # Get unique patients from Question 1 universe (N=38)
    # For now, use all patients in therapy_classified
    unique_patients <- n_distinct(therapy_classified$patient_id)
    
    # Create combination distribution table
    combination_dist <- therapy_classified %>%
      group_by(therapy_class) %>%
      summarise(
        n_patients = n_distinct(patient_id),
        n_lines = n(),
        .groups = "drop"
      ) %>%
      mutate(
        `N Patients (%)` = paste0(n_patients, " (", round(n_patients / unique_patients * 100, 1), "%)"),
        `Type` = ifelse(str_detect(therapy_class, "\\+"), "Combination", "Monotherapy")
      ) %>%
      arrange(desc(n_patients)) %>%
      select(`Therapy Class/Combination` = therapy_class, Type, `N Patients` = n_patients, `N Patients (%)`, `N Lines` = n_lines)
    
    cat("\n=== Therapy Combination Distribution (Question 1 Universe) ===\n\n")
    cat("Total unique patients:", unique_patients, "\n\n")
    print(combination_dist)
    cat("\n")
    
    # Summary by type
    type_summary <- combination_dist %>%
      group_by(Type) %>%
      summarise(
        n_combinations = n(),
        total_patients = sum(`N Patients`),
        total_lines = sum(`N Lines`),
        .groups = "drop"
      )
    
    cat("=== Summary by Therapy Type ===\n\n")
    print(type_summary)
    
  } else {
    cat("No palliative therapy data found.\n")
  }
} else {
  cat("Therapy regimen columns not found in dataset.\n")
}






