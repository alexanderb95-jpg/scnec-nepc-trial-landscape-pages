# ==============================
# Final Corrected Swimmer Plots with Events and Legend
# Author: Alex Karol
# Date: 2025-10-13
# ==============================

# Load required libraries
library(dplyr)
library(tidyr)
library(stringr)
library(readxl)
library(janitor)
library(lubridate)
library(ggplot2)

# ==============================
# Helper Functions
# ==============================

# Robust date parser
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

# ==============================
# Load Data
# ==============================

cat("=== LOADING DATA ===\n")

# Load main data
file_path <- "Natera_Sheet_cleaned.xlsx"
dat <- read_excel(file_path, sheet = 1, col_names = TRUE) %>%
  clean_names() %>%
  mutate(patient_id = record_id_linking_key) %>%
  filter(!is.na(patient_id)) %>%
  mutate(across(everything(), ~ifelse(. == "", NA, .)))

cat("Loaded", nrow(dat), "patients\n")

# ==============================
# Build ctDNA Data
# ==============================

cat("\n=== BUILDING ctDNA DATA ===\n")

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
  filter(!is.na(ctdna_date), !is.na(ctdna_value)) %>%
  select(patient_id, ctdna_date, ctdna_value) %>%
  arrange(patient_id, ctdna_date)

cat("ctDNA records:", nrow(ctdna_long), "\n")

# ==============================
# Build Treatment Events Data
# ==============================

cat("\n=== BUILDING TREATMENT EVENTS DATA ===\n")

# Extract treatment start/end dates and reasons
treatment_events <- data.frame(
  patient_id = character(),
  therapy_number = integer(),
  regimen = character(),
  start_date = as.Date(character()),
  end_date = as.Date(character()),
  reason_for_stopping = character(),
  setting = character(),
  stringsAsFactors = FALSE
)

for (i in 1:10) {
  therapy_col <- paste0("systemic_therapy_", i)
  start_col <- paste0("systemic_therapy_", i, "_start_date")
  end_col <- paste0("systemic_therapy_", i, "_end_date")
  reason_col <- paste0("systemic_therapy_", i, "_reason_for_stopping")
  setting_col <- paste0("systemic_therapy_", i, "_treatment_setting")
  
  if (all(c(therapy_col, start_col, end_col, reason_col) %in% names(dat))) {
    therapy_data <- dat %>%
      select(patient_id, all_of(c(therapy_col, start_col, end_col, reason_col, setting_col))) %>%
      filter(!is.na(!!sym(therapy_col))) %>%
      mutate(
        therapy_number = i,
        regimen = as.character(!!sym(therapy_col)),
        start_date = as_date_safe(!!sym(start_col)),
        end_date = as_date_safe(!!sym(end_col)),
        reason_for_stopping = as.character(!!sym(reason_col)),
        setting = as.character(!!sym(setting_col))
      ) %>%
      select(patient_id, therapy_number, regimen, start_date, end_date, reason_for_stopping, setting)
    
    treatment_events <- bind_rows(treatment_events, therapy_data)
  }
}

cat("Treatment events:", nrow(treatment_events), "\n")

# ==============================
# Build Clinical Events Data
# ==============================

cat("\n=== BUILDING CLINICAL EVENTS DATA ===\n")

# Extract clinical events
clinical_events <- dat %>%
  select(
    patient_id,
    alive_yes_no,
    death_date,
    cause_of_death,
    last_follow_up_date
  ) %>%
  mutate(
    alive_status = case_when(
      str_detect(tolower(alive_yes_no), "yes") ~ "Alive",
      str_detect(tolower(alive_yes_no), "no") ~ "Deceased",
      TRUE ~ "Unknown"
    ),
    death_date_parsed = as_date_safe(death_date),
    last_follow_up_parsed = as_date_safe(last_follow_up_date)
  )

cat("Clinical events loaded for", nrow(clinical_events), "patients\n")

