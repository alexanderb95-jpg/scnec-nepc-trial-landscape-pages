# Set working directory and file path
setwd("~/R")
file_path <- "Rodrigo_Clean_data.xlsx"

# Load necessary libraries
library(readxl)
library(dplyr)
library(mgcv)
library(caret)
library(ggplot2)

# Load necessary libraries
library(readxl)
library(dplyr)
library(openxlsx)

# Read and clean the data
file_path <- "Rodrigo_Clean_data.xlsx"
Cleaned_Clinical_Trial_Data <- read_excel(file_path, sheet = "Sheet1") %>%
  na.omit() %>%
  mutate(
    treatment_lines = as.factor(treatment_lines),
    tx_group_drug = as.factor(tx_group_drug),
    sponsors = as.factor(sponsors),
    disease_status = factor(disease_status,
                            levels = c("5", "1", "2", "3", "4"),
                            labels = c("Treatment_Naive", "Advanced_Metastatic",
                                       "Progressive_Disease", "Remission", "Residual"))
  ) %>%
  mutate(
    non_compliance = ifelse(
      total_number_enrolled > 0,
      (total_withdrew_noreason + total_withdrew_because_noncompliance + lost_fu) / total_number_enrolled,
      NA
    ),
    death_rate = ifelse(
      total_number_enrolled > 0,
      total_withdrew_because_death / total_number_enrolled,
      NA
    ),
    TRAE_rate = ifelse(
      total_number_withdrew > 0,
      total_withdrew_because_ae / total_number_withdrew,
      NA
    )
  ) %>%
  filter(!is.na(non_compliance), !is.na(death_rate))  # Ensure no missing values

# Define the linear regression function
fit_linear_regression <- function(outcome_column_name, dataset, output_file = NULL) {
  # Verify if the outcome column exists
  if (!(outcome_column_name %in% colnames(dataset))) {
    stop(paste("The outcome column", outcome_column_name, "is not found in the dataset."))
  }
  
  # Select relevant columns dynamically
  regression_data <- dataset %>%
    select(
      all_of(outcome_column_name),
      mitigation_contact,
      mitigation_encouragment,
      mitigation_nursing,
      mitigation_patienteducation,
      mitigation_protocolamend,
      mitigation_supportivecare,
      mitigation_telemedicine,
      mitigation_crossover,
      mitigation_dosingadjustment,
      mitigation_txafterwithdrawl
    ) %>%
    drop_na()  # Remove rows with NA
  
  # Fit the linear regression model
  formula <- as.formula(paste(outcome_column_name, "~ 
                                mitigation_contact + 
                                mitigation_encouragment + 
                                mitigation_nursing + 
                                mitigation_patienteducation + 
                                mitigation_protocolamend + 
                                mitigation_supportivecare + 
                                mitigation_telemedicine + 
                                mitigation_crossover + 
                                mitigation_dosingadjustment + 
                                mitigation_txafterwithdrawl"))
  linear_model <- lm(formula, data = regression_data)
  
  # Summarize the model
  summary_df <- as.data.frame(summary(linear_model)$coefficients)
  summary_df <- cbind(term = rownames(summary_df), summary_df)
  rownames(summary_df) <- NULL  # Reset row names
  summary_df <- summary_df %>% mutate(across(where(is.numeric), round, 3))  # Round numeric columns to 3 decimal places
  
  # Export results to Excel if output_file is provided
  if (!is.null(output_file)) {
    wb <- createWorkbook()
    addWorksheet(wb, "Linear_Regression_Summary")
    writeData(wb, "Linear_Regression_Summary", summary_df)
    saveWorkbook(wb, output_file, overwrite = TRUE)
  }
  
  # Return summary and coefficients
  list(
    summary = summary_df,
    coefficients = data.frame(
      term = names(coef(linear_model)),
      estimate = round(coef(linear_model), 3)  # Round coefficients to 3 decimal places
    )
  )
}

# Run the model with non_compliance as the outcome
output_file <- "Linear_Regression_Summary_Non_Compliance.xlsx"
results_non_compliance <- fit_linear_regression("non_compliance", Cleaned_Clinical_Trial_Data, output_file)

# Print success message and preview summary
cat("Linear regression summary for non-compliance exported to:", output_file, "\n")
print(results_non_compliance$summary)
