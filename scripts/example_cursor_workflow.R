# ============================================================================
# Example: Using Cursor for R Data Analysis
# This file demonstrates how to work with your actual data files
# ============================================================================

# Step 1: Set up your environment (run this first in R console)
# ----------------------------------------------------------------------------

# Set CRAN mirror (you already do this in your Rmd files)
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Load packages (install if needed)
required_packages <- c("dplyr", "tidyr", "readxl", "knitr", "kableExtra")

# Install missing packages (run once)
new_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) {
  cat("Installing:", paste(new_packages, collapse=", "), "\n")
  install.packages(new_packages)
}

# Load packages
suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
  library(readxl)
  library(knitr)
  library(kableExtra)
})

# Step 2: Define your working directory
# ----------------------------------------------------------------------------
# Instead of setwd(), use here() package or absolute paths
# This is more reliable in Cursor

# Option A: Use absolute path (simple, works everywhere)
data_dir <- "~/R"

# Option B: Use here package (better for projects)
# install.packages("here")
# library(here)
# data_dir <- here()

# Step 3: Load your data (example from your files)
# ----------------------------------------------------------------------------

# Example: Loading Excel file (like you do in AK_Clean_12_21.Rmd)
excel_file <- file.path(data_dir, "AK_Clean_Temp.xlsx")

# Check if file exists before loading
if(file.exists(excel_file)) {
  cat("Loading:", excel_file, "\n")
  
  # Read the file (with error handling)
  data <- tryCatch({
    read_excel(excel_file)
  }, error = function(e) {
    cat("Error loading file:", e$message, "\n")
    return(NULL)
  })
  
  if(!is.null(data)) {
    cat("Successfully loaded", nrow(data), "rows and", ncol(data), "columns\n")
    print(head(data))
  }
} else {
  cat("File not found:", excel_file, "\n")
  cat("Available Excel files in", data_dir, ":\n")
  excel_files <- list.files(data_dir, pattern = "\\.xlsx$", full.names = FALSE)
  print(excel_files)
}

# Step 4: Quick data exploration (test before putting in Rmd)
# ----------------------------------------------------------------------------

if(exists("data") && !is.null(data)) {
  # Basic summary
  cat("\n=== Data Summary ===\n")
  cat("Dimensions:", dim(data), "\n")
  cat("Column names:", paste(names(data)[1:min(10, ncol(data))], collapse=", "), "\n")
  
  # Summary statistics
  cat("\n=== Numeric Columns Summary ===\n")
  numeric_cols <- sapply(data, is.numeric)
  if(any(numeric_cols)) {
    summary(data[, numeric_cols, drop = FALSE])
  }
}

# Step 5: Test a specific analysis (before knitting entire Rmd)
# ----------------------------------------------------------------------------

# Example: Test the analysis you want to do
# This is what you'd copy from your Rmd chunk to test individually

if(exists("data") && !is.null(data)) {
  # Example analysis: Select specific columns (like you do in your Rmd)
  selected_columns <- c("Number_Enrolled_In_Trial", "discontinuation_rate_total")
  
  # Check which columns exist
  available_cols <- names(data)
  cols_to_use <- selected_columns[selected_columns %in% available_cols]
  missing_cols <- selected_columns[!selected_columns %in% available_cols]
  
  if(length(missing_cols) > 0) {
    cat("\nWarning: Missing columns:", paste(missing_cols, collapse=", "), "\n")
  }
  
  if(length(cols_to_use) > 0) {
    cat("\n=== Analysis Preview ===\n")
    analysis_data <- data %>% select(all_of(cols_to_use))
    print(head(analysis_data))
  }
}

# Step 6: Source your shared setup file (like in your Question1 file)
# ----------------------------------------------------------------------------

# Example: Source the shared setup
setup_file <- file.path(data_dir, "ctDNA_Research_Questions_Shared_Setup.R")

if(file.exists(setup_file)) {
  cat("\n=== Sourcing shared setup ===\n")
  source(setup_file)
  cat("Shared setup loaded successfully\n")
} else {
  cat("\nShared setup file not found:", setup_file, "\n")
}

# ============================================================================
# How to use this file in Cursor:
# ============================================================================
# 
# Method 1: Run in terminal R console
#   1. Open terminal in Cursor (Cmd+`)
#   2. Type: R
#   3. Type: source("example_cursor_workflow.R")
#
# Method 2: Run line by line
#   1. Open this file in Cursor
#   2. Open terminal (Cmd+`)
#   3. Start R: R
#   4. Copy and paste sections into R console as needed
#
# Method 3: Use Rscript
#   1. Open terminal
#   2. Run: Rscript example_cursor_workflow.R
#
# ============================================================================

cat("\n=== Example workflow complete ===\n")
cat("You can now modify this script for your actual analyses\n")