# ==============================
# Create Final Swimmer Plot Function
# ==============================

cat("\n=== CREATING FINAL SWIMMER PLOTS ===\n")

create_final_swimmer_plot <- function(pattern_name, max_patients = 20) {
  
  # Get patients with this pattern
  pattern_patients <- ctdna_long %>%
    group_by(patient_id) %>%
    summarise(
      first_value = first(ctdna_value),
      ever_positive = any(ctdna_value > 0),
      ever_negative = any(ctdna_value == 0),
      .groups = "drop"
    ) %>%
    mutate(
      ctdna_pattern = case_when(
        !ever_positive ~ "Persistent Negative",
        !ever_negative ~ "Persistent Positive", 
        first_value == 0 & ever_positive ~ "Conversion (0→>0)",
        first_value > 0 & ever_negative ~ "Resolution (>0→0)",
        TRUE ~ "Mixed Pattern"
      )
    ) %>%
    filter(ctdna_pattern == pattern_name) %>%
    slice_head(n = max_patients)
  
  if (nrow(pattern_patients) == 0) {
    cat("No patients found for pattern:", pattern_name, "\n")
    return(NULL)
  }
  
  # Get ctDNA data for these patients
  plot_ctdna <- ctdna_long %>%
    filter(patient_id %in% pattern_patients$patient_id) %>%
    group_by(patient_id) %>%
    mutate(
      months_from_start = as.numeric(ctdna_date - min(ctdna_date, na.rm = TRUE)) / 30.44,
      ctdna_status = case_when(
        ctdna_value == 0 ~ "Undetectable",
        ctdna_value > 0 ~ "Detectable",
        TRUE ~ "Unknown"
      )
    ) %>%
    ungroup()
  
  # Get treatment events for these patients
  plot_treatments <- treatment_events %>%
    filter(patient_id %in% pattern_patients$patient_id) %>%
    left_join(plot_ctdna %>% group_by(patient_id) %>% summarise(first_ctdna_date = min(ctdna_date, na.rm = TRUE)), by = "patient_id") %>%
    mutate(
      # Convert treatment dates to months from first ctDNA
      start_months = case_when(
        !is.na(start_date) & !is.na(first_ctdna_date) ~ 
          as.numeric(start_date - first_ctdna_date) / 30.44,
        TRUE ~ NA_real_
      ),
      end_months = case_when(
        !is.na(end_date) & !is.na(first_ctdna_date) ~ 
          as.numeric(end_date - first_ctdna_date) / 30.44,
        TRUE ~ NA_real_
      ),
      # Determine event type
      event_type = case_when(
        str_detect(tolower(reason_for_stopping), "progression|progressive|disease progression") ~ "Disease Progression",
        str_detect(tolower(reason_for_stopping), "complete|response|remission") ~ "Treatment Complete",
        str_detect(tolower(reason_for_stopping), "toxicity|side effect|adverse") ~ "Toxicity",
        str_detect(tolower(reason_for_stopping), "patient choice|refused|declined") ~ "Patient Choice",
        !is.na(reason_for_stopping) ~ "Other",
        TRUE ~ "Treatment Start"
      )
    ) %>%
    filter(!is.na(start_months))
  
  # Get clinical events for these patients
  plot_events <- clinical_events %>%
    filter(patient_id %in% pattern_patients$patient_id) %>%
    left_join(plot_ctdna %>% group_by(patient_id) %>% summarise(first_ctdna_date = min(ctdna_date, na.rm = TRUE)), by = "patient_id") %>%
    mutate(
      # Convert death dates to months from first ctDNA
      death_months = case_when(
        alive_status == "Deceased" & !is.na(death_date_parsed) & !is.na(first_ctdna_date) ~ 
          as.numeric(death_date_parsed - first_ctdna_date) / 30.44,
        TRUE ~ NA_real_
      ),
      # Convert follow-up dates to months from first ctDNA
      follow_up_months = case_when(
        alive_status == "Alive" & !is.na(last_follow_up_parsed) & !is.na(first_ctdna_date) ~ 
          as.numeric(last_follow_up_parsed - first_ctdna_date) / 30.44,
        TRUE ~ NA_real_
      ),
      # Determine event type
      event_type = case_when(
        alive_status == "Deceased" ~ "Death",
        alive_status == "Alive" ~ "Alive",
        TRUE ~ "Unknown"
      )
    )
  
  # Calculate timeline length
  max_months <- max(plot_ctdna$months_from_start, na.rm = TRUE)
  if (is.infinite(max_months) || max_months <= 0) {
    max_months <- 30
  }
  
  # Create the plot
  p <- ggplot() +
    # Patient timeline bars
    geom_segment(data = plot_ctdna %>% group_by(patient_id) %>% slice_head(n = 1),
                 aes(x = 0, xend = max_months, y = patient_id, yend = patient_id), 
                 color = "steelblue", linewidth = 2) +
    # ctDNA status markers
    geom_point(data = plot_ctdna, 
               aes(x = months_from_start, y = patient_id, color = ctdna_status), 
               size = 3, shape = 19) +
    # Treatment events
    geom_point(data = plot_treatments %>% filter(event_type == "Disease Progression"), 
               aes(x = start_months, y = patient_id), 
               color = "orange", size = 4, shape = 17) +
    geom_point(data = plot_treatments %>% filter(event_type != "Disease Progression"), 
               aes(x = start_months, y = patient_id), 
               color = "purple", size = 3, shape = 17) +
    # Death events
    geom_point(data = plot_events %>% filter(alive_status == "Deceased"), 
               aes(x = death_months, y = patient_id), 
               color = "black", size = 4, shape = 4) +
    # Color and shape scales
    scale_color_manual(values = c("Detectable" = "red", "Undetectable" = "green")) +
    # Labels
    labs(
      title = paste("Swimmer Plot:", pattern_name),
      subtitle = paste("n =", nrow(pattern_patients), "patients"),
      x = "Time from First ctDNA Test (months)",
      y = "Record ID",
      color = "ctDNA Status"
    ) +
    # Theme
    theme_minimal() +
    theme(
      axis.text.y = element_text(size = 10),
      axis.text.x = element_text(size = 10),
      plot.title = element_text(size = 14, hjust = 0.5, face = "bold"),
      plot.subtitle = element_text(size = 10, hjust = 0.5),
      legend.position = "right",
      panel.grid.minor = element_blank(),
      panel.grid.major.y = element_blank(),
      panel.grid.major.x = element_line(color = "gray90", linewidth = 0.5)
    ) +
    # X-axis formatting
    scale_x_continuous(breaks = seq(0, ceiling(max_months), 5))
  
  return(p)
}

