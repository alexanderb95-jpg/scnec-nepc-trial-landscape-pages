# ==============================
# Shared Setup Functions for ctDNA Research Questions
# Load this file at the start of each question-specific RMD
# ==============================

# Helper function: Robust date parser
as_date_safe <- function(x) {
  v <- as.character(x)
  num <- suppressWarnings(as.numeric(v))
  out <- rep(as.Date(NA), length(v))
  # Excel serials (roughly 1955–2064)
  is_serial <- !is.na(num) & num > 20000 & num < 60000
  out[is_serial] <- as.Date(num[is_serial], origin = "1899-12-30")
  # Strings
  left <- !is_serial
  if (any(left)) {
    parsed <- suppressWarnings(parse_date_time(v[left], orders = c("Y-m-d","m/d/Y","d/m/Y","m/d/y","d/m/y","Ymd"), tz = "UTC"))
    out[left] <- as.Date(parsed)
  }
  # Clamp to reasonable range
  bad <- is.na(out) | year(out) < 2000 | year(out) > 2100
  out[bad] <- as.Date(NA)
  out
}

# Build long ctDNA data from wide columns (minimal version)
build_ctdna_long_minimal <- function(dat, id_col) {
  ctdna_value_cols <- names(dat)[str_detect(names(dat), regex("^ct_dna_level_\\d+$", ignore_case = TRUE))]
  ctdna_date_cols <- names(dat)[str_detect(names(dat), regex("^ct_dna_level_\\d+_date$", ignore_case = TRUE))]
  
  if (length(ctdna_value_cols) == 0 || length(ctdna_date_cols) == 0) {
    return(tibble(
      !!id_col := character(0),
      ctdna_date = as.Date(character(0)),
      ctdna_value = numeric(0)
    ))
  }
  
  val <- dat %>% select(all_of(id_col), all_of(ctdna_value_cols)) %>%
    pivot_longer(-all_of(id_col), names_to = "tp", values_to = "ctdna_value_raw") %>%
    mutate(ctdna_value = suppressWarnings(as.numeric(gsub("^<\\s*", "", gsub(",", "", as.character(ctdna_value_raw))))) )
  dt  <- dat %>% select(all_of(id_col), all_of(ctdna_date_cols)) %>%
    pivot_longer(-all_of(id_col), names_to = "tp_date", values_to = "ctdna_date_raw")
  out <- val %>%
    mutate(tp_idx = as.integer(str_extract(tp, "\\d+"))) %>%
    left_join(dt %>% mutate(tp_idx = as.integer(str_extract(tp_date, "\\d+"))) %>% select(all_of(id_col), tp_idx, ctdna_date_raw),
              by = c(id_col, "tp_idx")) %>%
    mutate(ctdna_date = as_date_safe(ctdna_date_raw)) %>%
    filter(!is.na(ctdna_date), !is.na(ctdna_value)) %>%
    select(all_of(id_col), ctdna_date, ctdna_value) %>%
    arrange(.data[[id_col]], ctdna_date)
  out
}

# Minimal data loader - only loads what's needed
load_minimal_data <- function(include_survival = FALSE) {
  # Load libraries
  suppressPackageStartupMessages({
    library(dplyr)
    library(tidyr)
    library(stringr)
    library(readxl)
    library(janitor)
    library(lubridate)
  })
  
  # Lower tract dataset
  file_path_lower <- "Natera_Sheet_Master1.xlsx"
  available_sheets_lower <- excel_sheets(file_path_lower)
  sheet_name_lower <- if ("Master_Sheet" %in% available_sheets_lower) {
    "Master_Sheet"
  } else if ("Sheet1" %in% available_sheets_lower) {
    "Sheet1"
  } else {
    available_sheets_lower[1]
  }
  raw_lower <- read_excel(file_path_lower, sheet = sheet_name_lower, col_names = FALSE)
  var_names_lower <- raw_lower[[1]]
  dat_lower <- as.data.frame(t(raw_lower[, -1]), stringsAsFactors = FALSE)
  colnames(dat_lower) <- make.unique(var_names_lower, sep = "_")
  dat_lower <- clean_names(dat_lower)
  
  id_col_lower <- if ("record_id_linking_key" %in% names(dat_lower)) {
    "record_id_linking_key"
  } else {
    id_candidates <- names(dat_lower)[str_detect(names(dat_lower), regex("record.*id|id.*linking|linking.*key", ignore_case = TRUE))]
    if (length(id_candidates) > 0) id_candidates[1] else names(dat_lower)[2]
  }
  
  dat_lower <- dat_lower %>%
    mutate(id_check = as.character(.data[[id_col_lower]])) %>%
    filter(!is.na(id_check), str_trim(id_check) != "", str_trim(id_check) != "NA") %>%
    select(-id_check) %>%
    rename(patient_id = all_of(id_col_lower)) %>%
    mutate(dataset = "Lower Tract")
  
  # NOTE: All patients (including UTUC) are now in Master1 sheet
  # No longer loading from separate UTUC sheet
  
  # Convert date columns
  date_cols_lower <- names(dat_lower)[str_detect(names(dat_lower), regex("date", ignore_case = TRUE))]
  
  dat_lower <- dat_lower %>% mutate(across(all_of(date_cols_lower), as_date_safe))
  
  # Normalize ctDNA column names
  names(dat_lower) <- str_replace_all(names(dat_lower), regex("^ct[_ ]?dna[_ ]?level(\\d+)$", ignore_case = TRUE), "ct_dna_level_\\1")
  
  # Ensure ctDNA numeric columns are numeric
  ctdna_value_cols_lower <- names(dat_lower)[str_detect(names(dat_lower), regex("^ct_dna_level_\\d+$", ignore_case = TRUE))]
  if (length(ctdna_value_cols_lower)) {
    dat_lower[ctdna_value_cols_lower] <- lapply(dat_lower[ctdna_value_cols_lower], function(x) {
      y <- gsub(",", "", as.character(x))
      y <- gsub("^<\\s*", "", y)
      y[y %in% c("", "NA", "N/A", "na", "n/a", "Not detected", "Undetected", "NEGATIVE", "Negative", "neg", "ND")] <- NA
      suppressWarnings(as.numeric(y))
    })
  }
  
  # Use dat_lower as dat_combined (all patients now in Master1)
  dat_combined <- dat_lower
  
  # Build ctDNA long
  ctdna_long <- build_ctdna_long_minimal(dat_combined, "patient_id")
  
  result <- list(
    dat_combined = dat_combined,
    ctdna_long = ctdna_long
  )
  
  if (include_survival) {
    # Minimal survival extraction
    survival_cols <- names(dat_combined)[str_detect(names(dat_combined), regex("death.*date|alive.*yes.*no|last.*follow.*up.*date", ignore_case = TRUE))]
    if (length(survival_cols) > 0) {
      result$survival_data <- dat_combined %>%
        select(patient_id, all_of(survival_cols))
    }
  }
  
  return(result)
}

