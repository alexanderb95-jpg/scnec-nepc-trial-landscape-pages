# Add this code chunk to Question1_Baseline_ctDNA_Prognosis.Rmd after the existing therapy class table
# This will create a table showing actual therapy combinations (mono vs combo)

```{r therapy_combination_distribution, echo=FALSE, results='asis'}
# Create table showing actual therapy combinations (not expanded)
if (exists("palliative_regimen_table_filtered") && nrow(palliative_regimen_table_filtered) > 0) {
  
  # Get unique patients count
  total_unique_patients <- n_distinct(palliative_regimen_table_filtered$patient_id)
  
  # Create combination distribution (actual therapy_class values, not expanded)
  combination_dist <- palliative_regimen_table_filtered %>%
    group_by(therapy_class) %>%
    summarise(
      n_patients = n_distinct(patient_id),
      n_lines = n(),
      .groups = "drop"
    ) %>%
    mutate(
      `N Patients (%)` = paste0(n_patients, " (", round(n_patients / total_unique_patients * 100, 1), "%)"),
      `Type` = ifelse(str_detect(therapy_class, "\\+"), "Combination", "Monotherapy")
    ) %>%
    arrange(desc(n_patients)) %>%
    select(`Therapy Class/Combination` = therapy_class, Type, `N Patients` = n_patients, `N Patients (%)`, `N Lines` = n_lines)
  
  cat("\n## Therapy Combination Distribution\n\n")
  cat("**Distribution of patients by therapy class/combination (N = ", total_unique_patients, " unique patients):**\n\n", sep="")
  
  combination_dist %>%
    kable(caption = paste0("Therapy Class/Combination Distribution (N = ", total_unique_patients, " unique patients). Combinations are shown as received (e.g., 'ADC + ICI'), while monotherapies are shown as single classes (e.g., 'ADC', 'ICI', 'Chemo').")) %>%
    kable_styling(bootstrap_options = c("striped", "hover"), full_width = TRUE)
  
  # Summary by type
  type_summary <- combination_dist %>%
    group_by(Type) %>%
    summarise(
      `N Combinations` = n(),
      `Total Patients` = sum(`N Patients`),
      `Total Lines` = sum(`N Lines`),
      .groups = "drop"
    )
  
  cat("\n**Summary by Therapy Type:**\n\n")
  type_summary %>%
    kable() %>%
    kable_styling(bootstrap_options = c("striped", "hover"), full_width = FALSE)
  
} else {
  cat("Therapy combination distribution not available.\n")
}
```