# ==============================
# Create Plots for Different Patterns
# ==============================

patterns <- c("Conversion (0→>0)", "Resolution (>0→0)", "Persistent Positive", "Persistent Negative")
plots <- list()

for (pattern in patterns) {
  cat("Creating final plot for:", pattern, "\n")
  plots[[pattern]] <- create_final_swimmer_plot(pattern)
}

# ==============================
# Create Combined Plot with Legend
# ==============================

cat("\n=== CREATING COMBINED PLOT WITH LEGEND ===\n")

# Sample patients from each pattern
combined_ctdna <- ctdna_long %>%
  group_by(patient_id) %>%
  summarise(
    first_value = first(ctdna_value),
    ever_positive = any(ctdna_value > 0),
    ever_negative = any(ctdna_value == 0),
    .groups = "drop"
  ) %>%
  mutate(
    ctdna_pattern = case_when(
      !ever_positive ~ "Persistent Negative",
      !ever_negative ~ "Persistent Positive", 
      first_value == 0 & ever_positive ~ "Conversion (0→>0)",
      first_value > 0 & ever_negative ~ "Resolution (>0→0)",
      TRUE ~ "Mixed Pattern"
    )
  ) %>%
  group_by(ctdna_pattern) %>%
  slice_head(n = 5) %>%
  ungroup()

