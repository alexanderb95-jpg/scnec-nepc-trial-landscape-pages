


# Load Data
library(readxl)
data_alex <- read_excel("SPSS_GFR_Clean_RPedits_1_31.xlsx", 
                        col_types = c("text", "numeric", "numeric", 
                                      "text", "numeric", "numeric", "numeric", 
                                      "numeric", "numeric", "numeric", 
                                      "text", "text", "numeric", "text", 
                                      "numeric", "numeric", "numeric", 
                                      "numeric", "numeric", "numeric", 
                                      "numeric", "numeric", "text", "numeric", 
                                      "numeric", "numeric", "numeric", "numeric","numeric","numeric", 
                                      "numeric", "numeric", "text", "text", 
                                      "text", "numeric", "numeric", "numeric", 
                                      "numeric", "numeric", "numeric", 
                                      "text", "numeric", "numeric", "numeric", 
                                      "numeric", "numeric"))


# Subset data with relevant columns
subset_data <- data_alex[c("crcl", "X2019_2022_enrollment", "TTChemo","chemo", "GI", "Heme", "Lung", "therapy_combination")]

# Drop rows with missing values
subset_data <- na.omit(subset_data)

# Fit the full logistic regression model
model_full <- glm(crcl ~ X2019_2022_enrollment + GI + Heme + Lung + therapy_combination + TTChemo + chemo,
                  data = subset_data, family = binomial)

# Perform backward variable selection
model_backward <- step(model_full, direction = "backward")

# Summarize the final model
summary(model_backward)


# Subset data with relevant columns
subset_data_cruln <- data_alex[c("cruln", "X2013_2015_enrollment", "X2016_2018_enrollment", "Breast","GI")]

# Drop rows with missing values
subset_data_cruln <- na.omit(subset_data_cruln)

# Fit the full logistic regression model
model_full_cruln <- glm(cruln ~ X2013_2015_enrollment + X2016_2018_enrollment + Breast + GI,
                        data = subset_data_cruln, family = binomial)

# Perform backward variable selection
model_backward_cruln <- step(model_full_cruln, direction = "backward")

# Summarize the final model
summary(model_backward_cruln)

# Subset data with relevant columns
subset_data <- data_alex[c("heterogenous", "target", "TTChemo", "X2016_2018_enrollment", "Breast", "Heme", "Lung", "Skin", "it", "therapy_combination")]

# Drop rows with missing values
subset_data <- na.omit(subset_data)

# Fit the logistic regression model with backward selection
model_heterogenous <- glm(heterogenous ~ X2016_2018_enrollment + Breast + Heme + Lung + Skin + it + therapy_combination + TTChemo + target,
                           data = subset_data, family = binomial)

# Perform backward variable selection
model_heterogenous_backward <- step(model_heterogenous, direction = "backward")

# Summarize the final model
summary(model_heterogenous_backward)

# Subset data with relevant columns
subset_data <- data_alex[c("n_a_formula", "X2016_2018_enrollment", "X2013_2015_enrollment", "therapy_combination")]

# Drop rows with missing values
subset_data <- na.omit(subset_data)

# Fit the logistic regression model with backward selection
model_n_a_formula <- glm(n_a_formula ~ X2016_2018_enrollment + X2013_2015_enrollment + therapy_combination,
                         data = subset_data, family = binomial)

# Perform backward variable selection
model_n_a_formula_backward <- step(model_n_a_formula, direction = "backward")

# Summarize the final model
summary(model_n_a_formula_backward)



# Store the model summaries in objects
info_crcl <- summary(model_backward)
info_cruln <- summary(model_backward_cruln)
info_heterogenous <- summary(model_heterogenous_backward)
info_n_a_formula <- summary(model_n_a_formula_backward)

# Install the openxlsx package if not already installed
if (!requireNamespace("openxlsx", quietly = TRUE)) {
  install.packages("openxlsx")
}

# Load the openxlsx package
library(openxlsx)

# Create a new Excel workbook
wb <- createWorkbook()

# Function to write model summary to Excel with variable names
write_model_summary <- function(wb, sheet_name, info, variable_names) {
  addWorksheet(wb, sheet_name)
  
  # Write variable names
  writeData(wb, sheet_name, c("Variable", variable_names), startCol = 1)
  
  # Write coefficients
  writeData(wb, sheet_name, info$coefficients, startCol = 2)
  
  # Write deviance
  writeData(wb, sheet_name, c("Deviance", info$deviance), startCol = 1, startRow = nrow(info$coefficients) + 3)
  
  # Write AIC
  writeData(wb, sheet_name, c("AIC", info$aic), startCol = 1, startRow = nrow(info$coefficients) + 5)
}

# Get variable names from your data
variable_names_crcl <- c("Intercept", "X2019_2022_enrollment", "GI", "Heme", "therapy_combination")
variable_names_cruln <- c("Intercept", "X2013_2015_enrollment", "Breast")
variable_names_heterogenous <- c("Intercept", "X2016_2018_enrollment", "Breast", "Heme", "Lung", "Skin", "it", "therapy_combination")
variable_names_n_a_formula <- c("Intercept", "X2016_2018_enrollment")

# Write each model summary to Excel
write_model_summary(wb, "crcl_summary", info_crcl, variable_names_crcl)
write_model_summary(wb, "cruln_summary", info_cruln, variable_names_cruln)
write_model_summary(wb, "heterogenous_summary", info_heterogenous, variable_names_heterogenous)
write_model_summary(wb, "n_a_formula_summary", info_n_a_formula, variable_names_n_a_formula)




# Save the Excel workbook
saveWorkbook(wb, "eGFR_results_regression3.xlsx")
