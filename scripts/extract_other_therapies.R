library(readxl)
library(dplyr)
library(stringr)
library(tidyr)

# Load the shared setup to get data
source('ctDNA_Research_Questions_Shared_Setup.R')
data_list <- load_minimal_data(include_survival = FALSE)
dat_combined <- data_list$dat_combined

# Get regimen and note columns - columns are named systemic_therapy_1, systemic_therapy_2, etc.
regimen_cols <- names(dat_combined)[str_detect(names(dat_combined), regex("^systemic_therapy_\\d+$", ignore_case = TRUE))]
note_col <- "systemic_therapy_notes"

if (length(regimen_cols) > 0) {
  # Extract regimen data
  regimen_long <- dat_combined %>%
    select(patient_id, any_of(regimen_cols)) %>%
    pivot_longer(-patient_id, names_to = "regimen_var", values_to = "regimen_raw") %>%
    mutate(
      therapy_num = str_extract(regimen_var, "\\d+"),
      regimen_orig = str_squish(as.character(regimen_raw)),
      regimen_clean = tolower(str_squish(as.character(regimen_raw)))
    ) %>%
    filter(!is.na(regimen_orig), regimen_orig != "")
  
  # Extract notes if available - notes are in a single column, need to match by patient
  if (note_col %in% names(dat_combined)) {
    notes_data <- dat_combined %>%
      select(patient_id, all_of(note_col)) %>%
      rename(note_raw = all_of(note_col)) %>%
      mutate(note_clean = str_squish(as.character(note_raw)))
    
    # For now, we'll use the same note for all therapies for a patient
    # (since notes column doesn't specify which therapy line)
    regimen_notes <- regimen_long %>%
      left_join(notes_data %>% select(patient_id, note_clean), by = "patient_id")
  } else {
    regimen_notes <- regimen_long %>%
      mutate(note_clean = NA_character_)
  }
  
  # Process like the main code does
  regimen_processed <- regimen_notes %>%
    mutate(
      flag_other = str_detect(regimen_clean, regex("other.*note", ignore_case = TRUE)),
      flag_see_note = str_detect(regimen_clean, regex("see\\s*note", ignore_case = TRUE)),
      regimen_final = case_when(
        (flag_other | flag_see_note) ~ coalesce(str_squish(note_clean), "unspecified from notes"),
        TRUE ~ regimen_orig
      ),
      lower_final = tolower(regimen_final),
      is_other = str_detect(lower_final, regex("vaccine|peptide|unspecified", ignore_case = TRUE)),
      # Check if it doesn't match any known class
      is_adc = str_detect(lower_final, regex("enfortumab|disitimab|sacituzumab|trastuzumab\\s*deruxtecan|dato|bt8009|adc", ignore_case = TRUE)),
      is_ici = str_detect(lower_final, regex("pembro|pembrolizumab|nivolumab|nivo\\b|atezo|atezolizumab|durva|durvalumab|relatlimab|pd-1|pd1|pd-l1|pdl1", ignore_case = TRUE)),
      is_chemo = str_detect(lower_final, regex("gem\\b|gemcitabine|cis\\b|cisplatin|carbo|carboplatin|oxaliplatin|taxol|docetaxel|cabazitaxel|folfox|folfiri", ignore_case = TRUE)),
      is_targeted = str_detect(lower_final, regex("erdafitinib|olaparib|loxo|fgfr", ignore_case = TRUE)),
      classified_as_other = (is_other | (!is_adc & !is_ici & !is_chemo & !is_targeted)) & !is.na(regimen_final)
    )
  
  # Find therapies classified as Other
  other_therapies <- regimen_processed %>%
    filter(classified_as_other) %>%
    select(patient_id, therapy_num, regimen_orig, note_clean, regimen_final, flag_see_note, flag_other) %>%
    distinct() %>%
    arrange(patient_id, therapy_num)
  
  cat("=== THERAPIES CLASSIFIED AS OTHER ===\n\n")
  if (nrow(other_therapies) > 0) {
    for (i in 1:nrow(other_therapies)) {
      cat("Patient:", other_therapies$patient_id[i], "| Therapy:", other_therapies$therapy_num[i], "\n")
      cat("  Original regimen:", other_therapies$regimen_orig[i], "\n")
      cat("  Note:", ifelse(is.na(other_therapies$note_clean[i]), "(no note)", other_therapies$note_clean[i]), "\n")
      cat("  Final regimen used:", other_therapies$regimen_final[i], "\n")
      cat("\n")
    }
  } else {
    cat("No therapies classified as Other.\n")
  }
  
  cat("\n\n=== THERAPIES WITH \"SEE NOTE\" OR \"OTHER (SEE NOTES)\" ===\n\n")
  see_note_therapies <- regimen_processed %>%
    filter(flag_see_note | flag_other) %>%
    select(patient_id, therapy_num, regimen_orig, note_clean, regimen_final) %>%
    distinct() %>%
    arrange(patient_id, therapy_num)
  
  if (nrow(see_note_therapies) > 0) {
    for (i in 1:nrow(see_note_therapies)) {
      cat("Patient:", see_note_therapies$patient_id[i], "| Therapy:", see_note_therapies$therapy_num[i], "\n")
      cat("  Original regimen:", see_note_therapies$regimen_orig[i], "\n")
      cat("  Note content:", ifelse(is.na(see_note_therapies$note_clean[i]), "(no note found)", see_note_therapies$note_clean[i]), "\n")
      cat("  Final regimen used:", see_note_therapies$regimen_final[i], "\n")
      cat("\n")
    }
  } else {
    cat("No therapies with 'see note'.\n")
  }
  
  # Get unique final regimens that were classified as Other
  other_final_regimens <- regimen_processed %>%
    filter(classified_as_other) %>%
    select(regimen_final) %>%
    distinct() %>%
    arrange(regimen_final)
  
  cat("\n\n=== UNIQUE FINAL REGIMENS CLASSIFIED AS OTHER ===\n\n")
  if (nrow(other_final_regimens) > 0) {
    for (i in 1:nrow(other_final_regimens)) {
      cat(i, ". ", other_final_regimens$regimen_final[i], "\n", sep = "")
    }
  } else {
    cat("None.\n")
  }
  
  # Summary counts
  cat("\n\n=== SUMMARY ===\n")
  cat("Total therapies classified as Other:", nrow(other_therapies), "\n")
  cat("Total unique final regimens classified as Other:", nrow(other_final_regimens), "\n")
  cat("Total therapies with 'see note':", nrow(see_note_therapies), "\n")
  
} else {
  cat("No regimen columns found.\n")
}