combined_data <- ctdna_long %>%
  filter(patient_id %in% combined_ctdna$patient_id) %>%
  left_join(combined_ctdna %>% select(patient_id, ctdna_pattern), by = "patient_id") %>%
  group_by(patient_id) %>%
  mutate(
    months_from_start = as.numeric(ctdna_date - min(ctdna_date, na.rm = TRUE)) / 30.44,
    ctdna_status = case_when(
      ctdna_value == 0 ~ "Undetectable",
      ctdna_value > 0 ~ "Detectable",
      TRUE ~ "Unknown"
    )
  ) %>%
  ungroup()

max_months_combined <- max(combined_data$months_from_start, na.rm = TRUE)
if (is.infinite(max_months_combined) || max_months_combined <= 0) {
  max_months_combined <- 30
}

combined_plot <- ggplot(combined_data, aes(x = months_from_start, y = patient_id)) +
  geom_segment(aes(x = 0, xend = max_months_combined, y = patient_id, yend = patient_id), 
               color = "steelblue", linewidth = 2) +
  geom_point(aes(color = ctdna_status), size = 3, shape = 19) +
  scale_color_manual(values = c("Detectable" = "red", "Undetectable" = "green")) +
  facet_wrap(~ctdna_pattern, scales = "free_y", ncol = 2) +
  labs(
    title = "ctDNA Status Over Time by Pattern",
    x = "Time from First ctDNA Test (months)",
    y = "Record ID",
    color = "ctDNA Status"
  ) +
  theme_minimal() +
  theme(
    axis.text.y = element_text(size = 8),
    axis.text.x = element_text(size = 8),
    plot.title = element_text(size = 16, hjust = 0.5, face = "bold"),
    legend.position = "bottom",
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    strip.text = element_text(size = 10, face = "bold")
  ) +
  scale_x_continuous(breaks = seq(0, ceiling(max_months_combined), 5))

# ==============================
# Create Summary Plot with Full Legend
# ==============================

cat("\n=== CREATING SUMMARY PLOT WITH FULL LEGEND ===\n")

# Create a summary plot showing all patients (sample)
all_patients_sample <- ctdna_long %>%
  group_by(patient_id) %>%
  slice_head(n = 1) %>%
  ungroup() %>%
  slice_head(n = 30)  # Show 30 patients

summary_data <- ctdna_long %>%
  filter(patient_id %in% all_patients_sample$patient_id) %>%
  group_by(patient_id) %>%
  mutate(
    months_from_start = as.numeric(ctdna_date - min(ctdna_date, na.rm = TRUE)) / 30.44,
    ctdna_status = case_when(
      ctdna_value == 0 ~ "Undetectable",
      ctdna_value > 0 ~ "Detectable",
      TRUE ~ "Unknown"
    )
  ) %>%
  ungroup()

# Get treatment events for summary
summary_treatments <- treatment_events %>%
  filter(patient_id %in% all_patients_sample$patient_id) %>%
  left_join(summary_data %>% group_by(patient_id) %>% summarise(first_ctdna_date = min(ctdna_date, na.rm = TRUE)), by = "patient_id") %>%
  mutate(
    start_months = case_when(
      !is.na(start_date) & !is.na(first_ctdna_date) ~ 
        as.numeric(start_date - first_ctdna_date) / 30.44,
      TRUE ~ NA_real_
    ),
    event_type = case_when(
      str_detect(tolower(reason_for_stopping), "progression|progressive|disease progression") ~ "Disease Progression",
      str_detect(tolower(reason_for_stopping), "complete|response|remission") ~ "Treatment Complete",
      str_detect(tolower(reason_for_stopping), "toxicity|side effect|adverse") ~ "Toxicity",
      str_detect(tolower(reason_for_stopping), "patient choice|refused|declined") ~ "Patient Choice",
      !is.na(reason_for_stopping) ~ "Other",
      TRUE ~ "Treatment Start"
    )
  ) %>%
  filter(!is.na(start_months))

