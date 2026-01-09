# ==============================
# ctDNA Conversion Analysis - Core Code
# Simplified version for review
# ==============================

# Load libraries
library(dplyr)
library(tidyr)
library(stringr)
library(readxl)
library(janitor)
library(lubridate)

# Parameters
TOTAL_N <- 310
SCREENED_N <- 108

# Helper function for Excel dates
as_date_safe <- function(x) {
  v <- as.character(x)
  num <- suppressWarnings(as.numeric(v))
  out <- rep(as.Date(NA), length(v))
  is_serial <- !is.na(num) & num > 20000 & num < 60000
  out[is_serial] <- as.Date(num[is_serial], origin = "1899-12-30")
  left <- !is_serial
  if (any(left)) {
    parsed <- suppressWarnings(parse_date_time(v[left], orders = c("Y-m-d","m/d/Y","d/m/Y","m/d/y","d/m/y","Ymd"), tz = "UTC"))
    out[left] <- as.Date(parsed)
  }
  bad <- is.na(out) | year(out) < 2000 | year(out) > 2100
  out[bad] <- as.Date(NA)
  out
}

# Load data
dat <- read_excel("Natera_Sheet_cleaned.xlsx", sheet = 1, col_names = TRUE) %>%
  clean_names() %>%
  mutate(patient_id = record_id_linking_key) %>%
  filter(!is.na(patient_id))

# Build ctDNA long table
ctdna_values <- dat %>%
  select(patient_id, matches("^ct_dna_level_\\d+$")) %>%
  pivot_longer(-patient_id, names_to = "tp", values_to = "ctdna_value_raw") %>%
  mutate(
    tp_idx = as.integer(str_extract(tp, "\\d+")),
    ctdna_value = suppressWarnings(as.numeric(gsub("^<\\s*", "", gsub(",", "", as.character(ctdna_value_raw)))))
  )

ctdna_dates <- dat %>%
  select(patient_id, matches("^ct_dna_level_\\d+_date$")) %>%
  pivot_longer(-patient_id, names_to = "tp_date", values_to = "ctdna_date_raw") %>%
  mutate(tp_idx = as.integer(str_extract(tp_date, "\\d+")))

ctdna_long <- ctdna_values %>%
  left_join(ctdna_dates %>% select(patient_id, tp_idx, ctdna_date_raw), by = c("patient_id", "tp_idx")) %>%
  mutate(ctdna_date = as_date_safe(ctdna_date_raw)) %>%
  filter(!is.na(ctdna_date)) %>%
  select(patient_id, ctdna_date, ctdna_value)

# Identify non-metastatic patients at first ctDNA
non_metastatic <- dat %>%
  filter(
    str_detect(tolower(clinical_disease_state_at_time_of_first_ct_dna_nmibc_mibc_advanced_metastatic), "nmibc|mibc") &
    !str_detect(tolower(clinical_disease_state_at_time_of_first_ct_dna_nmibc_mibc_advanced_metastatic), "advanced|metastatic")
  )

cat("Non-metastatic patients at first ctDNA:", nrow(non_metastatic), "\n")

# Analyze ctDNA conversion
conversion_analysis <- ctdna_long %>%
  inner_join(non_metastatic %>% select(patient_id), by = "patient_id") %>%
  arrange(patient_id, ctdna_date) %>%
  group_by(patient_id) %>%
  summarise(
    first_result = case_when(
      first(ctdna_value) > 0 ~ "Positive",
      first(ctdna_value) == 0 ~ "Negative",
      TRUE ~ "Unknown"
    ),
    ever_positive = any(ctdna_value > 0, na.rm = TRUE),
    first_positive_date = min(ctdna_date[ctdna_value > 0], na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    conversion = case_when(
      first_result == "Negative" & ever_positive ~ "Converted",
      first_result == "Positive" ~ "Always Positive", 
      first_result == "Negative" & !ever_positive ~ "Remained Negative",
      TRUE ~ "Unknown"
    )
  )

# Add clinical outcomes
converted_patients <- conversion_analysis %>%
  filter(conversion == "Converted") %>%
  left_join(dat %>% select(
    patient_id,
    metastatic_disease_ever_diagnosed_yes_no,
    alive_yes_no,
    death_date,
    cause_of_death,
    race,
    ethnicity,
    cancer_stage_natera,
    pathology_t_stage,
    pathology_n_stage,
    neoadjuvant_systemic_therapy_yes_no
  ), by = "patient_id") %>%
  mutate(
    metastatic_ever = case_when(
      str_detect(tolower(metastatic_disease_ever_diagnosed_yes_no), "yes") ~ "Yes",
      str_detect(tolower(metastatic_disease_ever_diagnosed_yes_no), "no") ~ "No",
      TRUE ~ "Unknown"
    ),
    alive_status = case_when(
      str_detect(tolower(alive_yes_no), "yes") ~ "Alive",
      str_detect(tolower(alive_yes_no), "no") ~ "Deceased",
      TRUE ~ "Unknown"
    ),
    cancer_death = case_when(
      alive_status == "Alive" ~ "N/A",
      str_detect(tolower(cause_of_death), "cancer|bladder|tumor") ~ "Yes",
      TRUE ~ "Unknown"
    ),
    first_positive_date_formatted = ifelse(is.na(first_positive_date), "Not available", as.character(first_positive_date))
  ) %>%
  select(
    patient_id,
    first_positive_date_formatted,
    metastatic_ever,
    alive_status,
    cancer_death,
    race,
    ethnicity,
    cancer_stage_natera,
    pathology_t_stage,
    pathology_n_stage,
    neoadjuvant_systemic_therapy_yes_no
  )

# Results
cat("\n=== RESULTS ===\n")
cat("Patients with ctDNA conversion (0 → >0):", nrow(converted_patients), "\n")
cat("Expected when complete:", round(nrow(converted_patients) / SCREENED_N * TOTAL_N), "\n\n")

if (nrow(converted_patients) > 0) {
  cat("Converted patients:\n")
  print(converted_patients)
  
  # Export
  write.csv(converted_patients, "ctDNA_conversion_patients.csv", row.names = FALSE)
  cat("\nExported to: ctDNA_conversion_patients.csv\n")
} else {
  cat("No patients with ctDNA conversion found.\n")
}
