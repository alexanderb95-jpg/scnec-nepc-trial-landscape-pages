setwd("/Users/Alex/R")

# Load Data
# Install the openxlsx package if not already installed
if (!requireNamespace("openxlsx", quietly = TRUE)) {
  install.packages("openxlsx")
}

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



# Create an empty data frame to store results
results_df <- data.frame("Variable" = character(), "p-value" = numeric(), "Test" = character(), "Column" = character(), stringsAsFactors = FALSE)

# List of variables to iterate through
columns <- c("X2013_2015_enrollment", "X2016_2018_enrollment", "X2019_2022_enrollment", "AA_percentage",
             "Breast", "GI", "GU", "Gyn", "HN", "Heme", "Lung", "Skin", "it", "target", "chemo", "ba",
             "other", "IOTT","TTChemo","IOChemo","endo", "therapy_combination", "sponsor_type")

variables <- c('crabs', 'crcl', 'cruln', 'egfr', 'heterogenous', 'n_a_formula')

# Function to check if Fisher's exact test should be used
should_use_fisher <- function(table_data) {
  any(table_data < 5)
}

# Iterate through each variable and column
for (column in columns) {
  for (var in variables) {
    # Check if the column or variable contains missing values
    if (any(is.na(data_alex[[column]]) | is.na(data_alex[[var]]))) {
      cat('Skipping column', column, 'and variable', var, 'due to missing values.\n')
      next  # Skip to the next iteration
    }
    
    # Check if the vectors have the same length
    if (length(data_alex[[column]]) != length(data_alex[[var]])) {
      cat('Skipping column', column, 'and variable', var, 'due to different vector lengths.\n')
      next  # Skip to the next iteration
    }
    
    table_data <- table(data_alex[[column]], data_alex[[var]])
    
    # Check if the contingency table is valid for chi-squared test
    if (any(dim(table_data) < 2) || any(apply(table_data, 1, sum) < 1) || any(apply(table_data, 2, sum) < 1)) {
      cat('Skipping column', column, 'and variable', var, 'due to an invalid contingency table.\n')
      next  # Skip to the next iteration
    }
    
    # Check if Fisher's exact test should be used
    use_fisher <- should_use_fisher(table_data)
    
    # Perform the appropriate test
    if (use_fisher) {
      test_result <- fisher.test(table_data)
      test_type <- "Fisher's Exact Test"
    } else {
      test_result <- chisq.test(table_data)
      test_type <- "Chi-Squared Test"
    }
    
    # Append results to the data frame
    results_df <- rbind(results_df, c(var, test_result$p.value, test_type, column))
    
    cat('Variable:', var, 'P-value:', test_result$p.value, 'Test:', test_type, 'Column:', column, '\n')
    
    if (test_result$p.value < 0.05) {
      cat('The association between', var, 'and', column, 'is statistically significant.\n')
    } else {
      cat('The association between', var, 'and', column, 'is not statistically significant.\n')
    }
  }
}

# Set column names for the data frame
colnames(results_df) <- c("Variable", "p-value", "Test", "Column")

# Create an empty data frame to store t-test results
t_test_results_df <- data.frame("Variable" = character(), "p-value" = numeric(), "Test" = character(), "Column" = character(), stringsAsFactors = FALSE)

# Specify the column for the independent sample t-test
column_to_test <- "AA_percentage"

# List of variables to iterate through
variables <- c('crabs', 'crcl', 'cruln', 'egfr', 'heterogenous', 'n_a_formula')

# Iterate through each variable
for (var in variables) {
  # Exclude missing values from the t-test
  non_na_indices <- complete.cases(data_alex[[column_to_test]], data_alex[[var]])
  t_test_result <- t.test(data_alex[[column_to_test]][non_na_indices] ~ data_alex[[var]][non_na_indices])
  
  # Append results to the data frame
  t_test_results_df <- rbind(t_test_results_df, c(var, t_test_result$p.value, "t-test", column_to_test))
  
  cat('Variable:', var, 'P-value:', t_test_result$p.value, 'Test: t-test', 'Column:', column_to_test, '\n')
  
  if (t_test_result$p.value < 0.05) {
    cat('The difference between', column_to_test, 'and', var, 'is statistically significant.\n')
  } else {
    cat('The difference between', column_to_test, 'and', var, 'is not statistically significant.\n')
  }
}

# Set column names for the data frame
colnames(t_test_results_df) <- c("Variable", "p-value", "Test", "Column")

# Combine the two data frames
combined_df <- rbind(results_df, t_test_results_df)


# Specify the file path where you want to save the Excel file
excel_file_path <- "R/eGFR_results_bivariate.xlsx"

# Install the openxlsx package if not already installed
if (!requireNamespace("openxlsx", quietly = TRUE)) {
  install.packages("openxlsx")
}

# Load the openxlsx package
library(openxlsx)

excel_file_path <- "eGFR_results_bivariate.xlsx"

# Now, write the dataframe to the Excel file
write.xlsx(combined_df, excel_file_path, sheetName = "CombinedResults12", rowNames = FALSE)


# Write the combined dataframe to an Excel file
write.xlsx(combined_df, excel_file_path, sheetName = "CombinedResults12", rowNames = FALSE)


# Write the combined dataframe to an Excel file
write.xlsx(combined_df, excel_file_path, sheetName = "CombinedResults12", rowNames = FALSE)