# Get clinical events for summary
summary_events <- clinical_events %>%
  filter(patient_id %in% all_patients_sample$patient_id) %>%
  left_join(summary_data %>% group_by(patient_id) %>% summarise(first_ctdna_date = min(ctdna_date, na.rm = TRUE)), by = "patient_id") %>%
  mutate(
    death_months = case_when(
      alive_status == "Deceased" & !is.na(death_date_parsed) & !is.na(first_ctdna_date) ~ 
        as.numeric(death_date_parsed - first_ctdna_date) / 30.44,
      TRUE ~ NA_real_
    )
  )

max_months_summary <- max(summary_data$months_from_start, na.rm = TRUE)
if (is.infinite(max_months_summary) || max_months_summary <= 0) {
  max_months_summary <- 30
}

summary_plot <- ggplot() +
  geom_segment(data = summary_data %>% group_by(patient_id) %>% slice_head(n = 1),
               aes(x = 0, xend = max_months_summary, y = patient_id, yend = patient_id), 
               color = "steelblue", linewidth = 2) +
  geom_point(data = summary_data, 
             aes(x = months_from_start, y = patient_id, color = ctdna_status), 
             size = 3, shape = 19) +
  geom_point(data = summary_treatments %>% filter(event_type == "Disease Progression"), 
             aes(x = start_months, y = patient_id), 
             color = "orange", size = 4, shape = 17) +
  geom_point(data = summary_treatments %>% filter(event_type != "Disease Progression"), 
             aes(x = start_months, y = patient_id), 
             color = "purple", size = 3, shape = 17) +
  geom_point(data = summary_events %>% filter(alive_status == "Deceased"), 
             aes(x = death_months, y = patient_id), 
             color = "black", size = 4, shape = 4) +
  scale_color_manual(values = c("Detectable" = "red", "Undetectable" = "green")) +
  labs(
    title = "ctDNA Status Over Time with Clinical Events",
    subtitle = "Blue bars = Patient timelines, Red dots = ctDNA Detectable, Green dots = ctDNA Undetectable",
    x = "Time from First ctDNA Test (months)",
    y = "Record ID",
    color = "ctDNA Status"
  ) +
  theme_minimal() +
  theme(
    axis.text.y = element_text(size = 10),
    axis.text.x = element_text(size = 10),
    plot.title = element_text(size = 14, hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(size = 10, hjust = 0.5),
    legend.position = "right",
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.grid.major.x = element_line(color = "gray90", linewidth = 0.5)
  ) +
  scale_x_continuous(breaks = seq(0, ceiling(max_months_summary), 5))

# ==============================
# Save Plots
# ==============================

cat("\n=== SAVING FINAL PLOTS ===\n")

# Save individual plots
for (pattern in names(plots)) {
  if (!is.null(plots[[pattern]])) {
    filename <- paste0("final_swimmer_", gsub("[^A-Za-z0-9]", "_", pattern), ".png")
    ggsave(filename, plots[[pattern]], width = 12, height = 8, dpi = 300)
    cat("Saved:", filename, "\n")
  }
}

# Save combined plot
ggsave("final_swimmer_combined.png", combined_plot, width = 16, height = 12, dpi = 300)
cat("Saved: final_swimmer_combined.png\n")

# Save summary plot
ggsave("final_swimmer_summary.png", summary_plot, width = 14, height = 10, dpi = 300)
cat("Saved: final_swimmer_summary.png\n")

cat("\n=== FINAL SWIMMER PLOTS COMPLETED ===\n")
cat("Analysis completed:", Sys.time(), "\n")
